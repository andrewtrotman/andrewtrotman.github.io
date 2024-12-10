;
;	PROTEUS
;	-------
;	BIOS on the PROTEUS
;	This appears to be version 2 because a version 3 OS disk is incompatible with it.
;	That said, the BIOS appears to do very little except for read the real time clock
;	and provide a monitor!
;
;	Dissassembly by Andrew Trotman (andrew@cs.otago.ac.nz)
;
;CC register:
;BIT HEX  F  Description
; 8   80  E  1 = push all on interrupt. 0 = push PC and CC on interrupt
; 7   40  F  1 = ignore FIRQ
; 6   20  H  Half Carry
; 5   10  I  1 = ignore IRQ
; 4   08  N  Negative (bit 7 is set)
; 3   04  Z  Zero
; 2   02  V  arithmetic overflow
; 1   01  C  Carry / Borrow
;
;Addresses
; DFBF - bottom of stack
; DFC0 - Reserved Interrupt vector
; DFC2 - SWI3 vector
; DFC4 - SWI2 vector
; DFC6 - FIRQ Vector
; DFC8 - IRQ vector
; DFCA - SWI vecor
; DFCC - NMI vector
; DFCE - Reset vector
; 
; DFD0 - DFDF : for 0-F stores !0-F if the memory page exists
; DFDE = F1
;
; DFE0 - Address of current serial port (E004)
; 
; DFE2 - Echo flag (00 = no echo)
;
;
; This is a table used for storing 5 breakpoints
; DFE3 - <byte8> <address16>
; DFE6 - <byte8> <address16>
; DFE9 - <byte8> <address16>
; DFEC - <byte8> <address16>
; DFEF - <byte8> <address16>
;
; DFF3 - system clock (high byte)
; DFF4 - system clock (middle byte)
; DFF5 - system clock (low byte)
;
; DFF6 - warm boot	: old stack pointer on
; DFF7 - part of address
;
; DFF8 - warm boot	: old PC
; DFF9 - part of address
;
; DFFA - pointer to branch table for extended monitor commands (table format:<byte8> <address16>)
; DFFB - part of address
;
; E004 - E005 : 6850 serial controller
; E014        : Drive register ($00 = side 1 drive 1; $01 = side 1 drive 2; $40 = side 2 drive 1; $41 = side 2 drive 2)
;             : also, a read to E014, drive door opened
; E018 - E01B : WD 1771 floppy drive controller
; E020 - E027 : 6840 timer
; E030 - E036 : 6854 ADLC network controller
; E060        : Enable Z80 (store an address at E060 and when the 6809 comes back it'll load PC with that address)
;
F000 FE F3	; warm boot address
;
F002 00 29  ; ???: this does not appear to be references for anything!		// set it to 22 4D to boot v3 of the OS.
;
F004 4D 4D 53 42 55 47 30 35 20 30 33 30 39 38 32 20 04			; MMSBUG05 030982
;
; I/O port (6850) at $E004 - $E005 		(same as Poly)
;
F015 04 03 ;		master reset
F017 04 11 ;		divide by 16, 8 bits 2 stop bits!
;
; Timer (6840) is at $E020-$E027		(same as Poly)
;
F019 21 00 ;		control register 2 = 00
F01B 20 00 ;		control register 3 = 00
F01D 21 01 ;		control register 2 = 01 (write to control register 1)
F01F 20 40 ;		control register 1 = 40 (timer 1 should interrupt using IRQ)
F021 21 82 ;		control register 2 = 82 (output on pin O, use Enable clock)
F023 22 00 ;		MSB for timer 1
F025 23 63 ;		LSB for timer 1		(0063) Interrupt once a second
F027 24 13 ;		MSB for timer 2
F029 25 9F ;		LSB for timer 2		(139F)
->
Routine:
;
;	INITIALISE THE TIMER AND SERIAL PORTS
;	-------------------------------------
;
F02B      10 8E E0 00    LDY     #$E000 ;			reset relative to E000
F02F 0    30 8C E3       LEAX    $-1D,PC;			start of ordered pair reset table
->
F032      EC 81          LDD     ,X++   ;			get a pair, E0aa=bb on the next lin
F034      E7 A6          STB     A,Y    ;			store in the given register
F036   +  8C F0 2B       CMPX    #$F02B ;			are we at the end of the init list
F039 %    25 F7          BCS     $F032  ;			no, so more to do
F03B 9    39             RTS            ;			DONE			
->
;
;	BOOT FROM DISK
;	--------------
;
F03C      10 CE DF C0    LDS     #$DFC0 ;			reset the stack
F040      8D E9          BSR     $F02B  ;			initialise the hardware (6840 and 6821)
F042      86 E0          LDA     #$E0   ;			hardware page number
F044      1F 8B          TFR     A,DP   ;			DP = E000
F046      1A 10          ORCC    #$10   ;			Ignore IRQ
F048      0D 18          TST     $18    ;(DP$18);	E018	WD1771 Command register
F04A      0F 14          CLR     $14    ;(DP$14);	E014	drive select register
F04C  [   8D 5B          BSR     $F0A9  ;			Pause
->
F04E      0D 18          TST     $18    ;(DP$18);	E018	WD1771 Status register
F050 *    2A 1E          BPL     $F070  ;			if top bit is not set (the motor on bit)
->
F052      BD FD D0       JSR     $FDD0  ;			check if there is data in the serial port input buffer
F055      27 F7          BEQ     $F04E  ;			check the drive again
F057      BD FD C0       JSR     $FDC0  ;			read A from serial port
F05A      84 7F          ANDA    #$7F   ;			convert to ASCII
F05C      81 03          CMPA    #$03   ;			compare to ^C
F05E &    26 EE          BNE     $F04E  ;			check the drive again
F060 O    4F             CLRA           ;			A  = 00
F061      1F 8B          TFR     A,DP   ;			DP = 0000
F063 L    4C             INCA           ;			A = 01
F064   !  B7 E0 21       STA     $E021  ;			write to Timer control register 1
F067      B7 E0 20       STA     $E020  ;			reset all timers (CR01=$01)
F06A      BD FE F3       JSR     $FEF3  ;			warm reset
F06D ~    7E F8 14       JMP     $F814  ;			enter P-BUG
->
F070      86 E0          LDA     #$E0   ;			hardware page number
F072      1F 8B          TFR     A,DP   ;			DF = E000
F074      86 08          LDA     #$08   ;			command $08 (RESTORE)
F076      97 18          STA     $18    ;(DP$18);	E018	WD1771 Command register
F078  /   8D 2F          BSR     $F0A9  ;			Pause
->
F07A      D6 18          LDB     $18    ;(DP$18);	E018	WD1771 Status register
F07C      C5 01          BITB    #$01   ;			BUSY flag
F07E &    26 FA          BNE     $F07A  ;			Pause until BUSY flag goes off
F080      86 01          LDA     #$01   ;			Sector 1
F082      97 1A          STA     $1A    ;(DP$1A);	E01A	WD1771 Sector register
F084  #   8D 23          BSR     $F0A9  ;			Pause
F086      86 8C          LDA     #$8C   ;			command $8C (READ SECTOR)
F088      97 18          STA     $18    ;(DP$18);	E018	WD1771 Command register
F08A      8D 1D          BSR     $F0A9  ;			Pause
F08C      8E C0 00       LDX     #$C000 ;			address to load sector into
F08F      20 04          BRA     $F095  ;
->
F091      96 1B          LDA     $1B    ;(DP$1B);	E01B	Wd1771 DATA register
F093      A7 80          STA     ,X+    ;			store next byte
->
F095      D6 18          LDB     $18    ;(DP$18);	E018	WD1771 Status register
F097      C5 02          BITB    #$02   ;			DRQ
F099 &    26 F6          BNE     $F091  ;			read the next byte and continue
F09B      C5 01          BITB    #$01   ;			BUSY
F09D &    26 F6          BNE     $F095  ;			keep checking status flags
F09F  <   C5 3C          BITB    #$3C   ;			Check for Errors
F0A1 &    26 AB          BNE     $F04E  ;			Retry
F0A3 O    4F             CLRA           ;			A  = 00
F0A4      1F 8B          TFR     A,DP   ;			DP = 00
F0A6 ~    7E C0 00       JMP     $C000  ;			call the code we just loaded from disk (bootstrap to disk track 0 sector 1)
->
Routine:
;
;	PAUSE 04
;	--------
;
F0A9      C6 04          LDB     #$04   ;			Pause duration
->
;
;	PAUSE X
;	-------
;
F0AB Z    5A             DECB           ;			pause for as long as B is
F0AC &    26 FD          BNE     $F0AB  ;			keep going
F0AE 9    39             RTS            ;			DONE
->
;
;	SWI branch table
;	----------------
;	only SWI $18 does anything!!
;
F0AF F1 7F 			; $00
F0B1 F1 7F 			;
F0B3 F1 7F 			;
F0B5 F1 7F 			;
F0B7 F1 7F 			;
F0B9 F1 7F 			;
F0BB F1 7F 			;
F0BD F1 7F			;
F0BF F1 7F 			;
F0C1 F1 7F 			;
F0C3 F1 7F 			;
F0C5 F1 7F 			;
F0C7 F1 7F 			;
F0C9 F1 7F 			;
F0CB F1 7F 			;
F0CD F1 7F			;
F0CF F1 7F 			; $10
F0D1 F1 7F 			;
F0D3 F1 7F 			;
F0D5 F1 7F 			;
F0D7 F1 7F 			;
F0D9 F1 7F 			;
F0DB F1 7F 			;
F0DD F1 7F			;
F0DF F1 2F 		//	; $18 (used by FLEX)
F0E1 F1 7F 			;
F0E3 F1 7F 			;
F0E5 F1 7F 			;
F0E7 F1 7F 			;
F0E9 F1 7F 			;
F0EB F1 7F 			;
F0ED F1 7F			;
F0EF F1 7F 			; $20
F0F1 F1 7F 			;
F0F3 F1 7F 			;
F0F5 F1 7F 			;
F0F7 F1 7F 			;
F0F9 F1 7F 			;
F0FB F1 7F 			;
F0FD F1 7F			;
F0FF F1 7F 			;
F101 F1 7F 			;
F103 F1 7F 			;
F105 F1 7F 			;
F107 F1 7F 			;
F109 F1 7F 			;
F10B F1 7F 			;
F10D F1 7F			;
F10F F1 7F 			; $30
F111 F1 7F 			;
F113 F1 7F 			;
F115 F1 7F 			;
F117 F1 7F 			;
F119 F1 7F 			;
F11B F1 7F 			;
F11D F1 7F			;
F11F F1 7F 			;
F121 F1 7F 			;
F123 F1 7F 			;
F125 F1 7F 			;
F127 F1 7F 			;
F129 F1 7F 			;
F12B F1 7F 			;
F12D F1 7F			; $3F
->
Routine:
;
;	SWI $18
;	-------
;
F12F      8D 05          BSR     $F136  ;			get time as XD
F131  A   ED 41          STD     $01,U  ;			D after RTI
F133  D   AF 44          STX     $04,U  ;			X after RTI
F135 9    39             RTS            ;			DONE
->
Routine:
;
; 	GET TIME
;	--------
;	return in XD the current time measured in 100ths of a second
;
F136   c  CC 00 63       LDD     #$0063 ;			100ths of a second
F139      1A 10          ORCC    #$10   ;			ignore IRQ
F13B      B3 E0 22       SUBD    $E022  ;			timer 1's current value
F13E      F3 DF F4       ADDD    $DFF4  ;			number of 100ths of a second
F141      1F 01          TFR     D,X    ;			X = D
F143      F6 DF F3       LDB     $DFF3  ;			high of triplet
F146      C9 00          ADCB    #$00   ;			add with carry
F148 O    4F             CLRA           ;			A = 0
F149      1E 01          EXG     D,X    ;			swap D and X
F14B      1C EF          ANDCC   #$EF   ;			turn off the push all flag
F14D 9    39             RTS            ;			DONE
->
Routine:
;
;	alternate SWI entry point
;	-------------------------
;	look up the next byte in the lookup table and branch there (only $18 works)
;
F14E  C   1F 43          TFR     S,U    ;			U = S
F150      1C EF          ANDCC   #$EF   ;			turn off the push all flag
F152  J   AE 4A          LDX     $0A,U  ;			get PC
F154      E6 80          LDB     ,X+    ;			load B from next byte (SWI nn)
F156  J   AF 4A          STX     $0A,U  ;			inc over the byte (continue on next instruction)
F158 O    4F             CLRA           ;			A = 0 (about to do a 16 bit shift left)
F159 X    58             ASLB           ;			double B
F15A I    49             ROLA           ;			get carry into A
F15B      10 83 00 80    CMPD    #$0080 ;			check
F15F  $   10 24 00 1C    LBCC    $F17F  ;			branch higher or same (overflowed the table)
F163 0  H 30 8D FF 48    LEAX    $FF48,PC;			SWI branch table
F167      AD 9B          JSR     [D,X]  ;			doubled SWI number to convert into 16 bit address offsets, now call routine
F169 ~ l  7E F1 6C       JMP     $F16C  ;			jump to next line!!!
->
F16C      A6 C4          LDA     ,U     ;			CC
F16E      84 FE          ANDA    #$FE   ;			clear the carry flag
F170      A7 C4          STA     ,U     ;			put it back
->
F172  4   1F 34          TFR     U,S    ;			reset the stack
->
Routine:
;
;	alternate SWI3 and SWI2 entry point
;	-----------------------------------
;	appears to ignore IRQ and then turn off the high bit of where U points
;
F174      1A 10          ORCC    #$10   ;			Ignore IRQ
F176      A6 C4          LDA     ,U     ;			CC
F178      84 EF          ANDA    #$EF   ;			turn high bit off (fast RTI)
F17A      A7 C4          STA     ,U     ;			put it back
F17C ~    7E F1 B5       JMP     $F1B5  ;			DONE
->
F17F      A6 C4          LDA     ,U     ;			load the flags (CC)
F181      8A 01          ORA     #$01   ;			turn the carry on
F183      A7 C4          STA     ,U     ;			put the flags back
F185      20 EB          BRA     $F172  ;			now finish up
->
Routine:
;
;	alternate IRQ
;	-------------
;	This is a timer clocking the time in 3 bytes at DFF3 DFF4 and DFF5
;
F187   !  B6 E0 21       LDA     $E021  ;			read timer status register
F18A *    2A 27          BPL     $F1B3  ;			DONE
F18C _    5F             CLRB           ;			B = 0
->
F18D \    5C             INCB           ;			B = B + 1
F18E F    46             RORA           ;			rotate a
F18F $    24 FC          BCC     $F18D  ;			keep going until a bit is set
F191      8E E0 20       LDX     #$E020 ;			address of timer
F194 :    3A             ABX            ;			which timer (because of the set bit in the status register)
F195      AE 85          LDX     B,X    ;			doubles B
F197      FC DF F4       LDD     $DFF4  ;			bottom 2 bytes of timer
F19A   d  C3 00 64       ADDD    #$0064 ;			add 100 ($64)
F19D      FD DF F4       STD     $DFF4  ;			save it
F1A0 $    24 03          BCC     $F1A5  ;			it didn't overflow so move on
F1A2 |    7C DF F3       INC     $DFF3  ;			inc the high byte
->
F1A5      BE DF F3       LDX     $DFF3  ;			check top 2 bytes
F1A8      8C 83 D6       CMPX    #$83D6 ;			compate it to $83D6 (24 hours * 100 ($64) per second)
F1AB %    25 06          BCS     $F1B3  ;			DONE
F1AD      7F DF F3       CLR     $DFF3  ;			reset timer high byte
F1B0      7F DF F4       CLR     $DFF4  ;			reset timer middle byte
->
F1B3      1A 10          ORCC    #$10   ;			ignore IRQ
->
Routine:
F1B5      3B             RTI            ;			DONE
->
Routine:
;
;	COMPARE MEMORY BLOCKS
;	---------------------
;
F1B6   g  17 0B 67       LBSR    $FD20  ;			read 2 integers, X then Y
F1B9 )?   29 3F          BVS     $F1FA  ;			(branch on overflow)
->
F1BB      A6 80          LDA     ,X+    ;			load A from X
F1BD      A1 A0          CMPA    ,Y+    ;			is it the same as where Y points?
F1BF      27 FA          BEQ     $F1BB  ;			yes, so keep going
F1C1 40   34 30          PSHS    Y,X    ;			push Y and X (where they point differ)
F1C3      17 0B DC       LBSR    $FDA2  ;			print <cr><lf>
F1C6  b   AE 62          LDX     $02,S  ;			load the first address
F1C8 0    30 1F          LEAX    $-01,X ;			subtract 1
F1CA      17 0B 9D       LBSR    $FD6A  ;			print hex word (the address)
F1CD  =   86 3D          LDA     #$3D   ;			'='
F1CF      17 0C 0D       LBSR    $FDDF  ;			write to serial port
F1D2      A6 84          LDA     ,X     ;			get what's there
F1D4      17 0B 9B       LBSR    $FD72  ;			print hex byte (the byte)
F1D7      17 0C 01       LBSR    $FDDB  ;			write 2 spaces to serial port
F1DA      AE E4          LDX     ,S     ;			load the second address
F1DC 0    30 1F          LEAX    $-01,X ;			subtract 1
F1DE      17 0B 89       LBSR    $FD6A  ;			print hex word (the address)
F1E1  =   86 3D          LDA     #$3D   ;			'='
F1E3      17 0B F9       LBSR    $FDDF  ;			write to serial port
F1E6      A6 84          LDA     ,X     ;			get what's there
F1E8      17 0B 87       LBSR    $FD72  ;			print hext work (the byte)
F1EB      8E F1 FB       LDX     #$F1FB ;			Continue message
F1EE      17 0B BD       LBSR    $FDAE  ;			print string
F1F1      17 0B C6       LBSR    $FDBA  ;			get char and echo
F1F4      81 20          CMPA    #$20   ;			compare with <space> the continue char
F1F6 50   35 30          PULS    Y,X    ;			restore X and Y
F1F8      27 C1          BEQ     $F1BB  ;			keep going
->
F1FA 9    39             RTS            ;			DONE
->
F1FB 20 20 43 6F 6E 74 69 6E 75 65 20 28 53 50 41 43 45 3D 59 29 20 3F 20 04 ; Continue (SPACE=Y) ?
->
Routine:
;
;	COMPUTE ADDRESS
;	---------------
; 	compute
;		BEG - (END - NEW)   which is BEG - END + NEW
; 	or
;		BEG + (NEW - END)
;
;	Computed the end address of a block beg-end as if it were located at NEW
;
F213  0   8D 30          BSR     $F245  ;			read 2 integers (BEG and END)
F215 )    29 E3          BVS     $F1FA  ;			DONE on overflow
F217 40   34 30          PSHS    Y,X    ;			push the 2 integers
F219      17 0B C1       LBSR    $FDDD  ;			write space to serial port
F21C      17 0B 0C       LBSR    $FD2B  ;			read integer into X (NEW)
F21F 4    34 16          PSHS    X,D    ;			push X and make space for answer
F221 )A   29 41          BVS     $F264  ;			clean up stack and DONE
F223  f   EC 66          LDD     $06,S  ;			END
F225  b   A3 62          SUBD    $02,S  ;			END - NEW
F227 %    25 14          BCS     $F23D  ;			the params are the wrong way around so do a different calculation
F229      ED E4          STD     ,S     ;			save the difference on stack
F22B  d   EC 64          LDD     $04,S  ;			BEG
F22D      A3 E4          SUBD    ,S     ;			BEG - (END - NEW)
->
F22F      ED E4          STD     ,S     ;			save on top of stack
F231  =   86 3D          LDA     #$3D   ;			'='
F233      17 0B A9       LBSR    $FDDF  ;			write to serial port
F236      AE E4          LDX     ,S     ;			load the result
F238   /  17 0B 2F       LBSR    $FD6A  ;			print hex word
F23B      20 27          BRA     $F264  ;			clean up the stack and DONE
->
F23D  b   EC 62          LDD     $02,S  ;			NEW
F23F  f   A3 66          SUBD    $06,S  ;			NEW - END
F241  d   E3 64          ADDD    $04,S  ;			BEG + (NEW - END)
F243      20 EA          BRA     $F22F  ;			back to what we were doing
->
Routine:
;
;	READ 2 INTEGERS
;	---------------
;
F245      16 0A D8       LBRA    $FD20  ;			read 2 integers, X then Y
->
Routine:
;
;	ALTER S
;	-------
; <current-start><current-end><destination>
;
F248      8D FB          BSR     $F245  ;			read 2 integers (start and end)
F24A )    29 1A          BVS     $F266  ;			overflow, DONE
F24C 40   34 30          PSHS    Y,X    ;			save them
F24E      17 0B 8C       LBSR    $FDDD  ;			write space to serial port
F251      17 0A D7       LBSR    $FD2B  ;			read integer	(destination)
F254 4    34 16          PSHS    X,D    ;			save that too (and make an extra space)
F256 )    29 0C          BVS     $F264  ;			oveflow, clean stack and DONE
F258  d   EC 64          LDD     $04,S  ;			load end address
F25A  f   A3 66          SUBD    $06,S  ;			subtract start address (results in size)
F25C $    24 09          BCC     $F267  ;			BHS - so keep going
->
F25E      8E F2 A5       LDX     #$F2A5 ;			"range error"
->
F261   J  17 0B 4A       LBSR    $FDAE  ;			print string
->
F264 2h   32 68          LEAS    $08,S  ;			clean up stack
->
F266 9    39             RTS            ;			DONE
->
F267  b   E3 62          ADDD    $02,S  ;			add the destination (to give destination-end address)
F269 %    25 F3          BCS     $F25E  ;			print "range error" and DONE
F26B      ED E4          STD     ,S     ;			store on top of stack (destincation-end address)
F26D  b   EC 62          LDD     $02,S  ;			destination address
F26F  f   A3 66          SUBD    $06,S  ;			start address
F271 $    24 16          BCC     $F289  ;			make sure we copy to avoid overlap problems
F273  f   AE 66          LDX     $06,S  ;			start address
F275   b  10 AE 62       LDY     $02,S  ;			destination address
F278 0    30 1F          LEAX    $-01,X ;			X = X - 1
->
F27A 0    30 01          LEAX    $01,X  ;			X = X + 1
F27C      A6 84          LDA     ,X     ;			get A from start
F27E      A7 A0          STA     ,Y+    ;			write to destination
F280  d   AC 64          CMPX    $04,S  ;			cmp to end address
F282 &    26 F6          BNE     $F27A  ;			more
->
F284      8E F2 9C       LDX     #$F29C ;			"Done"
F287      20 D8          BRA     $F261  ;			print string, clean up, DONE
->
F289  d   AE 64          LDX     $04,S  ;			end address
F28B      10 AE E4       LDY     ,S     ;			dest end address
F28E 0    30 01          LEAX    $01,X  ;			X = X + 1
F290 1!   31 21          LEAY    $01,Y  ;			Y = Y + 1
->
F292      A6 82          LDA     ,-X    ;			copy from end address
F294      A7 A2          STA     ,-Y    ;			place at dest end address
F296  f   AC 66          CMPX    $06,S  ;			cmp to start address
F298 &    26 F8          BNE     $F292  ;			more to copy
F29A      20 E8          BRA     $F284  ;			print "Done", clean stack and DONE
->
F29C 20 20 44 6F 6E 65 20 21 04 				; Done !
;
F2A5 20 20 52 61 6E 67 65 20 65 72 72 6F 72 04 	; Range error.
;
->
Routine:
;
;	SET MEM BLOCK
;	-------------
;
F2B3      8D 90          BSR     $F245  ;			read 2 integers (Y=start address, X=end address)
F2B5 )    29 AF          BVS     $F266  ;			overflow
F2B7   #  17 0B 23       LBSR    $FDDD  ;			write space to serial port
F2BA      17 0A 7F       LBSR    $FD3C  ;			read byte (value to store there)
F2BD )    29 A7          BVS     $F266  ;			DONE
F2BF 0    30 01          LEAX    $01,X  ;			start = start + 1
F2C1 4v   34 76          PSHS    U,Y,X,D;			create 8 spaces on the stack
F2C3 4    34 20          PSHS    Y      ;			and create 2 more
F2C5      AC E1          CMPX    ,S++   ;			compate to end address (and clean stack)
F2C7 %    25 95          BCS     $F25E  ;			print "Range error", clean stack, DONE
->
F2C9      A7 A0          STA     ,Y+    ;			write to current address
F2CB 4    34 20          PSHS    Y      ;			save current address
F2CD      AC E1          CMPX    ,S++   ;			is it the end address (and clean the stack)
F2CF &    26 F8          BNE     $F2C9  ;			more
F2D1      20 B1          BRA     $F284  ;			print "Done" and DONE
->
Routine:
;
;	PRINT RT=
;	---------
;
F2D3      8E F2 DE       LDX     #$F2DE ;			"RT= "string below
F2D6      17 0A D5       LBSR    $FDAE  ;			print string
F2D9  L   AE 4C          LDX     $0C,U  ;			PC on the stack
F2DB      16 0A 8C       LBRA    $FD6A  ;			print hex word
->
F2DE 20 52 54 3D 04 0D 0A 04 55 43 4D 54 42 4C 20 44  RT=....UCMTBL D   ;
F2EE 46 46 41 20 75 73 72 63 6D 64 20 54 42 4C 04 55 FFA usrcmd TBL.U   ;
F2FE 53 45 52 56 20 44 46 43 30 20 54 6F 70 6F 66 20 SERV DFC0 Topof    ;
F30E 73 74 6B 2F 75 73 72 20 76 63 74 72 20 53 57 49 stk/usr vctr SWI   ;
F31E 33 20 53 57 49 32 20 46 49 52 51 20 49 52 51 20 3 SWI2 FIRQ IRQ    ;
F32E 53 57 49 04 53 56 43 56 4F 20 53 75 70 76 73 72 SWI.SVCVO Supvsr   ;
F33E 20 63 61 6C 20 76 63 74 72 20 6F 72 69 67 69 6E  cal vctr origin   ;
F34E 04 53 56 43 56 4C 20 53 75 70 76 73 72 20 63 61 .SVCVL Supvsr ca   ;
F35E 6C 20 76 63 74 72 20 6C 69 6D 69 74 04 41 43 49 l vctr limit.ACI   ;
F36E 41 41 44 20 44 46 45 30 20 43 6E 74 72 6C 70 6F AAD DFE0 Cntrlpo   ;
F37E 72 74 04 45 4B 4F 46 4C 47 20 44 46 45 32 20 45 rt.EKOFLG DFE2 E   ;
F38E 63 68 6F 66 6C 61 67 0D 0A 04 50 41 55 53 45 20 choflag...PAUSE    ;
F39E 46 42 36 44 20 6F 6E 20 45 53 43 20 61 62 6F 72 FB6D on ESC abor   ;
F3AE 74 20 69 66 20 4E 45 04 49 4E 32 41 44 52 20 46 t if NE.IN2ADR F   ;
F3BE 44 32 30 20 49 6E 20 32 20 68 65 78 20 61 64 64 D20 In 2 hex add   ;
F3CE 72 20 74 6F 20 59 2C 58 20 27 56 27 73 65 74 69 r to Y,X 'V'seti   ;
F3DE 66 6E 6F 74 48 65 78 04 49 4E 31 41 44 52 20 46 fnotHex.IN1ADR F   ;
F3EE 44 32 42 20 49 6E 20 31 20 68 65 78 20 61 64 64 D2B In 1 hex add   ;
F3FE 72 20 74 6F 20 58 20 27 56 27 73 65 74 04 42 59 r to X 'V'set.BY   ;
F40E 54 45 20 46 44 33 43 20 49 6E 20 32 20 68 65 78 TE FD3C In 2 hex   ;
F41E 20 63 68 61 72 20 74 6F 20 41 20 27 56 27 73 65  char to A 'V'se   ;
F42E 74 04 4F 55 54 34 48 20 46 44 36 41 20 4F 75 74 t.OUT4H FD6A Out   ;
F43E 20 68 65 78 20 61 64 64 72 20 69 6E 20 58 04 4F  hex addr in X.O   ;
F44E 55 54 32 48 20 46 44 37 32 20 4F 75 74 62 79 74 UT2H FD72 Outbyt   ;
F45E 20 69 6E 20 41 04 50 73 74 72 6E 67 20 46 44 39  in A.Pstrng FD9   ;
F46E 45 20 50 72 73 74 72 20 70 6E 74 64 20 74 6F 20 E Prstr pntd to    ;
F47E 62 79 20 58 20 74 69 6C 20 45 4F 54 2E 20 43 52 by X til EOT. CR   ;
F48E 4C 46 20 31 73 74 04 50 63 72 6C 66 20 46 44 41 LF 1st.Pcrlf FDA   ;
F49E 32 20 50 72 20 43 52 4C 46 2B 33 4E 55 4C 73 04 2 Pr CRLF+3NULs.   ;
F4AE 50 64 61 74 61 20 46 44 41 45 20 50 72 73 74 72 Pdata FDAE Prstr   ;
F4BE 20 70 6E 74 64 20 74 6F 20 62 79 20 58 20 74 69  pntd to by X ti   ;
F4CE 6C 20 45 4F 54 04 49 6E 63 68 65 20 46 44 42 41 l EOT.Inche FDBA   ;
F4DE 20 49 6E 20 63 68 61 72 20 74 6F 20 41 20 66 72  In char to A fr   ;
F4EE 6F 6D 20 54 65 72 6D 20 65 63 68 6F 20 28 70 61 om Term echo (pa   ;
F4FE 72 20 72 65 6D 76 64 29 04 49 6E 63 68 20 46 44 r remvd).Inch FD   ;
F50E 43 30 20 49 6E 20 63 68 61 72 20 74 6F 20 41 20 C0 In char to A    ;
F51E 66 72 6F 6D 20 54 65 72 6D 20 6E 6F 65 63 68 6F from Term noecho   ;
F52E 20 38 42 69 74 04 49 6E 63 68 65 6B 20 46 44 44  8Bit.Inchek FDD   ;
F53E 30 20 43 68 6B 20 66 6F 72 20 63 68 61 72 20 61 0 Chk for char a   ;
F54E 76 61 69 6C 20 66 72 6F 6D 20 54 65 72 6D 20 27 vail from Term '   ;
F55E 4E 45 27 20 69 66 6E 6F 63 68 61 72 04 4F 55 54 NE' ifnochar.OUT   ;
F56E 32 53 20 46 44 44 42 20 32 73 70 61 63 65 04 4F 2S FDDB 2space.O   ;
F57E 55 54 31 53 20 46 44 44 44 20 31 73 70 61 63 65 UT1S FDDD 1space   ;
F58E 04 4F 75 74 63 68 20 46 44 44 46 20 4F 75 74 20 .Outch FDDF Out    ;
F59E 63 68 61 72 20 69 6E 20 41 20 74 6F 20 54 65 72 char in A to Ter   ;
F5AE 6D 04 41 43 49 4E 49 5A 20 46 44 46 31 20 49 6E m.ACINIZ FDF1 In   ;
F5BE 69 74 20 41 43 49 41 20 61 64 64 72 20 69 73 69 it ACIA addr isi   ;
F5CE 6E 20 44 46 45 30 20 74 6F 20 38 44 32 53 6E 6F n DFE0 to 8D2Sno   ;
F5DE 50 41 52 20 54 75 72 6E 20 6F 6E 20 45 43 48 4F PAR Turn on ECHO   ;
F5EE 0D 0A 04 43 6F 6D 6D 61 6E 64 73 28 5E 20 63 6E ...Commands(^ cn   ;
F5FE 74 72 6C 29 04 5E 41 20 5E 42 20 5E 43 20 5E 44 trl).^A ^B ^C ^D   ;
F60E 20 5E 50 20 5E 55 20 5E 58 20 5E 59 20 61 6C 74  ^P ^U ^X ^Y alt   ;
F61E 20 72 65 67 04 41 20 63 6F 6D 70 75 74 65 20 61  reg.A compute a   ;
F62E 64 64 72 20 42 45 47 2D 45 4E 44 20 4E 45 57 6F ddr BEG-END NEWo   ;
F63E 72 45 4E 44 2D 42 45 47 20 4E 45 57 04 42 20 53 rEND-BEG NEW.B S   ;
F64E 65 74 20 62 72 6B 70 6E 74 20 41 44 44 52 20 28 et brkpnt ADDR (   ;
F65E 75 70 74 6F 20 35 29 04 43 20 63 6F 6D 70 61 72 upto 5).C compar   ;
F66E 65 20 6D 65 6D 20 62 6C 6B 73 20 42 45 47 2D 42 e mem blks BEG-B   ;
F67E 45 47 04 44 20 62 6F 6F 74 64 69 73 6B 20 28 47 EG.D bootdisk (G   ;
F68E 4F 54 4F 20 52 45 53 45 54 2F 50 57 52 2D 55 50 OTO RESET/PWR-UP   ;
F69E 29 04 45 20 64 75 6D 70 20 6D 65 6D 20 62 6C 6B ).E dump mem blk   ;
F6AE 20 42 45 47 2D 45 4E 44 04 47 20 67 6F 20 66 72  BEG-END.G go fr   ;
F6BE 6F 6D 20 63 75 72 72 20 50 43 04 48 20 64 69 73 om curr PC.H dis   ;
F6CE 70 20 62 79 74 65 20 69 6E 20 62 69 6E 20 42 59 p byte in bin BY   ;
F6DE 54 45 04 49 20 69 6E 73 74 72 75 63 74 04 4B 20 TE.I instruct.K    ;
F6EE 73 65 74 20 6D 65 6D 20 62 6C 6B 20 42 45 47 2D set mem blk BEG-   ;
F6FE 45 4E 44 20 42 59 54 45 04 4C 20 6C 6F 61 64 20 END BYTE.L load    ;
F70E 6D 69 6B 62 75 67 20 74 61 70 65 04 4D 20 6D 65 mikbug tape.M me   ;
F71E 6D 20 65 78 61 6D 20 63 68 67 20 41 44 44 52 20 m exam chg ADDR    ;
F72E 28 51 75 69 74 3D 43 52 2C 20 42 61 63 6B 3D 5E (Quit=CR, Back=^   ;
F73E 2C 20 46 6F 72 77 3D 41 4E 59 4F 54 48 45 52 29 , Forw=ANYOTHER)   ;
F74E 04 50 20 70 75 6E 63 68 20 6D 69 6B 62 75 67 20 .P punch mikbug    ;
F75E 74 61 70 65 04 51 20 74 73 74 20 6D 65 6D 20 42 tape.Q tst mem B   ;
F76E 45 47 2D 45 4E 44 20 4E 6F 74 3E 44 46 30 30 04 EG-END Not>DF00.   ;
F77E 52 20 64 69 73 70 20 72 65 67 20 2B 34 20 62 79 R disp reg +4 by   ;
F78E 74 20 73 74 61 72 74 69 6E 67 20 61 74 20 63 75 t starting at cu   ;
F79E 72 72 20 50 43 04 53 20 64 69 73 70 20 73 74 61 rr PC.S disp sta   ;
F7AE 63 6B 20 74 6F 20 44 46 43 30 04 5E 53 20 73 68 ck to DFC0.^S sh   ;
F7BE 69 66 74 20 6D 65 6D 20 62 6C 6B 20 42 45 47 2D ift mem blk BEG-   ;
F7CE 45 4E 44 20 42 45 47 04 58 20 63 6C 72 20 61 6C END BEG.X clr al   ;
F7DE 6C 20 62 72 6B 70 6E 74 73 04 5A 20 64 69 73 70 l brkpnts.Z disp   ;
F7EE 20 61 63 74 69 76 65 20 62 72 6B 70 6E 74 04 04  active brkpnt..   ;
F7FE 04 FF 
;
F800 F8 14 			; ENTER_P-BUG
F802 F8 61 			; MONITOR_MAIN_LOOP
F804 FD C0 			; GET_CHAR
F806 FD BA 			; GET_CHAR_AND_ECHO
F808 FD D0 			; DATA_READY
F80A FD DF 			; WRITE_TO_SERIAL_PORT
F80C FD AE			; PRINT_STRING
F80E FD A2 			; PRINT_CRLF
F810 FD 9E 			; PRINT_ON_NEXT_LINE
F812 FB 7E			; MAP_TRANSLATE
;
->
;
;	ENTER P-BUG
;	-----------
;
F814      8E FB E9       LDX     #$FBE9 ;			Interrupt table
F817      10 8E DF C0    LDY     #$DFC0 ;			bottom of stack location
F81B      C6 10          LDB     #$10   ;			$10 bytes to shift
->
F81D      A6 80          LDA     ,X+    ;			get a byte
F81F      A7 A0          STA     ,Y+    ;			save the byte
F821 Z    5A             DECB           ;			dec bytes left
F822 &    26 F9          BNE     $F81D  ;			more to copy
F824      8E E0 04       LDX     #$E004 ;			6850 status register
F827      BF DF E0       STX     $DFE0  ;			save the address of the register
F82A      17 02 A7       LBSR    $FAD4  ;			clear all breakpoints
F82D      C6 0C          LDB     #$0C   ;			12 bytes
->
F82F o    6F E2          CLR     ,-S    ;			clear 12 bytes on top of stack
F831 Z    5A             DECB           ;			dec
F832 &    26 FB          BNE     $F82F  ;			keep going
F834 0    30 8C DD       LEAX    $-23,PC;			P-BUG entry point ($F814)
F837  j   AF 6A          STX     $0A,S  ;			PC position
F839      86 D0          LDA     #$D0   ;			push all flags, Ignore FIRQ, Ignore IRQ
F83B      A7 E4          STA     ,S     ;			CC position
F83D  C   1F 43          TFR     S,U    ;			U = S
F83F      17 05 AF       LBSR    $FDF1  ;			init serial port
F842   R  8E FE 52       LDX     #$FE52 ;			"P-BUG 0.5 -"
F845   f  17 05 66       LBSR    $FDAE  ;			print string
F848      8E DF D0       LDX     #$DFD0 ;			valid memory page map
F84B O    4F             CLRA           ;			A = 00
F84C      C6 0D          LDB     #$0D   ;			start at DFDD and go to DFD0
->
F84E m    6D 85          TST     B,X    ;			is DFDx zero (if so then the RAM page is invalid)
F850      27 03          BEQ     $F855  ;			yes	so don't add 4
F852      8B 04          ADDA    #$04   ;			otherwise add 4 to A
F854      19             DAA            ;			the BCD adjust the register
->
F855 Z    5A             DECB           ;			move on to the previous DFDx location
F856 *    2A F6          BPL     $F84E  ;			keep going until we get to DFD0
F858      17 05 17       LBSR    $FD72  ;			print hex byte in A
F85B   g  8E FE 67       LDX     #$FE67 ;			"K"
F85E   M  17 05 4D       LBSR    $FDAE  ;			print string
->
F861   n  8E FE 6E       LDX     #$FE6E ;			address of ">" string
F864   7  17 05 37       LBSR    $FD9E  ;			print <cr><lf> then string
F867   V  17 05 56       LBSR    $FDC0  ;			load A from serial port
F86A      84 7F          ANDA    #$7F   ;			turn top bit off (because we are ASCII)
F86C      81 0D          CMPA    #$0D   ;			was it a <cr>
F86E      27 F1          BEQ     $F861  ;			yes so do nothing
F870      1F 89          TFR     A,B    ;			B = the key we pressed
F872      81 20          CMPA    #$20   ;			was it a space?
F874 ,    2C 09          BGE     $F87F  ;			after space so not a control character
F876  ^   86 5E          LDA     #$5E   ;			'^'
F878   d  17 05 64       LBSR    $FDDF  ;			write to serial port
F87B      1F 98          TFR     B,A    ;			copy it back
F87D  @   8B 40          ADDA    #$40   ;			convert a control char into an ASCII letter
->
F87F   ]  17 05 5D       LBSR    $FDDF  ;			write to serial port
F882   X  17 05 58       LBSR    $FDDD  ;			write space to serial port
F885      BE DF FA       LDX     $DFFA  ;			pointer to extended monitor command table
F888  &   10 26 03 1A    LBNE    $FBA6  ;			call extended monitor command (from B)
->
F88C      8E FE 04       LDX     #$FE04 ;			monitor command branch table
->
F88F      E1 80          CMPB    ,X+    ;			compare B to the entry in the function table
F891      27 0F          BEQ     $F8A2  ;			match so call the routine
F893 0    30 02          LEAX    $02,X  ;			inc by 2, so skip over the address
F895   R  8C FE 52       CMPX    #$FE52 ;			end of the branch table
F898 &    26 F5          BNE     $F88F  ;			keep looping through the list
F89A   p  8E FE 70       LDX     #$FE70 ;			"WHAT"
F89D      17 05 0E       LBSR    $FDAE  ;			print string
F8A0      20 BF          BRA     $F861  ;			back to the monitor command prompt
->
F8A2      AD 94          JSR     [,X]   ;			call where X points
F8A4      20 BB          BRA     $F861  ;			back to the monitor command prompt
->
Routine:
;
;	GO FROM CURRENT PC
;	------------------
;
F8A6  4   1F 34          TFR     U,S    ;			S = U
->
F8A8      3B             RTI            ;			DONE
Routine:
;
; 	DISPLAY REGISTERS +4 BYTES FROM PC
;	----------------------------------
;
F8A9   v  8E FE 76       LDX     #$FE76 ;			"-"
F8AC      17 04 EF       LBSR    $FD9E  ;			print string on next line
F8AF      17 04 0D       LBSR    $FCBF  ;			print S
F8B2   ^  17 04 5E       LBSR    $FD13  ;			print CC (in binary)
F8B5      17 02 92       LBSR    $FB4A  ;			print CC (in hex)
F8B8   D  17 04 44       LBSR    $FCFF  ;			print A
F8BB   K  17 04 4B       LBSR    $FD09  ;			print B
F8BE      17 04 14       LBSR    $FCD5  ;			print DP
F8C1   v  8E FE 76       LDX     #$FE76 ;			"-"
F8C4      17 04 D7       LBSR    $FD9E  ;			print string on next line
F8C7      17 04 16       LBSR    $FCE0  ;			print X
F8CA      17 04 1E       LBSR    $FCEB  ;			print Y
F8CD      17 03 FA       LBSR    $FCCA  ;			print U
F8D0      17 04 22       LBSR    $FCF5  ;			print PC
F8D3      8E FE 94       LDX     #$FE94 ;			"=>"
F8D6      17 04 D5       LBSR    $FDAE  ;			print string
F8D9  J   AE 4A          LDX     $0A,U  ;			address to dump from (the PC)
F8DB      C6 05          LDB     #$05   ;			number of bytes to print
->
F8DD      A6 80          LDA     ,X+    ;			load A
F8DF Z    5A             DECB           ;			bytes left
F8E0 &    26 04          BNE     $F8E6  ;			print it followed by a space
F8E2      17 F9 EE       LBSR    $F2D3  ;			print RT= message (and PC)
F8E5 9    39             RTS            ;			DONE
->
F8E6      17 04 89       LBSR    $FD72  ;			print A as hex value 
F8E9      17 04 F1       LBSR    $FDDD  ;			write space to serial port
F8EC      20 EF          BRA     $F8DD  ;			move on to next byte
->
Routine:
;
;	ALTER PC
;	--------
;
F8EE      17 04 04       LBSR    $FCF5  ;			print PC
F8F1      17 04 E9       LBSR    $FDDD  ;			write space to serial port
F8F4   4  17 04 34       LBSR    $FD2B  ;			read integer
F8F7 )    29 02          BVS     $F8FB  ;			DONE
F8F9  J   AF 4A          STX     $0A,U  ;			store at PC
->
F8FB 9    39             RTS            ;			DONE
->
Routine:
;
;	ALTER U
;	-------
;
F8FC      17 03 CB       LBSR    $FCCA  ;			print U
F8FF      17 04 DB       LBSR    $FDDD  ;			write space to serial port
F902   &  17 04 26       LBSR    $FD2B  ;			read integer
F905 )    29 02          BVS     $F909  ;			DONE
F907  H   AF 48          STX     $08,U  ;			store at U
->
F909 9    39             RTS            ;			DONE
->
Routine:
;
;	ALTER Y
;	-------
;
F90A      17 03 DE       LBSR    $FCEB  ;			print Y
F90D      17 04 CD       LBSR    $FDDD  ;			write space to serial port
F910      17 04 18       LBSR    $FD2B  ;			read integer
F913 )    29 02          BVS     $F917  ;			DONE
F915  F   AF 46          STX     $06,U  ;			store at Y
->
F917 9    39             RTS            ;			DONE
->
Routine:
;
;	ALTER X
;	-------
;
F918      17 03 C5       LBSR    $FCE0  ;			print X
F91B      17 04 BF       LBSR    $FDDD  ;			write space to serial port
F91E      17 04 0A       LBSR    $FD2B  ;			read integer
F921 )    29 02          BVS     $F925  ;			DONE
F923  D   AF 44          STX     $04,U  ;			store at X
->
F925 9    39             RTS            ;			DONE
->
Routine:
;
;	ALTER DP
;	--------
;
F926      17 03 AC       LBSR    $FCD5  ;			print DP
F929      17 04 B1       LBSR    $FDDD  ;			write space to serial port
F92C      17 04 0D       LBSR    $FD3C  ;			read byte
F92F )    29 02          BVS     $F933  ;			DONE
F931  C   A7 43          STA     $03,U  ;			save at DP
->
F933 9    39             RTS            ;			DONE
->
Routine:
;
;	ALTER B
;	-------
;
F934      17 03 D2       LBSR    $FD09  ;			print B
F937      17 04 A3       LBSR    $FDDD  ;			write space to serial port
F93A      17 03 FF       LBSR    $FD3C  ;			read byte
F93D )    29 02          BVS     $F941  ;			DONE
F93F  B   A7 42          STA     $02,U  ;			save at B
->
F941 9    39             RTS            ;			DONE
->
Routine:
;
;	ALTER A
;	-------
;
F942      17 03 BA       LBSR    $FCFF  ;			print A
F945      17 04 95       LBSR    $FDDD  ;			write space to serial port
F948      17 03 F1       LBSR    $FD3C  ;			read byte
F94B )    29 02          BVS     $F94F  ;			DONE
F94D  A   A7 41          STA     $01,U  ;			save at A
->
F94F 9    39             RTS            ;			DONE
->
Routine:
;
;	ALTER CC
;	--------
;
F950      17 03 C0       LBSR    $FD13  ;			print CC
F953      17 04 87       LBSR    $FDDD  ;			write space to serial port
F956      17 01 F1       LBSR    $FB4A  ;			print CC= and the value of CC
F959      17 04 81       LBSR    $FDDD  ;			write space to serial port
F95C      17 03 DD       LBSR    $FD3C  ;			read byte
F95F )    29 04          BVS     $F965  ;			overflow, done
F961      8A 80          ORA     #$80   ;			turn on the push all flag
F963      A7 C4          STA     ,U     ;			store where CC goes
->
F965 9    39             RTS            ;			DONE
->
Routine:
;
;	MEMORY EXAMINE
;	--------------
;
F966      17 03 C2       LBSR    $FD2B  ;			read integer
F969 )-   29 2D          BVS     $F998  ;			overflow, DONE
F96B      1F 12          TFR     X,Y    ;			Y = X
->
F96D   v  8E FE 76       LDX     #$FE76 ;			" - "
F970   +  17 04 2B       LBSR    $FD9E  ;			print <cr><lf> then string
F973  !   1F 21          TFR     Y,X    ;			X = Y
F975      17 03 F2       LBSR    $FD6A  ;			print hex word
F978   b  17 04 62       LBSR    $FDDD  ;			write space to serial port
F97B      A6 A4          LDA     ,Y     ;			load byte at from address
F97D      17 03 F2       LBSR    $FD72  ;			print hex byte
F980   Z  17 04 5A       LBSR    $FDDD  ;			write space to serial port
F983      17 03 B6       LBSR    $FD3C  ;			read byte (or char)
F986 (    28 11          BVC     $F999  ;			relace the byte at this location with one read from the user
F988      81 08          CMPA    #$08   ;			got backspace (^H)
F98A      27 E1          BEQ     $F96D  ;			display agaiin
F98C      81 18          CMPA    #$18   ;			got cancel (^X)
F98E      27 DD          BEQ     $F96D  ;			display again
F990  ^   81 5E          CMPA    #$5E   ;			got '^'
F992      27 17          BEQ     $F9AB  ;			move to previous byte
F994      81 0D          CMPA    #$0D   ;			got <cr>
F996 &    26 0F          BNE     $F9A7  ;			move on to next byte
->
F998 9    39             RTS            ;			DONE
->
F999      A7 A4          STA     ,Y     ;			replace the byte that was there with the one that the user gave
F99B      A1 A4          CMPA    ,Y     ;			make sure it went in OK (ie its in RAM)
F99D      27 08          BEQ     $F9A7  ;			move on to next memory location
F99F      17 04 3B       LBSR    $FDDD  ;			write space to serial port
F9A2  ?   86 3F          LDA     #$3F   ;			'?' 
F9A4   8  17 04 38       LBSR    $FDDF  ;			write to serial port
->
F9A7 1!   31 21          LEAY    $01,Y  ;			inc Y (move forward 1)
F9A9      20 C2          BRA     $F96D  ;			keep going
->
F9AB 1?   31 3F          LEAY    $-01,Y ;			dec Y (move back 1)
F9AD      20 BE          BRA     $F96D  ;			keep going
->
Routine:
;
;	DUMP STACK
;	----------
;
F9AF      17 03 0D       LBSR    $FCBF  ;			print current SP value
F9B2  2   1F 32          TFR     U,Y    ;			Y = U
F9B4      8E DF C0       LDX     #$DFC0 ;			X = bottom of stack (high mem)
F9B7 0    30 1F          LEAX    $-01,X ;			sub 1 (ie don't go to high mem pos)
F9B9      20 05          BRA     $F9C0  ;			dump memory blovk
->
Routine:
;
;	DUMP MEM BLOCK
;	--------------
;
F9BB   b  17 03 62       LBSR    $FD20  ;			read 2 integers, X then Y
F9BE )    29 06          BVS     $F9C6  ;			overflow, DONE
->
F9C0 4    34 20          PSHS    Y      ;			save one of them
F9C2      AC E1          CMPX    ,S++   ;			compare the other with the first
F9C4 $    24 01          BCC     $F9C7  ;			wrong order specified so quit
->
F9C6 9    39             RTS            ;			DONE
->										;			this lot is about to compute the end address as a whole number of "rows" from the start address
F9C7      1E 12          EXG     X,Y    ;			swap X and Y
F9C9      1F 20          TFR     Y,D    ;			D = Y
F9CB      C4 F0          ANDB    #$F0   ;			turn off the low nibble
F9CD      C3 00 10       ADDD    #$0010 ;			this is the next whole row after the end address
F9D0 4    34 06          PSHS    D      ;			save this address (it has the low nibble set to 0
F9D2      1F 10          TFR     X,D    ;			D = X
F9D4 O    4F             CLRA           ;			turn off the top byte
F9D5      C4 0F          ANDB    #$0F   ;			get the low nibble
F9D7      E3 E4          ADDD    ,S     ;			add the partial address from abovce
F9D9      ED E4          STD     ,S     ;			and shove it back on the stack
->
F9DB      AC E4          CMPX    ,S     ;			at the end yet?
F9DD      27 05          BEQ     $F9E4  ;			yes, so done
F9DF      17 01 8B       LBSR    $FB6D  ;			check for user pressing ESC
F9E2      27 03          BEQ     $F9E7  ;			print a row
->
F9E4 2b   32 62          LEAS    $02,S  ;			clean up the stack
F9E6 9    39             RTS            ;			DONE
->
F9E7 4    34 10          PSHS    X      ;			save X
F9E9   v  8E FE 76       LDX     #$FE76 ;			"-"
F9EC      17 03 AF       LBSR    $FD9E  ;			print <cr><lf> then string
F9EF      AE E4          LDX     ,S     ;			restore X
F9F1   v  17 03 76       LBSR    $FD6A  ;			print hex word
F9F4      17 03 E4       LBSR    $FDDB  ;			write 2 spaces to serial port
F9F7      C6 10          LDB     #$10   ;			$10 (decimal 16) numbers per row
->
F9F9      A6 80          LDA     ,X+    ;			load the next character
F9FB   t  17 03 74       LBSR    $FD72  ;			print hex byte (the byte)
F9FE      17 03 DC       LBSR    $FDDD  ;			write space to serial port
FA01 Z    5A             DECB           ;			next byte
FA02 &    26 F5          BNE     $F9F9  ;			keep going
FA04      17 03 D4       LBSR    $FDDB  ;			write 2 spaces to serial port
FA07      AE E1          LDX     ,S++   ;			reload the start address of this row
FA09      C6 10          LDB     #$10   ;			$10 (decimal 16) numbers per row
->
FA0B      A6 80          LDA     ,X+    ;			get a character from the location
FA0D      81 20          CMPA    #$20   ;			is it a space?
FA0F %    25 04          BCS     $FA15  ;			no, smaller
FA11  ~   81 7E          CMPA    #$7E   ;			is it ASCII?
FA13 #    23 02          BLS     $FA17  ;			yes so print
->
FA15  .   86 2E          LDA     #$2E   ;			'.'
->
FA17      17 03 C5       LBSR    $FDDF  ;			write to serial port
FA1A Z    5A             DECB           ;			next character
FA1B &    26 EE          BNE     $FA0B  ;			keep going
FA1D      20 BC          BRA     $F9DB  ;			next line of the dump
->
Routine:
;
;	TEST MEMORY
;	-----------
;
FA1F o    6F E2          CLR     ,-S    ;			push 0
FA21 o    6F E2          CLR     ,-S    ;			push 0
FA23      17 02 FA       LBSR    $FD20  ;			read 2 integers, Y then X
FA26 40   34 30          PSHS    Y,X    ;			save them on the stack
FA28 ){   29 7B          BVS     $FAA5  ;			clean the stack and DONE
FA2A  b   AC 62          CMPX    $02,S  ;			compare start and end address
FA2C )w   29 77          BVS     $FAA5  ;			clean the stack and DONE
FA2E      17 03 AC       LBSR    $FDDD  ;			write space to serial port
->
FA31      1F 20          TFR     Y,D    ;			D = current address
FA33  d   E3 64          ADDD    $04,S  ;	   		initialised to 00
FA35 4    34 04          PSHS    B      ;			save low byte of address
FA37      AB E0          ADDA    ,S+    ;			add low byte to high byte
FA39      A7 A0          STA     ,Y+    ;			store at current address
FA3B      10 AC E4       CMPY    ,S     ;			end address
FA3E %    25 F1          BCS     $FA31  ;			more to go
FA40   b  10 AE 62       LDY     $02,S  ;			start address
->
FA43      1F 20          TFR     Y,D    ;			D = current address
FA45  d   E3 64          ADDD    $04,S  ;	   		initialised to 00
FA47 4    34 02          PSHS    A      ;			save it
FA49      EB E0          ADDB    ,S+    ;			add low byte to high byte
FA4B      E8 A0          EORB    ,Y+    ;			EOR with what's there results in Zero
FA4D  <   27 3C          BEQ     $FA8B  ;			keep going
FA4F   v  8E FE 76       LDX     #$FE76 ;			"-"
FA52   I  17 03 49       LBSR    $FD9E  ;			print <cr><lf> then string
FA55 0?   30 3F          LEAX    $-01,Y ;			address that failed
FA57      17 03 10       LBSR    $FD6A  ;			print hex word
FA5A 4    34 10          PSHS    X      ;			save final successful address
FA5C      8E FE 94       LDX     #$FE94 ;			"=>"
FA5F   L  17 03 4C       LBSR    $FDAE  ;			print string
FA62 5    35 10          PULS    X      ;			restore
FA64      17 01 17       LBSR    $FB7E  ;			map-translate
FA67      17 03 14       LBSR    $FD7E  ;			print hex nibble
FA6A      17 02 FD       LBSR    $FD6A  ;			print hex word
FA6D   z  8E FE 7A       LDX     #$FE7A ;			"Pass"
FA70      17 03 3B       LBSR    $FDAE  ;			print string
FA73  d   AE 64          LDX     $04,S  ;	   		initialised to 00
FA75      17 02 F2       LBSR    $FD6A  ;			print hex word
FA78      8E FE 82       LDX     #$FE82 ;			"Bits in Error:"
FA7B   0  17 03 30       LBSR    $FDAE  ;			print string
FA7E      1F 98          TFR     B,A    ;			A = B
FA80      8E FE 99       LDX     #$FE99 ;			"76543210"
FA83      17 03 02       LBSR    $FD88  ;			fancy bitstring printing thing
FA86      17 00 E4       LBSR    $FB6D  ;			check for user pressing ESC
FA89 &    26 1A          BNE     $FAA5  ;			clean the stack and DONE
->
FA8B      10 AC E4       CMPY    ,S     ;			compare current to end address
FA8E %    25 B3          BCS     $FA43  ;			move on to next address
FA90  +   86 2B          LDA     #$2B   ;			'+'
FA92   J  17 03 4A       LBSR    $FDDF  ;			write to serial port
FA95      17 00 D5       LBSR    $FB6D  ;			check for user pressing ESC
FA98 &    26 0B          BNE     $FAA5  ;			clean the stack and DONE
FA9A   b  10 AE 62       LDY     $02,S  ;			start address
FA9D le   6C 65          INC     $05,S  ;			255 times
FA9F &    26 90          BNE     $FA31  ;			test again
FAA1 ld   6C 64          INC     $04,S  ;			255 times
FAA3 &    26 8C          BNE     $FA31  ;			test again
->
FAA5 2f   32 66          LEAS    $06,S  ;			clean the stack
FAA7 9    39             RTS            ;			DONE
->
Routine:
;
;	SET BREAKPOINT
;	--------------
;
FAA8      17 02 80       LBSR    $FD2B  ;			read integer
FAAB )    29 1E          BVS     $FACB  ;			overflow, DONE
FAAD      8C DF C0       CMPX    #$DFC0 ;			bottom of stack (high mem)
FAB0 $    24 1A          BCC     $FACC  ;			print "?" and DONE
FAB2 4    34 10          PSHS    X      ;			store the address on the stack
FAB4      8E FF FF       LDX     #$FFFF ;			empty breakpoint balue
FAB7  U   8D 55          BSR     $FB0E  ;			find breakpoint
FAB9 5    35 10          PULS    X      ;			get the address back
FABB      27 0F          BEQ     $FACC  ;			print "?" and DONE
FABD      A6 84          LDA     ,X     ;			get the byte that was at X
FABF  ?   81 3F          CMPA    #$3F   ;			was it a 3F (SWI)
FAC1      27 09          BEQ     $FACC  ;			print "?" and DONE (2 breakpoints at the same place)
FAC3      A7 A0          STA     ,Y+    ;			save what was there (the byte)
FAC5      AF A4          STX     ,Y     ;			save the breakpoint address (the address)
FAC7  ?   86 3F          LDA     #$3F   ;			SWI instruction
FAC9      A7 84          STA     ,X     ;			save it at the given location so an SWI is a breakpoint
->
FACB 9    39             RTS            ;			DONE
->
FACC      17 03 0E       LBSR    $FDDD  ;			write space to serial port
FACF  ?   86 3F          LDA     #$3F   ;			'?'
FAD1      16 03 0B       LBRA    $FDDF  ;			write to serial port
->
Routine:
;
;	CLEAR ALL BREAKPOINTS
;	---------------------
;
FAD4      10 8E DF E3    LDY     #$DFE3 ;			start of breakpoint table
FAD8      C6 05          LDB     #$05   ;			number of breakpoints
->
FADA      8D 18          BSR     $FAF4  ;			remove breakpoint
FADC Z    5A             DECB           ;			are we done
FADD &    26 FB          BNE     $FADA  ;			more
FADF 9    39             RTS            ;			DONE
->
;
;	SWI entry point (from the RAM vector table)
;	---------------
;
FAE0  C   1F 43          TFR     S,U    ;			U = S
FAE2  J   AE 4A          LDX     $0A,U  ;			read PC
FAE4 0    30 1F          LEAX    $-01,X ;			X = X - 1
FAE6  &   8D 26          BSR     $FB0E  ;			find breakpoint for X (returned in Y)
FAE8      27 04          BEQ     $FAEE  ;			found so dump the registers
FAEA  J   AF 4A          STX     $0A,U  ;			put PC address back on stack
FAEC      8D 06          BSR     $FAF4  ;			remove breakpoint pointed to by Y (that is, the one found above)
->
FAEE      17 FD B8       LBSR    $F8A9  ;			dump the registers
FAF1   m  16 FD 6D       LBRA    $F861  ;			Monitor main loop
->
Routine:
;
;	REMOVE BREAKPOINT
;	-----------------
;	Y points to the breakpoint triplet
;
FAF4  !   AE 21          LDX     $01,Y  ;			address
FAF6      8C DF C0       CMPX    #$DFC0 ;			bottom of stack
FAF9 $    24 0A          BCC     $FB05  ;
FAFB      A6 84          LDA     ,X     ;			what's there
FAFD  ?   81 3F          CMPA    #$3F   ;			is it a SWI instruction?
FAFF &    26 04          BNE     $FB05  ;			nope so ignore
FB01      A6 A4          LDA     ,Y     ;			load what was there
FB03      A7 84          STA     ,X     ;			and put it back
->
FB05      86 FF          LDA     #$FF   ;			breakpoint not used
FB07      A7 A0          STA     ,Y+    ;			old instruction
FB09      A7 A0          STA     ,Y+    ;			old address low
FB0B      A7 A0          STA     ,Y+    ;			old address high
FB0D 9    39             RTS            ;			DONE
->
Routine:
;
;	FIND BREAKPOINT
;	---------------
;	X = address for which we are looking for the breakpoint of
;	return Y = pointer to breakpoint triplet
;
FB0E      10 8E DF E3    LDY     #$DFE3 ;			breakpoint table
FB12      C6 05          LDB     #$05   ;			5 breakpoints
->
FB14      A6 A0          LDA     ,Y+    ;			load opcode
FB16      AC A1          CMPX    ,Y++   ;			compare X to the breakpoint address
FB18      27 04          BEQ     $FB1E  ;			point Y to the start of the breakpoint triplet
FB1A Z    5A             DECB           ;			move on to next breakpoint
FB1B &    26 F7          BNE     $FB14  ;			keep going
FB1D 9    39             RTS            ;			DONE
->
FB1E 1=   31 3D          LEAY    $-03,Y ;			point to the beginning of the current break point
FB20 9    39             RTS            ;			DONE
->
Routine:
;
;	BOOT DISK	
;	---------
;
FB21      8E FB DA       LDX     #$FBDA ;			"Reboot disk?"
FB24      BD FD 9E       JSR     $FD9E  ;			print <cr><lf> then string
FB27      BD FD BA       JSR     $FDBA  ;			get char and echo
FB2A  Y   81 59          CMPA    #$59   ;			compare to 'Y'
FB2C      10 27 03 B1    LBEQ    $FEE1  ;			simulate a RESET / NMI (which boots the disk)
FB30 9    39             RTS            ;			DONE
->
Routine:
;
;	DISPLAY BREAKPOINTS
;	-------------------
;
FB31      10 8E DF E3    LDY     #$DFE3 ;			start of breakpoint table
FB35      C6 05          LDB     #$05   ;			number of breakpoints
->
FB37      A6 A0          LDA     ,Y+    ;			value that belongs ther
FB39      AE A1          LDX     ,Y++   ;			address it belongs at
FB3B      8C FF FF       CMPX    #$FFFF ;			if the address FFFF (unused)
FB3E      27 06          BEQ     $FB46  ;			ignore this one
FB40      17 02 98       LBSR    $FDDB  ;			write 2 spaces to serial port
FB43   $  17 02 24       LBSR    $FD6A  ;			print hex word
->
FB46 Z    5A             DECB           ;			one done
FB47 &    26 EE          BNE     $FB37  ;			move on to next one
FB49 9    39             RTS            ;			DONE
->
Routine:
;
;	PRINTCC
;	-------
;
FB4A      8E FE CF       LDX     #$FECF ;			"CC="
FB4D   ^  17 02 5E       LBSR    $FDAE  ;			Print String
FB50      A6 C4          LDA     ,U     ;			load CC
FB52      16 02 1D       LBRA    $FD72  ;			Print hex
->
Routine:
;
;	INSTRUCT
;	--------
;	print the help string
;
FB55      8E F2 E3       LDX     #$F2E3 ;			start of help message
->
FB58   C  17 02 43       LBSR    $FD9E  ;			print <cr><lf> then string
FB5B      EC 84          LDD     ,X     ;			load next 2 chars
FB5D      10 83 04 04    CMPD    #$0404 ;			at end of list of strings
FB61      27 1A          BEQ     $FB7D  ;			DONE
FB63      8D 08          BSR     $FB6D  ;			check for user pressing ESC
FB65 &    26 16          BNE     $FB7D  ;			DONE
FB67      20 EF          BRA     $FB58  ;			more
->
FB69 FF FF FF FF
->
Routine:
;
;	POLL_ESC
;	--------
;	poll serial port and compare what's there with ESC
;
FB6D   `  17 02 60       LBSR    $FDD0  ;			is there serial data ready to be read?
FB70      27 0B          BEQ     $FB7D  ;			DONE
FB72      8D 02          BSR     $FB76  ;			read char and compare to ESC
FB74 &    26 07          BNE     $FB7D  ;			DONE
->
Routine:
;
;	GET_WITH_ESC
;	------------
;	get character from serial port and compare it to ESC
;
FB76   G  17 02 47       LBSR    $FDC0  ;			read A from serial port
FB79      84 7F          ANDA    #$7F   ;			turn the top bit off
FB7B      81 1B          CMPA    #$1B   ;			was it an ESC character?
->
FB7D 9    39             RTS            ;			DONE
->
Routine:
;
;	MAP TRANSLATE
;	-------------
;	The memory map table at DFD0 appears to be a translation table
;	that maps empty pages out of the address space (when testing the memory)
;	and this code does the mapping - it is called from TEST-MEMORY
;
FB7E 46   34 36          PSHS    Y,X,D  ;			save Y,X,D
FB80  b   A6 62          LDA     $02,S  ;			Xhi
FB82 D    44             LSRA           ;			move high nibble into low address
FB83 D    44             LSRA           ;			more
FB84 D    44             LSRA           ;			more
FB85 D    44             LSRA           ;			more
FB86      10 8E DF D0    LDY     #$DFD0 ;			valid memory page table
FB8A      E6 A6          LDB     A,Y    ;			get the entry from the valid page table
FB8C T    54             LSRB           ;			move high nibble into low nibble
FB8D T    54             LSRB           ;			more
FB8E T    54             LSRB           ;			more
FB8F T    54             LSRB           ;			more
FB90      E7 E4          STB     ,S     ;			place on stack (Dhi)
FB92      E6 A6          LDB     A,Y    ;			entry from valid page table
FB94 S    53             COMB           ;			invert
FB95 X    58             ASLB           ;			shift low nibble to high nibble
FB96 X    58             ASLB           ;			more
FB97 X    58             ASLB           ;			more
FB98 X    58             ASLB           ;			more
FB99  b   A6 62          LDA     $02,S  ;			XHi
FB9B      84 0F          ANDA    #$0F   ;			turn off high nibble
FB9D  b   A7 62          STA     $02,S  ;			put it back
FB9F  b   EA 62          ORB     $02,S  ;			turn on some bits (to do with the page table)
FBA1  b   E7 62          STB     $02,S  ;			put it back in Xhi
FBA3 56   35 36          PULS    Y,X,D  ;			restore registers
FBA5 9    39             RTS            ;			DONE
->
;
;	EXTENDED MONITOR COMMAND
;	------------------------
;	Search a path table for a given B and call that
;	the table ends with a 00 in which case B was not;
;	found so it is treated as a monitor command.
;
;	if (*x == 0)
;		monitor(b)
;	search a triplet <b><address> table for B
;		found so call <address>
;
FBA6      A6 84          LDA     ,X     ;			load A from X
FBA8      10 27 FC E0    LBEQ    $F88C  ;			if it was a 00 then B is the Monitor function number
FBAC      E1 80          CMPB    ,X+    ;			given function number
FBAE      27 04          BEQ     $FBB4  ;			call where X points
FBB0 0    30 02          LEAX    $02,X  ;			add 2 to X
FBB2      20 F2          BRA     $FBA6  ;			keep going
->
FBB4      AD 94          JSR     [,X]   ;			call where X points
FBB6      16 FC A8       LBRA    $F861  ;
->
Routine:
;
;	DISPLAY BYTE IN BINARY 
;	----------------------
;	read a hex value from serial port and print it in binary (as a bitstring)
;
FBB9      17 01 E6       LBSR    $FDA2  ;			print <cr><lf>
FBBC   }  17 01 7D       LBSR    $FD3C  ;			read byte
FBBF )    29 BC          BVS     $FB7D  ;			overflow, so DONE
FBC1 4    34 02          PSHS    A      ;			save A
FBC3  =   86 3D          LDA     #$3D   ;			'='
FBC5      17 02 17       LBSR    $FDDF  ;			write to serial port
FBC8 5    35 02          PULS    A      ;			restore A
FBCA      8E FB D2       LDX     #$FBD2 ;			"11111111" bit string
FBCD      17 01 B8       LBSR    $FD88  ;			fancy bit string printing thing
FBD0      20 E7          BRA     $FBB9  ;
->
FBD2 31 31 31 31 31 31 31 31 							; 11111111
;
FDBA 52 65 2D 62 6F 6F 74 20 64 69 73 6B 3F 20 04		; Re-boot disk?
->
;
;		INTERRUPT SERVICE ROUTINE ADDRESS LIST
;
FBE9 F8 A8 ;			Placed at : DFC0		Reserved
FBEB F8 A8 ;			Placed at : DFC2		SWI3
FBED F8 A8 ;			Placed at : DFC4		SWI2
FBEF F8 A8 ;			Placed at : DFC6		FIRQ
FBF1 F8 A8 ;			Placed at : DFC8		IRQ
FBF3 FA E0 ;			Placed at : DFCA		SWI
FBF5 FF FF ;			Placed at : DFCC		NMI
FBF7 FF FF ;			Placed at : DFCE		RESET
;
;		INTERRUPT SERVICE ROUTINE ADDRESS LIST (after an NMI)
;
FBF9 F8 A8  ;			Placed at : DFC0		Reserved
FBFB F1 74  ;			Placed at : DFC2		SWI3
FBFD F1 74  ;			Placed at : DFC4		SWI2
FBFF F1 B5  ;			Placed at : DFC6		FIRQ
FC01 F1 87  ;			Placed at : DFC8		IRQ
FC03 F1 4E  ;			Placed at : DFCA		SWI
FC05 FF FF  ;			Placed at : DFCC		NMI
FC07 FF FF  ;			Placed at : DFCE		RESET
;
Routine:
;
;	LOAD MIKBUG TAPE
;	----------------
;	Appears to load a Motorola S-record file from the serial port
;	Only S1 and S9 are supported.
;
FC09      86 11          LDA     #$11   ;			turn on paper tape reader (XON)
FC0B      17 01 D1       LBSR    $FDDF  ;			write to serial port
FC0E      7F DF E2       CLR     $DFE2  ;			echo flag turned off
->
FC11      17 01 A1       LBSR    $FDB5  ;			get char (optional echo)
->
FC14  S   81 53          CMPA    #$53   ;			'S'
FC16 &    26 F9          BNE     $FC11  ;			keep going
FC18      17 01 9A       LBSR    $FDB5  ;			get char (optional echo)
FC1B  9   81 39          CMPA    #$39   ;			'9'
FC1D  =   27 3D          BEQ     $FC5C  ;			DONE
FC1F  1   81 31          CMPA    #$31   ;			'1'
FC21 &    26 F1          BNE     $FC14  ;			look for another 'S' record
FC23      17 01 16       LBSR    $FD3C  ;			read byte
FC26 4    34 02          PSHS    A      ;			save it
FC28 )&   29 26          BVS     $FC50  ;			print '?' and DONE
FC2A      17 00 FE       LBSR    $FD2B  ;			read an integer
FC2D )!   29 21          BVS     $FC50  ;			print '?' and DONE
FC2F 4    34 10          PSHS    X      ;			save it on the stack
FC31      E6 E0          LDB     ,S+    ;			the first byte
FC33      EB E0          ADDB    ,S+    ;			add the second byte (the address bytes)
FC35      EB E4          ADDB    ,S     ;			add the very first byte we got (the len byte)
FC37 j    6A E4          DEC     ,S     ;			account for the address we already loaded
FC39 j    6A E4          DEC     ,S     ;			account for the address we already loaded
->
FC3B 4    34 04          PSHS    B      ;			save the partially completed checksum
FC3D      17 00 FC       LBSR    $FD3C  ;			read byte
FC40 5    35 04          PULS    B      ;			get the checksum back
FC42 )    29 0C          BVS     $FC50  ;			print '?' and DONE
FC44 4    34 02          PSHS    A      ;			put the char on the stack
FC46      EB E0          ADDB    ,S+    ;			add to the checksum
FC48 j    6A E4          DEC     ,S     ;			the number of bytes left to read
FC4A      27 05          BEQ     $FC51  ;			zero so completed the row
FC4C      A7 80          STA     ,X+    ;			save the value we read at the address we read
FC4E      20 EB          BRA     $FC3B  ;			keep going on this row
->
FC50 _    5F             CLRB           ;			print '?' and DONE
->
FC51 5    35 02          PULS    A      ;			clean the stack
FC53      C1 FF          CMPB    #$FF   ;		? Ah, is the checksum for the row FF - unlikely!
FC55      27 B2          BEQ     $FC09  ;			load the next S-record (inc turn the tape reader back on)
FC57  ?   86 3F          LDA     #$3F   ;			'?'
FC59      17 01 83       LBSR    $FDDF  ;			write to serial port
->
FC5C s    73 DF E2       COM     $DFE2  ;			switch echo state
FC5F      86 13          LDA     #$13   ;			turn off paper tape reader (XOFF)
FC61   {  16 01 7B       LBRA    $FDDF  ;			write to serial port, DONE
->
Routine:
;
;	PUNCH MIKBUG TAPE
;	-----------------
;
FC64 o    6F E2          CLR     ,-S    ;			create space on the stack
FC66      17 00 B7       LBSR    $FD20  ;			read 2 integers, start (Y) then end (X)
FC69 40   34 30          PSHS    Y,X    ;			save them
FC6B )J   29 4A          BVS     $FCB7  ;			clean up and done
FC6D  b   AC 62          CMPX    $02,S  ;			start == end ?
FC6F %F   25 46          BCS     $FCB7  ;			clean up and done
FC71 0    30 01          LEAX    $01,X  ;			end = end + 1
FC73      AF E4          STX     ,S     ;			put it back
FC75      86 12          LDA     #$12   ;			turn on the paper tape punch
FC77   e  17 01 65       LBSR    $FDDF  ;			write to serial port
->
FC7A      EC E4          LDD     ,S     ;			end address
FC7C  b   A3 62          SUBD    $02,S  ;			start (current) address; d = length
FC7E      27 06          BEQ     $FC86  ;		? Ah, if the start and the end are equal then write another whole row!!!
FC80      10 83 00 20    CMPD    #$0020 ;			number of bytes per S1 record
FC84 #    23 02          BLS     $FC88  ;			we're less so don't use the $20
->
FC86      C6 20          LDB     #$20   ;			number of bytes per S1 record
->
FC88  d   E7 64          STB     $04,S  ;			save the bytes per row value
FC8A      8E FE DE       LDX     #$FEDE ;			"S1"
FC8D      17 01 0E       LBSR    $FD9E  ;			print <cr><lf> then string
FC90      CB 03          ADDB    #$03   ;			add 3 - the address and checksum
FC92      1F 98          TFR     B,A    ;			A=B
FC94      17 00 DB       LBSR    $FD72  ;			print hex byte (the length of the line)
FC97  b   AE 62          LDX     $02,S  ;			current address
FC99      17 00 CE       LBSR    $FD6A  ;			print hex word (the address to write into)
FC9C  b   EB 62          ADDB    $02,S  ;			add the first byte of the current address to the checksum
FC9E  c   EB 63          ADDB    $03,S  ;			add the second byte of the current address to the checksum
->
FCA0      EB 84          ADDB    ,X     ;			add the byte from memory to the checksum
FCA2      A6 80          LDA     ,X+    ;			get from current address
FCA4      17 00 CB       LBSR    $FD72  ;			print hex byte (the byte)
FCA7 jd   6A 64          DEC     $04,S  ;			bytes left to write out
FCA9 &    26 F5          BNE     $FCA0  ;			more bytes left so keep going
FCAB S    53             COMB           ;			complement it - (because the definition of the format says to)
FCAC      1F 98          TFR     B,A    ;			A=B
FCAE      17 00 C1       LBSR    $FD72  ;			print hex byte (the checksum)
FCB1  b   AF 62          STX     $02,S  ;			save the current address
FCB3      AC E4          CMPX    ,S     ;			is the current the end address
FCB5 &    26 C3          BNE     $FC7A  ;			write another S1 record
->
FCB7      86 14          LDA     #$14   ;			turn off paper tape punch
FCB9   #  17 01 23       LBSR    $FDDF  ;			write to serial port
FCBC 2e   32 65          LEAS    $05,S  ;			clean the stack
FCBE 9    39             RTS            ;			DONE
->
Routine:
;
;	PRINT SP REG
;	------------
;
FCBF      8E FE A1       LDX     #$FEA1 ;			"SP="
FCC2      17 00 E9       LBSR    $FDAE  ;			Print String
FCC5  1   1F 31          TFR     U,X    ;			load U (does U == S?)
FCC7      16 00 A0       LBRA    $FD6A  ;			Print hex
->
Routine:
;
;	PRINT US REG
;	------------
;
FCCA      8E FE AD       LDX     #$FEAD ;			"US="
FCCD      17 00 DE       LBSR    $FDAE  ;			Print String
FCD0  H   AE 48          LDX     $08,U  ;			load U
FCD2      16 00 95       LBRA    $FD6A  ;			Print hex
->
Routine:
;
;	PRINT DP REG
;	------------
;
FCD5      8E FE BF       LDX     #$FEBF ;			"DP="
FCD8      17 00 D3       LBSR    $FDAE  ;			Print String
FCDB  C   A6 43          LDA     $03,U  ;			load DP
FCDD      16 00 92       LBRA    $FD72  ;			Print hex
->
Routine:
;
;	PRINT IX REG
;	------------
;
FCE0      8E FE B9       LDX     #$FEB9 ;			"IX="
FCE3      17 00 C8       LBSR    $FDAE  ;			Print String
FCE6  D   AE 44          LDX     $04,U  ;			load X
FCE8      16 00 7F       LBRA    $FD6A  ;			Print hex
->
Routine:
;
;	PRINT IY REG
;	------------
;
FCEB      8E FE B3       LDX     #$FEB3 ;			"IY="
FCEE      17 00 BD       LBSR    $FDAE  ;			Print String
FCF1  F   AE 46          LDX     $06,U  ;			load Y
FCF3  u   20 75          BRA     $FD6A  ;			Print hex
->
Routine:
;
;	PRINT PC REG
;	------------
;
FCF5      8E FE A7       LDX     #$FEA7 ;			"PC="
FCF8      17 00 B3       LBSR    $FDAE  ;			Print String
FCFB  J   AE 4A          LDX     $0A,U  ;			load PC
FCFD  k   20 6B          BRA     $FD6A  ;			Print hex
->
Routine:
;
;	PRINT A REG
;	-----------
;
FCFF      8E FE C5       LDX     #$FEC5 ;			"A="
FD02      17 00 A9       LBSR    $FDAE  ;			Print String
FD05  A   A6 41          LDA     $01,U  ;			load A
FD07  i   20 69          BRA     $FD72  ;			Print hex
->
Routine:
;
;	PRINT B REG
;	-----------
;
FD09      8E FE CA       LDX     #$FECA ;			"B="
FD0C      17 00 9F       LBSR    $FDAE  ;			Print String
FD0F  B   A6 42          LDA     $02,U  ;			load B
FD11  _   20 5F          BRA     $FD72  ;			Print hex
->
Routine:
;
;	PRINT CC REG
;	------------
;
FD13      8E FE CF       LDX     #$FECF ;			"CC="
FD16      17 00 95       LBSR    $FDAE  ;			Print String
FD19      A6 C4          LDA     ,U     ;			load CC
FD1B      8E FE D6       LDX     #$FED6 ;			"EFHINZVCS1"
FD1E  h   20 68          BRA     $FD88  ;			print fancy bit string thing
->
Routine:
;
;	READ 2 INTEGERS
;	---------------
;
FD20      8D 09          BSR     $FD2B  ;			read integer
FD22 )C   29 43          BVS     $FD67  ;			set overflow flag and done
FD24      1F 12          TFR     X,Y    ;			put it in Y
FD26  -   86 2D          LDA     #$2D   ;			'-'
FD28      17 00 B4       LBSR    $FDDF  ;			write byte to serial port
->
Routine:
;
;	READ INTEGER
;	------------
;	read value between 0000-FFFF and return in X
;
FD2B      8D 0F          BSR     $FD3C  ;			read byte
FD2D )8   29 38          BVS     $FD67  ;			set overflow flag and done
FD2F      1F 01          TFR     D,X    ;			store it in X
FD31      8D 09          BSR     $FD3C  ;			read byte
FD33 )2   29 32          BVS     $FD67  ;			set overflow flag and done
FD35 4    34 10          PSHS    X      ;			save partially complete number (high byte)
FD37  a   A7 61          STA     $01,S  ;			save low part
FD39 5    35 10          PULS    X      ;			load complete word
FD3B 9    39             RTS            ;			DONE
->
Routine:
;
;	READ BYTE
;	---------
;	return value between 00-FF (in A) read from the keyboard
;
FD3C      8D 11          BSR     $FD4F  ;			read nibble
FD3E )    29 27          BVS     $FD67  ;			set overflow flag and done
FD40 H    48             ASLA           ;			move to high nibble 
FD41 H    48             ASLA           ;			go
FD42 H    48             ASLA           ;			go
FD43 H    48             ASLA           ;			go
FD44      1F 89          TFR     A,B    ;			store in B
FD46      8D 07          BSR     $FD4F  ;			read nibble
FD48 )    29 1D          BVS     $FD67  ;			set overflow flag and done
FD4A 4    34 04          PSHS    B      ;			put on stack
FD4C      AB E0          ADDA    ,S+    ;			and return in A
FD4E 9    39             RTS            ;			DONE
->
Routine:
;
;	READ NIBBLE
;	-----------
;	return a value between 0-F in A
;
FD4F  d   8D 64          BSR     $FDB5  ;			get char
FD51  0   81 30          CMPA    #$30   ;			cmp "0"
FD53 %    25 12          BCS     $FD67  ;			set overflow flag and done
FD55  9   81 39          CMPA    #$39   ;			cmp "9"
FD57      22 03          BHI     $FD5C  ;			deal with HEX digits
FD59  0   80 30          SUBA    #$30   ;			deal with decimal digits
FD5B 9    39             RTS            ;			DONE
->
FD5C  A   81 41          CMPA    #$41   ;			"A"
FD5E %    25 07          BCS     $FD67  ;			set overflow flag and done
FD60  F   81 46          CMPA    #$46   ;			"F"
FD62      22 03          BHI     $FD67  ;			set overflow flag and done
FD64  7   80 37          SUBA    #$37   ;			convert into a byte
FD66 9    39             RTS            ;			DONE
->
FD67      1A 02          ORCC    #$02   ;			set overflow flag
FD69 9    39             RTS            ;			DONE
->
Routine:
;
;	PRINT HEX WORD
;	--------------
;	Print the value of X as 4 hex digits
;
FD6A 4    34 10          PSHS    X      ;			save X
FD6C 5    35 02          PULS    A      ;			load high byte
FD6E      8D 02          BSR     $FD72  ;			print in hex
FD70 5    35 02          PULS    A      ;			load the low byte and print in hex (fall through)
->
Routine:
;
;	PRINT HEX BYTE
;	---------------
;	Print the value of A as 2 hex digits
;
FD72 4    34 02          PSHS    A      ;			save A
FD74 D    44             LSRA           ;			shift bottom nibble into top nibble 
FD75 D    44             LSRA           ;			keep going
FD76 D    44             LSRA           ;			keep going
FD77 D    44             LSRA           ;			keep goinf
FD78      8D 04          BSR     $FD7E  ;			print high nibble
FD7A 5    35 02          PULS    A      ;			restor A
FD7C      84 0F          ANDA    #$0F   ;			turn top nibble off and print that too
->
Routine:
;
;	PRINT HEX NIBBLE
;	----------------
;
FD7E  0   8B 30          ADDA    #$30   ;			ASCII '0'
FD80  9   81 39          CMPA    #$39   ;			if > '9' then its a hex digit (A-F)
FD82 /    2F 02          BLE     $FD86  ;			write to serial port
FD84      8B 07          ADDA    #$07   ;			HEX character
->
FD86  W   20 57          BRA     $FDDF  ;			write to serial port
->
;
;	PRINT BITS
;	----------
;	X points to bit names
;	S points to byte whose bits are to be printed
;
FD88 4    34 02          PSHS    A      ;			save A
FD8A      C6 08          LDB     #$08   ;			number of bits in a byte
->
FD8C      A6 80          LDA     ,X+    ;			string of the bit names
FD8E h    68 E4          ASL     ,S     ;			examine next bit
FD90 %    25 02          BCS     $FD94  ;			top bit set so print its name
FD92  0   86 30          LDA     #$30   ;			"0" in ascii
->
FD94  I   8D 49          BSR     $FDDF  ;			write A to serial port
FD96  E   8D 45          BSR     $FDDD  ;			write space to serial port
FD98 Z    5A             DECB           ;			next bit
FD99 &    26 F1          BNE     $FD8C  ;			keep going
FD9B 5    35 02          PULS    A      ;			restore A
FD9D 9    39             RTS            ;			DONE
->
Routine:
;
;	PRINT ON NEXT LINE
;	------------------
;
FD9E      8D 02          BSR     $FDA2  ;			print CRLF
FDA0      20 0C          BRA     $FDAE  ;			print string
->
Routine:
;
;	PRINT CRLF
;	----------
;
FDA2 4    34 10          PSHS    X      ;			save X
FDA4   h  8E FE 68       LDX     #$FE68 ;			"<CR><LF>"
FDA7      8D 05          BSR     $FDAE  ;			print string
FDA9 5    35 10          PULS    X      ;			restore X
FDAB 9    39             RTS            ;			DONE
->
;
;	write to serial port and drop through
;
FDAC  1   8D 31          BSR     $FDDF  ;			write to serial port
->
Routine:
;
;	PRINT STRING
;	------------
;	X = address of string to print
;
FDAE      A6 80          LDA     ,X+    ;			Get character
FDB0      81 04          CMPA    #$04   ;			is if a $04 (end of string)
FDB2 &    26 F8          BNE     $FDAC  ;			write char to serial port
FDB4 9    39             RTS            ;			DONE
->
Routine:
;
;	GET CHAR AND OPTIONAL ECHO
;	--------------------------
;
FDB5 }    7D DF E2       TST     $DFE2  ;			check the echo flag
FDB8      27 06          BEQ     $FDC0  ;			get char (without echo)
->
Routine:
;
;	GET CHAR AND ECHO
;	-----------------
;
FDBA      8D 04          BSR     $FDC0  ;			get character
FDBC      84 7F          ANDA    #$7F   ;			turn top bit off (make ASCII)
FDBE      20 1F          BRA     $FDDF  ;			write to serial port
->
Routine:
;
;	GET CHAR
;	--------
;	read from the current serial port and return in A
;
FDC0 4    34 10          PSHS    X      ;			save X
FDC2      BE DF E0       LDX     $DFE0  ;			current serial port
->
FDC5      A6 84          LDA     ,X     ;			load status register
FDC7      85 01          BITA    #$01   ;			data ready to be read
FDC9      27 FA          BEQ     $FDC5  ;			no so wait
FDCB      A6 01          LDA     $01,X  ;			else load A from data register
FDCD 5    35 10          PULS    X      ;			restore X
FDCF 9    39             RTS            ;			DONE
->
Routine:
;
;	DATA READY
;	----------
;	is there data in the serial port's buffer ready to be read?
;
FDD0 4    34 02          PSHS    A      ;			save A
FDD2      A6 9F DF E0    LDA     [$DFE0];			serial port status register
FDD6      85 01          BITA    #$01   ;			data ready to be read
FDD8 5    35 02          PULS    A      ;			restore A
FDDA 9    39             RTS            ;			DONE
->
Routine:
;
;	WRITE 2 SPACES TO SERIAL PORT
;	-----------------------------
;
FDDB      8D 00          BSR     $FDDD  ;			write space to serial port (twice)
->
Routine:
;
;	WRITE SPACE TO SERIAL PORT
;	--------------------------
;
FDDD      86 20          LDA     #$20   ;			write space to serial port
->
Routine:
;
;	WRITE TO SERIAL PORT
;	--------------------
;	A = byte to write
;
FDDF 4    34 12          PSHS    X,A    ;			save X and A
FDE1      BE DF E0       LDX     $DFE0  ;			X = address of serial port command register
->
FDE4      A6 84          LDA     ,X     ;			load from status register
FDE6      85 02          BITA    #$02   ;			transmit data register empty
FDE8      27 FA          BEQ     $FDE4  ;			wait
FDEA 5    35 02          PULS    A      ;			restore A
FDEC      A7 01          STA     $01,X  ;			store it in the data port
FDEE 5    35 10          PULS    X      ;			restore X
FDF0 9    39             RTS            ;			DONE
->
Routine:
;
;	INIT SERIAL PORT
;	----------------
;
FDF1      BE DF E0       LDX     $DFE0  ;			address of serial port
FDF4      86 03          LDA     #$03   ;			reset the serial port
FDF6      A7 84          STA     ,X     ;			serial port control register
FDF8      86 11          LDA     #$11   ;			8 bits, 2 stop bits, clock divide by 16
FDFA      A7 84          STA     ,X     ;			serial port control register
FDFC m    6D 01          TST     $01,X  ;			data register
FDFE      86 FF          LDA     #$FF   ;			set echo on
FE00      B7 DF E2       STA     $DFE2  ;			Echo flag
FE03 9    39             RTS            ;			DONE
->
;
;	MONITOR COMMAND Branch table
;	----------------------------
;
FE04 01 F9 42 			; ^A alter A
FE07 02 F9 34 			; ^B alter B
FE0A 03 F9 50 			; ^C alter CC
FE0D 04 F9 26 			; ^D alter DP
FE10 10 F8 EE 			; ^P alter PC
FE13 15 F8 FC 			; ^U alter U
FE16 18 F9 18 			; ^X alter X
FE19 19 F9 0A 			; ^Y alter Y
FE1C 42 FA A8 			; B Set brkpnt ADDR (upto 5).
FE1F 44 FB 21 			; D bootdisk (GO TO RESET/PWR-UP).
FE22 45 F9 BB 			; E dump mem blk  BEG-END.
FE25 47 F8 A6 			; G go from curr PC.
FE28 4C FC 09 			; L load mikbug tape.
FE2B 4D F9 66 			; M	mem exam chg ADDR (Quit=CR, Back=^, Forw=ANYOTHER).
FE2E 50 FC 64 			; P punch mikbug tape.
FE31 51 FA 1F 			; Q tst mem BEG-END Not>DF00.
FE34 52 F8 A9 			; R disp reg +4 byte starting at curr PC.
FE37 53 F9 AF 			; S disp stack to DFC0.
FE3A 5A FB 31 			; Z	disp active brkpnt
FE3D 58 FA D4 			; X	clr all brkpnts.
FE40 41 F2 13 			; A compute addr BEG-END NEW or END-BEG NEW.
FE43 43 F1 B6 			; C	compare mem blks BEG-BEG.
FE46 48 FB B9 			; H	disp byte in bin BYTE.
FE49 4B F2 B3 			; K	set mem blk BEG-END BYTE.
FE4C 13 F2 48 			; ^S alter S (actually, copies a block of memory)
FE4F 49 FB 55 			; I	instruct.
;
FE52 00 00 00 0D 0A 00 00 00 50 2D 42 55 47 20 30 2E 35 20 2D 20 04 	; P-BUG 0.5 - 
;
FE67 4B 0D 0A 00 00 00 04 												; K
;
FE6E 3E 04																; >
;
FE70 57 48 41 54 3F 04													; WHAT?
;
FE76 20 2D 20 04 														; -
;
FE7A 2C 20 50 41 53 53 20 04	 										; , PASS
;
FE82 2C 20 42 49 54 53 20 49 4E 20 45 52 52 4F 52 3A 20 04 				; , BITS IN ERROR:
;
FE94 20 3D 3E 20 04 													; =>
;
FE99 37 36 35 34 33 32 31 30 			 								; 76543210
;
FEA1 20 20 53 50 3D 04 													; SP=
;
FEA7 20 20 50 43 3D 04 													; PC=
;
FEAD 20 20 55 53 3D 04 													; US=
;
FEB3 20 20 49 59 3D 04 													; IY=
;
FEB9 20 20 49 58 3D 04 													; IX= 
;
FEBF 20 20 44 50 3D 04		 											; DP=
;
FEC5 20 20 41 3D 04 													; A= 
;
FECA 20 20 42 3D 04 													; B=
;
FECF 20 20 43 43 3A 20 04 												; CC=
;
FED6 45 46 48 49 4E 5A 56 43 				      						; EFHINZVC
;
FEDE 53 31 04           												; S1
;
->
Interrupt Vector:Reset NMI 
;
;	COLD BOOT
;	---------
;
FEE1      10 CE DF C0    LDS     #$DFC0 ;			Load the stack with DFC0
FEE5      7F DF FA       CLR     $DFFA  ;			clear extended monitor command table address
FEE8      7F DF FB       CLR     $DFFB  ;			clear extended monitor command table address
FEEB      8E FB F9       LDX     #$FBF9 ;			interrupt table
FEEE      8D 06          BSR     $FEF6  ;			warm boot
FEF0 ~ <  7E F0 3C       JMP     $F03C  ;			boot from disk
->
Routine:
FEF3      8E FB E9       LDX     #$FBE9 ;			Interrupt table
->
Routine:
;
;	WARM BOOT
;	---------
;
FEF6 5    35 20          PULS    Y      ;			get the return address
FEF8      10 BF DF F8    STY     $DFF8  ;			store that (reused on exit)
FEFC      10 FF DF F6    STS     $DFF6  ;			store the old stack address (reused on exit)
FF00      10 CE DF C0    LDS     #$DFC0 ;			reset the stack address to DFC0
FF04 4    34 10          PSHS    X      ;			address of interrupt table
FF06      8E D0 A0       LDX     #$D0A0 ;			this is "basicly" the top memory address we'll check to see if the RAM is there
FF09      1F 10          TFR     X,D    ;			D = D0A0
FF0B C    43             COMA           ;			A = 11010000 -> 0010 1111 ($2F)
FF0C D    44             LSRA           ;			examine low nibble
FF0D D    44             LSRA           ;			more
FF0E D    44             LSRA           ;			more
FF0F D    44             LSRA           ;			more	A = 0000 0010 ($02)
FF10      10 8E DF D0    LDY     #$DFD0 ;			memory page exists table
FF14  -   A7 2D          STA     $0D,Y  ;			DFDD = 02		the D000s exist
FF16 o.   6F 2E          CLR     $0E,Y  ;			DFDE = 00		the E000s do not exist
FF18      86 F0          LDA     #$F0   ;			the page is ROM
FF1A  /   A7 2F          STA     $0F,Y  ;			DFDF = F0		the F000s are ROM
FF1C      86 0C          LDA     #$0C   ;			starting address (DFDC, we already did D,E, and F)
->
FF1E o    6F A6          CLR     A,Y    ;			Clear everything from DFDC to DFD0 (the RAM interrupt table)
FF20 J    4A             DECA           ;			A = A  - 1
FF21 *    2A FB          BPL     $FF1E  ;			keep going until done
->
FF23 0    30 89 F0 00    LEAX    $F000,X;			memory test counting downwards
FF27      8C F0 A0       CMPX    #$F0A0 ;			compate to F0A0 (have we wrapped around?)
FF2A      27 22          BEQ     $FF4E  ;			end of memory test
FF2C      EE 84          LDU     ,X     ;			load what was as X
FF2E   U  10 8E 55 AA    LDY     #$55AA ;			0101010110101010 (check every second bit)
FF32      10 AF 84       STY     ,X     ;			write the test pattern
FF35      10 AC 84       CMPY    ,X     ;			check it worked
FF38 &    26 E9          BNE     $FF23  ;			if not then move on to the next page (downwards)
FF3A      EF 84          STU     ,X     ;			put X back
FF3C      10 8E DF D0    LDY     #$DFD0 ;			memory exists table
FF40      1F 10          TFR     X,D    ;			D = X (current memchecked address)
FF42 D    44             LSRA           ;			take the top nibble of the address (page number)
FF43 D    44             LSRA           ;			again
FF44 D    44             LSRA           ;			again
FF45 D    44             LSRA           ;			again
FF46      1F 89          TFR     A,B    ;			B=A, the $x000 number of a page that exists
FF48      88 0F          EORA    #$0F   ;			A is now the complement of n in the $n000 page number
FF4A      A7 A5          STA     B,Y    ;			(DFD0 + page) = ~n
FF4C      20 D5          BRA     $FF23  ;			more pages to check
->
FF4E      86 F1          LDA     #$F1   ;			the page is ROM (actually, peripherals)
FF50      10 8E DF D0    LDY     #$DFD0 ;			memory exists table
FF54  .   A7 2E          STA     $0E,Y  ;			DFDE = F1
FF56      86 0C          LDA     #$0C   ;			for pages from 0 to C
->
FF58      E6 A6          LDB     A,Y    ;			search from DFDC to DFD0 until it finds a non-zero
FF5A &    26 05          BNE     $FF61  ;			found the highest page numner that exists so move on
FF5C J    4A             DECA           ;			next
FF5D *    2A F9          BPL     $FF58  ;			keep looking
FF5F      20 14          BRA     $FF75  ;			we're at end of the memory so move on
->
FF61 o    6F A6          CLR     A,Y    ;			mark the page in the page table as unused!
FF63  ,   E7 2C          STB     $0C,Y  ;			what was in the page table gets placed at DFDC
FF65 O    4F             CLRA           ;			A = 0
FF66  !   1F 21          TFR     Y,X    ;			X = DFD0
->										;			this removes blank pages from the page table
FF68      E6 A6          LDB     A,Y    ;			current entry in page table
FF6A      27 04          BEQ     $FF70  ;			zero so move on
FF6C o    6F A6          CLR     A,Y    ;			clear then entry in page table
FF6E      E7 80          STB     ,X+    ;			store lower down in the page table
->
FF70 L    4C             INCA           ;			move on to the next page
FF71      81 0C          CMPA    #$0C   ;			are we at the last page
FF73 -    2D F3          BLT     $FF68  ;			more
->
FF75      C6 FF          LDB     #$FF   ;			set echo on
FF77      F7 DF E2       STB     $DFE2  ;			store in echo flag
FF7A 5    35 10          PULS    X      ;			address of interrupt table
FF7C      10 8E DF C0    LDY     #$DFC0 ;			RAM interrupt table
FF80      C6 10          LDB     #$10   ;			10 bytes of data
->
FF82      A6 80          LDA     ,X+    ;			get the first byte
FF84      A7 A0          STA     ,Y+    ;			save it at Y
FF86 Z    5A             DECB           ;			number of bytes left to copy
FF87 &    26 F9          BNE     $FF82  ;			copy more
FF89      8E E0 04       LDX     #$E004 ;			address of serial port
FF8C      BF DF E0       STX     $DFE0  ;			store as current serial port
FF8F   B  17 FB 42       LBSR    $FAD4  ;			clear all breakpoints
FF92      C6 0C          LDB     #$0C   ;			remove 12 bytes from the stack
->
FF94 o    6F E2          CLR     ,-S    ;			zero
FF96 Z    5A             DECB           ;			B=B-1
FF97 &    26 FB          BNE     $FF94  ;			more to go
FF99 0  w 30 8D F8 77    LEAX    $F877,PC;			P-BUG entry point ($F814)
FF9D  j   AF 6A          STX     $0A,S  ;			PC after an RTI
FF9F      86 D0          LDA     #$D0   ;			push all, ignore FIRQ, ignore IRQ
FFA1      A7 E4          STA     ,S     ;			CC after an RTI
FFA3  C   1F 43          TFR     S,U    ;			U=S
FFA5   I  17 FE 49       LBSR    $FDF1  ;			init serial port
FFA8      10 FE DF F6    LDS     $DFF6  ;			S on entry to this routine
FFAC      BE DF F8       LDX     $DFF8  ;			PC on entry to this routine
FFAF 4    34 10          PSHS    X      ;			put it on the stack as the return address
FFB1 9    39             RTS            ;			DONE
->
Interrupt Vector:Reserved
FFB2 n    6E 9F DF C0    JMP     [$DFC0];			soft vector
->
Interrupt Vector:SWI2 
FFB6 n    6E 9F DF C4    JMP     [$DFC4];			soft vector
->
Interrupt Vector:FIRQ 
FFBA n    6E 9F DF C6    JMP     [$DFC6];			soft vector
->
Interrupt Vector:IRQ 
FFBE n    6E 9F DF C8    JMP     [$DFC8];			soft vector
->
Interrupt Vector:SWI 
FFC2 n    6E 9F DF CA    JMP     [$DFCA];			soft vector
->
Interrupt Vector:SWI3 
;
;	Call one of the other interrupts (B is which one) according to the RAM interrupt vector table.
;
FFC6  C   1F 43          TFR     S,U    ;			U = S
FFC8  J   AE 4A          LDX     $0A,U  ;			X = PC (before interrupt)
FFCA      E6 80          LDB     ,X+    ;			get the next byte (command code)
FFCC  J   AF 4A          STX     $0A,U  ;			put PC back (after skipping command byte)
FFCE O    4F             CLRA           ;			A = 0
FFCF X    58             ASLB           ;			B = B * 2
FFD0 I    49             ROLA           ;			16 bit multiply B by 2
FFD1      BE DF CC       LDX     $DFCC  ;			RAM NMI vector address
FFD4      8C FF FF       CMPX    #$FFFF ;			is it FFFF (un-used)
FFD7      27 0F          BEQ     $FFE8  ;			exit via a RAM SWI3
FFD9 0    30 8B          LEAX    D,X    ;			add D to X
FFDB      8C DF CE       CMPX    #$DFCE ;			RAM reset vector address
FFDE      22 08          BHI     $FFE8  ;			exit via a RAM SWI3
FFE0 4    34 10          PSHS    X      ;			store the address onto the stack
FFE2  A   EC 41          LDD     $01,U  ;			D before the SWI3
FFE4  D   AE 44          LDX     $04,U  ;			X before the SWI3
FFE6 n    6E F1          JMP     [,S++] ;			jump there
->
FFE8 7    37 1F          PULU    X,DP,D,CC;			clean up the stack
FFEA  B   EE 42          LDU     $02,U  ;			restore U to where it was before the SWI3
FFEC n    6E 9F DF C2    JMP     [$DFC2];			RAM SWI3 vector
->
FFF0 FF B2 ; Reserved
->
FFF2 FF C6 ; SWI3
->
FFF4 FF B6 ; SWI2
->
FFF6 FF BA ; FIRQ
->
FFF8 FF BE ; IRQ
->
FFFA FF C2 ; SWI
->
FFFC FE E1 ; NMI
->
FFFE FE E1 ; Reset
