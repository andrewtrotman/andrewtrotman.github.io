;
;	POLYSYS.SYS
;	-----------
;	Commented Dissassembly by Andrew Trotman andrew@cs.otago.ac.nz
;
;	This is the part that runs on the Poly 1 unit
;
C080 - C0FF - Line buffer
;
;
;
;

->
C600      20 05          BRA     $C607  ;
->
C602 84 2E 85 2E 80                                  .....              ;
->
C607      20 00          BRA     $C609  ;
->
C609  9   86 39          LDA     #$39   ;
C60B      B7 D3 FD       STA     $D3FD  ;
->
C60E      10 8E 00 00    LDY     #$0000 ;
C612   z  8E C7 7A       LDX     #$C77A ;
C615      C6 04          LDB     #$04   ;
C617 ?+   3F 2B          SWI     #$2B   ;
->
C619      10 8E 00 0B    LDY     #$000B ;
C61D ?,   3F 2C          SWI     #$2C   ;
C61F      C1 04          CMPB    #$04   ;
C621 &    26 EB          BNE     $C60E  ;
C623 m    6D 84          TST     ,X     ;
C625  & 9 10 26 01 39    LBNE    $C762  ;
C629      8D 02          BSR     $C62D  ;
C62B      20 EC          BRA     $C619  ;
->
Routine:
C62D   $  BD CD 24       JSR     $CD24  ;
C630      8E C7 80       LDX     #$C780 ;
C633      BD CD 1E       JSR     $CD1E  ;
C636      BD CD 1B       JSR     $CD1B  ;
C639      7F CC 02       CLR     $CC02  ;
C63C    z 10 8E C7 7A    LDY     #$C77A ;
C640   H  BD CD 48       JSR     $CD48  ;
C643 %    25 E8          BCS     $C62D  ;
C645      8C 00 1F       CMPX    #$001F ;
C648 "    22 E3          BHI     $C62D  ;
C64A      8C 00 00       CMPX    #$0000 ;
C64D /    2F DE          BLE     $C62D  ;
C64F      1F 10          TFR     X,D    ;
C651      F7 CC 0F       STB     $CC0F  ;
C654  !   E7 21          STB     $01,Y  ;
C656   H  BD CD 48       JSR     $CD48  ;
C659 %    25 D2          BCS     $C62D  ;
C65B      8C 00 0C       CMPX    #$000C ;
C65E "    22 CD          BHI     $C62D  ;
C660      8C 00 00       CMPX    #$0000 ;
C663 /    2F C8          BLE     $C62D  ;
C665      1F 10          TFR     X,D    ;
C667      F7 CC 0E       STB     $CC0E  ;
C66A      E7 A1          STB     ,Y++   ;
C66C   H  BD CD 48       JSR     $CD48  ;
C66F %    25 BC          BCS     $C62D  ;
C671   c  8C 00 63       CMPX    #$0063 ;
C674 "    22 B7          BHI     $C62D  ;
C676      1F 10          TFR     X,D    ;
C678      F7 CC 10       STB     $CC10  ;
C67B      E7 A0          STB     ,Y+    ;
->
C67D   $  BD CD 24       JSR     $CD24  ;
C680      8E C7 98       LDX     #$C798 ;
C683      BD CD 1E       JSR     $CD1E  ;
C686      BD CD 1B       JSR     $CD1B  ;
C689   H  BD CD 48       JSR     $CD48  ;
C68C %    25 EF          BCS     $C67D  ;
C68E      8C 00 17       CMPX    #$0017 ;
C691 "    22 EA          BHI     $C67D  ;
C693 _    5F             CLRB           ;
C694 O    4F             CLRA           ;
C695   ~  FD C7 7E       STD     $C77E  ;
C698   }  B7 C7 7D       STA     $C77D  ;
C69B      1F 10          TFR     X,D    ;
->
C69D Z    5A             DECB           ;
C69E +    2B 14          BMI     $C6B4  ;
C6A0   ~  BE C7 7E       LDX     $C77E  ;
C6A3 0    30 89 0E 10    LEAX    $0E10,X;
C6A7   ~  BC C7 7E       CMPX    $C77E  ;
C6AA $    24 03          BCC     $C6AF  ;
C6AC | }  7C C7 7D       INC     $C77D  ;
->
C6AF   ~  BF C7 7E       STX     $C77E  ;
C6B2      20 E9          BRA     $C69D  ;
->
C6B4   H  BD CD 48       JSR     $CD48  ;
C6B7 %    25 C4          BCS     $C67D  ;
C6B9   ;  8C 00 3B       CMPX    #$003B ;
C6BC "    22 BF          BHI     $C67D  ;
C6BE      1F 10          TFR     X,D    ;
C6C0  <   86 3C          LDA     #$3C   ;
C6C2 =    3D             MUL            ;
C6C3      1F 01          TFR     D,X    ;
C6C5  z   8D 7A          BSR     $C741  ;
C6C7   H  BD CD 48       JSR     $CD48  ;
C6CA %    25 B1          BCS     $C67D  ;
C6CC   ;  8C 00 3B       CMPX    #$003B ;
C6CF "    22 AC          BHI     $C67D  ;
C6D1      1F 10          TFR     X,D    ;
C6D3  l   8D 6C          BSR     $C741  ;
C6D5   $  BD CD 24       JSR     $CD24  ;
C6D8  :   86 3A          LDA     #$3A   ;
C6DA      B7 CC 02       STA     $CC02  ;
C6DD      8E 00 05       LDX     #$0005 ;
C6E0   }  F6 C7 7D       LDB     $C77D  ;
C6E3 O    4F             CLRA           ;
C6E4    ~ 10 BE C7 7E    LDY     $C77E  ;
->
C6E8  j   8D 6A          BSR     $C754  ;
C6EA 0    30 1F          LEAX    $-01,X ;
C6EC &    26 FA          BNE     $C6E8  ;
C6EE 4&   34 26          PSHS    Y,D    ;
C6F0  b   8D 62          BSR     $C754  ;
C6F2      1F 01          TFR     D,X    ;
C6F4  b   EC 62          LDD     $02,S  ;
C6F6 4    34 20          PSHS    Y      ;
C6F8 1    31 AB          LEAY    D,Y    ;
C6FA      10 AC E1       CMPY    ,S++   ;
C6FD $    24 02          BCC     $C701  ;
C6FF 0    30 01          LEAX    $01,X  ;
->
C701      1F 10          TFR     X,D    ;
C703  a   EB 61          ADDB    $01,S  ;
C705 2d   32 64          LEAS    $04,S  ;
C707      86 04          LDA     #$04   ;
->
C709 4    34 06          PSHS    D      ;
C70B   ~  FC C7 7E       LDD     $C77E  ;
C70E 4    34 20          PSHS    Y      ;
C710 1    31 AB          LEAY    D,Y    ;
C712      10 AC E1       CMPY    ,S++   ;
C715 $    24 02          BCC     $C719  ;
C717 la   6C 61          INC     $01,S  ;
->
C719 5    35 06          PULS    D      ;
C71B   }  FB C7 7D       ADDB    $C77D  ;
C71E J    4A             DECA           ;
C71F &    26 E8          BNE     $C709  ;
C721   }  F7 C7 7D       STB     $C77D  ;
C724    ~ 10 BF C7 7E    STY     $C77E  ;
C728   }  B6 C7 7D       LDA     $C77D  ;
C72B      1F 01          TFR     D,X    ;
C72D      C6 01          LDB     #$01   ;
C72F    ~ 10 BE C7 7E    LDY     $C77E  ;
C733 ?    3F 11          SWI     #$11   ;
C735      10 8E 00 06    LDY     #$0006 ;
C739   z  8E C7 7A       LDX     #$C77A ;
C73C      C6 04          LDB     #$04   ;
C73E ?+   3F 2B          SWI     #$2B   ;
C740 9    39             RTS            ;
->
Routine:
C741      1F 10          TFR     X,D    ;
C743   ~  BE C7 7E       LDX     $C77E  ;
C746 0    30 8B          LEAX    D,X    ;
C748   ~  BC C7 7E       CMPX    $C77E  ;
C74B $    24 03          BCC     $C750  ;
C74D | }  7C C7 7D       INC     $C77D  ;
->
C750   ~  BF C7 7E       STX     $C77E  ;
C753 9    39             RTS            ;
->
Routine:
C754 4    34 06          PSHS    D      ;
C756      1F 20          TFR     Y,D    ;
C758 X    58             ASLB           ;
C759 I    49             ROLA           ;
C75A      1F 02          TFR     D,Y    ;
C75C 5    35 06          PULS    D      ;
C75E Y    59             ROLB           ;
C75F      1C FE          ANDCC   #$FE   ;
C761 9    39             RTS            ;
->
C762      EC 81          LDD     ,X++   ;
C764      FD CC 0E       STD     $CC0E  ;
C767      A6 80          LDA     ,X+    ;
C769      B7 CC 10       STA     $CC10  ;
C76C   }  B6 C7 7D       LDA     $C77D  ;
C76F _    5F             CLRB           ;
C770      1F 01          TFR     D,X    ;
C772    ~ 10 BE C7 7E    LDY     $C77E  ;
C776 \    5C             INCB           ;
C777 ?    3F 11          SWI     #$11   ;
C779 9    39             RTS            ;
->
C77A 00 00 00 00 00 00 0F 03 45 6E 74 65 72 20 64 61 ........Enter da   ;
C78A 74 65 07 44 44 2C 4D 4D 2C 59 59 20 0E 04 0F 03 te.DD,MM,YY ....   ;
C79A 45 6E 74 65 72 20 74 69 6D 65 07 48 48 2C 4D 4D Enter time.HH,MM   ;
C7AA 20 0E 04                                         ..                ;
->
Routine:
C7AD   @  8E C8 40       LDX     #$C840 ;
C7B0      86 01          LDA     #$01   ;
C7B2      A7 84          STA     ,X     ;
C7B4      BD D4 06       JSR     $D406  ;
C7B7 '    27 0D          BEQ     $C7C6  ;
C7B9      A6 01          LDA     $01,X  ;
C7BB      81 04          CMPA    #$04   ;
C7BD '    27 06          BEQ     $C7C5  ;
->
C7BF      8E C7 E8       LDX     #$C7E8 ;
C7C2      BD CD 1E       JSR     $CD1E  ;
->
C7C5 9    39             RTS            ;
->
C7C6      10 8E C0 80    LDY     #$C080 ;
C7CA      10 BF CC 14    STY     $CC14  ;
C7CE      C6 80          LDB     #$80   ;
->
C7D0      BD D4 06       JSR     $D406  ;
C7D3 &    26 EA          BNE     $C7BF  ;
C7D5 Z    5A             DECB           ;
C7D6 '    27 E7          BEQ     $C7BF  ;
C7D8      A7 A0          STA     ,Y+    ;
C7DA      81 0D          CMPA    #$0D   ;
C7DC &    26 F2          BNE     $C7D0  ;
C7DE      86 04          LDA     #$04   ;
C7E0      A7 84          STA     ,X     ;
C7E2      BD D4 06       JSR     $D406  ;
C7E5 ~    7E CD 06       JMP     $CD06  ;
->
C7E8 0F 02 2A 2A 20 20 45 52 52 4F 52 20 20 2A 2A 20 ..**  ERROR  **    ;
C7F8 20 43 41 4E 4E 4F 54 20 52 55 4E 20 53 54 41 52  CANNOT RUN STAR   ;
C808 54 55 50 20 46 49 4C 45 0E 04 00 00 00 00 00 00 TUP FILE........   ;
C818 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 ................   ;
C828 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 ................   ;
C838 00 00 00 00 00 00 00 00 FF 00 00 00 53 54 41 52 ............STAR   ;
C848 54 55 50 53 54 58 54 00 00 00 00 00 00 00 00 00 TUPSTXT.........   ;
C858 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 ................   ;
C868 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 ................   ;
C878 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 ................   ;
C888 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 ................   ;
C898 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 ................   ;
C8A8 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 ................   ;
C8B8 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 ................   ;
C8C8 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 ................   ;
C8D8 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 ................   ;
C8E8 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 ................   ;
C8F8 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 ................   ;
C908 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 ................   ;
C918 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 ................   ;
C928 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 ................   ;
C938 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 ................   ;
C948 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 ................   ;
C958 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 ................   ;
C968 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 ................   ;
C978 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 ................   ;
C988 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 ................   ;
C998 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 ................   ;
C9A8 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 ................   ;
C9B8 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 ................   ;
C9C8 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 ................   ;
C9D8 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 ................   ;
C9E8 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 ................   ;
C9F8 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 ................   ;
CA08 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 ................   ;
CA18 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 ................   ;
CA28 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 ................   ;
CA38 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 ................   ;
CA48 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 ................   ;
CA58 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 ................   ;
CA68 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 ................   ;
CA78 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 ................   ;
CA88 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 ................   ;
CA98 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 ................   ;
CAA8 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 ................   ;
CAB8 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 ................   ;
CAC8 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 ................   ;
CAD8 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 ................   ;
CAE8 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 ................   ;
CAF8 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 ................   ;
CB08 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 ................   ;
CB18 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 ................   ;
CB28 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 ................   ;
CB38 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 ................   ;
CB48 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 ................   ;
CB58 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 ................   ;
CB68 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 ................   ;
CB78 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 ................   ;
CB88 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 ................   ;
CB98 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 ................   ;
CBA8 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 ................   ;
CBB8 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 ................   ;
CBC8 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 ................   ;
CBD8 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 ................   ;
CBE8 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 ................   ;
CBF8 00 00 00 00 00 00 00 00 

CC00 08									; FLEX TTYSET Backspace character
CC01 18									; FLEX TTYSET Delete character
CC02 3A									; FLEX TTYSET End of line character
CC03 00									; FLEX TTYSET Depth count (lines per page)
CC04 00									; FLEX TTYSET Width count
CC05 00									; FLEX TTYSET NULL count
CC06 00									; FLEX TTYSET Tab character
CC07 08									; FLEX TTYSET Backspace echo character
CC08 00 								; FLEX TTYSET Eject count
CC09 FF 								; FLEX TTYSET Pause control
CC0A 1B 								; FLEX TTYSET Escape character
CC0B 00									; FLEX System drive number
CC0C 00 								; FLEX Working drive number
CC0D 00 								; FLEX System scratch
CC0E 00 00 00 							; FLEX System date registers
CC11 00 								; FLEX Last terminator
CC12 00 00 								; FLEX User command table address (or NULL if not used)
CC14 00 00 								; FLEX Line buffer pointer
CC16 00 00								; FLEX Escape return register
CC18 00 								; FLEX Current character 
CC19 00 								; FLEX Previous character
CC1A 00 								; FLEX Current line number
CC1B 00 00 								; FLEX Loader address offset
CC1D 00 								; FLEX Transfer flag
CC1E 00 00 								; FLEX Transfer address
CC20 00 								; FLEX Error type
CC21 00 								; FLEX Special I/O flag
CC22 00 								; FLEX Output switch
CC23 00 								; FLEX Input switch
CC24 00 00 								; FLEX File output address
CC26 00 00								; FLEX File input address
CC28 00 								; FLEX Command flag
CC29 00 								; FLEX Current output column
CC2A 00 								; FLEX System scratch
CC2B BF FF 								; FLEX Memory end ($BFFF)
CC2D 00 00 								; FLEX Error name vector
CC2F 01 								; FLEX file imput echo flag
CC30 00 CC D9 							; FLEX System scratch
CC33 00 								; FLEX CPU type flag (0=unknown)
->
CC34 00 
->
CC35 00 00 								; FLEX Reserved printer area pointer
CC37 00 00 								; FLEX Printer area length
->
CC39 00 00 00 
->
CC3C 00 00 00 00 00 00 00 00 00 00 00 00 		; FLEX $CC3C-$CCBF System constants
CC48 00 60 00 00 00 00 00 0F 03 44 4F 53 0E 0D 0A 1E .`.......DOS....   ;
CC58 04 0F 02 0E 04 0F 02 57 48 41 54 3F 0E 04 0F 02 .......WHAT?....   ;
CC68 43 41 4E 27 54 20 54 52 41 4E 53 46 45 52 0E 04 CAN'T TRANSFER..   ;
CC78 45 52 52 4F 52 53 00 00 53 59 53 0F 02 52 45 51 ERRORS..SYS..REQ   ;
CC88 55 45 53 54 45 44 20 46 49 4C 45 20 49 4E 20 55 UESTED FILE IN U   ;
CC98 53 45 04 0F 02 46 49 4C 45 20 41 4C 52 45 41 44 SE...FILE ALREAD   ;
CCA8 59 20 45 58 49 53 54 53 04 47 45 54 00 D1 44 00 Y EXISTS.GET..D.   ;
CCB8 27 10 03 E8 00 64 00 
->
CCC0 0A 39 0F 02 46 49 4C 45 20                      .9..FILE    ;			FLEX $CCC0-$CCD7 Printer initialize
CCC8 44 4F 45 53 20 4E 4F 54 20 45 58 49 53 54 04 00 DOES NOT EXIST..   ;
->
CCD8 39 01 00 00 00 00 00 00 00 00 00 00 39 0F 02 44 9...........9..D   ;	FLEX $CCD8-$CCE7 Printer ready check
->
CCE8 49 53 4B 20 44 52 49 56 45 20 00 20 4E 4F 54 20 ISK DRIVE . NOT    ;   FLEX $CCE4-$CCF7 Printer output
CCF8 52 45 41 44 59 0E 04 00                         READY...           ;	FLEX $CCF8-$CCF7 System Scratch
->
Routine:
CD00 ~ i  7E CD 69       JMP     $CD69  ;		FLEX (COLDS) Cold Start
->
CD03 ~ }  7E CD 7D       JMP     $CD7D  ;		FLEX (WARMS) Warm Start
->
CD06 ~    7E CD C5       JMP     $CDC5  ;		FLEX (RENTER) DOS main loop re-entry point
->
CD09 ~    7E D3 AB       JMP     $D3AB  ;		FLEX (INCH) Input character
->
CD0C ~    7E D3 AB       JMP     $D3AB  ;		FLEX (INCH2) Input character
->
CD0F ~    7E D3 B1       JMP     $D3B1  ;		FLEX (OUTCH) Output character
->
CD12 ~    7E D3 B1       JMP     $D3B1  ;		FLEX (OUTCH2) Output character
->
CD15      7E CE D0       JMP     $CED0  ;		FLEX (GETCHR) Get character
-> 
CD18      7E CF 16       JMP     $CF16  ;		FLEX (PUTCHR) Put character
->
CD1B ~ B  7E CE 42       JMP     $CE42  ;		FLEX (INBUFF) Input into line buffer
->
CD1E ~    7E CE 81       JMP     $CE81  ;		FLEX (PSTRING) Print string
->
CD21      7E CF C2       JMP     $CFC2	;		FLEX (CLASS) Classify character
->
CD24 ~    7E CE 90       JMP     $CE90  ;		FLEX (PCRLF) Print CR/LF
->
CD27      7E CF E3       JMP     $CFE3  ; 		FLEX (NXTCH) Get Next Buffer Character
->
CD2A      7E CE 01       JMP     $CE01  ; 		FLEX (RSTRIO) Restore I/O vector
->
CD2D      7E D0 0B       JMP     $D00B  ;       FLEX (GETFIL) Get file specification
->
CD30      7E D8 6C       JMP     $D8C6	;		FLEX (LOAD) File loader
->
CD33      7E D0 B2       JMP     $D0B2	;		FLEX (SETEXT) Set Extension
->
CD36      7E D3 94       JMP     $D394	;		FLEX (ADDBX) Add B-register to X-Register
->
CD39      7E CF 5B       JMP     $CF5B	;		FLEX (OUTDEC) Output decimal number
->
CD3C      7E CF A9       JMP     $CFA9	;		FLEX (OUTHEX) Output hexidecimal number
->
CD3F      7E D2 AA       JMP     $D2AA	;		FLEX (RPTERR) Report error
->
CD42      7E D0 D2       JMP     $D0D2	;		FLEX (GETHEX) Get hexadecimal number
->
CD45      7E CF A5       JMP     $CFA5	;		FLEX (OUTADR) Output hexadecimal address
->
CD48 ~    7E D1 18       JMP     $D118  ;		FLEX (INDEX) Input decimal number
->
CD4B      7E D3 6E       JMP     $D36E	;		FLEX (DOCMND) Call DOS as a subroutine
->
CD4E      7E D3 B8       JMP     $D3B8	;		FLEX (STAT) Check terminal input status
->
CD51      7E CE 1C       JMP     $CE1C	;
->
CD54      7E CE 1C       JMP     $CE1C	;
->
CD57      7E CD 5D       JMP     $CD5D	;
->
CD5A      7E D8 26       JMP     $D826	;
->
CD5D      7F CC 11       JMP     $CC11	;
->
CD60      BD D4 00       JSR     $D400	;
->
CD63      7F CC 28       JMP     $CC28	;
->
CD66      7E D3 FD       JMP     $D3FD	;
->
CD69      BD C7 AD       JSR     $C7AD  ;
CD6C      86 8C          LDA     #$8C   ;
CD6E   i  B7 CD 69       STA     $CD69  ;
CD71      7F CC 11       CLR     $CC11  ;
CD74      BD D4 00       JSR     $D400  ;
CD77   (  7F CC 28       CLR     $CC28  ;
CD7A      BD D3 FD       JSR     $D3FD  ;
->
CD7D      10 CE C0 80    LDS     #$C080 ;
CD81      8E CC D9       LDX     #$CCD9 ;
CD84   1  BF CC 31       STX     $CC31  ;
CD87   4  7F CC 34       CLR     $CC34  ;
CD8A   L  7F CC 4C       CLR     $CC4C  ;
CD8D  r   8D 72          BSR     $CE01  ;
CD8F      B6 CC 11       LDA     $CC11  ;
CD92      B1 CC 02       CMPA    $CC02  ;
CD95 &    26 05          BNE     $CD9C  ;
CD97 |    7C CC 15       INC     $CC15  ;
CD9A  )   20 29          BRA     $CDC5  ;
->
CD9C } (  7D CC 28       TST     $CC28  ;
CD9F  &   10 26 05 E3    LBNE    $D386  ;
CDA3 ?    3F 1A          SWI     #$1A   ;
CDA5      CC D3 98       LDD     #$D398 ;
CDA8      FD DF CC       STD     $DFCC  ;
CDAB      CC BF FF       LDD     #$BFFF ;
CDAE   +  FD CC 2B       STD     $CC2B  ;
CDB1   }  CC CD 7D       LDD     #$CD7D ;
CDB4      FD CC 16       STD     $CC16  ;
CDB7      BD D4 03       JSR     $D403  ;
CDBA   O  8E CC 4F       LDX     #$CC4F ;
CDBD      BD CE 81       JSR     $CE81  ;
CDC0 | N  7C CC 4E       INC     $CC4E  ;
CDC3  }   8D 7D          BSR     $CE42  ;
->
CDC5      BD D0 9B       JSR     $D09B  ;
CDC8      81 20          CMPA    #$20   ;
CDCA %    25 D0          BCS     $CD9C  ;
CDCC      BE CC 14       LDX     $CC14  ;
CDCF   =  BF CC 3D       STX     $CC3D  ;
CDD2   @  8E C8 40       LDX     #$C840 ;
CDD5      BD D0 0B       JSR     $D00B  ;
CDD8 %    25 16          BCS     $CDF0  ;
CDDA      8E CC B1       LDX     #$CCB1 ;
CDDD  >   8D 3E          BSR     $CE1D  ;
CDDF '    27 09          BEQ     $CDEA  ;
CDE1      BE CC 12       LDX     $CC12  ;
CDE4 '    27 07          BEQ     $CDED  ;
CDE6  5   8D 35          BSR     $CE1D  ;
CDE8 &    26 03          BNE     $CDED  ;
->
CDEA n    6E 98 01       JMP     [$01,X];
->
CDED   c  BD D1 63       JSR     $D163  ;
->
CDF0   ]  8E CC 5D       LDX     #$CC5D ;
CDF3      86 15          LDA     #$15   ;
->
CDF5      B7 CC 20       STA     $CC20  ;
CDF8      BD CE 81       JSR     $CE81  ;
->
CDFB      7F CC 11       CLR     $CC11  ;
CDFE ~ }  7E CD 7D       JMP     $CD7D  ;
->
Routine:
CE01      BE CD 13       LDX     $CD13  ;
CE04      BF CD 10       STX     $CD10  ;
CE07      BE CD 0D       LDX     $CD0D  ;
CE0A      BF CD 0A       STX     $CD0A  ;
CE0D   #  7F CC 23       CLR     $CC23  ;
CE10   "  7F CC 22       CLR     $CC22  ;
CE13   !  7F CC 21       CLR     $CC21  ;
CE16   &  7F CC 26       CLR     $CC26  ;
CE19   $  7F CC 24       CLR     $CC24  ;
CE1C 9    39             RTS            ;
->
Routine:
CE1D    D 10 8E C8 44    LDY     #$C844 ;
->
CE21      A6 A0          LDA     ,Y+    ;
CE23  _   81 5F          CMPA    #$5F   ;
CE25 #    23 02          BLS     $CE29  ;
CE27      80 20          SUBA    #$20   ;
->
CE29      A1 80          CMPA    ,X+    ;
CE2B &    26 08          BNE     $CE35  ;
CE2D m    6D 84          TST     ,X     ;
CE2F &    26 F0          BNE     $CE21  ;
CE31 m    6D A4          TST     ,Y     ;
CE33 '    27 0C          BEQ     $CE41  ;
->
CE35 m    6D 80          TST     ,X+    ;
CE37 &    26 FC          BNE     $CE35  ;
CE39 0    30 02          LEAX    $02,X  ;
CE3B m    6D 84          TST     ,X     ;
CE3D &    26 DE          BNE     $CE1D  ;
CE3F      1C FB          ANDCC   #$FB   ;
->
CE41 9    39             RTS            ;
->
Routine:
CE42 4    34 20          PSHS    Y      ;
CE44      C6 1F          LDB     #$1F   ;
CE46      8E C0 80       LDX     #$C080 ;
CE49      10 8E 00 80    LDY     #$0080 ;
CE4D      BF CC 14       STX     $CC14  ;
->
CE50 ?    3F 02          SWI     #$02   ;
CE52      C1 0D          CMPB    #$0D   ;
CE54 ')   27 29          BEQ     $CE7F  ;
->
CE56 ?    3F 01          SWI     #$01   ;
CE58      C1 14          CMPB    #$14   ;
CE5A &    26 14          BNE     $CE70  ;
CE5C } N  7D CC 4E       TST     $CC4E  ;
CE5F '    27 F5          BEQ     $CE56  ;
CE61   N  7F CC 4E       CLR     $CC4E  ;
->
CE64      E6 80          LDB     ,X+    ;
CE66      C4 7F          ANDB    #$7F   ;
CE68      C1 0D          CMPB    #$0D   ;
CE6A '    27 EA          BEQ     $CE56  ;
CE6C ?    3F 02          SWI     #$02   ;
CE6E      20 F4          BRA     $CE64  ;
->
CE70   N  7F CC 4E       CLR     $CC4E  ;
CE73      C1 18          CMPB    #$18   ;
CE75 %    25 D9          BCS     $CE50  ;
CE77      C1 19          CMPB    #$19   ;
CE79 "    22 D5          BHI     $CE50  ;
CE7B      C0 0E          SUBB    #$0E   ;
CE7D      20 D1          BRA     $CE50  ;
->
CE7F 5    35 A0          PULS    PC,Y   ;
->
Routine:
CE81      8D 0D          BSR     $CE90  ;
->
Routine:
CE83      A6 84          LDA     ,X     ;
CE85      81 04          CMPA    #$04   ;
CE87 'D   27 44          BEQ     $CECD  ;
CE89      BD CF 16       JSR     $CF16  ;
CE8C 0    30 01          LEAX    $01,X  ;
CE8E      20 F3          BRA     $CE83  ;
->
Routine:
CE90 } !  7D CC 21       TST     $CC21  ;
CE93 &    26 1E          BNE     $CEB3  ;
CE95      B6 CC 03       LDA     $CC03  ;
CE98 '    27 19          BEQ     $CEB3  ;
CE9A      B1 CC 1A       CMPA    $CC1A  ;
CE9D "    22 11          BHI     $CEB0  ;
CE9F      7F CC 1A       CLR     $CC1A  ;
CEA2 4    34 04          PSHS    B      ;
CEA4      F6 CC 08       LDB     $CC08  ;
CEA7 '    27 05          BEQ     $CEAE  ;
->
CEA9      8D 08          BSR     $CEB3  ;
CEAB Z    5A             DECB           ;
CEAC &    26 FB          BNE     $CEA9  ;
->
CEAE 5    35 04          PULS    B      ;
->
CEB0 |    7C CC 1A       INC     $CC1A  ;
->
Routine:
CEB3 ?    3F 04          SWI     #$04   ;
CEB5 4    34 10          PSHS    X      ;
CEB7   T  8E CC 54       LDX     #$CC54 ;
CEBA      8D C7          BSR     $CE83  ;
CEBC 5    35 10          PULS    X      ;
CEBE 4    34 04          PSHS    B      ;
CEC0      F6 CC 05       LDB     $CC05  ;
CEC3 '    27 06          BEQ     $CECB  ;
->
CEC5 O    4F             CLRA           ;
CEC6  N   8D 4E          BSR     $CF16  ;
CEC8 Z    5A             DECB           ;
CEC9 &    26 FA          BNE     $CEC5  ;
->
CECB 5    35 04          PULS    B      ;
->
CECD      1C FE          ANDCC   #$FE   ;
CECF 9    39             RTS            ;
->
Routine:
CED0 } #  7D CC 23       TST     $CC23  ;
CED3 &    26 1A          BNE     $CEEF  ;
CED5 } &  7D CC 26       TST     $CC26  ;
CED8 '    27 10          BEQ     $CEEA  ;
CEDA      8D 1A          BSR     $CEF6  ;
CEDC } /  7D CC 2F       TST     $CC2F  ;
CEDF '    27 11          BEQ     $CEF2  ;
CEE1 } $  7D CC 24       TST     $CC24  ;
CEE4 '    27 0C          BEQ     $CEF2  ;
CEE6  S   8D 53          BSR     $CF3B  ;
CEE8      20 08          BRA     $CEF2  ;
->
CEEA      BD CD 09       JSR     $CD09  ;
CEED      20 03          BRA     $CEF2  ;
->
CEEF      BD CD 0C       JSR     $CD0C  ;
->
CEF2      7F CC 1A       CLR     $CC1A  ;
CEF5 9    39             RTS            ;
->
Routine:
CEF6   G  BF CC 47       STX     $CC47  ;
CEF9   &  BE CC 26       LDX     $CC26  ;
CEFC      20 06          BRA     $CF04  ;
->
Routine:
CEFE   G  BF CC 47       STX     $CC47  ;
CF01   $  BE CC 24       LDX     $CC24  ;
->
CF04      BD D4 06       JSR     $D406  ;
CF07 &    26 04          BNE     $CF0D  ;
CF09   G  BE CC 47       LDX     $CC47  ;
CF0C 9    39             RTS            ;
->
CF0D   $  7F CC 24       CLR     $CC24  ;
CF10      BD D2 AA       JSR     $D2AA  ;
CF13 ~    7E CD 03       JMP     $CD03  ;
->
Routine:
CF16 } !  7D CC 21       TST     $CC21  ;
CF19 &    26 20          BNE     $CF3B  ;
CF1B      81 1F          CMPA    #$1F   ;
CF1D "    22 05          BHI     $CF24  ;
CF1F   )  7F CC 29       CLR     $CC29  ;
CF22      20 17          BRA     $CF3B  ;
->
CF24 | )  7C CC 29       INC     $CC29  ;
CF27 4    34 02          PSHS    A      ;
CF29      B6 CC 04       LDA     $CC04  ;
CF2C '    27 0B          BEQ     $CF39  ;
CF2E   )  B1 CC 29       CMPA    $CC29  ;
CF31 $    24 06          BCC     $CF39  ;
CF33      BD CE 90       JSR     $CE90  ;
CF36 | )  7C CC 29       INC     $CC29  ;
->
CF39 5    35 02          PULS    A      ;
->
Routine:
CF3B 4    34 02          PSHS    A      ;
CF3D } "  7D CC 22       TST     $CC22  ;
CF40 &    26 13          BNE     $CF55  ;
CF42 } $  7D CC 24       TST     $CC24  ;
CF45 '    27 04          BEQ     $CF4B  ;
CF47      8D B5          BSR     $CEFE  ;
CF49      20 0D          BRA     $CF58  ;
->
CF4B } &  7D CC 26       TST     $CC26  ;
CF4E &    26 08          BNE     $CF58  ;
CF50      BD CD 0F       JSR     $CD0F  ;
CF53      20 03          BRA     $CF58  ;
->
CF55      BD CD 12       JSR     $CD12  ;
->
CF58 5    35 02          PULS    A      ;
CF5A 9    39             RTS            ;
->
Routine:
CF5B   J  7F CC 4A       CLR     $CC4A  ;
CF5E      F7 CC 1D       STB     $CC1D  ;
CF61      86 04          LDA     #$04   ;
CF63   M  B7 CC 4D       STA     $CC4D  ;
CF66      EC 84          LDD     ,X     ;
CF68      8E CC B8       LDX     #$CCB8 ;
->
CF6B      8D 0B          BSR     $CF78  ;
CF6D 0    30 02          LEAX    $02,X  ;
CF6F z M  7A CC 4D       DEC     $CC4D  ;
CF72 &    26 F7          BNE     $CF6B  ;
CF74      1F 98          TFR     B,A    ;
CF76  =   20 3D          BRA     $CFB5  ;
->
Routine:
CF78   K  7F CC 4B       CLR     $CC4B  ;
->
CF7B      10 A3 84       CMPD    ,X     ;
CF7E %    25 07          BCS     $CF87  ;
CF80      A3 84          SUBD    ,X     ;
CF82 | K  7C CC 4B       INC     $CC4B  ;
CF85      20 F4          BRA     $CF7B  ;
->
CF87 4    34 02          PSHS    A      ;
CF89   K  B6 CC 4B       LDA     $CC4B  ;
CF8C &    26 10          BNE     $CF9E  ;
CF8E } J  7D CC 4A       TST     $CC4A  ;
CF91 &    26 0B          BNE     $CF9E  ;
CF93 }    7D CC 1D       TST     $CC1D  ;
CF96 '    27 0B          BEQ     $CFA3  ;
CF98      86 20          LDA     #$20   ;
CF9A  #   8D 23          BSR     $CFBF  ;
CF9C      20 05          BRA     $CFA3  ;
->
CF9E | J  7C CC 4A       INC     $CC4A  ;
CFA1      8D 12          BSR     $CFB5  ;
->
CFA3 5    35 82          PULS    PC,A   ;
CFA5      8D 02          BSR     $CFA9  ;
CFA7 0    30 01          LEAX    $01,X  ;
->
Routine:
CFA9      A6 84          LDA     ,X     ;
CFAB      8D 04          BSR     $CFB1  ;
CFAD      A6 84          LDA     ,X     ;
CFAF      20 04          BRA     $CFB5  ;
->
Routine:
CFB1 D    44             LSRA           ;
CFB2 D    44             LSRA           ;
CFB3 D    44             LSRA           ;
CFB4 D    44             LSRA           ;
->
Routine:
CFB5      84 0F          ANDA    #$0F   ;
CFB7  0   8B 30          ADDA    #$30   ;
CFB9  9   81 39          CMPA    #$39   ;
CFBB #    23 02          BLS     $CFBF  ;
CFBD      8B 07          ADDA    #$07   ;
->
Routine:
CFBF ~    7E CF 16       JMP     $CF16  ;
->
Routine:
CFC2  0   81 30          CMPA    #$30   ;
CFC4 %    25 14          BCS     $CFDA  ;
CFC6  9   81 39          CMPA    #$39   ;
CFC8 #    23 16          BLS     $CFE0  ;
CFCA  A   81 41          CMPA    #$41   ;
CFCC %    25 0C          BCS     $CFDA  ;
CFCE  Z   81 5A          CMPA    #$5A   ;
CFD0 #    23 0E          BLS     $CFE0  ;
CFD2  a   81 61          CMPA    #$61   ;
CFD4 %    25 04          BCS     $CFDA  ;
CFD6  z   81 7A          CMPA    #$7A   ;
CFD8 #    23 06          BLS     $CFE0  ;
->
CFDA      1A 01          ORCC    #$01   ;
CFDC      B7 CC 11       STA     $CC11  ;
CFDF 9    39             RTS            ;
->
CFE0      1C FE          ANDCC   #$FE   ;
CFE2 9    39             RTS            ;
->
Routine:
CFE3 4    34 10          PSHS    X      ;
CFE5      BE CC 14       LDX     $CC14  ;
CFE8      B6 CC 18       LDA     $CC18  ;
CFEB      B7 CC 19       STA     $CC19  ;
->
CFEE      A6 80          LDA     ,X+    ;
CFF0      B7 CC 18       STA     $CC18  ;
CFF3      81 0D          CMPA    #$0D   ;
CFF5 '    27 10          BEQ     $D007  ;
CFF7      B1 CC 02       CMPA    $CC02  ;
CFFA '    27 0B          BEQ     $D007  ;
CFFC      BF CC 14       STX     $CC14  ;
CFFF      81 20          CMPA    #$20   ;
D001 &    26 04          BNE     $D007  ;
D003      A1 84          CMPA    ,X     ;
D005 '    27 E7          BEQ     $CFEE  ;
->
D007      8D B9          BSR     $CFC2  ;
D009 5    35 90          PULS    PC,X   ;
->
Routine:
D00B      86 15          LDA     #$15   ;
D00D      A7 01          STA     $01,X  ;
D00F      86 FF          LDA     #$FF   ;
D011      A7 03          STA     $03,X  ;
D013 o    6F 04          CLR     $04,X  ;
D015 o    6F 0C          CLR     $0C,X  ;
D017      BD D0 9B       JSR     $D09B  ;
D01A      86 08          LDA     #$08   ;
D01C   K  B7 CC 4B       STA     $CC4B  ;
D01F  '   8D 27          BSR     $D048  ;
D021 %!   25 21          BCS     $D044  ;
D023 &    26 0F          BNE     $D034  ;
D025  !   8D 21          BSR     $D048  ;
D027 %    25 1B          BCS     $D044  ;
D029 &    26 09          BNE     $D034  ;
D02B   ?  BC CC 3F       CMPX    $CC3F  ;
D02E '^   27 5E          BEQ     $D08E  ;
D030      8D 16          BSR     $D048  ;
D032 #Z   23 5A          BLS     $D08E  ;
->
D034   ?  BE CC 3F       LDX     $CC3F  ;
D037 m    6D 04          TST     $04,X  ;
D039 'S   27 53          BEQ     $D08E  ;
D03B m    6D 03          TST     $03,X  ;
D03D *    2A 05          BPL     $D044  ;
D03F      B6 CC 0C       LDA     $CC0C  ;
D042      A7 03          STA     $03,X  ;
->
D044   ?  BE CC 3F       LDX     $CC3F  ;
D047 9    39             RTS            ;
->
Routine:
D048      8D 99          BSR     $CFE3  ;
D04A %B   25 42          BCS     $D08E  ;
D04C  9   81 39          CMPA    #$39   ;
D04E "    22 14          BHI     $D064  ;
D050   ?  BE CC 3F       LDX     $CC3F  ;
D053 m    6D 03          TST     $03,X  ;
D055 *7   2A 37          BPL     $D08E  ;
D057      84 03          ANDA    #$03   ;
D059      A7 03          STA     $03,X  ;
D05B      8D 86          BSR     $CFE3  ;
D05D $/   24 2F          BCC     $D08E  ;
->
D05F  .   81 2E          CMPA    #$2E   ;
D061      1C FE          ANDCC   #$FE   ;
D063 9    39             RTS            ;
->
D064   K  F6 CC 4B       LDB     $CC4B  ;
D067 +%   2B 25          BMI     $D08E  ;
D069 4    34 04          PSHS    B      ;
D06B      C0 05          SUBB    #$05   ;
D06D   K  F7 CC 4B       STB     $CC4B  ;
D070 5    35 04          PULS    B      ;
->
D072   I  B1 CC 49       CMPA    $CC49  ;
D075 %    25 02          BCS     $D079  ;
D077      80 20          SUBA    #$20   ;
->
D079      A7 04          STA     $04,X  ;
D07B 0    30 01          LEAX    $01,X  ;
D07D Z    5A             DECB           ;
D07E      BD CF E3       JSR     $CFE3  ;
D081 $    24 08          BCC     $D08B  ;
D083  -   81 2D          CMPA    #$2D   ;
D085 '    27 04          BEQ     $D08B  ;
D087  _   81 5F          CMPA    #$5F   ;
D089 &    26 06          BNE     $D091  ;
->
D08B ]    5D             TSTB           ;
D08C &    26 E4          BNE     $D072  ;
->
D08E      1A 01          ORCC    #$01   ;
D090 9    39             RTS            ;
->
D091 ]    5D             TSTB           ;
D092 '    27 CB          BEQ     $D05F  ;
D094 o    6F 04          CLR     $04,X  ;
D096 0    30 01          LEAX    $01,X  ;
D098 Z    5A             DECB           ;
D099      20 F6          BRA     $D091  ;
->
Routine:
D09B   ?  BF CC 3F       STX     $CC3F  ;
D09E      BE CC 14       LDX     $CC14  ;
->
D0A1      A6 84          LDA     ,X     ;
D0A3      81 20          CMPA    #$20   ;
D0A5 &    26 04          BNE     $D0AB  ;
D0A7 0    30 01          LEAX    $01,X  ;
D0A9      20 F6          BRA     $D0A1  ;
->
D0AB      BF CC 14       STX     $CC14  ;
D0AE   ?  BE CC 3F       LDX     $CC3F  ;
D0B1 9    39             RTS            ;
->
Routine:
D0B2 40   34 30          PSHS    Y,X    ;
D0B4      E6 0C          LDB     $0C,X  ;
D0B6 &    26 18          BNE     $D0D0  ;
D0B8    G 10 8E D8 47    LDY     #$D847 ;
D0BC      81 0B          CMPA    #$0B   ;
D0BE "    22 10          BHI     $D0D0  ;
D0C0      C6 03          LDB     #$03   ;
D0C2 =    3D             MUL            ;
D0C3 1    31 A5          LEAY    B,Y    ;
D0C5      C6 03          LDB     #$03   ;
->
D0C7      A6 A0          LDA     ,Y+    ;
D0C9      A7 0C          STA     $0C,X  ;
D0CB 0    30 01          LEAX    $01,X  ;
D0CD Z    5A             DECB           ;
D0CE &    26 F7          BNE     $D0C7  ;
->
D0D0 5    35 B0          PULS    PC,Y,X ;
D0D2   S  BD D1 53       JSR     $D153  ;
->
D0D5      BD CF E3       JSR     $CFE3  ;
D0D8 %"   25 22          BCS     $D0FC  ;
D0DA  &   8D 26          BSR     $D102  ;
D0DC %    25 18          BCS     $D0F6  ;
D0DE 4    34 04          PSHS    B      ;
D0E0      C6 04          LDB     #$04   ;
->
D0E2 x    78 CC 1C       ASL     $CC1C  ;
D0E5 y    79 CC 1B       ROL     $CC1B  ;
D0E8 Z    5A             DECB           ;
D0E9 &    26 F7          BNE     $D0E2  ;
D0EB 5    35 04          PULS    B      ;
D0ED      BB CC 1C       ADDA    $CC1C  ;
D0F0      B7 CC 1C       STA     $CC1C  ;
D0F3 \    5C             INCB           ;
D0F4      20 DF          BRA     $D0D5  ;
->
D0F6      BD CF E3       JSR     $CFE3  ;
D0F9 $    24 FB          BCC     $D0F6  ;
D0FB 9    39             RTS            ;
->
D0FC      BE CC 1B       LDX     $CC1B  ;
D0FF      1C FE          ANDCC   #$FE   ;
D101 9    39             RTS            ;
->
Routine:
D102  G   80 47          SUBA    #$47   ;
D104 *    2A 0F          BPL     $D115  ;
D106      8B 06          ADDA    #$06   ;
D108 *    2A 04          BPL     $D10E  ;
D10A      8B 07          ADDA    #$07   ;
D10C *    2A 07          BPL     $D115  ;
->
D10E      8B 0A          ADDA    #$0A   ;
D110 +    2B 03          BMI     $D115  ;
D112      1C FE          ANDCC   #$FE   ;
D114 9    39             RTS            ;
->
D115      1A 01          ORCC    #$01   ;
D117 9    39             RTS            ;
->
D118  9   8D 39          BSR     $D153  ;
->
D11A      BD CF E3       JSR     $CFE3  ;
D11D %    25 DD          BCS     $D0FC  ;
D11F  9   81 39          CMPA    #$39   ;
D121 "    22 D3          BHI     $D0F6  ;
D123      84 0F          ANDA    #$0F   ;
D125 4    34 04          PSHS    B      ;
D127 4    34 02          PSHS    A      ;
D129      FC CC 1B       LDD     $CC1B  ;
D12C X    58             ASLB           ;
D12D I    49             ROLA           ;
D12E X    58             ASLB           ;
D12F I    49             ROLA           ;
D130 X    58             ASLB           ;
D131 I    49             ROLA           ;
D132      F3 CC 1B       ADDD    $CC1B  ;
D135      F3 CC 1B       ADDD    $CC1B  ;
D138      EB E0          ADDB    ,S+    ;
D13A      89 00          ADCA    #$00   ;
D13C      FD CC 1B       STD     $CC1B  ;
D13F 5    35 04          PULS    B      ;
D141 \    5C             INCB           ;
D142      20 D6          BRA     $D11A  ;
->
D144 4F 8D 40 25 10 8D 08 7C CC 4C 17 07 1B 20 F1    O.@%...|.L... .    ;
->
Routine:
D153 O    4F             CLRA           ;
D154 _    5F             CLRB           ;
D155      FD CC 1B       STD     $CC1B  ;
D158 9    39             RTS            ;
->
D159 F6 CC 4C 10 27 FC 90 7E CD 03                   ..L.'..~..         ;
->
Routine:
D163      86 02          LDA     #$02   ;
D165  ,   8D 2C          BSR     $D193  ;
D167      8D EA          BSR     $D153  ;
D169   l  BD D8 6C       JSR     $D86C  ;
D16C      F6 CC 1D       LDB     $CC1D  ;
D16F '    27 0E          BEQ     $D17F  ;
D171      F6 CC 11       LDB     $CC11  ;
D174  ;   C1 3B          CMPB    #$3B   ;
D176 &    26 03          BNE     $D17B  ;
D178   S  BD D2 53       JSR     $D253  ;
->
D17B n    6E 9F CC 1E    JMP     [$CC1E];
->
D17F   f  8E CC 66       LDX     #$CC66 ;
D182      86 81          LDA     #$81   ;
D184 ~    7E CD F5       JMP     $CDF5  ;
->
D187 34 02 8E C8 40 BD D0 0B 35 02 25 24             4...@...5.%$       ;
->
Routine:
D193   @  8E C8 40       LDX     #$C840 ;
D196      BD D0 B2       JSR     $D0B2  ;
D199   @  8E C8 40       LDX     #$C840 ;
D19C      86 01          LDA     #$01   ;
D19E      A7 84          STA     ,X     ;
D1A0      BD D8 F0       JSR     $D8F0  ;
D1A3 %    25 0C          BCS     $D1B1  ;
D1A5      A6 0F          LDA     $0F,X  ;
D1A7      85 04          BITA    #$04   ;
D1A9 &    26 1D          BNE     $D1C8  ;
D1AB      86 FF          LDA     #$FF   ;
D1AD   ;  A7 88 3B       STA     $3B,X  ;
D1B0 9    39             RTS            ;
->
D1B1      BD D2 AA       JSR     $D2AA  ;
D1B4 ~    7E CD FB       JMP     $CDFB  ;
->
D1B7 B6 CC 11 81 0D 27 07 B1 CC 02 10 26 FC 2B 1A 01 .....'.....&.+..   ;
D1C7 39                                              9                  ;
->
D1C8      86 04          LDA     #$04   ;
D1CA      A7 84          STA     ,X     ;
D1CC      BD D4 06       JSR     $D406  ;
D1CF &    26 E0          BNE     $D1B1  ;
D1D1   *  7F CC 2A       CLR     $CC2A  ;
D1D4      FC DF CC       LDD     $DFCC  ;
D1D7 4    34 06          PSHS    D      ;
D1D9   ;  CC D2 3B       LDD     #$D23B ;
D1DC      FD DF CC       STD     $DFCC  ;
D1DF      FC DF F4       LDD     $DFF4  ;		? user's initials ?
D1E2      FD C1 00       STD     $C100  ;
D1E5   =  FC CC 3D       LDD     $CC3D  ;
D1E8      FD C1 02       STD     $C102  ;
D1EB      B6 CC 0C       LDA     $CC0C  ;			working drive number
D1EE      B7 C1 04       STA     $C104  ;
->
D1F1      8E C0 80       LDX     #$C080 ;			start address of message
D1F4      10 8E 00 85    LDY     #$0085 ;			length of message (C080-C105)
D1F8      C6 07          LDB     #$07   ;			message type
D1FA ?+   3F 2B          SWI     #$2B   ;			send command to server
D1FC $    24 05          BCC     $D203  ;
D1FE      BD D7 13       JSR     $D713  ;
D201      20 EE          BRA     $D1F1  ;
->
D203      BD D7 05       JSR     $D705  ;
->
D206      8E C1 00       LDX     #$C100 ;			start address of message
D209      10 8E 01 00    LDY     #$0100 ;			max message length
D20D ?,   3F 2C          SWI     #$2C   ;			get a reply from the server
D20F $    24 06          BCC     $D217  ;
D211      81 02          CMPA    #$02   ;
D213 '    27 F1          BEQ     $D206  ;
D215  !   20 21          BRA     $D238  ;
->
D217      C1 07          CMPB    #$07   ;
D219 '    27 0F          BEQ     $D22A  ;
D21B      E6 80          LDB     ,X+    ;
D21D      C1 0A          CMPB    #$0A   ;
D21F $    24 E5          BCC     $D206  ;
D221 X    58             ASLB           ;
D222    ? 10 8E D2 3F    LDY     #$D23F ;
D226      AD B5          JSR     [B,Y]  ;
D228      20 DC          BRA     $D206  ;
->
D22A 5    35 06          PULS    D      ;
D22C      FD DF CC       STD     $DFCC  ;
D22F      EC 01          LDD     $01,X  ;
D231      FD CC 14       STD     $CC14  ;
D234 O    4F             CLRA           ;
D235      B7 CC 20       STA     $CC20  ;
->
D238 ~    7E CD 03       JMP     $CD03  ;
->
D23B 7C CC 2A 3B D2 59 D2 67 D2 7A CE 83 D2 6D D2 75 |.*;.Y.g.z...m.u   ;
D24B CF A9 CF A5 D2 53 D2 A7                         .....S..           ;
->
Routine:
D253   -  8E D8 2D       LDX     #$D82D ;
D256      BD CE 81       JSR     $CE81  ;
D259      BD CE D0       JSR     $CED0  ;
D25C      8E C1 00       LDX     #$C100 ;
D25F      A7 84          STA     ,X     ;
D261      10 8E 00 01    LDY     #$0001 ;
D265  .   20 2E          BRA     $D295  ;
->
D267 A6 84 BD CF 16 39 BD CD 24 B6 CC 2A 20 E7 E6 80 .....9..$..* ...   ;
D277 7E CF 5B BD CE 42 10 8E C0 80 8E C1 00 EC A1 ED ~.[..B..........   ;
D287 81 10 8C C1 00 25 F6 8E C1 00 10 8E 00 80       .....%........     ;
->
D295      C6 13          LDB     #$13   ;
D297 ?+   3F 2B          SWI     #$2B   ;
D299 9    39             RTS            ;
->
D29A 44 49 53 4B 20 45 52 52 4F 52 20 5F 04 8E C1 00 DISK ERROR _....   ;
->
Routine:
D2AA 40   34 30          PSHS    Y,X    ;
D2AC      A6 01          LDA     $01,X  ;
D2AE      B7 CC 20       STA     $CC20  ;
D2B1 'o   27 6F          BEQ     $D322  ;
D2B3      BD CE 01       JSR     $CE01  ;
D2B6    - 10 BE CC 2D    LDY     $CC2D  ;
D2BA &    26 04          BNE     $D2C0  ;
D2BC    x 10 8E CC 78    LDY     #$CC78 ;
->
D2C0   @  8E C8 40       LDX     #$C840 ;
D2C3 m    6D 02          TST     $02,X  ;
D2C5 '    27 07          BEQ     $D2CE  ;
D2C7      86 04          LDA     #$04   ;
D2C9      A7 84          STA     ,X     ;
D2CB      BD D4 06       JSR     $D406  ;
->
D2CE      B6 CC 20       LDA     $CC20  ;
D2D1      81 10          CMPA    #$10   ;
D2D3 'O   27 4F          BEQ     $D324  ;
D2D5      81 01          CMPA    #$01   ;
D2D7 '    27 06          BEQ     $D2DF  ;
D2D9      81 04          CMPA    #$04   ;
D2DB  #   10 23 04 F2    LBLS    $D7D1  ;
->
D2DF   8  8E C8 38       LDX     #$C838 ;
D2E2      C6 0B          LDB     #$0B   ;
D2E4   i  BD D3 69       JSR     $D369  ;
D2E7   @  8E C8 40       LDX     #$C840 ;
D2EA      B6 CC 0C       LDA     $CC0C  ;
D2ED      A7 03          STA     $03,X  ;
D2EF      86 01          LDA     #$01   ;
D2F1      A7 84          STA     ,X     ;
D2F3      BD D4 06       JSR     $D406  ;
D2F6 &    26 16          BNE     $D30E  ;
D2F8      B6 CC 20       LDA     $CC20  ;
D2FB J    4A             DECA           ;
D2FC G    47             ASRA           ;
D2FD G    47             ASRA           ;
D2FE L    4C             INCA           ;
D2FF o    6F 88 20       CLR     $20,X  ;
D302   !  A7 88 21       STA     $21,X  ;
D305      86 15          LDA     #$15   ;
D307      A7 84          STA     ,X     ;
D309      BD D4 06       JSR     $D406  ;
D30C ')   27 29          BEQ     $D337  ;
->
D30E      8E D2 9A       LDX     #$D29A ;
D311      BD CE 81       JSR     $CE81  ;
D314   ?  BE CC 3F       LDX     $CC3F  ;
D317      B6 CC 20       LDA     $CC20  ;
D31A      A7 01          STA     $01,X  ;
D31C o    6F 84          CLR     ,X     ;
D31E _    5F             CLRB           ;
D31F   [  BD CF 5B       JSR     $CF5B  ;
->
D322 5    35 B0          PULS    PC,Y,X ;
->
D324      AE E4          LDX     ,S     ;
D326      A6 03          LDA     $03,X  ;
D328      84 03          ANDA    #$03   ;
D32A  0   8B 30          ADDA    #$30   ;
D32C      B7 CC F2       STA     $CCF2  ;
D32F      8E CC E5       LDX     #$CCE5 ;
D332      BD CE 81       JSR     $CE81  ;
D335      20 EB          BRA     $D322  ;
->
D337      BD CE 90       JSR     $CE90  ;
D33A   @  8E C8 40       LDX     #$C840 ;
D33D      B6 CC 20       LDA     $CC20  ;
D340 J    4A             DECA           ;
D341      84 03          ANDA    #$03   ;
D343  ?   C6 3F          LDB     #$3F   ;
D345 =    3D             MUL            ;
D346      CB 04          ADDB    #$04   ;
D348   "  E7 88 22       STB     $22,X  ;
D34B      C6 FF          LDB     #$FF   ;
D34D   ;  E7 88 3B       STB     $3B,X  ;
->
D350      BD D4 06       JSR     $D406  ;
D353 &    26 B9          BNE     $D30E  ;
D355      BD CF 16       JSR     $CF16  ;
D358      81 0D          CMPA    #$0D   ;
D35A '    27 04          BEQ     $D360  ;
D35C      81 00          CMPA    #$00   ;
D35E &    26 F0          BNE     $D350  ;
->
D360      86 04          LDA     #$04   ;
D362      A7 84          STA     ,X     ;
D364      BD D4 06       JSR     $D406  ;
D367      20 B9          BRA     $D322  ;
->
Routine:
D369 40   34 30          PSHS    Y,X    ;
D36B ~    7E D0 C7       JMP     $D0C7  ;
->
D36E 35 06 FD CC 43 10 FF CC 45 CC D3 A1 FD DF CC 7F 5...C...E.......   ;
D37E CC 20 7C CC 28 7E CD CC                         . |.(~..           ;
->
D386   (  7F CC 28       CLR     $CC28  ;
D389    E 10 FE CC 45    LDS     $CC45  ;
D38D      F6 CC 20       LDB     $CC20  ;
D390 n  C 6E 9F CC 43    JMP     [$CC43];
->
D394 3A 39 3F 2D FC CC 16 ED 6A BD D7 05 3B C6 FE F7 :9?-....j...;...   ;
D3A4 CC 20 CC D3 86 20 F0                            . ... .            ;
->
D3AB      1E 89          EXG     A,B    ;
D3AD ?    3F 01          SWI     #$01   ;
D3AF      1E 89          EXG     A,B    ;
->
D3B1      1E 89          EXG     A,B    ;
D3B3 ?    3F 05          SWI     #$05   ;
D3B5      1E 89          EXG     A,B    ;
D3B7 9    39             RTS            ;
->
D3B8 34 04 3F 00 C4 7F 5D 35 04 39 1E 89 3F 01 1E 89 4.?...]5.9..?...   ;
D3C8 39 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 9...............   ;
D3D8 00 00 00 00 00 00 00 00 
D3E0 00 D3 C8 D3 C8 
->
;
; FLEX Console I/O Driver Vector Table
;
D3E5 D3 C2 ; FLEX INCHNE	Input character W/O echo
D3E7 D3 C8 ; FLEX IHNDLR	IRQ interrupt handler
D3E9 D3 C8 ; FLEX SWIVEC	SWI3 vector location
D3EB D3 C8 ; FLEX IRQVEC	IRQ vector location
D3ED D3 C8 ; FLEX TMOFF		Timer off routine
D3EF D3 C8 ; FLEX TMON		Timer on routine
D3F1 D3 C8 ; FLEX TMINT		Timer initialization
D3F3 D3 C8 ; FLEX MONITR	Moniter entry address
D3F5 D3 C8 ; FLEX TINIT		Terminal snitialization
D3F7 D3 B8 ; FLEX STAT		Check terminal status
D3F9 D3 B1 ; FLEX OUTCH		Output character
D3FC D3 AB ; FLEX INCH		Input character W/ echo
->
Routine:
D3FD ~    7E C6 00       JMP     $C600  ;		
->
Routine:
D400 ~ 6  7E D4 36       JMP     $D436  ;		FLEX: FMS Initialization
->
Routine:
D403 ~ f  7E D4 66       JMP     $D466  ;		FLEX: FMS Close
->
Routine:
D406 ~ ~  7E D4 7E       JMP     $D47E  ;		FLEX: FMS Call
->
D409 00 00 								;		FLEX: FCB Base Pointer
D40B 00 00 								;       FLEX: Current FCB Address
D40D 00 00 
D40F 00 00 								;		pointer to next FCB
D411 00 00 00 00 00 00 00 00 ................   ;
D419 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 ................   ;
D429 00 00 00 00 00 00 00 00 00 00 00 00 
D435 FF									;		FLEX: Verify Flag
->
D436      8E D4 09       LDX     #$D409 ;
D439      C6 0A          LDB     #$0A   ;
->
D43B o    6F 80          CLR     ,X+    ;
D43D Z    5A             DECB           ;
D43E &    26 FB          BNE     $D43B  ;
D440      8E 00 05       LDX     #$0005 ;
D443      BF D4 13       STX     $D413  ;
D446      BF D4 15       STX     $D415  ;
D449      7F D4 1A       CLR     $D41A  ;
->
D44C      8E D4 1B       LDX     #$D41B ;
D44F      C6 1A          LDB     #$1A   ;
->
D451 o    6F 80          CLR     ,X+    ;
D453 Z    5A             DECB           ;
D454 &    26 FB          BNE     $D451  ;
D456 4    34 20          PSHS    Y      ;
D458   @  8E C8 40       LDX     #$C840 ;
D45B      C6 0E          LDB     #$0E   ;
D45D      10 8E 00 20    LDY     #$0020 ;
D461 ?)   3F 29          SWI     #$29   ;
D463 _    5F             CLRB           ;
D464 5    35 A0          PULS    PC,Y   ;
->
D466      BE D4 09       LDX     $D409  ;
D469 '    27 E1          BEQ     $D44C  ;
D46B 0    30 88 E4       LEAX    $-1C,X ;
D46E      BF D4 0B       STX     $D40B  ;			FLEX Current FCB address
D471 4    34 20          PSHS    Y      ;
D473      C6 04          LDB     #$04   ;
D475      E7 84          STB     ,X     ;
D477      BD D6 B1       JSR     $D6B1  ;
D47A 5    35 20          PULS    Y      ;
D47C      20 E8          BRA     $D466  ;
->
;
;	FMS Call
;	--------
;	Entry to FLEX File Management System
;	X points to the FCB and byte 0 of the FCB is the function number
;
D47E 4$   34 24          PSHS    Y,B    ;
D480      BF D4 0B       STX     $D40B  ;			FLEX Current FCB address
D483 o    6F 01          CLR     $01,X  ;			Clear the error status
D485      E6 84          LDB     ,X     ;			B is the function code
D487 &"   26 22          BNE     $D4AB  ;
D489      E6 02          LDB     $02,X  ;
D48B '    27 1A          BEQ     $D4A7  ;
D48D      C1 02          CMPB    #$02   ;
D48F '    27 11          BEQ     $D4A2  ;
D491   {  BD D5 7B       JSR     $D57B  ;
->
D494      BE D4 0B       LDX     $D40B  ;			FLEX Current FCB address
D497 %&   25 26          BCS     $D4BF  ;
D499 }    7D CC DB       TST     $CCDB  ;
D49C &#   26 23          BNE     $D4C1  ;
D49E _    5F             CLRB           ;
D49F 5$   35 24          PULS    Y,B    ;
D4A1 9    39             RTS            ;			DONE
->
D4A2      BD D5 CE       JSR     $D5CE  ;
D4A5      20 ED          BRA     $D494  ;
->
D4A7      C6 12          LDB     #$12   ;
D4A9      20 14          BRA     $D4BF  ;
->
D4AB      C1 1D          CMPB    #$1D   ;			Check against $1D
D4AD #    23 04          BLS     $D4B3  ;			Less so decode and call function
D4AF      C6 01          LDB     #$01   ;			Illegal FMS function specified
D4B1      20 0C          BRA     $D4BF  ;			Set error code and done
->
D4B3 Z    5A             DECB           ;			subtract 1 from the function number
D4B4 X    58             ASLB           ;			double B (ie an offset into a table of words)
D4B5      8E D4 C6       LDX     #$D4C6 ;			offset table
D4B8      AD 95          JSR     [B,X]  ;			call the FMS function
D4BA      BE D4 0B       LDX     $D40B  ;			FLEX Current FCB address
D4BD $    24 02          BCC     $D4C1  ;
->
D4BF      E7 01          STB     $01,X  ;			Store the error code in the FCB
->
D4C1 m    6D 01          TST     $01,X  ;			Check to see if there was an error and set flags
D4C3 5$   35 24          PULS    Y,B    ;
D4C5 9    39             RTS            ;			DONE
->
;
;	FMS offset table (counts from 1)
;								 
D4C6      D6 8C			; FLEX  1 open for read
D4C8      D6 8C 		; FLEX  2 open for write
D4CA      D6 8C			; FLEX  3 open for update
D4CC      D6 B1 		; FLEX  4 close file
D4DE      D6 CA			; FLEX  5 rewind file
D4E0      D6 4C 		; FLEX  6 open directory
D4E2      D6 67			; FLEX  7 get information record
D4E4      D6 CA 		; FLEX  8 put information record
D4E6      D6 A8			; FLEX  9 read single sector
D4E8      D6 CA 		; FLEX 10 write single sector
D4EA      D6 CA			; FLEX 11 RESERVED
D4EC      D6 9F 		; FLEX 12 delete file
D4EE      D6 9F			; FLEX 13 rename file
D4F0      D5 18 		; FLEX 14 RESERVED
D4F2      D6 CA			; FLEX 15 next sequential sector
D4F4      D6 45 		; FLEX 16 open system information record
D4F6      D5 36			; FLEX 17 get random byte form sector
D4F8      D5 57 		; FLEX 18 put random byte in sector
D4FA      D6 8C			; FLEX 19 RESERVED
D4FC      D6 A8 		; FLEX 20 find nex drive
D4FE      D6 CA			; FLEX 21 position to record N
D500      D6 CA 		; FLEX 22 backup one record
D502      D5 18			; FLEX 23
D504      D5 18 		; FLEX 24
D506      D6 CA			; FLEX 25
D508      D6 CA 		; FLEX 26
D50A      D6 CA			; FLEX 27
D50C      D6 8C 		; FLEX 28
D50E      D6 CA 		; FLEX 29
->
D500 8D 19 ED 84 AE 84 ................   ;
D506 6F 84 6F 01 39                                  o.o.9              ;
->
Routine:
D50B      8D 0E          BSR     $D51B  ;
D50D '    27 05          BEQ     $D514  ;
D50F      C6 0D          LDB     #$0D   ;
D511      1A 01          ORCC    #$01   ;
D513 9    39             RTS            ;
->
D514      EC 94          LDD     [,X]   ;
D516      ED 84          STD     ,X     ;
D518      1C FE          ANDCC   #$FE   ;
D51A 9    39             RTS            ;
->
Routine:
D51B      FC D4 0B       LDD     $D40B  ;			FLEX Current FCB address
D51E      C3 00 1C       ADDD    #$001C ;
D521      8E D4 09       LDX     #$D409 ;
->
D524      10 AE 84       LDY     ,X     ;
D527 &    26 03          BNE     $D52C  ;
D529      1C FB          ANDCC   #$FB   ;
D52B 9    39             RTS            ;
->
D52C      10 A3 84       CMPD    ,X     ;
D52F &    26 01          BNE     $D532  ;
D531 9    39             RTS            ;
->
D532      AE 84          LDX     ,X     ;
D534      20 EE          BRA     $D524  ;
->
D536 BE D4 0B E6 02 54 24 6B E6 88 23 7E D5 B9       .....T$k..#~..     ;
->
Routine:
D544      BE D4 0B       LDX     $D40B  ;			FLEX Current FCB address
D547   "  E6 88 22       LDB     $22,X  ;
D54A l "  6C 88 22       INC     $22,X  ;
D54D :    3A             ABX            ;
D54E   @  A7 88 40       STA     $40,X  ;
D551 \    5C             INCB           ;
D552 &    26 1F          BNE     $D573  ;
D554      1A 01          ORCC    #$01   ;
D556 9    39             RTS            ;
->
D557 BE D4 0B E6 02 C4 03 C1 03 26 47 CA 80 E7 02 E6 .........&G.....   ;
D567 0F C5 80 26 0A E6 88 23 3A A7 88 40             ...&...#:..@       ;
->
D573      1C FE          ANDCC   #$FE   ;
D575 9    39             RTS            ;
->
D576 C6 0B 1A 01 39                                  ....9              ;
->
Routine:
D57B   ;  A6 88 3B       LDA     $3B,X  ;
D57E +.   2B 2E          BMI     $D5AE  ;
D580 '    27 07          BEQ     $D589  ;
D582 j ;  6A 88 3B       DEC     $3B,X  ;
D585      86 20          LDA     #$20   ;
D587      20 1D          BRA     $D5A6  ;
->
D589  #   8D 23          BSR     $D5AE  ;
D58B %    25 1B          BCS     $D5A8  ;
D58D      81 18          CMPA    #$18   ;
D58F "    22 15          BHI     $D5A6  ;
D591 '    27 F6          BEQ     $D589  ;
D593      81 09          CMPA    #$09   ;
D595 &    26 0C          BNE     $D5A3  ;
D597      8D 15          BSR     $D5AE  ;
D599 %    25 0D          BCS     $D5A8  ;
D59B      BE D4 0B       LDX     $D40B  ;			FLEX Current FCB address
D59E   ;  A7 88 3B       STA     $3B,X  ;
D5A1      20 D8          BRA     $D57B  ;
->
D5A3 M    4D             TSTA           ;
D5A4 '    27 E3          BEQ     $D589  ;
->
D5A6      1C FE          ANDCC   #$FE   ;
->
D5A8 9    39             RTS            ;
->
D5A9      C6 12          LDB     #$12   ;
D5AB      1A 01          ORCC    #$01   ;
D5AD 9    39             RTS            ;
->
Routine:
D5AE      BE D4 0B       LDX     $D40B  ;			FLEX Current FCB address
D5B1   "  E6 88 22       LDB     $22,X  ;
D5B4 '    27 0A          BEQ     $D5C0  ;
D5B6 l "  6C 88 22       INC     $22,X  ;
D5B9 :    3A             ABX            ;
D5BA   @  A6 88 40       LDA     $40,X  ;
D5BD      1C FE          ANDCC   #$FE   ;
D5BF 9    39             RTS            ;
->
D5C0 4    34 02          PSHS    A      ;
D5C2      86 18          LDA     #$18   ;
D5C4      A7 84          STA     ,X     ;
D5C6 5    35 02          PULS    A      ;
D5C8      17 00 DD       LBSR    $D6A8  ;
D5CB $    24 E1          BCC     $D5AE  ;
D5CD 9    39             RTS            ;
->
Routine:
D5CE      BE D4 0B       LDX     $D40B  ;			FLEX Current FCB address
D5D1   ;  E6 88 3B       LDB     $3B,X  ;
D5D4 +=   2B 3D          BMI     $D613  ;
D5D6      81 20          CMPA    #$20   ;
D5D8 &    26 0F          BNE     $D5E9  ;
D5DA \    5C             INCB           ;
D5DB   ;  E7 88 3B       STB     $3B,X  ;
D5DE      C1 7F          CMPB    #$7F   ;
D5E0 &    26 0C          BNE     $D5EE  ;
D5E2      20 0D          BRA     $D5F1  ;
->
D5E4      8D 0B          BSR     $D5F1  ;
D5E6 $    24 E6          BCC     $D5CE  ;
D5E8 9    39             RTS            ;
->
D5E9 ]    5D             TSTB           ;
D5EA ''   27 27          BEQ     $D613  ;
D5EC      20 F6          BRA     $D5E4  ;
->
D5EE      1C FE          ANDCC   #$FE   ;
D5F0 9    39             RTS            ;
->
Routine:
D5F1 4    34 02          PSHS    A      ;
D5F3      C1 01          CMPB    #$01   ;
D5F5 &    26 04          BNE     $D5FB  ;
D5F7      86 20          LDA     #$20   ;
D5F9      20 10          BRA     $D60B  ;
->
D5FB      86 09          LDA     #$09   ;
D5FD      8D 14          BSR     $D613  ;
D5FF 5    35 02          PULS    A      ;
D601 %9   25 39          BCS     $D63C  ;
D603 4    34 02          PSHS    A      ;
D605      BE D4 0B       LDX     $D40B  ;			FLEX Current FCB address
D608   ;  A6 88 3B       LDA     $3B,X  ;
->
D60B o ;  6F 88 3B       CLR     $3B,X  ;
D60E      8D 03          BSR     $D613  ;
D610 5    35 02          PULS    A      ;
D612 9    39             RTS            ;
->
Routine:
D613      BE D4 0B       LDX     $D40B  ;			FLEX Current FCB address
D616      E6 02          LDB     $02,X  ;
D618      C1 02          CMPB    #$02   ;
D61A  &   10 26 FF 8B    LBNE    $D5A9  ;
D61E   "  E6 88 22       LDB     $22,X  ;
D621      C1 04          CMPB    #$04   ;
D623 &    26 08          BNE     $D62D  ;
D625 4    34 02          PSHS    A      ;
D627      8D 14          BSR     $D63D  ;
D629 5    35 02          PULS    A      ;
D62B %    25 0F          BCS     $D63C  ;
->
D62D   D  BD D5 44       JSR     $D544  ;
D630 $    24 0A          BCC     $D63C  ;
D632      C6 04          LDB     #$04   ;
D634      BE D4 0B       LDX     $D40B  ;			FLEX Current FCB address
D637   "  E7 88 22       STB     $22,X  ;
D63A      1C FE          ANDCC   #$FE   ;
->
D63C 9    39             RTS            ;
->
Routine:
D63D      86 17          LDA     #$17   ;
D63F      A7 84          STA     ,X     ;
D641      BD D6 CA       JSR     $D6CA  ;
D644 9    39             RTS            ;
->
D645 5F 34 04 C6 03 20 08 F6 D4 13 34 04 F6 D4 14 BE _4... ....4.....   ;
D655 D4 0B E7 88 41 35 04 E7 88 40 7F D4 18 5F E7 88 ....A5...@..._..   ;
D665 22 39 BE D4 0B E6 88 22 26 04 BD D6 CA 39 A6 88 "9....."&....9..   ;
D675 22 A7 88 31 C6 18 34 14 BD D5 AE 35 14 A7 04 30 "..1..4....5...0   ;
D685 01 5A 26 F2 1C FE 39 BD D5 00 BE D4 0B FC DF F4 .Z&...9.........   ;
D695 ED 88 40 8D 0E 10 25 FE 6D 39 BE D4 0B FC DF F4 ..@...%.m9......   ;
D6A5 ED 88 40                                        ..@                ;
->
Routine:
;
;	READ_SINGLE_SECTOR  (FLEX FMS Function 9)
;	------------------
;	Read a single sector from disk.
;	FCB byte 30 (1E) is the track
;	FCB byte 31 (1F) is the sector
; 
D6A8      BE D4 0B       LDX     $D40B  ;			FLEX Current FCB address  (and NETWORK: Transfer "from" address)
D6AB    D 10 8E 00 44    LDY     #$0044 ;			NETWORK: Length of message
D6AF      20 20          BRA     $D6D1  ;
->
Routine:
D6B1      BD D5 0B       JSR     $D50B  ;
D6B4      BE D4 0B       LDX     $D40B  ;			FLEX Current FCB address
D6B7      A6 02          LDA     $02,X  ;
D6B9 4    34 02          PSHS    A      ;
D6BB      BD D6 CA       JSR     $D6CA  ;
D6BE 5    35 02          PULS    A      ;
D6C0 %{   25 7B          BCS     $D73D  ;
D6C2      81 01          CMPA    #$01   ;
D6C4 '    27 03          BEQ     $D6C9  ;
D6C6      BD D7 A3       JSR     $D7A3  ;
->
D6C9 9    39             RTS            ;			DONE
->
Routine:
D6CA      BE D4 0B       LDX     $D40B  ;			FLEX Current FCB address
D6CD    @ 10 8E 01 40    LDY     #$0140 ;
->
D6D1   2  ED 88 32       STD     $32,X  ;			save D
D6D4      1F A9          TFR     CC,B   ;			copy CC to B so we can save it next
D6D6   4  E7 88 34       STB     $34,X  ;			save CC
D6D9      EC 88 1C       LDD     $1C,X  ;			store the pointer to the next FCB because this field of the FCB
D6DC      FD D4 0F       STD     $D40F  ;			will get replaced by the machine UID for transmission to the server
D6DF      C6 0D          LDB     #$0D   ;			NETWORK: message type ($0D - read sector)	p1 is in D:  p2 is in X : p3 is in Y
D6E1   y  7F D7 79       CLR     $D779  ;
->
D6E4 44   34 34          PSHS    Y,X,B  ;
D6E6 ?)   3F 29          SWI     #$29   ;			ROM function $29 - RESERVED - stores machine UID in NEXT_FCB and Chains to "send message to server"
D6E8 $    24 06          BCC     $D6F0  ;			no error if carry clear
D6EA  '   8D 27          BSR     $D713  ;
D6EC 54   35 34          PULS    Y,X,B  ;
D6EE      20 F4          BRA     $D6E4  ;
->
D6F0 2e   32 65          LEAS    $05,S  ;
D6F2      8D 11          BSR     $D705  ;
->
D6F4    @ 10 8E 01 40    LDY     #$0140 ;			NETWORK: max length of message
D6F8      BE D4 0B       LDX     $D40B  ;			FLEX Current FCB address (NETWORK: destination)
D6FB ?,   3F 2C          SWI     #$2C   ;			NETWORK: get message from server 	p1 is in D:  p2 is in X : p3 is in Y
D6FD $A   24 41          BCC     $D740  ;			no error if carry clear
D6FF      85 02          BITA    #$02   ;
D701 &    26 F1          BNE     $D6F4  ;
D703  6   20 36          BRA     $D73B  ;
->
Routine:
D705 } y  7D D7 79       TST     $D779  ;
D708 '    27 08          BEQ     $D712  ;
D70A   P  8E D7 50       LDX     #$D750 ;			scratch message (there's normally nothing there)
D70D      8D 1D          BSR     $D72C  ;			print message at bottom of screen
D70F   y  7F D7 79       CLR     $D779  ;
->
D712 9    39             RTS            ;			DONE
->
Routine:
D713 } y  7D D7 79       TST     $D779  ;			error on read sector
D716 &"   26 22          BNE     $D73A  ;
D718   P  CC D7 50       LDD     #$D750 ;
D71B   (  8E 00 28       LDX     #$0028 ;
D71E      10 8E 17 00    LDY     #$1700 ;
D722 ?    3F 08          SWI     #$08   ;			ROM function $08 (Copy from screen to a string) 
D724      86 01          LDA     #$01   ;			
D726   y  B7 D7 79       STA     $D779  ;
D729   z  8E D7 7A       LDX     #$D77A ;			waiting to access disk message
->
Routine:
;
;	Print string at bottom of screen
;
D72C      10 8E 17 00    LDY     #$1700 ;			row / column position
->
D730      E6 80          LDB     ,X+    ;			get first character
D732 '    27 06          BEQ     $D73A  ;			is it a '\0' (end of string)
D734 ?    3F 06          SWI     #$06   ;			ROM function $06 (write character to screen position)
D736 1!   31 21          LEAY    $01,Y  ;			inc column number
D738      20 F6          BRA     $D730  ;			next character in string
->
D73A 9    39             RTS            ;			DONE
->
D73B      C6 1B          LDB     #$1B   ;
->
D73D      1A 01          ORCC    #$01   ;
D73F 9    39             RTS            ;			DONE
->
D740      FC D4 0F       LDD     $D40F  ;
D743      ED 88 1C       STD     $1C,X  ;
D746   4  A6 88 34       LDA     $34,X  ;
D749 4    34 02          PSHS    A      ;
D74B   2  EC 88 32       LDD     $32,X  ;
D74E 5    35 81          PULS    PC,CC  ;			DONE
->
D750 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 ................
D760 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 ................
D770 00 00 00 00 00 00 00 00 00                      .........
->
D779 00							; dunno yet
->
D77A 02 57 61 69 74 69 6E 67 20 74 6F 20 61 63 63 65 .Waiting to acce
D78A 73 73 20 64 69 73 6B 2E 20 50 6C 65 61 73 65 20 ss disk. Please 
D79A 77 61 69 74 2E 2E 2E 2E 00                      wait.....
->
Routine:
D7A3      BE D4 0B       LDX     $D40B  ;			FLEX Current FCB address
D7A6      EC 0C          LDD     $0C,X  ;
D7A8   PR 10 83 50 52    CMPD    #$5052 ;
D7AC &    26 20          BNE     $D7CE  ;
D7AE      A6 0E          LDA     $0E,X  ;
D7B0  T   81 54          CMPA    #$54   ;
D7B2 &    26 1A          BNE     $D7CE  ;
D7B4 m    6D 04          TST     $04,X  ;
D7B6 +    2B 16          BMI     $D7CE  ;
D7B8 0    30 03          LEAX    $03,X  ;
D7BA      10 8E 00 0C    LDY     #$000C ;
D7BE      E6 84          LDB     ,X     ;
D7C0      CA 90          ORB     #$90   ;
D7C2      E7 84          STB     ,X     ;
D7C4      C6 05          LDB     #$05   ;
D7C6 ?+   3F 2B          SWI     #$2B   ;
D7C8      10 8E 00 00    LDY     #$0000 ;
D7CC ?,   3F 2C          SWI     #$2C   ;
->
D7CE      1C FE          ANDCC   #$FE   ;
D7D0 9    39             RTS            ;
->
D7D1 '    27 0E          BEQ     $D7E1  ;
D7D3      80 02          SUBA    #$02   ;
D7D5 &    26 05          BNE     $D7DC  ;
D7D7      8E CC 83       LDX     #$CC83 ;
D7DA      20 08          BRA     $D7E4  ;
->
D7DC      8E CC 9B       LDX     #$CC9B ;
D7DF      20 03          BRA     $D7E4  ;
->
D7E1      8E CC C1       LDX     #$CCC1 ;
->
D7E4      BD CD 1E       JSR     $CD1E  ;
D7E7      86 03          LDA     #$03   ;
D7E9  .   8D 2E          BSR     $D819  ;
D7EB      AE E4          LDX     ,S     ;
D7ED      8D 03          BSR     $D7F2  ;
D7EF   0  16 FB 30       LBRA    $D322  ;
->
Routine:
D7F2 m $  6D 88 24       TST     $24,X  ;
D7F5 '!   27 21          BEQ     $D818  ;
D7F7      A6 03          LDA     $03,X  ;
D7F9 +    2B 0A          BMI     $D805  ;
D7FB      84 03          ANDA    #$03   ;
D7FD  0   8B 30          ADDA    #$30   ;
D7FF      8D 18          BSR     $D819  ;
D801  .   86 2E          LDA     #$2E   ;
D803      8D 14          BSR     $D819  ;
->
D805 0 $  30 88 24       LEAX    $24,X  ;
D808      C6 08          LDB     #$08   ;
D80A      8D 10          BSR     $D81C  ;
D80C  .   86 2E          LDA     #$2E   ;
D80E      8D 09          BSR     $D819  ;
D810      C6 03          LDB     #$03   ;
D812      8D 08          BSR     $D81C  ;
D814      86 0E          LDA     #$0E   ;
D816      8D 01          BSR     $D819  ;
->
D818 9    39             RTS            ;
->
Routine:
D819 ~    7E CF 16       JMP     $CF16  ;
->
Routine:
D81C      A6 80          LDA     ,X+    ;
D81E '    27 02          BEQ     $D822  ;
D820      8D F7          BSR     $D819  ;
->
D822 Z    5A             DECB           ;
D823 &    26 F7          BNE     $D81C  ;
D825 9    39             RTS            ;
->
D826 A6 84 30 88 DD 20 CC 54 79 70 65 20 61 6E 79 20 ..0.. .Type any    ;
D836 6B 65 79 20 74 6F 20 63 6F 6E 74 69 6E 75 65 20 key to continue    ;
D846 04 42 49 4E 54 58 54 43 4D 44 42 41 53 53 59 53 .BINTXTCMDBASSYS   ;
D856 42 41 4B 53 43 52 44 41 54 42 41 43 44 49 52 50 BAKSCRDATBACDIRP   ;
D866 52 54 4F 55 54 00                               RTOUT.             ;
->
Routine:
D86C      7F CC 1D       CLR     $CC1D  ;
D86F  c   8D 63          BSR     $D8D4  ;
D871      20 05          BRA     $D878  ;
->
D873 Z    5A             DECB           ;
D874 &    26 02          BNE     $D878  ;
D876  \   8D 5C          BSR     $D8D4  ;
->
D878      A6 C0          LDA     ,U+    ;
D87A      81 02          CMPA    #$02   ;
D87C '    27 1F          BEQ     $D89D  ;
D87E      81 16          CMPA    #$16   ;
D880 &    26 F1          BNE     $D873  ;
D882 Z    5A             DECB           ;
D883 &    26 02          BNE     $D887  ;
D885  M   8D 4D          BSR     $D8D4  ;
->
D887      A6 C0          LDA     ,U+    ;
D889      B7 CC 1E       STA     $CC1E  ;
D88C Z    5A             DECB           ;
D88D &    26 02          BNE     $D891  ;
D88F  C   8D 43          BSR     $D8D4  ;
->
D891      A6 C0          LDA     ,U+    ;
D893      B7 CC 1F       STA     $CC1F  ;
D896      86 01          LDA     #$01   ;
D898      B7 CC 1D       STA     $CC1D  ;
D89B      20 D6          BRA     $D873  ;
->
D89D Z    5A             DECB           ;
D89E &    26 02          BNE     $D8A2  ;
D8A0  2   8D 32          BSR     $D8D4  ;
->
D8A2      A6 C0          LDA     ,U+    ;
D8A4      A7 E3          STA     ,--S   ;
D8A6 Z    5A             DECB           ;
D8A7 &    26 02          BNE     $D8AB  ;
D8A9  )   8D 29          BSR     $D8D4  ;
->
D8AB      A6 C0          LDA     ,U+    ;
D8AD  a   A7 61          STA     $01,S  ;
D8AF 5    35 20          PULS    Y      ;
D8B1 4    34 04          PSHS    B      ;
D8B3      FC CC 1B       LDD     $CC1B  ;
D8B6 1    31 AB          LEAY    D,Y    ;
D8B8 5    35 04          PULS    B      ;
D8BA Z    5A             DECB           ;
D8BB &    26 02          BNE     $D8BF  ;
D8BD      8D 15          BSR     $D8D4  ;
->
D8BF      A6 C0          LDA     ,U+    ;
D8C1   k  B7 D8 6B       STA     $D86B  ;
->
D8C4 Z    5A             DECB           ;
D8C5 &    26 02          BNE     $D8C9  ;
D8C7      8D 0B          BSR     $D8D4  ;
->
D8C9      A6 C0          LDA     ,U+    ;
D8CB      A7 A0          STA     ,Y+    ;
D8CD z k  7A D8 6B       DEC     $D86B  ;
D8D0 &    26 F2          BNE     $D8C4  ;
D8D2      20 9F          BRA     $D873  ;
->
Routine:
D8D4   @  8E C8 40       LDX     #$C840 ;
D8D7   @  EC 88 40       LDD     $40,X  ;
D8DA &    26 02          BNE     $D8DE  ;
D8DC      20 20          BRA     $D8FE  ;
->
D8DE      ED 88 1E       STD     $1E,X  ;
D8E1      C6 09          LDB     #$09   ;
D8E3      E7 84          STB     ,X     ;
D8E5      BD D4 06       JSR     $D406  ;
D8E8 &    26 0E          BNE     $D8F8  ;
D8EA      C6 FC          LDB     #$FC   ;
D8EC 3 D  33 88 44       LEAU    $44,X  ;
D8EF 9    39             RTS            ;
->
Routine:
D8F0   @  8E C8 40       LDX     #$C840 ;
D8F3      BD D4 06       JSR     $D406  ;
D8F6 '    27 11          BEQ     $D909  ;
->
D8F8      A6 01          LDA     $01,X  ;
D8FA      81 08          CMPA    #$08   ;
D8FC &    26 0E          BNE     $D90C  ;
->
D8FE 2b   32 62          LEAS    $02,S  ;
D900      86 04          LDA     #$04   ;
D902      A7 84          STA     ,X     ;
D904      BD D4 06       JSR     $D406  ;
D907 &    26 0D          BNE     $D916  ;
->
D909      1C FE          ANDCC   #$FE   ;
D90B 9    39             RTS            ;
->
D90C      B7 CC 20       STA     $CC20  ;
D90F      81 04          CMPA    #$04   ;
D911 &    26 03          BNE     $D916  ;
D913      1A 01          ORCC    #$01   ;
D915 9    39             RTS            ;
->
D916      BD D2 AA       JSR     $D2AA  ;
D919 ~    7E CD FB       JMP     $CDFB  ;
->
