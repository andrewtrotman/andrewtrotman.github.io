;
;	POLYNET.SYS
;	-----------
;	Verison 3 of the OS.
;
;	Commented Dissassembly by Andrew Trotman andrew@cs.otago.ac.nz
;
;	This part resides on the Network Controller
;	Start Execution at $C850
;
;	E004-E006 : Serial Port
;	E010 - Floppy Disk Controller
;	E020 - Clock chip?
;	E030 - Network Controller
;
;	SWI #$18 - this appears to be a clock!
;
;		
;
; 	patch address $4808: printer type (FF = PROTEUS Parallel, 00 = PROTEUS Serial, 01 = POLYDRIVE Serial)
;
; when transmitting down the network the Poly and Network controller
; always transmit the data then sets the Transmit Last Data bit of
; control register 2 (E032)
;
;
;

->
4800      20 03          BRA     $4805  ;			Call GETCHR on remote Poly
->
4802 87 2E 80                           ;		??? $87 is an invalid opcode ???
->
;
;	FLEX (GETCHR) Get character
;	-------------
;	Transmit command #$13 param #$00
;	return the result in A
;
4805 4    34 14          PSHS    X,B    ;			save registers X and B
4807  [   8E 5B 19       LDX     #$5B19 ; 			FCB address
480A o    6F 84          CLR     ,X     ;			function code (GETCHR)
480C      10 8E 00 01    LDY     #$0001 ;			packet length
4810  I   BD 49 1D       JSR     $491D  ;			Transmit command 13 and FCB to Poly
->
4813  [   8E 5B 19       LDX     #$5B19 ;			address
4816      10 8E 00 01    LDY     #$0001 ;			rec message length
481A  Q   BD 51 1A       JSR     $511A  ;			get message
481D &    26 F4          BNE     $4813  ;			do it again
481F  [   8E 5B 19       LDX     #$5B19 ;			FCB address
4822      A6 84          LDA     ,X     ;			first byte from FCB (the FCB function code)
4824 _    5F             CLRB           ;			clear the flags
4825 5    35 94          PULS    PC,X,B ;			DONE
;
;
;	FLEX (PUTCHR) Put character
;	-------------
;	Accumulator A hold the character to output
;
;	Transmit command #$13 param #$01, <CharToPrint>
;
4827 4    34 14          PSHS    X,B    ;			Save X and B (FLEX says we must)
4829  [   8E 5B 19       LDX     #$5B19 ;			FCB address
482C      C6 01          LDB     #$01   ;			Functin code 01 (putchar)
482E      E7 84          STB     ,X     ;			into buffer
4830      A7 01          STA     $01,X  ;			FCB Error byte
4832      10 8E 00 02    LDY     #$0002 ;			packet length
4836  I   BD 49 1D       JSR     $491D  ;			Transmit command 13 and FCB to Poly
4839 5    35 94          PULS    PC,X,B ;			DONE
;
;	FLEX (INBUFF) Input into line buffer
;	-------------
;	Transmit command #$13 #$02
;	Return result in X
;
483B  [   8E 5B 19       LDX     #$5B19 ;			FCB address
483E      C6 02          LDB     #$02   ;			Function Code 02 (inbuff)
4840      E7 84          STB     ,X     ;			into buffer
4842      10 8E 00 01    LDY     #$0001 ;			packet length
4846  I   BD 49 1D       JSR     $491D  ;			Transmit command 13 and FCB to Poly
->
4849   d  8E 00 64       LDX     #$0064 ;			100 decimal
484C  P   BD 50 C9       JSR     $50C9  ;			timeing loop (of length X)
484F      8E C0 80       LDX     #$C080 ;			FLEX Line buffer
4852      BF CC 14       STX     $CC14  ; 			FLEX Line buffer pointer
4855      10 8E 00 80    LDY     #$0080 ;			rec message length
4859  Q   BD 51 1A       JSR     $511A  ;			get message
485C &    26 EB          BNE     $4849  ;			more
485E 9    39             RTS            ;			DONE
->
;
;	FLEX (PSTRNG) Print string
;	------------
;	X points to the string
;
;	Transmit command #$13 #$03 <string> #$04
;
485F      8D 20          BSR     $4881  ;			Transmit CR/LF combination(PCRLF)
4861 4    34 10          PSHS    X      ;			save X
4863   [  10 8E 5B 19    LDY     #$5B19 ;			FCB address
4867      C6 03          LDB     #$03   ;			Function Code 03
4869      E7 A4          STB     ,Y     ;			command buffer
486B _    5F             CLRB           ;			B = 0
->
486C \    5C             INCB           ;			B = B + 1
486D      A6 80          LDA     ,X+    ;			load A from 
486F      A7 A5          STA     B,Y    ;			store in the buffer
4871      81 04          CMPA    #$04   ;			was it an #$04
4873 &    26 F7          BNE     $486C  ;			nope so copy more (#$04 terminated string)
4875 O    4F             CLRA           ;			A = 0
4876 \    5C             INCB           ;			B = length of packet
4877      1F 02          TFR     D,Y    ;			Y = length of packet
4879  [   8E 5B 19       LDX     #$5B19 ;			FCB address
487C  I   BD 49 1D       JSR     $491D  ;			Transmit command 13 and FCB to Poly
487F 5    35 90          PULS    PC,X   ;			Done
->
;
;	FLEX (PCRLF) Print CR/LF
;	------------
;	Transmit command #$13 #$04
;	return result in A (dunno what)
;
4881 4    34 10          PSHS    X      ;			save X
4883  [   8E 5B 19       LDX     #$5B19 ;			FCB address
4886      C6 04          LDB     #$04   ;			Function Code 04
4888      E7 84          STB     ,X     ;			command buffer
488A      10 8E 00 01    LDY     #$0001 ;			length
488E  I   BD 49 1D       JSR     $491D  ;			Transmit command 13 and FCB to Poly
->
4891  [   8E 5B 19       LDX     #$5B19 ;			FCB address
4894      10 8E 00 01    LDY     #$0001 ;			rec message length
4898  Q   BD 51 1A       JSR     $511A  ;			get message
489B &    26 F4          BNE     $4891  ;			more
489D      A6 84          LDA     ,X     ;			get A
489F      27 03          BEQ     $48A4  ;			DONE
48A1 ~    7E CD 03       JMP     $CD03  ;			FLEX (WARMS) warm start entry point
->
48A4 5    35 90          PULS    PC,X   ;			DONE
->
;
;	FLEX (OUTDEC) Output decimal number
;	-------------
;	B points to pad with spaces flag (0 = no padding, !0 = padding)
;	X points to MSB of 16 bit integer
;
;	Transmit #$13 #$05 <B> <where Y points>
;
48A6 4    34 14          PSHS    X,B    ;			Save X and B
48A8  [   8E 5B 19       LDX     #$5B19 ;			FCB address
48AB      C6 05          LDB     #$05   ;			Function Code #$05
48AD      E7 80          STB     ,X+    ;			command buffer
48AF 5    35 04          PULS    B      ;			Get B
48B1      E7 80          STB     ,X+    ;			store that
48B3 5    35 20          PULS    Y      ;			Get Y
48B5      EC A4          LDD     ,Y     ;			get D from where X points
48B7      ED 84          STD     ,X     ;			store that
48B9  [   8E 5B 19       LDX     #$5B19 ;			FCB address
48BC      10 8E 00 04    LDY     #$0004 ;			length of message
48C0  I   BD 49 1D       JSR     $491D  ;			Transmit command 13 and FCB to Poly
48C3 9    39             RTS            ;			DONE
->
;
;	FLEX (OUTHEX) Output hexidecimal number
;	-------------
;	X points to address of byte to print
;
;	Transmit #$13 #$06 <byte>
;
48C4 4    34 14          PSHS    X,B    ;			Save X and B
48C6      A6 84          LDA     ,X     ;			get the character
48C8  [   8E 5B 19       LDX     #$5B19 ;			FCB address
48CB      C6 06          LDB     #$06   ;			Funciton Code #$06
48CD      E7 84          STB     ,X     ;			command buffer
48CF      A7 01          STA     $01,X  ;			command buffer
48D1      10 8E 00 02    LDY     #$0002 ;			length
48D5  I   BD 49 1D       JSR     $491D  ;			Transmit command 13 and FCB to Poly
48D8 5    35 94          PULS    PC,X,B ;			DONE
;
;	FLEX (OUTADR) Output hexadecimal address
;	-------------
;	X points to the MSB of the 16 bit value
;
;	Transmit #$13 #$07 <word>
;
48DA      EC 84          LDD     ,X     ;			get the value
48DC  [   8E 5B 19       LDX     #$5B19 ;			FCB address
48DF 4    34 04          PSHS    B      ;			save B
48E1      C6 07          LDB     #$07   ;			Function Code #$07
48E3      E7 84          STB     ,X     ;			command buffer
48E5 5    35 04          PULS    B      ;			get B back
48E7      ED 01          STD     $01,X  ;			store the value
48E9      10 8E 00 03    LDY     #$0003 ;			message length
48ED  I   BD 49 1D       JSR     $491D  ;			Transmit command 13 and FCB to Poly
48F0 9    39             RTS            ;
->
;
;		-----------------------------------------------------
;		This appears to be an important entry point from FLEX
;		-----------------------------------------------------
; 	appears to be end of command (so return control of Poly to user)
;
;	Transmit #$13 #$08
;
48F1 4    34 14          PSHS    X,B    ;			save X and B
48F3  [   8E 5B 19       LDX     #$5B19 ;			FCB address
48F6      C6 08          LDB     #$08   ;			Funciton Code #$08
48F8      E7 84          STB     ,X     ;			command buffer
48FA      10 8E 00 01    LDY     #$0001 ;			length of transmission packet
48FE      8D 1D          BSR     $491D  ;			Transmit command #$13 and the #$08 to Poly
4900      16 FF 10       LBRA    $4813  ;			DONE (This does a pop and a RTS)
->
;
;	FLEX (RPTERR) Report error
;	-------------
;	Transmit #$13 #$09 <?string?>
;
4903 4    34 10          PSHS    X      ;			save X
4905   [  10 8E 5B 19    LDY     #$5B19 ;			FCB address
4909  @   C6 40          LDB     #$40   ;			bytes to copy
490B  L   BD 4C 1D       JSR     $4C1D  ;			MEMCPY(Y, X, B)
490E  [   8E 5B 19       LDX     #$5B19 ;			FCB address
4911      C6 09          LDB     #$09   ;			Function Code #$09
4913      E7 84          STB     ,X     ;			buffer
4915    @ 10 8E 00 40    LDY     #$0040 ;			message length
4919      8D 02          BSR     $491D  ;			Transmit command 13 and FCB to Poly
491B 5    35 90          PULS    PC,X   ;			DONE
->
;
;	COMMAND_13
;	----------
;	Transmit command 13 parameters to the Poly
;	X points to the FCB
;	Y is the length of the transmission
;
Routine:
491D 4    34 10          PSHS    X      ;			save X
491F      8E 01 90       LDX     #$0190 ;			load X with $0190
4922  P   BD 50 C9       JSR     $50C9  ;			pause (count X down to 0)
4925 5    35 10          PULS    X      ;			restore X (FBC address)
4927      C6 13          LDB     #$13   ;			Command 13
4929  Q   BD 51 A1       JSR     $51A1  ;			Transmit FCB to Poly
492C 9    39             RTS            ;			DONE
->
;
;
;	+----------------------------------------------------+
;	| MAIN ENTRY POINT TO NETWORK CONTROLLER APPLICATION |
;	+----------------------------------------------------+
;
;
492D  T   BD 54 00       JSR     $5400  ;			Printer stuff
->
4930  O   B6 4F B9       LDA     $4FB9  ;			load
4933 4    34 02          PSHS    A      ;			save
4935  P   BD 50 05       JSR     $5005  ;
4938 5    35 02          PULS    A      ;			restore
493A  O   B7 4F B9       STA     $4FB9  ;			replace
493D  I   BD 49 99       JSR     $4999  ;			SWI$18
4940  O   FD 4F 06       STD     $4F06  ;
->
4943  I   BD 49 99       JSR     $4999  ;			SWI$18
4946  O   B3 4F 06       SUBD    $4F06  ;
4949    X 10 83 02 58    CMPD    #$0258 ;			(600 decimal)
494D %3   25 33          BCS     $4982  ;	? BLO if we don't time-out then do some processing?
;
;	Find the first item in the UID list to hit zero
;
494F  O   CE 4F 0A       LDU     #$4F0A ;			Poly UID list
->
4952   O  11 B3 4F 08    CMPU    $4F08  ;			Pointer to end of Poly UID list
4956      27 D8          BEQ     $4930  ;			are we at the end of the list?
4958 jB   6A 42          DEC     $02,U  ;			this is some kind of triplet
495A      27 04          BEQ     $4960  ;			zero so move on (FMS close and remove it from the list)
495C 3C   33 43          LEAU    $03,U  ;			u = u + 3
495E      20 F2          BRA     $4952  ;			again
->
;
;	Now reduce the size of the UID list by one
;
4960  O   BE 4F 08       LDX     $4F08  ;			pointer to end of UID list
4963 0    30 1D          LEAX    $-03,X ;			subtract 3
4965  O   BF 4F 08       STX     $4F08  ;			pointer to end of UID list			
;
;	Get the UID of the Poly we need to deal with
;
4968      EC C4          LDD     ,U     ;			uid of Poly
496A   6  FD D4 36       STD     $D436  ;			remote ID of Poly?
496D 4@   34 40          PSHS    U      ;			save the pointer
->
;
;	Now remove it from the list by shifting all the others down
;
496F  C   A6 43          LDA     $03,U  ;			get the next byte			
4971      A7 C0          STA     ,U+    ;			store it here
4973   O  11 B3 4F 08    CMPU    $4F08  ;			pointer to end of UID list
4977 #    23 F6          BLS     $496F  ;			more to do
4979 3]   33 5D          LEAU    $-03,U ;			subtract 3 (this line does nothing)
;
;	FMS close, reload the pointer, then redo the whole FMS close thing again
;
497B      BD D4 03       JSR     $D403  ;			FLEX FMS Close
497E 5@   35 40          PULS    U      ;
4980      20 D0          BRA     $4952  ;
->
4982  @   8D 40          BSR     $49C4  ;			PRINTER:Process printer requests
4984  [   8E 5B 19       LDX     #$5B19 ;			FCB address
4987    @ 10 8E 01 40    LDY     #$0140 ;			320 bytes (that is, the whole FCB)
498B }O   7D 4F BA       TST     $4FBA  ;	  
498E      27 B3          BEQ     $4943  ;
4990  P   BD 50 D9       JSR     $50D9  ;			move on to the next machine that is still there
4993 .    2E 9B          BGT     $4930  ;			re-enter main loop
4995 &    26 AC          BNE     $4943  ;
4997      20 22          BRA     $49BB  ;			process command and send reply
->
Routine:
;
;	SWI$18
;	------
;
4999 4    34 10          PSHS    X      ;			save X
499B ?    3F 18          SWI     #$18   ;		?Sent to Poly? return value in D is????
499D 5    35 10          PULS    X      ;			restore X
499F 9    39             RTS            ;			DONE
->
Routine:
;
;	copy date
;	---------
;
49A0      A6 84          LDA     ,X     ;			first byte of date
49A2      B7 DF F3       STA     $DFF3  ;			goes in $DFF3
49A5      EC 01          LDD     $01,X  ;			and the other 2 bytes
49A7      FD DF F4       STD     $DFF4  ;			go in $DFF4-$DFF5
49AA 9    39             RTS            ;			DONE
->
49AB  [   8E 5B 19       LDX     #$5B19 ;			FCB
49AE    @ 10 8E 01 40    LDY     #$0140 ;			Length of FCB (320 bytes)
49B2  Q   BD 51 1A       JSR     $511A  ;			get message
49B5 +    2B 8C          BMI     $4943  ;
49B7  & u 10 26 FF 75    LBNE    $4930  ;			re-enter main loop
->
;
;	Process command and send reply
;
;
49BB   O  10 BF 4F 02    STY     $4F02  ;			length of the FCB
49BF  O   F7 4F 04       STB     $4F04  ;			command number
49C2  f   20 66          BRA     $4A2A  ;			process the command (and send reply)
->
Routine:
;
;	Process printer requests
;	------------------------
;
49C4      C6 FF          LDB     #$FF   ;			255 times
->
49C6 4    34 04          PSHS    B      ;			save B
49C8  X   BD 58 0A       JSR     $580A  ;			PRINTER:do the next thing with the printer
49CB 5    35 04          PULS    B      ;			restore B
49CD Z    5A             DECB           ;			dec
49CE &    26 F6          BNE     $49C6  ;			more
49D0 9    39             RTS            ;			DONE
->
Routine:
;
;
;	open file on system drive (X points to a filename)
;
49D1   [  10 8E 5B 1D    LDY     #$5B1D ;			file name buffer
49D5      C6 0B          LDB     #$0B   ;			max filename length
->										;			this is basicaly a strncmp(y,x,0x0D) routine
49D7      A6 80          LDA     ,X+    ;			get from source
49D9      A7 A0          STA     ,Y+    ;			put into destination
49DB Z    5A             DECB           ;			dec characters left to copy
49DC &    26 F9          BNE     $49D7  ;			copy another character
49DE      B6 CC 0B       LDA     $CC0B  ;			FLEX system drive number
49E1  [   B7 5B 1C       STA     $5B1C  ;			store that before the filename
->
Routine:
;
;	open file (whose name is in the FCB)
;
49E4  [   8E 5B 1D       LDX     #$5B1D ;			filename
49E7   N  10 8E 4E F5    LDY     #$4EF5 ;			filename in text of error mesage "cannot read"
49EB      C6 0B          LDB     #$0B   ;			maxfilename length
49ED  L   BD 4C 1D       JSR     $4C1D  ;			MEMCPY(Y, X, B)
49F0  [   8E 5B 19       LDX     #$5B19 ;			FCB address
49F3      86 01          LDA     #$01   ;			function 1 (open for read)
49F5  [   B7 5B 19       STA     $5B19  ;			FBC function
49F8      BD D4 06       JSR     $D406  ;			FLEX FMS Call (on return the file is open)
49FB &    26 0C          BNE     $4A09  ;			DONE
49FD      86 FF          LDA     #$FF   ;			no space compression ($FF)
49FF  [T  B7 5B 54       STA     $5B54  ;			FCB space compression flag
4A02  [*  FC 5B 2A       LDD     $5B2A  ;			first track and sector of file
4A05  [7  FD 5B 37       STD     $5B37  ;			current position (track / sector), so this is a rewind()
4A08 O    4F             CLRA           ;			zero A (no error?)
->
4A09 9    39             RTS            ;			DONE
->
Routine:
;
;	Read next sector from file
;
4A0A  [   8E 5B 19       LDX     #$5B19 ;			X = FCB of open file
4A0D   @  EC 88 40       LDD     $40,X  ;			FCB sector buffer (next sector in chain)
4A10      ED 88 1E       STD     $1E,X  ;			FCB current position
4A13      86 09          LDA     #$09   ;			FCB function number (read single sector)
4A15      A7 84          STA     ,X     ;			FCB function to perform
4A17 ~    7E D4 06       JMP     $D406  ;			FLEX FMS Call
->
4A1A 8D 03 7E 49 43                                  ..~IC              ;
->
;
;	close file and return
;
4A1F  [   8E 5B 19       LDX     #$5B19 ;			FCB
4A22      86 04          LDA     #$04   ;			functon number 4 (close file)
4A24  [   B7 5B 19       STA     $5B19  ;			store in the FCB
4A27 ~    7E D4 06       JMP     $D406  ;			FLEX FMS Call the return
->
;
;	Decode command and execute it
;
;
4A2A      C1 0D          CMPB    #$0D   ;		0D	(FCB command)
4A2C  ' : 10 27 05 3A    LBEQ    $4F6A  ;			Process a remote FCB (and send it back to the Poly)
4A30      C1 0E          CMPB    #$0E   ;		0E	(FMS close command)
4A32  ' l 10 27 05 6C    LBEQ    $4FA2  ;			Process a remote FMS close command (end of command / close all files)
4A36      C1 04          CMPB    #$04   ;		04	(date command)
4A38 &X   26 58          BNE     $4A92  ;			nope, move on
4A3A 1    31 A4          LEAY    ,Y     ;			does Y=0? (that's a bit nasty)
4A3C      27 17          BEQ     $4A55  ;			if y == 0 then send date to Poly else get date from Poly
4A3E  [   8E 5B 19       LDX     #$5B19 ;			FCB address
4A41      10 8E CC 0E    LDY     #$CC0E ;			FLEX system date registers
->
4A45      A6 80          LDA     ,X+    ;			copy 3 bytes from 5B19 into system date registers
4A47      A7 A0          STA     ,Y+    ;			save in the system date registers
4A49      10 8C CC 11    CMPY    #$CC11 ;			end of FLEX system date registers
4A4D %    25 F6          BCS     $4A45  ;			more to do
4A4F  I   BD 49 A0       JSR     $49A0  ;			copy date to DFF3
4A52 ~IC  7E 49 43       JMP     $4943  ;
->
4A55  [   8E 5B 19       LDX     #$5B19 ;			FCB address
4A58      10 8E CC 0E    LDY     #$CC0E ;			FLEX system date registers
->
4A5C      A6 A0          LDA     ,Y+    ;			load date from FLEX
4A5E      A7 80          STA     ,X+    ;			store in FCB buffer
4A60      10 8C CC 11    CMPY    #$CC11 ;			are we done?
4A64 %    25 F6          BCS     $4A5C  ;			more to do
4A66      B6 DF F3       LDA     $DFF3  ;			load the other date (boot time?)
4A69      A7 80          STA     ,X+    ;			store in the buffer
4A6B      FC DF F4       LDD     $DFF4  ;			and the next 2 bytes of the date
4A6E      ED 84          STD     ,X     ;			save them too
4A70  [   8E 5B 19       LDX     #$5B19 ;			FCB address
4A73      10 8E 00 06    LDY     #$0006 ;			this is the length of the 2 dates
4A77      C6 04          LDB     #$04   ;			Command 04 (send date to Poly)
4A79  Q   BD 51 A1       JSR     $51A1  ;			Transmit FCB to Poly
4A7C }    7D CC 0E       TST     $CC0E  ;			FLEX system date registers
4A7F  &   10 26 FE C0    LBNE    $4943  ;
->
4A83  [   8E 5B 19       LDX     #$5B19 ;			FCB address
4A86    @ 10 8E 01 40    LDY     #$0140 ;			size of the FCB in bytes (320 bytes)
4A8A  Q   BD 51 1A       JSR     $511A  ;			get message from Poly
4A8D &    26 F4          BNE     $4A83  ;			more
4A8F ~I   7E 49 BB       JMP     $49BB  ;			process command and send reply
->
4A92      C1 05          CMPB    #$05   ;		05	(some kind of print command?)
4A94 &'   26 27          BNE     $4ABD  ;			nope, move on to check the next command
4A96  O   FC 4F 02       LDD     $4F02  ;			Length of an FCB
4A99 '    27 18          BEQ     $4AB3  ;			send (error?) message to Poly
4A9B      10 83 00 0C    CMPD    #$000C ;			is the length 12 bytes?
4A9F &    26 12          BNE     $4AB3  ;			send (error?) message to Poly
4AA1  [   8E 5B 19       LDX     #$5B19 ;			FCB address
4AA4  Z   BD 5A 87       JSR     $5A87  ;		? something to do with printing ?
4AA7 $    24 0A          BCC     $4AB3  ;			send (error?) message to Poly
4AA9  T   8E 54 07       LDX     #$5407 ;			from address	(something to do with printing - status code?)
->
4AAC      10 8E 00 01    LDY     #$0001 ;			length
4AB0 ~O   7E 4F 94       JMP     $4F94  ;			send to Poly
->
4AB3  TW  8E 54 57       LDX     #$5457 ;			from address	(something to do with printing - text message?)
4AB6      10 8E 00 F7    LDY     #$00F7 ;			length (247 bytes)
4ABA ~O   7E 4F 94       JMP     $4F94  ;			send to Poly
->
4ABD      C1 06          CMPB    #$06   ;		06 (some kind of print commnad?)
4ABF &    26 18          BNE     $4AD9  ;			nope, so move on to next command
4AC1  O   FC 4F 02       LDD     $4F02  ;			lenth of an FCB
4AC4      27 ED          BEQ     $4AB3  ;			send (error?) message to Poly
4AC6      10 83 00 0C    CMPD    #$000C ;			is the length 12 bytes?
4ACA &    26 E7          BNE     $4AB3  ;			send (error?) message to Poly
4ACC  [   8E 5B 19       LDX     #$5B19 ;			FCB address
4ACF  Z   BD 5A BD       JSR     $5ABD  ;		? something to do with printing ?
4AD2 $    24 DF          BCC     $4AB3  ;			send (error?) message to Poly
4AD4  T   8E 54 08       LDX     #$5408 ;			from address (something to do with printing - status code?)
4AD7      20 D3          BRA     $4AAC  ;			send to Poly
->
4AD9      C1 07          CMPB    #$07   ;		07	(execute command on Network Controller)
4ADB &P   26 50          BNE     $4B2D  ;			nope, move on
4ADD  [   8E 5B 19       LDX     #$5B19 ;			FCB address
4AE0      10 8E C0 80    LDY     #$C080 ;			FLEX line buffer address
->
4AE4      A6 80          LDA     ,X+    ;			copy from X (the FCB address)
4AE6      A7 A0          STA     ,Y+    ;			into Y (the line buffer)
4AE8      10 8C C1 00    CMPY    #$C100 ;			at end of line buffer?
4AEC $    24 04          BCC     $4AF2  ;			move on as at end of line buffer
4AEE      81 0D          CMPA    #$0D   ;			end of line character
4AF0 &    26 F2          BNE     $4AE4  ;			nope, so keep copying
->
4AF2  [   BE 5B 9B       LDX     $5B9B  ;		??
4AF5      BF CC 14       STX     $CC14  ;			FLEX line buffer pointer
4AF8  [   FC 5B 99       LDD     $5B99  ;		?? user initials ??
4AFB   [  FD D4 5B       STD     $D45B  ;		??
4AFE  [   B6 5B 9D       LDA     $5B9D  ;			Remote Poly working drive number
4B01      B7 CC 0C       STA     $CC0C  ;			FLEX Working drive number
4B04      B7 CC 0B       STA     $CC0B  ;			FLEX System drive number
4B07 _    5F             CLRB           ;			B=0
4B08 O    4F             CLRA           ;			A=0 (so D=0)
4B09   6  FD D4 36       STD     $D436  ;			UID of remote Poly?
4B0C   K  BD CD 4B       JSR     $CD4B  ;			FLEX (DOCMND) Call DOS as a subroutine
4B0F  [   F7 5B 19       STB     $5B19  ;			FCB address (B is the error code from FMS)
4B12      BE CC 14       LDX     $CC14  ; 			FLEX Line buffer pointer
4B15  [   BF 5B 1A       STX     $5B1A  ;			the next 2 chars in the FCB buffer			
4B18      7F CC 0C       CLR     $CC0C  ;			FLEX Working drive number
4B1B      7F CC 0B       CLR     $CC0B  ;			FLEX system drive number
4B1E  [   8E 5B 19       LDX     #$5B19 ;			FCB address
4B21      10 8E 00 03    LDY     #$0003 ;			3 bytes
4B25      C6 07          LDB     #$07   ;			command 07
4B27  Q   BD 51 A1       JSR     $51A1  ;			Transmit FCB to Poly
4B2A ~IC  7E 49 43       JMP     $4943  ;
->
4B2D      C1 08          CMPB    #$08   ;		08		(wild guess, but something to do with loggin in? see OVERRIDE command)
4B2F &    26 19          BNE     $4B4A  ;			nope, so move on
4B31      10 8C 00 03    CMPY    #$0003 ;		? the length of the message we recieved?
4B35 &    26 10          BNE     $4B47  ;
4B37  [   B6 5B 19       LDA     $5B19  ;			FCB address
4B3A      81 A9          CMPA    #$A9   ;			is the first byte #$A9?
4B3C &    26 09          BNE     $4B47  ;		??
4B3E  [   FC 5B 1A       LDD     $5B1A  ;			next 2 bytes
4B41   X  FD D4 58       STD     $D458  ;		??
4B44 | Z  7C D4 5A       INC     $D45A  ;		??
->
4B47 ~IC  7E 49 43       JMP     $4943  ;
->
4B4A  O   B6 4F B9       LDA     $4FB9  ;		? current machine?
4B4D  O   B7 4F 00       STA     $4F00  ;
4B50  O   B7 4F 01       STA     $4F01  ;			broadcast flag (non-zero on broadcast)
4B53      C1 11          CMPB    #$11   ;		11	(Broadcast given file)
4B55 '    27 19          BEQ     $4B70  ;
4B57      C1 10          CMPB    #$10   ;		10	(Broadcast load memu.bac)
4B59 '%   27 25          BEQ     $4B80  ;
4B5B      C1 12          CMPB    #$12   ;		12	(Enter Broadcast?)
4B5D  &   10 26 FD E2    LBNE    $4943  ;
4B61      86 01          LDA     #$01   ;			A=01
4B63  O   B1 4F B9       CMPA    $4FB9  ;		? current machine?	(are we machine #01?)
4B66  &   10 26 FD D9    LBNE    $4943  ;			nope, so not allowed to enter broadcast
4B6A  M   B7 4D 88       STA     $4D88  ;			store #$01
4B6D ~IC  7E 49 43       JMP     $4943  ;
->
4B70  O   FC 4F 02       LDD     $4F02  ;			length of an FCB
4B73  M}  F7 4D 7D       STB     $4D7D  ;			file name length (of BASIC program to load)
4B76   Mo 10 8E 4D 6F    LDY     #$4D6F ;			Name of BASIC program to load
4B7A  [   8E 5B 19       LDX     #$5B19 ;			FCB address
4B7D  L   BD 4C 1D       JSR     $4C1D  ;			MEMCPY(Y, X, B)
->
4B80 }M   7D 4D 88       TST     $4D88  ;			check broadcast flag
4B83 '(   27 28          BEQ     $4BAD  ;			zero so not in broadcast
4B85  O   B6 4F B9       LDA     $4FB9  ;			current remote machine
4B88      81 01          CMPA    #$01   ;			are we machine #01?
4B8A  &   10 26 FD B5    LBNE    $4943  ;
4B8E  O   7F 4F 01       CLR     $4F01  ;			broadcast flag (non-zero on broadcast)
4B91  M   7F 4D 88       CLR     $4D88  ;			end broadcast
4B94   6  7F D4 36       CLR     $D436  ;			remote ID of Poly
4B97   7  7F D4 37       CLR     $D437  ;			remote ID of Poly
4B9A      BD D4 03       JSR     $D403  ;			FLEX FMS Close
4B9D  P   BD 50 05       JSR     $5005  ;
4BA0  O   7F 4F B9       CLR     $4FB9  ;			current destination machine
4BA3 O    4F             CLRA           ;			A=$00
4BA4  P   BD 50 EE       JSR     $50EE  ;			remote logout
4BA7      8E FF FF       LDX     #$FFFF ;			length of timing loop
4BAA  P   BD 50 C9       JSR     $50C9  ;			timeing loop (of length X)
->
4BAD  I   BD 49 99       JSR     $4999  ;			SWI$18
4BB0  O   FD 4F 06       STD     $4F06  ;
4BB3  M   7F 4D 89       CLR     $4D89  ;
4BB6 }O   7D 4F 01       TST     $4F01  ;			broadcast flag
4BB9      27 07          BEQ     $4BC2  ;			its a broadcast so send the right message
4BBB  N   8E 4E CB       LDX     #$4ECB ;			"system loading now"
4BBE      C6 18          LDB     #$18   ;			length of message
4BC0      20 05          BRA     $4BC7  ;			transmit, send the files, and so on.
->
4BC2  N   8E 4E 90       LDX     #$4E90 ;			"broadcast loading now"
4BC5      C6 1D          LDB     #$1D   ;			length of message
->
4BC7  L7  BD 4C 37       JSR     $4C37  ;			transmit
4BCA  MO  8E 4D 4F       LDX     #$4D4F ;			"POLYSYS.SYS"
4BCD  LT  BD 4C 54       JSR     $4C54  ;			transmit file
4BD0  MZ  8E 4D 5A       LDX     #$4D5A ;			"BASIC.CMD"
4BD3  I   BD 49 D1       JSR     $49D1  ;			open binary file on system disk (X points to filename) 
4BD6 &    26 03          BNE     $4BDB  ;			could not open file
4BD8  J   BD 4A 0A       JSR     $4A0A  ;			read next sector from file
->
4BDB  &   10 26 00 8E    LBNE    $4C6D  ;			transmit "cannot read <filename>", DONE
4BDF  [i  BE 5B 69       LDX     $5B69  ;		?? is this the load address of basic.cmd on the Poly?
4BE2  N   BF 4E 8E       STX     $4E8E  ;		?? is this later transmitted to the Poly as the start address?
4BE5  L^  BD 4C 5E       JSR     $4C5E  ;			transmit remainder of file, close file
4BE8 }O   7D 4F 01       TST     $4F01  ;			broadcast flag (non-zero on broadcast)
4BEB      27 17          BEQ     $4C04  ;			load  a basic program (other than 0.MENU.BAC)
4BED  Me  8E 4D 65       LDX     #$4D65 ;			"0.MENU.BAC"
4BF0      C6 0A          LDB     #$0A   ;			length of string
->
4BF2  L   BD 4C AB       JSR     $4CAB  ;			load and transmit compiled basic .BAC program
4BF5 }O   7D 4F 01       TST     $4F01  ;			broadcast flag (non-zero on broadcast)
4BF8 &    26 12          BNE     $4C0C  ;			if zero then non-broadcast so skip a bit
4BFA  N   8E 4E AD       LDX     #$4EAD ;			"broadcast program loaded"
4BFD      C6 1E          LDB     #$1E   ;			length of message
4BFF  L7  BD 4C 37       JSR     $4C37  ;			transmit
4C02      20 08          BRA     $4C0C  ;			tell Poly to boot
->
4C04  Mo  8E 4D 6F       LDX     #$4D6F ;			name of basic program to load
4C07  M}  F6 4D 7D       LDB     $4D7D  ;			length of the string
4C0A      20 E6          BRA     $4BF2  ;			load basic program
->
4C0C }O   7D 4F 01       TST     $4F01  ;			broadcast flag (non-zero on broadcast)
4C0F      27 05          BEQ     $4C16  ;			branch if not in broadcast mode
4C11      8D 12          BSR     $4C25  ;			tell poly to boot in broadcast mode
4C13 ~IC  7E 49 43       JMP     $4943  ;
->
4C16      86 7F          LDA     #$7F   ;			start networked OS on Poly
4C18      8D 0E          BSR     $4C28  ;			transmit to Poly
4C1A ~I0  7E 49 30       JMP     $4930  ;			reenter main loop
->
Routine:
;
;	MEMCPY(Y, X, B)
;	---------------
;	copy B charactes from where X points to where Y points
;
4C1D      A6 80          LDA     ,X+    ;			load from X
4C1F      A7 A0          STA     ,Y+    ;			store at Y
4C21 Z    5A             DECB           ;			dec B
4C22 &    26 F9          BNE     $4C1D  ;			more to copy?
4C24 9    39             RTS            ;			DONE
->
Routine:
;
;	Send boot command to Poly
;
;
4C25  O   B6 4F 00       LDA     $4F00  ;
->
;
;	Tell Poly to boot
;	-----------------
;
Routine:
4C28  M   B7 4D 7F       STA     $4D7F  ;			$7F = start networked Poly, -ve = restart, 01=broadcast?
4C2B  M   8E 4D 80       LDX     #$4D80 ;			send message to JMP $A009 to Poly
4C2E      C6 07          LDB     #$07   ;			7 bytes long
4C30      8D 05          BSR     $4C37  ;			transmit (data pointed to by X of length B)
4C32  M~  8E 4D 7E       LDX     #$4D7E ;			send command $04 to the Poly (restart?)
4C35      C6 02          LDB     #$02   ;			of length 2, fall through to transmit
->
Routine:
;
;	transmit data pointed to by X of length in B
;
4C37 O    4F             CLRA           ;			clear the top byte of D
4C38      1F 02          TFR     D,Y    ;			and copy to Y
->
;
;	transmit the data pointed to by X (of length Y)
;
4C3A  I   BD 49 99       JSR     $4999  ;			SWI$18
4C3D  O   B3 4F 06       SUBD    $4F06  ;	??
4C40      10 83 00 02    CMPD    #$0002 ;	??
4C44 %    25 F4          BCS     $4C3A  ;			(BLO) more (too quick?)
4C46      C6 10          LDB     #$10   ;	? Command 10 ?
4C48  Q   BD 51 A1       JSR     $51A1  ;			Transmit FCB to Poly
4C4B &D   26 44          BNE     $4C91  ;			close file
4C4D  I   BD 49 99       JSR     $4999  ;			SWI$18
4C50  O   FD 4F 06       STD     $4F06  ;
4C53 9    39             RTS            ;			DONE
->
Routine:
;
;	transmit file (X points to name)
;
4C54  I   BD 49 D1       JSR     $49D1  ;			open binary file on system disk (X points to filename) 
4C57 &    26 14          BNE     $4C6D  ;			transmit "cannot read <filename>", DONE
->
4C59  J   BD 4A 0A       JSR     $4A0A  ;			read next sector from open file
4C5C &    26 0F          BNE     $4C6D  ;			transmit "cannot read <filename>", DONE
->
Routine:
;
;	transmit remainder of file (file already open and a sector loaded)
;
;
4C5E  []  8E 5B 5D       LDX     #$5B5D ;			First byte of sector contents (after the chain)
4C61      C6 FC          LDB     #$FC   ;			length (in bytes) of data at that address
4C63      8D D2          BSR     $4C37  ;			transmit data
4C65  [Y  BE 5B 59       LDX     $5B59  ;			chain to next sector
4C68 &    26 EF          BNE     $4C59  ;			is not zero so more data
4C6A ~J   7E 4A 1F       JMP     $4A1F  ;			close the file and DONE
->
;
;	Transmit the "Cannot read <filename>" message
;
4C6D  [   B6 5B 1C       LDA     $5B1C  ;			FCB drive number
4C70  0   8B 30          ADDA    #$30   ;			ASCII for '0'
4C72  N   B7 4E F3       STA     $4EF3  ;			drive number in ASCII
4C75  N   8E 4E E3       LDX     #$4EE3 ;			"Cannot read <filename>"
4C78      C6 1D          LDB     #$1D   ;			length of error message
4C7A 4    34 14          PSHS    X,B    ;			store message and length on the stack
4C7C      8D B9          BSR     $4C37  ;			transmit data
4C7E      86 FF          LDA     #$FF   ;			boot failed
4C80      8D A6          BSR     $4C28  ;			transmit to Poly and tell it to restart
4C82      8E FF FF       LDX     #$FFFF ;			timeing loop
->
4C85 4    34 7F          PSHS    U,Y,X,DP,D,CC;		waste cycles
4C87 5    35 7F          PULS    U,Y,X,DP,D,CC;		waste cycles
4C89 0    30 1F          LEAX    $-01,X ;			are we done?
4C8B &    26 F8          BNE     $4C85  ;			nope, waste some more cycles
4C8D 5    35 14          PULS    X,B    ;			retransmit the cannot read <filename> message
4C8F      8D A6          BSR     $4C37  ;			transmit data (in X of length B)
->
4C91      10 CE C0 80    LDS     #$C080 ;			FLEX line buffer
4C95  [   8E 5B 19       LDX     #$5B19 ;			FCB buffer
4C98      86 04          LDA     #$04   ;			function 4 (close file)
4C9A      A7 84          STA     ,X     ;			stored in the FCB
4C9C      BD D4 06       JSR     $D406  ;			FLEX FMS Call
4C9F ~I0  7E 49 30       JMP     $4930  ;			reenter main loop
->
Routine:
;
;	Perform FCB function (X = system FCB ($5B19), then execute function)
;
4CA2  [   8E 5B 19       LDX     #$5B19 ;			FCB
4CA5      BD D4 06       JSR     $D406  ;			FLEX FMS Call
4CA8 &    26 C3          BNE     $4C6D  ;			transmit "cannot read <filename>", DONE
4CAA 9    39             RTS            ;			DONE
->
Routine:
;
;	load and transmit .BAC comiled basic program
;
4CAB      10 8E C0 80    LDY     #$C080 ;			FLEX line buffer
4CAF      10 BF CC 14    STY     $CC14  ;			FLEX line buffer pointer (so rewind)
4CB3  L   BD 4C 1D       JSR     $4C1D  ;			MEMCPY(Y, X, B)
4CB6      86 0D          LDA     #$0D   ;			terminate the line with a $0D
4CB8      A7 A4          STA     ,Y     ;			FLEX line buffer
4CBA  [   8E 5B 19       LDX     #$5B19 ;			FCB
4CBD   -  BD CD 2D       JSR     $CD2D  ;			FLEX (GETFIL) Get file specification
4CC0 %    25 AB          BCS     $4C6D  ;			transmit "cannot read <filename>", DONE
4CC2      86 08          LDA     #$08   ;			file extension #08 (.bac), compiled basic
4CC4   3  BD CD 33       JSR     $CD33  ;			FLEX (SETEXT) Set file extension
4CC7  I   BD 49 E4       JSR     $49E4  ;			open file (name in the FCB) and ready for read
4CCA &    26 A1          BNE     $4C6D  ;			transmit "cannot read <filename>", DONE
4CCC  N   FC 4E 8E       LDD     $4E8E  ;			address as given by Poly
4CCF  M   FD 4D 8B       STD     $4D8B  ;			address on Poly when transmitted
4CD2   M  10 8E 4D 8E    LDY     #$4D8E ;			start of BAC decode buffer
4CD6      8D CA          BSR     $4CA2  ;			perform FBC function (FCB=$5B19) (A = read byte from file)
4CD8      81 03          CMPA    #$03   ;			The first byte of a BAC file should be $03
4CDA &    26 91          BNE     $4C6D  ;			transmit "cannot read <filename>", DONE
4CDC  M   7F 4D 87       CLR     $4D87  ;			initialise the BAC decoder
4CDF  6   8D 36          BSR     $4D17  ;			get a BAC decoded byte
->
4CE1 M    4D             TSTA           ;			was it a zero?
4CE2      27 0E          BEQ     $4CF2  ;			this looks like an end of file marker
4CE4 4    34 02          PSHS    A      ;			store on top of stack
->
4CE6  9   8D 39          BSR     $4D21  ;			copy into the packet buffer and if full transmit, rewind, and in destinations' address
4CE8  -   8D 2D          BSR     $4D17  ;			get a BAC decoded byte
4CEA j    6A E4          DEC     ,S     ;			dec the value at the top of the stack
4CEC &    26 F8          BNE     $4CE6  ;			more to do 
4CEE 2a   32 61          LEAS    $01,S  ;			remove it from the top of the stack
4CF0      20 EF          BRA     $4CE1  ;			more to do
->
4CF2  <   8D 3C          BSR     $4D30  ;			send and rewind to beginning of buffer (and inc dest address)
4CF4  M   FC 4D 8B       LDD     $4D8B  ;			address of end of file once loaded on Poly
4CF7  N   FD 4E 8A       STD     $4E8A  ;			store in transmit buffer
4CFA  L   BD 4C A2       JSR     $4CA2  ;			perform FCB function (at $5B19), read byte
4CFD 4    34 02          PSHS    A      ;		??? msb of something - is this the variable space?
4CFF  L   BD 4C A2       JSR     $4CA2  ;			perform FCB function (at $5B19), read byte
4D02      1F 89          TFR     A,B    ;			A -> lsb
4D04 5    35 02          PULS    A      ;			get msb
4D06  N   F3 4E 8A       ADDD    $4E8A  ;			add the size of the file
4D09  N   FD 4E 8C       STD     $4E8C  ;		??? store it - is this the "working set" of the basic program?
4D0C  N   8E 4E 86       LDX     #$4E86 ;			packet to send
4D0F      C6 08          LDB     #$08   ;			packet size
4D11  L7  BD 4C 37       JSR     $4C37  ;			transmit data
4D14 ~J   7E 4A 1F       JMP     $4A1F  ;			close the file and DONE
->
Routine:
;
;	Decode BAC (compiled basic) file.
;
;	BAC files are encoded this:
;		Byte 0: 03
;		Byte 1->: subtract the byte number to get the data.
;
4D17  L   BD 4C A2       JSR     $4CA2  ;			perform FCB function (at $5B19) ready byte
4D1A  M   B0 4D 87       SUBA    $4D87  ;			get the true value
4D1D |M   7C 4D 87       INC     $4D87  ;			inc the decoder byte
4D20 9    39             RTS            ;			DONE
->
Routine:
;
;	copy into the packet buffer and if full transmit, rewind, and in destinations' address
;
4D21   N  10 8C 4E 86    CMPY    #$4E86 ;			have we have a full buffer?
4D25 %    25 06          BCS     $4D2D  ;			nope, so copy and move on to the next byte
4D27 4    34 02          PSHS    A      ;			save A
4D29      8D 05          BSR     $4D30  ;			send and rewind to beginning of buffer (and inc dest address)
4D2B 5    35 02          PULS    A      ;			restore A
->
4D2D      A7 A0          STA     ,Y+    ;			store A at Y
4D2F 9    39             RTS            ;			DONE
->
Routine:
;
;	Transmit, rewind to beginning of buffer and inc destination address
;
4D30      1F 20          TFR     Y,D    ;			D = Y
4D32  M   83 4D 8E       SUBD    #$4D8E ;			number of bytes that are used
4D35  M   F7 4D 8D       STB     $4D8D  ;			bytes used
4D38      CB 04          ADDB    #$04   ;			add 4 to the length to convert from the length of the buffer to the length of the packet
4D3A  M   8E 4D 8A       LDX     #$4D8A ;			X points to the data to send
4D3D  L7  BD 4C 37       JSR     $4C37  ;			transmit data
4D40 O    4F             CLRA           ;			clear top byte of D
4D41  M   F6 4D 8D       LDB     $4D8D  ;			bytes from file
4D44  M   F3 4D 8B       ADDD    $4D8B  ;			Poly's address for the packet
4D47  M   FD 4D 8B       STD     $4D8B  ;			place the next packed immediately after this on in the Poly's memory
4D4A   M  10 8E 4D 8E    LDY     #$4D8E ;			rewind buffer pointer to beginning of the packet
4D4E 9    39             RTS            ;			DONE
->
4D4F 50 4F 4C 59 53 59 53 00 53 59 53   POLYSYS.SYS ;
->
4D5A 42 41 53 49 43 00 00 00 43 4D 44   BASIC...CMD ;
->
4D65 30 2E 4D 45 4E 55 2E 42 41 43      0.MENU.BAC   ;
->
4D6F 00 00 00 00 00 00 00 00 00 00 00 00 00 00		; the name of a basic program to load at startup
4D7D 00 											; length of the filename
->
4D7E 04												; boot command
4D7F 00 											; boot, restart, or broadcast
->
4D80 02 C1 00 03 7E A0 09 							; message to load JMP $A009 at $C100, it, branch to POLY Basic interpreter (what to do?).
->
4D87 00 											; Compiled Basic (BAC) decoder byte
->
4D88 00 
4D89 00 
->
4D8A 02 			; start of the buffer used to transmit data (e.g. a .BAC file) to the user
4D8B 00 00 			; word copied from 4E8E (this looks like the address of where to put the data)
4D8D 00 			; number of bytes in the following buffer that are used
;
;	$4D8E-$4E85 is used as a buffer by the compiled basic file decoder
;
4D8E 00 
4D8F 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 ................   ;
4D9F 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 ................   ;
4DAF 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 ................   ;
4DBF 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 ................   ;
4DCF 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 ................   ;
4DDF 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 ................   ;
4DEF 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 ................   ;
4DFF 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 ................   ;
4E0F 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 ................   ;
4E1F 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 ................   ;
4E2F 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 ................   ;
4E3F 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 ................   ;
4E4F 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 ................   ;
4E5F 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 ................   ;
4E6F 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 ................   ;
4E7F 00 00 00 00 00 00 00 
->
4E86 02				; packet to send to the Poly after transmitting a .BAC file
4E87 00 0A 			; destinaton address
4E88 04 			; size in bytes
4E8A 00 00 			; address of end of file once loaded in Poly
4E8C 00 00			;
->
4E8E 00 00			; word that is copied to 4D8B (address in POLY as stated in incoming packet?)
->
4E90 02 E8 02 19 0D 02 42 52 4F 41 44 43 41 53 54 ......BROADCAST   ;
4E9F 20 4C 4F 41 44 49 4E 47 20 4E 4F 57 20 20     LOADING NOW      ;
->
4EAD 02 E8
4EAF 02 1A 0D 06 42 52 4F 41 44 43 41 53 54 20 50 52 ....BROADCAST PR   ;
4EBF 4F 47 52 41 4D 20 4C 4F 41 44 45 44             OGRAM LOADED       ;
->
4ECB 02 E8 02 14                                     ....               ;
4ECF 0D 02 53 59 53 54 45 4D 20 4C 4F 41 44 49 4E 47 ..SYSTEM LOADING   ;
4EDF 20 4E 4F 57                                     NOW				;
->
4EE3 02 E9 B8 19 43 41 4E 4E 4F 54 20 52 45 41 44 20 ....CANNOT READ    ;
4EF3 20 											; drive number (in ascii)
4EF4 2E												; "."
4EF5 00 00 00 00 00 00 00 00 00 00 00				; filename
->
4F00 00 
4F01 00 								; broadcast flag (if non-zero then broadcast)
4F02 00 00 								; length of an FCB
4F04 00 								; command number
4F05 00 
4F06 00 00 
4F08 4F 0A 				; Poiner to end of list of Poly UIDs
4F0A 00 00 				; array of UIDs of remote Poly machines
4F0C 00 00 
4F0E 00 00 
4F10 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 ................   ;
4F1F 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 ................   ;
4F2F 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 ................   ;
4F3F 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 ................   ;
4F4F 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 ................   ;
4F5F 00 00 00 00 00 00 00 00 00 00 00                ...........        ;
->
;
;	REMOTE_FCB
;	----------
;	Process a remote FCB and return it to the Poly
;
;
4F6A  [   8E 5B 19       LDX     #$5B19 ;			FCB address
4F6D      EC 88 1C       LDD     $1C,X  ;			FCB list pointer (Poly UID word)
4F70   6  FD D4 36       STD     $D436  ;			UID of remote Poly
4F73   @  EC 88 40       LDD     $40,X  ;			FCB sector buffer
4F76   [  FD D4 5B       STD     $D45B  ;			Sector buffer of remote Poly
4F79   2  EC 88 32       LDD     $32,X  ;			FCB first deleted directory pointer!
4F7C      BD D4 06       JSR     $D406  ;			FLEX FMS Call (do the command)
4F7F      E6 01          LDB     $01,X  ;			FCB Error
4F81   2  ED 88 32       STD     $32,X  ;			FCB first deleted directory pointer (what was A?)
4F84 ]    5D             TSTB           ;			was there an error?
4F85      1C FE          ANDCC   #$FE   ;			clear the carry
4F87 '    27 02          BEQ     $4F8B  ;			don't set the carry
4F89      1A 01          ORCC    #$01   ;			set the carry
->
4F8B      1F A9          TFR     CC,B   ;			copy CC to B and store
4F8D   4  E7 88 34       STB     $34,X  ;			FCB first deleted directory pointer
4F90    @ 10 8E 01 40    LDY     #$0140 ;			length of the complete FCB (320 bytes)
->
4F94  O   F6 4F 04       LDB     $4F04  ;			command
4F97  Q   BD 51 A1       JSR     $51A1  ;			Transmit FCB to Poly
4F9A      86 11          LDA     #$11   ;		? trash the ID (are is #$11xx reserved?)
4F9C   6  B7 D4 36       STA     $D436  ;			UID of remote Poly
4F9F ~IC  7E 49 43       JMP     $4943  ;
->
4FA2      EC 88 1C       LDD     $1C,X  ;			FCB list pointer (Poly UID word)
4FA5   6  FD D4 36       STD     $D436  ;			UID of remote Poly
4FA8      BD D4 03       JSR     $D403  ;			FLEX FMS Close
4FAB ~IC  7E 49 43       JMP     $4943  ;
->
4FAE 32						; "2" 
4FAF 46 					; "F"
4FB0 01 2C 					; " ,"
4FB2 00 00 					; start address to read into
4FB4 00 00 					; end address to read into
4FB6 00 00 					; address of the last byte in the last packet we just read
4FB8 00 				;? current machine we're sending to ?
4FB9 01					;? current machine we're recieving from ?
4FBA 01 				;?
4FBB 00 00					; UID of remote Poly (bytes 2 and 3 in the packet)
4FBD 00						; first byte from the packet	low nibble must be a 0001
4FBE 00 					; if 0 then don't read a packet, if 1 then read a packet
4FBF 00 					; interrupt flag?  When 0 we fake an interrupt return and do not read a packet
4FC0 00 					; current value of network status register 2 (high bit is set on timeout)
4FC1 00  					; an old value of 4FC0!
4FC2 00 				;?
4FC3 00 00 00 00 00 00 00 00 
4FCB 00 00 00 00 00 00 00 00 ; 16 bytes, one for each machine?
4FD3 00 00 00 00 00 00 00 00 
4FDB 00 00 00 00 00 00 00 00 ; 16 bytes, one for each machine?
4DE3 00					;?
->
Routine:
;
;	Set up timer and network controllers?
;	-------------------------------------
;
4FE4      C6 10          LDB     #$10   ;			low byte of clock latch value
4FE6      86 92          LDA     #$92   ;			Wiggle O1 (or is it O3) pin, continious operating mode 
4FE8      B7 E0 20       STA     $E020  ;			6840 Timer Control Register 1
4FEB O    4F             CLRA           ;			A = 0
4FEC   &  FD E0 26       STD     $E026  ;			latch value is $0010
4FEF      CC C1 08       LDD     #$C108 ;			(A=C1 B=08) (TxReset, RxReset, AC=1, 01/11 idle)
4FF2      8D 0A          BSR     $4FFE  ;			write to network control registers
4FF4      86 1E          LDA     #$1E   ;			Reciever and sender information field length = 8 bits
4FF6   6  B7 E0 36       STA     $E036  ;			Network control register 4
4FF9      1C EF          ANDCC   #$EF   ;			clear the "E" flag (so this was a "fast" interrupt)
4FFB      CC 00 01       LDD     #$0001 ;			AC = 0, disable interrupts, out of reset, prioritised status enable	
->
Routine:
4FFE   0  B7 E0 30       STA     $E030  ;			Network control register 1
5001   2  F7 E0 32       STB     $E032  ;			Network control register 2 (or 3)
->
5004 9    39             RTS            ;			DONE
->
Routine:
5005  O   BE 4F B0       LDX     $4FB0  ;	? Initial number of Poly in the network ?
->
;
;	Call $5015 (X times)
;
;
5008 4    34 10          PSHS    X      ;			save X
500A      8D 09          BSR     $5015  ;	? appears to warm-cycle the networking of every machine in the network!
500C 5    35 10          PULS    X      ;			restore X
500E      27 F4          BEQ     $5004  ;			DONE
5010 0    30 1F          LEAX    $-01,X ;			x = x - 1
5012 &    26 F4          BNE     $5008  ;			if non zero then again
5014 9    39             RTS            ;			DONE
->
Routine:
;
;	Transmit
;		destination id
;		$17			remote:reset the network
;		$00
;		$BF			remote:send UID to me
;		destination id
;		$13			remote:pritorise enable
;		destination id
;		$73			remote:enter loop mode
;		$00
;
5015  O   7F 4F B9       CLR     $4FB9  ;		? id of current destination machine
5018  O   7F 4F BA       CLR     $4FBA  ;		??
501B  O   7F 4F D3       CLR     $4FD3  ;		?? D3 value of machine 00
501E      8D C4          BSR     $4FE4  ;			initialise timer and network controllers
5020   X  8E 02 58       LDX     #$0258 ;			X=$0258
5023  P   BD 50 C9       JSR     $50C9  ;			timeing loop (of length X)
5026  P   BD 50 D4       JSR     $50D4  ;	transmit id of destination machine
5029      86 17          LDA     #$17   ;	$17
502B  P   BD 50 CE       JSR     $50CE  ;			Transmit A and read a packet
->
502E      8E 04 B0       LDX     #$04B0 ;			(dec:1200)
5031  P   BD 50 C9       JSR     $50C9  ;			timeing loop (of length X)
5034 |O   7C 4F B9       INC     $4FB9  ;			current destination machine
5037  O   8E 4F E3       LDX     #$4FE3 ;			start address
503A      10 8E 00 01    LDY     #$0001 ;			length of packet
503E  R#  BD 52 23       JSR     $5223  ;			D = X + Y (and then save X in 4FB2 and D in 4FB4)
5041      86 01          LDA     #$01   ;			read a packet const
5043  O   B7 4F BE       STA     $4FBE  ;			store in the read a packet variable
5046      C6 01          LDB     #$01   ;			B = 1
5048 O    4F             CLRA           ;	$00
5049  RB  BD 52 42       JSR     $5242  ;			transmit A down the network
504C      86 BF          LDA     #$BF   ;	$BF
504E  RR  BD 52 52       JSR     $5252  ;			Transmit A down the network
5051  O   B6 4F B9       LDA     $4FB9  ;	id of destination machine
5054  x   8D 78          BSR     $50CE  ;			Transmit A and read a packet
5056 &E   26 45          BNE     $509D  ;	COMMAND $13 (transmit:destination id, $13)
5058  O   B6 4F BD       LDA     $4FBD  ;			first byte in packet
505B      81 13          CMPA    #$13   ;			did we get a $13
505D &    26 3B          BNE     $509A  ;			nope, A=$01, DONE
505F  O   BE 4F BB       LDX     $4FBB  ;			second byte in packet and third byte in packet (UID of Poly)
5062  O   CE 4F 0A       LDU     #$4F0A ;			start of array of Poly UIDs
->
5065   O  11 B3 4F 08    CMPU    $4F08  ;			pointer to end of list of Poly UIDs
5069 $    24 08          BCC     $5073  ;			BHS (ie, at end of list)
506B      AC C1          CMPX    ,U++   ;			does X match the value stored at U (and add 2 to U)
506D      27 0B          BEQ     $507A  ;			yup, so move on
506F 3A   33 41          LEAU    $01,U  ;			U = U + 1
5071      20 F2          BRA     $5065  ;			loop back round (at which point U has had 3 added to it)
->
5073      AF C1          STX     ,U++   ;			save Poly UID at end of list
5075 0A   30 41          LEAX    $01,U  ;			point to end of list
5077  O   BF 4F 08       STX     $4F08  ;			and store that as the end of the list
->
507A      86 0A          LDA     #$0A   ;	?? why this value ??
507C      A7 C4          STA     ,U     ;			store that as the param after the UID
507E |O   7C 4F BA       INC     $4FBA  ;	??
5081  O   BE 4F B8       LDX     $4FB8  ;		?current machine we're sending to?
5084 o O  6F 89 4F C3    CLR     $4FC3,X;			clear the C3 buffer
5088 o O  6F 89 4F D3    CLR     $4FD3,X;			clear the D3 buffer
508C  F   8D 46          BSR     $50D4  ;	transmit id of destination machine
508E  s   86 73          LDA     #$73   ;	$73
5090  RR  BD 52 52       JSR     $5252  ;			Transmit A down the network
5093  O   B6 4F C2       LDA     $4FC2  ;	?? (appears to be 00)
5096  6   8D 36          BSR     $50CE  ;			Transmit A and read a packet
5098      27 94          BEQ     $502E  ;			transmit the 00 BF thing again
->
509A      86 01          LDA     #$01   ;			A=$01
509C 9    39             RTS            ;			DONE
->
;
;	???? COMMAND $13 (remote turn on prioritised packet processing)
;	----------------
;	Transmit
;		destination id
;		$13
;	read a packet
;
509D zO   7A 4F B9       DEC     $4FB9  ;			current machine
50A0      27 F8          BEQ     $509A  ;			A=$01, DONE
50A2  0   8D 30          BSR     $50D4  ;			transmit id of destination and read a packet
50A4      86 13          LDA     #$13   ;	$13		
50A6  &   8D 26          BSR     $50CE  ;			transmit A and read packet
50A8 &    26 F0          BNE     $509A  ;			A=$01, DONE
50AA   X  8E 02 58       LDX     #$0258 ;			(dec 600)
50AD      8D 1A          BSR     $50C9  ;			timeing loop (of length X)
50AF  O   F6 4F BA       LDB     $4FBA  ;	??
50B2 Z    5A             DECB           ;			dec
50B3      C1 04          CMPB    #$04   ;			compare to $04
50B5 $    24 02          BCC     $50B9  ;			if greateror same then OK
50B7      C6 04          LDB     #$04   ;			otherwise set it to $04
->
50B9      86 92          LDA     #$92   ;			TXoutput Enabled, Continious Operating Mode, TX uses enable clock
50BB      B7 E0 20       STA     $E020  ;			Timer Control Register 1
50BE O    4F             CLRA           ;			A=$00
50BF 4    34 04          PSHS    B      ;			take B
50C1 W    57             ASRB           ;			divide by 2
50C2      EB E0          ADDB    ,S+    ;			add what B was (result B=B+B*0.5)
50C4   &  FD E0 26       STD     $E026  ;	??
50C7 O    4F             CLRA           ;			A=$00
50C8 9    39             RTS            ;			DONE
->
Routine:
;
;	TIME_LOOP
;	---------
;	This is a timing loop that counts down from X
;
50C9 0    30 1F          LEAX    $-01,X ;			x = x - 1
50CB &    26 FC          BNE     $50C9  ;			compare to 0
50CD 9    39             RTS            ;			DONE
->
Routine:
;
;	Transmit A, end packet, and read packet
;	--------------------------------------
;
50CE  RR  BD 52 52       JSR     $5252  ;			Transmit A down the network
50D1 ~Rb  7E 52 62       JMP     $5262  ;			Read a packet into where $4FB2 points, DONE
->
Routine:
;
;	Transmit id of destination machine and read a packet
;	----------------------------------------------------
;
50D4      86 01          LDA     #$01   ;			yes, read a packet
50D6 ~R   7E 52 3B       JMP     $523B  ;			transmit id of destination machine
->
Routine:
;
;	NEXT_POLY
;	---------
;	move on to the next active machine
;	that can be verified to still be there.
;
50D9  R#  BD 52 23       JSR     $5223  ;			D = X + Y (and then save X in 4FB2 and D in 4FB4)
50DC |O   7C 4F B9       INC     $4FB9  ;			current machine
50DF  O   B6 4F B9       LDA     $4FB9  ;			current machine
50E2  O   B1 4F BA       CMPA    $4FBA  ;	??
50E5 #    23 05          BLS     $50EC  ;			do what-ever we're doing to the current machine
50E7      86 01          LDA     #$01   ;			else set the current machine to $01
50E9  O   B7 4F B9       STA     $4FB9  ;			current machine
->
50EC  E   20 45          BRA     $5133  ;		? verify the existance of that machine?
->
Routine:
;
;	REMOTE_LOGOUT (COMMAND $1B)
;	-------------
; transmit
;	id of remote machine
;	$1B
;	Value of accumulator A (always $00)
; get next packet
;
50EE 4    34 02          PSHS    A      ;			save A
50F0      CC 00 10       LDD     #$0010 ;			0010
50F3   &  FD E0 26       STD     $E026  ;			latch 0010 to the clock
50F6  R:  BD 52 3A       JSR     $523A  ;			transmit id of destination machine
50F9      86 1B          LDA     #$1B   ;	$1B		? (what command it this?)
50FB  RR  BD 52 52       JSR     $5252  ;			Transmit A down the network
50FE 5    35 02          PULS    A      ;			restore A
5100  P   BD 50 CE       JSR     $50CE  ;			transmit A and get a packet back
5103 4    34 01          PSHS    CC     ;			save flags
5105  O   F6 4F BA       LDB     $4FBA  ;		??
5108 Z    5A             DECB           ;			subtract 1
5109      C1 04          CMPB    #$04   ;			is it now $04
510B $    24 02          BCC     $510F  ;			BHS ($04 is the min allowed value)
510D      C6 04          LDB     #$04   ;			so set it to $04
->
510F O    4F             CLRA           ;			A = 0
5110 4    34 04          PSHS    B      ;			push B
5112 W    57             ASRB           ;			divide by 2
5113      EB E0          ADDB    ,S+    ;			add B again (B = B + B * 0.5)
5115   &  FD E0 26       STD     $E026  ;			clock latch
5118 5    35 81          PULS    PC,CC  ;			pull flags (the old B value), DONE
->
Routine:
;
;	Get Message from Poly
;
;	Y = length of message to recieve
;	X = message buffer to rec into
;
511A  R#  BD 52 23       JSR     $5223  ;			D = X + Y (and then save X in 4FB2 and D in 4FB4)
511D  O   B6 4F AE       LDA     $4FAE  ;
5120 4    34 02          PSHS    A      ;
->
5122      8D 0F          BSR     $5133  ;	? verify existance of machine?
5124      27 04          BEQ     $512A  ;			pop and DONE	
5126 j    6A E4          DEC     ,S     ;			dec top of stack
5128 &    26 F8          BNE     $5122  ;			more
->
512A 2a   32 61          LEAS    $01,S  ;			inc the stack (this is a pop)
512C }O   7D 4F C0       TST     $4FC0  ;			status register 2
512F 9    39             RTS            ;			DONE
->
5130      BD 52 23       JSR     $5223  ;			D = X + Y (and then save X in 4FB2 and D in 4FB4)
->
Routine:
;
;	COMMAND $33
;	-----------
;	Verify existance of machine?
;	----------------------------
; transmit
;	remote machine id
;	$33
;	$00
; read a packet
; transmit
;	NACK or ACK
;
5133  R/  BD 52 2F       JSR     $522F  ;			transmit id of destination machine
5136  3   86 33          LDA     #$33   ;			transmit $33
5138  RR  BD 52 52       JSR     $5252  ;			Transmit A down the network
513B O    4F             CLRA           ;			transmit $00
513C  RR  BD 52 52       JSR     $5252  ;			Transmit A down the network
513F  Rb  BD 52 62       JSR     $5262  ;			Read a packet into where $4FB2 points
5142 '    27 04          BEQ     $5148  ;			all ok, so keep going
5144  Q   8D 51          BSR     $5197  ;		?error - transmit a NACK to the Poly?
5146 &+   26 2B          BNE     $5173  ;			standardise the result, DONE
->
5148  O   B6 4F BD       LDA     $4FBD  ;			first byte in packet
514B      84 11          ANDA    #$11   ;			turn off all except low bits in each nibble
514D      81 10          CMPA    #$10   ;			is the low bit of the high nibble set?
514F &    26 1D          BNE     $516E  ;			error, standardise the result, DONE
5151  O   B6 4F BD       LDA     $4FBD  ;			first byte in packet
5154 H    48             ASLA           ;			shift
5155 H    48             ASLA           ;			shift
5156 H    48             ASLA           ;			shift
5157 H    48             ASLA           ;			shifted from high to low nibble
5158  O   F6 4F B9       LDB     $4FB9  ;			current machine?
515B  O   8E 4F C3       LDX     #$4FC3 ;			lookup table of first-bytes
515E      A1 85          CMPA    B,X    ;			do they match?
5160 4    34 01          PSHS    CC     ;			push the flags
5162 &    26 04          BNE     $5168  ;		? is this an acknowledge of the packet ?
5164      8B 20          ADDA    #$20   ;			set bit 2 of the high nibble
5166      A7 85          STA     B,X    ;			store it in the table of first-bytes
->
5168      8D 1B          BSR     $5185  ;		? send the ACK to the Poly?
516A 5    35 01          PULS    CC     ;			restore the flags
516C      27 05          BEQ     $5173  ;			standardise the result, DONE
->
516E      86 81          LDA     #$81   ;			timeout flag
5170  O   B7 4F C0       STA     $4FC0  ;			status register 2
->
;
;	STANDARDISE RESULT
;	------------------
;	set X = packet start address
;	set Y = packet length
;	set B = "third byte"
;	set A = status register 2 value
;
5173  O   FC 4F B6       LDD     $4FB6  ;			address of last byte in the packet
5176  O   B3 4F B2       SUBD    $4FB2  ;			packet start address, so D in the packet length
5179  O   BE 4F B2       LDX     $4FB2  ;			packet start address
517C      1F 02          TFR     D,Y    ;			Y = packet length
517E  O   F6 4F BC       LDB     $4FBC  ;		? command (third byte)
5181  O   B6 4F C0       LDA     $4FC0  ;			network status register 2
5184 9    39             RTS            ;			DONE
->
Routine:
;
;	ACKNOLWEDGE
;	-----------
; transmit:
;	id of remote machine
;	first-byte with low bit of each nibble set
;	then wait for a reply
;
5185  R:  BD 52 3A       JSR     $523A  ;			transmit id of destination machine
5188  O   BE 4F B8       LDX     $4FB8  ;			which machine I think it is
518B   O  A6 89 4F C3    LDA     $4FC3,X;			first byte that the machine sent to me
518F      8A 11          ORA     #$11   ;			with the low bit of each nibble set
5191  RR  BD 52 52       JSR     $5252  ;			Transmit A down the network
5194 ~Rb  7E 52 62       JMP     $5262  ;			Read a packet into where $4FB2 points, DONE
->
Routine:
;
;	NOT_ACKNOWLEDGE
;	---------------
; transmit:
;	id of remote machne
;	00
;	then wait for a reply
;
5197  R/  BD 52 2F       JSR     $522F  ;			transmit id of destination machine
519A O    4F             CLRA           ;			A=$00
519B  RR  BD 52 52       JSR     $5252  ;			Transmit A down the network
519E ~Rb  7E 52 62       JMP     $5262  ;			Read a packet into where $4FB2 points, DONE
->
;
;	TRANSMIT_FCB
;	------------
;	Transmit FCB to the Poly.
;
;	X = FCB
;	Y = length
;	B = (#$13 #$04, #$07, #$10)
;
Routine:
51A1 2    32 7F          LEAS    $-01,S ;			subtract 1 from S (thus increasing the stack)
51A3 44   34 34          PSHS    Y,X,B  ;			push Y, X, B
51A5  O   B6 4F AF       LDA     $4FAF  ;		??
51A8  e   A7 65          STA     $05,S  ;			put that on the stack too (just before Y)
->
51AA O    4F             CLRA           ;			A = 0
51AB _    5F             CLRB           ;			B = 0, D = 0
51AC  O   FD 4F B4       STD     $4FB4  ;			packet end address
51AF  R/  BD 52 2F       JSR     $522F  ;		transmit id of destination machine
51B2  O   BE 4F B8       LDX     $4FB8  ;
51B5   O  A6 89 4F C3    LDA     $4FC3,X;		??
51B9   O  AA 89 4F D3    ORA     $4FD3,X;		??
51BD      8A 10          ORA     #$10   ;		??
51BF  RR  BD 52 52       JSR     $5252  ;		Transmit A down the network	
51C2      A6 E4          LDA     ,S     ;			Parameter B
51C4  RR  BD 52 52       JSR     $5252  ;		Transmit A (that is, parameter B) down the network
51C7  c   EC 63          LDD     $03,S  ;			length of data to send (parameter Y)
51C9  a   AE 61          LDX     $01,S  ;			address of data to send
->										; 	transmit D characters from (parameter X)
51CB      83 00 01       SUBD    #$0001 ;			dec chars left
51CE -    2D 0B          BLT     $51DB  ;			are we finished
51D0 4    34 06          PSHS    D      ;			save count
51D2      A6 80          LDA     ,X+    ;			load next char into A
51D4  RR  BD 52 52       JSR     $5252  ;			Transmit A down the network
51D7 5    35 06          PULS    D      ;			restore count
51D9      20 F0          BRA     $51CB  ;			more to do
->										;
51DB  Rb  BD 52 62       JSR     $5262  ;			Read a packet into where $4FB2 points
51DE .<   2E 3C          BGT     $521C  ;			error so restart
51E0      27 0E          BEQ     $51F0  ;			no error so verfy all OK
51E2  O   BE 4F B8       LDX     $4FB8  ;
51E5 &    26 05          BNE     $51EC  ;
51E7  O   7F 4F C0       CLR     $4FC0  ;			network status register 2
51EA  #   20 23          BRA     $520F  ;			clean stack, standardise result, and DONE
->
51EC      8D A9          BSR     $5197  ;	?NACK?
51EE &,   26 2C          BNE     $521C  ;		loop back round (or time out)
->
51F0  O   B6 4F BD       LDA     $4FBD  ;			first byte in packet
51F3      84 0F          ANDA    #$0F   ;			turn high nibble off
51F5      81 01          CMPA    #$01   ;			check the low nibble
51F7 &    26 1E          BNE     $5217  ;			nope, so fake a time-out from the network controller
51F9  O   B6 4F BD       LDA     $4FBD  ;			first byte in packet
51FC D    44             LSRA           ;			shift
51FD D    44             LSRA           ;			shift
51FE D    44             LSRA           ;			shift
51FF D    44             LSRA           ;			shifted high nibble to low nibble
5200      84 0E          ANDA    #$0E   ;			turn bottom bit off
5202  O   BE 4F B8       LDX     $4FB8  ;		?current machine we're talking to?
5205   O  A1 89 4F D3    CMPA    $4FD3,X;		is this the right "first byte"?
5209 '    27 09          BEQ     $5214  ;
520B   O  A7 89 4F D3    STA     $4FD3,X;		store the first byte
->
520F 2f   32 66          LEAS    $06,S  ;			add 6 to the stack (clean up)
5211 ~Qs  7E 51 73       JMP     $5173  ;			standardise the result, DONE
->
5214  Q   BD 51 85       JSR     $5185  ;
->
5217      86 80          LDA     #$80   ;			set high bit (fake a time-out)
5219  O   B7 4F C0       STA     $4FC0  ;			save as network status register 2 (high bit is set on timeout)
->
521C je   6A 65          DEC     $05,S  ;		dec the number of times we'll try (time out?)
521E      27 EF          BEQ     $520F  ;			clean up, standardise the answer, and DONE
5220 ~Q   7E 51 AA       JMP     $51AA  ;			try again
->
Routine:
;
;	D = X + Y
;	---------
;	in the example case X = address (is Y a length value?)
;	then store X as the packet start address
;	     store D as the packet end address
;
5223      1F 20          TFR     Y,D    ;			D=Y
5225  O   BF 4F B2       STX     $4FB2  ;			save X as start address to read into
5228  O   F3 4F B2       ADDD    $4FB2  ;			D = D + X
522B  O   FD 4F B4       STD     $4FB4  ;			save X+Y as end address to read upto
522E 9    39             RTS            ;			DONE
->
Routine:
;
;	transmit id of destination machine
;	----------------------------------
;
522F O    4F             CLRA           ;			not expecting response from Poly
5230  O   BE 4F B2       LDX     $4FB2  ;			start address to read into
5233  O   BF 4F B6       STX     $4FB6  ;			address of last byte in the packet
5236      C6 01          LDB     #$01   ;			B=01
5238      20 02          BRA     $523C  ;			transmit id of destination machine
->
Routine:
;
;	Transmit ID ($4FB9) of destination machine
;	------------------------------------------
;	not expecting a reply from the Poly
;	fake an interrupt return
;	transmit the id of the destination machine
;
523A O    4F             CLRA           ;			not expecting response from Poly
->
523B _    5F             CLRB           ;			B=00 (fake an interrupt return and do not load a packet
->
523C  O   B7 4F BE       STA     $4FBE  ;			are we expecting a response by the Poly?
523F  O   B6 4F B9       LDA     $4FB9  ;		? current machine?
->
Routine:
5242  O   F7 4F BF       STB     $4FBF  ;			interrupt flag?
5245  O   7F 4F C0       CLR     $4FC0  ;			last value of status register 2
5248      1A 10          ORCC    #$10   ;			disable IRQ
524A  @   C6 40          LDB     #$40   ;			RxReset
524C   0  F7 E0 30       STB     $E030  ;			Network control register 1 (RxReset)
524F   0  7F E0 30       CLR     $E030  ;			turn off network interrupts
->
Routine:
;
;	Transmit A down the network
;	---------------------------
;
5252   0  F6 E0 30       LDB     $E030  ;			E030 (Network status register?)
5255  @   C5 40          BITB    #$40   ;			TDRA/FC
5257 &    26 05          BNE     $525E  ;			set so we can transmit
5259      C5 20          BITB    #$20   ;			check for Underrun
525B      27 F5          BEQ     $5252  ;			no underrun so keep waiting
525D 9    39             RTS            ;			DONE
->
525E   4  B7 E0 34       STA     $E034  ;			E034 (Network data register?)
5261 9    39             RTS            ;			DONE
->
Routine:
;
;	READ PACKET
;	-----------
;	Mark the last write as and end of frame
;	Read a packet into where $4FB2 points and swallow all other crap on the network
;
5262   0  B6 E0 30       LDA     $E030  ;			network status register 1
5265      85 20          BITA    #$20   ;			check bit 2 (does status register 2 need reading?)
5267 &E   26 45          BNE     $52AE  ;			status register 2 has set bits so save it and reset the transmitter status
5269      86 11          LDA     #$11   ;			TxLast (end of frame), Prioritised status enable
->
526B   2  B7 E0 32       STA     $E032  ;			status register 2
526E  O   B6 4F BE       LDA     $4FBE  ;			do we expect a packet in response?
5271 &R   26 52          BNE     $52C5  ;			read a packet (into where where $4FB2 points)
->						 				;			read what ever is on the network until the point at which there's nothing left (or a new packet)
5273      8E 04 00       LDX     #$0400 ;			this looks like a timeout - $400 lots of nothing on the network and we're happy
->
5276   0  B6 E0 30       LDA     $E030  ;			network status register 1
5279      85 01          BITA    #$01   ;			check first bit (data ready (that isn't an address or final data))
527B      27 05          BEQ     $5282  ;			nope (that this, either no data, or an address is present) so move on
->
527D   4  B6 E0 34       LDA     $E034  ;			read network data register and throw away
5280      20 F1          BRA     $5273  ;			more (start over)
->										;			we should be ready to read a packet at this point
5282      85 02          BITA    #$02   ;			check second bit (S2RQ (status register 2 non-zero?))
5284      27 19          BEQ     $529F  ;			status register 2 is zero (nothing happening, so move on)
5286   2  B6 E0 32       LDA     $E032  ;			read network status register 2
5289      85 01          BITA    #$01   ;			address present bit
528B &    26 F0          BNE     $527D  ;			read the address field and throw it away
528D  D   85 44          BITA    #$44   ;			inactive idle bit | overrun bit
528F &    26 0A          BNE     $529B  ;			one or other is set so reset recieve status and more (start over)
5291      85 02          BITA    #$02   ;			frame valid bit (last byte of transmission)
5293 &&   26 26          BNE     $52BB  ;			toss the last character then read a packet
5295  O   BA 4F C0       ORA     $4FC0  ;			or with the previous value of status register 2
5298  O   B7 4F C0       STA     $4FC0  ;			and save the value of status register 2
->										;			inactive idle (or) overrun bit is set
529B      8D 18          BSR     $52B5  ;			reset recieve status
529D      20 D4          BRA     $5273  ;			more (start over)
->										;			status register 2 is zero
529F 0    30 1F          LEAX    $-01,X ;			dec X
52A1 &    26 D3          BNE     $5276  ;			wait longer
52A3      86 02          LDA     #$02   ;			set the valid frame bit (ie this is the end of a packet)
52A5  O   BA 4F C0       ORA     $4FC0  ;			network status register 2
52A8  O   B7 4F C0       STA     $4FC0  ;			put it back
52AB ~S4  7E 53 34       JMP     $5334  ;			Clear "E" and DONE
->										;			save status register 2, and reset the transmitter status
52AE  O   B7 4F C0       STA     $4FC0  ;			save status register 2
52B1  A   86 41          LDA     #$41   ;			Clear Transmitter Status, Priority Status Enable
52B3      20 B6          BRA     $526B  ;			set control register 2
->
Routine:
;
;	deal with network idle | overrun.  Reset recieve status
;
52B5  !   86 21          LDA     #$21   ;			Clear Rx status | Pritorized Status Enable
52B7   2  B7 E0 32       STA     $E032  ;			Network Control Register 2
52BA 9    39             RTS            ;			DONE
->
;
;	network frame valid bit is set (so the next read is the last byte of the packet)
;
52BB   4  B6 E0 34       LDA     $E034  ;			E034 (Network data register?)
52BE }O   7D 4F C0       TST     $4FC0  ;			value of status register 2
52C1 &    26 D8          BNE     $529B  ;			not zero so reset the recieve status and start over
52C3      8D F0          BSR     $52B5  ;			reset recieve status
->										; 			
52C5  O   B6 4F BF       LDA     $4FBF  ;			check interrupt flag
52C8  j   27 6A          BEQ     $5334  ;			Clear "E" and DONE
52CA   R  10 8E 52 F9    LDY     #$52F9 ;			address to branch to next
52CE  R   1E 52          EXG     PC,Y   ;			read a byte from network and return it in A (branch to $52F9)
52D0  O   B1 4F B9       CMPA    $4FB9  ;		?? is this the machine we are expecting a reply from ??
52D3      27 07          BEQ     $52DC  ;			read a packet
52D5      86 81          LDA     #$81   ;			high bit is time-out, low bit is addres present (next byte is the address, that is, we're about to start a new packet)
52D7  O   B7 4F C0       STA     $4FC0  ;			store where status reguster 2 is kept
52DA      20 97          BRA     $5273  ;			more (start over)
->
52DC  O   BE 4F B2       LDX     $4FB2  ;			start address
52DF  R   1E 52          EXG     PC,Y   ;			get next byte
52E1  O   B7 4F BD       STA     $4FBD  ;		??save the first byte
52E4  R   1E 52          EXG     PC,Y   ;			get bext byte
52E6  O   B7 4F BB       STA     $4FBB  ;		??save the second byte
52E9  R   1E 52          EXG     PC,Y   ;			get next byte
52EB  O   B7 4F BC       STA     $4FBC  ;		??save the third byte
->
52EE  R   1E 52          EXG     PC,Y   ;			get next byte
52F0  O   BC 4F B4       CMPX    $4FB4  ;			end address
52F3 $    24 F9          BCC     $52EE  ;			branch high or same (toss the remainder of the packet)
52F5      A7 80          STA     ,X+    ;			save the byte we just read
52F7      20 F5          BRA     $52EE  ;			read more data (at the end of the framw the EXG results in an RTS)
->
Routine:
;
;	GET NEXT BYTE
;	-------------
;	Some kind of finite state machine that returns the next byte from the
;	network controller under time-out conditions
;
;	4FC0 stores status register 2 but
;		high bit is set if timeout occurred (either controller or software)
;
52F9      C6 FF          LDB     #$FF   ;			maximum number of retries
->
52FB Z    5A             DECB           ;			dec 
52FC  /   27 2F          BEQ     $532D  ;			timed out so exit the loop
52FE   0  B6 E0 30       LDA     $E030  ;			E030 Network status register 1
5301      85 01          BITA    #$01   ;			RDA (data available)
5303      27 07          BEQ     $530C  ;			nope, so check status register 2 and process all that stuff
->
5305   4  B6 E0 34       LDA     $E034  ;			E034 Network data register
5308  R   1E 52          EXG     PC,Y   ;			DONE
530A      20 ED          BRA     $52F9  ;			restart the read another byte business
->
530C      85 02          BITA    #$02   ;			S2RQ (status register 2 is set)
530E      27 EB          BEQ     $52FB  ;			nope, so wait longer
5310   2  B6 E0 32       LDA     $E032  ;			status register 2
5313      85 01          BITA    #$01   ;			AP (Address present)
5315 &    26 EE          BNE     $5305  ;			address is present so read it and return to "Y"
5317      85 04          BITA    #$04   ;			Rx IDLE
5319 &    26 09          BNE     $5324  ;			the flag is set so deal with it
531B      85 02          BITA    #$02   ;			FV (Frame Valid) (frame is complete with no error)
531D &    26 20          BNE     $533F  ;			read and return with the next byte of data in A
531F      8A 80          ORA     #$80   ;		??
5321 ~R   7E 52 95       JMP     $5295  ;		??
->										;			deal with RxIDLE flag being set
5324 }O   7D 4F BE       TST     $4FBE  ;			did we expect a packet in response?
5327      27 04          BEQ     $532D  ;			store the fact that we have timed out
5329      8D 8A          BSR     $52B5  ;			reset reciever status
532B      20 CC          BRA     $52F9  ;			restart the read another byte business
->										;			reading from the network has timed out
532D      8A 80          ORA     #$80   ;			set the high bit
532F  O   B7 4F C0       STA     $4FC0  ;			store network status register 2
->
5332      8D 81          BSR     $52B5  ;			reset reciever status
->										;			Clear E and push the value of status register 2
5334      1C EF          ANDCC   #$EF   ;			clear the "E" flag (so this was a "fast" interrupt)
5336  O   B6 4F C0       LDA     $4FC0  ;			read the status register 2 value
5339 '    27 03          BEQ     $533E  ;			DONE
533B  O   B7 4F C1       STA     $4FC1  ;			store it here too! (but it looks like it never gets read)
->
533E 9    39             RTS            ;			DONE
->										;			this happens at the end of the transmission (last valid byte in the packet)
533F   4  B6 E0 34       LDA     $E034  ;			read from network data register
5342  R   1E 52          EXG     PC,Y   ;			return to "Y"
5344  O   BF 4F B6       STX     $4FB6  ;			pointer to last byte we read
5347      20 E9          BRA     $5332  ;			clear "E" flag and DONE
->
5349 00 00 00 00 00 00 										  .......   ;
534F 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 ................   ;
535F 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 ................   ;
536F 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 ................   ;
537F 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 ................   ;
538F 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 ................   ;
539F 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 ................   ;
53AF 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 ................   ;
53BF 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 ................   ;
53CF 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 ................   ;
53DF 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 ................   ;
53EF 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 ................   ;
53FF 00                                              .                  ;
->
;
;		PRINTER ROUTINES
;
;

Routine:
5400 ~X4  7E 58 34       JMP     $5834  ;
->
5403 39 
5404 00 			; next function in the branch table ($5557) to call next
5405 00 00 			; pointer to string to print
5407 03 04 00 00 00 00 00 00 00 00 00 00 9...............   ;
5413 00 00 
5415 00 00 00 00 00 00 00 00 00 00 00 00 00 00         ..............   ;
5423 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 ................   ;
5433 00 00 00 04 00 00 00 00 00 00 00 00 00 00 00 00 ................   ;
5443 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 ................   ;
5453 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 ................   ;
5463 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 ................   ;
5473 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 ................   ;
5483 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 ................   ;
5493 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 ................   ;
54A3 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 ................   ;
54B3 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 ................   ;
54C3 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 ................   ;
54D3 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 ................   ;
54E3 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 ................   ;
54F3 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 ................   ;
5503 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 ................   ;
5513 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 ................   ;
5523 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 ................   ;
5533 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 ................   ;
5543 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 ................   ;
5553 00 00 00 00 
->
5557 58 3C 			; 00
5559 59 1E 			; 01
555B 5A 5C 			; 02
555D 59 4E 			; 03
555F 5A 3B 			; 04
5561 5A 5C			; 05
5563 59 AD 			; 06
5565 5A 5C 			; 07
5567 5A 5C 			; 08
5569 5A 5C 			; 09
556B 5A 5C 			; 0A
556D 5A 5C 			; 0B
556F 58 3B 			; 0C
5571 58 3B			; 0D
5573 58 17 			; 0E Play Bell on Printer
5575 5A 5C 			; 0F
5577 59 D3 			; 10
5579 59 E0 			; 11
557B 5A 2A 			; 12
557D 5A 5C 			; 13
557F 5A 5C 			; 14
5581 5A 5C			; 15
5583 5A 5C 			; 16
5585 01 0F 15 14 0B 0A 06 16 09 11 04 00 0C 0D
5593 0E 10 02 13 05 03 12 07 08 
559C 00 
559D 56 CA 			; ???
559F 55 E4 			; initialise printer sequence
55A1 56 02			; cr lf lf
55A3 55 F3 			; reset printer sequence
55A5 56 C7 			; cr ff
55A7 56 39 			; lf cr lf stars
55A9 55 A9 			; here!
55AB 55 E4 			; initialise printer sequence
55AD 56 C2 			; cr lf lf lf
55AF 55 AF 			; here!
55B1 56 CA			; ???
55B3 54 57 			; ????
55B5 55 B5			; here! 
55B7 55 B7 			; here!
55B9 55 B9 			; here!
55BB 55 BB 			; here!
55BD 56 39 			; lf cr lf start
55BF 55 BF 			; here!
55C1 56 C2			; cr lf lf lf
55C3 56 CA			; ????
55C5 55 C5			; here!
55C7 56 0A			; Listing of
55C9 56 3A			; row of stars
;
; Print spooler parameter table
;
55CB 3C 			; lines per page
55CC 50 			; characters per line
55CD 84 			; compressed characters per line
55CE 28 			; elongated characters per line
55CF 0A 0A			; line feeds
55D1 0E 00 00 00 	; 4 characters needed to produce elongated characters
55D5 00 			; null terminated
55D6 0A 0A 			; line feeds
55D8 0F 00 00 00 	; 4 characters needed to produce compressed characters
55DC 00 			; null terminated
55DD 0A 0A 			; line feeds
55DF 00 00 00 00 	; 4 characters needed to produce normal characters
55E3 00 			; null terminated
55E4 12 14 1B 32 1B 39 1B 46 00 00 00 00 00 00 ; 14 characters to initialise printer
55F2 00 			; null terminated
55F3 12 00 00 00 00 00 00 00 00 00 00 00 00 00 ; 14 characters to reset the printer
5601 00 			; null terminated
5602 0D 0A 0A 		; cr lf lf
5605 0E 1B 45 00 	; 4 characters needed to produce double-printed characters
5609 00 			; null terminated
;
560A 20 20 20 20 20 20 20 20 20 ;
5613 20 20 20 20 20 20 20 20 20 20 20 20 4C 49 53 54             LIST   ;
5623 49 4E 47 20 4F 46 20 20 00 00 00 00 00 00 00 00 ING OF  ........   ;
5633 00 00 00 00 00 00 
5939 0A 
563A 0D 0A 2A 2A 2A 2A 2A 2A 2A                      ..*******          ;
5643 2A 2A 2A 2A 2A 2A 2A 2A 2A 2A 2A 2A 2A 2A 2A 2A ****************   ;
5653 2A 2A 2A 2A 2A 2A 2A 2A 2A 2A 2A 2A 2A 2A 2A 2A ****************   ;
5663 2A 2A 2A 2A 2A 2A 2A 2A 2A 2A 2A 2A 2A 2A 2A 2A ****************   ;
5673 2A 2A 2A 2A 2A 2A 2A 2A 2A 2A 2A 2A 2A 2A 2A 2A ****************   ;
5683 2A 2A 2A 2A 2A 2A 2A 2A 2A 2A 2A 2A 2A 2A 2A 2A ****************   ;
5693 2A 2A 2A 2A 2A 2A 2A 2A 2A 2A 2A 2A 2A 2A 2A 2A ****************   ;
56A3 2A 2A 2A 2A 2A 2A 2A 2A 2A 2A 2A 2A 2A 2A 2A 2A ****************   ;
56B3 2A 2A 2A 2A 2A 2A 2A 2A 2A 2A 2A 2A 2A 0D 00    *************...   ;
56C2 0D
56C3 0A 0A 0A 00 
55C7 0D 0C 00
56CA 00 00 00 00 00 00 00 00 00 ................   ;
56D3 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 ................   ;
56E3 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 ................   ;
56F3 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 ................   ;
5703 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 ................   ;
5713 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 ................   ;
5723 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 ................   ;
5733 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 ................   ;
5743 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 ................   ;
5753 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 ................   ;
5763 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 ................   ;
5773 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 ................   ;
5783 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 ................   ;
5793 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 ................   ;
57A3 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 ................   ;
57B3 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 ................   ;
57C3 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 ................   ;
57D3 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 ................   ;
57E3 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 ................   ;
57F3 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 ................   ;
5803 00 00 00 00 00 00 00                            .......            ;
->
Routine:
580A  T   B6 54 04       LDA     $5404  ;			function to call
580D H    48             ASLA           ;			double A
580E  T   BE 54 05       LDX     $5405  ;			ponter to string to print
5811   UW 10 8E 55 57    LDY     #$5557 ;			branch table
5815 n    6E B6          JMP     [A,Y]  ;			pass control to branch table function at $5404
->
Routine:
;
;	Play Bell on Printer
;	--------------------
;
5817      B6 E0 04       LDA     $E004  ;			Serial Port Status Register
581A      85 02          BITA    #$02   ;			Check bit 2 (transmit data register)
581C      27 1D          BEQ     $583B  ;			DONE
581E      86 07          LDA     #$07   ;			load with calue 07 (^G = BELL)
5820      B7 E0 05       STA     $E005  ;			write to data register
5823 9    39             RTS            ;			DONE
->
Routine:
5824  T   B6 54 04       LDA     $5404  ;			next function to call
5827      81 0D          CMPA    #$0D   ;			is it 0D?
5829      27 10          BEQ     $583B  ;			DONE
582B  U   B7 55 9C       STA     $559C  ;			next character
582E      86 0D          LDA     #$0D   ;			function 0D
5830  T   B7 54 04       STA     $5404  ;			next function to call
5833 9    39             RTS            ;			DONE
->
5834  U   B6 55 9C       LDA     $559C  ;
5837  T   B7 54 04       STA     $5404  ;
583A 9    39             RTS            ;			DONE
->
Routine:
583B 9    39             RTS            ;			DONE
->
Routine:
583C      8C 00 00       CMPX    #$0000 ;
583F &G   26 47          BNE     $5888  ;
5841  U   F6 55 CC       LDB     $55CC  ;
5844      C0 20          SUBB    #$20   ;
5846  d   C0 64          SUBB    #$64   ;
5848 ,    2C 14          BGE     $585E  ;
584A  V   8E 56 C0       LDX     #$56C0 ;
584D      86 0D          LDA     #$0D   ;
584F      A7 85          STA     B,X    ;
5851 \    5C             INCB           ;
5852      86 00          LDA     #$00   ;
5854      A7 85          STA     B,X    ;
5856  U   BE 55 C7       LDX     $55C7  ;
5859 0    30 0D          LEAX    $0D,X  ;
585B  U   BF 55 C7       STX     $55C7  ;
->
585E      86 03          LDA     #$03   ;
5860      B7 E0 04       STA     $E004  ;
5863      86 11          LDA     #$11   ;
5865      B7 E0 04       STA     $E004  ;
5868  TW  8E 54 57       LDX     #$5457 ;
586B  T   BF 54 05       STX     $5405  ;
->
586E o    6F 80          CLR     ,X+    ;
5870  UN  8C 55 4E       CMPX    #$554E ;
5873 %    25 F9          BCS     $586E  ;
5875      86 00          LDA     #$00   ;
5877  T   B7 54 04       STA     $5404  ;
587A 9    39             RTS            ;
->
587B      86 0C          LDA     #$0C   ;
587D  T   B7 54 04       STA     $5404  ;
5880 9    39             RTS            ;
->
5881 0    30 0D          LEAX    $0D,X  ;
5883  UN  8C 55 4E       CMPX    #$554E ;
5886 ,    2C F3          BGE     $587B  ;
->
5888      A6 84          LDA     ,X     ;
588A '    27 F5          BEQ     $5881  ;
588C  T   BF 54 15       STX     $5415  ;
588F 0    30 01          LEAX    $01,X  ;
5891  T   7F 54 09       CLR     $5409  ;
5894  T   7F 54 0A       CLR     $540A  ;
5897  T   7F 54 0B       CLR     $540B  ;
589A  T   7F 54 0C       CLR     $540C  ;
589D  T   7F 54 0F       CLR     $540F  ;
58A0  T   7F 54 0E       CLR     $540E  ;
58A3  U   B6 55 CB       LDA     $55CB  ;
58A6  T   B7 54 10       STA     $5410  ;
58A9      E6 84          LDB     ,X     ;
58AB      1F 98          TFR     B,A    ;
58AD      84 03          ANDA    #$03   ;
58AF      A7 84          STA     ,X     ;
58B1 X    58             ASLB           ;
58B2 $    24 03          BCC     $58B7  ;
58B4 |T   7C 54 0A       INC     $540A  ;
->
58B7 X    58             ASLB           ;
58B8 $    24 05          BCC     $58BF  ;
58BA |T   7C 54 0E       INC     $540E  ;
58BD      20 18          BRA     $58D7  ;
->
58BF X    58             ASLB           ;
58C0 $    24 03          BCC     $58C5  ;
58C2 |T   7C 54 0B       INC     $540B  ;
->
58C5 X    58             ASLB           ;
58C6 $    24 03          BCC     $58CB  ;
58C8 |T   7C 54 0F       INC     $540F  ;
->
58CB X    58             ASLB           ;
58CC $    24 03          BCC     $58D1  ;
58CE |T   7C 54 0C       INC     $540C  ;
->
58D1 X    58             ASLB           ;
58D2 $    24 03          BCC     $58D7  ;
58D4 |T   7C 54 09       INC     $5409  ;
->
58D7   V  10 8E 56 CD    LDY     #$56CD ;
58DB      C6 0C          LDB     #$0C   ;
->
58DD      A6 80          LDA     ,X+    ;
58DF      A7 A0          STA     ,Y+    ;
58E1 Z    5A             DECB           ;
58E2 &    26 F9          BNE     $58DD  ;
58E4      86 01          LDA     #$01   ;
58E6  V   8E 56 CA       LDX     #$56CA ;
58E9      A7 84          STA     ,X     ;
58EB  T   BF 54 05       STX     $5405  ;
58EE  T   B7 54 04       STA     $5404  ;
58F1      C6 08          LDB     #$08   ;
58F3  V+  8E 56 2B       LDX     #$562B ;
58F6   V  10 8E 56 CE    LDY     #$56CE ;
->
58FA      A6 A0          LDA     ,Y+    ;
58FC '    27 05          BEQ     $5903  ;
58FE      A7 80          STA     ,X+    ;
5900 Z    5A             DECB           ;
5901 &    26 F7          BNE     $58FA  ;
->
5903  .   86 2E          LDA     #$2E   ;
5905      A7 80          STA     ,X+    ;
5907   V  10 8E 56 D6    LDY     #$56D6 ;
590B      C6 03          LDB     #$03   ;
->
590D      A6 A0          LDA     ,Y+    ;
590F '    27 05          BEQ     $5916  ;
5911      A7 80          STA     ,X+    ;
5913 Z    5A             DECB           ;
5914 &    26 F7          BNE     $590D  ;
->
5916      86 0A          LDA     #$0A   ;
5918      A7 80          STA     ,X+    ;
591A O    4F             CLRA           ;
591B      A7 84          STA     ,X     ;
591D 9    39             RTS            ;
->
Routine:
591E      BD D4 06       JSR     $D406  ;			FLEX FMS Call
5921 '    27 11          BEQ     $5934  ;			no error so move on
5923      86 00          LDA     #$00   ;			next call function 0
5925  T   B7 54 04       STA     $5404  ;			store the fact
5928  TW  8E 54 57       LDX     #$5457 ;
592B  T   BF 54 05       STX     $5405  ;
592E  T   BE 54 15       LDX     $5415  ;
5931      A7 84          STA     ,X     ;
5933 9    39             RTS            ;			DONE
->
5934 m    6D 88 17       TST     $17,X  ;			FCB File Sector Map Indicator (non-zero means random access file)
5937 &    26 06          BNE     $593F  ;			no compression needed
5939      A6 0F          LDA     $0F,X  ;			FCB File attributes
593B      85 02          BITA    #$02   ;		?? dunno - this appears to be an undocumented flag
593D '    27 05          BEQ     $5944  ;			move on
->
593F      86 FF          LDA     #$FF   ;			no space compression
5941      A7 88 3B       STA     $3B,X  ;			FCB Space Compresison Flag
->
5944  T   BE 54 15       LDX     $5415  ;		?? printer work space ??
5947      86 02          LDA     #$02   ;
5949      A7 84          STA     ,X     ;
594B   "  16 01 22       LBRA    $5A70  ;
->
Routine:
594E      B6 E0 04       LDA     $E004  ;
5951      85 02          BITA    #$02   ;
5953 '4   27 34          BEQ     $5989  ;
5955 }T   7D 54 0D       TST     $540D  ;
5958 '    27 08          BEQ     $5962  ;
595A  T   B6 54 0D       LDA     $540D  ;
595D  T   7F 54 0D       CLR     $540D  ;
5960      20 05          BRA     $5967  ;
->
5962      BD D4 06       JSR     $D406  ;			FLEX FMS Call
5965 &?   26 3F          BNE     $59A6  ;
->
5967 }T   7D 54 0E       TST     $540E  ;
596A &    26 06          BNE     $5972  ;
596C  _   81 5F          CMPA    #$5F   ;
596E &    26 02          BNE     $5972  ;
5970  #   86 23          LDA     #$23   ;
->
5972      B7 E0 05       STA     $E005  ;
5975 }T   7D 54 0E       TST     $540E  ;
5978 &    26 0F          BNE     $5989  ;
597A      81 0D          CMPA    #$0D   ;
597C &    26 0C          BNE     $598A  ;
597E  T   B6 54 12       LDA     $5412  ;
5981  T   B7 54 11       STA     $5411  ;
5984      86 06          LDA     #$06   ;
5986  T   B7 54 04       STA     $5404  ;
->
5989 9    39             RTS            ;
->
598A zT   7A 54 11       DEC     $5411  ;
598D &    26 FA          BNE     $5989  ;
598F  T   B6 54 12       LDA     $5412  ;
5992  T   B7 54 11       STA     $5411  ;
5995      BD D4 06       JSR     $D406  ;			FLEX FMS Call
5998 &    26 0C          BNE     $59A6  ;
599A  T   B7 54 0D       STA     $540D  ;
599D      81 0D          CMPA    #$0D   ;
599F '    27 E8          BEQ     $5989  ;
59A1  T   BE 54 13       LDX     $5413  ;
59A4  "   20 22          BRA     $59C8  ;
->
59A6      86 04          LDA     #$04   ;
59A8      A7 84          STA     ,X     ;
59AA      16 00 C3       LBRA    $5A70  ;
->
Routine:
59AD      86 03          LDA     #$03   ;
59AF  T   B7 54 04       STA     $5404  ;
59B2      BD D4 06       JSR     $D406  ;			FLEX FMS Call
59B5 &    26 EF          BNE     $59A6  ;
59B7      81 0A          CMPA    #$0A   ;
59B9 '    27 03          BEQ     $59BE  ;
59BB  T   B7 54 0D       STA     $540D  ;
->
59BE  T   BE 54 13       LDX     $5413  ;
59C1 0    30 1F          LEAX    $-01,X ;
59C3 }T   7D 54 09       TST     $5409  ;
59C6 '    27 02          BEQ     $59CA  ;
->
59C8 0    30 1F          LEAX    $-01,X ;
->
59CA  T   BF 54 05       STX     $5405  ;
59CD      86 13          LDA     #$13   ;
59CF  T   B7 54 04       STA     $5404  ;
59D2 9    39             RTS            ;
->
Routine:
59D3 }T   7D 54 0A       TST     $540A  ;
59D6  '   10 27 00 96    LBEQ    $5A70  ;
59DA      86 11          LDA     #$11   ;
59DC  T   B7 54 04       STA     $5404  ;
59DF 9    39             RTS            ;
->
Routine:
59E0  U   B6 55 CC       LDA     $55CC  ;
59E3  U   8E 55 DF       LDX     #$55DF ;
59E6 }T   7D 54 0C       TST     $540C  ;
59E9 '    27 08          BEQ     $59F3  ;
59EB  U   B6 55 CE       LDA     $55CE  ;
59EE  U   8E 55 D1       LDX     #$55D1 ;
59F1      20 0B          BRA     $59FE  ;
->
59F3 }T   7D 54 0B       TST     $540B  ;
59F6 '    27 06          BEQ     $59FE  ;
59F8  U   B6 55 CD       LDA     $55CD  ;
59FB  U   8E 55 D8       LDX     #$55D8 ;
->
59FE  T   B7 54 12       STA     $5412  ;
5A01  T   B7 54 11       STA     $5411  ;
5A04  T   BF 54 13       STX     $5413  ;
5A07  T   BF 54 05       STX     $5405  ;
5A0A  T   7F 54 0D       CLR     $540D  ;
5A0D      86 13          LDA     #$13   ;
5A0F  T   B7 54 04       STA     $5404  ;
5A12 9    39             RTS            ;
->
Routine:
5A13 }T   7D 54 0F       TST     $540F  ;
5A16 '    27 11          BEQ     $5A29  ;
5A18      81 0A          CMPA    #$0A   ;
5A1A &    26 0D          BNE     $5A29  ;
5A1C zT   7A 54 10       DEC     $5410  ;
5A1F .    2E 08          BGT     $5A29  ;
5A21  U   B6 55 CB       LDA     $55CB  ;
5A24  T   B7 54 10       STA     $5410  ;
5A27      86 0C          LDA     #$0C   ;
->
5A29 9    39             RTS            ;
->
Routine:
5A2A }T   7D 54 0A       TST     $540A  ;
5A2D 'A   27 41          BEQ     $5A70  ;
5A2F      86 04          LDA     #$04   ;
5A31  T   B7 54 04       STA     $5404  ;
5A34  V   8E 56 CA       LDX     #$56CA ;
5A37  T   BF 54 05       STX     $5405  ;
5A3A 9    39             RTS            ;
->
5A3B      BD D4 06       JSR     $D406  ;			FLEX FMS Call
5A3E      A6 0C          LDA     $0C,X  ;
5A40  P   81 50          CMPA    #$50   ;
5A42 &    26 0F          BNE     $5A53  ;
5A44      EC 0D          LDD     $0D,X  ;
5A46   RT 10 83 52 54    CMPD    #$5254 ;
5A4A &    26 07          BNE     $5A53  ;
5A4C      86 0C          LDA     #$0C   ;
5A4E      A7 84          STA     ,X     ;
5A50      BD D4 06       JSR     $D406  ;			FLEX FMS Call
->
5A53   T  10 BE 54 15    LDY     $5415  ;
5A57  Z   BD 5A F4       JSR     $5AF4  ;
5A5A      20 14          BRA     $5A70  ;
->
Routine:
5A5C      B6 E0 04       LDA     $E004  ;
5A5F      85 02          BITA    #$02   ;
5A61 '    27 0C          BEQ     $5A6F  ;
5A63      A6 80          LDA     ,X+    ;
5A65 '    27 09          BEQ     $5A70  ;
5A67      8D AA          BSR     $5A13  ;
5A69      B7 E0 05       STA     $E005  ;
5A6C  T   BF 54 05       STX     $5405  ;
->
5A6F 9    39             RTS            ;			DONE
->
5A70  T   F6 54 04       LDB     $5404  ;			next function from function table
5A73   U  10 8E 55 85    LDY     #$5585 ;		??
5A77      A6 A5          LDA     B,Y    ;			load from the table
5A79  T   B7 54 04       STA     $5404  ;			store as next function to call
5A7C X    58             ASLB           ;			double it
5A7D   U  10 8E 55 9D    LDY     #$559D ;			pointer into printer parameter table
5A81      AE A5          LDX     B,Y    ;			turn into an address
5A83  T   BF 54 05       STX     $5405  ;			store that address
5A86 9    39             RTS            ;			DONE
->
Routine:
5A87   TW 10 8E 54 57    LDY     #$5457 ;
5A8B  T   B6 54 04       LDA     $5404  ;
5A8E      81 0D          CMPA    #$0D   ;
5A90 &    26 05          BNE     $5A97  ;
5A92  U   7F 55 9C       CLR     $559C  ;
5A95      20 07          BRA     $5A9E  ;
->
5A97      81 0C          CMPA    #$0C   ;
5A99 &    26 03          BNE     $5A9E  ;
5A9B  T   7F 54 04       CLR     $5404  ;
->
5A9E      A6 A4          LDA     ,Y     ;
5AA0 '    27 0B          BEQ     $5AAD  ;
5AA2 1-   31 2D          LEAY    $0D,Y  ;
5AA4   UN 10 8C 55 4E    CMPY    #$554E ;
5AA8 %    25 F4          BCS     $5A9E  ;
5AAA      1A 01          ORCC    #$01   ;
5AAC 9    39             RTS            ;
->
5AAD      86 01          LDA     #$01   ;
5AAF      A7 A0          STA     ,Y+    ;
5AB1      C6 0C          LDB     #$0C   ;
->
5AB3      A6 80          LDA     ,X+    ;
5AB5      A7 A0          STA     ,Y+    ;
5AB7 Z    5A             DECB           ;
5AB8 &    26 F9          BNE     $5AB3  ;
5ABA      1C FE          ANDCC   #$FE   ;
5ABC 9    39             RTS            ;
->
Routine:
5ABD   TW 10 8E 54 57    LDY     #$5457 ;
5AC1      20 0D          BRA     $5AD0  ;
->
5AC3 50   35 30          PULS    Y,X    ;
->
5AC5 1-   31 2D          LEAY    $0D,Y  ;
5AC7   UN 10 8C 55 4E    CMPY    #$554E ;
5ACB %    25 03          BCS     $5AD0  ;
5ACD      1A 01          ORCC    #$01   ;
5ACF 9    39             RTS            ;
->
5AD0      A6 A4          LDA     ,Y     ;
5AD2 '    27 F1          BEQ     $5AC5  ;
5AD4 40   34 30          PSHS    Y,X    ;
5AD6      C6 0C          LDB     #$0C   ;
5AD8 1!   31 21          LEAY    $01,Y  ;
5ADA      A6 A0          LDA     ,Y+    ;
5ADC      84 03          ANDA    #$03   ;
5ADE      A1 80          CMPA    ,X+    ;
5AE0 &    26 E1          BNE     $5AC3  ;
5AE2 Z    5A             DECB           ;
->
5AE3      A6 80          LDA     ,X+    ;
5AE5      A1 A0          CMPA    ,Y+    ;
5AE7 &    26 DA          BNE     $5AC3  ;
5AE9 Z    5A             DECB           ;
5AEA &    26 F7          BNE     $5AE3  ;
5AEC 50   35 30          PULS    Y,X    ;
5AEE      A6 A4          LDA     ,Y     ;
5AF0      81 01          CMPA    #$01   ;
5AF2 &    26 15          BNE     $5B09  ;
->
Routine:
5AF4  -   A6 2D          LDA     $0D,Y  ;
5AF6      A7 A0          STA     ,Y+    ;
5AF8   UA 10 8C 55 41    CMPY    #$5541 ;
5AFC &    26 F6          BNE     $5AF4  ;
->
5AFE o    6F A0          CLR     ,Y+    ;
5B00   UN 10 8C 55 4E    CMPY    #$554E ;
5B04 &    26 F8          BNE     $5AFE  ;
5B06      1C FE          ANDCC   #$FE   ;
5B08 9    39             RTS            ;
->
5B09      86 04          LDA     #$04   ;
5B0B  T   B7 54 04       STA     $5404  ;
5B0E  V   8E 56 CA       LDX     #$56CA ;
5B11  T   BF 54 05       STX     $5405  ;
5B14      A7 84          STA     ,X     ;
5B16   "  16 FF 22       LBRA    $5A3B  ;
->
;
; FCB
;
5B19 	  00							;			0 Function code
5B1A	  00							;			1 Error ststus byte
5B1B	  00							;			2 Activity status
5B1C	  00							;			3 Drive number
5B1D	  00 00 00 00 00 00 00 00		; 			4-11 Filename
5B25      00 00 00						;			12-14 File extension
5B28      00							;			15 File attribute
5B29      00							;			16 Reserved for system use
5B2A      00							;			17 Track of start of file
5B2B      00                            ;			18 Sector of start file
5B2C      00							;			19 Track of end of file
5B2D      00							;			20 Sector of end of file
5B2E      00 00							;			21-22 File size
5B30      00							;			23 File sector map indicator
5B31      00							;			24 Reserved for system use
5B32      00 00 00						;			25-27 File creation date
5B35      00 00							;			28-29 FCB list pointer
5B37      00 00							;			30-31 ($1E-$1F) Current position (track / sector)
5B39      00 00							;			32-33 Current record number
5B3B      00                            ;			34 Data index
5B3C      00                            ;			35 Random index
5B3D      00 00 00 00 00 00 00 00 00 00 00 ;		36-46 Name work buffer
5B48      00 00 00						;			47-49 Current directory address
5B4B      00 00 00						;			50-52 First deleted directory pointer
5B4E      00 00 00 00 00 00 			;			53-59 (next 3 lines) Scratch area
5B54      00 							;			59 Space compression flag (and scratch)
5B55      00 00 00 00 					;		    60-63 Scratch area
5B59 - 5C58								;			64-319 Sector buffer (255 bytes)
	; 5B59  		Next track
	; 5B5A  		Next sector
	; 5B5B - 5B5C	File logical record number
	; 5B5D->5C58	Sector data

->
->		SNIP
->
C080 - C0FF : FLEX Line Buffer
->
C5E9 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 ................   ;
C5F9 00 00 00 00 00 00 00 20 05 83 2E 82 2E 80 20 21 ....... ...... !   ;
C609 4F 50 53 59 53 20 2D 20 56 65 72 73 69 6F 6E 20 OPSYS - Version    ;
C619 33 2E 32 2E 30 20 2D 20 4A 75 6C 20 31 39 38 33 3.2.0 - Jul 1983   ;
C629 04                                              .                  ;
->
C62A  9   86 39          LDA     #$39   ;
C62C   5  B7 D1 35       STA     $D135  ;
C62F   /  FC D1 2F       LDD     $D12F  ;			FLEX STATUS vector
C632   O  FD CD 4F       STD     $CD4F  ;			FLEX STAT routine addres
C635   1  FC D1 31       LDD     $D131  ;			FLEX OUTCHAR vector
C638      FD CD 10       STD     $CD10  ;			FLEX OUTCH routine address
C63B      FD CD 13       STD     $CD13  ;			FLEX OUTCH2 routine address
C63E   3  FC D1 33       LDD     $D133  ;			FLEX INCHAR vector
C641      FD CD 0A       STD     $CD0A  ;			FLEX INCH routine address
C644      FD CD 0D       STD     $CD0D  ;			FLEX INCH2 routine address
C647      7F CC 0F       CLR     $CC0F  ;			FLEX system date registers
C64A      7F CC 0E       CLR     $CC0E  ;			FLEX system date registers
C64D      7F CC 10       CLR     $CC10  ;			FLEX system date registers
C650   @  8E C8 40       LDX     #$C840 ;			FCB address
C653      BD DE 0F       JSR     $DE0F  ;			FLEX Check drive ready
C656      86 01          LDA     #$01   ;			Function code (open file for read)
C658      A7 84          STA     ,X     ;			store as the FMS function number
C65A      BD D4 06       JSR     $D406  ;			FLEX FMS Call		(open STARTUP.TXT for read)
C65D '    27 09          BEQ     $C668  ;			load the first line of startup.txt into line buffer and warmstart
C65F      A6 01          LDA     $01,X  ;			error status byte
C661      81 04          CMPA    #$04   ;			was it error 4? (file not found)
C663 &%   26 25          BNE     $C68A  ;			cannot read from the file so print error and warm-start
C665 ~    7E CD 03       JMP     $CD03  ;			FLEX (WARMS) warm start entry point
->
;
; process STARTUP.TXT
;
C668      10 8E C0 80    LDY     #$C080 ;			FLEX line buffer
C66C      10 BF CC 14    STY     $CC14  ;			FLEX line buffer pointer
C670      C6 80          LDB     #$80   ;			max number of characters on the line to read
->
C672      BD D4 06       JSR     $D406  ;			FLEX FMS Call (read next character into A)
C675 &    26 13          BNE     $C68A  ;			error, print a message and warm-start
C677 Z    5A             DECB           ;			got one more character so count down
C678 '    27 10          BEQ     $C68A  ;			zero so end of readline but not end of line (print error and warm-start)
C67A      A7 A0          STA     ,Y+    ;			store the character we read at Y (line buffer)
C67C      81 0D          CMPA    #$0D   ;			was it an end of line character?
C67E &    26 F2          BNE     $C672  ;			no, so read more from the file
C680      86 04          LDA     #$04   ;			FMS function 4 (close file)
C682      A7 84          STA     ,X     ;			store in the FCB, next instruction closes the file
C684      BD D4 06       JSR     $D406  ;			FLEX FMS Call
C687 ~    7E CD 06       JMP     $CD06  ;			FLEX (RENTER) DOS main loop re-entry point
->
C68A      8E C6 93       LDX     #$C693 ;			"CANNOT RUN STARTUP FILE" error message
C68D      BD CD 1E       JSR     $CD1E  ;			FLEX (PSTRNG) Print string
C690 ~    7E CD 03       JMP     $CD03  ;			FLEX (WARMS) warm start entry point
->
C693 0F 02 43 41 4E 4E 4F 54 20 52 55 4E 20 53 54 41 ..CANNOT RUN STA   ;
C6A3 52 54 55 50 20 46 49 4C 45 0E 04 00 00 00 00 00 RTUP FILE.......   ;
C6B3 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 ................   ;
C6C3 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 ................   ;
C6D3 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 ................   ;
C6E3 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 ................   ;
C6F3 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 ................   ;
C703 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 ................   ;
C713 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 ................   ;
C723 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 ................   ;
C733 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 ................   ;
C743 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 ................   ;
C753 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 ................   ;
C763 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 ................   ;
C773 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 ................   ;
C783 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 ................   ;
C793 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 ................   ;
C7A3 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 ................   ;
C7B3 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 ................   ;
C7C3 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 ................   ;
C7D3 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 ................   ;
C7E3 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 ................   ;
C7F3 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 ................   ;
C803 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 ................   ;
C813 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 ................   ;
C823 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 ................   ;
C833 00 00 00 00 00 00 00 00 00 00 00 00 00 
->
;
;	FLEX command line FCB
;	---------------------
;	This address is used as a FCB during the FLEX startup proceure
;
C840 FF 00 00 00
->
C844 53 54 41 52 54 55 50 00 54 58 54 00          STARTUP.TXT.      ;
->
Routine:
;
;	NETWORK CONTROLLER BOOT
;	-----------------------
;
C850  H   8E 48 00       LDX     #$4800 ;			$4800 is the top of memory
C853   +  BF CC 2B       STX     $CC2B  ;			FLEX Memory End!
C856   3  7F CC 33       CLR     $CC33  ;			FLEX CPU type = 0 (Unknown)
C859 ~    7E CD 00       JMP     $CD00  ;			FLEX cold start entry point!
->
C85C 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 ................   ;
C86C 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 ................   ;
C87C 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 ................   ;
C88C 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 ................   ;
C89C 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 ................   ;
C8AC 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 ................   ;
C8BC 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 ................   ;
C8CC 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 ................   ;
C8DC 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 ................   ;
C8EC 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 ................   ;
C8FC 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 ................   ;
C90C 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 ................   ;
C91C 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 ................   ;
C92C 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 ................   ;
C93C 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 ................   ;
C94C 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 ................   ;
C95C 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 ................   ;
C96C 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 ................   ;
C97C 00 00 00 00 BE D4 0B 30 88 44 10 8E C8 80 C6 FC .......0.D......   ;
C98C BD 4C 1D BD D2 6F 24 22 C1 18 26 2C 8D 2D 25 28 .L...o$"..&,.-%(   ;
C99C BE D4 0B 6F 88 40 6F 88 41 EC 88 20 83 00 01 ED ...o.@o.A.. ....   ;
C9AC 88 42 6A 02 EC 88 13 ED 88 1E 31 88 44 8E C8 80 .Bj.......1.D...   ;
C9BC C6 FC BD 4C 1D 7E D7 DB 1A 01 39 FC D4 0F B3 D4 ...L.~....9.....   ;
C9CC 0B 83 00 40 BE D4 0F 10 AE 84 A6 02 BE D4 0B A7 ...@............   ;
C9DC 88 37 E7 88 3A EC 88 1E ED 88 38 10 AF 88 35 BE .7..:.....8...5.   ;
C9EC D4 0B EC 88 20 C3 00 02 A3 88 15 34 06 BD DA 68 .... ......4...h   ;
C9FC 25 29 BD DC 8A 25 24 EC 88 42 ED 88 20 BD D8 C7 %)...%$..B.. ...   ;
CA0C 25 19 35 06 83 00 01 27 04 34 06 20 F0 BD D2 09 %.5....'.4. ....   ;
CA1C 25 08 BD DA C7 25 03 BD DA A5 39 35 90 00 00 00 %....%....95....   ;
CA2C 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 ................   ;
CA3C 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 ................   ;
CA4C 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 ................   ;
CA5C 00 00 00 00 01 00 06 06 0B 0C 04 03 09 09 0E 01 ................   ;
CA6C 02 07 07 0D 0C 04 05 0A 0A 02 0F 08 03 0E 08 05 ................   ;
CA7C 0D 0B 00 17 02 1C 08 10 0E 15 05 1A 0B 13 03 18 ................   ;
CA8C 09 1D 00 11 06 16 0C 1B 04 14 0A 19 01 1E 07 12 ................   ;
CA9C 0D 00                                           ..                 ;
->
CA9E   $  BD DE 24       JSR     $DE24  ;
CAA1 '    27 03          BEQ     $CAA6  ;
CAA3   [  BD D5 5B       JSR     $D55B  ;
->
CAA6      17 00 9F       LBSR    $CB48  ;
CAA9 &A   26 41          BNE     $CAEC  ;
CAAB 4`   34 60          PSHS    U,Y    ;
CAAD      EC 88 1E       LDD     $1E,X  ;
->
CAB0    ` 10 8E CA 60    LDY     #$CA60 ;
CAB4      C1 10          CMPB    #$10   ;
CAB6 %    25 05          BCS     $CABD  ;
CAB8 1    31 A8 1F       LEAY    $1F,Y  ;
CABB      C0 0F          SUBB    #$0F   ;
->
CABD      C0 01          SUBB    #$01   ;
CABF      C1 0F          CMPB    #$0F   ;
CAC1 "$   22 24          BHI     $CAE7  ;
CAC3 X    58             ASLB           ;
CAC4 1    31 A5          LEAY    B,Y    ;
CAC6  !   A6 21          LDA     $01,Y  ;
CAC8 5    35 20          PULS    Y      ;
CACA 1%   31 25          LEAY    $05,Y  ;
CACC      E6 A6          LDB     A,Y    ;
CACE 4    34 04          PSHS    B      ;
CAD0 _    5F             CLRB           ;
CAD1   >  10 AE 3E       LDY     $-02,Y ;
CAD4 1    31 AB          LEAY    D,Y    ;
CAD6 0 @  30 88 40       LEAX    $40,X  ;
CAD9      C6 80          LDB     #$80   ;
->
CADB      EE A1          LDU     ,Y++   ;
CADD      EF 81          STU     ,X++   ;
CADF Z    5A             DECB           ;
CAE0 &    26 F9          BNE     $CADB  ;
CAE2 5D   35 44          PULS    U,B    ;
CAE4      C5 9C          BITB    #$9C   ;
->
CAE6 9    39             RTS            ;
->
CAE7      CA 10          ORB     #$10   ;
CAE9      1A 01          ORCC    #$01   ;
CAEB 9    39             RTS            ;
->
CAEC   C  BD DF 43       JSR     $DF43  ;
CAEF %    25 F5          BCS     $CAE6  ;
CAF1      10 8E CB 7F    LDY     #$CB7F ;
CAF5 }    7D CB A7       TST     $CBA7  ;
CAF8 &    26 05          BNE     $CAFF  ;
CAFA |    7C CB A7       INC     $CBA7  ;
CAFD      20 06          BRA     $CB05  ;
->
CAFF      7F CB A7       CLR     $CBA7  ;
CB02 1    31 A8 14       LEAY    $14,Y  ;
->
CB05      E6 88 1E       LDB     $1E,X  ;
CB08      A6 03          LDA     $03,X  ;
CB0A      ED A4          STD     ,Y     ;
CB0C      EC 88 1E       LDD     $1E,X  ;
CB0F o"   6F 22          CLR     $02,Y  ;
CB11 l"   6C 22          INC     $02,Y  ;
CB13      C1 10          CMPB    #$10   ;
CB15 %    25 02          BCS     $CB19  ;
CB17 l"   6C 22          INC     $02,Y  ;
->
CB19 4p   34 70          PSHS    U,Y,X  ;
CB1B 3%   33 25          LEAU    $05,Y  ;
CB1D  #   AE 23          LDX     $03,Y  ;
CB1F    ` 10 8E CA 60    LDY     #$CA60 ;
CB23 4    34 06          PSHS    D      ;
CB25      C1 10          CMPB    #$10   ;
CB27 %    25 03          BCS     $CB2C  ;
CB29 1    31 A8 1F       LEAY    $1F,Y  ;
->
CB2C      A6 E4          LDA     ,S     ;
CB2E      E6 A4          LDB     ,Y     ;
CB30 '    27 11          BEQ     $CB43  ;
CB32 4    34 10          PSHS    X      ;
CB34   0  BD DE 30       JSR     $DE30  ;			FLEX: Read (low level Disk Driver)
CB37      E7 C0          STB     ,U+    ;
CB39 1"   31 22          LEAY    $02,Y  ;
CB3B 5    35 10          PULS    X      ;
CB3D 0    30 89 01 00    LEAX    $0100,X;
CB41      20 E9          BRA     $CB2C  ;
->
CB43 5    35 16          PULS    X,D    ;
CB45   h  16 FF 68       LBRA    $CAB0  ;
->
Routine:
CB48      A6 03          LDA     $03,X  ;
CB4A      E6 88 1E       LDB     $1E,X  ;
CB4D      10 8E CB 7F    LDY     #$CB7F ;
CB51      10 A3 A4       CMPD    ,Y     ;
CB54 '    27 08          BEQ     $CB5E  ;
CB56 1    31 A8 14       LEAY    $14,Y  ;
CB59      10 A3 A4       CMPD    ,Y     ;
CB5C &    26 0F          BNE     $CB6D  ;
->
CB5E      E6 88 1F       LDB     $1F,X  ;
CB61      C1 10          CMPB    #$10   ;
CB63 $    24 04          BCC     $CB69  ;
CB65      C6 01          LDB     #$01   ;
CB67      20 02          BRA     $CB6B  ;
->
CB69      C6 02          LDB     #$02   ;
->
CB6B  "   E1 22          CMPB    $02,Y  ;
->
CB6D 9    39             RTS            ;
->
CB6E      8D D8          BSR     $CB48  ;
CB70 &    26 04          BNE     $CB76  ;
CB72      86 05          LDA     #$05   ;
CB74      A7 A4          STA     ,Y     ;
->
CB76      EC 88 1E       LDD     $1E,X  ;
CB79 0 @  30 88 40       LEAX    $40,X  ;
CB7C   @  16 13 40       LBRA    $DEBF  ;
->
CB7F 05 00 00 01 00 00 00 00 00 00 00 00 00 00 00 00 ................   ;
CB8F 00 00 00 00 05 00 00 10 00 00 00 00 00 00 00 00 ................   ;
CB9F 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 ................   ;
CBAF 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 ................   ;
CBBF 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 ................   ;
CBCF 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 ................   ;
CBDF 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 ................   ;
CBEF 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 ................   ;
CBFF 00 
->
CC00 08				; TTYSET Backspace character
CC01 18 			; TTYSET Delete character
CC02 2A 			; TTYSET End of line character
CC03 00 			; TTYSET Depth count
CC04 00 			; TTYSET Width count
CC05 00 			; TTYSET NULL count
CC06 00 			; TTYSET TAB character
CC07 08 			; TTYSET Backspace echo character
CC08 00 			; TTYSET Eject count
CC09 FF 			; TTYSET Pause control (FF=Pause Disabled, 00=Pause Enabled)
CC0A 1B 			; TTYSET Escape character
CC0B 00 			; FLEX System drive number
CC0C 00 			; FLEX Working drive number
CC0D 00 			; FLEX SYSTEM SCRATCH
CC0E 00 00 00 		; FLEX System date registers
CC11 00 			; FLEX Last terminator
CC12 00 00 			; FLEX User command table address
CC14 00 00 			; FLEX Line buffer pointer
CC16 00 00 			; FLEX Escape return register
CC18 00 			; FLEX Current character
CC19 00 			; FLEX Previous character
CC1A 00 			; FLEX Current line number
CC1B 00 00 			; FLEX Loader address offset
CC1D 00 			; FLEX Transfer flag
CC1E 00 00 			; FLEX Transfer address
CC20 00 			; FLEX Error type
CC21 00 			; FLEX Special I/O flag
CC22 00 			; FLEX Output switch
CC23 00 			; FLEX Input switch
CC24 00 00 			; FLEX File output address
CC26 00 00 			; FLEX File input address
CC28 00 			; FLEX Command flag
CC29 00 			; FLEX Current output column
CC2A 00 			; FLEX SYSTEM SCRATCH
CC2B 00 00 			; FLEX Memnory end
CC2D 00 00			; FLEX Error name vector
CC2F 01 			; FLEX File input echo flag
CC30 00 00 00 		; FLEX SYSTEM SCRATCH
CC33 00 			; FLEX CPU flag (0 = unknown)
CC34 00 
CC35 00 00 			; FLEX Reserved printer area pointer
CC37 00 00 			; FLEX Printer area length
CC39 00 00 00 
CC3C 00 00 00		; FLEX $CC3C-$CCBF: system constants
CC3F 00 00 00 00 
CC43 00 00 			; used to store retun address on DOCMND
CC45 00 00			; used to store register S on DOCMND 
CC47 00 00 60 00 00 00 00 
->
;
;	DOS built in command table
;	--------------------------
;
CC4E 47 45 54 00 GET.			; GET -> D06D		(GET <filespec>[,<filelist>])
CC52 D0 6D 						; 
CC54 4D 4F 4E 00 MON. 			; MON -> D107		(MON (jump into monitor))
CC58 D1 07 						;
CC5A 00 						; end of string table
->
CC5B 27 10 03 E8				;
CC5F 00 64 00 0A 00 00 00 00 00 00 00 00 00 00 00 00 .d..............   ;
CC6F 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 ................   ;
CC7F 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 ................   ;
CC8F 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 ................   ;
CC9F 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 ................   ;
CCAF 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 ................   ;
CCBF 00 
->
;		START OF SUPERSEDED PRINTER SPACE
->
CCC0      39             RTS           ; superseded PINIT
->
CCC1 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 
->
CCD8      39             RTS           ; superseded PCHK
->
CCD9 00 00 00 00 00 00 00 00 00 00 00 
->
CCE4      39             RTS           ; superseded POUT
->
CCE5 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 
->
;		END OF SUPERSEDED PRINTER SPACE
->
CCF8 01 00 00 00 00 00 00 00			; 			FLEX system scratch area                                              .                  ;
->
CD00 ~ W  7E CD 57       JMP     $CD57  ;			FLEX (COLDS) cold start entry point
->
CD03 ~ g  7E CD 67       JMP     $CD67  ;			FLEX (WARMS) warm start entry point
->
CD06 ~    7E CD 96       JMP     $CD96  ;			FLEX (RENTER) DOS main loop re-entry point
->
CD09      7E CD 09       JMP     $CD09	;			FLEX (INCH)	Input character
->
CD0C      7E CD 0C       JMP     $CD0C	;			FLEX (INCH2) Input character
->
CD0F      7E CD 0F       JMP     $CD0F	;			FLEX (OUTCH) Output character
->
CD12      7E CD 12       JMP     $CD12	;			FLEX (OUTCH2) Output character
->
CD15      7E 48 05       JMP     $4805	;			FLEX (GETCHR) Get character
->
CD18      7E 48 27       JMP     $4827	;			FLEX (PUTCHR) Put character
->
CD1B      7E 48 3B       JMP     $483B	;			FLEX (INBUFF) Input into line buffer
->
CD1E ~H_  7E 48 5F       JMP     $485F  ;			FLEX (PSTRNG) Print string
->
CD21      7E CE 0A       JMP     $CE0A	;			FLEX (CLASS) Character classifier
->
CD24      7E 48 81       JMP     $4881	;			FLEX (PCRLF) Print CR/LF
->
CD27      7E CE 2B       JMP     $CE2B	;			FLEX (NXTCH) Get next buffer character
->
CD2A      7E CD C9       JMP     $CDC9	;			FLEX (RSTRIO) Restore I/O vector
->
CD2D ~ S  7E CE 53       JMP     $CE53  ;			FLEX (GETFIL) Get file specification
->
CD30      7E CF C0       JMP     $CFC0  ;			FLEX (LOAD) File loader
->
CD33 ~    7E CF 08       JMP     $CF08  ;			FLEX (SETEXT) Set file extension
->
CD36      7E D1 05       JMP     $D105	;			FLEX (ADDBX) Add B to X
->
CD39      7E 48 A6       JMP     $48A6	;			FLEX (OUTDEC) Output decimal number
->
CD3C      7E 48 C4       JMP     $48C4	;			FLEX (OUTHEX) Output hexidecimal number
->
CD3F      7E 49 03       JMP     $4903	;			FLEX (RPTERR) Report error
->
CD42      7E CF 4C       JMP     $CF4C	;			FLEX (GETHEX) Get hexadecimal number
->
CD45      7E 48 DA       JMP     $48DA	;			FLEX (OUTADR) Output hexadecimal address
->
CD48      7E CF 92       JMP     $CF92	;			FLEX (INDEX) Input decimal number
->
CD4B ~    7E D0 E5       JMP     $D0E5  ;			FLEX (DOCMND) Call DOS as a subroutine
->
CD4E      7E CD 4E       JMP     $CD4E  ;			FLEX (STAT) Check terminal input status
->
CD51      7E CD E4       JMP     $CDE4  ;			NO-OP
->
CD54      7E CD E4       JMP     $CDE4  ;			NO-OP
->
;
;	FLEX (COLDS) cold start entry point
;	------------
;
;
CD57      10 CE C0 80    LDS     #$C080 ;
CD5B      7F CC 11       CLR     $CC11  ;
CD5E      BD D4 00       JSR     $D400  ;			FLEX FMS Initialization
CD61   (  7F CC 28       CLR     $CC28  ;
CD64   5  BD D1 35       JSR     $D135  ;
->
;
;	FLEX (WARMS) warm start entry point
;	------------
;
CD67      10 CE C0 80    LDS     #$C080 ;		FLEX line buffer (so the stack builds down from FLEX in high-mem)
CD6B      BD DE 18       JSR     $DE18  ;		FLEX Disk Driver initialisation (Warm start)
CD6E      8E CC F8       LDX     #$CCF8 ;	????
CD71   1  BF CC 31       STX     $CC31  ;	scratch space		
CD74   4  7F CC 34       CLR     $CC34  ;	undocumented
CD77   L  7F CC 4C       CLR     $CC4C  ;	system constant
CD7A  M   8D 4D          BSR     $CDC9  ;		FLEX restore I/O vectors
CD7C      B6 CC 11       LDA     $CC11  ;		FLEX last terminator
CD7F      B1 CC 02       CMPA    $CC02  ;		TTYSET end of line
CD82 &    26 05          BNE     $CD89  ;		if we're a re-entered FLEX then exit the re-entry
CD84 |    7C CC 15       INC     $CC15  ;		FLEX line buffer pointer
CD87      20 0D          BRA     $CD96  ;		Enter DOS main loop
->
CD89 } (  7D CC 28       TST     $CC28  ;		FLEX command flag
CD8C  & g 10 26 03 67    LBNE    $D0F7  ;		non-zero so called from a user program (so exit the re-entered FLEX)
CD90      BD D4 03       JSR     $D403  ;		FLEX FMS close  (close all open files at end of program)
CD93 ~I-  7E 49 2D       JMP     $492D  ;		POLYCORP's application
->
;
;	FLEX (REENTER) DOS main loop re-entry point
;	--------------
;
;
CD96      BD CE F1       JSR     $CEF1  ;			get next token from the FLEX line buffer
CD99      81 0D          CMPA    #$0D   ;			end of line character?
CD9B '    27 EC          BEQ     $CD89  ;			exit any re-entered FLEX
->
CD9D   @  8E C8 40       LDX     #$C840 ;			FLEX FCB space
CDA0 |    7C CC 0D       INC     $CC0D  ;			FLEX scratch area!
CDA3   S  BD CE 53       JSR     $CE53  ;			FLEX GETFIL get file specification (for filename in line buffer)
CDA6 %    25 16          BCS     $CDBE  ;			Error
CDA8   N  8E CC 4E       LDX     #$CC4E ;			DOS built-in command table
CDAB  8   8D 38          BSR     $CDE5  ;			check the command table to see if the command is there
CDAD '    27 09          BEQ     $CDB8  ;			found so do the command
CDAF      BE CC 12       LDX     $CC12  ;			USER command table
CDB2 '    27 07          BEQ     $CDBB  ;			no comand table so bad command
CDB4  /   8D 2F          BSR     $CDE5  ;			check the command table to see if the command is there
CDB6 &    26 03          BNE     $CDBB  ;			command not there so bad command
->
CDB8 n    6E 98 01       JMP     [$01,X];			command was found so branch indirect to execute the command
->
CDBB      BD D0 8D       JSR     $D08D  ;			load a CMD file and transfer control to it
->
CDBE      86 15          LDA     #$15   ;			FLEX error code (Invalid Filename Syntax)
->
CDC0      B7 CC 20       STA     $CC20  ;			FLEX error location
->
CDC3      7F CC 11       CLR     $CC11  ;			FLEX last terminator
CDC6 ~ g  7E CD 67       JMP     $CD67  ;			FLEX warm entry point
->
Routine:
;
;	FLEX (RSTRIO) Restore I/O vector
;	-------------
;
CDC9      BE CD 13       LDX     $CD13  ;			FLEX OUTCH2
CDCC      BF CD 10       STX     $CD10  ;			FLEX OUTCH
CDCF      BE CD 0D       LDX     $CD0D  ;			FLEX INCH2
CDD2      BF CD 0A       STX     $CD0A  ;			FLEX INCH
CDD5   #  7F CC 23       CLR     $CC23  ;			FLEX input switch
CDD8   "  7F CC 22       CLR     $CC22  ;			FLEX output switch
CDDB   !  7F CC 21       CLR     $CC21  ;			FLEX Special I/O flag
CDDE   &  7F CC 26       CLR     $CC26  ;			FLEX file input address
CDE1   $  7F CC 24       CLR     $CC24  ;			FLEX file output address
CDE4 9    39             RTS            ;			DONE
->
Routine:
CDE5    D 10 8E C8 44    LDY     #$C844 ;			"STARTUP.TXT"
->
CDE9      A6 A0          LDA     ,Y+    ;			Character at Y
CDEB  _   81 5F          CMPA    #$5F   ;			Last uppercase character
CDED #    23 02          BLS     $CDF1  ;			Uppercase already
CDEF      80 20          SUBA    #$20   ;			Convert to uppercase
->
CDF1      A1 80          CMPA    ,X+    ;			compare character at a time to where X points
CDF3 &    26 08          BNE     $CDFD  ;			strings do not match
CDF5 m    6D 84          TST     ,X     ;			are we at the end of the cmp string
CDF7 &    26 F0          BNE     $CDE9  ;			get next character
CDF9 m    6D A4          TST     ,Y     ;			is it a '\0'?
CDFB '    27 0C          BEQ     $CE09  ;			yes, so done and the strings match
->
CDFD m    6D 80          TST     ,X+    ;			are we at the end of x yet?
CDFF &    26 FC          BNE     $CDFD  ;			nope, so go to end of string
CE01 0    30 02          LEAX    $02,X  ;			x = x + 2 (skip a pointer)
CE03 m    6D 84          TST     ,X     ;			are we at empty strings?
CE05 &    26 DE          BNE     $CDE5  ;			nope, do this all over again
CE07      1C FB          ANDCC   #$FB   ;
->
CE09 9    39             RTS            ;			DONE
->
Routine:
;
;	FLEX (CLASS) Character classifier
;	------------
;
CE0A  0   81 30          CMPA    #$30   ;
CE0C %    25 14          BCS     $CE22  ;
CE0E  9   81 39          CMPA    #$39   ;
CE10 #    23 16          BLS     $CE28  ;
CE12  A   81 41          CMPA    #$41   ;
CE14 %    25 0C          BCS     $CE22  ;
CE16  Z   81 5A          CMPA    #$5A   ;
CE18 #    23 0E          BLS     $CE28  ;
CE1A  a   81 61          CMPA    #$61   ;
CE1C %    25 04          BCS     $CE22  ;
CE1E  z   81 7A          CMPA    #$7A   ;
CE20 #    23 06          BLS     $CE28  ;
->
CE22      1A 01          ORCC    #$01   ;
CE24      B7 CC 11       STA     $CC11  ;
CE27 9    39             RTS            ;
->
CE28      1C FE          ANDCC   #$FE   ;
CE2A 9    39             RTS            ;
->
Routine:
;
;	FLEX (NXTCH) Get next buffer character
;	------------
;
CE2B 4    34 10          PSHS    X      ;
CE2D      BE CC 14       LDX     $CC14  ; 			FLEX Line buffer pointer
CE30      B6 CC 18       LDA     $CC18  ;
CE33      B7 CC 19       STA     $CC19  ;
->
CE36      A6 80          LDA     ,X+    ;
CE38      B7 CC 18       STA     $CC18  ;
CE3B      81 0D          CMPA    #$0D   ;
CE3D '    27 10          BEQ     $CE4F  ;
CE3F      B1 CC 02       CMPA    $CC02  ;
CE42 '    27 0B          BEQ     $CE4F  ;
CE44      BF CC 14       STX     $CC14  ; 			FLEX Line buffer pointer
CE47      81 20          CMPA    #$20   ;
CE49 &    26 04          BNE     $CE4F  ;
CE4B      A1 84          CMPA    ,X     ;
CE4D '    27 E7          BEQ     $CE36  ;
->
CE4F      8D B9          BSR     $CE0A  ;
CE51 5    35 90          PULS    PC,X   ;
->
Routine:
;
;	FLEX (GETFIL) Get file specification
;	-------------
;
CE53      86 15          LDA     #$15   ;
CE55      A7 01          STA     $01,X  ;
CE57      86 FF          LDA     #$FF   ;
CE59      A7 03          STA     $03,X  ;
CE5B o    6F 04          CLR     $04,X  ;
CE5D o    6F 0C          CLR     $0C,X  ;
CE5F      BD CE F1       JSR     $CEF1  ;
CE62      86 08          LDA     #$08   ;
CE64   K  B7 CC 4B       STA     $CC4B  ;
CE67  4   8D 34          BSR     $CE9D  ;
CE69 %.   25 2E          BCS     $CE99  ;
CE6B &    26 0F          BNE     $CE7C  ;
CE6D  .   8D 2E          BSR     $CE9D  ;
CE6F %(   25 28          BCS     $CE99  ;
CE71 &    26 09          BNE     $CE7C  ;
CE73   ?  BC CC 3F       CMPX    $CC3F  ;
CE76 'l   27 6C          BEQ     $CEE4  ;
CE78  #   8D 23          BSR     $CE9D  ;
CE7A #h   23 68          BLS     $CEE4  ;
->
CE7C   ?  BE CC 3F       LDX     $CC3F  ;
CE7F m    6D 04          TST     $04,X  ;
CE81 'a   27 61          BEQ     $CEE4  ;
CE83 m    6D 03          TST     $03,X  ;
CE85 *    2A 0F          BPL     $CE96  ;
CE87 }    7D CC 0D       TST     $CC0D  ;
CE8A '    27 05          BEQ     $CE91  ;
CE8C      B6 CC 0B       LDA     $CC0B  ;			FLEX system drive number
CE8F      20 03          BRA     $CE94  ;
->
CE91      B6 CC 0C       LDA     $CC0C  ;
->
CE94      A7 03          STA     $03,X  ;
->
CE96      7F CC 0D       CLR     $CC0D  ;
->
CE99   ?  BE CC 3F       LDX     $CC3F  ;
CE9C 9    39             RTS            ;
->
Routine:
CE9D      8D 8C          BSR     $CE2B  ;
CE9F %C   25 43          BCS     $CEE4  ;
CEA1  9   81 39          CMPA    #$39   ;
CEA3 "    22 15          BHI     $CEBA  ;
CEA5   ?  BE CC 3F       LDX     $CC3F  ;
CEA8 m    6D 03          TST     $03,X  ;
CEAA *8   2A 38          BPL     $CEE4  ;
CEAC      84 03          ANDA    #$03   ;
CEAE      A7 03          STA     $03,X  ;
CEB0   +  BD CE 2B       JSR     $CE2B  ;
CEB3 $/   24 2F          BCC     $CEE4  ;
->
CEB5  .   81 2E          CMPA    #$2E   ;
CEB7      1C FE          ANDCC   #$FE   ;
CEB9 9    39             RTS            ;
->
CEBA   K  F6 CC 4B       LDB     $CC4B  ;
CEBD +%   2B 25          BMI     $CEE4  ;
CEBF 4    34 04          PSHS    B      ;
CEC1      C0 05          SUBB    #$05   ;
CEC3   K  F7 CC 4B       STB     $CC4B  ;
CEC6 5    35 04          PULS    B      ;
->
CEC8   I  B1 CC 49       CMPA    $CC49  ;
CECB %    25 02          BCS     $CECF  ;
CECD      80 20          SUBA    #$20   ;
->
CECF      A7 04          STA     $04,X  ;
CED1 0    30 01          LEAX    $01,X  ;
CED3 Z    5A             DECB           ;
CED4   +  BD CE 2B       JSR     $CE2B  ;
CED7 $    24 08          BCC     $CEE1  ;
CED9  -   81 2D          CMPA    #$2D   ;
CEDB '    27 04          BEQ     $CEE1  ;
CEDD  _   81 5F          CMPA    #$5F   ;
CEDF &    26 06          BNE     $CEE7  ;
->
CEE1 ]    5D             TSTB           ;
CEE2 &    26 E4          BNE     $CEC8  ;
->
CEE4      1A 01          ORCC    #$01   ;
CEE6 9    39             RTS            ;
->
CEE7 ]    5D             TSTB           ;
CEE8 '    27 CB          BEQ     $CEB5  ;
CEEA o    6F 04          CLR     $04,X  ;
CEEC 0    30 01          LEAX    $01,X  ;
CEEE Z    5A             DECB           ;
CEEF      20 F6          BRA     $CEE7  ;
->
Routine:
;
;	get next token from the line buffer (skipping multiple spaces)
;	leave the pointer in the FLEX line buffer pointer location
;
CEF1   ?  BF CC 3F       STX     $CC3F  ;			save X in the scratch space
CEF4      BE CC 14       LDX     $CC14  ;			FLEX line buffer pointer
->										;			skip over sequences of multiple spaces
CEF7      A6 84          LDA     ,X     ;			get first character from line buffer
CEF9      81 20          CMPA    #$20   ;			was it a space?
CEFB &    26 04          BNE     $CF01  ;			not a space so move on
CEFD 0    30 01          LEAX    $01,X  ;			inc X
CEFF      20 F6          BRA     $CEF7  ;			more
->
CF01      BF CC 14       STX     $CC14  ;			FLEX line buffer pointer
CF04   ?  BE CC 3F       LDX     $CC3F  ;			restore X from scratch space
CF07 9    39             RTS            ;			DONE
->
Routine:
;
;	FLEX (SETEXT) Set file extension
;	-------------
;
CF08 40   34 30          PSHS    Y,X    ;			Save Y and X
CF0A      E6 0C          LDB     $0C,X  ;
CF0C &    26 18          BNE     $CF26  ;			DONE
CF0E    ( 10 8E CF 28    LDY     #$CF28 ;			file extension lookup table
CF12      81 0B          CMPA    #$0B   ;
CF14 "    22 10          BHI     $CF26  ;			DONE
CF16      C6 03          LDB     #$03   ;
CF18 =    3D             MUL            ;
CF19 1    31 A5          LEAY    B,Y    ;
CF1B      C6 03          LDB     #$03   ;
->
CF1D      A6 A0          LDA     ,Y+    ;
CF1F      A7 0C          STA     $0C,X  ;
CF21 0    30 01          LEAX    $01,X  ;
CF23 Z    5A             DECB           ;
CF24 &    26 F7          BNE     $CF1D  ;
->
CF26 5    35 B0          PULS    PC,Y,X ;			DONE
;
; FILE TYPE lookup table 
;
;
CF28      42 49 4E        BIN ;			 0
CF2B      54 58 54        TXT ;			 1
CF2E      43 4D 44        CMD ;			 2
CF31      42 41 53        BAS ;			 3
CF34      53 59 53        SYS ;			 4
CF37      42 41 4B        BAK ;			 5
CF3A      53 43 52        SCR ;			 6
CF3D      44 41 54        DAT ;			 7
CF40      42 41 43        BAC ;			 8
CF43      44 49 52        DIR ;			 9
CF46      50 52 54        PRT ;			10 ($0A)
CF49      4F 55 54        OUT ;			11 ($0B)
;
;	FLEX (GETHEX) Get hexadecimal number
;	-------------
;
CF4C   }  BD D0 7D       JSR     $D07D  ;
->
CF4F   +  BD CE 2B       JSR     $CE2B  ;
CF52 %"   25 22          BCS     $CF76  ;
CF54  &   8D 26          BSR     $CF7C  ;
CF56 %    25 18          BCS     $CF70  ;
CF58 4    34 04          PSHS    B      ;
CF5A      C6 04          LDB     #$04   ;
->
CF5C x    78 CC 1C       ASL     $CC1C  ;
CF5F y    79 CC 1B       ROL     $CC1B  ;
CF62 Z    5A             DECB           ;
CF63 &    26 F7          BNE     $CF5C  ;
CF65 5    35 04          PULS    B      ;
CF67      BB CC 1C       ADDA    $CC1C  ;
CF6A      B7 CC 1C       STA     $CC1C  ;
CF6D \    5C             INCB           ;
CF6E      20 DF          BRA     $CF4F  ;
->
CF70   +  BD CE 2B       JSR     $CE2B  ;
CF73 $    24 FB          BCC     $CF70  ;
CF75 9    39             RTS            ;
->
CF76      BE CC 1B       LDX     $CC1B  ;
CF79      1C FE          ANDCC   #$FE   ;
CF7B 9    39             RTS            ;
->
Routine:
CF7C  G   80 47          SUBA    #$47   ;
CF7E *    2A 0F          BPL     $CF8F  ;
CF80      8B 06          ADDA    #$06   ;
CF82 *    2A 04          BPL     $CF88  ;
CF84      8B 07          ADDA    #$07   ;
CF86 *    2A 07          BPL     $CF8F  ;
->
CF88      8B 0A          ADDA    #$0A   ;
CF8A +    2B 03          BMI     $CF8F  ;
CF8C      1C FE          ANDCC   #$FE   ;
CF8E 9    39             RTS            ;
->
CF8F      1A 01          ORCC    #$01   ;
CF91 9    39             RTS            ;
->
;
;	FLEX (INDEX) Input decimal number
;	------------
;


CF92   }  BD D0 7D       JSR     $D07D  ;
->
CF95   +  BD CE 2B       JSR     $CE2B  ;
CF98 %    25 DC          BCS     $CF76  ;
CF9A  9   81 39          CMPA    #$39   ;
CF9C "    22 D2          BHI     $CF70  ;
CF9E      84 0F          ANDA    #$0F   ;
CFA0 4    34 04          PSHS    B      ;
CFA2 4    34 02          PSHS    A      ;
CFA4      FC CC 1B       LDD     $CC1B  ;
CFA7 X    58             ASLB           ;
CFA8 I    49             ROLA           ;
CFA9 X    58             ASLB           ;
CFAA I    49             ROLA           ;
CFAB X    58             ASLB           ;
CFAC I    49             ROLA           ;
CFAD      F3 CC 1B       ADDD    $CC1B  ;
CFB0      F3 CC 1B       ADDD    $CC1B  ;
CFB3      EB E0          ADDB    ,S+    ;
CFB5      89 00          ADCA    #$00   ;
CFB7      FD CC 1B       STD     $CC1B  ;
CFBA 5    35 04          PULS    B      ;
CFBC \    5C             INCB           ;
CFBD      20 D6          BRA     $CF95  ;
->
CFBF  00       .     ;
->
Routine:
;
;	FLEX (LOAD) File loader
;	-----------
;
CFC0      7F CC 1D       CLR     $CC1D  ;
CFC3  c   8D 63          BSR     $D028  ;
CFC5      20 05          BRA     $CFCC  ;
->
CFC7 Z    5A             DECB           ;
CFC8 &    26 02          BNE     $CFCC  ;
CFCA  \   8D 5C          BSR     $D028  ;
->
CFCC      A6 C0          LDA     ,U+    ;
CFCE      81 02          CMPA    #$02   ;
CFD0 '    27 1F          BEQ     $CFF1  ;
CFD2      81 16          CMPA    #$16   ;
CFD4 &    26 F1          BNE     $CFC7  ;
CFD6 Z    5A             DECB           ;
CFD7 &    26 02          BNE     $CFDB  ;
CFD9  M   8D 4D          BSR     $D028  ;
->
CFDB      A6 C0          LDA     ,U+    ;
CFDD      B7 CC 1E       STA     $CC1E  ;
CFE0 Z    5A             DECB           ;
CFE1 &    26 02          BNE     $CFE5  ;
CFE3  C   8D 43          BSR     $D028  ;
->
CFE5      A6 C0          LDA     ,U+    ;
CFE7      B7 CC 1F       STA     $CC1F  ;
CFEA      86 01          LDA     #$01   ;
CFEC      B7 CC 1D       STA     $CC1D  ;
CFEF      20 D6          BRA     $CFC7  ;
->
CFF1 Z    5A             DECB           ;
CFF2 &    26 02          BNE     $CFF6  ;
CFF4  2   8D 32          BSR     $D028  ;
->
CFF6      A6 C0          LDA     ,U+    ;
CFF8      A7 E3          STA     ,--S   ;
CFFA Z    5A             DECB           ;
CFFB &    26 02          BNE     $CFFF  ;
CFFD  )   8D 29          BSR     $D028  ;
->
CFFF      A6 C0          LDA     ,U+    ;
D001  a   A7 61          STA     $01,S  ;
D003 5    35 20          PULS    Y      ;
D005 4    34 04          PSHS    B      ;
D007      FC CC 1B       LDD     $CC1B  ;
D00A 1    31 AB          LEAY    D,Y    ;
D00C 5    35 04          PULS    B      ;
D00E Z    5A             DECB           ;
D00F &    26 02          BNE     $D013  ;
D011      8D 15          BSR     $D028  ;
->
D013      A6 C0          LDA     ,U+    ;
D015      B7 CF BF       STA     $CFBF  ;
->
D018 Z    5A             DECB           ;
D019 &    26 02          BNE     $D01D  ;
D01B      8D 0B          BSR     $D028  ;
->
D01D      A6 C0          LDA     ,U+    ;
D01F      A7 A0          STA     ,Y+    ;
D021 z    7A CF BF       DEC     $CFBF  ;
D024 &    26 F2          BNE     $D018  ;
D026      20 9F          BRA     $CFC7  ;
->
Routine:
D028   @  8E C8 40       LDX     #$C840 ;
D02B   @  EC 88 40       LDD     $40,X  ;
D02E &    26 02          BNE     $D032  ;
D030      20 20          BRA     $D052  ;
->
D032      ED 88 1E       STD     $1E,X  ;
D035      C6 09          LDB     #$09   ;
D037      E7 84          STB     ,X     ;
D039      BD D4 06       JSR     $D406  ;			FLEX FMS Call
D03C &    26 0E          BNE     $D04C  ;
D03E      C6 FC          LDB     #$FC   ;
D040 3 D  33 88 44       LEAU    $44,X  ;
D043 9    39             RTS            ;
->
;
;	Do and FCB comand and if it goes wrong the warm-start FLEX
;
;
Routine:
D044   @  8E C8 40       LDX     #$C840 ;			FCB address
D047      BD D4 06       JSR     $D406  ;			FLEX FMS Call
D04A '    27 11          BEQ     $D05D  ;			no error occurred
->
D04C      A6 01          LDA     $01,X  ;			FMS error byte
D04E      81 08          CMPA    #$08   ;			error:read past end of file 
D050 &    26 0E          BNE     $D060  ;			nope, tidy up and done
->
D052 2b   32 62          LEAS    $02,S  ;			pull return address from stack (because we warm-enter FLEX later?)
D054      86 04          LDA     #$04   ;			FMS function 4 (close file)
D056      A7 84          STA     ,X     ;			store in the FCB
D058      BD D4 06       JSR     $D406  ;			FLEX FMS Call (close the file)
D05B &    26 0D          BNE     $D06A  ;			error occurred
->
D05D      1C FE          ANDCC   #$FE   ;			clear flag (no error)
D05F 9    39             RTS            ;			DONE
->
D060      B7 CC 20       STA     $CC20  ;			FLEX error (last error)
D063      81 04          CMPA    #$04   ;			was it a close file error?
D065 &    26 03          BNE     $D06A  ;			DONE (and warm-start FLEX)
D067      1A 01          ORCC    #$01   ;			turn the flag bit on
D069 9    39             RTS            ;			DONE
->
D06A ~    7E CD C3       JMP     $CDC3  ;			finished and warm-start FLEX
->
;
;	BOOT: GET command
;	-----------------
;
Routine:
D06D      86 00          LDA     #$00   ;
D06F  =   8D 3D          BSR     $D0AE  ;
D071 %    25 10          BCS     $D083  ;
D073      8D 08          BSR     $D07D  ;
D075 | L  7C CC 4C       INC     $CC4C  ;
D078   E  17 FF 45       LBSR    $CFC0  ;			FLEX LOAD File Loader (load binary file)
D07B      20 F0          BRA     $D06D  ;
->
Routine:
;
;	set FLEX loader address offset to 0000
;
D07D O    4F             CLRA           ;			A = 0
D07E _    5F             CLRB           ;			B = 0 / D = 0
D07F      FD CC 1B       STD     $CC1B  ;			FLEX loader address offset
D082 9    39             RTS            ;			DONE
->
D083   L  F6 CC 4C       LDB     $CC4C  ;
D086  ' 4 10 27 FD 34    LBEQ    $CDBE  ;
D08A ~    7E CD 03       JMP     $CD03  ;			FLEX (WARMS) warm start entry point
->
Routine:
D08D      86 02          LDA     #$02   ;			CMD file extension
D08F  )   8D 29          BSR     $D0BA  ;			add the extension and open the file
D091      8D EA          BSR     $D07D  ;			reset the FLEX loader address offset to 0000
D093      BD CF C0       JSR     $CFC0  ;			FLEX LOAD File Loader (load binary file)
D096      F6 CC 1D       LDB     $CC1D  ;			FLEX Transfer Flag
D099 '    27 0E          BEQ     $D0A9  ;			if zero no transfer flag was found so don't do anything
D09B      F6 CC 11       LDB     $CC11  ;			FLEX last terminator
D09E      C1 3B          CMPB    #$3B   ;			this is a semi-colon
D0A0 &    26 03          BNE     $D0A5  ;			go and do it,
D0A2  H   BD 48 F1       JSR     $48F1  ;		POLYCORP something (send command #$13 (param #$08) to the Poly)
->
D0A5 n    6E 9F CC 1E    JMP     [$CC1E];			FLEX transfer address
->
D0A9      86 81          LDA     #$81   ;			error code! (this doesn't seem to exist, but means no transfer address found (not a CMD file))
D0AB ~    7E CD C0       JMP     $CDC0  ;			store errror, clear last terminator, and re-enter FLEX
->
Routine:
D0AE 4    34 02          PSHS    A      ;
D0B0   @  8E C8 40       LDX     #$C840 ;
D0B3   S  BD CE 53       JSR     $CE53  ;
D0B6 5    35 02          PULS    A      ;
D0B8 %    25 1A          BCS     $D0D4  ;
->
Routine:
;
;	a complex way of opening a file
;
D0BA   @  8E C8 40       LDX     #$C840 ;			FCB address
D0BD      BD CF 08       JSR     $CF08  ;			FLEX SETEXT set file extension
D0C0   @  8E C8 40       LDX     #$C840 ;			FCB address
D0C3      86 01          LDA     #$01   ;			FCB function 1 (open for read)
D0C5      A7 84          STA     ,X     ;			store as the command
D0C7   D  BD D0 44       JSR     $D044  ;			open the file
D0CA  %   10 25 00 05    LBCS    $D0D3  ;			DONE
D0CE      86 FF          LDA     #$FF   ;			no space compression
D0D0      A7 88 3B       STA     $3B,X  ;			FCB space compression flag
->
D0D3 9    39             RTS            ;			DONE
->
D0D4      B6 CC 11       LDA     $CC11  ;
D0D7      81 0D          CMPA    #$0D   ;
D0D9 '    27 07          BEQ     $D0E2  ;
D0DB      B1 CC 02       CMPA    $CC02  ;
D0DE  &   10 26 FC DC    LBNE    $CDBE  ;
->
D0E2      1A 01          ORCC    #$01   ;
D0E4 9    39             RTS            ;
->
;
;	FLEX (DOCMND) Call DOS as a subroutine
;	-------------
;
D0E5 5    35 06          PULS    D      ;			get return address
D0E7   C  FD CC 43       STD     $CC43  ;			save it
D0EA    E 10 FF CC 45    STS     $CC45  ;			save the stack
D0EE      7F CC 20       CLR     $CC20  ;			FLEX error type (cleared)
D0F1 | (  7C CC 28       INC     $CC28  ;			FLEX command flag
D0F4 ~    7E CD 9D       JMP     $CD9D  ;			FLEX REENTER (call FLEX reenterantly)
->
D0F7   (  7F CC 28       CLR     $CC28  ;			FLEX command flag (cleared)
D0FA    E 10 FE CC 45    LDS     $CC45  ;			get the stack back
D0FE      F6 CC 20       LDB     $CC20  ;			FLEX error type (so return error in register B)
D101 n  C 6E 9F CC 43    JMP     [$CC43];			branch to the specified return address (this is the DOCMND rts instruction)
->
;
;	FLEX (ADDBX) Add B to X
;	------------
;
D105 3A 39 
;
;	BOOT: MON command
;	-----------------
;
D107 3F 37 7E CD 67 45 52 52 4F 52 53 00 00 53         ?7~.gERRORS..S   ;
D115 59 53 00 00 00 00 7D D1 2B 27 08 AD 9F D1 2B 39 YS....}.+'....+9   ;
D125 1A 04 39 39 3F 01 00 00 
->
D12D D1 29 
D12F D1 25 					; FLEX STATUS vector (terminal status)
D131 D1 24 					; FLEX OUTCHAR and OUTCH2 
D133 D1 1B 					; FLEX INCHAR and INCH2 vector
->
Routine:
D135 ~ *  7E C6 2A       JMP     $C62A  ;
->
;
;	FMS DELETE FILE (function 12)
;	---------------
;
D138 BD D6 74 BD D5 30 27 66 BD DA 68 25 60 BD DD 1E ..t..0'f..h%`...   ;
D148 25 5B BE D4 0B A6 0F 85 80 26 58 85 40 26 58 BD %[.......&X.@&X.   ;
D158 D8 E0 BE D4 38 EC 02 26 0F BE D4 0B EC 88 11 27 ....8..&.......'   ;
D168 34 BE D4 38 ED 84 20 15 BE D4 0B BD D7 50 25 2D 4..8.. ......P%-   ;
D178 BE D4 0B EC 88 11 27 1D BD DD 87 25 20 BE D4 0B ......'....% ...   ;
D188 EC 88 13 BE D4 38 ED 02 BE D4 0B EC 88 15 BE D4 .....8..........   ;
D198 38 E3 04 ED 04 BD DD 75 25 03 BD DA A5 39 C6 02 8......u%....9..   ;
D1A8 1A 01 39 C6 0B 20 02 C6 0C 1A 01 39             ..9.. .....9       ;
->
Routine:
D1B4      EC 88 1E       LDD     $1E,X  ;
D1B7 \    5C             INCB           ;
D1B8   <  E1 88 3C       CMPB    $3C,X  ;
D1BB #    23 03          BLS     $D1C0  ;
D1BD      C6 01          LDB     #$01   ;
D1BF L    4C             INCA           ;
->
D1C0      10 A3 88 13    CMPD    $13,X  ;
D1C4 &    26 0E          BNE     $D1D4  ;
D1C6   7  A6 88 37       LDA     $37,X  ;
D1C9      81 FF          CMPA    #$FF   ;
D1CB '    27 07          BEQ     $D1D4  ;
D1CD L    4C             INCA           ;
D1CE   7  A7 88 37       STA     $37,X  ;
D1D1      1C FE          ANDCC   #$FE   ;
D1D3 9    39             RTS            ;
->
D1D4  3   8D 33          BSR     $D209  ;
D1D6 %0   25 30          BCS     $D208  ;
D1D8      BE D4 0B       LDX     $D40B  ;
D1DB   :  A6 88 3A       LDA     $3A,X  ;
D1DE      8B 03          ADDA    #$03   ;
D1E0 &    26 16          BNE     $D1F8  ;
D1E2      EC 88 1E       LDD     $1E,X  ;
D1E5      10 A3 88 11    CMPD    $11,X  ;
D1E9 '    27 05          BEQ     $D1F0  ;
D1EB      C6 17          LDB     #$17   ;
D1ED      1A 01          ORCC    #$01   ;
D1EF 9    39             RTS            ;
->
D1F0   @  EC 88 40       LDD     $40,X  ;
->
D1F3   8  ED 88 38       STD     $38,X  ;
D1F6      86 04          LDA     #$04   ;
->
D1F8   :  A7 88 3A       STA     $3A,X  ;
D1FB      EC 88 13       LDD     $13,X  ;
D1FE   5  ED 88 35       STD     $35,X  ;
D201      86 01          LDA     #$01   ;
D203   7  A7 88 37       STA     $37,X  ;
D206      1C FE          ANDCC   #$FE   ;
->
D208 9    39             RTS            ;
->
Routine:
D209   8  EC 88 38       LDD     $38,X  ;
D20C   P  BD D7 50       JSR     $D750  ;
D20F %    25 F7          BCS     $D208  ;
D211      BE D4 0B       LDX     $D40B  ;
D214      1F 12          TFR     X,Y    ;
D216   :  E6 88 3A       LDB     $3A,X  ;
D219      12             NOP            ;
D21A :    3A             ABX            ;
D21B      C6 03          LDB     #$03   ;
->
D21D   5  A6 A8 35       LDA     $35,Y  ;
D220 1!   31 21          LEAY    $01,Y  ;
D222   @  A7 88 40       STA     $40,X  ;
D225 0    30 01          LEAX    $01,X  ;
D227 Z    5A             DECB           ;
D228 &    26 F3          BNE     $D21D  ;
D22A      BD D7 DB       JSR     $D7DB  ;
D22D $    24 D9          BCC     $D208  ;
D22F ~    7E DD 8F       JMP     $DD8F  ;
->
D232 BD D9 74 BD D7 3C 10 25 00 4E BE D4 0B 4F 5F ED ..t..<.%.N...O_.   ;
D242 88 20 A6 88 67 A7 88 3C 5F 6F 88 40 30 01 5A 26 . ..g..<_o.@0.Z&   ;
D252 F8 BE D4 0B 1C FE 39 
;
;	FMS BACKUP ONE RECORD (function 22)
;	---------------------
;
BE D4 0B A6 88 17 27 25 EC ......9......'%.   ;
D262 88 20 83 00 01 2A 03 7E D3 16 ED 88 20 
;
;	FMS POSITION TO RECORD N (function 21)
;	------------------------
;
D26F BD DC 07
D272 25 16 46 24 0F 17 00 EF 25 0E BE D4 0B 6F 84 A6 %.F$....%....o..   ;
D282 88 17 26 05 C6 12 1A 01 39 7F D4 11 EC 88 11 10 ..&.....9.......   ;
D292 AE 88 20 27 6A BD D3 1B 25 EE 4F 5F 6D 02 27 74 .. 'j...%.O_m.'t   ;
D2A2 EB 02 89 00 BF D4 0F BE D4 0B 10 A3 88 20 24 2C ............. $,   ;
D2B2 BE D4 0F 30 03 34 02 B6 D4 11 4C B7 D4 11 81 54 ...0.4....L....T   ;
D2C2 27 08 81 A8 35 02 27 4C 20 D2 34 04 BE D4 0B EC '...5.'L .4.....   ;
D2D2 88 40 8D 45 25 3E 35 04 35 02 20 C0 A3 88 20 BE .@.E%>5.5. ... .   ;
D2E2 D4 0F A6 02 34 04 A0 E0 4A 1F 89 A6 84 EB 01 BE ....4...J.......   ;
D2F2 D4 0B 25 05 E1 88 3C 23 06 E0 88 3C 4C 20 F5 BD ..%...<#...<L ..   ;
D302 D7 50 25 14 BE D4 0B EC 88 42 10 A3 88 20 27 14 .P%......B... '.   ;
D312 C6 19 20 02 C6 18 1A 01 39 BD D7 50 25 08 BE D4 .. .....9..P%...   ;
D322 0B C6 44 3A 1C FE 39 BE D4 0B C6 0B A6 88 24 A7 ..D:..9.......$.   ;
D332 04 30 01 5A 26 F6 39 BE D4 0B A6 03 4C 81 04 24 .0.Z&.9.....L..$   ;
D342 0F A7 03 26 05 BD DE 0F 20 03 BD DE 12 25 E8 39 ...&.... ....%.9   ;
D352 C6 10 1A 01 39 7F D3 68 8D 0D 25 07 7D D3 68 27 ....9..h..%.}.h'   ;
D362 04 C6 14 1A 01 39 00 BD D6 01 26 45 34 10 AE 01 .....9....&E4...   ;
D372 AC E4 27 3B A6 84 85 05 27 F4 7C D3 68 85 01 27 ..';....'.|.h..'   ;
D382 ED EC 88 15 43 53 C3 00 01 1A 10 F3 DF F4 1F 03 ....CS..........   ;
D392 34 01 E6 88 14 35 01 23 01 5C F1 DF F3 1C EF 25 4....5.#.\.....%   ;
D3A2 06 11 83 17 70 25 04 8D 38 20 04 C6 22 1A 01 35 ....p%..8 .."..5   ;
D3B2 90 C6 0D 1A 01 39 8D AF 25 1C A6 84 85 02 27 17 .....9..%.....'.   ;
D3C2 8A 05 A7 84 1A 10 F6 DF F3 E7 88 14 FC DF F4 ED ................   ;
D3D2 88 15 1C EF 1C FE 39 C6 21 1A 01 39 BD D6 01 26 ......9.!..9...&   ;
D3E2 D0 A6 84 
;
;	???? Console I/O Driver Vector Table ????
;
D3E5      84 FE 		;	FLEX (INCHNE) Input character W/O echo
D3E7      A7 84			;	FLEX (INHNDLR) IRQ interrupt handler
D3E9      1C FE 		;	FLEX (SWIVEC) SWI3 vector location
D3EB      39 00 		;	FLEX (IRQVEC) IRQ vector location
D3ED      00 00			;	FLEX (TMOFF) Timer off
D3EF      00 00 		;	FLEX (TMON) Timer on
D3F1      00 00 		;	FLEX (TMINT) Timer initialisation
D3F3      00 00 		;	FLEX (MONITR) Monitor entry address
D3F5      00 00 		;	FLEX (TINIT) Terminal initialisation
D3F7      00 00 		;	FLEX (STAT) Check terminal status
D3F9      00 00 		;	FLEX (OUTCH) Output character
D3FB      00 00 		;	FLEX (INCH)	Input character W/ echo
D3FD      00 00 		;
D3FF      00			;
->
Routine:
D400 ~ ]  7E D4 5D       JMP     $D45D  ;			FLEX FMS Initialization
->
Routine:
D403 ~ n  7E D4 6E       JMP     $D46E  ;			FLEX FMS Close
->
Routine:
D406 ~    7E D4 94       JMP     $D494  ;			FLEX FMS Call
->
D409 00 00 00 00 00 00 00 00 00 00 00 05 00 05 00 00 ................   ;
D419 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 ................   ;
D429 00 00 00 00 00 00 00 00 00 00 00 00 FF 
->
D436 00 00 			; UID of remote Poly
->
D438 00 
D439 00 00 00 D4 40 00 00 00 D4 40 FF FF FF FF FF FF ....@....@......   ;
D449 FF FF FF FF FF FF 00 00 00 00 00 00 00 00 01     ...............   ;
D458 00
D459 00 00 
D45B 00 00			; Sector buffer on remote Poly
->
D45D      BD DE 15       JSR     $DE15  ;
D460      8E D4 19       LDX     #$D419 ;
D463      CC 01 04       LDD     #$0104 ;
->
D466      A7 06          STA     $06,X  ;
D468 0    30 07          LEAX    $07,X  ;
D46A Z    5A             DECB           ;
D46B &    26 F9          BNE     $D466  ;
D46D 9    39             RTS            ;
->
D46E   @  8E D4 40       LDX     #$D440 ;
D471   >  BF D4 3E       STX     $D43E  ;
D474      AE 88 10       LDX     $10,X  ;
->
D477 '    27 1A          BEQ     $D493  ;
D479      EC 88 10       LDD     $10,X  ;
D47C 4    34 07          PSHS    D,CC   ;
D47E      EC 88 12       LDD     $12,X  ;
D481    6 10 B3 D4 36    CMPD    $D436  ;			UID of remote Poly
D485 &    26 05          BNE     $D48C  ;
D487   %  BD D6 25       JSR     $D625  ;
D48A      20 03          BRA     $D48F  ;
->
D48C   >  BF D4 3E       STX     $D43E  ;
->
D48F 5    35 11          PULS    X,CC   ;
D491      20 E4          BRA     $D477  ;
->
D493 9    39             RTS            ;
->
;
;	FLEX FMS Call
;	-------------
;
D494 4$   34 24          PSHS    Y,B    ;
D496      BF D4 0B       STX     $D40B  ;			FLEX Current FCB address
D499 o    6F 01          CLR     $01,X  ;			clear the error status
D49B      E6 84          LDB     ,X     ;			B is the function code
D49D &"   26 22          BNE     $D4C1  ;
D49F      E6 02          LDB     $02,X  ;
D4A1 '    27 1A          BEQ     $D4BD  ;
D4A3      C1 02          CMPB    #$02   ;
D4A5 '    27 11          BEQ     $D4B8  ;
D4A7      BD D6 DF       JSR     $D6DF  ;
->
D4AA      BE D4 0B       LDX     $D40B  ;
D4AD %&   25 26          BCS     $D4D5  ;
D4AF }    7D CC FC       TST     $CCFC  ;
D4B2 &#   26 23          BNE     $D4D7  ;
D4B4 _    5F             CLRB           ;
D4B5 5$   35 24          PULS    Y,B    ;
D4B7 9    39             RTS            ;
->
D4B8      BD D8 07       JSR     $D807  ;
D4BB      20 ED          BRA     $D4AA  ;
->
D4BD      C6 12          LDB     #$12   ;
D4BF      20 14          BRA     $D4D5  ;
->
D4C1      C1 1D          CMPB    #$1D   ;			compare aginst $1D
D4C3 #    23 04          BLS     $D4C9  ;			less so decode and call function
D4C5      C6 01          LDB     #$01   ;
D4C7      20 0C          BRA     $D4D5  ;
->
D4C9 Z    5A             DECB           ;			subtract 1 from the function number
D4CA X    58             ASLB           ;			double B (ie offset into integer array)
D4CB      8E D4 DC       LDX     #$D4DC ;			offset table
D4CE      AD 95          JSR     [B,X]  ;
D4D0      BE D4 0B       LDX     $D40B  ;
D4D3 $    24 02          BCC     $D4D7  ;
->
D4D5      E7 01          STB     $01,X  ;
->
D4D7 m    6D 01          TST     $01,X  ;
D4D9 5$   35 24          PULS    Y,B    ;
D4DB 9    39             RTS            ;
->
;
;	FMS offset table (counts from 1)
;
D4DC DA E4			; FLEX  1 open for read
D4DE DB 2F			; FLEX  2 open for write 
D4E0 DC 77			; FLEX  3 open for update 
D4E2 DC 30			; FLEX  4 close file 
D4E4 D7 0D			; FLEX  5 rewind file 
D4E6 D9 81			; FLEX  6 open directory 
D4E8 D9 99			; FLEX  7 get information record 
D4EA D9 CD			; FLEX  8 put information record
D4EC D7 71			; FLEX  9 read single sector 
D4EE D7 DB			; FLEX 10 write single sector 
D4F0 DA C7			; FLEX 11 RESERVED 		(appears to set file attributes)
D4F2 D1 38			; FLEX 12 delete file 
D4F4 DC AA			; FLEX 13 rename file 
D4F6 D7 D5			; FLEX 14 RESERVED 
D4F8 DB DD			; FLEX 15 next sequential sector 
D4FA D9 74			; FLEX 16 open system information record
D4FC D6 9A			; FLEX 17 get random byte from sector 
D4FE D6 BB			; FLEX 18 put random byte in sector 
D500 DC 85			; FLEX 19 RESERVED 
D502 D3 39			; FLEX 20 find next drive 
D504 D2 6F			; FLEX 21 position to record N 
D506 D2 59			; FLEX 22 backup one record 
D508 D8 83			; FLEX 23 
D50A D7 37			; FLEX 24
D50C D3 B8			; FLEX 25 
D50E D3 DE			; FLEX 26 
D510 C9 80			; FLEX 27 
D512 DD A4			; FLEX 28 
D514 D3 57			; FLEX 29 
;
D516 8D 18 34 11 8D 61
D51C 35 11 26 0A EC 01 10 AF 01 ED 21 1C FE 39 10 AF 5.&.......!..9..   ;
D52C 21 1C FE 39 10 BE D4 0B 8E D4 40 27 0C 8D 0D 27 !..9......@'...'   ;
D53C 0A BF D4 3E AE 88 10 20 F2 1C FB 39             ...>... ...9       ;
->
Routine:
D548 40   34 30          PSHS    Y,X    ;
D54A 0    30 03          LEAX    $03,X  ;
D54C 1#   31 23          LEAY    $03,Y  ;
D54E      C6 0C          LDB     #$0C   ;
->
D550      A6 A0          LDA     ,Y+    ;
D552      A1 80          CMPA    ,X+    ;
D554 &    26 03          BNE     $D559  ;
D556 Z    5A             DECB           ;
D557 &    26 F7          BNE     $D550  ;
->
D559 5    35 B0          PULS    PC,Y,X ;
->
Routine:
D55B 4    34 10          PSHS    X      ;
D55D      A6 03          LDA     $03,X  ;
D55F   @  8E D4 40       LDX     #$D440 ;
->
D562      AE 88 10       LDX     $10,X  ;
D565 '    27 0C          BEQ     $D573  ;
D567      A1 03          CMPA    $03,X  ;
D569 &    26 F7          BNE     $D562  ;
D56B      A6 84          LDA     ,X     ;
D56D      8A 80          ORA     #$80   ;
D56F      A7 84          STA     ,X     ;
D571      20 EF          BRA     $D562  ;
->
D573      BD D8 E0       JSR     $D8E0  ;
D576 l    6C 06          INC     $06,X  ;
D578      BD DE 18       JSR     $DE18  ;;		FLEX Disk Driver initialisation (Warm start)
D57B 5    35 90          PULS    PC,X   ;
D57D   :  BE D4 3A       LDX     $D43A  ;
D580 &    26 02          BNE     $D584  ;
D582  G   8D 47          BSR     $D5CB  ;
->
D584    < 10 BE D4 3C    LDY     $D43C  ;
D588      AF A8 10       STX     $10,Y  ;
D58B      EC 88 10       LDD     $10,X  ;
D58E   :  FD D4 3A       STD     $D43A  ;
D591 o    6F 88 10       CLR     $10,X  ;
D594 o    6F 88 11       CLR     $11,X  ;
D597   <  BF D4 3C       STX     $D43C  ;
D59A      10 BE D4 0B    LDY     $D40B  ;
D59E   W  B6 D4 57       LDA     $D457  ;
D5A1 | W  7C D4 57       INC     $D457  ;
D5A4   =  A7 A8 3D       STA     $3D,Y  ;
D5A7      A7 0F          STA     $0F,X  ;
D5A9   6  FC D4 36       LDD     $D436  ;			UID of remote Poly
D5AC      ED 88 12       STD     $12,X  ;
D5AF O    4F             CLRA           ;
D5B0 m    6D A8 17       TST     $17,Y  ;
D5B3 '    27 02          BEQ     $D5B7  ;
D5B5      8A 02          ORA     #$02   ;
->
D5B7      A7 84          STA     ,X     ;
D5B9      C6 0C          LDB     #$0C   ;
D5BB 0    30 03          LEAX    $03,X  ;
D5BD 1#   31 23          LEAY    $03,Y  ;
->
D5BF      A6 A0          LDA     ,Y+    ;
D5C1      A7 80          STA     ,X+    ;
D5C3 Z    5A             DECB           ;
D5C4 &    26 F9          BNE     $D5BF  ;
D5C6    < 10 BE D4 3C    LDY     $D43C  ;
D5CA 9    39             RTS            ;
->
Routine:
D5CB   +  BE CC 2B       LDX     $CC2B  ;
D5CE 4    34 10          PSHS    X      ;
D5D0 0    30 89 FE 90    LEAX    $FE90,X;
D5D4   +  BF CC 2B       STX     $CC2B  ;
D5D7 0    30 01          LEAX    $01,X  ;
D5D9   :  BF D4 3A       STX     $D43A  ;
->
D5DC 1    31 88 17       LEAY    $17,X  ;
D5DF      10 AC E4       CMPY    ,S     ;
D5E2 $    24 09          BCC     $D5ED  ;
D5E4      10 AF 88 10    STY     $10,X  ;
D5E8 0    30 88 17       LEAX    $17,X  ;
D5EB      20 EF          BRA     $D5DC  ;
->
D5ED o    6F 88 10       CLR     $10,X  ;
D5F0 o    6F 88 11       CLR     $11,X  ;
D5F3 2b   32 62          LEAS    $02,S  ;
D5F5   :  BE D4 3A       LDX     $D43A  ;
D5F8   <  FC D4 3C       LDD     $D43C  ;
D5FB &    26 03          BNE     $D600  ;
D5FD   <  BF D4 3C       STX     $D43C  ;
->
D600 9    39             RTS            ;
->
Routine:
D601      10 BE D4 0B    LDY     $D40B  ;
D605   @  8E D4 40       LDX     #$D440 ;
->
D608 '    27 14          BEQ     $D61E  ;
D60A   =  A6 A8 3D       LDA     $3D,Y  ;
D60D      A1 0F          CMPA    $0F,X  ;
D60F &    26 05          BNE     $D616  ;
D611   H  BD D5 48       JSR     $D548  ;
D614 '    27 0A          BEQ     $D620  ;
->
D616   >  BF D4 3E       STX     $D43E  ;
D619      AE 88 10       LDX     $10,X  ;
D61C      20 EA          BRA     $D608  ;
->
D61E      1C FB          ANDCC   #$FB   ;
->
D620 9    39             RTS            ;
->
D621 8D DE 26 37                                     ..&7               ;
->
Routine:
D625 4    34 10          PSHS    X      ;
D627      EC 88 10       LDD     $10,X  ;
D62A   >  BE D4 3E       LDX     $D43E  ;
D62D      ED 88 10       STD     $10,X  ;
D630   <  FC D4 3C       LDD     $D43C  ;
D633      10 A3 E4       CMPD    ,S     ;
D636 &    26 03          BNE     $D63B  ;
D638   <  BF D4 3C       STX     $D43C  ;
->
D63B      AE E4          LDX     ,S     ;
D63D      10 AE 01       LDY     $01,X  ;
->
D640      EC 01          LDD     $01,X  ;
D642      10 A3 E4       CMPD    ,S     ;
D645 '    27 04          BEQ     $D64B  ;
D647      1F 01          TFR     D,X    ;
D649      20 F5          BRA     $D640  ;
->
D64B      10 AF 01       STY     $01,X  ;
D64E 5    35 10          PULS    X      ;
D650   :  FC D4 3A       LDD     $D43A  ;
D653      ED 88 10       STD     $10,X  ;
D656   :  BF D4 3A       STX     $D43A  ;
D659      1C FE          ANDCC   #$FE   ;
D65B 9    39             RTS            ;
->
D65C      C6 0D          LDB     #$0D   ;
D65E      1A 01          ORCC    #$01   ;
D660 9    39             RTS            ;
->
D661 39 BE D4 0B 4F 5F 8D 02 C6 2F A7 88 11 30 01 5A 9...O_.../...0.Z   ;
D671 26 F8 39 BE D4 0B C6 0B A6 04 A7 88 24 30 01 5A &.9.........$0.Z   ;
D681 26 F6 39 BE D4 0B C6 0B A6 04 34 02 A6 88 24 A1 &.9.......4...$.   ;
D691 E0 26 05 30 01 5A 26 F0 39 
;
;	FMS GET RANDOM BYTE FROM SECTOR (function 17)
;	-------------------------------
;
D69A BE D4 0B E6 02 54 24 .&.0.Z&.9.....T$   ;
D6A1 79 E6 88 23 7E D7 2B                            y..#~.+            ;
->
Routine:
D6A8      BE D4 0B       LDX     $D40B  ;
D6AB   "  E6 88 22       LDB     $22,X  ;
D6AE l "  6C 88 22       INC     $22,X  ;
D6B1 :    3A             ABX            ;
D6B2   @  A7 88 40       STA     $40,X  ;
D6B5 \    5C             INCB           ;
D6B6 &    26 1F          BNE     $D6D7  ;
D6B8      1A 01          ORCC    #$01   ;
D6BA 9    39             RTS            ;
->
;
;	FMS PUT RANDOM BYTE IN SECTOR (function 18)
;	-----------------------------
;
D6BB BE D4 0B E6 02 C4 03 C1 03 26 55 CA 80 E7 02 E6 .........&U.....   ;
D6CB 0F C5 80 26 0A E6 88 23 3A A7 88 40             ...&...#:..@       ;
->
D6D7      1C FE          ANDCC   #$FE   ;
D6D9 9    39             RTS            ;
->
D6DA C6 0B 1A 01 39                                  ....9              ;
->
Routine:
D6DF   ;  A6 88 3B       LDA     $3B,X  ;
D6E2 +<   2B 3C          BMI     $D720  ;
D6E4 '    27 07          BEQ     $D6ED  ;
D6E6 j ;  6A 88 3B       DEC     $3B,X  ;
D6E9      86 20          LDA     #$20   ;
D6EB      20 1D          BRA     $D70A  ;
->
D6ED  1   8D 31          BSR     $D720  ;
D6EF %    25 1B          BCS     $D70C  ;
D6F1      81 18          CMPA    #$18   ;
D6F3 "    22 15          BHI     $D70A  ;
D6F5 '    27 F6          BEQ     $D6ED  ;
D6F7      81 09          CMPA    #$09   ;
D6F9 &    26 0C          BNE     $D707  ;
D6FB  #   8D 23          BSR     $D720  ;
D6FD %    25 0D          BCS     $D70C  ;
D6FF      BE D4 0B       LDX     $D40B  ;
D702   ;  A7 88 3B       STA     $3B,X  ;
D705      20 D8          BRA     $D6DF  ;
->
D707 M    4D             TSTA           ;
D708 '    27 E3          BEQ     $D6ED  ;
->
D70A      1C FE          ANDCC   #$FE   ;
->
D70C 9    39             RTS            ;
->
;
;	FMS REWIND FILE (function 5)
;	-------------------
;
D70D BD DC 07 25 09 85 01 27 05 A7 84 7E DA F8       ...%...'...~..     ;
->
D71B      C6 12          LDB     #$12   ;
D71D      1A 01          ORCC    #$01   ;
D71F 9    39             RTS            ;
->
Routine:
D720      BE D4 0B       LDX     $D40B  ;
D723   "  E6 88 22       LDB     $22,X  ;
D726 '    27 0A          BEQ     $D732  ;
D728 l "  6C 88 22       INC     $22,X  ;
D72B :    3A             ABX            ;
D72C   @  A6 88 40       LDA     $40,X  ;
D72F      1C FE          ANDCC   #$FE   ;
D731 9    39             RTS            ;
->
D732      8D 08          BSR     $D73C  ;
D734 $    24 EA          BCC     $D720  ;
D736 9    39             RTS            ;
->
D737 BE D4 0B 6F 84                                  ...o.              ;
->
Routine:
D73C      BE D4 0B       LDX     $D40B  ;
D73F   @  EC 88 40       LDD     $40,X  ;
D742 l !  6C 88 21       INC     $21,X  ;
D745 &    26 03          BNE     $D74A  ;
D747 l    6C 88 20       INC     $20,X  ;
->
D74A      10 83 00 00    CMPD    #$0000 ;
D74E '    27 1C          BEQ     $D76C  ;
->
Routine:
D750      ED 88 1E       STD     $1E,X  ;
D753 4    34 02          PSHS    A      ;
D755      86 04          LDA     #$04   ;
D757   "  A7 88 22       STA     $22,X  ;
D75A 5    35 02          PULS    A      ;
D75C      8D 13          BSR     $D771  ;
D75E $    24 10          BCC     $D770  ;
D760      C5 80          BITB    #$80   ;
D762 '    27 04          BEQ     $D768  ;
D764      C6 10          LDB     #$10   ;
D766      20 06          BRA     $D76E  ;
->
D768      C6 09          LDB     #$09   ;
D76A      20 02          BRA     $D76E  ;
->
D76C      C6 08          LDB     #$08   ;
->
D76E      1A 01          ORCC    #$01   ;
->
D770 9    39             RTS            ;
->
Routine:
;
;	FMS READ SINGLE SECTOR (function 9)
;	----------------------
;
D771  1   8D 31          BSR     $D7A4  ;
D773      BE D4 0B       LDX     $D40B  ;
D776 } (  7D CC 28       TST     $CC28  ;
D779 &    26 07          BNE     $D782  ;
D77B      BD DE 1E       JSR     $DE1E  ;
D77E %    25 19          BCS     $D799  ;
D780      20 0A          BRA     $D78C  ;
->
D782      BD DE 0C       JSR     $DE0C  ;
D785 %    25 12          BCS     $D799  ;
->
D787      8D 11          BSR     $D79A  ;
D789      BD DE 00       JSR     $DE00  ;			FLEX Read (low level disk I/O, sector read)
->
D78C &    26 03          BNE     $D791  ;
D78E      1C FE          ANDCC   #$FE   ;
D790 9    39             RTS            ;
->
D791 4    34 04          PSHS    B      ;
D793      8D 17          BSR     $D7AC  ;
D795 5    35 04          PULS    B      ;
D797 $    24 EE          BCC     $D787  ;
->
D799 9    39             RTS            ;
->
Routine:
D79A      BE D4 0B       LDX     $D40B  ;
D79D      EC 88 1E       LDD     $1E,X  ;
D7A0 0 @  30 88 40       LEAX    $40,X  ;
D7A3 9    39             RTS            ;
->
Routine:
D7A4 O    4F             CLRA           ;
D7A5      B7 D4 11       STA     $D411  ;
D7A8      B7 D4 12       STA     $D412  ;
D7AB 9    39             RTS            ;
->
Routine:
D7AC      C5 10          BITB    #$10   ;
D7AE &    26 11          BNE     $D7C1  ;
D7B0      C5 80          BITB    #$80   ;
D7B2 &$   26 24          BNE     $D7D8  ;
D7B4      F6 D4 11       LDB     $D411  ;
D7B7 \    5C             INCB           ;
D7B8      C1 05          CMPB    #$05   ;
D7BA '    27 05          BEQ     $D7C1  ;
D7BC      F7 D4 11       STB     $D411  ;
D7BF      20 14          BRA     $D7D5  ;
->
D7C1      7F D4 11       CLR     $D411  ;
D7C4      F6 D4 12       LDB     $D412  ;
D7C7 \    5C             INCB           ;
D7C8      C1 07          CMPB    #$07   ;
D7CA '    27 0C          BEQ     $D7D8  ;
D7CC      F7 D4 12       STB     $D412  ;
D7CF      BE D4 0B       LDX     $D40B  ;
D7D2      BD DE 09       JSR     $DE09  ;
->
;
;	FMS RESERVED (function 14)
;	------------
;
D7D5      1C FE          ANDCC   #$FE   ;
D7D7 9    39             RTS            ;
->
D7D8      1A 01          ORCC    #$01   ;
D7DA 9    39             RTS            ;
->
Routine:
;
;	FMS WRITE SINGLE SECTOR (function 10)
;	----------------------
;
D7DB      8D C7          BSR     $D7A4  ;
D7DD      BE D4 0B       LDX     $D40B  ;
D7E0      BD DE 0C       JSR     $DE0C  ;
D7E3 %    25 1E          BCS     $D803  ;
->
D7E5      BE D4 0B       LDX     $D40B  ;
D7E8   !  BD DE 21       JSR     $DE21  ;
D7EB &    26 0A          BNE     $D7F7  ;
D7ED   5  B6 D4 35       LDA     $D435  ;
D7F0 '5   27 35          BEQ     $D827  ;
D7F2      BD DE 06       JSR     $DE06  ;
D7F5 '0   27 30          BEQ     $D827  ;
->
D7F7  @   C5 40          BITB    #$40   ;
D7F9 &    26 09          BNE     $D804  ;
D7FB 4    34 04          PSHS    B      ;
D7FD      8D AD          BSR     $D7AC  ;
D7FF 5    35 04          PULS    B      ;
D801 $    24 E2          BCC     $D7E5  ;
->
D803 9    39             RTS            ;
->
D804      1A 01          ORCC    #$01   ;
D806 9    39             RTS            ;
->
Routine:
D807      BE D4 0B       LDX     $D40B  ;
D80A   ;  E6 88 3B       LDB     $3B,X  ;
D80D +=   2B 3D          BMI     $D84C  ;
D80F      81 20          CMPA    #$20   ;
D811 &    26 0F          BNE     $D822  ;
D813 \    5C             INCB           ;
D814   ;  E7 88 3B       STB     $3B,X  ;
D817      C1 7F          CMPB    #$7F   ;
D819 &    26 0C          BNE     $D827  ;
D81B      20 0D          BRA     $D82A  ;
->
D81D      8D 0B          BSR     $D82A  ;
D81F $    24 E6          BCC     $D807  ;
D821 9    39             RTS            ;
->
D822 ]    5D             TSTB           ;
D823 ''   27 27          BEQ     $D84C  ;
D825      20 F6          BRA     $D81D  ;
->
D827      1C FE          ANDCC   #$FE   ;
D829 9    39             RTS            ;
->
Routine:
D82A 4    34 02          PSHS    A      ;
D82C      C1 01          CMPB    #$01   ;
D82E &    26 04          BNE     $D834  ;
D830      86 20          LDA     #$20   ;
D832      20 10          BRA     $D844  ;
->
D834      86 09          LDA     #$09   ;
D836      8D 14          BSR     $D84C  ;
D838 5    35 02          PULS    A      ;
D83A %    25 0F          BCS     $D84B  ;
D83C 4    34 02          PSHS    A      ;
D83E      BE D4 0B       LDX     $D40B  ;
D841   ;  A6 88 3B       LDA     $3B,X  ;
->
D844 o ;  6F 88 3B       CLR     $3B,X  ;
D847      8D 03          BSR     $D84C  ;
D849 5    35 02          PULS    A      ;
->
D84B 9    39             RTS            ;
->
Routine:
D84C      BE D4 0B       LDX     $D40B  ;
D84F      E6 02          LDB     $02,X  ;
D851      C1 02          CMPB    #$02   ;
D853  &   10 26 FE C4    LBNE    $D71B  ;
D857   "  E6 88 22       LDB     $22,X  ;
D85A      C1 04          CMPB    #$04   ;
D85C &    26 08          BNE     $D866  ;
D85E 4    34 02          PSHS    A      ;
D860  &   8D 26          BSR     $D888  ;
D862 5    35 02          PULS    A      ;
D864 %    25 0F          BCS     $D875  ;
->
D866      BD D6 A8       JSR     $D6A8  ;
D869 $    24 0A          BCC     $D875  ;
D86B      C6 04          LDB     #$04   ;
D86D      BE D4 0B       LDX     $D40B  ;
D870   "  E7 88 22       STB     $22,X  ;
D873      1C FE          ANDCC   #$FE   ;
->
D875 9    39             RTS            ;
->
Routine:
D876      BE D4 0B       LDX     $D40B  ;
D879 O    4F             CLRA           ;
D87A _    5F             CLRB           ;
D87B      ED 88 20       STD     $20,X  ;
D87E   B  ED 88 42       STD     $42,X  ;
D881  D   20 44          BRA     $D8C7  ;
->
D883 BE D4 0B 6F 84                                  ...o.              ;
->
Routine:
D888      BD D6 01       JSR     $D601  ;
D88B  &   10 26 FD CD    LBNE    $D65C  ;
D88F      A6 84          LDA     ,X     ;
D891 +_   2B 5F          BMI     $D8F2  ;
D893   $  BD DE 24       JSR     $DE24  ;
D896 '    27 05          BEQ     $D89D  ;
D898   [  BD D5 5B       JSR     $D55B  ;
D89B  U   20 55          BRA     $D8F2  ;
->
D89D      BE D4 0B       LDX     $D40B  ;
D8A0      E6 88 12       LDB     $12,X  ;
D8A3 &"   26 22          BNE     $D8C7  ;
D8A5      E6 88 17       LDB     $17,X  ;
D8A8 'Q   27 51          BEQ     $D8FB  ;
D8AA o    6F 88 17       CLR     $17,X  ;
D8AD  L   8D 4C          BSR     $D8FB  ;
D8AF %.   25 2E          BCS     $D8DF  ;
D8B1      8D C3          BSR     $D876  ;
D8B3 %*   25 2A          BCS     $D8DF  ;
D8B5      8D BF          BSR     $D876  ;
D8B7 %&   25 26          BCS     $D8DF  ;
D8B9      BE D4 0B       LDX     $D40B  ;
D8BC      C6 02          LDB     #$02   ;
D8BE      E7 88 17       STB     $17,X  ;
D8C1      EC 88 11       LDD     $11,X  ;
D8C4 ~    7E D1 F3       JMP     $D1F3  ;
->
D8C7      8D 10          BSR     $D8D9  ;
D8C9 %    25 14          BCS     $D8DF  ;
D8CB      BE D4 0B       LDX     $D40B  ;
D8CE   @  ED 88 40       STD     $40,X  ;
D8D1      BD D7 DB       JSR     $D7DB  ;
D8D4 $%   24 25          BCC     $D8FB  ;
D8D6 ~    7E DD 8F       JMP     $DD8F  ;
->
Routine:
D8D9      8D 05          BSR     $D8E0  ;
D8DB &    26 15          BNE     $D8F2  ;
D8DD      EC 84          LDD     ,X     ;
->
D8DF 9    39             RTS            ;
->
Routine:
D8E0      BE D4 0B       LDX     $D40B  ;
D8E3      E6 03          LDB     $03,X  ;
D8E5      86 07          LDA     #$07   ;
D8E7 =    3D             MUL            ;
D8E8      8E D4 19       LDX     #$D419 ;
D8EB :    3A             ABX            ;
D8EC   8  BF D4 38       STX     $D438  ;
D8EF m    6D 06          TST     $06,X  ;
D8F1 9    39             RTS            ;
->
D8F2      C6 20          LDB     #$20   ;
D8F4      BE D4 0B       LDX     $D40B  ;
D8F7 o    6F 02          CLR     $02,X  ;
D8F9      20 08          BRA     $D903  ;
->
Routine:
D8FB      8D DC          BSR     $D8D9  ;
D8FD %    25 06          BCS     $D905  ;
D8FF &    26 05          BNE     $D906  ;
D901      C6 07          LDB     #$07   ;
->
D903      1A 01          ORCC    #$01   ;
->
D905 9    39             RTS            ;
->
D906      BE D4 0B       LDX     $D40B  ;
D909      ED 88 13       STD     $13,X  ;
D90C m    6D 88 12       TST     $12,X  ;
D90F &    26 03          BNE     $D914  ;
D911      ED 88 11       STD     $11,X  ;
->
D914 l    6C 88 16       INC     $16,X  ;
D917 &    26 03          BNE     $D91C  ;
D919 l    6C 88 15       INC     $15,X  ;
->
D91C m    6D 88 17       TST     $17,X  ;
D91F '    27 0B          BEQ     $D92C  ;
D921      BD D1 B4       JSR     $D1B4  ;
D924 %    25 DD          BCS     $D903  ;
D926      BE D4 0B       LDX     $D40B  ;
D929      EC 88 13       LDD     $13,X  ;
->
D92C   P  BD D7 50       JSR     $D750  ;
D92F %    25 D2          BCS     $D903  ;
D931      BE D4 0B       LDX     $D40B  ;
D934   @  EC 88 40       LDD     $40,X  ;
D937 4    34 06          PSHS    D      ;
D939      8D A5          BSR     $D8E0  ;
D93B 5    35 06          PULS    D      ;
D93D      ED 84          STD     ,X     ;
D93F &    26 0A          BNE     $D94B  ;
D941 o    6F 02          CLR     $02,X  ;
D943 o    6F 03          CLR     $03,X  ;
D945 o    6F 04          CLR     $04,X  ;
D947 o    6F 05          CLR     $05,X  ;
D949      20 08          BRA     $D953  ;
->
D94B      10 AE 04       LDY     $04,X  ;
D94E 1?   31 3F          LEAY    $-01,Y ;
D950      10 AF 04       STY     $04,X  ;
->
D953 O    4F             CLRA           ;
D954      BE D4 0B       LDX     $D40B  ;
D957 l !  6C 88 21       INC     $21,X  ;
D95A &    26 03          BNE     $D95F  ;
D95C l    6C 88 20       INC     $20,X  ;
->
D95F _    5F             CLRB           ;
->
D960   @  A7 88 40       STA     $40,X  ;
D963 0    30 01          LEAX    $01,X  ;
D965 Z    5A             DECB           ;
D966 &    26 F8          BNE     $D960  ;
D968      BE D4 0B       LDX     $D40B  ;
D96B      EC 88 20       LDD     $20,X  ;
D96E   B  ED 88 42       STD     $42,X  ;
D971      1C FE          ANDCC   #$FE   ;
D973 9    39             RTS            ;
->
;
;	FMS OPEN SYSTEM INFORMATION RECORD (function 16)
;	----------------------------------
;
D974 5F 34 04 C6 03 20 0E BE D4 15 BF D4 13
;
;	FMS OPEN DIRECTORY (function 6)
;	------------------
;
D981 F6 D4 13
D984 34 04 F6 D4 14 BE D4 0B E7 88 41 35 04 E7 88 40 4.........A5...@   ;
D994 5F E7 88 22 39 
;
;	FMS GET INFORMATION RECORD (function 7)
;	--------------------------
;
D999 BE D4 0B E6 88 22 26 13 BD D7 3C _.."9....."&...<   ;
D9A4 25 26 BE D4 0B 86 10 A7 88 22 EC 88 1E ED 88 2F %&......."...../   ;
D9B4 A6 88 22 A7 88 31 C6 18 34 14 BD D7 20 35 14 A7 .."..1..4... 5..   ;
D9C4 04 30 01 5A 26 F2 1C FE 39 
;
;	FMS PUT INFORMATION RECORD (function 8)
;	--------------------------
;
D9CD BE D4 0B A6 88 31 A7
D9D4 88 22 C6 18 34 14 A6 04 BD D8 4C 35 14 30 01 5A
D9E4 26 F2 7E D7 DB BE D4 0B A6 03 A7 88 23 B6 D4 17 &.~.........#...   ;
D9F4 7D D4 18 26 2B A7 03 BE D4 15 BF D4 13 8C 00 05 }..&+...........   ;
DA04 27 06 8D 1C 23 31 20 F5 BE D4 0B A6 88 23 A7 03 '...#1 ......#..   ;
DA14 2A 0E BD D3 39 25 36 8D 07 23 1C BD D3 29 20 F2 *...9%6..#...) .   ;
DA24 BE D4 0B 7F D4 18 BD D6 74 BD D9 81 BD D9 99 24 ........t......$   ;
DA34 07 C1 08 27 18 1A 01 39 BE D4 0B A6 04 27 0C 2A ...'...9.....'.*   ;
DA44 02 8D 0F BD D6 84 26 E4 1C FE 39 8D 05 1C FB 1C ......&...9.....   ;
DA54 FE 39 A6 88 33 26 0C EC 88 2F ED 88 32 A6 88 31 .9..3&.../..2..1   ;
DA64 A7 88 34 39 BE D4 0B BD DE 24 27 03 BD D5 5B BD ..49.....$'...[.   ;
DA74 D8 E0 27 19 8D 1A 25 17 C6 06 10 BE D4 0B BE D4 ..'...%.........   ;
DA84 38 A6 A8 5D 31 21 A7 80 5A 26 F6 6F 84 1C FE 39 8..]1!..Z&.o...9   ;
DA94 BD D9 74 BD D7 3C 25 08 BE D4 0B C6 10 E7 88 22 ..t..<%........"   ;
DAA4 39 BD D8 E0 8D EA 25 F8 C6 06 10 BE D4 0B BE D4 9.....%.........   ;
DAB4 38 A6 80 A7 A8 5D 31 21 5A 26 F6 BD D7 DB 24 E0 8....]1!Z&....$.   ;
DAC4 7E DD 8F 
;
;	FMS RESERVED (function 11)
;	------------
;
DAC7 BE D4 0B 86 02 A7 02 EC 88 2F ED 88 1E ~.........../...   ;
DAD4 BD D7 71 25 08 BD D9 CD 24 05 7E DD 8F C6 0A 39 ..q%....$.~....9   ;
;
;	FMS OPEN FOR READ (function 1)
;	-----------------
;
DAE4 BD D9 E9 25 37 26 36 BD D5 16 25 35 BE D4 0B BD ...%7&6...%5....   ;
DAF4 DD 31 26 2D BD D2 32 25 28 EC 88 11 ED 88 40 BD .1&-..2%(.....@.   ;
DB04 DB CC E6 88 17 27 13 34 04 BD D7 3C 35 04 25 11 .....'.4...<5.%.   ;
DB14 5A 26 F4 BE D4 0B 5F E7 88 22 1C FE 39 C6 04 20 Z&...._.."..9..    ;
DB24 07 34 04 BD D6 21 35 04 1A 01 39 
;
;	FMS OPEN FOR WRITE (function 2)
;	------------------
;
DB2F BE D4 0B 6D 03 .4...!5...9...m.   ;
DB34 2A 08 BD D3 39 
;
;	FMS FIND NEXT DRIVE (function 20)
;	-------------------
;
D339 24 03 C6 10 39 BD D6 62 BD DA 68 *...9$...9..b..h   ;
DB44 25 4F BD D5 16 25 DA BD D9 E9 25 D5 26 04 C6 03 %O...%....%.&...   ;
DB54 20 CF BD D2 32 25 CA BE D4 0B C6 0A 6F 0F 30 01  ...2%......o.0.   ;
DB64 5A 26 F9 BE D4 0B EC 88 32 27 27 ED 88 2F A6 88 Z&......2''../..   ;
DB74 34 A7 88 31 FC CC 0E ED 88 19 B6 CC 10 A7 88 1B 4..1............   ;
DB84 BD D3 29 BD DA C7 25 99 8D 3E 86 04 A7 88 22 1C ..)...%..>....".   ;
DB94 FE 39 BE D4 0B 6F 88 17 6C 88 12 EC 88 2F BD D7 .9...o..l..../..   ;
DBA4 50 25 0D BD D8 C7 25 08 BD D7 DB 24 06 BD DD 8F P%....%....$....   ;
DBB4 7E DB 25 BE D4 0B EC 88 1E ED 88 32 86 10 A7 88 ~.%........2....   ;
DBC4 34 BD DA A5 25 EA 20 8A BE D4 0B A6 84 A7 02 6F 4...%. ........o   ;
DBD4 84 6F 88 3B 4F A7 88 22 39 
;
;	FMS NEXT SEQUENTIAL SECTOR (function 15)
;	--------------------------
;
Routine:
DBDD  (   8D 28          BSR     $DC07  ;
DBDF %    25 0E          BCS     $DBEF  ;
DBE1 o    6F 84          CLR     ,X     ;
DBE3 D    44             LSRA           ;
DBE4  % T 10 25 FB 54    LBCS    $D73C  ;
DBE8      C6 04          LDB     #$04   ;
DBEA   "  E7 88 22       STB     $22,X  ;
DBED      1C FE          ANDCC   #$FE   ;
->
DBEF 9    39             RTS            ;
->
Routine:
DBF0      BE D4 0B       LDX     $D40B  ;
DBF3      A6 02          LDA     $02,X  ;
DBF5      81 83          CMPA    #$83   ;
DBF7 &    26 0B          BNE     $DC04  ;
DBF9      86 03          LDA     #$03   ;
DBFB      A7 02          STA     $02,X  ;
DBFD      BD D7 DB       JSR     $D7DB  ;
DC00  %   10 25 01 8B    LBCS    $DD8F  ;
->
DC04      1C FE          ANDCC   #$FE   ;
DC06 9    39             RTS            ;
->
Routine:
DC07      BD D6 01       JSR     $D601  ;
DC0A  & N 10 26 FA 4E    LBNE    $D65C  ;
DC0E      A6 84          LDA     ,X     ;
DC10 +    2B 08          BMI     $DC1A  ;
DC12   $  BD DE 24       JSR     $DE24  ;
DC15 '    27 07          BEQ     $DC1E  ;
DC17   [  BD D5 5B       JSR     $D55B  ;
->
DC1A      C6 20          LDB     #$20   ;
DC1C      20 0F          BRA     $DC2D  ;
->
DC1E      8D D0          BSR     $DBF0  ;
DC20 %    25 0D          BCS     $DC2F  ;
DC22      BE D4 0B       LDX     $D40B  ;
DC25      A6 02          LDA     $02,X  ;
DC27      81 03          CMPA    #$03   ;
DC29 #    23 D9          BLS     $DC04  ;
DC2B      C6 12          LDB     #$12   ;
->
DC2D      1A 01          ORCC    #$01   ;
->
DC2F 9    39             RTS            ;
;
;	FMS CLOSE FILE (function 4)
;	--------------
;
DC30 BE D4 0B A6 .....#.....9....   ;
DC34 02 81 01 27 0B 8D CC 25 33 81 02 27 08 BE D4 0B ...'...%3..'....   ;
DC44 6F 02 7E D6 21 A6 88 12 26 07 BD D6 21 BD DD 75 o.~.!...&...!..u   ;
DC54 39 8D A6 25 17 BE D4 0B 6D 88 17 27 05 BD D2 09 9..%....m..'....   ;
DC64 25 0A BD DA C7 25 05 BD DA A5 24 D1 34 05 BD D6 %....%....$.4...   ;
DC74 21 35 85 
;
;	FMS OPEN FOR UPDATE (function 3)
;	-------------------
;
DC77 BD DA E4 25 28 BD D7 3C 25 23 86 03 20 !5....%(..<%#..    ;
DC84 18 
;
;	FMS RESERVED (function 19)
;	------------
;
DC85 BD DA E4 25 1A BE D4 0B A6 0F 85 80 26 12 EC ....%........&..   ;
DC94 88 13 BD D7 50 25 09 86 02 BE D4 0B A7 02 1C FE ....P%..........   ;
DCA4 39 C6 0B 1A 01 39 
;
;	FMS RENAME FILE (function 13)
;	---------------
;
DCAA BD D5 30 27 2E 8D 3B BD D9 E9 9....9..0'..;...   ;
DCB4 25 30 27 2A BE D4 0B C6 0B A6 88 24 A7 04 30 01 %0'*.......$..0.   ;
DCC4 5A 26 F6 8D 53 25 1B BE D4 0B A6 0F 85 80 26 D1 Z&..S%........&.   ;
DCD4 85 40 26 0F 8D 12 16 00 9F C6 02 1A 01 39 C6 03 .@&..........9..   ;
DCE4 1A 01 39 C6 0C 1A 01 39 BE D4 0B 86 0B B7 D4 11 ..9....9........   ;
DCF4 A6 04 E6 88 35 A7 88 35 E7 04 30 01 7A D4 11 26 ....5..5..0.z..&   ;
DD04 EF BE D4 0B A6 0C 26 0C C6 03 A6 88 3D A7 0C 30 ......&.....=..0   ;
DD14 01 5A 26 F6 BE D4 0B 39 8D CE BD D9 E9 25 0D 26 .Z&....9.....%.&   ;
DD24 4B BE D4 0B 8D 07 1C FE 27 02 1A 01 39 FC F0 02 K.......'...9...   ;
DD34 10 83 00 00 27 26 E6 0F C5 08 26 21 C5 20 27 1C ....'&....&!. '.   ;
DD44 7D D4 5A 27 09 FC D4 58 10 B3 D4 5B 27 0E A6 88 }.Z'...X...['...   ;
DD54 10 E6 88 18 10 B3 D4 5B 27 02 C6 11 39 A6 88 10 .......['...9...   ;
DD64 E6 88 18 10 B3 F0 02 27 02 C6 24 39 C6 04 1A 01 .......'..$9....   ;
DD74 39 BE D4 0B 86 FF A7 04 BD DA C7 BE D4 0B 86 00 9...............   ;
DD84 A7 02 39 ED 88 40 BD D7 DB 24 14                ..9..@...$.        ;
->
DD8F  @   C5 40          BITB    #$40   ;
DD91 &    26 08          BNE     $DD9B  ;
DD93      C5 80          BITB    #$80   ;
DD95 '    27 0A          BEQ     $DDA1  ;
DD97      C6 10          LDB     #$10   ;
DD99      20 06          BRA     $DDA1  ;
->
DD9B      C6 0B          LDB     #$0B   ;
DD9D      20 02          BRA     $DDA1  ;
->
DD9F C6 0A                                           ..                 ;
->
DDA1      1A 01          ORCC    #$01   ;
DDA3 9    39             RTS            ;
->
DDA4 BD DB 2F 25 1A 86 02 A7 02 A7 88 17 BD D8 07 25 ../%...........%   ;
DDB4 0E BD DC 30 25 09 BD DA E4 25 04 86 01 A7 02 39 ...0%....%.....9   ;
DDC4 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 ................   ;
DDD4 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 ................   ;
DDE4 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 ................   ;
DDF4 00 00 00 00 00 00 00 00 00 00 00 00             ............       ;
->
Routine:
DE00 ~ 0  7E DE 30       JMP     $DE30  ;		FLEX Read
->
DE03      7E DE BF       JMP     $DEBF  ;		FLEX Write
->
DE06 ~    7E DE E8       JMP     $DEE8  ;		FLEX Verify
->
DE09 ~    7E DE F5       JMP     $DEF5  ;		FLEX Restore
->
DE0C ~ C  7E DF 43       JMP     $DF43  ;		FLEX Drive select
->
DE0F ~ w  7E DF 77       JMP     $DF77  ;		FLEX Check drive ready
->
DE12      7E DF 85       JMP     $DF85  ;		FLEX Quick check drive ready
->
DE15 ~    7E DF 97       JMP     $DF97  ;		FLEX Driver initialisation (Cold start)
->
DE18 ~    7E DF A1       JMP     $DFA1  ;		FLEX Driver initialisation (Warm start)
->
DE1B      7E DE 62       JMP     $DE62  ;		FLEX Seek to specified track
->
DE1E ~    7E CA 9E       JMP     $CA9E  ;
->
DE21 ~ n  7E CB 6E       JMP     $CB6E  ;
->
DE24 ~    7E DF 0E       JMP     $DF0E  ;
->
DE27 00 00 00 00 00 00 00 00 00                      .........          ;
->
Routine:
;
;
;	FLEX Read
;	---------
;	FLEX read sector from disk routine
;
DE30  0   8D 30          BSR     $DE62  ;
DE32      B7 E0 19       STA     $E019  ;
DE35      86 88          LDA     #$88   ;
DE37      B7 E0 18       STA     $E018  ;
DE3A  ~   8D 7E          BSR     $DEBA  ;
DE3C _    5F             CLRB           ;
DE3D 4    34 09          PSHS    DP,CC  ;
DE3F      1A 10          ORCC    #$10   ;
DE41      86 E0          LDA     #$E0   ;
DE43      1F 8B          TFR     A,DP   ;
DE45      20 04          BRA     $DE4B  ;
->
DE47      96 1B          LDA     $1B    ;(DP$1B);
DE49      A7 80          STA     ,X+    ;
->
DE4B      D6 18          LDB     $18    ;(DP$18);
DE4D      C5 02          BITB    #$02   ;
DE4F &    26 F6          BNE     $DE47  ;
DE51      C5 01          BITB    #$01   ;
DE53 &    26 F6          BNE     $DE4B  ;
DE55 5    35 09          PULS    DP,CC  ;
DE57      C5 9C          BITB    #$9C   ;
DE59 9    39             RTS            ;			DONE
->
Routine:
DE5A      F6 E0 18       LDB     $E018  ;
DE5D      C5 01          BITB    #$01   ;
DE5F &    26 F9          BNE     $DE5A  ;
DE61 9    39             RTS            ;
->
;
;	FLEX Seek to specified track
;	----------------------------
;
Routine:
DE62      F7 E0 1A       STB     $E01A  ;
DE65      C1 10          CMPB    #$10   ;
DE67      C6 00          LDB     #$00   ;
DE69 %    25 02          BCS     $DE6D  ;
DE6B  @   C6 40          LDB     #$40   ;
->
DE6D   '  FA DE 27       ORB     $DE27  ;
DE70      F7 E0 14       STB     $E014  ;
DE73      B1 E0 19       CMPA    $E019  ;
DE76 '*   27 2A          BEQ     $DEA2  ;
DE78 %    25 04          BCS     $DE7E  ;
DE7A  Z   C6 5A          LDB     #$5A   ;
DE7C      20 02          BRA     $DE80  ;
->
DE7E  z   C6 7A          LDB     #$7A   ;
->
DE80      F7 E0 18       STB     $E018  ;
DE83  5   8D 35          BSR     $DEBA  ;
DE85      8D D3          BSR     $DE5A  ;
DE87      B7 E0 1B       STA     $E01B  ;
DE8A      8D 16          BSR     $DEA2  ;
DE8C 4    34 16          PSHS    X,D    ;
DE8E      86 18          LDA     #$18   ;
DE90      B7 E0 18       STA     $E018  ;
DE93  %   8D 25          BSR     $DEBA  ;
DE95      8D C3          BSR     $DE5A  ;
DE97   |  8E 01 7C       LDX     #$017C ;
->
DE9A      8D 1E          BSR     $DEBA  ;
DE9C 0    30 1F          LEAX    $-01,X ;
DE9E &    26 FA          BNE     $DE9A  ;
DEA0 5    35 96          PULS    PC,X,D ;
->
Routine:
DEA2 4    34 04          PSHS    B      ;
DEA4      F6 E0 18       LDB     $E018  ;
DEA7 *    2A 02          BPL     $DEAB  ;
DEA9      8D 02          BSR     $DEAD  ;
->
DEAB 5    35 84          PULS    PC,B   ;
->
Routine:
DEAD 4    34 10          PSHS    X      ;
DEAF  :   8E 3A 98       LDX     #$3A98 ;
->
DEB2      8D 06          BSR     $DEBA  ;
DEB4 0    30 1F          LEAX    $-01,X ;
DEB6 &    26 FA          BNE     $DEB2  ;
DEB8 5    35 90          PULS    PC,X   ;
->
Routine:
DEBA      8D 00          BSR     $DEBC  ;
->
Routine:
DEBC      8D 00          BSR     $DEBE  ;
->
Routine:
DEBE 9    39             RTS            ;
->
;
;	FLEX Write
;	----------
;
DEBF      8D A1          BSR     $DE62  ;
DEC1      B7 E0 19       STA     $E019  ;
DEC4      86 A8          LDA     #$A8   ;
DEC6      B7 E0 18       STA     $E018  ;
DEC9      8D EF          BSR     $DEBA  ;
DECB 4    34 09          PSHS    DP,CC  ;
DECD      1A 10          ORCC    #$10   ;
DECF      86 E0          LDA     #$E0   ;
DED1      1F 8B          TFR     A,DP   ;
DED3      20 02          BRA     $DED7  ;
->
DED5      97 1B          STA     $1B    ;(DP$1B);
->
DED7      A6 80          LDA     ,X+    ;
->
DED9      D6 18          LDB     $18    ;(DP$18);
DEDB      C5 02          BITB    #$02   ;
DEDD &    26 F6          BNE     $DED5  ;
DEDF      C5 01          BITB    #$01   ;
DEE1 &    26 F6          BNE     $DED9  ;
DEE3 5    35 09          PULS    DP,CC  ;
DEE5      C5 DC          BITB    #$DC   ;
DEE7 9    39             RTS            ;
->
;
;	FLEX Verify
;	-----------
;
DEE8      86 88          LDA     #$88   ;
DEEA      B7 E0 18       STA     $E018  ;
DEED      8D CB          BSR     $DEBA  ;
DEEF   h  17 FF 68       LBSR    $DE5A  ;
DEF2      C5 98          BITB    #$98   ;
DEF4 9    39             RTS            ;
->
;
;	FLEX Restore
;	------------
;
DEF5  L   8D 4C          BSR     $DF43  ;
DEF7 %    25 14          BCS     $DF0D  ;
DEF9      86 08          LDA     #$08   ;
DEFB      B7 E0 18       STA     $E018  ;
DEFE      8D BA          BSR     $DEBA  ;
DF00   W  17 FF 57       LBSR    $DE5A  ;
DF03  @   C5 40          BITB    #$40   ;
DF05 &    26 03          BNE     $DF0A  ;
DF07      1C FE          ANDCC   #$FE   ;
DF09 9    39             RTS            ;
->
DF0A      C6 16          LDB     #$16   ;
DF0C W    57             ASRB           ;
->
DF0D 9    39             RTS            ;
->
DF0E 4    34 10          PSHS    X      ;
DF10      A6 03          LDA     $03,X  ;
DF12      84 03          ANDA    #$03   ;
DF14   ,  8E DE 2C       LDX     #$DE2C ;
DF17      B7 E0 14       STA     $E014  ;
DF1A m    6D 86          TST     A,X    ;
DF1C &!   26 21          BNE     $DF3F  ;
DF1E      F6 E0 14       LDB     $E014  ;
DF21      C4 02          ANDB    #$02   ;
DF23 '    27 18          BEQ     $DF3D  ;
DF25      1F 89          TFR     A,B    ;
DF27 \    5C             INCB           ;
DF28      C4 03          ANDB    #$03   ;
DF2A 4    34 04          PSHS    B      ;
DF2C      F7 E0 14       STB     $E014  ;
DF2F      F6 E0 14       LDB     $E014  ;
DF32      C4 02          ANDB    #$02   ;
DF34      B7 E0 14       STA     $E014  ;
DF37 5    35 02          PULS    A      ;
DF39      E7 86          STB     A,X    ;
->
DF3B      C6 FF          LDB     #$FF   ;
->
DF3D 5    35 90          PULS    PC,X   ;
->
DF3F o    6F 86          CLR     A,X    ;
DF41      20 F8          BRA     $DF3B  ;
->
;
;	FLEX Drive select
;	-----------------
;
Routine:
DF43      A6 03          LDA     $03,X  ;
DF45      81 04          CMPA    #$04   ;
DF47 %    25 04          BCS     $DF4D  ;
DF49      C6 1F          LDB     #$1F   ;
DF4B W    57             ASRB           ;
DF4C 9    39             RTS            ;
->
DF4D 4    34 10          PSHS    X      ;
DF4F      8D 1E          BSR     $DF6F  ;
DF51      F6 E0 19       LDB     $E019  ;
DF54      E7 84          STB     ,X     ;
DF56      B7 E0 14       STA     $E014  ;
DF59   '  B1 DE 27       CMPA    $DE27  ;
DF5C '    27 03          BEQ     $DF61  ;
DF5E   Y  17 FF 59       LBSR    $DEBA  ;
->
DF61   '  B7 DE 27       STA     $DE27  ;
DF64      8D 09          BSR     $DF6F  ;
DF66      A6 84          LDA     ,X     ;
DF68      B7 E0 19       STA     $E019  ;
DF6B 5    35 10          PULS    X      ;
DF6D      20 0D          BRA     $DF7C  ;
->
Routine:
DF6F   (  8E DE 28       LDX     #$DE28 ;
DF72   '  F6 DE 27       LDB     $DE27  ;
DF75 :    3A             ABX            ;
DF76 9    39             RTS            ;
->
;
;	FLEX Check drive ready
;	----------------------
;
DF77      A6 03          LDA     $03,X  ;
DF79      B7 E0 14       STA     $E014  ;
->
DF7C      8D 0C          BSR     $DF8A  ;
DF7E $    24 16          BCC     $DF96  ;
DF80   *  17 FF 2A       LBSR    $DEAD  ;
DF83      20 05          BRA     $DF8A  ;
->
;
;	FLEX Quick check drive ready
;	----------------------------
;
Routine:
DF85      A6 03          LDA     $03,X  ;
DF87      B7 E0 14       STA     $E014  ;
->
Routine:
DF8A   -  17 FF 2D       LBSR    $DEBA  ;
DF8D      1C FE          ANDCC   #$FE   ;
DF8F      F6 E0 18       LDB     $E018  ;
DF92 *    2A 02          BPL     $DF96  ;
DF94      1A 01          ORCC    #$01   ;
->
DF96 9    39             RTS            ;
->
;
;	FLEX Driver initialisation (Cold start)
;	---------------------------------------
;
DF97   '  8E DE 27       LDX     #$DE27 ;
DF9A      C6 06          LDB     #$06   ;
->
DF9C o    6F 80          CLR     ,X+    ;
DF9E Z    5A             DECB           ;
DF9F &    26 FB          BNE     $DF9C  ;
->
;
;	FLEX Driver initialisation (Warm start)
;	---------------------------------------
;
DFA1      86 05          LDA     #$05   ;
DFA3      B7 CB 7F       STA     $CB7F  ;
DFA6      B7 CB 93       STA     $CB93  ;
DFA9 9    39             RTS            ;
->
DFAA 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 ................   ;
DFBA 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 ................   ;
DFCA 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 ................   ;
DFDA 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 ................   ;
DFEA 00 00 00 00 00 00 
DFF0 00 00 00 00 
DFF4 00 00 00 00 00 00 
DFFA 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 ................   ;
