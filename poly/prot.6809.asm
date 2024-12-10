;
;	PROT.CMD
;	--------
;	Commented Dissassembly by Andrew Trotman andrew@cs.otago.ac.nz
;
;	This is the command that protects a FLEX file
;
;	PROT filename [option-list]
;
;	Options W,D,P,C,X
;		write, delete, password, cat, remove
->
Routine:
C100      20 06          BRA     $C108  ;			start
->
C102 01 			;?
C103 00 			;	[X] should we remove protections?
C104 00 			;	[C] should we catalog protect?
C105 00 			;	[P] should we password protect?
C106 00 			;	[W] should we write protect?
C107 00				;	[D] should we delete protect?
->
C108   @  8E C8 40       LDX     #$C840 ;			FCB
C10B   -  BD CD 2D       JSR     $CD2D  ;			get file specification
C10E $    24 03          BCC     $C113  ;			no error detected
C110 ~    7E C1 BB       JMP     $C1BB  ;			report "invalid filename syntax"
->
C113      86 01          LDA     #$01   ;			default extenstion TXT file
C115      A7 84          STA     ,X     ;			first byte of FCB (command 01 : open file for read)
C117   3  BD CD 33       JSR     $CD33  ;			set file extension
C11A      BD C1 DB       JSR     $C1DB  ;			at end of line?
C11D &    26 03          BNE     $C122  ;			nope, so decode next param
C11F ~    7E C1 D2       JMP     $C1D2  ;			report "syntax error in command"
->
C122   @  8E C8 40       LDX     #$C840 ;			FCB
C125      BD D4 06       JSR     $D406  ;			FLEX FMS Call (open file)
C128  &   10 26 00 96    LBNE    $C1C2  ;			report error
C12C      86 04          LDA     #$04   ;			function 04 (close file)
C12E      A7 84          STA     ,X     ;			store as FMS function
C130      BD D4 06       JSR     $D406  ;			FLEX FMS Call (close file)
C133  &   10 26 00 8B    LBNE    $C1C2  ;			report error
C137      BD CD 27       JSR     $CD27  ;			FLEX (NXTCH) Get next buffer character
C13A  %   10 25 00 94    LBCS    $C1D2  ;			report "syntax error in command"
->
C13E  _   84 5F          ANDA    #$5F   ;			A holds the next char from the command buffer
C140  W   81 57          CMPA    #$57   ;			'W' (write protect)
C142 &    26 05          BNE     $C149  ;			move on
C144 |    7C C1 06       INC     $C106  ;			yup
C147      20 22          BRA     $C16B  ;			check next character
->
C149  D   81 44          CMPA    #$44   ;			'D' (delete protect)
C14B &    26 05          BNE     $C152  ;			move on
C14D |    7C C1 07       INC     $C107  ;			yup
C150      20 19          BRA     $C16B  ;			check next character
->
C152  P   81 50          CMPA    #$50   ;			'P' (password protect)
C154 &    26 05          BNE     $C15B  ;			move on
C156 |    7C C1 05       INC     $C105  ;			yup
C159      20 10          BRA     $C16B  ;			check next character
->
C15B  C   81 43          CMPA    #$43   ;			'C' (catalogue protect (hidden files))
C15D &    26 05          BNE     $C164  ;			move on
C15F |    7C C1 04       INC     $C104  ;			yup
C162      20 07          BRA     $C16B  ;			check next character
->
C164  X   81 58          CMPA    #$58   ;			'X' (remove all protections)
C166 &j   26 6A          BNE     $C1D2  ;			otherwise report "syntax error in command"
C168 |    7C C1 03       INC     $C103  ;			yup
->
C16B      BD CD 27       JSR     $CD27  ;			FLEX (NXTCH) Get next buffer character
C16E $    24 CE          BCC     $C13E  ;			decode it
C170  i   8D 69          BSR     $C1DB  ;			at end of line?
C172 &^   26 5E          BNE     $C1D2  ;			report "syntax error in command"
C174   @  8E C8 40       LDX     #$C840 ;			FCB
C177      A6 0F          LDA     $0F,X  ;			FCB File attributes
C179 }    7D C1 03       TST     $C103  ;			Remove protections?
C17C '    27 02          BEQ     $C180  ;			nope
C17E      84 0F          ANDA    #$0F   ;			turn off high nibble (which are the FLEX WDRCxxxx protection bits)
->
C180 }    7D C1 06       TST     $C106  ;			write protect?
C183 '    27 02          BEQ     $C187  ;			nope
C185      8A 80          ORA     #$80   ;			yes, turn on FLEX W bit
->
C187 }    7D C1 07       TST     $C107  ;			delete protect?
C18A '    27 02          BEQ     $C18E  ;			nope
C18C  @   8A 40          ORA     #$40   ;			yes, turn on FLEX D bit
->
C18E }    7D C1 05       TST     $C105  ;			password protect?
C191 '    27 14          BEQ     $C1A7  ;			nope
C193      85 08          BITA    #$08   ;			check high bit of low nibble			(WDRCSxxx)
C195 &B   26 42          BNE     $C1D9  ;			delete the program from memory and EXIT
C197      F6 DF F4       LDB     $DFF4  ;		? user's first initial ?
C19A      E7 88 10       STB     $10,X  ;			"reserved for future use" (really?)
C19D      F6 DF F5       LDB     $DFF5  ;		? user's second initial ?
C1A0      E7 88 18       STB     $18,X  ;			"reserved for future use" (really?)
C1A3      8A 20          ORA     #$20   ;			turn on the "R" bit to read-protect a file
C1A5      84 F7          ANDA    #$F7   ;			turn off the "S" special bit (not sure what, exactly, the S bit is)
->
C1A7 }    7D C1 04       TST     $C104  ;			catalog protect?
C1AA '    27 02          BEQ     $C1AE  ;			nope,
C1AC      8A 10          ORA     #$10   ;			yes, turn on FLEX C bit
->
C1AE      A7 0F          STA     $0F,X  ;			put attributes back into the FCB
C1B0      86 0B          LDA     #$0B   ;			function "reserved for future use"
C1B2      A7 84          STA     ,X     ;			put into the FCB
C1B4      BD D4 06       JSR     $D406  ;			FLEX FMS Call
C1B7 &    26 09          BNE     $C1C2  ;			report error
C1B9      20 0A          BRA     $C1C5  ;			delete program from memory and EXIT
->
C1BB   @  8E C8 40       LDX     #$C840 ;			FCB
C1BE      C6 15          LDB     #$15   ;			error #$15 (invalid filename syntax)
->
C1C0      E7 01          STB     $01,X  ;			FCB error code
->
C1C2   ?  BD CD 3F       JSR     $CD3F  ;			FLEX (RPTERR) Report error
->
C1C5      8E C1 00       LDX     #$C100 ;			start of this program
->
C1C8 o    6F 80          CLR     ,X+    ;			delete what ever is there
C1CA      8C C1 C4       CMPX    #$C1C4 ;			until we get to this piece of code
C1CD %    25 F9          BCS     $C1C8  ;			delete more
C1CF ~    7E CD 03       JMP     $CD03  ;			EXIT (FLEX warmstart entry point)
->
C1D2   @  8E C8 40       LDX     #$C840 ;			FCB
C1D5      C6 1A          LDB     #$1A   ;			error #$1A (syntax error in command)
C1D7      20 E7          BRA     $C1C0  ;			report the error
->
C1D9      20 EA          BRA     $C1C5  ;			delete the program from memory and EXIT
->
Routine:
;
;	at end of line?
;
C1DB      B6 CC 11       LDA     $CC11  ;			FLEX Last terminator
C1DE      81 0D          CMPA    #$0D   ;			was it and end of line character?
C1E0 '    27 03          BEQ     $C1E5  ;			DONE
C1E2      B1 CC 02       CMPA    $CC02  ;			TTYSET End of line character
->
C1E5 9    39             RTS            ;			DONE
