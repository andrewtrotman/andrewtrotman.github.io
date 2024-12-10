;
;	PROT.CMD
;	--------
;	OPSYS - Version 3.4.0 - Nov 1984
;
;	Commented Dissassembly by Andrew Trotman andrew@cs.otago.ac.nz
;
;	This is the command that protects a FLEX file
;
C100      20 08          BRA     $C10A  ;
->
C102      01
C103      00		; [X] should we remove protections?
C104      00		; [C] Catalog protect bit
C105      00		; [P] Password protect bit
C106      00		; [W] Write protect bit
C107      00		; [D] Delete protect bit
C108      00 00		; File size
->
C01A      8E C8 40       LDX     #$C840 ;	FCB
C10D   -  BD CD 2D       JSR     $CD2D  ;	get file specification
C110 $    24 03          BCC     $C115  ;	no error detected
C112 ~    7E C2 19       JMP     $C219  ;	report "invalid filename syntax"
->
C115      86 01          LDA     #$01   ;	default extension TXT file
C117      A7 84          STA     ,X     ;	first byte of FCB
C119   3  BD CD 33       JSR     $CD33  ;	set file extension
C11C   9  BD C2 39       JSR     $C239  ;	at end of line?
C11F &    26 03          BNE     $C124  ;	nope, so decode next param
C121 ~ 0  7E C2 30       JMP     $C230  ;	report "Syntax Error in Command"
->
C124   @  8E C8 40       LDX     #$C840 ;	FCB
C127      A6 03          LDA     $03,X  ;	drive number
C129 +    2B 04          BMI     $C12F  ;	high bit set?
C12B      84 BF          ANDA    #$BF   ;	1011 1111
C12D      A7 03          STA     $03,X  ;	put it back (Why?)
->
C12F      BD D4 06       JSR     $D406  ;	FMS call
C132  &   10 26 00 EA    LBNE    $C220  ;	Report an error
C136      EC 88 15       LDD     $15,X  ;	get file size
C139      FD C1 08       STD     $C108  ;	LOCAL file size
C13C      86 04          LDA     #$04   ;	function #$04 (close file)
C13E      A7 84          STA     ,X     ;	FCB function
C140      BD D4 06       JSR     $D406  ;	FMS call
C143  &   10 26 00 D9    LBNE    $C220  ;	Report an error
->
C147      BD CD 27       JSR     $CD27  ;	FLEX NXTCH Get next buffer character (into A)
C14A $    24 07          BCC     $C153  ;	Carry is clear if the character is alphabetic
C14C      81 20          CMPA    #$20   ;	' '
C14E      27 F7          BEQ     $C147  ;	move on to the next parameter
C150      16 00 DD       LBRA    $C230  ;	report "Syntax Error in Command"
->
C153  _   84 5F          ANDA    #$5F   ;	ASCII uppercase characters
C155  W   81 57          CMPA    #$57   ;	'W' (write protect)
C157 &    26 05          BNE     $C15E  ;	move on
C159 |    7C C1 06       INC     $C106  ;	LOCAL write protect bit
C15C  $   20 24          BRA     $C182  ;	next paramter
->
C15E  D   81 44          CMPA    #$44   ;	'D' (delete protect)
C160 &    26 05          BNE     $C167  ;	move on
C162 |    7C C1 07       INC     $C107  ;	LOCAL delete protect bit
C165      20 1B          BRA     $C182  ;	next parameter
->
C167  P   81 50          CMPA    #$50   ;	'P' (password protect)
C169 &    26 05          BNE     $C170  ;	move on
C16B |    7C C1 05       INC     $C105  ;	LOCAL password protect bit
C16E      20 12          BRA     $C182  ;	next parameter
->
C170  C   81 43          CMPA    #$43   ;	'C' (catalog protext)
C172 &    26 05          BNE     $C179  ;	move on
C174 |    7C C1 04       INC     $C104  ;	LOCAL catalog protect bit
C177      20 09          BRA     $C182  ;	next parameter
->
C179  X   81 58          CMPA    #$58   ;	'X' (remove protectsions)
C17B  &   10 26 00 B1    LBNE    $C230  ;	report "Syntax Error in Command"
C17F |    7C C1 03       INC     $C103  ;	LOCAL remove bit
->
C182      BD CD 27       JSR     $CD27  ;	FLEX (NXTCH) Get next buffer character
C185 $    24 CC          BCC     $C153  ;	decode it if ASCII
C187      81 20          CMPA    #$20   ;	' '
C189      27 F7          BEQ     $C182  ;	skip
C18B      17 00 AB       LBSR    $C239  ;	at end of line?
C18E  &   10 26 00 9E    LBNE    $C230  ;	report "Syntax Error in Command"
C192   @  8E C8 40       LDX     #$C840 ;	FCB
C195      A6 0F          LDA     $0F,X  ;	FCB File attributes
C197 }    7D C1 03       TST     $C103  ;	check - should we remove protections?
C19A      27 02          BEQ     $C19E  ;	nope
C19C      84 0F          ANDA    #$0F   ;	turn off high nibble (which are the FLEX WDRCxxxx protection bits)
->
C19E }    7D C1 06       TST     $C106  ;	check - should we write protect?
C1A1      27 02          BEQ     $C1A5  ;	nope
C1A3      8A 80          ORA     #$80   ;	FLEX 'W' bit
->
C1A5 }    7D C1 07       TST     $C107  ;	check - should we delete protect?
C1A8      27 02          BEQ     $C1AC  ;	nope
C1AA  @   8A 40          ORA     #$40   ;	FLEX 'D' bit
->
C1AC }    7D C1 05       TST     $C105  ;	check - should we password protect?
C1AF  T   27 54          BEQ     $C205  ;	nope
C1B1      85 08          BITA    #$08   ;	FLEX reserved 'S' bit
C1B3  &   10 26 00 80    LBNE    $C237  ;	delete program from memory and exit
C1B7      10 BE C1 08    LDY     $C108  ;	LOCAL file size
C1BB  f   27 66          BEQ     $C223  ;	zero size so delete program from memory and exit
;
C1BD      10 BE DF F4    LDY     $DFF4  ;	check - do we have initials and password?
C1C1 &2   26 32          BNE     $C1F5  ;	yes so protect
C1C3 4    34 12          PSHS    X,A    ;	save X and A as we're going to use them
C1C5      8E C2 9F       LDX     #$C29F ; 	enter initials message
C1C8      BD CD 1E       JSR     $CD1E  ;	FLEX (PSTRNG) print string
C1CB      8E DF F0       LDX     #$DFF0 ;	store initials at DFF0
C1CE      7F C3 07       CLR     $C307  ;	display typing
C1D1  q   8D 71          BSR     $C244  ;	get string (A = encrypted version)
C1D3      B7 C3 05       STA     $C305  ;	LOCAL encrypted initials
C1D6      8E C2 EC       LDX     #$C2EC ;	enter password message
C1D9      BD CD 1E       JSR     $CD1E  ;	FLEX (PSTRNG) print string
C1DC      8E C3 01       LDX     #$C301 ;	store the password here
C1DF |    7C C3 07       INC     $C307  ;	hide typing
C1E2      8D 60          BSR     $C244  ;	get string (A = encrypted version)
C1E4      B7 C3 06       STA     $C306  ;	LOCAL encrypted password
C1E7      FC C3 05       LDD     $C305  ;	LOCAL encrypted initials / password
C1EA      FD DF F4       STD     $DFF4  ;	FLEX / POLYSYS encrypted initials / password
C1ED      7F C3 05       CLR     $C305  ;	remove from working memory
C1F0      7F C3 06       CLR     $C306  ;	remove from working memory
C1F3 5    35 12          PULS    X,A    ;	restore X and A
->
C1F5      F6 DF F4       LDB     $DFF4  ;	FLEX / POLYSYS encrypted initials
C1F8      E7 88 10       STB     $10,X  ;	FLEX "Reserved"
C1FB      F6 DF F5       LDB     $DFF5  ;	FLEX / POLYSYS encrypted password
C1FE      E7 88 18       STB     $18,X  ;	FLEX "Reserved"
C201      8A 20          ORA     #$20   ;	FLEX 'R' bit
C203      84 F7          ANDA    #$F7   ;	turn off the 'S' bit
->
C205 }    7D C1 04       TST     $C104  ;	check - catalog protect?
C208      27 02          BEQ     $C20C  ;	nope
C20A      8A 10          ORA     #$10   ;	FLEX 'C' bit
->
C20C      A7 0F          STA     $0F,X  ;	put attributes back into FCB
C20E      86 0B          LDA     #$0B   ;	FCB 'Reserved for future use' (appears to be "set protections")
C210      A7 84          STA     ,X     ;	FCB command
C212      BD D4 06       JSR     $D406  ;	FLEX FMS Call
C215 &    26 09          BNE     $C220  ;	report error
C217      20 0A          BRA     $C223  ;	delete program from memory and exit
->
C219   @  8E C8 40       LDX     #$C840 ;	FCB
C21C      C6 15          LDB     #$15   ;	error #$15 (invalid filename syntax)
->
C21E      E7 01          STB     $01,X  ;	FCB error code
->
C220   ?  BD CD 3F       JSR     $CD3F  ;	FLEX (RPTERR) Report Error
->
C223      8E C1 00       LDX     #$C100 ;	Start of this program
->
C226 o    6F 80          CLR     ,X+    ;	delete what ever is there
C228      8C C2 22       CMPX    #$C222 ;	until we get to this code
C22B %    25 F9          BCS     $C226  ;	delete more
C22D ~    7E CD 03       JMP     $CD03  ;	FLEX warm start entry point
->
C230   @  8E C8 40       LDX     #$C840 ;	FCB
C233      C6 1A          LDB     #$1A   ;	error #$1A (syntax error in command)
C235      20 E7          BRA     $C21E  ;	report this error
->
C237      20 EA          BRA     $C223  ;	delete program from memory and exit
->
Routine:
C239      B6 CC 11       LDA     $CC11  ;	FLEX Last terminator
C23C      81 0D          CMPA    #$0D   ;	was it an end of line character?
C23E      27 03          BEQ     $C243  ;	DONE
C240      B1 CC 02       CMPA    $CC02  ;	TTYSET End of line character
->
C243 9    39             RTS            ;	DONE
->
Routine:
C244      C6 04          LDB     #$04   ;	read 4 characters
->
C246      1E 89          EXG     A,B    ;	A = B
C248 ?    3F 01          SWI     #$01   ;	input single character (into B)
C24A      1E 89          EXG     A,B    ;	put it into A (and restore B)
C24C      81 0D          CMPA    #$0D   ;	end of line
C24E  9   27 39          BEQ     $C289  ;	pad then encrypt then done
C250      81 08          CMPA    #$08   ;	backspace
C252 &    26 19          BNE     $C26D  ;	verify, print, and get next character
C254      C1 04          CMPB    #$04   ;	at start of string?
C256 $    24 EE          BCC     $C246  ;	(BHE) next character
C258 \    5C             INCB           ;	B = B + 1 (backspace management)
C259 0    30 1F          LEAX    $-01,X ;	X = X - 1
C25B 4    34 06          PSHS    D      ;	save A & B
C25D      C6 08          LDB     #$08   ;	backspace
C25F ?    3F 05          SWI     #$05   ;	put character
C261      C6 20          LDB     #$20   ;	' '
C263 ?    3F 05          SWI     #$05   ;	put character
C265      C6 08          LDB     #$08   ;	backspace
C267 ?    3F 05          SWI     #$05   ;	put character
C269 5    35 06          PULS    D      ;	restore A & B
C26B      20 D9          BRA     $C246  ;	next character
->
C26D  _   84 5F          ANDA    #$5F   ;	ASCII lowercase
C26F  A   81 41          CMPA    #$41   ;	'A'
C271 %    25 D3          BCS     $C246  ;	next character
C273  Z   81 5A          CMPA    #$5A   ;	'Z'
C275      22 CF          BHI     $C246  ;	next character
C277 ]    5D             TSTB           ;	check - are we done?
C278      27 CC          BEQ     $C246  ;	next character
C27A      A7 80          STA     ,X+    ;	save the character
C27C Z    5A             DECB           ;	one fewer to get
C27D }    7D C3 07       TST     $C307  ;	initials or password?
C280      27 02          BEQ     $C284  ;	print character
C282      86 20          LDA     #$20   ;	' '	(don't display passwords)
->
C284      BD CD 18       JSR     $CD18  ;	FLEX (PUTCHR) put character routine
C287      20 BD          BRA     $C246  ;	next character
->
C289      86 20          LDA     #$20   ;	' '
->
C28B ]    5D             TSTB           ;	check - at end of string?
C28C      27 05          BEQ     $C293  ;	yes
C28E      A7 80          STA     ,X+    ;	no, so pad with spaces
C290 Z    5A             DECB           ;	next character
C291      20 F8          BRA     $C28B  ;	pad until end of string
->
C293 0    30 1C          LEAX    $-04,X ;	X = X - 4 (start of string)
C295      C6 04          LDB     #$04   ;	B = #$04
C297 O    4F             CLRA           ;	A = #$00
->
C298 I    49             ROLA           ;	A = A << 1		(this is the "encrypt" algorithm)
C299      A9 80          ADCA    ,X+    ;	A += *X++
C29B Z    5A             DECB           ;	B = B - 1
C29C &    26 FA          BNE     $C298  ;	more
C29E 9    39             RTS            ;	DONE

->
C29F "Your initials and password have not been entered."
C2D2 1E 0D 0A 1E 0A 1E 0F 03
C2DA "Enter initials: "
C2EA 0E 04 
->
C2EC  1E 0F 03
C2EF "Enter password:"
C2FE 18 0E 04
->
C301      20 20 20 20	; user's password
->
C305      00			; encrypted initials
C306      00			; encrypted password
->
C307      00			; 0 = initials 1 = password
->
DFF0	  00 00 00 00	; users initials
DFF4      00 00			; encrypted initials / password
