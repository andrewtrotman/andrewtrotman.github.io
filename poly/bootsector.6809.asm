;
;	POLY BOOT SECTOR
;	----------------
;	Commented Dissassembly by Andrew Trotman andrew@cs.otago.ac.nz
;
;	Western Digital Equates!!!
;	E014: $40 if on size 1 of disk of $00 if on side 2
;	E018: command register		(COMMAND REGISTER)
;	E019: track register		(TRACK REGISTER)
;	E01A: sector to read		(SECTOR REGISTER)
;	E01B: track number to read	(DATA REGISTER)
;
;
Routine:
C100      86 E0          LDA     #$E0   ;			DP will be set of $E0
C102  (   20 28          BRA     $C12C  ;			Skip over the text
->
C104 20 
;
C105 01 								;			FLEX OS Track  Start
C106 01 								;			FLEX OS Sector Start
;
C107 0F 02 0E 2D 20 54 48 49 53 20 44 49 53  ..- THIS DIS   ;
C114 4B 20 48 41 53 20 4E 4F 54 20 42 45 45 4E 20 4C K HAS NOT BEEN L   ;
C124 49 4E 4B 45 44 0D 0A 00                         INKED...           ;
->
C12C      1F 8B          TFR     A,DP   ;			DP = $E0
->
C12E      86 0B          LDA     #$0B   ;			set the low bit
C130      B7 E0 18       STA     $E018  ;			and store at E018
C133      17 00 96       LBSR    $C1CC  ;			Pause 51 clock cycles
C136      17 00 98       LBSR    $C1D1  ;			Wait for E018 to have the low bit set (which will be immediately)
C139  B   8D 42          BSR     $C17D  ;

;
;	FILE LOAD
;	---------
;	This appears to be taken almost directly from the
;	FLEX addaptation guide example for SWTPc (see page 87 of manual)
;	
;LOAD 1:
;
C13B  7   8D 37          BSR     $C174  ;			get a character
C13D      81 02          CMPA    #$02   ;			data record header?
C13F      27 10          BEQ     $C151  ;			skip if so
C141      81 16          CMPA    #$16   ;			xfer address header?
C143 &    26 F6          BNE     $C13B  ;			loop if neither
C145  -   8D 2D          BSR     $C174  ;			get transfer address (byte 1)
C147      A7 E3          STA     ,--S   ;			store on stack
C149  )   8D 29          BSR     $C174  ;			get transfer address (byte 2)
C14B  a   A7 61          STA     $01,S  ;			store on stack
C14D O    4F             CLRA           ;			DP will be zero
C14E      1F 8B          TFR     A,DP   ;			set DP=00
C150 9    39             RTS            ;			DONE (jump to address from down the line)
;
;LOAD 2:
;
C151  !   8D 21          BSR     $C174  ;			get character
C153      A7 E3          STA     ,--S   ;			store on stack
C155      8D 1D          BSR     $C174  ;			get another character
C157  a   A7 61          STA     $01,S  ;			store on stack
C159 5    35 20          PULS    Y      ;			get the address
C15B      8D 17          BSR     $C174  ;			get character
C15D      1F 89          TFR     A,B    ;			put in B
C15F M    4D             TSTA           ;			check a
C160      27 D9          BEQ     $C13B  ;			loop if count = 0
;
;LOAD 3:
;
C162 4    34 04          PSHS    B      ;			save B
C164      8D 0E          BSR     $C174  ;			get character
C166 5    35 04          PULS    B      ;			restore B
C168      A7 A0          STA     ,Y+    ;			put charcter
C16A Z    5A             DECB           ;			end of data in record
C16B &    26 F5          BNE     $C162  ;			loop if not
C16D      20 CC          BRA     $C13B  ;			get another record
->
C16F      FC C1 00       LDD     $C100  ;			First two bytes of the sector (is this part of the chaining method?)
C172      8D 10          BSR     $C184  ;
					;			Fall through to return first byte of new sector
->
Routine:
;
;	GET_CHARACTER
;	-------------
;	return next character from the transfer (in S)
;
C174      11 83 C2 00    CMPU    #$C200 ;			check stack address to see if we are at end of buffer
C178      27 F5          BEQ     $C16F  ;			yes we are so load another sector
C17A      A6 C0          LDA     ,U+    ;			get next byte and return in A
C17C 9    39             RTS            ;			DONE
->
Routine:
C17D      EC 8C 85       LDD     $-7B,PC;			Yikes! $C105, the track number in A the sector number in B
C180 &    26 02          BNE     $C184  ;			non zero so we continue
->
C182      20 FE          BRA     $C182  ;			Yikes!  Hang!  Shouldn't this print a message and then hang?
->
Routine:
C184  %   8D 25          BSR     $C1AB  ;			Seek to track
C186      86 88          LDA     #$88   ;			command $88 (is this a read?)
C188      B7 E0 18       STA     $E018  ;			issue the command
C18B  ?   8D 3F          BSR     $C1CC  ;			Delay
C18D _    5F             CLRB           ;			get the sector length (=256)
C18E      8E C1 00       LDX     #$C100 ;			pointer to sector buffer (C100)
C191      20 05          BRA     $C198  ;			read more data from the disk
->
C193      B6 E0 1B       LDA     $E01B  ;			track number
C196      A7 80          STA     ,X+    ;			copy into beginning of C100 buffer
->
WD STATUS?
->
C198      F6 E0 18       LDB     $E018  ;			load from E018
C19B      C5 02          BITB    #$02   ;			check data request flag for data ready (AND with 02)
C19D &    26 F4          BNE     $C193  ; 		nope - we have data so get the next byte
C19F      C5 01          BITB    #$01   ;			check the busy flag (AND with 01)
C1A1 &    26 F5          BNE     $C198  ; 		nope - we are executing a command so wait until we're done
C1A3      C5 1C          BITB    #$1C   ;			check bits 1C (AND with 1C)
C1A5 &    26 87          BNE     $C12E  ;		nope  - an error has occurred (CRC error, etc) 
C1A7      CE C1 04       LDU     #$C104 ;			set the USER stack to C104 (skip over the sector chain and point to the sector's data)
C1AA 9    39             RTS            ;			DONE
->

;
;	SET_TRACK_SECTOR (SEEK)
;	-----------------------
;	store the track and sector number to read in E01A and E01B and
;	store which side of the disk we're on in E014
;	finally fall through to the RTS
;
C1AB      F7 E0 1A       STB     $E01A  ;			sector number
C1AE      C1 10          CMPB    #$10   ;			is it on side 2 of the disk
C1B0      C6 00          LDB     #$00   ;			set it to zero (size 1 of disk)
C1B2 %    25 02          BCS     $C1B6  ;			branch if higher or same (as #$10)
C1B4  @   C6 40          LDB     #$40   ;			$40 for side 2 of disk
->
C1B6      F7 E0 14       STB     $E014  ;			store which side of the disk we are going to use
C1B9      B1 E0 19       CMPA    $E019  ;		????
C1BC '    27 0E          BEQ     $C1CC  ;			Pause 49 clock cycles
C1BE      B7 E0 1B       STA     $E01B  ;			track number to read
C1C1      8D 09          BSR     $C1CC  ;			Pause 49 clock cycles
C1C3      86 1B          LDA     #$1B   ;			A=#$1B (low bit set)
C1C5      B7 E0 18       STA     $E018  ;			store it in the low bit set checker
C1C8      8D 02          BSR     $C1CC  ;			Pause 49 clock cycles
C1CA      8D 05          BSR     $C1D1  ;			Wait for E018 (it should finish immediately)
										;			Fall though (wait 42 and return)
;
;	WAIT_49
;	-------
; 	a BSR to here wastes 49 clock cycles
;		
;
C1CC      8D 00          BSR     $C1CE  ;
C1CE      8D 00          BSR     $C1D0  ;
C1D0 9    39             RTS            ;			DONE (49 clock cycles wastes)

;
;	WAIT_E018
;	---------
;	Wait until the first bit of E018 is set
;	it must be set by an interrupt somewhere
;
C1D1      F6 E0 18       LDB     $E018  ;			load E018
C1D4      C5 01          BITB    #$01   ;			check it
C1D6 &    26 F9          BNE     $C1D1  ;			if NE then try again
C1D8 9    39             RTS            ;			DONE
->
