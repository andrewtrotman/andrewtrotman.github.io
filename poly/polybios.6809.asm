
;
;	POLY BIOS
;	---------
;	Commented Dissassembly by Andrew Trotman andrew@cs.otago.ac.nz
;
; D = AB (A is High, B is Low)
;
;
; DP MAP (DP=EB00)
;
; C0-C1		ADDRESS OF THE SCREEN CONTROL BLOCK
; C2		IF 0 THEN PRINTING THE BELL CHARACTER IS SILENT
; C4		***** dunno *****
; C3		***** was the last chatacter pressed other than a space? *****
; D0		***** something to do with key presses? *****
; D4		***** number of bytes to read from network? *****
; C2		***** if true the mute the bell and other sounds *****
; C3		***** dunno *****
; C4		***** dunno *****
; C5		***** dunno *****
; C6		***** dunno *****
; C7		IF ONE OF A SET OF SPECIAL NON-ALPAHBETICAL MASKABLE CHARATERS ARE PRESSED (used at F9AF)
; C8		***** something to do with the E000 stuff and the keyboard *****
; C9		OVER-RIDE SWI AND CALL [] INSTEAD
; CB		WAS THE LAST KEY PRESS A CHARACTER $16
; CC		WAS THE LAST KEY PRESS A CHARACTER $17
; CD		if non-zero the display cursor when reading from keyboard
; CE		PAUSE key flag (WAS THE LAST KEY PRESS A CHARACTER $1C)
; CF		interrupt in IRQ was caused by the timer
; D0		1 when a key has been pressed but not read
; D1		EXIT key flag (WAS THE LAST KEY PRESS A CHARACTER $1A)
; D4		***** dunno *****
; E1		3 byte integer, number of 100ths of a second since power up
; E2		3 byte integer, number of 100ths of a second since power up
; E3		3 byte integer, number of 100ths of a second since power up
; E5		***** dunno *****
; E6		RTS control mode for the network
; E7		***** network bytes remaining to read? *****
; E9-EA		address of end of network read buffer
; EB		LAST KEY PRESS
; EC		0 IF A KEY HAS BEEN PRESSED?  (***** is this a key has been read from buffer tag? *****)
; ED		***** number of bytes read from network? *****
; EE		***** something to do wiht network *****
; EF		***** address byte from network *****
; F0		***** reset to 0 on initialise network read? *****
; F1		***** something to do with network errors? *****
; F3-F4		TIMEOUT FOR AUTOREPEAT ON KEY PRESS (LONG PAUSE THEN FAST REPEAT)
; F5-F6		where the next byte of network data is to be stored after a read (pointer to network buffer)
; F7-F8		pointer to start of network read buffer
; F9-FA		***** dunno, but S is stored here sometimes
;
;
; MEMORY MAP
; A000 - ???? ***** ROM BASIC? *****
; C400 - C500 ***** network read address on boot? *****
; DFCC - DFCD HOLDS ADDRESS OF WHERE TO BRANCH TO ON KEY $1A BEING PRESSED
; DFD0 - DFD1 HOLDS ADDRESS OF WHERE TO BRANCH ON A REPROGRAMMABLE KEY BEING PRESSED (B HOLD THE KEY ID)
; DFD4 - DFD5 HOLDS ADDRESS OF WHERE TO BRANCH TO ON KEY $16 BEING PRESSED
; DFD6 - DFD7 HOLDS ADDRESS OF WHERE TO BEANCH TO ON KEY $17 BEING PRESSED
; DFDC - DFDD HOLDS THE ADDRESS OF WHERE TO BRANCH ON SWI IF DP$C9 IS NON-ZERO
; DFDE - DFE7 CONTROL CHARACTER LOOKUP TABLE USED AT F97F ***** are these the user programmable functin keys? *****
; DFE8 - DFEB SOMETHING TO DO WITH CHARACTERS AND KEYBOARDS USED AT F9A5 (IS THIS ONLY 4 BYTES LONG?)
; DFEC - DFED RAM VERSION OF SWI BRANCH TABLE (TABLE OF WORDS).  USE IS SWI <BYTE> WHERE <BYTE> IS THE TABLE LOOKUP ADDRESS
; DFF6 - ***** is it some kind of keyboard buffer? *****
; E00E - E00F KEYBOARD STROBE (6821 port B)
; E020 - E028 The timer chip (6840)
; E030 - E038 Network chip (6854)
; E040   
; E800 - EBBF TEXT SCREEN 1
; E8A0 - ***** Keyboard input buffer from BASIC interpreter? *****
; EB00 - EBFF ROM Demand Page
; EC00 - EFBF TEXT SCREEN 2
; EFE4 - EFE5 ***** something keyboard SWI function 1 ***** 
; EFE6 - EFE7 ***** something keyboard SWI function 1 ***** 
; EFC0 SCREEN CONTROL BLOCK 1
; EFD0 SCREEN CONTROL BLOCK 2 ???
; EFDE - EFDF pointer to routine to handle the next incoming byte from the network 
; EFE0 - EFE1
; F000 - FFFF BIOS ROM
;

;
; BETWEEN E000 AND F000 THERE'S A GAP THAT INCLUDED THE TEXT PAGE AND A NUMBER
; OF BOOT ROM PARAMETERS
;

;================================================================================
;
; BOOT ROM
;
;================================================================================
->
Routine:
F000      8E F0 1D       LDX     #$F01D ;				where to read from
->
Routine:
F003      10 8E E0 00    LDY     #$E000 ;				where to write to
->
F007      EC 81          LDD     ,X++   ;				get next two bytes
F009      E7 A6          STB     A,Y    ;				*(Y+A)=B
F00B   K  8C F0 4B       CMPX    #$F04B ;				at the end address yet?
F00E %    25 F7          BCS     $F007  ;				nope, so do more
F010 9    39             RTS            ;				done
->
;
; Network controllor (6854) is at $E030
;
F011 30 C1	;		control register 1 (reset Tx, reset Rx, C1b0=1)
F013 32 A8	;		control register 3 (go online, loop mode, use 01 on idle)
F015 36 1E	;		control register 4 (word length 8 bits (both transmit and recieve))
F017 30 C0	;		control register 1 (reset Tx, reset Rx, C1b0=0)
F019 32 81	;		control register 2 (use RTS! pin, prioritise the status bits)
F01B 30 03	;		control register 1 (enable interrupt, C1b0=1)
->
;
; The "Other" I/O port (6821) is at $E000 - $E004		(graphics)
;
F01D 01 00	; CRA = 00
F01F 03 00 	; CRB = 00
F021 00 FF 	; DDA = FF
F023 02 FF 	; DDB = FF
F025 01 04 	; CRA = 04
F027 03 04 	; CRB = 04
F029 00 0E 	; OUTA = 0E
F02B 02 0C	; OUTB = 0C
;
; Keyboard I/O (6821) is at $E00C-$E00F
; Port A is not used.  Port B is the keyboard
; E00F is the 12/24 line teletext display
;
F02D 0F 00 	;		control register B  (select data direction register at $E00E)
F02F 0E 00 	;		data direction register B	(all 8 lines are for input)
F031 0D 3C 	;		control register A (0011 1100) (CA2 is output which goes high as CPU writes b3 of control register, output register selected)
F033 0F 3F 	;		control reguster B (0011 1111) (CB2 is output which goes high as CPU writes b3 of control register, output register selected, enable IRQB on low to high on pin CB1)
;
; Timer (6840) is at $E020-$E027
;
F035 21 00	;		control register 2 = 00
F037 20 00 	;		control register 3 = 00
F039 21 01 	;		control register 2 = 01 (write to control register 1)
F03B 20 40	;		control register 1 = 40 (timer 1 should interrupt using IRQ)
F03D 21 82 	;		control register 2 = 82 (output on pin O, use Enable clock)
F03F 22 00 	;		MSB for timer 1
F041 23 63 	;		LSB for timer 1		(0063) Interrupt once a second
F043 24 13 	;		MSB for timer 2
F045 25 9F 	;		LSB for timer 2		(139F)
;
; The "Other" I/O port (6821) is at $E000 - $E004 (this is the graphics screens)
;
F047 04 03 
F049 04 11
->
Interrupt Vector:Reset 
F04B      10 CE F0 00    LDS     #$F000 ;						SET STACK POINTER TO $F000
F04F      86 EB          LDA     #$EB   ;						FOR LOADING DP VIA A
F051      1F 8B          TFR     A,DP   ;						SET DP TO $EB00
F053      8E E8 00       LDX     #$E800 ;						START ADDRESS
F056 O    4F             CLRA           ;						STORE 0
->
F057      A7 80          STA     ,X+    ;						WHERE X IS 
F059      8C F0 00       CMPX    #$F000 ;						UNTIL WE GET TO $F000
F05C %    25 F9          BCS     $F057  ;						THIS AS CLEARED $E800-$F000
F05E      8E F0 11       LDX     #$F011 ;						initialise the network controller
F061      8D A0          BSR     $F003  ;						go do it
F063      86 80          LDA     #$80   ;						load 80
F065      97 E6          STA     $E6    ;(DP$E6);				DP$E6 = $80		RTS mode
F067      B6 E0 04       LDA     $E004  ;						READ FROM STATUS OF SERIAL PORT
F06A      81 02          CMPA    #$02   ;						CMP 0x02
F06C '    27 06          BEQ     $F074  ;						logoff
F06E      81 08          CMPA    #$08   ;						CMP 0x08
F070 '    27 02          BEQ     $F074  ;						logoff
F072      0C E4          INC     $E4    ;(DP$E4);				after some point in the initialisation
->
;
;
;Routine:
;
; SWI FUNCTION 2D: Logoff
;
;
F074      1A 10          ORCC    #$10   ;
F076   #  8E FF 23       LDX     #$FF23 ;						memory map 1
F079    P 10 8E E0 50    LDY     #$E050 ;
F07D   9  BD F8 39       JSR     $F839  ;
F080      BD F8 11       JSR     $F811  ;
F083      BD F8 09       JSR     $F809  ;
F086      10 CE DF B0    LDS     #$DFB0 ;						MOVE STACK POINTER TO $DFB0
F08A      8E E8 00       LDX     #$E800 ;						START OF TEXT PAGE
F08D      CE EB BF       LDU     #$EBBF ;						MOVE USER STACK TO $EBBF
F090      10 8E EF C0    LDY     #$EFC0 ;						LOAD ADDRESS OF SCREEN CONTROL BLOCK
F094      10 9F C0       STY     $C0    ;(DP$C0);				AND STORE ON DP
F097 _    5F             CLRB           ;
->
F098      AF A1          STX     ,Y++   ;						$00,Y / $01,Y = $E800	THEN $EC00		START OF SCREEN
F09A      EF A1          STU     ,Y++   ;						$02,Y / $03,Y = $EBBF	THEN $EFBF		END OF SCREEN
F09C      AF A1          STX     ,Y++   ;						$04,Y / $05,Y = $E800	THEN $EC00		START OF SCREEN
F09E      EF A1          STU     ,Y++   ;						$06,Y / $07,Y = $EBBF	THEN $EFBF		END OF SCREEN
F0A0      86 17          LDA     #$17   ;						NUMBER OF ROWS (MINUS 1)
F0A2      A7 A0          STA     ,Y+    ;						$08,Y = 23 ($17)		THAT IS, 24 ROWS
F0A4      86 06          LDA     #$06   ;						CLEAR THE REST OF THE BLOCK
->
F0A6 o    6F A0          CLR     ,Y+    ;						$09,Y - $0E,Y = 00 ($00)
F0A8 J    4A             DECA           ;						COUNTING DOWN
F0A9 &    26 FB          BNE     $F0A6  ;						AND KEEP GOING UNTIL $0E
F0AB ]    5D             TSTB           ;						DO IT FOR EACH SCREEN CONTROL BLOCK (TWICE)
F0AC &    26 09          BNE     $F0B7  ;						DONE AFTER THE SECOND TIME
F0AE      8E EC 00       LDX     #$EC00 ;						AND THE SECOND SCREEN IS AT $EC00
F0B1      CE EF BF       LDU     #$EFBF ;						ENDING AT $EFBF
F0B4 \    5C             INCB           ;						DO THE SECOND SCREEN CONTROL BLOCK
F0B5      20 E1          BRA     $F098  ;						WHOSE OTHER VALUES ARE THE SAME
->
F0B7      8E EB C2       LDX     #$EBC2 ;
F0BA      E7 80          STB     ,X+    ;
F0BC      E7 80          STB     ,X+    ;
F0BE      E7 80          STB     ,X+    ;
F0C0 J    4A             DECA           ;
F0C1      A7 80          STA     ,X+    ;
->
F0C3 o    6F 80          CLR     ,X+    ;
F0C5      8C EB E4       CMPX    #$EBE4 ;
F0C8 %    25 F9          BCS     $F0C3  ;
F0CA      8E 10 00       LDX     #$1000 ;
F0CD      BF EF E4       STX     $EFE4  ;
F0D0      BF EF E6       STX     $EFE6  ;
F0D3      8E F2 1F       LDX     #$F21F ;				ROM-BASED SWI COMMAND BRANCH TABLE
F0D6      BF DF EC       STX     $DFEC  ;				LOADED INTO RAM AND IS NOW SOFTWARE-CONFIGURABLE
F0D9      8E DF CA       LDX     #$DFCA ;
->
F0DC      A7 80          STA     ,X+    ;
F0DE      8C DF DE       CMPX    #$DFDE ;
F0E1 %    25 F9          BCS     $F0DC  ;
F0E3  0   86 30          LDA     #$30   ;
->
F0E5      A7 80          STA     ,X+    ;
F0E7 L    4C             INCA           ;
F0E8  9   81 39          CMPA    #$39   ;
F0EA #    23 F9          BLS     $F0E5  ;
->
F0EC o    6F 80          CLR     ,X+    ;
F0EE      8C DF EC       CMPX    #$DFEC ;
F0F1 %    25 F9          BCS     $F0EC  ;
F0F3      FC FF F0       LDD     $FFF0  ;					UID of the machine
F0F6      FD DF EE       STD     $DFEE  ;					store UID of machine at $DFEE
F0F9      7F DF F6       CLR     $DFF6  ;
F0FC  C   1F 43          TFR     S,U    ;
F0FE      BD F0 00       JSR     $F000  ;
F101      1C EF          ANDCC   #$EF   ;
F103      F6 E0 0E       LDB     $E00E  ;					read from keyboard
F106      C4 DF          ANDB    #$DF   ;					leave the high bit on and check the ASCII key
F108      C1 D7          CMPB    #$D7   ;					did we get a D7 (Is the 'w' key being held down?)
F10A &    26 06          BNE     $F112  ;					if not then continue
F10C      CC A0 03       LDD     #$A003 ;
F10F ~    7E F1 CA       JMP     $F1CA  ;
->
F112      0F D1          CLR     $D1    ;(DP$D1);
F114      10 8E EF C0    LDY     #$EFC0 ;
F118   ]  BD FE 5D       JSR     $FE5D  ;
F11B  \   86 5C          LDA     #$5C   ;
F11D      B7 E0 02       STA     $E002  ;
F120      CC 06 08       LDD     #$0608 ;					SCREEN ROW AND COL POSITION
F123      BD F1 A6       JSR     $F1A6  ;					PRINT UP-TO \0
->
F126 0F 0D 06 50 4F 4C 59 20 55 4E                         ...POLY UN   ;
F130 49 54 20 41 56 41 49 4C 41 42 4C 45 00          IT AVAILABLE.      ;
->
F13D      CC 0E 08       LDD     #$0E08 ;					SCREEN ROW AND COL POSITION
F140  d   8D 64          BSR     $F1A6  ;					PRINT THE TEXT UP-TO THE \0
->
F142 03 50 72 65 73 73 20 41 6E 79 20 4B 65             .Press Any Ke   ;
F14F 79 20 74 6F 20 53 74 61 72 74 00                     y to Start.   ;
->
F15A      96 D0          LDA     $D0    ;(DP$D0);			NON-ZERO WHEN A KEY HAS BEEN PRESSED
F15C &    26 04          BNE     $F162  ;					DONE SO MOVE ON
F15E      96 F1          LDA     $F1    ;(DP$F1);			***** some kind of sum of network errors? *****
F160 *    2A F8          BPL     $F15A  ;					WAIT LONGER
->
F162   ]  BD FE 5D       JSR     $FE5D  ;					CLEAR SCREEN AND HOME CURSOR
F165      86 0C          LDA     #$0C   ;
F167      B7 E0 02       STA     $E002  ;					the screen Parallel port
F16A      0D E5          TST     $E5    ;(DP$E5);
F16C 'T   27 54          BEQ     $F1C2  ;					start standalone POLYBASIC startup
F16E      0D F1          TST     $F1    ;(DP$F1);
F170 +"   2B 22          BMI     $F194  ;					DON'T PRINT THE AWAITING LOAD MESSAGE!
->
F172      0C F1          INC     $F1    ;(DP$F1);
F174 _    5F             CLRB           ;					CLEAR D
F175 O    4F             CLRA           ;					SETS ROW AND COL TO 0
F176  .   8D 2E          BSR     $F1A6  ;					PRINT TEXT UP TO THE \0
->
F178 0F 01 0D 41 57 41 49 54                     ...AWAIT   ;
F180 49 4E 47 20 4C 4F 41 44 0E 00               ING LOAD.. ;
->
F18A      C6 10          LDB     #$10   ;					B = server command ($10)
F18C 1    31 01          LEAY    $01,X  ;					Y = X + 1			Y = end of message
F18E   *  BD FB 2A       JSR     $FB2A  ;					send message to server (B = command, X=start address, Y=end address)
F191      BD FB 7F       JSR     $FB7F  ;					recieve a FLEX binary file from the server
->
F194      96 F0          LDA     $F0    ;(DP$F0);
F196 +#   2B 23          BMI     $F1BB  ;					SET DP$F1 = 1 AND RESTART!
F198      81 7F          CMPA    #$7F   ;
F19A '+   27 2B          BEQ     $F1C7  ;					start network Poly
F19C      91 E5          CMPA    $E5    ;(DP$E5);
F19E ''   27 27          BEQ     $F1C7  ;					start network Poly
F1A0      0D D4          TST     $D4    ;(DP$D4);			bytes to be read from the network
F1A2 .    2E CE          BGT     $F172  ;					RE-PRINT THE AWAITING LOAD MESSAGE AND KEEP GOING
F1A4      20 EE          BRA     $F194  ;					TRY AGAIN
->
;
;
;
;Routine:
;
;PRINT STRING AT GIVEN ROW / COL ONTO CURRENT TEXT SCREEN
;
F1A6      10 9E C0       LDY     $C0    ;(DP$C0);			SCREEN CONTROL BLOCK
F1A9  ,   ED 2C          STD     $0C,Y  ;					SAVE ROW AND COL VALUES ($0C = ROW, $0D = COL)
F1AB 5    35 10          PULS    X      ;					PULL TOP OF STACK (RETURN ADDRESS) AND STORE IN X
F1AD      8D 02          BSR     $F1B1  ;					PRINT STRING
F1AF n    6E 84          JMP     ,X     ;					SIMULATE AN RTS TO WHAT EVER IS AFTER THE NULL TERMINATED STRING
->
;
;
;
;Routine:
;
;PRINT STRING AT THE CURRENT ROW / COL ON THE CURRENT TEXT SCREEN
;
F1B1      A6 80          LDA     ,X+    ;					READ THE FIRST / NEXT CHARACTER
F1B3 '    27 05          BEQ     $F1BA  ;					WHILE NON-ZERO (NULL TERMINATED STRING)
F1B5      BD FD DD       JSR     $FDDD  ;					PRINT THE CHARACTER
F1B8      20 F7          BRA     $F1B1  ;					REPEAT UNTIL NULL CHARACTER FOUND
->
F1BA 9    39             RTS            ;					THEN RETURN
;
;
;
->
F1BB      86 01          LDA     #$01   ;
F1BD      97 F1          STA     $F1    ;(DP$F1);
F1BF ~ t  7E F0 74       JMP     $F074  ;
->
;
;
;
;Routine:
;
; RETURN TO EITHER #$A000 OR #$C100 AFTER SIMULATING AN NMI/FIRQ
;
F1C2      CC A0 00       LDD     #$A000 ;					LOAD D WITH #$A000
F1C5      20 03          BRA     $F1CA  ;					MOVE ON
->
F1C7      CC C1 00       LDD     #$C100 ;					OR ELSE LOAD D WITH #$C100
->
F1CA  J   ED 4A          STD     $0A,U  ;					THIS IS THE RETURN FROM INTERRUPT ADDRESS
F1CC      0F C3          CLR     $C3    ;(DP$C3);			***** dunno *****
F1CE      0F F1          CLR     $F1    ;(DP$F1);			***** dunno *****
F1D0      86 C0          LDA     #$C0   ;					PUSHED EVERYTHING AND SIMULATE A FIRQ IN ACTION
F1D2      A7 C4          STA     ,U     ;					FLAGS FOR THE RTI
F1D4 oC   6F 43          CLR     $03,U  ;					DP ON RETURN
F1D6 ~ D  7E FA 44       JMP     $FA44  ;					SIMULATE NMI / FIRQ
->
;
;
;
;Interrupt Vector:SWI 
;
; SOFTWARE INTERRUPT
; NEXT BYTE AFTER THE SWI CONTAINS THE FUNCTION NUMBER (WHICH IS LOADED INTO B)
;
;Order of pushing the registers is
;sp   -> CC
;sp+1 -> A
;sp+2 -> B
;sp+3 -> DP
;sp+4 -> Xh
;sp+5 -> Xl
;sp+6 -> Yh
;sp+7 -> Yl
;sp+8 -> Uh
;sp+9 -> Ul
;sp+A -> PCh
;sp+B -> PCl
;
F1D9 3    33 E4          LEAU    ,S     ;					U = S
F1DB      86 EB          LDA     #$EB   ;					LOAD DP VIA A
F1DD      1F 8B          TFR     A,DP   ;					DP = $EB00
F1DF      0F C6          CLR     $C6    ;(DP$C6);			***** dunno *****
F1E1      0D C9          TST     $C9    ;(DP$C9);			CHECK TO SEE IF WE SHOULD OVERRIDE SWI PROCESSING
F1E3  &   10 26 08 DF    LBNE    $FAC6  ;					IF SO THEN DEAL WITH IT
F1E7  J   AE 4A          LDX     $0A,U  ;					RETURN ADDRESS
F1E9      E6 80          LDB     ,X+    ;					NEXT BYTE IS B
F1EB  J   AF 4A          STX     $0A,U  ;					NEW RETURN ADDRESS (BECAUSE X MOVED)
F1ED      A6 C4          LDA     ,U     ;					LOAD A WITH CC
F1EF      84 D0          ANDA    #$D0   ;					TURN OFF ALL EXCEPT E, F, AND I
F1F1  -   C1 2D          CMPB    #$2D   ;					COMPARE INSTRUCTION WITH $2D
F1F3 "    22 04          BHI     $F1F9  ;					IT WAS OVER ($2E OR ABOVE)
F1F5      1C EF          ANDCC   #$EF   ;					TURN THE EVERYTHING BIT (E) OFF
F1F7      84 C0          ANDA    #$C0   ;					LEAVE E AND F BITS ON (CC ON TOP OF STACK)
->
F1F9      A7 C4          STA     ,U     ;					REPLACE CC ON TOP OF STACK
F1FB  0   C1 30          CMPB    #$30   ;					COMPARE INSTRUCTION TO $30
F1FD $    24 12          BCC     $F211  ;					IT WAS GREATER THAN OR EQUAL TO $30
F1FF X    58             ASLB           ;					SHIFT IT LEFT (MULTIPLY BY 2)
F200      10 9E C0       LDY     $C0    ;(DP$C0);			SCREEN CONTROL BLOCK
F203      BE DF EC       LDX     $DFEC  ;					O/S BRANCH TABLE
F206      AD 95          JSR     [B,X]  ;					OFF WE GO
->
F208  4   1F 34          TFR     U,S    ;					S = U (RETURN THE STACK TO WHERE IT WAS BEFORE)
F20A      86 EB          LDA     #$EB   ;					LOAD DP VIA A
F20C      1F 8B          TFR     A,DP   ;					DP = $EB00
F20E ~ D  7E FA 44       JMP     $FA44  ;					NOW FAKE AN NMI/FIRQ
->
;
;
;Routine:
;
; SWI FUNCTION 15 / 26 / 27 / 28
; 
; Reserved SWI Functions
;
F211      86 1F          LDA     #$1F   ;
F213  A   A7 41          STA     $01,U  ;					REPLACE A ON THE STACK
F215  B   A7 42          STA     $02,U  ;					REPLACE B ON THE STACK
;
F217      A6 C4          LDA     ,U     ;					LOAD CC
F219      8A 01          ORA     #$01   ;					SET THE LOW BIT (CARRY)
F21B      A7 C4          STA     ,U     ;					PUT IT BACK
F21D      20 E9          BRA     $F208  ;					FORWARD TO NMI/FIRQ
->
;
;
;
;
; SWI BRANCH TABLE.  AT STARTUP DFEC IS LOADED WITH THIS ADDRESS AND
; REFERENCES ARE ALL DEREFERENCED THROUGH THERE.
;
F21F     F2 7F 	; 00 		Check status of keyboard
F221     F2 89 	; 01 		Input single character
F223     F2 E5 	; 02 		Line Edit
F225     F5 84 	; 03		Sound Generator
F227     F5 C6 	; 04 		Pause
F229     F5 CF 	; 05 		Put Character
F22B     F5 E5 	; 06 		Write Character To Specdified Position
F22D     F5 EF	; 07 		Read The Keyboard
F22F     F6 09 	; 08		Copy From Screen To A String
F231     F6 3A 	; 09 		Set Cursor Position
F233     F6 41 	; 0A		Set Relative Cursor Position On Current Text Screen
F235     F6 53 	; 0B 		Read Cursor Position
F237     F6 5B 	; 0C 		Read Cursor Character
F239     F6 66 	; 0D 		Split Screen Into Two Portions
F23B     F6 97 	; 0E 		Clear Text Screen
F23D     F6 AD	; 0F		Set Screen And Display Characteristics
F23F     F6 B6	; 10 		Read Display Mode
F241     F6 C2	; 11 		Set The Clock
F243     F6 F6	; 12		Return The Time
F245     F6 FD	; 13		Wait routine
F247     F7 28	; 14		set PAUSE key flag
F249     F2 11	; 15		Reserved:
F24B     F2 8E	; 16		Reserved:get key from keyboard without displaying a cursor
F24D     F7 2D	; 17		Read Through Serial Port
F24F     F7 66 	; 18		Write Through Serial Port
F251     F7 B0 	; 19		Set Terminal Mode
F253     F8 11 	; 1A		Select Standard Memory Map 2
F255     F8 09 	; 1B		Switch To Memory Map 1
F257     F8 16 	; 1C		Switch To Memory Map 2
F259     F8 1F 	; 1D		Change Configutation of Memory Map 2
F25B     F8 45	; 1E		Select Current Text Screen
F25D     F8 6C	; 1F		select 24 line teletext display
F25F     F8 73 	; 20		select 12 line teletext display
F261     F8 7C 	; 21		display first 12 lines
F263     F8 83 	; 22		display last 12 lines
F265     F8 8C 	; 23		Set Scroll Mode On Text Screen
F267     F8 91 	; 24		Map In Memory Page
F269     F8 A5 	; 25		Text Exit Flag
F26B     F2 11 	; 26		Reserved:
F26D     F2 11 	; 27		Reserved:
F26F     F2 11 	; 28		Reserved:
F271     F8 AC 	; 29		Reserved:
F273     F8 B7 	; 2A		Reserved:
F275     FA FF 	; 2B		Send Message To Master
F277     FB 5F 	; 2C		Revieve Message From Master
F279     F0 74 	; 2D		Log Off   				***** are these ones special? CC gets changed! *****
F27B     F7 91 	; 2E		Read System Input/Output
F27D     F7 A0	; 2F		Write System Input/Output
->
;
;Routine:
;
; SWI FUNCTION 00
;
; Check status of keyboard
;
; returns in B:
;	Low bit set  : character is waiting to be read (new key press)
;	High bit set : the key is still down
;	Both bits set: new key press and the key is held down
;
F27F      B6 E0 0E       LDA     $E00E  ;						keyboard strobe (high bit set on key held down)
F282      84 80          ANDA    #$80   ;						set high bit of result if a key is held down
F284      9A D0          ORA     $D0    ;(DP$D0);				new key press (that has not been read)
F286  B   A7 42          STA     $02,U  ;						Store the result in B
F288 9    39             RTS            ;						Done
;
;
;
;Routine:
;
; SWI FUNCTION 01
;
; Input Single Character
;
; Turns on the cursor and waits for a key press
; returns in B: charcter read
;
F289      BD F5 D6       JSR     $F5D6  ;						IF THERE'S A KEY PRESS STORED AT $DFF6 THEN RETURN THAT IMMEDIATELY IN A
F28C      0C CD          INC     $CD    ;(DP$CD);				DISPLAY THE CURSOR ON GET KEY
;
;
;Routine:
;
; SWI FUNCTION 16
;
; Reserved
; 	GET A KEY FROM THE KEYBOARD WITHOUT DISPLAYING A CURSOR
; 	RETURNS: B=KEY
;
F28E      8D 05          BSR     $F295  ;						WAIT SOME TIMEOUT PERIOD FOR A KEY PRESS
F290  B   A7 42          STA     $02,U  ;						STORE AT TOP OF STACK AFTER RETURN ADDRESS
F292 9    39             RTS            ;						DONE
->
F293      0C CD          INC     $CD    ;(DP$CD);				DISPLAY THE CURSOR ON GET KEY
->
;
;
;
;Routine:
;
; HANDLER FOR SWI FUNCTION 01
;
; OPTIONALLY DISPLAY A CURSOR
; READ THE LAST UNREAD KEY FROM THE KEYBOARD BUFFER
; AND RETURN IT IN A
; ***** what does the EFE4 / EFE6 stuff do? ***** (both are initially initialised to $1000)
;
F295 45   34 35          PSHS    Y,X,B,CC;						SAVE THE REGISTERS WE'RE ABOUT TO TRASH
F297      BD FE 9D       JSR     $FE9D  ;						LOAD SCREEN CONTROL BLOCK INTO Y AND CONVERT ROW/COL INTO A MEMORY ADDRESS (X)
F29A      E6 84          LDB     ,X     ;						LOAD B WITH THE CHARACTER AT THAT LOCATION
F29C 4    34 04          PSHS    B      ;						SAVE IT ON THE STACK
F29E      0D CD          TST     $CD    ;(DP$CD);				SHOULD WE DISPLAY A CURSOR?
F2A0 '    27 04          BEQ     $F2A6  ;						AVOID FLIPPING THE TOP BITS IF WE'RE NOT FROM THE SWI
F2A2      C8 80          EORB    #$80   ;						FLIP THE TOP BIT (DISPLAY A CURSOR)
F2A4      E7 84          STB     ,X     ;						PUT IT BACK
->
F2A6 }    7D E0 0E       TST     $E00E  ;						KEYBOARD STROBE (HIGH BIT SET MEANS KEY IS HELD DOWN)
F2A9 *    2A 12          BPL     $F2BD  ;						NO KEY IS BEING HELD DOWN
F2AB      0D D0          TST     $D0    ;(DP$D0);				CHECK TO SEE IF A KEY HAS ALEADY BEEN READ
F2AD &#   26 23          BNE     $F2D2  ;						YES, SO MOVE ON
F2AF      DC F3          LDD     $F3    ;(DP$F3);				DELAY IN KEYBOARD AUTOREPEAT
F2B1      83 00 01       SUBD    #$0001 ;						SUBTRACT ONE
F2B4      DD F3          STD     $F3    ;(DP$F3);				SAVE IT BACK
F2B6 &    26 EE          BNE     $F2A6  ;						AND WAIT LONGER
F2B8      CC 05 14       LDD     #$0514 ;						SHORT DELAY TO NEXT KEY PRESS AS A KEY IS BEING HELD DOWN
F2BB      20 18          BRA     $F2D5  ;						RETURN THE LAST KEY PRESSED
->
F2BD      0F D0          CLR     $D0    ;(DP$D0);				NO KEY HAS BEEN PRESSED SO CLEAR KEY PRESSED STROBE
F2BF O    4F             CLRA           ;						***** dunno why *****
F2C0      1C EF          ANDCC   #$EF   ;						TURN ON IRQ INTERRUPTS (THE KEYBOARD PROCESSING IS ON IRQ)
->
F2C2      0D D0          TST     $D0    ;(DP$D0);				HAS A KEY BEEN PRESSED NOW?
F2C4 &    26 0C          BNE     $F2D2  ;						YES A KEY HAS BEEN PRESSED SO MOVE ON
F2C6      10 BE EF E4    LDY     $EFE4  ;						***** dunno *****
F2CA      10 BC EF E6    CMPY    $EFE6  ;						***** dunno *****
F2CE '    27 F2          BEQ     $F2C2  ;						THEY ARE THE SAME SO WAIT UNTIL A KEY IS PRESSED
F2D0      20 0B          BRA     $F2DD  ;						CLEAN UP AND DONE
->
F2D2  7   CC 37 CD       LDD     #$37CD ;						LONG DELAY BEFORE AUTOREPEAT STARTS
->
F2D5      DD F3          STD     $F3    ;(DP$F3);				KEYBOARD DELAY FOR AUTOREPEAT SAVED
F2D7      1A 10          ORCC    #$10   ;						DISABLE IRQ (STOP KEYBOARD PROCESING)
F2D9      96 EC          LDA     $EC    ;(DP$EC);				***** is this the last key pressed? *****
F2DB      0F D0          CLR     $D0    ;(DP$D0);				WE'VE READ THE KEY AND USED IT
->
F2DD 5    35 04          PULS    B      ;						CHARACTER THAT WAS ON THE SCREEN
F2DF      E7 84          STB     ,X     ;						PUT IT BACK ON THE SCREEN
F2E1      0F CD          CLR     $CD    ;(DP$CD);				TURN THE CURSOR OFF (NOT IN THE SWI ANY LONGER)
F2E3 5    35 B5          PULS    PC,Y,X,B,CC;					DONE (BECAUSE PC IS PULLED)
;
;Routine:
;
; SWI FUNCTION 02
; line edit
;
; on entry,
; 	if B == 0 then a is the subfunction number
; 	else
;
;
F2E5      BD F5 D6       JSR     $F5D6  ;			IF THERE'S A KEY PRESS STORED AT $DFF6 THEN RETURN THAT IN A
F2E8  B   A6 42          LDA     $02,U  ;			LOAD WITH B FROM BEFORE THE SWI
F2EA '#   27 23          BEQ     $F30F  ;			it was a zero so do subfunctions
F2EC      81 0E          CMPA    #$0E   ;			got 0E
F2EE '    27 1F          BEQ     $F30F  ;			do subfunctions
F2F0 m*   6D 2A          TST     $0A,Y  ;			not sure what's here in the screen control block
F2F2 &!   26 21          BNE     $F315  ;
F2F4      81 1F          CMPA    #$1F   ;			subfuncton $1F
F2F6 ';   27 3B          BEQ     $F333  ;			
F2F8 "    22 1B          BHI     $F315  ;
F2FA      81 0A          CMPA    #$0A   ;
F2FC 'c   27 63          BEQ     $F361  ;
F2FE      81 0B          CMPA    #$0B   ;
F300 'W   27 57          BEQ     $F359  ;
F302      81 05          CMPA    #$05   ;
F304 'f   27 66          BEQ     $F36C  ;
F306      81 06          CMPA    #$06   ;
F308 'g   27 67          BEQ     $F371  ;
F30A      BD F4 CE       JSR     $F4CE  ;
F30D  B   A6 42          LDA     $02,U  ;
->
F30F      8E F3 18       LDX     #$F318 ;			address of branch table
F312 ~ $  7E FE 24       JMP     $FE24  ;			branch table lookup
->
F315 ~    7E F4 A1       JMP     $F4A1  ;
->
;
; branch table for subfunction of swi function 2?
;
F318 0D F5 4A 
F31B 0C F5 3E 
F31E 03 F5 05 
F321 04 F5 1C 
F324 01 F4 1F 
F327 02 F3 EC 
F32A 08 F3 D4 
F32D 09 F3 E0 
F330 00 FD DD			; print character and scroll if necessary
->
F333  A   A6 41          LDA     $01,U  ;
F335      B7 EF E8       STA     $EFE8  ;
F338  D   EC 44          LDD     $04,U  ;
F33A   F  10 AE 46       LDY     $06,U  ;
F33D '    27 17          BEQ     $F356  ;
F33F 0    30 AB          LEAX    D,Y    ;
F341      8C E0 00       CMPX    #$E000 ;
F344 $    24 10          BCC     $F356  ;
F346      DD DD          STD     $DD    ;(DP$DD);
F348 1?   31 3F          LEAY    $-01,Y ;
F34A      10 9F DB       STY     $DB    ;(DP$DB);
F34D      BD FE 9D       JSR     $FE9D  ;
F350  ,   EC 2C          LDD     $0C,Y  ;
F352      DD D7          STD     $D7    ;(DP$D7);
F354  H   20 48          BRA     $F39E  ;
->
F356 ~    7E F2 17       JMP     $F217  ;
->
F359  ,   E6 2C          LDB     $0C,Y  ;
F35B  )   E1 29          CMPB    $09,Y  ;
F35D #    23 12          BLS     $F371  ;
F35F      20 06          BRA     $F367  ;
->
F361  ,   E6 2C          LDB     $0C,Y  ;
F363  (   E1 28          CMPB    $08,Y  ;
F365 *    2A 05          BPL     $F36C  ;
->
F367      BD FD DD       JSR     $FDDD  ;
F36A      20 08          BRA     $F374  ;
->
F36C      BD FE FF       JSR     $FEFF  ;
F36F      20 03          BRA     $F374  ;
->
F371      BD FE E3       JSR     $FEE3  ;
->
F374      BD FE A0       JSR     $FEA0  ;
F377  ,   EC 2C          LDD     $0C,Y  ;
F379 m    6D 84          TST     ,X     ;
F37B &    26 11          BNE     $F38E  ;
->
F37D  $   AC 24          CMPX    $04,Y  ;
F37F #    23 1B          BLS     $F39C  ;
F381 m    6D 82          TST     ,-X    ;
F383 &    26 07          BNE     $F38C  ;
F385 ]    5D             TSTB           ;
F386 '    27 14          BEQ     $F39C  ;
F388  B   8D 42          BSR     $F3CC  ;
F38A      20 F1          BRA     $F37D  ;
->
F38C 0    30 01          LEAX    $01,X  ;
->
F38E  $   AC 24          CMPX    $04,Y  ;
F390 #    23 0A          BLS     $F39C  ;
F392 m    6D 82          TST     ,-X    ;
F394 '    27 04          BEQ     $F39A  ;
F396  4   8D 34          BSR     $F3CC  ;
F398      20 F4          BRA     $F38E  ;
->
F39A 0    30 01          LEAX    $01,X  ;
->
F39C      DD D7          STD     $D7    ;(DP$D7);
->
F39E  &   AC 26          CMPX    $06,Y  ;
F3A0 $    24 08          BCC     $F3AA  ;
F3A2 m    6D 80          TST     ,X+    ;
F3A4 '    27 04          BEQ     $F3AA  ;
F3A6      8D 1C          BSR     $F3C4  ;
F3A8      20 F4          BRA     $F39E  ;
->
F3AA      DD D9          STD     $D9    ;(DP$D9);
F3AC      DC D7          LDD     $D7    ;(DP$D7);
F3AE      BD FE A2       JSR     $FEA2  ;
F3B1 4    34 10          PSHS    X      ;
F3B3      DC D9          LDD     $D9    ;(DP$D9);
F3B5      BD FE A2       JSR     $FEA2  ;
F3B8      A3 E1          SUBD    ,S++   ;
F3BA m    6D 84          TST     ,X     ;
F3BC '    27 03          BEQ     $F3C1  ;
F3BE      C3 00 01       ADDD    #$0001 ;
->
F3C1      DD DF          STD     $DF    ;(DP$DF);
F3C3 9    39             RTS            ;
->
Routine:
F3C4 \    5C             INCB           ;
F3C5  (   C1 28          CMPB    #$28   ;
F3C7 &    26 02          BNE     $F3CB  ;
F3C9 _    5F             CLRB           ;
F3CA L    4C             INCA           ;
->
F3CB 9    39             RTS            ;
->
Routine:
F3CC ]    5D             TSTB           ;
F3CD &    26 03          BNE     $F3D2  ;
F3CF  (   C6 28          LDB     #$28   ;
F3D1 J    4A             DECA           ;
->
F3D2 Z    5A             DECB           ;
F3D3 9    39             RTS            ;
->
Routine:
;
; SWI 02 subfunction 08
;
F3D4  ,   EC 2C          LDD     $0C,Y  ;
F3D6      8D F4          BSR     $F3CC  ;
F3D8      10 93 D7       CMPD    $D7    ;(DP$D7);
F3DB -    2D 02          BLT     $F3DF  ;
F3DD  ,   ED 2C          STD     $0C,Y  ;
->
F3DF 9    39             RTS            ;
->
Routine:
;
; SWI 02 subfunction 09
;
F3E0  ,   EC 2C          LDD     $0C,Y  ;
F3E2      10 93 D9       CMPD    $D9    ;(DP$D9);
F3E5 $    24 04          BCC     $F3EB  ;
F3E7      8D DB          BSR     $F3C4  ;
F3E9  ,   ED 2C          STD     $0C,Y  ;
->
F3EB 9    39             RTS            ;
->
Routine:
;
; SWI 02 subfunction 02
;
F3EC      DC D9          LDD     $D9    ;(DP$D9);
F3EE   ,  10 A3 2C       CMPD    $0C,Y  ;
F3F1 #+   23 2B          BLS     $F41E  ;
F3F3      10 93 D7       CMPD    $D7    ;(DP$D7);
F3F6 '&   27 26          BEQ     $F41E  ;
F3F8      BD FE A2       JSR     $FEA2  ;
F3FB 4    34 10          PSHS    X      ;
F3FD      BD FE A0       JSR     $FEA0  ;
F400  &   AC 26          CMPX    $06,Y  ;
F402 %    25 04          BCS     $F408  ;
F404 o    6F 84          CLR     ,X     ;
F406      20 0E          BRA     $F416  ;
->
F408      A6 01          LDA     $01,X  ;
F40A      A7 80          STA     ,X+    ;
F40C      AC E4          CMPX    ,S     ;
F40E %    25 F8          BCS     $F408  ;
F410      DC D9          LDD     $D9    ;(DP$D9);
F412      8D B8          BSR     $F3CC  ;
F414      DD D9          STD     $D9    ;(DP$D9);
->
F416 2b   32 62          LEAS    $02,S  ;
F418      9E DF          LDX     $DF    ;(DP$DF);
F41A 0    30 1F          LEAX    $-01,X ;
F41C      9F DF          STX     $DF    ;(DP$DF);
->
F41E 9    39             RTS            ;
->
Routine:
;
; SWI 02 subfunction 01
;
F41F      9E DF          LDX     $DF    ;(DP$DF);
F421      9C DB          CMPX    $DB    ;(DP$DB);
F423 $    24 20          BCC     $F445  ;
F425      DC D9          LDD     $D9    ;(DP$D9);
F427  '   C1 27          CMPB    #$27   ;
F429 %L   25 4C          BCS     $F477  ;
F42B  (   A1 28          CMPA    $08,Y  ;
F42D *(   2A 28          BPL     $F457  ;
F42F _    5F             CLRB           ;
F430 L    4C             INCA           ;
F431      DD D9          STD     $D9    ;(DP$D9);
F433      BD FE A2       JSR     $FEA2  ;
F436  $   EC 24          LDD     $04,Y  ;
F438 4    34 06          PSHS    D      ;
F43A  $   AF 24          STX     $04,Y  ;
F43C      BD FE E3       JSR     $FEE3  ;
F43F 5    35 06          PULS    D      ;
F441  $   ED 24          STD     $04,Y  ;
F443  5   20 35          BRA     $F47A  ;
->
F445      BD FE A0       JSR     $FEA0  ;
F448 4    34 10          PSHS    X      ;
F44A      DC D9          LDD     $D9    ;(DP$D9);
F44C      BD FE A2       JSR     $FEA2  ;
F44F      AC E4          CMPX    ,S     ;
F451 'K   27 4B          BEQ     $F49E  ;
F453 0    30 1F          LEAX    $-01,X ;
F455  -   20 2D          BRA     $F484  ;
->
F457 m&   6D 26          TST     $06,Y  ;
F459 '    27 1F          BEQ     $F47A  ;
F45B      BD FE FF       JSR     $FEFF  ;
F45E  )   E6 29          LDB     $09,Y  ;
F460  ,   E1 2C          CMPB    $0C,Y  ;
F462 '    27 02          BEQ     $F466  ;
F464 j,   6A 2C          DEC     $0C,Y  ;
->
F466      D1 D7          CMPB    $D7    ;(DP$D7);
F468 '    27 04          BEQ     $F46E  ;
F46A      0A D7          DEC     $D7    ;(DP$D7);
F46C      20 07          BRA     $F475  ;
->
F46E      9E DF          LDX     $DF    ;(DP$DF);
F470 0    30 88 D8       LEAX    $-28,X ;
F473      9F DF          STX     $DF    ;(DP$DF);
->
F475      C6 FF          LDB     #$FF   ;
->
F477 \    5C             INCB           ;
F478      D7 DA          STB     $DA    ;(DP$DA);
->
F47A      BD FE A0       JSR     $FEA0  ;
F47D 4    34 10          PSHS    X      ;
F47F      DC D9          LDD     $D9    ;(DP$D9);
F481      BD FE A2       JSR     $FEA2  ;
->
F484      AC E4          CMPX    ,S     ;
F486 #    23 06          BLS     $F48E  ;
F488      A6 82          LDA     ,-X    ;
F48A      A7 01          STA     $01,X  ;
F48C      20 F6          BRA     $F484  ;
->
F48E      86 20          LDA     #$20   ;
F490      A7 84          STA     ,X     ;
F492      DC DF          LDD     $DF    ;(DP$DF);
F494      10 93 DB       CMPD    $DB    ;(DP$DB);
F497 '    27 05          BEQ     $F49E  ;
F499      C3 00 01       ADDD    #$0001 ;
F49C      DD DF          STD     $DF    ;(DP$DF);
->
F49E 2b   32 62          LEAS    $02,S  ;
F4A0 9    39             RTS            ;
->
F4A1  +   8D 2B          BSR     $F4CE  ;
F4A3  ,   EC 2C          LDD     $0C,Y  ;
F4A5      10 93 D9       CMPD    $D9    ;(DP$D9);
F4A8 %    25 17          BCS     $F4C1  ;
F4AA      DC DF          LDD     $DF    ;(DP$DF);
F4AC      10 93 DB       CMPD    $DB    ;(DP$DB);
F4AF %    25 0D          BCS     $F4BE  ;
F4B1      BD FE A0       JSR     $FEA0  ;
F4B4  $   AC 24          CMPX    $04,Y  ;
F4B6 #    23 15          BLS     $F4CD  ;
F4B8  B   E6 42          LDB     $02,U  ;
F4BA      E7 82          STB     ,-X    ;
F4BC      20 0F          BRA     $F4CD  ;
->
F4BE      BD F4 1F       JSR     $F41F  ;
->
F4C1  B   A6 42          LDA     $02,U  ;
F4C3      BD FE 8E       JSR     $FE8E  ;
F4C6  ,   EC 2C          LDD     $0C,Y  ;
F4C8      BD F3 C4       JSR     $F3C4  ;
F4CB  ,   ED 2C          STD     $0C,Y  ;
->
F4CD 9    39             RTS            ;
->
Routine:
F4CE      DC D9          LDD     $D9    ;(DP$D9);
F4D0   ,  10 A3 2C       CMPD    $0C,Y  ;
F4D3 $    24 02          BCC     $F4D7  ;
F4D5  ,   ED 2C          STD     $0C,Y  ;
->
F4D7      9E DB          LDX     $DB    ;(DP$DB);
F4D9      9C DF          CMPX    $DF    ;(DP$DF);
F4DB $'   24 27          BCC     $F504  ;
F4DD      DC D7          LDD     $D7    ;(DP$D7);
F4DF      BD FE A2       JSR     $FEA2  ;
F4E2      D3 DB          ADDD    $DB    ;(DP$DB);
F4E4 4    34 06          PSHS    D      ;
F4E6      DC D9          LDD     $D9    ;(DP$D9);
F4E8      BD FE A2       JSR     $FEA2  ;
F4EB      DC D9          LDD     $D9    ;(DP$D9);
F4ED o    6F 84          CLR     ,X     ;
->
F4EF      AC E4          CMPX    ,S     ;
F4F1 #    23 07          BLS     $F4FA  ;
F4F3 o    6F 82          CLR     ,-X    ;
F4F5      BD F3 CC       JSR     $F3CC  ;
F4F8      20 F5          BRA     $F4EF  ;
->
F4FA 2b   32 62          LEAS    $02,S  ;
F4FC      DD D9          STD     $D9    ;(DP$D9);
F4FE  ,   ED 2C          STD     $0C,Y  ;
F500      9E DB          LDX     $DB    ;(DP$DB);
F502      9F DF          STX     $DF    ;(DP$DF);
->
F504 9    39             RTS            ;
->
Routine:
;
; SWI 02 subfunction 03
;
F505      DC D7          LDD     $D7    ;(DP$D7);
F507  ,   ED 2C          STD     $0C,Y  ;
F509  $   AE 24          LDX     $04,Y  ;
F50B 4    34 10          PSHS    X      ;
F50D      BD FE A2       JSR     $FEA2  ;
F510  $   AF 24          STX     $04,Y  ;
F512      BD FE E3       JSR     $FEE3  ;
F515 5    35 06          PULS    D      ;
F517  $   ED 24          STD     $04,Y  ;
F519   X  16 FE 58       LBRA    $F374  ;
->
Routine:
;
; SWI 02 subfunction 04
;
F51C      DC D9          LDD     $D9    ;(DP$D9);
F51E      90 D7          SUBA    $D7    ;(DP$D7);
F520 L    4C             INCA           ;
F521  A   A7 41          STA     $01,U  ;
F523  $   AE 24          LDX     $04,Y  ;
F525 4    34 12          PSHS    X,A    ;
F527      DC D7          LDD     $D7    ;(DP$D7);
F529  ,   ED 2C          STD     $0C,Y  ;
F52B      BD FE A2       JSR     $FEA2  ;
F52E  $   AF 24          STX     $04,Y  ;
->
F530      BD FE FF       JSR     $FEFF  ;
F533 j    6A E4          DEC     ,S     ;
F535 &    26 F9          BNE     $F530  ;
F537 5    35 12          PULS    X,A    ;
F539  $   AF 24          STX     $04,Y  ;
F53B ~ t  7E F3 74       JMP     $F374  ;
->
Routine:
;
; SWI 02 subfunction 0C
;
F53E   ]  BD FE 5D       JSR     $FE5D  ;
F541      DD D7          STD     $D7    ;(DP$D7);
F543      DD D9          STD     $D9    ;(DP$D9);
F545 _    5F             CLRB           ;
F546 O    4F             CLRA           ;
F547      DD DF          STD     $DF    ;(DP$DF);
F549 9    39             RTS            ;
->
Routine:
;
; SWI 02 subfunction 0D
;
; happens when dealing with a "\n"
;
F54A }    7D EF E8       TST     $EFE8  ;
F54D &    26 07          BNE     $F556  ;
F54F  ,   EC 2C          LDD     $0C,Y  ;
F551      DD D9          STD     $D9    ;(DP$D9);
F553      BD F3 AC       JSR     $F3AC  ;
->
F556      DC D9          LDD     $D9    ;(DP$D9);
F558  ,   ED 2C          STD     $0C,Y  ;
F55A o-   6F 2D          CLR     $0D,Y  ;
F55C      BD FE A2       JSR     $FEA2  ;
F55F 4    34 10          PSHS    X      ;
F561      DC D7          LDD     $D7    ;(DP$D7);
F563      BD FE A2       JSR     $FEA2  ;
F566      10 9E DD       LDY     $DD    ;(DP$DD);
->
F569      AC E4          CMPX    ,S     ;
F56B "    22 06          BHI     $F573  ;
F56D      A6 80          LDA     ,X+    ;
F56F      A7 A0          STA     ,Y+    ;
F571      20 F6          BRA     $F569  ;
->
F573 2b   32 62          LEAS    $02,S  ;
F575      86 0D          LDA     #$0D   ;
F577      A7 A2          STA     ,-Y    ;
F579      DC DD          LDD     $DD    ;(DP$DD);
F57B  D   ED 44          STD     $04,U  ;
F57D      9E DF          LDX     $DF    ;(DP$DF);
F57F 0    30 01          LEAX    $01,X  ;
F581  F   AF 46          STX     $06,U  ;
F583 9    39             RTS            ;
->
;
;
;Routine:
;
;	SWI FUNCTION 03
;
;	Sound Generator
;	Parameters:
;		D: Pitch of the sound
;		X: Duration in 10 millisecond units
;	
;
F584      0D C2          TST     $C2    ;(DP$C2);				silent mode?
F586  '   10 27 FC 8D    LBEQ    $F217  ;						if in silent mode then don't play the bell
;
;
;Routine:
;
;	Keyboard Bell Routine
;
F58A  A   AE 41          LDX     $01,U  ;	(d)	pitch from parameter D
F58C '7   27 37          BEQ     $F5C5  ;		it's zero so done
F58E      86 82          LDA     #$82   ;		output on pin O, no IRQ, continious (synthesizer) mode, 16 bit, use Enable clock, no prescale
F590      B7 E0 20       STA     $E020  ;		control register 3 = $82
F593 _    5F             CLRB           ;		clear B
F594 O    4F             CLRA           ;		clear A (so D = 0)
F595  D   A3 44          SUBD    $04,U  ; (x)	duration from parameter X
F597  D   ED 44          STD     $04,U  ;	(x)	this has inverted the duration (0-D)
F599   "  FC E0 22       LDD     $E022  ;		load state of timer 1
F59C 4    34 16          PSHS    X,D    ;		X was the frequency and D the current timer 1 tick time
F59E   &  BF E0 26       STX     $E026  ;		store pitch (frequency) at timer 3
->
F5A1  b   AF 62          STX     $02,S  ;		store the frequency
F5A3   &  BE E0 26       LDX     $E026  ;		load state of timer 3
F5A6  b   AC 62          CMPX    $02,S  ; 	compare to what we stored
F5A8 %    25 F7          BCS     $F5A1  ;		if the clock is still ticking then wait longer
F5AA      EC E4          LDD     ,S     ; 	initial timer 1 tick time
F5AC    " 10 BE E0 22    LDY     $E022  ;		current timer 1 tick time
F5B0      10 AF E4       STY     ,S     ; 	save current timer 1 tick count
F5B3      A3 E4          SUBD    ,S     ;
F5B5 ,    2C 03          BGE     $F5BA  ;		current time is less than initial so its not been another round of timer 1 (another 10ms)
F5B7   d  C3 00 64       ADDD    #$0064 ;		is has been another 10ms so add another 10ms
->
F5BA  D   E3 44          ADDD    $04,U  ;		parameter X
F5BC  D   ED 44          STD     $04,U  ; 	parameter X
F5BE -    2D E1          BLT     $F5A1  ;		more sound
F5C0 2d   32 64          LEAS    $04,S  ; 	clean the stack (pop X and D and discard them)
F5C2      7F E0 20       CLR     $E020  ;		control register 3 = $00 (disable output on pin O, so go quiet)
->
F5C5 9    39             RTS            ;		done
->
;
;
;Routine:
;
; SWI FUNCTION 04
;
; Pause (if PAUSE key has been pressed) and when done return key in B
; Returns in B: Key that was pressed (of $FF if PAUSE not effective)
;
;
F5C6      86 FF          LDA     #$FF   ;
F5C8      0D CE          TST     $CE    ;(DP$CE);		check PAUSE key flag
F5CA '/   27 2F          BEQ     $F5FB  ;				not set so don't wait (return FF in B)
F5CC ~    7E F2 8E       JMP     $F28E  ;				wait for key press (without cursor, SWI 16)
->
;
;
;Routine:
;
; SWI FUNCTION 05
;
; Put character
;
; print the character in B and scroll if necessary
;
;
F5CF      8D 05          BSR     $F5D6  ;
F5D1  B   A6 42          LDA     $02,U  ;				CHARACTER TO PRINT WAS IN B
F5D3 ~    7E FD DD       JMP     $FDDD  ;				PRINT CHARACTER
->
;
;
;
;Routine:
;
; IF DFF6 IS ZERO THEN DO NOTHING BUT IF NOT THEN TURN THE HIGH BIT ON AND
; STORE IT AT DP$EB (WHICH IS THE LAST KEY PRESSED)
;
F5D6      B6 DF F6       LDA     $DFF6  ;					***** dunno *****
F5D9 '    27 09          BEQ     $F5E4  ;					DONE
F5DB      8A 80          ORA     #$80   ;					TURN THE HIGH BIT ON
F5DD      B7 DF F6       STA     $DFF6  ;					***** dunno *****
F5E0      97 EB          STA     $EB    ;(DP$EB);			LAST KEY PRESSED
F5E2 2b   32 62          LEAS    $02,S  ;					PULL 2 BYTES FROM THE STACK
->
F5E4 9    39             RTS            ;					DONE
->
;
;
;Routine:
;
; SWI FUNCTION 06
; Write Character To Specified Position
;
; without affecting the cursor position
; print character in B at screen coordinates in Y (Yh = row, Yl = column)
;
F5E5      8D 17          BSR     $F5FE  ;		load row and column number into Y
F5E7      BD FE A2       JSR     $FEA2  ;		get screen address
F5EA  B   A6 42          LDA     $02,U  ;		character to print from B
F5EC      A7 84          STA     ,X     ;		place it on the screen
F5EE 9    39             RTS            ;		done
->
;
;
;Routine:
;
; SWI FUNCTION 07
;
; Read The Keyboard
;
; if a key has been pressed return it in B
; or else return B = 0
;
F5EF      1A 10          ORCC    #$10   ;
F5F1 oB   6F 42          CLR     $02,U  ;						b = 0
F5F3      0D D0          TST     $D0    ;(DP$D0);				has a key been pressed?
F5F5 '    27 06          BEQ     $F5FD  ;						DONE
F5F7      96 EC          LDA     $EC    ;(DP$EC);				***** is this the key that was pressed? *****
F5F9      0F D0          CLR     $D0    ;(DP$D0);				unset the key press
->
Routine:
F5FB  B   A7 42          STA     $02,U  ;						b = last key pressed
F5FD 9    39             RTS            ;						DONE
->
;
;
;
;Routine:
;
; read screen coordinates from Y and only return is valid
;
F5FE  F   EC 46          LDD     $06,U  ;						row and column numbers from Y
F600  '   C1 27          CMPB    #$27   ;						column > 39?
F602 "1   22 31          BHI     $F635  ;						if so then out of screen area so end swi
F604      81 17          CMPA    #$17   ;						row > 23?
F606 "-   22 2D          BHI     $F635  ;						if so the out of screen area so end swi
F608 9    39             RTS            ;						done
->
;
;
;Routine:
;
; SWI FUNCTION 08
;
; Copy From Screen To A String
;
; Copies some number of characters from the current screen locaton
; to some location in RAM before E000
;
; D contains starting address of destination
; X is the length of the string to be copied
; Y is the screen location to copy from
;
F609      BD F5 D6       JSR     $F5D6  ;
F60C      8D F0          BSR     $F5FE  ;			read screen coordinates from Y
F60E      BD FE A2       JSR     $FEA2  ;			convert screen x/y into memory location in X
F611  "   EC 22          LDD     $02,Y  ;
F613 4    34 06          PSHS    D      ;
F615   A  10 AE 41       LDY     $01,U  ;			address of destination
->
F618  D   EC 44          LDD     $04,U  ;			load length to be copied
F61A '    27 1C          BEQ     $F638  ;			equal to zero so done
F61C      83 00 01       SUBD    #$0001 ;			subtract one
F61F  D   ED 44          STD     $04,U  ;			put it back
F621      AC E4          CMPX    ,S     ;			if X is > top of stack then stop
F623 "    22 10          BHI     $F635  ;			finished so done with SWI
F625      A6 80          LDA     ,X+    ;			read the character
F627 &    26 02          BNE     $F62B  ;			if its a \0 replace with a space
F629      86 20          LDA     #$20   ;			space character
->
F62B      10 8C E0 00    CMPY    #$E000 ;			if Y > E000 then we're done (so Y must therefore be memory before the screen)
F62F "    22 04          BHI     $F635  ;			finished so done with SWI
F631      A7 A0          STA     ,Y+    ;			store where Y points
F633      20 E3          BRA     $F618  ;			do it again
->
F635 ~    7E F2 17       JMP     $F217  ;			is this done SWI?
->
F638 5    35 86          PULS    PC,D   ;			done
->
;
;
;Routine:
;
; SWI FUNCTION 09
;
; Set Cursor Position
;
; A = Row
; B = Column
;
F63A      BD F5 D6       JSR     $F5D6  ;
F63D  A   EC 41          LDD     $01,U  ;
F63F      20 09          BRA     $F64A  ;
->
;
;
;Routine:
;
; SWI FUNCTION 0A
;
; Set Relative Cursor Position On Current Text Screen
;
; D = rows to move (+ve or -ve)
; X = columns to move (+ve or -ve)
;
;
F641      BD F5 D6       JSR     $F5D6  ;
F644  ,   EC 2C          LDD     $0C,Y  ;
F646  B   EB 42          ADDB    $02,U  ;
F648  A   AB 41          ADDA    $01,U  ;
->
F64A      8D B4          BSR     $F600  ;
F64C  ,   ED 2C          STD     $0C,Y  ;
F64E  .   A6 2E          LDA     $0E,Y  ;
F650 &    26 20          BNE     $F672  ;
F652 9    39             RTS            ;
->
;
;
;Routine:
;
; SWI FUNCTION 0B
; read cursor position
;
;
F653      BD F5 D6       JSR     $F5D6  ;
F656  ,   EC 2C          LDD     $0C,Y  ;
->
F658  A   ED 41          STD     $01,U  ;
F65A 9    39             RTS            ;
->
;
;
;Routine:
;
; SWI FUNCTION 0C
; read cursor character
;
;
F65B      BD F5 D6       JSR     $F5D6  ;
F65E      BD FE 9D       JSR     $FE9D  ;
F661      E6 84          LDB     ,X     ;
F663 O    4F             CLRA           ;
F664      20 F2          BRA     $F658  ;
->
;
;
;Routine:
;
; SWI FUNCTION 0D
; split screen into two
;
;
F666      BD F5 D6       JSR     $F5D6  ;
F669  A   A6 41          LDA     $01,U  ;
F66B      81 17          CMPA    #$17   ;
F66D #    23 01          BLS     $F670  ;
F66F O    4F             CLRA           ;
->
F670  .   A7 2E          STA     $0E,Y  ;
->
F672  ,   A1 2C          CMPA    $0C,Y  ;
F674 #    23 10          BLS     $F686  ;
F676 o)   6F 29          CLR     $09,Y  ;
F678      AE A4          LDX     ,Y     ;
F67A  $   AF 24          STX     $04,Y  ;
F67C J    4A             DECA           ;
F67D  (   A7 28          STA     $08,Y  ;
F67F  '   C6 27          LDB     #$27   ;
F681      BD FE A2       JSR     $FEA2  ;
F684      20 0E          BRA     $F694  ;
->
F686 _    5F             CLRB           ;
F687  )   A7 29          STA     $09,Y  ;
F689      BD FE A2       JSR     $FEA2  ;
F68C  $   ED 24          STD     $04,Y  ;
F68E      86 17          LDA     #$17   ;
F690  (   A7 28          STA     $08,Y  ;
F692  "   EC 22          LDD     $02,Y  ;
->
F694  &   ED 26          STD     $06,Y  ;
F696 9    39             RTS            ;
->
;
;
;Routine:
;
; SWI FUNCTION 0E
; clear text screen
;
;
F697      BD F5 D6       JSR     $F5D6  ;
F69A  B   A6 42          LDA     $02,U  ;
F69C -    2D 0C          BLT     $F6AA  ;
F69E &    26 06          BNE     $F6A6  ;
F6A0      10 8E EF C0    LDY     #$EFC0 ;
F6A4      20 04          BRA     $F6AA  ;
->
F6A6      10 8E EF CF    LDY     #$EFCF ;
->
F6AA ~ ]  7E FE 5D       JMP     $FE5D  ;
->
;
;
;Routine:
;
; SWI FUNCTION 0F
;
; Set Screen And Display Characteristics
;
; bits (in D) are:
;		15: not used
;		14: Mix (1) / Priority (0)
;		13: display screen 2 (1) / don't  (0)
;		12: select screen 5 (1) / select screen 2 (0)
;		11: display screen 1 (1) / don't (0)
;		10/09: screen 2 mix colour (00 = blue 01 = green 10 = red 11 = none)
;		08: not used
;		07: not used
;		06/05/04 :Background colour
;			06 = blue
;			05 = green
;			04 = red
;		03/02 screen 4 mix colour  (00 = blue 01 = green 10 = red 11 = none)
;		01 display screen 4 (1) don't (0)
;		00 display screen 3 (1) don't (0)
;
F6AD  A   EC 41          LDD     $01,U  ;				characterisitcs are in D
F6AF      B7 E0 00       STA     $E000  ;				store high byte into 6821
F6B2      F7 E0 02       STB     $E002  ;				store low byte into 6821
F6B5 9    39             RTS            ;				done
->
;
;
;Routine:
;
; SWI FUNCTION 10
;
; Read Display Mode
;
; For details see SWI function 0F
; Value is returned in D
;
F6B6      B6 E0 00       LDA     $E000  ;				load from 6821
F6B9  ~   84 7E          ANDA    #$7E   ;				turn high bit off
F6BB      F6 E0 02       LDB     $E002  ;				load from 6821
F6BE      C4 7F          ANDB    #$7F   ;				turn high bit off
F6C0      20 96          BRA     $F658  ;				save into D and return
->
;
;
;Routine:
;
; SWI FUNCTION 11
;
; Set The Clock
;
; Enable / Disable / Set real time clock
;
; Parameters
; B = 0 disable timer interrups
; B != 0 enable timer interrupts
; XhYhYl = current time in 100ths of a second since midnight
;
;
F6C2  B   E6 42          LDB     $02,U  ;
F6C4      D7 C2          STB     $C2    ;(DP$C2);		is the timer working (0 = disabled)
F6C6 &    26 0A          BNE     $F6D2  ;
F6C8      86 01          LDA     #$01   ;
F6CA   !  B7 E0 21       STA     $E021  ;	  			E021 = $01		timer control register 2 = $01 (write to control register 1)
F6CD      7F E0 20       CLR     $E020  ;				E020 = $00		timer control register 1 = $00 (disable IRQ)
F6D0      20 10          BRA     $F6E2  ;
->
F6D2      86 01          LDA     #$01   ;
F6D4   !  B7 E0 21       STA     $E021  ;	  			E021 = $01		timer control register 2 = $01 (write to control register 1)
F6D7  @   86 40          LDA     #$40   ;
F6D9      B7 E0 20       STA     $E020  ;				E020 = $40		timer control register 1 = $40 (enable IRQ)
F6DC   c  CC 00 63       LDD     #$0063 ;
F6DF   "  FD E0 22       STD     $E022  ;				E022 = $0063	latch 1 = $0063
->
F6E2      86 82          LDA     #$82   ;
F6E4   !  B7 E0 21       STA     $E021  ;	  			E021 = $82		timer control register 2 = $82 (output on pin O, use Enable clock)
F6E7      CC 13 9F       LDD     #$139F ;
F6EA   $  FD E0 24       STD     $E024  ;				E024 = $139F	latch 2 = $139F
F6ED  D   E6 44          LDB     $04,U  ;				load the current time from XhYhYl into E1E2E3
F6EF      D7 E1          STB     $E1    ;(DP$E1);		high byte of current time
F6F1  F   EC 46          LDD     $06,U  ;
F6F3      DD E2          STD     $E2    ;(DP$E2);		low word of current time
F6F5 9    39             RTS            ;				done
->
;
;
;Routine:
;
; SWI FUNCTION 12
; 
; Return the Time
;
; return the current time in 100ths of a second in XD
;
;
F6F6      8D 15          BSR     $F70D  ;				get the current time in XD
F6F8  A   ED 41          STD     $01,U  ;				store D as D
F6FA  D   AF 44          STX     $04,U  ;				then X as X
F6FC 9    39             RTS            ;				done
->
;
;
;Routine:
;
; SWI FUNCTION 13
;
; wait for some time (stored in D) measured in 100ths of a second
;
F6FD      8D 0E          BSR     $F70D  ;				get the current time in XD
F6FF 4    34 06          PSHS    D      ;				save the current time on the stack
->
F701      8D 0A          BSR     $F70D  ;				get the time now
F703      A3 E4          SUBD    ,S     ;				subtract what is was at the beginning (leaving how long it has been)
F705 +    2B FA          BMI     $F701  ;				make sure it's positive
F707  A   A3 41          SUBD    $01,U  ;				subtract how long we want to wait
F709 %    25 F6          BCS     $F701  ;				and if we'rw not done the go back for more
F70B 5    35 86          PULS    PC,D   ;				done
->
;
;
;
;Routine:
;
; return in XD the current time measured in 100ths of a second
;
F70D      0D C2          TST     $C2    ;(DP$C2);				check the timers are working
F70F  '   10 27 FB 04    LBEQ    $F217  ;						nope so finished with the SWI
F713   c  CC 00 63       LDD     #$0063 ;						100ths of a second
F716      1A 10          ORCC    #$10   ;						disable IRQ
F718   "  B3 E0 22       SUBD    $E022  ;						timer 1's current value (100ths of a second)
F71B      D3 E2          ADDD    $E2    ;(DP$E2);				the number of 100ths of a second since clock was set
F71D      1F 01          TFR     D,X    ;
F71F _    5F             CLRB           ;						bottom byte of D
F720      D9 E1          ADCB    $E1    ;(DP$E1);				top of 3 byte timer count
F722 O    4F             CLRA           ;						zero top byte of D
F723      1E 01          EXG     D,X    ;						XD now holds the current time
F725      1C EF          ANDCC   #$EF   ;						enable IRQ
F727 9    39             RTS            ;						done
->
;
;
;Routine:
;
; SWI FUNCTION 14
;
; Set PAUSE key flag
;
; Parameters
;	B: Value of the PAUSE key flag (0 = unset, 1 = set)
;
F728  B   E6 42          LDB     $02,U  ;					value to use
F72A      D7 CE          STB     $CE    ;(DP$CE);			PAUSE key flag
F72C 9    39             RTS            ;					done
->
;
;
;Routine:
;
; SWI FUNCTION 17
;
; Read Through Serial Port
;
; Time out if no message recieved for a second
;
;Input Paramters: 
;
;	Parameter 1: If negative then absolute value number of characters will be read.  Else
;				it is the ascii character on which to terminate input (up-to and including)
;	Parameter 2: The address into which to write
;
;Return Value: 
;	Number of characters read.
;	If negative or zero then timed out, and absolute value is the number
;	of characters read
;
F72D  D   AE 44          LDX     $04,U  ;			parameter 2, address into which to write
->
F72F      10 8E 00 00    LDY     #$0000 ;			clear y (timeout)
->
F733      B6 E0 04       LDA     $E004  ;			check status register
F736      85 01          BITA    #$01   ;			bit 1 (recieve data register full)
F738 &    26 0D          BNE     $F747  ;			read the data from the port
F73A 1!   31 21          LEAY    $01,Y  ;			inc y
F73C &    26 F5          BNE     $F733  ;			and again (until we time out)
->
F73E      8D 16          BSR     $F756  ;			how many chars did we read?
F740      CC 00 00       LDD     #$0000 ;			clear D
F743  A   A3 41          SUBD    $01,U  ;			invert the numner of chars we read
F745      20 13          BRA     $F75A  ;			store, done, return
->
F747      B6 E0 05       LDA     $E005  ;			load the data
F74A      84 7F          ANDA    #$7F   ;			turn the high bit off!
F74C      A7 80          STA     ,X+    ;			store and inc pointer
F74E  A   EC 41          LDD     $01,U  ;			parameter 1 (accumulator b is the stop char)
F750 -    2D 0B          BLT     $F75D  ;			counting chars not stop on char
F752      E1 1F          CMPB    $-01,X ;			compare what we read to the stop char
F754 &    26 D9          BNE     $F72F  ;			more to read
->
Routine:
F756      1F 10          TFR     X,D    ;			address of end of buffer
F758  D   A3 44          SUBD    $04,U  ;			subtract start of buffer (gives chars read)
->
F75A  A   ED 41          STD     $01,U  ;			store len as the return value
F75C 9    39             RTS            ;			done
->
F75D      C3 00 01       ADDD    #$0001 ;			inc number of chars read
F760  A   ED 41          STD     $01,U  ;			store back as parameter 1
F762 -    2D CB          BLT     $F72F  ;			more to read
F764      20 F0          BRA     $F756  ;			stpre numner of chars read, done, return
->
;
;
;Routine:
;
; SWI FUNCTION 18
;
; Write Through Serial Port
;
; All characters up-to and including the terminate are written, or given number of characters are written.
; Times out if no response for 1 second
;
; Input Parameters: 
; 	Parameter 1 (D): If negative then the absolute value is the number of characters to write,
;			otherwise it is the ascii of the character on which to terminate
;
; 	Parameter 2 (X): Address from which to read from
;
; Return Value (D): 
;	Number of characters output. 
;	If negative of 0 then timout occurred (and absolute value were written)
;
; Notes:  Must initialise the port first (write 3 into location $E004)
;         Must set baud rate (write to $E006)
;         Must set parity, bits, stop bits and so on (write to $E004)
;
F766  D   AE 44          LDX     $04,U  ;		address to read from
->
F768      10 8E 00 00    LDY     #$0000 ;		y = 0 (timeout)
->
F76C      B6 E0 04       LDA     $E004  ;		read status register
F76F      85 02          BITA    #$02   ;		check bit 2 (transmit data register)
F771 &    26 06          BNE     $F779  ;		check stop condition
F773 1!   31 21          LEAY    $01,Y  ;		y++
F775 &    26 F5          BNE     $F76C  ;		not yet timed out
F777      20 C5          BRA     $F73E  ;		timed out so do the same op as the read timeout, done
->
F779      A6 80          LDA     ,X+    ;		load the character to send
F77B      B7 E0 05       STA     $E005  ;		write to the data register
F77E  A   EC 41          LDD     $01,U  ;		load parameter 1 (termination condition)
F780 -    2D 06          BLT     $F788  ;		negative so chars to send
F782      E1 1F          CMPB    $-01,X ;		else compate to stop character
F784 &    26 E2          BNE     $F768  ;		more to read
F786      20 CE          BRA     $F756  ;		compute chars read, done
->
F788      C3 00 01       ADDD    #$0001 ;		add one to characters written
F78B  A   ED 41          STD     $01,U  ;		and save it
F78D -    2D D9          BLT     $F768  ;		more to read
F78F      20 C5          BRA     $F756  ;		compute chars read, done
->
;
;
;Routine:
;
; SWI FUNCTION 2E
;
; Read System Input/Output
;
; Parameter 1: if the second byte is zero then one byte is read, otherwise 2 bytes are read
; Return Value: The value read.  If only one byte is read then it will be inthe low order byte and the high
; order byte will be unchanged
;
;
F791  D   AE 44          LDX     $04,U  ;
F793  B   E6 42          LDB     $02,U  ;
F795 &    26 05          BNE     $F79C  ;
F797      E6 84          LDB     ,X     ;
F799  B   E7 42          STB     $02,U  ;
F79B 9    39             RTS            ;
->
F79C      EC 84          LDD     ,X     ;
F79E      20 BA          BRA     $F75A  ;
->
;
;
;Routine:
;
; SWI FUNCTION 2F
;
; Write System Input/Output
;
; Input Paramters: Parameter 1: the 1 or 2 bytes of data to be written to the specified address.  If only
; one byte is to be written, the low-order byte must contain the data
; Parameter 2: Address to write to
; Parameter 3: Zero indicates one byte is to be written, otherwise 2 bytes will be written
; Return value: None
;
;
F7A0  D   AE 44          LDX     $04,U  ;
F7A2  F   EC 46          LDD     $06,U  ;
F7A4 &    26 05          BNE     $F7AB  ;
F7A6  B   E6 42          LDB     $02,U  ;
F7A8      E7 84          STB     ,X     ;
F7AA 9    39             RTS            ;
->
F7AB  A   EC 41          LDD     $01,U  ;
F7AD      ED 84          STD     ,X     ;
F7AF 9    39             RTS            ;
->
;
;
;Routine:
;
; SWI FUNCTION 19
;
; Set Terminal Mode (Must reset to get out)
;
; Paramter 1: Baud Rate
;		00 = 9600
;		02 = 4800
;		04 = 2400
;		06 = 1200
;		08 =  600
;		0A =  300
;		0C = External Clock (cassette Interface)
; Parameter 2: Parity, etc.  The value must be 000xxx01 (so in the range 1..29)
;		7 bits, Even, 2 stop bits
;		7 bits,  Odd, 2 stop bits
;		7 bits, Even, 1 stop bits
;		7 bits,  Odd, 1 stop bits
;		8 bits, None,  2 stop bits
;		8 bits, None,  1 stop bits
;		8 bits, Even, 1 stop bits
;		8 bits,  Odd, 1 stop bits
;
; Return Value: None
;
;
F7B0      0C D5          INC     $D5    ;(DP$D5);
F7B2 o*   6F 2A          CLR     $0A,Y  ;
F7B4      86 03          LDA     #$03   ;			reset rs232 port
F7B6      B7 E0 04       STA     $E004  ;			register:	(reset the port)
F7B9  D   EC 44          LDD     $04,U  ;		parameter 2? word structure
F7BB      C4 1C          ANDB    #$1C   ;			0001 1100
F7BD      CA 81          ORB     #$81   ;			1000 0001
F7BF      F7 E0 04       STB     $E004  ;			register:	100xxx01
F7C2  A   EC 41          LDD     $01,U  ;		parameter 1? baud rate
F7C4      F7 E0 06       STB     $E006  ;			baud rate generator
->
F7C7      BD F2 93       JSR     $F293  ;
F7CA M    4D             TSTA           ;
F7CB '    27 20          BEQ     $F7ED  ;
F7CD      0D D6          TST     $D6    ;(DP$D6);
F7CF '    27 0A          BEQ     $F7DB  ;
F7D1      0F D6          CLR     $D6    ;(DP$D6);
F7D3  |   81 7C          CMPA    #$7C   ;
F7D5 '    27 0C          BEQ     $F7E3  ;
F7D7      84 1F          ANDA    #$1F   ;
F7D9      20 08          BRA     $F7E3  ;
->
F7DB  |   81 7C          CMPA    #$7C   ;
F7DD &    26 04          BNE     $F7E3  ;
F7DF      97 D6          STA     $D6    ;(DP$D6);
F7E1      20 E4          BRA     $F7C7  ;
->
F7E3      F6 E0 04       LDB     $E004  ;			load from status register
F7E6      C5 02          BITB    #$02   ;			check we can write
F7E8 '    27 F9          BEQ     $F7E3  ;			if not then wait until we can
F7EA      B7 E0 05       STA     $E005  ;			write to data register
->
F7ED      BE EF E4       LDX     $EFE4  ;			
F7F0      BC EF E6       CMPX    $EFE6  ;
F7F3 '    27 D2          BEQ     $F7C7  ;
F7F5      A6 80          LDA     ,X+    ;
F7F7      84 7F          ANDA    #$7F   ;
F7F9      8C 90 00       CMPX    #$9000 ;
F7FC %    25 03          BCS     $F801  ;
F7FE      8E 10 00       LDX     #$1000 ;
->
F801      BF EF E4       STX     $EFE4  ;
F804      BD FD DD       JSR     $FDDD  ;
F807      20 E4          BRA     $F7ED  ;
->
;
;
;Routine:
;
; SWI FUNCTION 1B
;
; switch to memory map 1
;
;
F809 O    4F             CLRA           ;
F80A      B7 DF F7       STA     $DFF7  ;			memory map number
F80D   `  B7 E0 60       STA     $E060  ;
F810 9    39             RTS            ;			done
->
;
;
;Routine:
;
; SWI FUNCTION 1A
;
; select standard memory map 2
;
;
F811   +  8E FF 2B       LDX     #$FF2B ;			ROM address of memory map 2
F814      8D 10          BSR     $F826  ;
;
;
;Routine:
;
; SWI FUNCTION 1C
;
; switch to memory map 2
;
;
F816      86 02          LDA     #$02   ;			memory map number
F818      B7 DF F7       STA     $DFF7  ;			stored at DFF7
F81B   p  B7 E0 70       STA     $E070  ;			
F81E 9    39             RTS            ;			done
->
;
;
;Routine:
;
; SWI FUNCTION 1D
; change configuration of memory map 2
;
;
F81F  A   AE 41          LDX     $01,U  ;
F821      8C DF F8       CMPX    #$DFF8 ;
F824 $C   24 43          BCC     $F869  ;
->
Routine:
F826      C6 08          LDB     #$08   ;
F828      10 8E DF F8    LDY     #$DFF8 ;
->
F82C      A6 80          LDA     ,X+    ;
F82E      A7 A0          STA     ,Y+    ;
F830 Z    5A             DECB           ;
F831 &    26 F9          BNE     $F82C  ;
F833 0    30 18          LEAX    $-08,X ;
F835    X 10 8E E0 58    LDY     #$E058 ;
->
Routine:
F839      A6 80          LDA     ,X+    ;
F83B C    43             COMA           ;
F83C      A7 A0          STA     ,Y+    ;
F83E    ` 10 8C E0 60    CMPY    #$E060 ;
F842 %    25 F5          BCS     $F839  ;
F844 9    39             RTS            ;
->
;
;
;Routine:
;
; SWI FUNCTION 1E
; select current text screen
;
;
F845  A   EC 41          LDD     $01,U  ;				PARAMETER D
F847      C1 05          CMPB    #$05   ;
F849 '    27 12          BEQ     $F85D  ;
F84B "    22 07          BHI     $F854  ;
F84D      8E EF CF       LDX     #$EFCF ;
F850      C4 02          ANDB    #$02   ;
F852 &    26 03          BNE     $F857  ;
->
F854      8E EF C0       LDX     #$EFC0 ;
->
F857      9F C0          STX     $C0    ;(DP$C0);
F859      7F DF F6       CLR     $DFF6  ;
F85C 9    39             RTS            ;
->
F85D      BE DF CA       LDX     $DFCA  ;
F860      8C E0 00       CMPX    #$E000 ;
F863 $    24 EF          BCC     $F854  ;
F865      F7 DF F6       STB     $DFF6  ;
F868 9    39             RTS            ;
->
F869 ~    7E F2 17       JMP     $F217  ;
->
;
;
;Routine:
;
; SWI FUNCTION 1F
;
; Select 24 line display for Teletext
;
F86C      B6 E0 0F       LDA     $E00F  ;		keyboard control register B
F86F  <   8A 3C          ORA     #$3C   ;		send a high down CB2
F871      20 05          BRA     $F878  ;		go and do it then finished
->
;
;
;Routine:
;
; SWI FUNCTION 20
;
; select 12 line display for Teletext
;
F873      B6 E0 0F       LDA     $E00F  ;		keyboard control register B
F876      84 F7          ANDA    #$F7   ;		send a low down CB2
->
F878      B7 E0 0F       STA     $E00F  ;		cause it to happen now
F87B 9    39             RTS            ;		done
->
;
;
;Routine:
;
; SWI FUNCTION 21
;
; Display first 12 lines of display
;
;
F87C      B6 E0 0D       LDA     $E00D  ;		keyboard control register A
F87F      84 F7          ANDA    #$F7   ;		send a low down CA2
F881      20 05          BRA     $F888  ;		go and do it then finish
->
;
;
;Routine:
;
; SWI FUNCTION 22
;
; Display last 12 lines of display
;
;
F883      B6 E0 0D       LDA     $E00D  ;		keyboard control register A
F886  <   8A 3C          ORA     #$3C   ;		send a high down CA2
->
F888      B7 E0 0D       STA     $E00D  ;		cause it to happen
F88B 9    39             RTS            ;		done
->
;
;
;Routine:
;
; SWI FUNCTION 23
; set scroll mode on text screen
;
;
F88C  B   E6 42          LDB     $02,U  ;
F88E      D7 D3          STB     $D3    ;(DP$D3);
F890 9    39             RTS            ;
->
;
;
;Routine:
;
; SWI FUNCTION 24
; map in memory page
;
;
F891  A   A6 41          LDA     $01,U  ;
F893      81 08          CMPA    #$08   ;
F895 $    24 D2          BCC     $F869  ;
F897  B   E6 42          LDB     $02,U  ;
F899      8E DF F8       LDX     #$DFF8 ;
F89C      E7 86          STB     A,X    ;
F89E   X  8E E0 58       LDX     #$E058 ;
F8A1 S    53             COMB           ;
F8A2      E7 86          STB     A,X    ;
F8A4 9    39             RTS            ;
->
;
;
;Routine:
;
; SWI FUNCTION 25
;
; return the value of the EXIT key flag in B
;
;
F8A5      D6 D1          LDB     $D1    ;(DP$D1);		get the value of the EXIT key flag
F8A7      0F D1          CLR     $D1    ;(DP$D1);		clear the EXIT key flag
F8A9  B   E7 42          STB     $02,U  ;				return in B
F8AB 9    39             RTS            ;				done
->
;
;
;Routine:
;
; SWI FUNCTION 29
;
; Reserved
;
F8AC  D   AE 44          LDX     $04,U  ;
F8AE      FC FF F0       LDD     $FFF0  ;						UID of machine
F8B1      ED 88 1C       STD     $1C,X  ;
F8B4 ~    7E FA FF       JMP     $FAFF  ;
->
;
;
;Routine:
;
; SWI FUNCTION 2A
;
; Reserved
;
F8B7      0C C9          INC     $C9    ;(DP$C9);
F8B9 9    39             RTS            ;
->
;
;
;
; Interrupt Vector:IRQ 
; 	Network interrupt
; 	Timer interrupt
; 	Keyboard interrupt
;
;
F8BA      86 EB          LDA     #$EB   ;						ADDRESS OF DP
F8BC      1F 8B          TFR     A,DP   ;						LOADED INTO DP TO AVOID POSSIBLE PROBLEMS
F8BE   0  B6 E0 30       LDA     $E030  ;						read the network status register 1
->
F8C1      85 01          BITA    #$01   ;						check if a byte of data has arrived from the network and is ready to be read
F8C3 &    26 09          BNE     $F8CE  ;						go and read the data
F8C5      85 02          BITA    #$02   ;						check if some other condition has occurred on the network
F8C7 '    27 19          BEQ     $F8E2  ;						nothing has so move on
F8C9      BD FB D7       JSR     $FBD7  ;					
F8CC      20 07          BRA     $F8D5  ;						check if data is ready to read and move on
->
F8CE   4  B6 E0 34       LDA     $E034  ;						read a byte of information from the network
F8D1      AD 9F EF DE    JSR     [$EFDE];						and do what ever is supposed to happen with it
->
F8D5   0  B6 E0 30       LDA     $E030  ;						read the network status register 1
F8D8 +    2B E7          BMI     $F8C1  ;						high bit is set so an interrupt has happened so go and process it
F8DA      96 C6          LDA     $C6    ;(DP$C6);
F8DC '    27 03          BEQ     $F8E1  ;						DONE
F8DE   @  B7 E0 40       STA     $E040  ;
->
F8E1 ;    3B             RTI            ;						DONE
->
F8E2   !  B6 E0 21       LDA     $E021  ;						read timer status register (Bits 7 = 1 on any IRQ.  Bits 0,1,2 are 1 on IRQ from timer 1,2,3)
F8E5 *:   2A 3A          BPL     $F921  ;						this wasn't a timer interrupt (so what was it?)
F8E7 _    5F             CLRB           ;						B = 0
->
F8E8 \    5C             INCB           ;						B = B + 1 (COUNTS THE BIT POS OF THE LOWEST SET BIT)
F8E9 F    46             RORA           ;						A /= 2
F8EA $    24 FC          BCC     $F8E8  ;						UNTIL THERE'S A 1 BIT (this is the timer that caused the interrupt)
F8EC      8E E0 20       LDX     #$E020 ;						timer interrupt (6840) base address
F8EF :    3A             ABX            ;						ADD THE BIT NUMBER
F8F0      AE 85          LDX     B,X    ;						LOAD X FROM THERE (this is $E020 * 2*B)
F8F2      0D C2          TST     $C2    ;(DP$C2);			dunno
F8F4 '$   27 24          BEQ     $F91A  ;					if zero then 
F8F6      C1 01          CMPB    #$01   ;						was it 6840 timer 1?
F8F8 &    26 20          BNE     $F91A  ;						nope
F8FA      0C C5          INC     $C5    ;(DP$C5);			yes so inc DP$C5
F8FC &    26 02          BNE     $F900  ;					if it isn't zero now
F8FE      0A C5          DEC     $C5    ;(DP$C5);			otherwise dec DP$C5
->
F900      DC E2          LDD     $E2    ;(DP$E2);				load bottom 2 btyes of timer
F902   d  C3 00 64       ADDD    #$0064 ;						add 100 ($64)
F905      DD E2          STD     $E2    ;(DP$E2);				save it
F907 $    24 02          BCC     $F90B  ;						if it didn't overflow then move on
F909      0C E1          INC     $E1    ;(DP$E1);				DP$E1 DP$E2 and DP$E3 are a 3 byte integer storing the numner of 100ths of a second since the timer began
->
F90B      9E E1          LDX     $E1    ;(DP$E1);				load the top two bytes
F90D      8C 83 D6       CMPX    #$83D6 ;						compate it to $83D6 (24 hours * 100 ($64) per second)
F910 %    25 04          BCS     $F916  ;						if less then ignore
F912      0F E1          CLR     $E1    ;(DP$E1);				otherwise reset the counter high byte
F914      0F E2          CLR     $E2    ;(DP$E2);				then the middle byte (low byte is already 0)
->
F916      0C CF          INC     $CF    ;(DP$CF);			inc cf
F918      20 02          BRA     $F91C  ;					inc eb then simulate nmi / firq
->
F91A      D7 D2          STB     $D2    ;(DP$D2);			bit pos of the lowest bit
->
F91C      0C EB          INC     $EB    ;(DP$EB);
F91E ~ H  7E FA 48       JMP     $FA48  ;							SIMULATE THE NMI / FIRQ
->
F921      0D E4          TST     $E4    ;(DP$E4);					after some point in initialisaiton
F923 &$   26 24          BNE     $F949  ;							MOVE ON TO THE KEYBOARD
F925      F6 E0 04       LDB     $E004  ;
F928 *    2A 1F          BPL     $F949  ;							MOVE ON TO THE KEYBOARD
F92A      0D D5          TST     $D5    ;(DP$D5);
F92C '    27 14          BEQ     $F942  ;
F92E      BE EF E6       LDX     $EFE6  ;
F931      B6 E0 05       LDA     $E005  ;
F934      A7 80          STA     ,X+    ;
F936      8C 90 00       CMPX    #$9000 ;
F939 %    25 03          BCS     $F93E  ;
F93B      8E 10 00       LDX     #$1000 ;
->
F93E      BF EF E6       STX     $EFE6  ;
F941 ;    3B             RTI            ;									DONE
->
F942      0C CA          INC     $CA    ;(DP$CA);
F944      0C EB          INC     $EB    ;(DP$EB);
->
F946 ~ H  7E FA 48       JMP     $FA48  ;									SIMULATE NMI / FIRQ
->
F949      F6 E0 0F       LDB     $E00F  ;									read the keyboard control register  (which will be -ve on an interrupt)
F94C  *   10 2A 00 F8    LBPL    $FA48  ;									SIMULATE NMI / FIRQ (becuase noting on the keyboard to read)
F950      F6 E0 0E       LDB     $E00E  ;									This is the keyboard and the high bit is set if the key is currently held down
F953 *    2A F1          BPL     $F946  ;									SIMULATE NMI / FIRQ
F955      C4 7F          ANDB    #$7F   ;									TURN HIGH BIT OFF			##### SPECIAL PROCESSING OF A KEY PRESS #####
F957      86 FF          LDA     #$FF   ;									LOAD WITH 255
F959      C1 1F          CMPB    #$1F   ;									COMPATE WITH US (Unit Seperator)
F95B /    2F 1A          BLE     $F977  ;									NON-PRINTABLE CHARACTER BEFORE ' ' (0..1F)
F95D  ?   C1 3F          CMPB    #$3F   ;									COMPARE WITH '?'
F95F /'   2F 27          BLE     $F988  ;									SPACE - NUMBERS - PUNCTUATION (20..3F)
F961  @   C1 40          CMPB    #$40   ;									COMPARE TO '@'
F963 /    2F 10          BLE     $F975  ;									CAN ONLY BE EQUAL TO '@' (AS 3F IS TAKEN CARE OF ALREADY)
F965  Z   C1 5A          CMPB    #$5A   ;									COMPARE TO UPPERCASE 'Z'
F967 /    2F 1F          BLE     $F988  ;									UPPERCASE CHARACTERS								
F969  `   C1 60          CMPB    #$60   ;									COMPARE TO '\''
F96B /    2F 06          BLE     $F973  ;									PUNCTUATION BETWEEN UPPER AND LOWER CASES
F96D  z   C1 7A          CMPB    #$7A   ;									COMPARERE TO LOWER CASE 'z'
F96F /    2F 17          BLE     $F988  ;									LOWER CASE CHARACTERS
F971      C0 1A          SUBB    #$1A   ;									OTHERWISE SUB $1A (THEN $1A THEN $20)
->
F973      C0 1A          SUBB    #$1A   ;									SUB $1A THEN (BELOW) $20 FROM $5B GIVES $21 (AND $60-> $26)
->
F975      C0 20          SUBB    #$20   ;									SUB $20 FROM $40 TO GIVE $20 
->
F977      8E F9 EC       LDX     #$F9EC ;									CHARACTER IS NOT ALPHABETIC SO DO A TABLE LOOKUP
F97A X    58             ASLB           ;									MULTIPLY BY 2
F97B      EC 85          LDD     B,X    ;									LOAD A AND B FROM THE LOOKUP TABLE AT $F9EC + (2 * CHAR)
F97D *    2A 05          BPL     $F984  ;									IF NEGATIVE IS ONE OF:00,03,04,05,07,0C,0E,0F,12,13,18,1C,1E,1F, '-', AND del
F97F      8E DF DE       LDX     #$DFDE ;									ALTERNATE LOOK UP TABLE
F982      A6 85          LDA     B,X    ;									GOT B FROM ALTERNATE LOOKUP TABLE (*****is this function keys?*****)
->
F984      1E 89          EXG     A,B    ;									CAME FROM A LOOKUP TABLE... SET B TO THE CHARACTER NOW
F986      20 06          BRA     $F98E  ;									MOVE ON
->
F988  #   C1 23          CMPB    #$23   ;									WAS IT A '#' CHARACTER?
F98A &    26 02          BNE     $F98E  ;									NOT A HASH SO MOVE ON
F98C  _   C6 5F          LDB     #$5F   ;									CONVERT INTO AN "_" AND MOVE ON
->
F98E      C1 20          CMPB    #$20   ;									WAS IT A ' ' CHARACTER?
F990 '    27 02          BEQ     $F994  ;									IF IT IS A SPACE THEN MOVE ON
F992      0F CE          CLR     $CE    ;(DP$CE);							IF NOT A SPACE THEN CLEAR PAUSE KEY FLAG (space and pause do not unset the flag)
->
F994 M    4D             TSTA           ;									COMPARE TO A LIST OF SPECIAL NON-ALPHABETICAL CHARACTERS
F995 +    2B 1E          BMI     $F9B5  ;									IF ALPHABETICAL THEN MOVE ON
F997 4    34 06          PSHS    D      ;									SAVE A AND BE
F999      1F 89          TFR     A,B    ;									NOW WE'RE GOING TO LOOK UP IN A LONG BIT STRING 
F99B D    44             LSRA           ;									DIVIDE BY 2 THREE TIMES
F99C D    44             LSRA           ;									BECAUSE THAT'LL GIVE US A BYTE NUMNER
F99D D    44             LSRA           ;									OK, GOT THE BYTE NUMBER
F99E      C4 07          ANDB    #$07   ;									NOW GET THE BIT NUMBER
F9A0      8E FA F4       LDX     #$FAF4 ;				   					TURN THE BIT ON (THIS IS A NUM TO BIT LOOKUP TABLE)
F9A3      E6 85          LDB     B,X    ;									TURN ON THE GIVEN BIT NUMBER
F9A5      8E DF E8       LDX     #$DFE8 ;									LOOKUP TABLE FOR WHICH SPECIAL CHARACTERS TO ACTION UPON
F9A8      E4 86          ANDB    A,X    ;									DOES THE KEY PRESSED AND THE ACTION KEY LIST MATCH?
F9AA '    27 07          BEQ     $F9B3  ;									NOPE SO MOVE ON
F9AC 5    35 06          PULS    D      ;									OTHERWISE RESTORE A AND B
F9AE L    4C             INCA           ;									INC SO THAT A CMP #$00 LATER WILL WORK (IT THEN DOES A DEC)
F9AF      97 C7          STA     $C7    ;(DP$C7);							STORE A AT DP$C7 (WE'VE HAD THE ACTION KEY PRESSED)
F9B1      20 20          BRA     $F9D3  ;									STORE AT DP$EB, SIMULATE A \0 AND DONE
->
F9B3 5    35 06          PULS    D      ;									RESTORE A AND  B
->
F9B5      C1 1C          CMPB    #$1C   ;					 				WAS IT A FS (File Seperator)
F9B7 &    26 04          BNE     $F9BD  ;					 				NO SO CONTINUE
F9B9      D7 CE          STB     $CE    ;(DP$CE);			 				yes so set PAUSE key flag
F9BB      20 16          BRA     $F9D3  ;					 				ON WE GO
->
F9BD      C1 1A          CMPB    #$1A   ;					 				WAS IT A SUB (SUBstitute)
F9BF &    26 04          BNE     $F9C5  ;					 				NO SO CONTINUE
F9C1      D7 D1          STB     $D1    ;(DP$D1);			 				YES so set EXIT key flag (DP$D1)
F9C3      20 0E          BRA     $F9D3  ;					 				ON WE GO
->
F9C5      C1 16          CMPB    #$16   ;					 				WAS IT A SYN (SYNchronous idle)
F9C7 &    26 04          BNE     $F9CD  ;					 				NO SO CONTINUE
F9C9      D7 CB          STB     $CB    ;(DP$CB);			 				YES SO STORE AT DP$CB
F9CB      20 06          BRA     $F9D3  ;					 				ON WE GO
->
F9CD      C1 17          CMPB    #$17   ;					 				WAS IT A ETB (End of Transition Block)
F9CF &    26 07          BNE     $F9D8  ;					 				NO SO CONTINUE
F9D1      D7 CC          STB     $CC    ;(DP$CC);			 				YES SO STORE AT DP$CC
->
F9D3      D7 EB          STB     $EB    ;(DP$EB);			 				STORE WHAT WE GOT AT DP$EB
F9D5 _    5F             CLRB           ;					 				CLEAR WHAT IT WAS AND PRETEND WE GOT A \0
F9D6      20 0C          BRA     $F9E4  ;									RECORD THAT A KEY HAS BEEN PRESSED
->
F9D8      BE DF D2       LDX     $DFD2  ;							***** this is the ordinary case *****
F9DB      8C E0 00       CMPX    #$E000 ;							***** why E000? dunno yet *****
F9DE $    24 04          BCC     $F9E4  ;									IF SO THEN STORE AT DP$EC AND DONE
F9E0      D7 C8          STB     $C8    ;(DP$C8);							STORE AT DP$C8
F9E2      20 EF          BRA     $F9D3  ;									THEN STORE AT DP$EB AND PRETEND WE GOT A \0 AND FINISH
->
F9E4      D7 EC          STB     $EC    ;(DP$EC);							STORE WHAT WE GOT AT DP$EC
F9E6      C6 01          LDB     #$01   ;									LOAD WITH TRUE
F9E8      D7 D0          STB     $D0    ;(DP$D0);							STORE THAT A KEY HAS BEEN PRESSED
F9EA  \   20 5C          BRA     $FA48  ;									SIMULATE AN NMI/FIRQ
->
;
; LOOK UP TABLE TO TRANSLATE CONTROL CHARACTERS
;
;    A  B               CHARACTER
F9EC 00 FF				; 00 null
F9EE 01 16 				; 01 ^a				KEY:INS CHAR
F9F0 02 17 				; 02 ^b				KEY:DEL CHAR
F9F2 03 FF 				; 03 ^c
F9F4 04 FF 				; 04 ^d
F9F6 05 FF 				; 05 ^e
F9F8 FF 09 				; 06 ^f				KEY:U9
F9FA 07 FF 				; 07 ^g
F9FC 08 12 				; 08 ^h				KEY:LEFT
F9FE 09 13 				; 09 ^i				KEY:RIGHT
FA00 18 14 				; 0A ^j				KEY:DOWN
FA02 19 15 				; 0B ^k				KEY:UP
FA04 0C FF 				; 0C ^l
FA06 0D 0C 				; 0D ^m				KEY:ENTER
FA08 0E FF 				; 0E ^n
FA0A 0F FF 				; 0F ^o
FA0C 11 18 				; 10 ^p				KEY:INS LINE
FA0E 1A 0A 				; 11 ^q				KEY:EXIT
FA10 12 FF 				; 12 ^r
FA12 13 FF 				; 13 ^s
FA14 FF 01 				; 14 ^t				KEY:U1
FA16 FF 02 				; 15 ^u				KEY:U2
FA18 FF 03 				; 16 ^v				KEY:U3
FA1A FF 04 				; 17 ^w				KEY:U4
FA1C 18 FF 				; 18 ^x
FA1E FF 05 				; 19 ^y				KEY:U5
FA20 FF 06 				; 1A ^z				KEY:U6
FA22 1C 0B 				; 1B ^[				KEY:PAUSE
FA24 1C FF 				; 1C ^\
FA26 FF 08 				; 1D ^]				KEY:U8
FA28 1E FF 				; 1E ^^
FA2A 1F FF 				; 1F ^_
;
FA2C 7C 1F				; 20 ; 40; (CHAR $40 - $20 SO ACTUALLY '@') KEY:|
;
FA2E 15 0F				; 21 ; 5B; (CHAR $5B - $20 - $1A SO ACTUALLY '[') KEY:BACK
FA30 23 1D 				; 22 ; 5C; '\'				KEY:Pound Currency
FA32 13 0D 				; 23 ; 5D; '['				KEY:NEXT
FA34 17 11 				; 24 ; 5E; '^'				KEY:CALC
FA36 FF 00 				; 25 ; 5F; '_'				KEY:U0
FA38 5E 1E				; 26 ; 60; '`'				KEY:EXP
;
FA3A 1A 0A				; 27 ; 7B; '{' (CHAR $7B - $1A - $1A - $20) KEY: EXIT
FA3C 40 1C 				; 28 ; 7C; '|'				KEY:@
FA3E 14 0E 				; 29 ; 7D; '}'				KEY:REPEAT
FA40 16 10 				; 2A ; 7E; '~'				KEY:HELP
FA42 FF 07				; 2B ; 7F; del				KEY:U7
->
;
;	FAKE AN NMI / FIRQ
;

FA44      1A 10          ORCC    #$10   ;							PREVENT IRQ PROCESSING (BECAUSE WE'RE IN A FIRQ)
FA46      0C C6          INC     $C6    ;(DP$C6);
->
Interrupt Vector:NMI FIRQ
FA48      0D C6          TST     $C6    ;(DP$C6);
FA4A 'y   27 79          BEQ     $FAC5  ;
FA4C      0D EB          TST     $EB    ;(DP$EB);
FA4E 'o   27 6F          BEQ     $FABF  ;		 					SET DP=0 AND DONE
FA50      0F EB          CLR     $EB    ;(DP$EB);
FA52      0D CA          TST     $CA    ;(DP$CA);
FA54 '    27 0C          BEQ     $FA62  ;		 
FA56      0F CA          CLR     $CA    ;(DP$CA);
FA58      BE DF DA       LDX     $DFDA  ;
FA5B      B6 E0 05       LDA     $E005  ;
FA5E  o   8D 6F          BSR     $FACF  ;
FA60  ]   20 5D          BRA     $FABF  ;							SET DP=0 AND DONE
->
FA62      F6 DF F6       LDB     $DFF6  ;
FA65 *    2A 0A          BPL     $FA71  ;
FA67      BE DF CA       LDX     $DFCA  ;
FA6A      C4 7F          ANDB    #$7F   ;
FA6C      F7 DF F6       STB     $DFF6  ;
FA6F  t   8D 74          BSR     $FAE5  ;
->
FA71      D6 D1          LDB     $D1    ;(DP$D1);					DID THE USER PRESS KEY $1A
FA73 '    27 07          BEQ     $FA7C  ;					  		NO SO CONTINUE
FA75      BE DF CC       LDX     $DFCC  ;					  		LOAD THE ACTION ADDRES
FA78      0F D1          CLR     $D1    ;(DP$D1);			  		WE'VE TAKEN CARE OF IT
FA7A  i   8D 69          BSR     $FAE5  ;					  		AND RTI WILL TAKE US THERE
->
FA7C      D6 CF          LDB     $CF    ;(DP$CF);
FA7E '    27 07          BEQ     $FA87  ;
FA80      0F CF          CLR     $CF    ;(DP$CF);
FA82      BE DF D8       LDX     $DFD8  ;
FA85  ^   8D 5E          BSR     $FAE5  ;
->
FA87      D6 C7          LDB     $C7    ;(DP$C7);			  		WAS A RE-PROGRAMMABLE KEY PRESSED? (IS THE THE FUNCTION KEYS?)
FA89 '    27 08          BEQ     $FA93  ;							NO SO CONTINUE
FA8B      0F C7          CLR     $C7    ;(DP$C7);			  		SERVICE ROUTINE HAS BEEN CALLED
FA8D Z    5A             DECB           ;							CONVERT BACK INTO RANGE 0..N
FA8E      BE DF D0       LDX     $DFD0  ;							LOAD ACTION ADDRESS
FA91  <   8D 3C          BSR     $FACF  ;							AND RTI WILL TAKE US THERE
->
FA93      D6 CC          LDB     $CC    ;(DP$CC);			  		DID THE USER PRESS KEY $17
FA95 '    27 07          BEQ     $FA9E  ;					  		NO SO CONTINUE
FA97      0F CC          CLR     $CC    ;(DP$CC);			  		TAKEN CARE OF IT
FA99      BE DF D6       LDX     $DFD6  ;							LOAD THE ACTION ADDRESS
FA9C  G   8D 47          BSR     $FAE5  ;							AND RTI WILL TAKE US THERE
->
FA9E      D6 CB          LDB     $CB    ;(DP$CB);					DID THE USER PRESS KEY $16
FAA0 '    27 07          BEQ     $FAA9  ;							NO SO CONTINUE
FAA2      0F CB          CLR     $CB    ;(DP$CB);					TAKE CARE OF IT
FAA4      BE DF D4       LDX     $DFD4  ;							LOAD ACTION ADDRESS
FAA7  <   8D 3C          BSR     $FAE5  ;							AND RTI WILL TAKE US THERE
->
FAA9      D6 C8          LDB     $C8    ;(DP$C8);
FAAB '    27 07          BEQ     $FAB4  ;
FAAD      0F C8          CLR     $C8    ;(DP$C8);
FAAF      BE DF D2       LDX     $DFD2  ;
FAB2      8D 1B          BSR     $FACF  ;
->
FAB4      D6 D2          LDB     $D2    ;(DP$D2);
FAB6 '    27 07          BEQ     $FABF  ;
FAB8      0F D2          CLR     $D2    ;(DP$D2);
FABA      BE DF CE       LDX     $DFCE  ;
FABD      8D 10          BSR     $FACF  ;
->
FABF _    5F             CLRB           ;						SET B = 0
FAC0      1F 9B          TFR     B,DP   ;						THEN TRANSFER TO DP (DP IS NOW ZERO)
->
Interrupt Vector:SWI2 SWI3 
FAC2   @  F7 E0 40       STB     $E040  ;						***** what's here? *****
->
FAC5 ;    3B             RTI            ;						DONE
->
FAC6      0F C9          CLR     $C9    ;(DP$C9);				CALLED FROM SWI WHEN $C9 IS NON-ZERO
FAC8      BE DF DC       LDX     $DFDC  ;						LOAD X WITH WHERE TO BRANCH TO
FACB      8D 18          BSR     $FAE5  ;						FIX THE STACK TO GO THERE ON RTI
FACD      20 F0          BRA     $FABF  ;						SET DP = 0 AND RTI TO [X]
->
;
;
;
;Routine:
;
; STACK ON ENTRY  : PCL PCH 
; STACK ON EXIT   : XL XH UL UH YL YH XL XH 00 B A $90
; THAT IS, X IS THE RETURN ADDRESS FROM THE INTERRUPT.
; WHICH IS THE NECESSARY STACK FOR RTI WITH CC=$90
; $90 IS THE ENTIRE | INTERRUPT FLAGS (PULL ALL REGISTERS)
;
FACF      8C E0 00       CMPX    #$E000 ;						IF TARGET ADDRESS IS IN ROM THEN IGNORE
FAD2 $    24 1F          BCC     $FAF3  ;						ROM SO IGNORE
FAD4 4p   34 70          PSHS    U,Y,X  ;						CREATE THE STACK NECESSART FOR A CC=E|I RTU
FAD6 o    6F E2          CLR     ,-S    ;						SET DP=0 ON RTI
FAD8 4    34 06          PSHS    D      ;						PUSH A AND B
FADA      C6 90          LDB     #$90   ;						SET CC TO E|I ON RTI
FADC 4    34 04          PSHS    B      ;						STACK THAT TOO
FADE   j  10 AE 6A       LDY     $0A,S  ;						WHERE WERE WE CALLED FROM?
FAE1  j   AF 6A          STX     $0A,S  ;						WHERE THE RTI WILL TAKE US
FAE3 n    6E A4          JMP     ,Y     ;						DONE
->
;
;
;Routine:
;
: STACK ON EXIT : XL XH 00
; THAT IS, CC = 0 AND X IS THE ADDRESS TO WHICH RTI WILL RETURN
;
FAE5      8C E0 00       CMPX    #$E000 ;						IF TARGET ADDRESS IS GREATER (IN ROM) THEN IGNORE
FAE8 $    24 09          BCC     $FAF3  ;						ROM SO IGNORE
FAEA      10 AE E4       LDY     ,S     ;						WHERE WE WERE CALLED FROM
FAED      AF E4          STX     ,S     ;						WHERE WE WANT TO GO TO
FAEF o    6F E2          CLR     ,-S    ;						SET CC TO 0 ON THE RTI
FAF1 n    6E A4          JMP     ,Y     ;						AND RETURN BECAUSE WE'RE DONE
->
FAF3 9    39             RTS            ;						DONE
->
;
; LOOKUP TABLE TO CONVERT BIT NUMBER INTO BIT THAT IS ON
;
FAF4 01 02 04 08 10 20 40 80
->
FAFC ~    7E F2 17       JMP     $F217  ;
->
;
;
;Routine:
;
; SWI FUNCTION 2B
; send message to master
;
; Parameter 1:
;	second byte contains message type
; Parameter 2:
;	start address of message
; Parameter 3:
;	length of message
;
; Return Value:
;	none - but cary is set on error
;
FAFF      8D 09          BSR     $FB0A  ; 				X = start address Y = end address of buffer
FB01  B   E6 42          LDB     $02,U  ; 				parameter 1 (message type)
FB03  %   8D 25          BSR     $FB2A  ;				do the work
->
FB05  A   A7 41          STA     $01,U  ;				return value (but it doesn't mean anything)
FB07 &    26 F3          BNE     $FAFC  ;				done
FB09 9    39             RTS            ;				done
->
;Routine:
;
; Put start address of network transfer buffer
; into X and end address into Y
;
FB0A  D   EC 44          LDD     $04,U  ;				parameter 2 (start address)
FB0C      1F 01          TFR     D,X    ;				x contains pointer to buffer to write into
FB0E  F   E3 46          ADDD    $06,U  ;				parameter 3 (length); D contains end of buffer
FB10      10 83 E0 00    CMPD    #$E000 ;				if end address == $E000
FB14 $    24 E6          BCC     $FAFC  ;				if greater then quit without doing anything
FB16      1F 02          TFR     D,Y    ;				y contains end address
FB18 9    39             RTS            ;				done
->
;
;
;
;Routine:
;
; read a byte from DP$C4 and compare to $33
;
FB19      0F C4          CLR     $C4    ;(DP$C4);				clear the last value
->
FB1B  1   8D 31          BSR     $FB4E  ;						CHECK DP$C5 >= $3C
FB1D &    26 07          BNE     $FB26  ;						IF IT IS THEN CLEAN UP AND DONE
FB1F      96 C4          LDA     $C4    ;(DP$C4);				LOAD A BYTE FROM DP$C4
FB21 '    27 F8          BEQ     $FB1B  ;						IF WE HAVE A ZERO THEN DO IT AGAIN
FB23  3   81 33          CMPA    #$33   ;						COMPARE TO $33
FB25 9    39             RTS            ;						DONE
->
FB26 2b   32 62          LEAS    $02,S  ; 						PULL THE RETURN ADDRESS FROM THE STACK TO CLEAN IT UP FOR A PULL
FB28  "   20 22          BRA     $FB4C  ;						AND WE'RE DONE
->
;
;
;
;Routine:
;	read the sequence $33 $n1 from DP$C4 then 
;	read one byte from DP$ED and make sure the high nibble is different from before
;	is DP$ED some kind of count of the number of bytes read?
;	is DP$E7 some kind of store of the number of bytes we have read?
;
;	software interrupt to send message to master comes here - it does the work
;
;	X = start address
;	Y = end address
;	B = network command
;
FB2A 44   34 34          PSHS    Y,X,B  ;						save start address, end address, and command
FB2C      10 DF F9       STS     $F9    ;(DP$F9);				save the stack for later use (to transmit with)
->
FB2F      8D E8          BSR     $FB19  ;						READ AND COMPARE TO $33
FB31 &    26 FC          BNE     $FB2F  ;						IF WE DON'T HAVE A $33 THEN TRY AGAIN
->
FB33      8D E4          BSR     $FB19  ;						READ AND COMPATE TO $33
FB35 '    27 FC          BEQ     $FB33  ;						IF WE HAVE A $33 THEN TRY AGAIN
FB37      84 0F          ANDA    #$0F   ;						LOOK AT THE BOTTOM NIBBLE
FB39      81 01          CMPA    #$01   ;						IS THE BOTTOM NIBBLE $01?
FB3B &    26 F6          BNE     $FB33  ;						IF THE BOTTOM NIBBLE IS NOT $01 THEN TRY AGAIN
FB3D      96 ED          LDA     $ED    ;(DP$ED);				***** network control field *****
FB3F D    44             LSRA           ;						.
FB40 D    44             LSRA           ;						.
FB41 D    44             LSRA           ;						.
FB42 D    44             LSRA           ;						look at the upper nibble
FB43      84 0E          ANDA    #$0E   ;						turn the low bit
FB45      91 E7          CMPA    $E7    ;(DP$E7);				compate to dp$e7
FB47 '    27 E6          BEQ     $FB2F  ;						if equal then start over
FB49      97 E7          STA     $E7    ;(DP$E7);				otherwise store it at dp$e7
FB4B O    4F             CLRA           ;						clear a and finish
->
FB4C 5    35 B4          PULS    PC,Y,X,B;						SO IT DOES A RTS TOO!
->
;
;
;
;Routine:
;
;  This appears to be a time-out.  If the Proteus doesn't reply within 60 seconds then the network is prbably broken
;	in which case we return A=2.  If we've seen a message then set A=0 (no error)
;
;	if DP$C5 >= #$3C THEN
;		DP$C5 = 0
;		network buffer end address = 0
;		RETURN A = 2
;	ELSE
;		RETURN A = 0
;
FB4E      96 C5          LDA     $C5    ;(DP$C5);				looks like a counter that incs each second between messages
FB50  <   81 3C          CMPA    #$3C   ;						this is 60 in dec so probably 1 minute
FB52 ,    2C 02          BGE     $FB56  ;						record error status and done
FB54 O    4F             CLRA           ;						A=0
FB55 9    39             RTS            ;						done
->
FB56 _    5F             CLRB           ;						B = 0
FB57 O    4F             CLRA           ;						A = 0 (D = 0)
FB58      97 C5          STA     $C5    ;(DP$C5);				start counting from zero
FB5A      DD E9          STD     $E9    ;(DP$E9);				clear network end address
FB5C      86 02          LDA     #$02   ;						A=2 (error)
FB5E 9    39             RTS            ;						done
->
Routine:
;
;
;Routine:
;
; SWI FUNCTION 2C
; revieve message from master
;
; Parameter 1:
;	not used								(D register)
; Parameter 2:
;	Start address of message to read		(X register)
; Parameter 3:
;	Max length of message to recieve		(Y register)
;
; Return Value
;	Parameter 1:
;		Second byte contains message type
;	Parameter 2:
;		Not changed (start address of message)
;	Parameter 3:
;		Length of message actually recieved
;	On error carry bit is set.
;
FB5F      8D A9          BSR     $FB0A  ;		x = start address y = end address
FB61      8D 07          BSR     $FB6A  ;
FB63  B   E7 42          STB     $02,U  ;		message type		
FB65   F  10 AF 46       STY     $06,U  ;		length read
FB68      20 9B          BRA     $FB05  ;
->
Routine:
FB6A  "   8D 22          BSR     $FB8E  ;					set up ready for a read (by copying vals into DP addresses)
->
FB6C      8D E0          BSR     $FB4E  ;					check for timeout
FB6E &    26 0E          BNE     $FB7E  ;					time-out so we're done
FB70      0D D4          TST     $D4    ;(DP$D4);			bytes remaining to be read
FB72 +    2B F8          BMI     $FB6C  ;					more to be read so wait in loop
FB74      DC F5          LDD     $F5    ;(DP$F5);			current address
FB76      93 F7          SUBD    $F7    ;(DP$F7);			start address, leaves length read
FB78      1F 02          TFR     D,Y    ;					y = length read
FB7A      D6 EE          LDB     $EE    ;(DP$EE);			message type
FB7C      96 D4          LDA     $D4    ;(DP$D4);			bytes remaining to be read
->
FB7E 9    39             RTS            ;					done
->
;
;
;
; Routine:
;
;
;
FB7F      0F F0          CLR     $F0    ;(DP$F0);				clear DP$F0
FB81      CC FD 98       LDD     #$FD98 ;						decode the loaded FLEX binary file
FB84      FD EF E0       STD     $EFE0  ;						this is what to do on completed load of packet
->
FB87      8E C4 00       LDX     #$C400 ;						start address of network recieve buffer
FB8A      10 8E C5 00    LDY     #$C500 ;						end address of network recieve buffer
->
FB8E      1A 10          ORCC    #$10   ;						this turns on the I bit (disable IRQ)
FB90      9F F7          STX     $F7    ;(DP$F7);				start address
FB92      9F F5          STX     $F5    ;(DP$F5);				current address
FB94      10 9F E9       STY     $E9    ;(DP$E9);				end address
FB97      86 FF          LDA     #$FF   ;						get 256 bytes
FB99      97 D4          STA     $D4    ;(DP$D4);				size in bytes
FB9B      1C EF          ANDCC   #$EF   ;						re-enable IRQ
FB9D 9    39             RTS            ;						done
->
Routine:
FB9E      CC 03 E8       LDD     #$03E8 ;					A = #$03 B = #$E8
FBA1   0  B7 E0 30       STA     $E030  ;					Address Control | Reciever Interupt Enable
FBA4   2  F7 E0 32       STB     $E032  ;					Online | Go active on Poll | Loop | Allow Packet Appends
->
Routine:
FBA7      96 E5          LDA     $E5    ;(DP$E5);			This is the byte to write to the network
->
;
; Routine:
;
; This appears to be the only place that a network write can occur.  
; Write accumulator A to the network
;
FBA9   0  F6 E0 30       LDB     $E030  ;					network status register 1
FBAC  @   C5 40          BITB    #$40   ;					TDRA / Frame Complete
FBAE &    26 0C          BNE     $FBBC  ;					write the byte to the network
FBB0      C5 20          BITB    #$20   ;					Tx Underrun
FBB2 &    26 0B          BNE     $FBBF  ;					done
FBB4   2  F6 E0 32       LDB     $E032  ;					status register 2
FBB7  @   C5 40          BITB    #$40   ;					Rx Overrun
FBB9 '    27 EE          BEQ     $FBA9  ;					do it again
FBBB 9    39             RTS            ;					done
->
FBBC   4  B7 E0 34       STA     $E034  ;					write to network data port
->
FBBF 9    39             RTS            ;					done
->
Routine:
FBC0      CC 02 11       LDD     #$0211 ;					Recieve Interrupt Enable, Transmit Last Data, Prioritised Status Enable
FBC3  6   8D 36          BSR     $FBFB  ;					set registers (and optionally RTS control)
FBC5   0  B6 E0 30       LDA     $E030  ;					network status register 1
FBC8      85 20          BITA    #$20   ;					Tx Underrun
FBCA '    27 F3          BEQ     $FBBF  ;					done
FBCC      86 80          LDA     #$80   ;					Tx Reset
FBCE   0  B7 E0 30       STA     $E030  ;					network control register 1
->
FBD1      86 02          LDA     #$02   ;					Reciever Interrupt Enable
->
FBD3   0  B7 E0 30       STA     $E030  ;					network control register 1
FBD6 9    39             RTS            ;					done
->
Routine:
FBD7   2  B6 E0 32       LDA     $E032  ;					read status register 2 from the 6854 network chip
FBDA      85 02          BITA    #$02   ;					check the Frame Valid bit
FBDC &^   26 5E          BNE     $FC3C  ;
FBDE      85 01          BITA    #$01   ;					check the Address Present bit
FBE0 &(   26 28          BNE     $FC0A  ;
FBE2      85 04          BITA    #$04   ;					check the Inactive Idle Recieve bit
FBE4 &    26 12          BNE     $FBF8  ;					enable interrupt, reset read, prioritize interrupts and done
FBE6  @   85 40          BITA    #$40   ;					check the Reciever Overrun bit
FBE8 '    27 05          BEQ     $FBEF  ;					transmit an abort and enable interrupt
FBEA  "   CC 22 01       LDD     #$2201 ;					enable interrupts, discard to end of frame, prioritise interupts
FBED      8D 0C          BSR     $FBFB  ;					send to 6854 and done
->
;
; network Reciever Overrun
;
FBEF   >  CC 03 3E       LDD     #$033E ;					enable interrupt, AC=1, transmit abort, word length 8 bits
FBF2   0  B7 E0 30       STA     $E030  ;					control register 1
FBF5   6  F7 E0 36       STB     $E036  ;					control register 4
->
Routine:
FBF8   !  CC 02 21       LDD     #$0221 ;					enable interrupt, reset read, prioritize status registers
->
Routine:
FBFB      DA E6          ORB     $E6    ;(DP$E6);			RTS Control Mode (either on or off)
->
Routine:
FBFD   0  B7 E0 30       STA     $E030  ;					control register 1
FC00   2  F7 E0 32       STB     $E032  ;					control register 2
FC03 9    39             RTS            ;					done
->
;
;Routine:
;
; set the address of the routine that will process
; the next byte of information from the network
;
;
FC04 5    35 06          PULS    D      ;						the place we were called from
FC06      FD EF DE       STD     $EFDE  ;						is where to go when we recieve the next network byte
FC09 9    39             RTS            ;						done
->
;
; Process Network ADDRESS FIELD
;
FC0A   4  B6 E0 34       LDA     $E034  ;						read a byte of data from the network 6854
FC0D      97 EF          STA     $EF    ;(DP$EF);				saved it
FC0F '    27 08          BEQ     $FC19  ;						if zero then read the frame (broadcast to all Poly)
FC11      91 E5          CMPA    $E5    ;(DP$E5);				else if equal to E5 (my ID)
FC13 '    27 04          BEQ     $FC19  ;						read the frame
FC15  "   86 22          LDA     #$22   ;						discard the current frame and set the interrupt bit
FC17      20 BA          BRA     $FBD3  ;						store in the network control register 1 and done
->
FC19      8D E9          BSR     $FC04  ;						continue on next line after next network byte recieved, and we're done
;
; Process the command
;
FC1B      97 ED          STA     $ED    ;(DP$ED);				Store the command at ED
FC1D  3   81 33          CMPA    #$33   ;						Was it $33?
FC1F '7   27 37          BEQ     $FC58  ;						***** dunno *****
FC21      84 11          ANDA    #$11   ;						***** are we checking the control / data bit here? *****
FC23      81 10          CMPA    #$10   ;
FC25 'H   27 48          BEQ     $FC6F  ;
->
FC27      8D DB          BSR     $FC04  ;						continue on next line after next network byte recieved
;
; ***** is this the first byte of parameters to the command *****
;
FC29      97 EE          STA     $EE    ;(DP$EE);				message type
FC2B      DC F7          LDD     $F7    ;(DP$F7);				pointer to start of network read buffer
FC2D      DD F5          STD     $F5    ;(DP$F5);				pointer to current location in network read buffer
FC2F      8D D3          BSR     $FC04  ;						continue on next line after next network byte recieved
;
; ***** read the remainder of the packet of data *****
;
FC31      9E F5          LDX     $F5    ;(DP$F5);				where the byte is to be stored
FC33      9C E9          CMPX    $E9    ;(DP$E9);				are we at the end of the buffer?
FC35 $    24 04          BCC     $FC3B  ;						yes we are so we're done
FC37      A7 80          STA     ,X+    ;						else store the byte
FC39      9F F5          STX     $F5    ;(DP$F5);				and save where the next byte goes
->
FC3B 9    39             RTS            ;						done
->
;
; Process Network FRAME VALID bit
;
FC3C      8D BA          BSR     $FBF8  ;						enable interrupt, reset read, prioritize interrupts
FC3E      0F C5          CLR     $C5    ;(DP$C5);
FC40   4  B6 E0 34       LDA     $E034  ;						read a byte of data from the network 6854
FC43      AD 9F EF DE    JSR     [$EFDE];						and process it
FC47      96 ED          LDA     $ED    ;(DP$ED);				The command type
FC49  }   27 7D          BEQ     $FCC8  ;						if it was a 00 we're done
FC4B  3   81 33          CMPA    #$33   ;						compare to $33
FC4D  H   27 48          BEQ     $FC97  ;						finish a $33 command
FC4F      84 11          ANDA    #$11   ;
FC51      81 10          CMPA    #$10   ;
FC53 't   27 74          BEQ     $FCC9  ;
FC55 ~    7E FC F4       JMP     $FCF4  ;						decode one of a set of commands and return
->
;
;	got <address> $33
;
;	send <address>, I, 00
;
FC58      0D C4          TST     $C4    ;(DP$C4);
FC5A &    26 10          BNE     $FC6C  ;						***** do nothing with the  data until next frame? *****
FC5C      BD FB 9E       JSR     $FB9E  ;						write my ID to the network
FC5F      96 E8          LDA     $E8    ;(DP$E8);		? construct an I packet?
FC61      9A E7          ORA     $E7    ;(DP$E7);		? construct an I packet?
FC63      8A 10          ORA     #$10   ;				? does this make it an I packet?
FC65      BD FB A9       JSR     $FBA9  ;						write accumulator A to the network
FC68 O    4F             CLRA           ;						A = 0
FC69      BD FB A9       JSR     $FBA9  ;						write accumulator A to the network
->
FC6C      8D 96          BSR     $FC04  ;						continue on next line after next network byte recieved
FC6E 9    39             RTS            ;						done
->
FC6F      D6 EF          LDB     $EF    ;(DP$EF);				Network machine ID of the message
FC71 '    27 1A          BEQ     $FC8D  ;						The message is a broadcast message (id=00)
FC73      BD FB 9E       JSR     $FB9E  ;						write DP$E5 (my Poly ID) to the network
FC76      9E E9          LDX     $E9    ;(DP$E9);				buffer end address
FC78 '    27 15          BEQ     $FC8F  ;
FC7A      96 ED          LDA     $ED    ;(DP$ED);				command from the network message
FC7C H    48             ASLA           ;
FC7D H    48             ASLA           ;
FC7E H    48             ASLA           ;
FC7F H    48             ASLA           ;
FC80      91 E8          CMPA    $E8    ;(DP$E8);
FC82 &    26 0B          BNE     $FC8F  ;
FC84  1   8B 31          ADDA    #$31   ;
->
FC86      BD FB A9       JSR     $FBA9  ;						write accumulator A to the network
FC89 O    4F             CLRA           ;						A = 0
FC8A      BD FB A9       JSR     $FBA9  ;						write accumulator A to the network
->
FC8D      20 98          BRA     $FC27  ;						the next byte is the first in the packet, DONE
->
FC8F      00 EF          NEG     $EF    ;(DP$EF);				address byte
FC91      96 E8          LDA     $E8    ;(DP$E8);
FC93      8A 11          ORA     #$11   ;
FC95      20 EF          BRA     $FC86  ;
->
FC97      0D C4          TST     $C4    ;(DP$C4);
FC99 '    27 09          BEQ     $FCA4  ;						??? put the packet back on the network ???
FC9B      86 04          LDA     #$04   ;						4 bytes to read
FC9D      97 D4          STA     $D4    ;(DP$D4);				store in bytes to read
FC9F O    4F             CLRA           ;						load 0 into A
FCA0 _    5F             CLRB           ;						load 0 into B (and D)
FCA1      DD E9          STD     $E9    ;(DP$E9);				end of network buffer read address is now NULL
FCA3 9    39             RTS            ;						done
->
FCA4      DE F9          LDU     $F9    ;(DP$F9);				load stack with address that points to command, start address, and end address
FCA6      A6 C0          LDA     ,U+    ;						command
FCA8      BD FB A9       JSR     $FBA9  ;						write accumulator A to the network
FCAB      CC 01 A8       LDD     #$01A8 ;						**
FCAE   0  B7 E0 30       STA     $E030  ;						**
FCB1   2  F7 E0 32       STB     $E032  ;						**
FCB4      AE C1          LDX     ,U++   ;						packet start address
->
FCB6      AC C4          CMPX    ,U     ;						packet end address
FCB8 $    24 07          BCC     $FCC1  ;						all sent
FCBA      A6 80          LDA     ,X+    ;						get the net byte in A
FCBC      BD FB A9       JSR     $FBA9  ;						write accumulator A to the network
FCBF      20 F5          BRA     $FCB6  ;						loop back and send the next byte
->
FCC1      BD FB C0       JSR     $FBC0  ;						make sure the send was completed successfully
FCC4      96 ED          LDA     $ED    ;(DP$ED);				command from the packet
->
FCC6      97 C4          STA     $C4    ;(DP$C4);				store the command in DP$C4
->
FCC8 9    39             RTS            ;						DONE
->
FCC9      D6 EF          LDB     $EF    ;(DP$EF);				ID of target machine
FCCB      27 1A          BEQ     $FCE7  ;						its a broadcast message
FCCD O    4F             CLRA           ;						A = 0
FCCE      BD FB A9       JSR     $FBA9  ;						write accumulator A to the network
FCD1      CC 01 A8       LDD     #$01A8 ;						select register 3, go online, loop mode, allow go-ahead (set 01 mode)
FCD4   0  B7 E0 30       STA     $E030  ;						write to control register 1
FCD7   2  F7 E0 32       STB     $E032  ;						write to control register 3
FCDA      BD FB C0       JSR     $FBC0  ;						reset ready for next message
FCDD      D6 EF          LDB     $EF    ;(DP$EF);				ID of target machine
FCDF +    2B 12          BMI     $FCF3  ;						if high bit set then DONE
FCE1      96 E8          LDA     $E8    ;(DP$E8);				load from E8		(packets read?)
FCE3      8B 20          ADDA    #$20   ;						add $20 to it		(add 1)
FCE5      97 E8          STA     $E8    ;(DP$E8);				store it back there	(put it back)
->
FCE7 O    4F             CLRA           ;						clear A
FCE8 _    5F             CLRB           ;						clear B (D=0)
FCE9      DD E9          STD     $E9    ;(DP$E9);				end of buffer = 0
FCEB      97 D4          STA     $D4    ;(DP$D4);				bytes to read = 0 
FCED      96 F1          LDA     $F1    ;(DP$F1);
FCEF  &   10 26 00 80    LBNE    $FD73  ;						check for a boot command
->
FCF3 9    39             RTS            ;						DONE
->
FCF4      96 ED          LDA     $ED    ;(DP$ED);				command from server
FCF6      81 17          CMPA    #$17   ;						is it a $17			SIM (Set Initialisation Mode, initiate loop setup)
FCF8 '    27 13          BEQ     $FD0D  ;						Reset networking
FCFA      81 BF          CMPA    #$BF   ;						is it a $BF			XID (Exchange ID)
FCFC '-   27 2D          BEQ     $FD2B  ;						send the ID of this machine to the server
FCFE  s   81 73          CMPA    #$73   ;						is it a $73			UA (Unnumbered Acknowledge)
FD00 'K   27 4B          BEQ     $FD4D  ;						enter loop online
FD02      81 13          CMPA    #$13   ;						is it a $13			UI (Unnumbered Information)
FD04 'W   27 57          BEQ     $FD5D  ;						turn on interrupts
FD06      81 1B          CMPA    #$1B   ;						is it a $1B			?? logoff ??
FD08 '[   27 5B          BEQ     $FD65  ;						?? execute a command then logoff ??
FD0A ~    7E FC C6       JMP     $FCC6  ;						not a recognised command so store for later and done
->
FD0D      8E 00 C8       LDX     #$00C8 ;						x = $C8
->
FD10 0    30 1F          LEAX    $-01,X ;						x = x - 1
FD12 &    26 FC          BNE     $FD10  ;						and do it again (this is a timing loop!)
FD14      9F E7          STX     $E7    ;(DP$E7);				DP$E7 = 0
FD16      86 FF          LDA     #$FF   ;
FD18      97 E5          STA     $E5    ;(DP$E5);				DP$E5 = 0xFF
FD1A      0F E6          CLR     $E6    ;(DP$E6);				DP$E6 = 0		RTS mode
FD1C      CC C1 08       LDD     #$C108 ;						Tx reset, Rx reset, ac=1, 01 idle mode
FD1F      BD FB FD       JSR     $FBFD  ;						because ac=1 write to control register 1 and 3
FD22      CC C0 01       LDD     #$C001 ;						Tx reset, Rx reset, Prioritised Status Enable
FD25      BD FB FD       JSR     $FBFD  ;						write to control register 1 and 2
FD28 ~    7E FB D1       JMP     $FBD1  ;						enable interrupt on network and done
->
FD2B      0D E5          TST     $E5    ;(DP$E5);
FD2D .    2E C4          BGT     $FCF3  ;						DONE
FD2F      96 EE          LDA     $EE    ;(DP$EE);				message type (first byte of packet)
FD31      97 E5          STA     $E5    ;(DP$E5);				byte to send on network (the ID of the current Poly)
FD33      BD FB A7       JSR     $FBA7  ;						send DP$E5 to the network
FD36      86 13          LDA     #$13   ;						load $13 to next send to the network
FD38      BD FB A9       JSR     $FBA9  ;						write accumulator A to the network
FD3B      B6 FF F0       LDA     $FFF0  ;						uid of machine?
FD3E      BD FB A9       JSR     $FBA9  ;						write accumulator A to the network
FD41      B6 FF F1       LDA     $FFF1  ;						uid of machine?
FD44      BD FB A9       JSR     $FBA9  ;						write accumulator A to the network
FD47      CC 02 11       LDD     #$0211 ;						Recieve interupt enable, Transmit last data, Prioritised Status Enable
FD4A ~    7E FB FD       JMP     $FBFD  ;						write to control register 1 and 2 and done
->
FD4D      86 80          LDA     #$80   ;
FD4F      97 E6          STA     $E6    ;(DP$E6);				DP$E6 = $80		RTS mode
FD51      CC 03 A8       LDD     #$03A8 ;						Recieve interrupt enable, ac=1, Loop online control DTR, loop mode, 01 idle mode
FD54      BD FB FD       JSR     $FBFD  ;						as ac=1 set control registers 1 and 3
FD57      CC 02 81       LDD     #$0281 ;						Recieve interrupt enable, ac=0, RTS control, Prioritised Status Enable
FD5A ~    7E FB FD       JMP     $FBFD  ;						write to control registers 1 and 2 then done
->
FD5D      0F E6          CLR     $E6    ;(DP$E6);				DP$E6 = $00		RTS mode
FD5F      CC 02 01       LDD     #$0201 ;						Recieve interrupt enable, Prioritised status enable
FD62 ~    7E FB FD       JMP     $FBFD  ;						write to control regsters 1 and 3 then done
->
FD65      BD FB 7F       JSR     $FB7F  ;						recieve a FLEX binary file from the network
FD68      86 FF          LDA     #$FF   ;						load $FF
FD6A      97 F1          STA     $F1    ;(DP$F1);				DP$F1 = $FF
FD6C      D6 C3          LDB     $C3    ;(DP$C3);				load B from DP$C3
FD6E  '   10 27 F3 02    LBEQ    $F074  ;						Logoff!
FD72 9    39             RTS            ;						DONE
;
; no more bytes to read
; and we have a command $10 (boot command?)
; so load start address and do the next command
; if we don't have a command $10 then
; initialise a load into $C400-$C500
;
FD73      0D D4          TST     $D4    ;(DP$D4);				bytes remaining to be read
FD75 &    26 18          BNE     $FD8F  ;						DONE
FD77      96 EE          LDA     $EE    ;(DP$EE);				message type
FD79      81 10          CMPA    #$10   ;						was it a command $10?
FD7B &    26 18          BNE     $FD95  ;						load from network into $C400-$C500
; command $10 (is this the boot command?)
FD7D      9E F7          LDX     $F7    ;(DP$F7);				ponter to start of network read buffer
FD7F      FC EF E0       LDD     $EFE0  ;						where to go next
FD82 4    34 06          PSHS    D      ;						is pushed onto the stack for a later return
FD84      DC F5          LDD     $F5    ;(DP$F5);				current read address
FD86      93 F7          SUBD    $F7    ;(DP$F7);				ponter to start of network read buffer
FD88      20 03          BRA     $FD8D  ;						at this point B contains the amount read
->
FD8A Z    5A             DECB           ;						process another byte
FD8B '    27 03          BEQ     $FD90  ;						load from network into $C400-$C500 if we have run-out
->
FD8D      A6 80          LDA     ,X+    ;						get the next byte from the network read buffer
->
FD8F 9    39             RTS            ;						DONE
;
; routine
; load from the network into $C400-$C500 and return
;
FD90 5    35 10          PULS    X      ;						JSR this code and it will load from the network and return to the next line of code
FD92      BF EF E0       STX     $EFE0  ;						where to go after the network load is done
->
FD95 ~    7E FB 87       JMP     $FB87  ;						load from network into $C400-$C500
->
;
;Routine:
;	This appears to decode a standard FLEX binary file with one exception...
;	command $04 is not a FLEX command and appears to signal the end of the boot loader
;
FD98      81 02          CMPA    #$02   ;				did we get a $02
FD9A '    27 14          BEQ     $FDB0  ;				load address and count then copy count bytes to address
FD9C      81 04          CMPA    #$04   ;				did we get a $04
FD9E '    27 0A          BEQ     $FDAA  ;				signal that the boot loader is loaded
FDA0      81 16          CMPA    #$16   ;				did we get a $16
FDA2 &5   26 35          BNE     $FDD9  ;				toss the byte and move on to the next one
FDA4      8D E4          BSR     $FD8A  ;				load a byte
FDA6      8D E2          BSR     $FD8A  ;				load a byte
FDA8  /   20 2F          BRA     $FDD9  ;				load a third byte and decode that
->
FDAA      8D DE          BSR     $FD8A  ;				load a byte
FDAC      97 F0          STA     $F0    ;(DP$F0);		store it where it gets checked on startup
FDAE  )   20 29          BRA     $FDD9  ;				continue decoding
->
FDB0      8D D8          BSR     $FD8A  ;				load a high byte
FDB2      B7 EF E2       STA     $EFE2  ;				store high byte
FDB5      8D D3          BSR     $FD8A  ;				load low byte
FDB7      B7 EF E3       STA     $EFE3  ;				store low byte
FDBA      8D CE          BSR     $FD8A  ;				load another byte (length byte)
FDBC      97 F2          STA     $F2    ;(DP$F2);		store in DP$F2
FDBE      10 BE EF E2    LDY     $EFE2  ;				load Y as the word that was stored
->
FDC2 Z    5A             DECB           ;				we read a byte
FDC3 &    26 0C          BNE     $FDD1  ;
FDC5      10 BF EF E2    STY     $EFE2  ;				save Y
FDC9      8D C5          BSR     $FD90  ;				load next packet from network into $C400-$C500
FDCB      10 BE EF E2    LDY     $EFE2  ;				restore Y
FDCF      20 02          BRA     $FDD3  ;				skip next instruction
->
FDD1      A6 80          LDA     ,X+    ;				get the next byte
->
FDD3      A7 A0          STA     ,Y+    ;				store A where Y points!
FDD5      0A F2          DEC     $F2    ;(DP$F2);		number of bytes to store at Y
FDD7 &    26 E9          BNE     $FDC2  ;				more to get
->
FDD9      8D AF          BSR     $FD8A  ;				read the next byte
FDDB      20 BB          BRA     $FD98  ;				and continue the decoding
->
;
;
;
;Routine:
;
; PRINT CHARACTER (IN A, IF PRINTABLE), MOVE CURSOR AND SCROLL IF NECESSARY
; Y POINTS TO THE SCREEN CONTROL BLOCK BECAUSE (DP$C0) IS THE ADDRESS OF THE SCREEN CONTROL BLOCK
;
; LOOKS LIKE WE HAVE TWO MODES, $0E/$0F AND $1B/$10
;
; MODE $0B,Y = 1 HAS THE RESULT OF SETTING THE HIGH BIT OF THE CHARACTER (DOES THIS SET BLOCK GRAPHICS MODE?)
; MODE $0A,Y = 1 HAS THE RESULT OF SETTING FUNCTIONAL CHARACTERS MODE (CLS, ETC)
;
;
;
FDDD 46   34 36          PSHS    Y,X,D  ;					SAVE THE PARAMETERS THAT GET TRASHED LATER
FDDF      10 9E C0       LDY     $C0    ;(DP$C0);			LOAD THE SCREEN CONTROL BLOCK
FDE2      84 7F          ANDA    #$7F   ;					ASCII DEL CODE
FDE4 '9   27 39          BEQ     $FE1F  ;					DO NOTHING (RETURN)
FDE6      81 20          CMPA    #$20   ;					IS IT >= $20 (SPACE OR LATER)
FDE8 ,    2C 20          BGE     $FE0A  ;					
FDEA      81 0E          CMPA    #$0E   ;					SO (Slide Out?)
FDEC &    26 04          BNE     $FDF2  ;					NOPE SO MOVE ON
FDEE o*   6F 2A          CLR     $0A,Y  ;					YES SO $0A,Y = 0
FDF0  *   20 2A          BRA     $FE1C  ;					SCROLL AND DONE
->
FDF2      81 0F          CMPA    #$0F   ;					SI (Slide In?)
FDF4 &    26 04          BNE     $FDFA  ;					NOPE SO MOVE ON
FDF6  *   A7 2A          STA     $0A,Y  ;					YES SO STORE $0A,Y = $0F
FDF8  "   20 22          BRA     $FE1C  ;					SCROLL AND DONE
->
FDFA      81 1B          CMPA    #$1B   ;					Esc
FDFC &    26 04          BNE     $FE02  ;					NOPE SO MOVE ON
FDFE o+   6F 2B          CLR     $0B,Y  ;					YES SO SET $0B,Y = 0
FE00      20 1A          BRA     $FE1C  ;					SCROLL AND DONE
->
FE02      81 10          CMPA    #$10   ;					Line Feed
FE04 &    26 04          BNE     $FE0A  ;					NOPE SO MOVE ON
FE06  +   A7 2B          STA     $0B,Y  ;					YES SO SET $0B,Y = $10
FE08      20 12          BRA     $FE1C  ;					SCROLL AND DONE
->
FE0A m*   6D 2A          TST     $0A,Y  ;					ARE WE IN THE $0A MODE?
FE0C &    26 08          BNE     $FE16  ;					IF WE ARE THEN NORMAL MODE
FE0E      81 1F          CMPA    #$1F   ;					CHARACTER >= SPACE
FE10 "    22 04          BHI     $FE16  ;					IF SO THEN PRINT IT
FE12      8D 0D          BSR     $FE21  ;					ELSE ITS A SPECIAL CHARACTER
FE14      20 06          BRA     $FE1C  ;					SCROLL AND DONE
->
FE16      A6 E4          LDA     ,S     ;					LOAD A FROM TOP OF STACK
FE18  t   8D 74          BSR     $FE8E  ;					OUTPUT TO THE CURRENT ROW/COL POSITION
FE1A l-   6C 2D          INC     $0D,Y  ;					INC COLUMN POSITION
->
FE1C      BD FE B0       JSR     $FEB0  ;					IF NECESSARY SCROLL AND MAKE SURE STILL ONSCREEN
->
FE1F 5    35 B6          PULS    PC,Y,X,D;					RETURN
->
;
;
;
;Routine:
;
; PRINT SPECIAL CHARACTERS  (*****  to be documented *****)
; BUT BY ENTERING AT $FE24 IT IS USED FOR GENERAL BRANCH TABLE LOOKUP
;
FE21 0    30 8C 0F       LEAX    $0F,PC ;  					LOAD THE ADDRESS OF THE BRANCH TABLE
->
FE24 m    6D 84          TST     ,X     ;					COMPARE TO ZERO
FE26 '    27 08          BEQ     $FE30  ;					IF AT END OF TABLE THEN BRANCH
FE28      A1 84          CMPA    ,X     ;					OR, IF WE MATCH THE SPECIAL CHARACTER
FE2A '    27 04          BEQ     $FE30  ;					THEN BRANCH
FE2C 0    30 03          LEAX    $03,X  ;					ADD 3 TO X (NEXT ROW IN TABLE)
FE2E      20 F4          BRA     $FE24  ;					THEN KEEP GOING (MUST EXIT AT END OF TABLE AT WORST)
->
FE30 n    6E 98 01       JMP     [$01,X];					BRANCH TO THE ADDRESS IN THE BRANCH TABLE
->
;
;
;
; BRANCH TABLE FOR SPECIAL CHARACTERS
;
FE33 0D FE 4E 		; CARIDGE RETURN
FE36 0A FE 51 		; LINE FEED
FE39 08 FE 57 		; BACK SPACE
FE3C 09 FE 5A 		; HORIZONTAL TAB
FE3F 0C FE 5D 		; FORM FEED
FE42 0B FE 54 		; VERTICAL TAB
FE45 1E FE 6E 		; RECORD SEPERATOR
FE48 07 FE 7B 		; BELL
FE4B 00 FE 50 		; NUll
->
;
;
;
;Routine:
;
; SET CURSOR TO START OF LINE
;
FE4E o-   6F 2D          CLR     $0D,Y  ;					SET THE COLUMN ADDRESS TO 0 (START OF LINE)
FE50 9    39             RTS            ;					DONE
->
;
;
;
;Routine:
;
; SET CURSOR TO TOP OF PAGE
;
FE51 l,   6C 2C          INC     $0C,Y  ;					SET ROW ADDRESS TO 0 (TOP OF PAGE)
FE53 9    39             RTS            ;					DONE
->
;
;
;
;Routine:
;
; MOVE CURSOR UP
;
FE54 j,   6A 2C          DEC     $0C,Y  ;					DEC ROW ADDRESS BY 1 (UP)
FE56 9    39             RTS            ;					DONE
->
;
;
;
;Routine:
;
; MOVE CURSOR LEFT 
;
FE57 j-   6A 2D          DEC     $0D,Y  ;					DEC COLUMN BY 1 (LEFT)
FE59 9    39             RTS            ;					DONE
->
;
;
;
;Routine:
;
; MOVE CURSOR RIGHT
;
FE5A l-   6C 2D          INC     $0D,Y  ;					INC COLUMN BY 1 (RIGHT)
FE5C 9    39             RTS            ;					DONE
;
;
;
;Routine:
;
; CLEAR SCREEN AND HOME CURSOR
;
FE5D _    5F             CLRB           ;					SET B TO 0
FE5E O    4F             CLRA           ;					SET A TO 0 (WHICH SETS D TO 0)
FE5F  $   AE 24          LDX     $04,Y  ;					START OF TEXT SCREEN
->
FE61      ED 81          STD     ,X++   ;					CLEAR THE NEXT TWO CHARACTERS
FE63  &   AC 26          CMPX    $06,Y  ;					UNTIL THE END OF THE GRAPHICS SCREEN
FE65 #    23 FA          BLS     $FE61  ;					KEEP GOING
FE67  )   A6 29          LDA     $09,Y  ;					LOAD THE LEFT WINDOW BORDER NUMBER
FE69  ,   A7 2C          STA     $0C,Y  ;					SET ROW NUMBER
FE6B o-   6F 2D          CLR     $0D,Y  ;					CLEAR COLUMN NUMBER
FE6D 9    39             RTS            ;					DONE
->
;
;
;
;Routine:
;
; CLEAR TO END OF LINE
;
FE6E  0   8D 30          BSR     $FEA0  ;					GET MEMORY ADDRESS OF ROW / COL
FE70  (   C6 28          LDB     #$28   ;					LOAD B WITH 40 (COL COUNT)
FE72  -   E0 2D          SUBB    $0D,Y  ;					CURRENT COLUMN NUMBER
FE74 O    4F             CLRA           ;					A = 0
->
FE75      A7 80          STA     ,X+    ;					CLEAR THAT ADDRESS
FE77 Z    5A             DECB           ;					MOVE ON TO THE NEXT POSITION
FE78 &    26 FB          BNE     $FE75  ;					AGAIN
->
FE7A 9    39             RTS            ;					DONE
->
;
;
;
;Routine:
;
; CHARACTER 7 BELL ROUTINE
;
FE7B      0D C2          TST     $C2    ;(DP$C2);
FE7D '    27 FB          BEQ     $FE7A  ;					DONE
FE7F      8E 00 1E       LDX     #$001E ;					X = 30
FE82      CC 03 BF       LDD     #$03BF ;					D = 959
FE85 4    34 7F          PSHS    U,Y,X,DP,D,CC;				PUSH PRETTY MUCH EVERYTHING
FE87  C   1F 43          TFR     S,U    ;					SAVE THE CURRENT STACK POSITION (PRESUMABLY IT GETS TRASHED)
FE89      BD F5 8A       JSR     $F58A  ;
FE8C 5    35 FF          PULS    PC,U,Y,X,DP,D,CC;			PULL EVERYTHING INCLUDING PC (SO DONE)
->
;
;
;
;Routine:
;
; PRINT A CHARACTER (IN A) TO THE TEXT SCREEN AND
; OPTIONALLY IF $0B,Y IS != 0 THEN SET THE HIGH BIT
; OF THE CHARACTER (***** DOES THIS TURN ON BLOCK GRAPHICS? *****)
; $00,Y IS THE TEXT PAGE ADDRESS
; $0C,Y IS THE ROW, $0D,Y IS THE COLUMN
; ROW AND COL ARE NOT CHANGED
;
FE8E 4    34 02          PSHS    A      ;						SAVE A (THE CHARACTER TO PRINT)
FE90      8D 0E          BSR     $FEA0  ;						COMPUTE THE ADDRESS OF THE TEXT CHARACTER
FE92 5    35 02          PULS    A      ;						RESTORE A
FE94 m+   6D 2B          TST     $0B,Y  ;						IF ***** something ***** then
FE96 '    27 02          BEQ     $FE9A  ;						JUMP TO WHERE IT GETS STORED AT X
FE98      8A 80          ORA     #$80   ;						ELSE TURN THE HIGH BIT ON
->
FE9A      A7 84          STA     ,X     ;						STORE IT WHERE X POINTS
FE9C 9    39             RTS            ;						AND WE'RE DONE
->
;
;
;
;Routine:
;
; LOAD Y WITH THE CURRENT SCREEN CONTROL BLOCK THEN FALL THROUGH
; TO THE ROUTINE THAT CONVERTS A ROW/COL INTO A SCREEN ADDRESS
;
FE9D      10 9E C0       LDY     $C0    ;(DP$C0);
;
;Routine:
;
; CONVERT ROW / COL INTO MEMORY ADDRESS
; Y POINTS TO A STRUCTURE SUCH THAT
; $00,Y IS THE TEXT PAGE ADDRESS
; $0C,Y IS THE ROW, $0D,Y IS THE COLUMN
; RETURN ADDRESS IN X
;
FEA0  ,   EC 2C          LDD     $0C,Y  ;						A IS THE ROW NUMBER
;Routine:
FEA2 4    34 04          PSHS    B      ;						B IS THE COLUMN NUMBER
FEA4  (   C6 28          LDB     #$28   ;						LOAD B WITH 40 (COLUMNS?)
FEA6 =    3D             MUL            ;						MULTIPLY TO GET THE ROW ADDRESS
FEA7      EB E0          ADDB    ,S+    ;						ADD TOP OF STACK (COLUMN ADDRESS?) AND PULL
FEA9      89 00          ADCA    #$00   ;						CATCH CARRY OVERFLOW
FEAB      E3 A4          ADDD    ,Y     ;						Y IS A POINTER TO THE ADDRESS OF THE TEXT PAGE
FEAD      1F 01          TFR     D,X    ;						X HOLDS THE MEMORY LOCATION
FEAF 9    39             RTS            ;						DONE
->
;
;
;
;Routine:
;
; LOOKS LIKE SOME KIND OF WINDOWING SYSTEM
; SOME KIND OF SCROLL AND KEEP THE CURSOR ON SCREEN ROUTINE
; $09,Y <= ROW <= $08,Y
; (DP$D3) - ***** something ***** SOME KIND OF TEXT MODE
; LOOKS LIKE WE HAVE TWO MODES... +VE COLUMNS AND -VER COLUMNS
; WHAT DO THEY DO AND WHY ARE THEY DIFFERENT?  +VE COLS HAS -VE ROWS ND -VE COLS HAS +VE ROWS!
;
FEB0  -   A6 2D          LDA     $0D,Y  ;						LOAD THE COLUMN POSITION
FEB2 *    2A 08          BPL     $FEBC  ;						IF POSITIVE THEN ***** dunno *****
FEB4  (   8B 28          ADDA    #$28   ;						ADD 40 (THE NUMBER OF COLUMNS)
FEB6  -   A7 2D          STA     $0D,Y  ;						STORE BACK AS THE COLMN NUMBER
FEB8 j,   6A 2C          DEC     $0C,Y  ;						DECRAMENT THE ROW NUMBER
FEBA      20 08          BRA     $FEC4  ;						VERIFY THE ROW NUMBER
->
FEBC  (   80 28          SUBA    #$28   ;						SUBTRACT 40 COLUMNS
FEBE -    2D 04          BLT     $FEC4  ;						IF IT BECOMES NEGATIVE (***** why?*****) VERIFY THE ROW NUMBER
FEC0  -   A7 2D          STA     $0D,Y  ;						SAVE IT BACK AS THE CURRENT COL NUMBER
FEC2 l,   6C 2C          INC     $0C,Y  ;						INC THE ROW NUMBER
->
FEC4  ,   A6 2C          LDA     $0C,Y  ;						LOAD A WITH THE ROW NUMBER
FEC6  )   A1 29          CMPA    $09,Y  ;						MAKE SURE ROW >= $09,Y (TOP ROW NUMBER)
FEC8 ,    2C 0A          BGE     $FED4  ;						IF IT IS THEN MOVE ON
FECA      0D D3          TST     $D3    ;(DP$D3);				IF IN ***** dunno mode ***** THEN
FECC &    26 10          BNE     $FEDE  ;						LOAD WITH ROW TOP NUMBER AND FINISH
FECE      8D 13          BSR     $FEE3  ;						ELSE SCROLL ***** dunno what *****
->
FED0  )   A6 29          LDA     $09,Y  ;						LOAD WITH WINDOW BOTTOM ADDRESS
FED2      20 0C          BRA     $FEE0  ;						AND STORE IT AS THE CURRENT ROW NUMBER AND FINISH
->
FED4  (   A1 28          CMPA    $08,Y  ;						MAKE SURE A (ROW NUMBER) LESS THAN $08,Y
FED6 /    2F 0A          BLE     $FEE2  ;						IF IT IS THEN WE'RE DONE
FED8      0D D3          TST     $D3    ;(DP$D3);				IF IN ***** dunno mode ***** THEN
FEDA &    26 F4          BNE     $FED0  ;						LOAD WITH WINDOW BOTTOM ADDRESS AND FINISH
FEDC  !   8D 21          BSR     $FEFF  ;						ELSE SCROLL ***** dunno what *****
->
FEDE  (   A6 28          LDA     $08,Y  ;						LOAD WITH WINDOW TOP ADDRESS
->
FEE0  ,   A7 2C          STA     $0C,Y  ;						STORE IT AS THE CURRENT ROW NUMBER
->
FEE2 9    39             RTS            ;						DONE
->
;
;
;
;Routine:
;
; SOME KIND OF SCROLL AND CLEAR THE BOTTOM LINE OF THE SCREEN ROUTINE
; $04,Y THE ADDRESS OF THE BOTTOM ROW OF THE TEXT SCREEN  ***** dunno yet *****
; $06,Y ***** dunno yet! *****
;
FEE3  &   AE 26          LDX     $06,Y  ;						LOAD X WITH $06,Y
FEE5 0    30 88 D9       LEAX    $-27,X ;						SUBTRACT 39
->
FEE8  $   AC 24          CMPX    $04,Y  ;						COMPARE TO ADDRESS OF THE LAST LINE OF THE SCREEN
FEEA #    23 07          BLS     $FEF3  ;						IF LESS THEN CLEAR THE LAST LINE OF THE SCREEN
FEEC      EC 83          LDD     ,--X   ;						OTHERWISE LOAD FROM ON SCREEN
FEEE   (  ED 88 28       STD     $28,X  ;						AND MOVE IT BY ONE LINE (***** up or down? *****)
FEF1      20 F5          BRA     $FEE8  ;						DO IT AGAIN!
->
FEF3 0 (  30 88 28       LEAX    $28,X  ;						ADD 40 TO X (MOVE ON TO THE NEXT LINE)
FEF6 _    5F             CLRB           ;						B = 0
FEF7 O    4F             CLRA           ;						A = 0	(SO D = 0)
->
FEF8      ED 83          STD     ,--X   ;						CLEAR 2 BYTES THEN MOVE ON TO NEXT TWO
FEFA  $   AC 24          CMPX    $04,Y  ;						AT THE BEGINNING OF THE LINE?
FEFC "    22 FA          BHI     $FEF8  ;						IF NOT THE CLEAR MORE
FEFE 9    39             RTS            ;						DONE
->
;
;
;
;Routine:
; SOME KIND OF SCROLL ROUTINE TOO
;
; $04,Y THE ADDRESS OF THE BOTTOM ROW OF THE TEXT SCREEN?  OR IS THIS THE TOP?
; $06,Y ADDRESS OF LAST LINE OF TEXT?
;
FEFF  &   AE 26          LDX     $06,Y  ;						LOAD X WITH LAST LINE OF TEXT
FF01 0    30 88 D8       LEAX    $-28,X ;						SUBTRACT ONE LINE TO MAKE SECOND TO LAST
FF04 4    34 10          PSHS    X      ;						AND PUSH THE ADDRESS OF THE SECOND TO LAST LINE
FF06  $   AE 24          LDX     $04,Y  ;						LOAD X WITH FIRST LINE OF SCREEN
FF08      20 0A          BRA     $FF14  ;						ALWAYS BRANCH
->
FF0A   (  EC 88 28       LDD     $28,X  ;						LOAD 2 BYTES FROM FURTHER DOWN SCREEN
FF0D      ED 81          STD     ,X++   ;						STORE IT HERE
FF0F   (  EC 88 28       LDD     $28,X  ;						LOAD ANOTHER 2 BYTES
FF12      ED 81          STD     ,X++   ;						STORE THEM HERE TOO
->
FF14      AC E4          CMPX    ,S     ;						ON THE LAST LINE?
FF16 %    25 F2          BCS     $FF0A  ;						NOPE SO SCROLL MORE
FF18 2b   32 62          LEAS    $02,S  ;						SUBTRACT 2 FROM THE STACK (PULL PULL)
FF1A _    5F             CLRB           ;						B = 0
FF1B O    4F             CLRA           ;						A = 0  (SO D = 0)
->
FF1C      ED 81          STD     ,X++   ;						CLEAR TWO BYTES
FF1E  &   AC 26          CMPX    $06,Y  ;						AND DO THIS UNTIL WE HIT $06,Y
FF20 #    23 FA          BLS     $FF1C  ;						KEEP CLEARING
FF22 9    39             RTS            ;						DONE
->
FF23 00 01 03 08 04 06 05 07			;						Memory Map 1 (RAM and BASIC ROM)
->
FF2B 00 01 03 08 04 09 05 02			;						Memory Map 2 (All RAM)
->
FF33 FF FF FF FF FF FF FF FF FF FF FF FF FF FF FF FF ................   ;
FF43 FF FF FF FF FF FF FF FF FF FF FF FF FF FF FF FF ................   ;
FF53 FF FF FF FF FF FF FF FF FF FF FF FF FF FF FF FF ................   ;
FF63 FF FF FF FF FF FF FF FF FF FF FF FF FF FF FF FF ................   ;
FF73 FF FF FF FF FF FF FF FF FF FF FF FF FF FF FF FF ................   ;
FF83 FF FF FF FF FF FF FF FF FF FF FF FF FF FF FF FF ................   ;
FF93 FF FF FF FF FF FF FF FF FF FF FF FF FF FF FF FF ................   ;
FFA3 FF FF FF FF FF FF FF FF FF FF FF FF FF FF FF FF ................   ;
FFB3 FF FF FF FF FF FF FF FF FF FF FF FF FF FF FF FF ................   ;
FFC3 FF FF FF FF FF FF FF FF FF FF FF FF FF FF FF FF ................   ;
FFD3 FF FF FF FF FF FF FF FF FF FF FF FF FF FF FF FF ................   ;
FFE3 FF FF FF FF FF FF FF FF FF FF FF FF FF          .............      ;
->
FFF0 00 E9    				; NOTE: on ROM from second Poly 1 FFF0-FFF1 contains 01 0D
->
FFF2 FA C2 ; SWI3
->
FFF4 FA C2 ; SWI2
->
FFF6 FA 48 ; FIRQ
->
FFF8 F8 BA ; IRQ
->
FFFA F1 D9 ; SWI
->
FFFC FA 48 ; NMI
->
FFFE F0 4B ; Reset
