C400  #   20 23          BRA     $C425  ;
->
C402 82 2E 38 3A 33 20 57 50 2D 53 41 46 4C 45 58 20 ..8:3 WP-SAFLEX    ;
C412 46 4F 52 20 53 54 41 4E 44 41 4C 4F 4E 45 20 50 FOR STANDALONE P   ;
C422 4F 4C 59                                        OLY                ;
->
C425  9   86 39          LDA     #$39   ;
C427      B7 D3 FD       STA     $D3FD  ;
C42A ?    3F 1B          SWI     #$1B   ;
C42C   $  BD CD 24       JSR     $CD24  ;
C42F   P  8E C8 50       LDX     #$C850 ;
C432      BD CD 1E       JSR     $CD1E  ;
C435   $  BD CD 24       JSR     $CD24  ;
->
C438   O  FC CC 4F       LDD     $CC4F  ;
C43B 4    34 06          PSHS    D      ;
C43D      8E C7 D4       LDX     #$C7D4 ;
C440   O  BF CC 4F       STX     $CC4F  ;
C443      BD CD 1E       JSR     $CD1E  ;
C446      BD CD 1B       JSR     $CD1B  ;
C449 5    35 06          PULS    D      ;
C44B   O  FD CC 4F       STD     $CC4F  ;
C44E      10 8E CC 0E    LDY     #$CC0E ;
C452  P   8D 50          BSR     $C4A4  ;
C454 #    23 E2          BLS     $C438  ;
C456  L   8D 4C          BSR     $C4A4  ;
C458 #    23 DE          BLS     $C438  ;
C45A  H   8D 48          BSR     $C4A4  ;
C45C #    23 DA          BLS     $C438  ;
C45E      FC CC 0E       LDD     $CC0E  ;
C461      B7 CC 0F       STA     $CC0F  ;
C464      F7 CC 0E       STB     $CC0E  ;
C467   $  BD CD 24       JSR     $CD24  ;
C46A   @  8E C8 40       LDX     #$C840 ;
C46D      BD DE 0F       JSR     $DE0F  ;
C470      86 01          LDA     #$01   ;
C472      A7 84          STA     ,X     ;
C474      BD D4 06       JSR     $D406  ;
C477 '    27 09          BEQ     $C482  ;
C479      A6 01          LDA     $01,X  ;
C47B      81 04          CMPA    #$04   ;
C47D &7   26 37          BNE     $C4B6  ;
C47F ~    7E CD 03       JMP     $CD03  ;
->
C482      10 8E C0 80    LDY     #$C080 ;
C486      10 BF CC 14    STY     $CC14  ;
C48A      C6 80          LDB     #$80   ;
->
C48C      BD D4 06       JSR     $D406  ;
C48F &%   26 25          BNE     $C4B6  ;
C491 Z    5A             DECB           ;
C492 '"   27 22          BEQ     $C4B6  ;
C494      A7 A0          STA     ,Y+    ;
C496      81 0D          CMPA    #$0D   ;
C498 &    26 F2          BNE     $C48C  ;
C49A      86 04          LDA     #$04   ;
C49C      A7 84          STA     ,X     ;
C49E      BD D4 06       JSR     $D406  ;
C4A1 ~    7E CD 06       JMP     $CD06  ;
->
Routine:
C4A4   H  BD CD 48       JSR     $CD48  ;
C4A7 4    34 10          PSHS    X      ;
C4A9 %    25 09          BCS     $C4B4  ;
C4AB      A6 A4          LDA     ,Y     ;
C4AD ]    5D             TSTB           ;
C4AE '    27 02          BEQ     $C4B2  ;
C4B0  a   A6 61          LDA     $01,S  ;
->
C4B2      A7 A0          STA     ,Y+    ;
->
C4B4 5    35 86          PULS    PC,D   ;
->
C4B6      8E C4 BF       LDX     #$C4BF ;
C4B9      BD CD 1E       JSR     $CD1E  ;
C4BC ~    7E CD 03       JMP     $CD03  ;
->
C4BF 0F 02 43 61 6E 6E 6F 74 20 72 75 6E 20 53 54 41 ..Cannot run STA   ;
C4CF 52 54 55 50 20 66 69 6C 65 04 00 00 00 00 00 00 RTUP file.......   ;
C4DF 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 ................   ;
C4EF 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 ................   ;
C4FF 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 ................   ;
C50F 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 ................   ;
C51F 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 ................   ;
C52F 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 ................   ;
C53F 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 ................   ;
C54F 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 ................   ;
C55F 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 ................   ;
C56F 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 ................   ;
C57F 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 ................   ;
C58F 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 ................   ;
C59F 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 ................   ;
C5AF 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 ................   ;
C5BF 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 ................   ;
C5CF 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 ................   ;
C5DF 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 ................   ;
C5EF 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 ................   ;
C5FF 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 ................   ;
C60F 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 ................   ;
C61F 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 ................   ;
C62F 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 ................   ;
C63F 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 ................   ;
C64F 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 ................   ;
C65F 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 ................   ;
C66F 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 ................   ;
C67F 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 ................   ;
C68F 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 ................   ;
C69F 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 ................   ;
C6AF 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 ................   ;
C6BF 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 ................   ;
C6CF 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 ................   ;
C6DF 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 ................   ;
C6EF 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 ................   ;
C6FF 00 BD D9 D7 25 1A 86 02 A7 02 A7 88 17 BD D6 D2 ....%...........   ;
C70F 25 0E BD DA CF 25 09 BD D9 84 25 04 86 01 A7 02 %....%....%.....   ;
C71F 39 BE D4 0B 30 88 44 10 8E C9 C0 C6 FC BD C7 C9 9...0.D.........   ;
C72F BD DD 08 24 22 C1 18 26 2C 8D 2D 25 28 BE D4 0B ...$"..&,.-%(...   ;
C73F 6F 88 40 6F 88 41 EC 88 20 83 00 01 ED 88 42 6A o.@o.A.. .....Bj   ;
C74F 02 EC 88 13 ED 88 1E 31 88 44 8E C9 C0 C6 FC BD .......1.D......   ;
C75F C7 C9 7E D6 A2 1A 01 39 FC D4 0F B3 D4 0B 83 00 ..~....9........   ;
C76F 40 BE D4 0F 10 AE 84 A6 02 BE D4 0B A7 88 37 E7 @.............7.   ;
C77F 88 3A EC 88 1E ED 88 38 10 AF 88 35 BE D4 0B EC .:.....8...5....   ;
C78F 88 20 C3 00 02 A3 88 15 34 06 BD D9 15 25 29 BD . ......4....%).   ;
C79F DB 18 25 24 EC 88 42 ED 88 20 BD D7 75 25 19 35 ..%$..B.. ..u%.5   ;
C7AF 06 83 00 01 27 04 34 06 20 F0 BD DC A4 25 08 BD ....'.4. ....%..   ;
C7BF D9 67 25 03 BD D9 45 39 35 90 A6 80 A7 A0 5A 26 .g%...E95.....Z&   ;
C7CF F9 39 1C FE 39 0F 03 44 61 74 65 20 28 44 44 2C .9..9..Date (DD,   ;
C7DF 4D 4D 2C 59 59 29 3F 20 07 0E 04 00 00 00 00 00 MM,YY)? ........   ;
C7EF 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 ................   ;
C7FF 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 ................   ;
C80F 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 ................   ;
C81F 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 ................   ;
C82F 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 ................   ;
C83F 00 FF 00 00 00 73 74 61 72 74 75 70 00 74 78 74 .....startup.txt   ;
C84F 00 0F 01 1D 07 0D 57 50 2D 53 41 46 4C 45 58 20 ......WP-SAFLEX    ;
C85F 20 32 2E 38 20 20 20 32 32 2D 4E 6F 76 2D 38 33  2.8   22-Nov-83   ;
C86F 20 20 20 38 36 6B 0E 0A 04 00 00 00 00 00 00 00    86k..........   ;
C87F 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 ................   ;
C88F 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 ................   ;
C89F 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 ................   ;
C8AF 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 ................   ;
C8BF 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 ................   ;
C8CF 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 ................   ;
C8DF 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 ................   ;
C8EF 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 ................   ;
C8FF 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 ................   ;
C90F 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 ................   ;
C91F 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 ................   ;
C92F 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 ................   ;
C93F 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 ................   ;
C94F 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 ................   ;
C95F 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 ................   ;
C96F 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 ................   ;
C97F 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 ................   ;
C98F 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 ................   ;
C99F 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 ................   ;
C9AF 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 ................   ;
C9BF 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 ................   ;
C9CF 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 ................   ;
C9DF 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 ................   ;
C9EF 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 ................   ;
C9FF 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 ................   ;
CA0F 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 ................   ;
CA1F 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 ................   ;
CA2F 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 ................   ;
CA3F 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 ................   ;
CA4F 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 ................   ;
CA5F 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 ................   ;
CA6F 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 ................   ;
CA7F 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 ................   ;
CA8F 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 ................   ;
CA9F 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 ................   ;
CAAF 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 ................   ;
CABF 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 ................   ;
CACF 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 ................   ;
CADF 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 ................   ;
CAEF 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 ................   ;
CAFF 00                                              .                  ;
->
CB00 '    27 0E          BEQ     $CB10  ;
CB02      80 02          SUBA    #$02   ;
CB04 &    26 05          BNE     $CB0B  ;
CB06   !  8E CB 21       LDX     #$CB21 ;
CB09      20 08          BRA     $CB13  ;
->
CB0B   9  8E CB 39       LDX     #$CB39 ;
CB0E      20 03          BRA     $CB13  ;
->
CB10   O  8E CB 4F       LDX     #$CB4F ;
->
CB13      BD CD 1E       JSR     $CD1E  ;
CB16      86 03          LDA     #$03   ;
CB18  r   8D 72          BSR     $CB8C  ;
CB1A      AE E4          LDX     ,S     ;
CB1C  G   8D 47          BSR     $CB65  ;
CB1E      16 07 CE       LBRA    $D2EF  ;
->
CB21 0F 02 52 45 51 55 45 53 54 45 44 20 46 49 4C 45 ..REQUESTED FILE   ;
CB31 20 49 4E 20 55 53 45 04 0F 02 46 49 4C 45 20 41  IN USE...FILE A   ;
CB41 4C 52 45 41 44 59 20 45 58 49 53 54 53 04 0F 02 LREADY EXISTS...   ;
CB51 46 49 4C 45 20 44 4F 45 53 20 4E 4F 54 20 45 58 FILE DOES NOT EX   ;
CB61 49 53 54 04                                     IST.               ;
->
Routine:
CB65 m $  6D 88 24       TST     $24,X  ;
CB68 '!   27 21          BEQ     $CB8B  ;
CB6A      A6 03          LDA     $03,X  ;
CB6C +    2B 0A          BMI     $CB78  ;
CB6E      84 03          ANDA    #$03   ;
CB70  0   8B 30          ADDA    #$30   ;
CB72      8D 18          BSR     $CB8C  ;
CB74  .   86 2E          LDA     #$2E   ;
CB76      8D 14          BSR     $CB8C  ;
->
CB78 0 $  30 88 24       LEAX    $24,X  ;
CB7B      C6 08          LDB     #$08   ;
CB7D      8D 10          BSR     $CB8F  ;
CB7F  .   86 2E          LDA     #$2E   ;
CB81      8D 09          BSR     $CB8C  ;
CB83      C6 03          LDB     #$03   ;
CB85      8D 08          BSR     $CB8F  ;
CB87      86 0E          LDA     #$0E   ;
CB89      8D 01          BSR     $CB8C  ;
->
CB8B 9    39             RTS            ;
->
Routine:
CB8C ~ #  7E CF 23       JMP     $CF23  ;
->
Routine:
CB8F      A6 80          LDA     ,X+    ;
CB91 '    27 02          BEQ     $CB95  ;
CB93      8D F7          BSR     $CB8C  ;
->
CB95 Z    5A             DECB           ;
CB96 &    26 F7          BNE     $CB8F  ;
CB98 9    39             RTS            ;
->
CB99 A6 84 30 88 DD 20 CC 00 00 00 00 00 00 00 00 00 ..0.. ..........   ;
CBA9 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 ................   ;
CBB9 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 ................   ;
CBC9 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 ................   ;
CBD9 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 ................   ;
CBE9 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 ................   ;
CBF9 00 00 00 00 00 00 00 08 18 3A 00 00 06 00 08 00 .........:......   ;
CC09 FF 1B 00 00 00 00 00 00 00 00 00 00 00 CD 03 00 ................   ;
CC19 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 ................   ;
CC29 00 00 9F FF 00 00 01 00 00 00 00 00 00 00 00 00 ................   ;
CC39 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 ................   ;
CC49 60 00 00 00 00 00 CC 51 0F 03 44 4F 53 0E 0D 0A `......Q..DOS...   ;
CC59 1E 04 0F 02 0E 04 0F 02 57 48 41 54 3F 0E 04 0F ........WHAT?...   ;
CC69 02 43 41 4E 27 54 20 54 52 41 4E 53 46 45 52 0E .CAN'T TRANSFER.   ;
CC79 04 0F 02 44 49 53 4B 20 45 52 52 4F 52 20 5F 04 ...DISK ERROR _.   ;
CC89 0F 02 44 52 49 56 45 20 00 20 4E 4F 54 20 52 45 ..DRIVE . NOT RE   ;
CC99 41 44 59 04 00 00 00 00 00 00 00 00 00 00 00 00 ADY.............   ;
CCA9 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 ................   ;
CCB9 00 00 00 00 00 00 00 39 00 00 00 00 00 00 00 00 .......9........   ;
CCC9 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 39 ...............9   ;
CCD9 00 00 00 00 00 00 00 00 00 00 00 39 00 00 00 00 ...........9....   ;
CCE9 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 01 ................   ;
CCF9 00 00 00 00 00 00 00                            .......            ;
->
Routine:
CD00 ~ i  7E CD 69       JMP     $CD69  ;
->
CD03 ~ q  7E CD 71       JMP     $CD71  ;
->
CD06 ~    7E CD AE       JMP     $CDAE  ;
->
Routine:
CD09 ~    7E D3 95       JMP     $D395  ;
->
Routine:
CD0C ~    7E D3 95       JMP     $D395  ;
->
Routine:
CD0F ~    7E D3 9B       JMP     $D39B  ;
->
Routine:
CD12 ~    7E D3 9B       JMP     $D39B  ;
->
CD15 7E CE DD 7E CF 23                               ~..~.#             ;
->
Routine:
CD1B ~ -  7E CE 2D       JMP     $CE2D  ;
->
Routine:
CD1E ~ l  7E CE 6C       JMP     $CE6C  ;
->
CD21 7E CF CF                                        ~..                ;
->
Routine:
CD24 ~ {  7E CE 7B       JMP     $CE7B  ;
->
CD27 7E CF F0 7E CD E7 7E D0 18 7E D1 96 7E D0 CD 7E ~..~..~..~..~..~   ;
CD37 D3 5E 7E CF 68 7E CF B6 7E D2 79 7E D1 23 7E CF .^~.h~..~.y~.#~.   ;
CD47 B2                                              .                  ;
->
Routine:
CD48 ~ l  7E D1 6C       JMP     $D16C  ;
->
CD4B 7E D3 38 7E D3 A2 7E CE 02 7E CE 02 7E CD 5D 7E ~.8~..~..~..~.]~   ;
CD5B CB 99                                           ..                 ;
->
Routine:
CD5D      7F CC 11       CLR     $CC11  ;
CD60      BD D4 00       JSR     $D400  ;
CD63   (  7F CC 28       CLR     $CC28  ;
CD66 ~    7E D3 FD       JMP     $D3FD  ;
->
CD69      10 CE C0 7F    LDS     #$C07F ;
->
CD6D ?    3F 1B          SWI     #$1B   ;
CD6F      8D EC          BSR     $CD5D  ;
->
CD71      10 CE C0 7F    LDS     #$C07F ;
CD75 ?    3F FD          SWI     #$FD   ;
CD77      BD DE 18       JSR     $DE18  ;
CD7A      8E CD 03       LDX     #$CD03 ;
CD7D      BF CC 16       STX     $CC16  ;
CD80   L  7F CC 4C       CLR     $CC4C  ;
CD83  b   8D 62          BSR     $CDE7  ;
CD85      B6 CC 11       LDA     $CC11  ;
CD88      B1 CC 02       CMPA    $CC02  ;
CD8B &    26 05          BNE     $CD92  ;
CD8D |    7C CC 15       INC     $CC15  ;
CD90      20 1C          BRA     $CDAE  ;
->
CD92 } (  7D CC 28       TST     $CC28  ;
CD95  &   10 26 05 B7    LBNE    $D350  ;
CD99 ?    3F 1A          SWI     #$1A   ;
CD9B      CC BF FF       LDD     #$BFFF ;
CD9E   +  FD CC 2B       STD     $CC2B  ;
CDA1      CC D3 85       LDD     #$D385 ;
CDA4      FD DF CC       STD     $DFCC  ;
CDA7      BD D4 03       JSR     $D403  ;
CDAA &    26 C1          BNE     $CD6D  ;
CDAC  z   8D 7A          BSR     $CE28  ;
->
CDAE      BD D0 B6       JSR     $D0B6  ;
CDB1      81 20          CMPA    #$20   ;
CDB3 %    25 DD          BCS     $CD92  ;
CDB5   @  8E C8 40       LDX     #$C840 ;
CDB8 |    7C CC 0D       INC     $CC0D  ;
CDBB      BD D0 18       JSR     $D018  ;
CDBE %    25 16          BCS     $CDD6  ;
CDC0   s  8E D3 73       LDX     #$D373 ;
CDC3  >   8D 3E          BSR     $CE03  ;
CDC5 '    27 09          BEQ     $CDD0  ;
CDC7      BE CC 12       LDX     $CC12  ;
CDCA '    27 07          BEQ     $CDD3  ;
CDCC  5   8D 35          BSR     $CE03  ;
CDCE &    26 03          BNE     $CDD3  ;
->
CDD0 n    6E 98 01       JMP     [$01,X];
->
CDD3      BD D2 1E       JSR     $D21E  ;
->
CDD6   _  8E CC 5F       LDX     #$CC5F ;
CDD9      86 15          LDA     #$15   ;
->
CDDB      B7 CC 20       STA     $CC20  ;
CDDE   l  BD CE 6C       JSR     $CE6C  ;
->
CDE1      7F CC 11       CLR     $CC11  ;
CDE4 ~ q  7E CD 71       JMP     $CD71  ;
->
Routine:
CDE7      BE CD 13       LDX     $CD13  ;
CDEA      BF CD 10       STX     $CD10  ;
CDED      BE CD 0D       LDX     $CD0D  ;
CDF0      BF CD 0A       STX     $CD0A  ;
CDF3   #  7F CC 23       CLR     $CC23  ;
CDF6   "  7F CC 22       CLR     $CC22  ;
CDF9   !  7F CC 21       CLR     $CC21  ;
CDFC   &  7F CC 26       CLR     $CC26  ;
CDFF   $  7F CC 24       CLR     $CC24  ;
CE02 9    39             RTS            ;
->
Routine:
CE03    D 10 8E C8 44    LDY     #$C844 ;
->
CE07      A6 A0          LDA     ,Y+    ;
CE09  _   81 5F          CMPA    #$5F   ;
CE0B #    23 02          BLS     $CE0F  ;
CE0D      80 20          SUBA    #$20   ;
->
CE0F      A1 80          CMPA    ,X+    ;
CE11 &    26 08          BNE     $CE1B  ;
CE13 m    6D 84          TST     ,X     ;
CE15 &    26 F0          BNE     $CE07  ;
CE17 m    6D A4          TST     ,Y     ;
CE19 '    27 0C          BEQ     $CE27  ;
->
CE1B m    6D 80          TST     ,X+    ;
CE1D &    26 FC          BNE     $CE1B  ;
CE1F 0    30 02          LEAX    $02,X  ;
CE21 m    6D 84          TST     ,X     ;
CE23 &    26 DE          BNE     $CE03  ;
CE25      1C FB          ANDCC   #$FB   ;
->
CE27 9    39             RTS            ;
->
Routine:
CE28   O  BE CC 4F       LDX     $CC4F  ;
CE2B  ?   8D 3F          BSR     $CE6C  ;
->
CE2D 4    34 20          PSHS    Y      ;
CE2F      C6 1F          LDB     #$1F   ;
CE31      8E C0 80       LDX     #$C080 ;
CE34      10 8E 00 80    LDY     #$0080 ;
CE38      BF CC 14       STX     $CC14  ;
->
CE3B ?    3F 02          SWI     #$02   ;
CE3D      C1 0D          CMPB    #$0D   ;
CE3F ')   27 29          BEQ     $CE6A  ;
->
CE41 ?    3F 01          SWI     #$01   ;
CE43      C1 14          CMPB    #$14   ;
CE45 &    26 14          BNE     $CE5B  ;
CE47 } N  7D CC 4E       TST     $CC4E  ;
CE4A '    27 F5          BEQ     $CE41  ;
CE4C   N  7F CC 4E       CLR     $CC4E  ;
->
CE4F      E6 80          LDB     ,X+    ;
CE51      C4 7F          ANDB    #$7F   ;
CE53      C1 0D          CMPB    #$0D   ;
CE55 '    27 EA          BEQ     $CE41  ;
CE57 ?    3F 02          SWI     #$02   ;
CE59      20 F4          BRA     $CE4F  ;
->
CE5B   N  7F CC 4E       CLR     $CC4E  ;
CE5E      C1 18          CMPB    #$18   ;
CE60 %    25 D9          BCS     $CE3B  ;
CE62      C1 19          CMPB    #$19   ;
CE64 "    22 D5          BHI     $CE3B  ;
CE66      C0 0E          SUBB    #$0E   ;
CE68      20 D1          BRA     $CE3B  ;
->
CE6A 5    35 A0          PULS    PC,Y   ;
->
Routine:
CE6C      8D 0D          BSR     $CE7B  ;
->
Routine:
CE6E      A6 84          LDA     ,X     ;
CE70      81 04          CMPA    #$04   ;
CE72 'D   27 44          BEQ     $CEB8  ;
CE74   #  BD CF 23       JSR     $CF23  ;
CE77 0    30 01          LEAX    $01,X  ;
CE79      20 F3          BRA     $CE6E  ;
->
Routine:
CE7B } !  7D CC 21       TST     $CC21  ;
CE7E &    26 1E          BNE     $CE9E  ;
CE80      B6 CC 03       LDA     $CC03  ;
CE83 '    27 19          BEQ     $CE9E  ;
CE85      B1 CC 1A       CMPA    $CC1A  ;
CE88 "    22 11          BHI     $CE9B  ;
CE8A      7F CC 1A       CLR     $CC1A  ;
CE8D 4    34 04          PSHS    B      ;
CE8F      F6 CC 08       LDB     $CC08  ;
CE92 '    27 05          BEQ     $CE99  ;
->
CE94      8D 08          BSR     $CE9E  ;
CE96 Z    5A             DECB           ;
CE97 &    26 FB          BNE     $CE94  ;
->
CE99 5    35 04          PULS    B      ;
->
CE9B |    7C CC 1A       INC     $CC1A  ;
->
Routine:
CE9E ?    3F 04          SWI     #$04   ;
CEA0 4    34 10          PSHS    X      ;
CEA2   V  8E CC 56       LDX     #$CC56 ;
CEA5      8D C7          BSR     $CE6E  ;
CEA7 5    35 10          PULS    X      ;
CEA9 4    34 04          PSHS    B      ;
CEAB      F6 CC 05       LDB     $CC05  ;
CEAE '    27 06          BEQ     $CEB6  ;
->
CEB0 O    4F             CLRA           ;
CEB1  p   8D 70          BSR     $CF23  ;
CEB3 Z    5A             DECB           ;
CEB4 &    26 FA          BNE     $CEB0  ;
->
CEB6 5    35 04          PULS    B      ;
->
CEB8      1C FE          ANDCC   #$FE   ;
CEBA 9    39             RTS            ;
->
CEBB 0F 06 54 79 70 65 20 61 6E 79 20 6B 65 79 20 74 ..Type any key t   ;
CECB 6F 20 63 6F 6E 74 69 6E 75 65 18 04             o continue..       ;
->
Routine:
CED7      8E CE BB       LDX     #$CEBB ;
CEDA      BD CD 1E       JSR     $CD1E  ;
CEDD } #  7D CC 23       TST     $CC23  ;
CEE0 &    26 1A          BNE     $CEFC  ;
CEE2 } &  7D CC 26       TST     $CC26  ;
CEE5 '    27 10          BEQ     $CEF7  ;
CEE7      8D 1A          BSR     $CF03  ;
CEE9 } /  7D CC 2F       TST     $CC2F  ;
CEEC '    27 11          BEQ     $CEFF  ;
CEEE } $  7D CC 24       TST     $CC24  ;
CEF1 '    27 0C          BEQ     $CEFF  ;
CEF3  S   8D 53          BSR     $CF48  ;
CEF5      20 08          BRA     $CEFF  ;
->
CEF7      BD CD 09       JSR     $CD09  ;
CEFA      20 03          BRA     $CEFF  ;
->
CEFC      BD CD 0C       JSR     $CD0C  ;
->
CEFF      7F CC 1A       CLR     $CC1A  ;
CF02 9    39             RTS            ;
->
Routine:
CF03   G  BF CC 47       STX     $CC47  ;
CF06   &  BE CC 26       LDX     $CC26  ;
CF09      20 06          BRA     $CF11  ;
->
Routine:
CF0B   G  BF CC 47       STX     $CC47  ;
CF0E   $  BE CC 24       LDX     $CC24  ;
->
CF11      BD D4 06       JSR     $D406  ;
CF14 &    26 04          BNE     $CF1A  ;
CF16   G  BE CC 47       LDX     $CC47  ;
CF19 9    39             RTS            ;
->
CF1A   $  7F CC 24       CLR     $CC24  ;
CF1D   y  BD D2 79       JSR     $D279  ;
CF20 ~    7E CD 03       JMP     $CD03  ;
->
Routine:
CF23 } !  7D CC 21       TST     $CC21  ;
CF26 &    26 20          BNE     $CF48  ;
CF28      81 1F          CMPA    #$1F   ;
CF2A "    22 05          BHI     $CF31  ;
CF2C   )  7F CC 29       CLR     $CC29  ;
CF2F      20 17          BRA     $CF48  ;
->
CF31 | )  7C CC 29       INC     $CC29  ;
CF34 4    34 02          PSHS    A      ;
CF36      B6 CC 04       LDA     $CC04  ;
CF39 '    27 0B          BEQ     $CF46  ;
CF3B   )  B1 CC 29       CMPA    $CC29  ;
CF3E $    24 06          BCC     $CF46  ;
CF40   {  BD CE 7B       JSR     $CE7B  ;
CF43 | )  7C CC 29       INC     $CC29  ;
->
CF46 5    35 02          PULS    A      ;
->
Routine:
CF48 4    34 02          PSHS    A      ;
CF4A } "  7D CC 22       TST     $CC22  ;
CF4D &    26 13          BNE     $CF62  ;
CF4F } $  7D CC 24       TST     $CC24  ;
CF52 '    27 04          BEQ     $CF58  ;
CF54      8D B5          BSR     $CF0B  ;
CF56      20 0D          BRA     $CF65  ;
->
CF58 } &  7D CC 26       TST     $CC26  ;
CF5B &    26 08          BNE     $CF65  ;
CF5D      BD CD 0F       JSR     $CD0F  ;
CF60      20 03          BRA     $CF65  ;
->
CF62      BD CD 12       JSR     $CD12  ;
->
CF65 5    35 02          PULS    A      ;
CF67 9    39             RTS            ;
->
Routine:
CF68   J  7F CC 4A       CLR     $CC4A  ;
CF6B      F7 CC 1D       STB     $CC1D  ;
CF6E      86 04          LDA     #$04   ;
CF70   M  B7 CC 4D       STA     $CC4D  ;
CF73      EC 84          LDD     ,X     ;
CF75   `  8E D3 60       LDX     #$D360 ;
->
CF78      8D 0B          BSR     $CF85  ;
CF7A 0    30 02          LEAX    $02,X  ;
CF7C z M  7A CC 4D       DEC     $CC4D  ;
CF7F &    26 F7          BNE     $CF78  ;
CF81      1F 98          TFR     B,A    ;
CF83  =   20 3D          BRA     $CFC2  ;
->
Routine:
CF85   K  7F CC 4B       CLR     $CC4B  ;
->
CF88      10 A3 84       CMPD    ,X     ;
CF8B %    25 07          BCS     $CF94  ;
CF8D      A3 84          SUBD    ,X     ;
CF8F | K  7C CC 4B       INC     $CC4B  ;
CF92      20 F4          BRA     $CF88  ;
->
CF94 4    34 02          PSHS    A      ;
CF96   K  B6 CC 4B       LDA     $CC4B  ;
CF99 &    26 10          BNE     $CFAB  ;
CF9B } J  7D CC 4A       TST     $CC4A  ;
CF9E &    26 0B          BNE     $CFAB  ;
CFA0 }    7D CC 1D       TST     $CC1D  ;
CFA3 '    27 0B          BEQ     $CFB0  ;
CFA5      86 20          LDA     #$20   ;
CFA7  #   8D 23          BSR     $CFCC  ;
CFA9      20 05          BRA     $CFB0  ;
->
CFAB | J  7C CC 4A       INC     $CC4A  ;
CFAE      8D 12          BSR     $CFC2  ;
->
CFB0 5    35 82          PULS    PC,A   ;
CFB2      8D 02          BSR     $CFB6  ;
CFB4 0    30 01          LEAX    $01,X  ;
->
Routine:
CFB6      A6 84          LDA     ,X     ;
CFB8      8D 04          BSR     $CFBE  ;
CFBA      A6 84          LDA     ,X     ;
CFBC      20 04          BRA     $CFC2  ;
->
Routine:
CFBE D    44             LSRA           ;
CFBF D    44             LSRA           ;
CFC0 D    44             LSRA           ;
CFC1 D    44             LSRA           ;
->
Routine:
CFC2      84 0F          ANDA    #$0F   ;
CFC4  0   8B 30          ADDA    #$30   ;
CFC6  9   81 39          CMPA    #$39   ;
CFC8 #    23 02          BLS     $CFCC  ;
CFCA      8B 07          ADDA    #$07   ;
->
Routine:
CFCC ~ #  7E CF 23       JMP     $CF23  ;
->
Routine:
CFCF  0   81 30          CMPA    #$30   ;
CFD1 %    25 14          BCS     $CFE7  ;
CFD3  9   81 39          CMPA    #$39   ;
CFD5 #    23 16          BLS     $CFED  ;
CFD7  A   81 41          CMPA    #$41   ;
CFD9 %    25 0C          BCS     $CFE7  ;
CFDB  Z   81 5A          CMPA    #$5A   ;
CFDD #    23 0E          BLS     $CFED  ;
CFDF  a   81 61          CMPA    #$61   ;
CFE1 %    25 04          BCS     $CFE7  ;
CFE3  z   81 7A          CMPA    #$7A   ;
CFE5 #    23 06          BLS     $CFED  ;
->
CFE7      1A 01          ORCC    #$01   ;
CFE9      B7 CC 11       STA     $CC11  ;
CFEC 9    39             RTS            ;
->
CFED      1C FE          ANDCC   #$FE   ;
CFEF 9    39             RTS            ;
->
Routine:
CFF0 4    34 10          PSHS    X      ;
CFF2      BE CC 14       LDX     $CC14  ;
CFF5      B6 CC 18       LDA     $CC18  ;
CFF8      B7 CC 19       STA     $CC19  ;
->
CFFB      A6 80          LDA     ,X+    ;
CFFD      B7 CC 18       STA     $CC18  ;
D000      81 0D          CMPA    #$0D   ;
D002 '    27 10          BEQ     $D014  ;
D004      B1 CC 02       CMPA    $CC02  ;
D007 '    27 0B          BEQ     $D014  ;
D009      BF CC 14       STX     $CC14  ;
D00C      81 20          CMPA    #$20   ;
D00E &    26 04          BNE     $D014  ;
D010      A1 84          CMPA    ,X     ;
D012 '    27 E7          BEQ     $CFFB  ;
->
D014      8D B9          BSR     $CFCF  ;
D016 5    35 90          PULS    PC,X   ;
->
Routine:
D018      86 15          LDA     #$15   ;
D01A      A7 01          STA     $01,X  ;
D01C      86 FF          LDA     #$FF   ;
D01E      A7 03          STA     $03,X  ;
D020 o    6F 04          CLR     $04,X  ;
D022 o    6F 0C          CLR     $0C,X  ;
D024      BD D0 B6       JSR     $D0B6  ;
D027      86 08          LDA     #$08   ;
D029   K  B7 CC 4B       STA     $CC4B  ;
D02C  4   8D 34          BSR     $D062  ;
D02E %.   25 2E          BCS     $D05E  ;
D030 &    26 0F          BNE     $D041  ;
D032  .   8D 2E          BSR     $D062  ;
D034 %(   25 28          BCS     $D05E  ;
D036 &    26 09          BNE     $D041  ;
D038   ?  BC CC 3F       CMPX    $CC3F  ;
D03B 'l   27 6C          BEQ     $D0A9  ;
D03D  #   8D 23          BSR     $D062  ;
D03F #h   23 68          BLS     $D0A9  ;
->
D041   ?  BE CC 3F       LDX     $CC3F  ;
D044 m    6D 04          TST     $04,X  ;
D046 'a   27 61          BEQ     $D0A9  ;
D048 m    6D 03          TST     $03,X  ;
D04A *    2A 0F          BPL     $D05B  ;
D04C }    7D CC 0D       TST     $CC0D  ;
D04F '    27 05          BEQ     $D056  ;
D051      B6 CC 0B       LDA     $CC0B  ;
D054      20 03          BRA     $D059  ;
->
D056      B6 CC 0C       LDA     $CC0C  ;
->
D059      A7 03          STA     $03,X  ;
->
D05B      7F CC 0D       CLR     $CC0D  ;
->
D05E   ?  BE CC 3F       LDX     $CC3F  ;
D061 9    39             RTS            ;
->
Routine:
D062      8D 8C          BSR     $CFF0  ;
D064 %C   25 43          BCS     $D0A9  ;
D066  9   81 39          CMPA    #$39   ;
D068 "    22 15          BHI     $D07F  ;
D06A   ?  BE CC 3F       LDX     $CC3F  ;
D06D m    6D 03          TST     $03,X  ;
D06F *8   2A 38          BPL     $D0A9  ;
D071      84 03          ANDA    #$03   ;
D073      A7 03          STA     $03,X  ;
D075      BD CF F0       JSR     $CFF0  ;
D078 $/   24 2F          BCC     $D0A9  ;
->
D07A  .   81 2E          CMPA    #$2E   ;
D07C      1C FE          ANDCC   #$FE   ;
D07E 9    39             RTS            ;
->
D07F   K  F6 CC 4B       LDB     $CC4B  ;
D082 +%   2B 25          BMI     $D0A9  ;
D084 4    34 04          PSHS    B      ;
D086      C0 05          SUBB    #$05   ;
D088   K  F7 CC 4B       STB     $CC4B  ;
D08B 5    35 04          PULS    B      ;
->
D08D   I  B1 CC 49       CMPA    $CC49  ;
D090 %    25 02          BCS     $D094  ;
D092      80 20          SUBA    #$20   ;
->
D094      A7 04          STA     $04,X  ;
D096 0    30 01          LEAX    $01,X  ;
D098 Z    5A             DECB           ;
D099      BD CF F0       JSR     $CFF0  ;
D09C $    24 08          BCC     $D0A6  ;
D09E  -   81 2D          CMPA    #$2D   ;
D0A0 '    27 04          BEQ     $D0A6  ;
D0A2  _   81 5F          CMPA    #$5F   ;
D0A4 &    26 06          BNE     $D0AC  ;
->
D0A6 ]    5D             TSTB           ;
D0A7 &    26 E4          BNE     $D08D  ;
->
D0A9      1A 01          ORCC    #$01   ;
D0AB 9    39             RTS            ;
->
D0AC ]    5D             TSTB           ;
D0AD '    27 CB          BEQ     $D07A  ;
D0AF o    6F 04          CLR     $04,X  ;
D0B1 0    30 01          LEAX    $01,X  ;
D0B3 Z    5A             DECB           ;
D0B4      20 F6          BRA     $D0AC  ;
->
Routine:
D0B6   ?  BF CC 3F       STX     $CC3F  ;
D0B9      BE CC 14       LDX     $CC14  ;
->
D0BC      A6 84          LDA     ,X     ;
D0BE      81 20          CMPA    #$20   ;
D0C0 &    26 04          BNE     $D0C6  ;
D0C2 0    30 01          LEAX    $01,X  ;
D0C4      20 F6          BRA     $D0BC  ;
->
D0C6      BF CC 14       STX     $CC14  ;
D0C9   ?  BE CC 3F       LDX     $CC3F  ;
D0CC 9    39             RTS            ;
->
Routine:
D0CD 40   34 30          PSHS    Y,X    ;
D0CF      E6 0C          LDB     $0C,X  ;
D0D1 &    26 1E          BNE     $D0F1  ;
D0D3 1    31 8C 1D       LEAY    $1D,PC ;
D0D6      81 0F          CMPA    #$0F   ;
D0D8 "    22 17          BHI     $D0F1  ;
D0DA      C6 03          LDB     #$03   ;
D0DC =    3D             MUL            ;
D0DD 1    31 AB          LEAY    D,Y    ;
D0DF      C6 03          LDB     #$03   ;
->
D0E1      A6 A0          LDA     ,Y+    ;
D0E3   I  B1 CC 49       CMPA    $CC49  ;
D0E6 %    25 02          BCS     $D0EA  ;
D0E8      80 20          SUBA    #$20   ;
->
D0EA      A7 0C          STA     $0C,X  ;
D0EC 0    30 01          LEAX    $01,X  ;
D0EE Z    5A             DECB           ;
D0EF &    26 F0          BNE     $D0E1  ;
->
D0F1 5    35 B0          PULS    PC,Y,X ;
D0F3 b    62             ----           ;
D0F4 in   69 6E          ROL     $0E,S  ;
D0F6 txt  74 78 74       LSR     $7874  ;
D0F9 cm   63 6D          COM     $0D,S  ;
D0FB db   64 62          LSR     $02,S  ;
D0FD a    61             ----           ;
D0FE ssy  73 73 79       COM     $7379  ;
D101 sba  73 62 61       COM     $6261  ;
D104 k    6B             ----           ;
D105 scr  73 63 72       COM     $6372  ;
D108 da   64 61          LSR     $01,S  ;
D10A tba  74 62 61       LSR     $6261  ;
D10D cd   63 64          COM     $04,S  ;
D10F ir   69 72          ROL     $-0E,S ;
D111 prt  70 72 74       NEG     $7274  ;
D114 ou   6F 75          CLR     $-0B,S ;
D116 tre  74 72 65       LSR     $7265  ;
D119 lr   6C 72          INC     $-0E,S ;
D11B fi   66 69          ROR     $09,S  ;
D11D de   64 65          LSR     $05,S  ;
D11F var  76 61 72       ROR     $6172  ;
D122 c    63 BD D2 0E    COM     [$D20E,PC];
->
D126      BD CF F0       JSR     $CFF0  ;
D129 %"   25 22          BCS     $D14D  ;
D12B  &   8D 26          BSR     $D153  ;
D12D %    25 18          BCS     $D147  ;
D12F 4    34 04          PSHS    B      ;
D131      C6 04          LDB     #$04   ;
->
D133 x    78 CC 1C       ASL     $CC1C  ;
D136 y    79 CC 1B       ROL     $CC1B  ;
D139 Z    5A             DECB           ;
D13A &    26 F7          BNE     $D133  ;
D13C 5    35 04          PULS    B      ;
D13E      BB CC 1C       ADDA    $CC1C  ;
D141      B7 CC 1C       STA     $CC1C  ;
D144 \    5C             INCB           ;
D145      20 DF          BRA     $D126  ;
->
D147      BD CF F0       JSR     $CFF0  ;
D14A $    24 FB          BCC     $D147  ;
D14C 9    39             RTS            ;
->
D14D      BE CC 1B       LDX     $CC1B  ;
->
D150      1C FE          ANDCC   #$FE   ;
D152 9    39             RTS            ;
->
Routine:
D153  _   81 5F          CMPA    #$5F   ;
D155 #    23 02          BLS     $D159  ;
D157      80 20          SUBA    #$20   ;
->
D159  G   80 47          SUBA    #$47   ;
D15B *    2A 0C          BPL     $D169  ;
D15D      8B 06          ADDA    #$06   ;
D15F *    2A 04          BPL     $D165  ;
D161      8B 07          ADDA    #$07   ;
D163 *    2A 04          BPL     $D169  ;
->
D165      8B 0A          ADDA    #$0A   ;
D167 *    2A E7          BPL     $D150  ;
->
D169      1A 01          ORCC    #$01   ;
D16B 9    39             RTS            ;
->
D16C      BD D2 0E       JSR     $D20E  ;
->
D16F      BD CF F0       JSR     $CFF0  ;
D172 %    25 D9          BCS     $D14D  ;
D174  9   81 39          CMPA    #$39   ;
D176 "    22 CF          BHI     $D147  ;
D178      84 0F          ANDA    #$0F   ;
D17A 4    34 04          PSHS    B      ;
D17C 4    34 02          PSHS    A      ;
D17E      FC CC 1B       LDD     $CC1B  ;
D181 X    58             ASLB           ;
D182 I    49             ROLA           ;
D183 X    58             ASLB           ;
D184 I    49             ROLA           ;
D185      F3 CC 1B       ADDD    $CC1B  ;
D188 X    58             ASLB           ;
D189 I    49             ROLA           ;
D18A      EB E0          ADDB    ,S+    ;
D18C      89 00          ADCA    #$00   ;
D18E      FD CC 1B       STD     $CC1B  ;
D191 5    35 04          PULS    B      ;
D193 \    5C             INCB           ;
D194      20 D9          BRA     $D16F  ;
->
Routine:
D196      7F CC 1D       CLR     $CC1D  ;
->
D199  =   8D 3D          BSR     $D1D8  ;
D19B      81 02          CMPA    #$02   ;
D19D '    27 15          BEQ     $D1B4  ;
D19F      81 16          CMPA    #$16   ;
D1A1 &    26 F6          BNE     $D199  ;
D1A3  3   8D 33          BSR     $D1D8  ;
D1A5      B7 CC 1E       STA     $CC1E  ;
D1A8  .   8D 2E          BSR     $D1D8  ;
D1AA      B7 CC 1F       STA     $CC1F  ;
D1AD      86 01          LDA     #$01   ;
D1AF      B7 CC 1D       STA     $CC1D  ;
D1B2      20 E5          BRA     $D199  ;
->
D1B4  "   8D 22          BSR     $D1D8  ;
D1B6      1F 89          TFR     A,B    ;
D1B8      8D 1E          BSR     $D1D8  ;
D1BA      1E 89          EXG     A,B    ;
D1BC      F3 CC 1B       ADDD    $CC1B  ;
D1BF   =  FD CC 3D       STD     $CC3D  ;
D1C2      8D 14          BSR     $D1D8  ;
D1C4      1F 89          TFR     A,B    ;
D1C6 M    4D             TSTA           ;
D1C7 '    27 D0          BEQ     $D199  ;
->
D1C9      8D 0D          BSR     $D1D8  ;
D1CB   =  BE CC 3D       LDX     $CC3D  ;
D1CE      A7 80          STA     ,X+    ;
D1D0   =  BF CC 3D       STX     $CC3D  ;
D1D3 Z    5A             DECB           ;
D1D4 &    26 F3          BNE     $D1C9  ;
D1D6      20 C1          BRA     $D199  ;
->
Routine:
D1D8   @  8E C8 40       LDX     #$C840 ;
D1DB      BD D4 06       JSR     $D406  ;
D1DE '    27 11          BEQ     $D1F1  ;
D1E0      A6 01          LDA     $01,X  ;
D1E2      81 08          CMPA    #$08   ;
D1E4 &    26 0E          BNE     $D1F4  ;
D1E6 2b   32 62          LEAS    $02,S  ;
D1E8      86 04          LDA     #$04   ;
D1EA      A7 84          STA     ,X     ;
D1EC      BD D4 06       JSR     $D406  ;
D1EF &    26 0A          BNE     $D1FB  ;
->
D1F1      1C FE          ANDCC   #$FE   ;
D1F3 9    39             RTS            ;
->
D1F4      B7 CC 20       STA     $CC20  ;
D1F7      81 04          CMPA    #$04   ;
D1F9 '{   27 7B          BEQ     $D276  ;
->
D1FB  |   8D 7C          BSR     $D279  ;
D1FD ~    7E CD E1       JMP     $CDE1  ;
->
D200 4F 8D 3F 25 0F 8D 07 7C CC 4C 8D 8A 20 F2       O.?%...|.L.. .     ;
->
Routine:
D20E O    4F             CLRA           ;
D20F _    5F             CLRB           ;
D210      FD CC 1B       STD     $CC1B  ;
D213 9    39             RTS            ;
->
D214 F6 CC 4C 10 27 FB BB 7E CD 03                   ..L.'..~..         ;
->
Routine:
D21E      86 02          LDA     #$02   ;
D220  ,   8D 2C          BSR     $D24E  ;
D222      8D EA          BSR     $D20E  ;
D224      BD D1 96       JSR     $D196  ;
D227      F6 CC 1D       LDB     $CC1D  ;
D22A '    27 0E          BEQ     $D23A  ;
D22C      F6 CC 11       LDB     $CC11  ;
D22F  ;   C1 3B          CMPB    #$3B   ;
D231 &    26 03          BNE     $D236  ;
D233      BD CE D7       JSR     $CED7  ;
->
D236 n    6E 9F CC 1E    JMP     [$CC1E];
->
D23A   h  8E CC 68       LDX     #$CC68 ;
D23D      86 81          LDA     #$81   ;
D23F ~    7E CD DB       JMP     $CDDB  ;
->
D242 34 02 8E C8 40 BD D0 18 35 02 25 1A             4...@...5.%.       ;
->
Routine:
D24E   @  8E C8 40       LDX     #$C840 ;
D251      BD D0 CD       JSR     $D0CD  ;
D254   @  8E C8 40       LDX     #$C840 ;
D257      86 01          LDA     #$01   ;
D259      A7 84          STA     ,X     ;
D25B      BD D1 D8       JSR     $D1D8  ;
D25E  %   10 25 00 D0    LBCS    $D332  ;
D262      86 FF          LDA     #$FF   ;
D264   ;  A7 88 3B       STA     $3B,X  ;
D267 9    39             RTS            ;
->
D268 B6 CC 11 81 0D 27 07 B1 CC 02 10 26 FB 60       .....'.....&.`     ;
->
D276      1A 01          ORCC    #$01   ;
D278 9    39             RTS            ;
->
Routine:
D279 40   34 30          PSHS    Y,X    ;
D27B      A6 01          LDA     $01,X  ;
D27D      B7 CC 20       STA     $CC20  ;
D280 'm   27 6D          BEQ     $D2EF  ;
D282      BD CD E7       JSR     $CDE7  ;
D285    - 10 BE CC 2D    LDY     $CC2D  ;
D289 &    26 12          BNE     $D29D  ;
D28B      81 10          CMPA    #$10   ;
D28D 'b   27 62          BEQ     $D2F1  ;
D28F      81 01          CMPA    #$01   ;
D291 '    27 06          BEQ     $D299  ;
D293      81 04          CMPA    #$04   ;
D295  # g 10 23 F8 67    LBLS    $CB00  ;
->
D299    h 10 8E D3 68    LDY     #$D368 ;
->
D29D   @  8E C8 40       LDX     #$C840 ;
D2A0 m    6D 02          TST     $02,X  ;
D2A2 '    27 09          BEQ     $D2AD  ;
D2A4      86 04          LDA     #$04   ;
D2A6      A7 84          STA     ,X     ;
D2A8      BD D4 06       JSR     $D406  ;
D2AB &.   26 2E          BNE     $D2DB  ;
->
D2AD   8  8E C8 38       LDX     #$C838 ;
D2B0      C6 0B          LDB     #$0B   ;
D2B2  y   8D 79          BSR     $D32D  ;
D2B4   @  8E C8 40       LDX     #$C840 ;
D2B7      B6 CC 0B       LDA     $CC0B  ;
D2BA      A7 03          STA     $03,X  ;
D2BC      86 01          LDA     #$01   ;
D2BE      A7 84          STA     ,X     ;
D2C0      BD D4 06       JSR     $D406  ;
D2C3 &    26 16          BNE     $D2DB  ;
D2C5      B6 CC 20       LDA     $CC20  ;
D2C8 J    4A             DECA           ;
D2C9 G    47             ASRA           ;
D2CA G    47             ASRA           ;
D2CB L    4C             INCA           ;
D2CC o    6F 88 20       CLR     $20,X  ;
D2CF   !  A7 88 21       STA     $21,X  ;
D2D2      86 15          LDA     #$15   ;
D2D4      A7 84          STA     ,X     ;
D2D6      BD D4 06       JSR     $D406  ;
D2D9 ')   27 29          BEQ     $D304  ;
->
D2DB   z  8E CC 7A       LDX     #$CC7A ;
D2DE   l  BD CE 6C       JSR     $CE6C  ;
D2E1   ?  BE CC 3F       LDX     $CC3F  ;
D2E4      B6 CC 20       LDA     $CC20  ;
D2E7      A7 01          STA     $01,X  ;
D2E9 o    6F 84          CLR     ,X     ;
D2EB _    5F             CLRB           ;
D2EC   h  BD CF 68       JSR     $CF68  ;
->
D2EF 5    35 B0          PULS    PC,Y,X ;
->
D2F1      AE E4          LDX     ,S     ;
D2F3      A6 03          LDA     $03,X  ;
D2F5      84 07          ANDA    #$07   ;
D2F7  0   8B 30          ADDA    #$30   ;
D2F9      B7 CC 91       STA     $CC91  ;
D2FC      8E CC 89       LDX     #$CC89 ;
D2FF   l  BD CE 6C       JSR     $CE6C  ;
D302      20 EB          BRA     $D2EF  ;
->
D304   {  BD CE 7B       JSR     $CE7B  ;
D307   @  8E C8 40       LDX     #$C840 ;
D30A      B6 CC 20       LDA     $CC20  ;
D30D J    4A             DECA           ;
D30E      84 03          ANDA    #$03   ;
D310  ?   C6 3F          LDB     #$3F   ;
D312 =    3D             MUL            ;
D313      CB 04          ADDB    #$04   ;
D315   "  E7 88 22       STB     $22,X  ;
->
D318      BD D4 06       JSR     $D406  ;
D31B &    26 BE          BNE     $D2DB  ;
D31D   #  BD CF 23       JSR     $CF23  ;
D320      81 0D          CMPA    #$0D   ;
D322 &    26 F4          BNE     $D318  ;
D324      86 04          LDA     #$04   ;
D326      A7 84          STA     ,X     ;
D328      BD D4 06       JSR     $D406  ;
D32B      20 C2          BRA     $D2EF  ;
->
Routine:
D32D 40   34 30          PSHS    Y,X    ;
D32F ~    7E D0 E1       JMP     $D0E1  ;
->
D332   y  BD D2 79       JSR     $D279  ;
D335 ~    7E CD E1       JMP     $CDE1  ;
->
D338 35 06 FD CC 43 10 FF CC 45 FC D3 85 FD DF CC 7F 5...C...E.......   ;
D348 CC 20 7C CC 28 7E CD B5                         . |.(~..           ;
->
D350   (  7F CC 28       CLR     $CC28  ;
D353    E 10 FE CC 45    LDS     $CC45  ;
D357      F6 CC 20       LDB     $CC20  ;
D35A n  C 6E 9F CC 43    JMP     [$CC43];
->
D35E 3A 39 27 10 03 E8 00 64 00 0A 65 72 72 6F 72 73 :9'....d..errors   ;
D36E 00 00 73 79 73 47 45 54 00 D2 00 4C 4F 47 4F 46 ..sysGET...LOGOF   ;
D37E 46 00 D3 83 00 3F 2D FC CC 16 ED 6A 3B C6 FE F7 F....?-....j;...   ;
D38E CC 20 CC D3 50 20 F3                            . ..P .            ;
->
D395      1E 89          EXG     A,B    ;
D397 ?    3F 01          SWI     #$01   ;
D399      1E 89          EXG     A,B    ;
->
D39B      1E 89          EXG     A,B    ;
D39D ?    3F 05          SWI     #$05   ;
D39F      1E 89          EXG     A,B    ;
D3A1 9    39             RTS            ;
->
D3A2 34 04 3F 00 C4 7F 5D 35 04 39 1E 89 3F 01 1E 89 4.?...]5.9..?...   ;
D3B2 39 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 9...............   ;
D3C2 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 ................   ;
D3D2 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 D3 ................   ;
D3E2 B2 D3 B2 D3 AC D3 B2 D3 B2 D3 B2 D3 B2 D3 B2 D3 ................   ;
D3F2 B2 D3 B2 D3 B2 D3 A2 D3 9B D3 95                ...........        ;
->
D3FD ~    7E C4 00       JMP     $C400  ;
->
Routine:
D400 ~ :  7E D4 3A       JMP     $D43A  ;
->
Routine:
D403 ~ [  7E D4 5B       JMP     $D45B  ;
->
Routine:
D406 ~ w  7E D4 77       JMP     $D477  ;
->
D409 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 ................   ;
D419 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 ................   ;
D429 00 00 00 00 00 00 00 00 00 00 00 00 FF 00 00 00 ................   ;
D439 00                                              .                  ;
->
D43A      BD DE 15       JSR     $DE15  ;
D43D      8E D4 09       LDX     #$D409 ;
D440      C6 0A          LDB     #$0A   ;
D442      8D 11          BSR     $D455  ;
D444      8E 00 05       LDX     #$0005 ;
D447      BF D4 13       STX     $D413  ;
D44A      BF D4 15       STX     $D415  ;
D44D      7F D4 1A       CLR     $D41A  ;
->
D450      8E D4 1B       LDX     #$D41B ;
D453      C6 1A          LDB     #$1A   ;
->
Routine:
D455 o    6F 80          CLR     ,X+    ;
D457 Z    5A             DECB           ;
D458 &    26 FB          BNE     $D455  ;
D45A 9    39             RTS            ;
->
D45B      BE D4 09       LDX     $D409  ;
D45E '    27 F0          BEQ     $D450  ;
D460 0    30 88 E4       LEAX    $-1C,X ;
D463      BF D4 0B       STX     $D40B  ;
D466 4    34 20          PSHS    Y      ;
D468      BD DA CF       JSR     $DACF  ;
D46B 5    35 20          PULS    Y      ;
D46D $    24 EC          BCC     $D45B  ;
D46F      BE D4 0B       LDX     $D40B  ;
D472 o    6F 02          CLR     $02,X  ;
D474      C6 FF          LDB     #$FF   ;
D476 9    39             RTS            ;
->
D477 4$   34 24          PSHS    Y,B    ;
D479      BF D4 0B       STX     $D40B  ;
D47C o    6F 01          CLR     $01,X  ;
D47E      E6 84          LDB     ,X     ;
D480 &"   26 22          BNE     $D4A4  ;
D482      E6 02          LDB     $02,X  ;
D484 '    27 1A          BEQ     $D4A0  ;
D486      C1 02          CMPB    #$02   ;
D488 '    27 11          BEQ     $D49B  ;
D48A      BD D5 B7       JSR     $D5B7  ;
->
D48D      BE D4 0B       LDX     $D40B  ;
D490 %&   25 26          BCS     $D4B8  ;
D492 }    7D CC FC       TST     $CCFC  ;
D495 &#   26 23          BNE     $D4BA  ;
D497 _    5F             CLRB           ;
D498 5$   35 24          PULS    Y,B    ;
D49A 9    39             RTS            ;
->
D49B      BD D6 D2       JSR     $D6D2  ;
D49E      20 ED          BRA     $D48D  ;
->
D4A0      C6 12          LDB     #$12   ;
D4A2      20 14          BRA     $D4B8  ;
->
D4A4      C1 1D          CMPB    #$1D   ;
D4A6 #    23 04          BLS     $D4AC  ;
D4A8      C6 01          LDB     #$01   ;
D4AA      20 0C          BRA     $D4B8  ;
->
D4AC Z    5A             DECB           ;
D4AD X    58             ASLB           ;
D4AE      8E D4 BF       LDX     #$D4BF ;
D4B1      AD 95          JSR     [B,X]  ;
D4B3      BE D4 0B       LDX     $D40B  ;
D4B6 $    24 02          BCC     $D4BA  ;
->
D4B8      E7 01          STB     $01,X  ;
->
D4BA m    6D 01          TST     $01,X  ;
D4BC 5$   35 24          PULS    Y,B    ;
D4BE 9    39             RTS            ;
->
D4BF D9 84 D9 D7 DB 05 DA CF D5 E5 D8 1A D8 35 D8 74 .............5.t   ;
D4CF D6 44 D6 A2 D9 67 DB E2 DB 38 D6 9C DA 93 D8 13 .D...g...8......   ;
D4DF D5 72 D5 93 DB 13 DD CA DD 08 DC F2 D6 9C D6 9C .r..............   ;
D4EF C7 D1 C7 D1 C7 20 C7 00 C7 D1 8D 20 26 05 C6 02 ..... ..... &...   ;
D4FF 1A 01 39 ED 84 AE 84 6F 84 6F 01 39             ..9....o.o.9       ;
->
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
D51B      FC D4 0B       LDD     $D40B  ;
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
D536 BE D4 0B 4F 5F 8D 02 C6 2F A7 88 11 30 01 5A 26 ...O_.../...0.Z&   ;
D546 F8 39 BE D4 0B C6 0B A6 04 A7 88 24 30 01 5A 26 .9.........$0.Z&   ;
D556 F6 39 BE D4 0B C6 0B A6 04 8A 20 34 02 A6 88 24 .9........ 4...$   ;
D566 8A 20 A1 E0 26 05 30 01 5A 26 EC 39 BE D4 0B E6 . ..&.0.Z&.9....   ;
D576 02 54 24 79 E6 88 23 7E D6 03                   .T$y..#~..         ;
->
Routine:
D580      BE D4 0B       LDX     $D40B  ;
D583   "  E6 88 22       LDB     $22,X  ;
D586 l "  6C 88 22       INC     $22,X  ;
D589 :    3A             ABX            ;
D58A   @  A7 88 40       STA     $40,X  ;
D58D \    5C             INCB           ;
D58E &    26 1F          BNE     $D5AF  ;
D590      1A 01          ORCC    #$01   ;
D592 9    39             RTS            ;
->
D593 BE D4 0B E6 02 C4 03 C1 03 26 55 CA 80 E7 02 E6 .........&U.....   ;
D5A3 0F C5 80 26 0A E6 88 23 3A A7 88 40             ...&...#:..@       ;
->
D5AF      1C FE          ANDCC   #$FE   ;
D5B1 9    39             RTS            ;
->
D5B2 C6 0B 1A 01 39                                  ....9              ;
->
Routine:
D5B7   ;  A6 88 3B       LDA     $3B,X  ;
D5BA +<   2B 3C          BMI     $D5F8  ;
D5BC '    27 07          BEQ     $D5C5  ;
D5BE j ;  6A 88 3B       DEC     $3B,X  ;
D5C1      86 20          LDA     #$20   ;
D5C3      20 1D          BRA     $D5E2  ;
->
D5C5  1   8D 31          BSR     $D5F8  ;
D5C7 %    25 1B          BCS     $D5E4  ;
D5C9      81 18          CMPA    #$18   ;
D5CB "    22 15          BHI     $D5E2  ;
D5CD '    27 F6          BEQ     $D5C5  ;
D5CF      81 09          CMPA    #$09   ;
D5D1 &    26 0C          BNE     $D5DF  ;
D5D3  #   8D 23          BSR     $D5F8  ;
D5D5 %    25 0D          BCS     $D5E4  ;
D5D7      BE D4 0B       LDX     $D40B  ;
D5DA   ;  A7 88 3B       STA     $3B,X  ;
D5DD      20 D8          BRA     $D5B7  ;
->
D5DF M    4D             TSTA           ;
D5E0 '    27 E3          BEQ     $D5C5  ;
->
D5E2      1C FE          ANDCC   #$FE   ;
->
D5E4 9    39             RTS            ;
->
D5E5 BD DA BD 25 09 85 01 27 05 A7 84 7E D9 9E       ...%...'...~..     ;
->
D5F3      C6 12          LDB     #$12   ;
D5F5      1A 01          ORCC    #$01   ;
D5F7 9    39             RTS            ;
->
Routine:
D5F8      BE D4 0B       LDX     $D40B  ;
D5FB   "  E6 88 22       LDB     $22,X  ;
D5FE '    27 0A          BEQ     $D60A  ;
D600 l "  6C 88 22       INC     $22,X  ;
D603 :    3A             ABX            ;
D604   @  A6 88 40       LDA     $40,X  ;
D607      1C FE          ANDCC   #$FE   ;
D609 9    39             RTS            ;
->
D60A      8D 03          BSR     $D60F  ;
D60C $    24 EA          BCC     $D5F8  ;
D60E 9    39             RTS            ;
->
Routine:
D60F      BE D4 0B       LDX     $D40B  ;
D612   @  EC 88 40       LDD     $40,X  ;
D615 l !  6C 88 21       INC     $21,X  ;
D618 &    26 03          BNE     $D61D  ;
D61A l    6C 88 20       INC     $20,X  ;
->
D61D      10 83 00 00    CMPD    #$0000 ;
D621 '    27 1C          BEQ     $D63F  ;
->
Routine:
D623      ED 88 1E       STD     $1E,X  ;
D626 4    34 02          PSHS    A      ;
D628      86 04          LDA     #$04   ;
D62A   "  A7 88 22       STA     $22,X  ;
D62D 5    35 02          PULS    A      ;
D62F      8D 13          BSR     $D644  ;
D631 $    24 10          BCC     $D643  ;
D633      C5 80          BITB    #$80   ;
D635 '    27 04          BEQ     $D63B  ;
D637      C6 10          LDB     #$10   ;
D639      20 06          BRA     $D641  ;
->
D63B      C6 09          LDB     #$09   ;
D63D      20 02          BRA     $D641  ;
->
D63F      C6 08          LDB     #$08   ;
->
D641      1A 01          ORCC    #$01   ;
->
D643 9    39             RTS            ;
->
Routine:
D644  %   8D 25          BSR     $D66B  ;
D646      BE D4 0B       LDX     $D40B  ;
D649      BD DE 0C       JSR     $DE0C  ;
D64C %    25 12          BCS     $D660  ;
->
D64E      8D 11          BSR     $D661  ;
D650      BD DE 00       JSR     $DE00  ;
D653 &    26 03          BNE     $D658  ;
D655      1C FE          ANDCC   #$FE   ;
D657 9    39             RTS            ;
->
D658 4    34 04          PSHS    B      ;
D65A      8D 17          BSR     $D673  ;
D65C 5    35 04          PULS    B      ;
D65E $    24 EE          BCC     $D64E  ;
->
D660 9    39             RTS            ;
->
Routine:
D661      BE D4 0B       LDX     $D40B  ;
D664      EC 88 1E       LDD     $1E,X  ;
D667 0 @  30 88 40       LEAX    $40,X  ;
D66A 9    39             RTS            ;
->
Routine:
D66B O    4F             CLRA           ;
D66C      B7 D4 11       STA     $D411  ;
D66F      B7 D4 12       STA     $D412  ;
D672 9    39             RTS            ;
->
Routine:
D673      C5 10          BITB    #$10   ;
D675 &    26 11          BNE     $D688  ;
D677      C5 80          BITB    #$80   ;
D679 &    26 0D          BNE     $D688  ;
D67B      F6 D4 11       LDB     $D411  ;
D67E \    5C             INCB           ;
D67F      C1 05          CMPB    #$05   ;
D681 '    27 05          BEQ     $D688  ;
D683      F7 D4 11       STB     $D411  ;
D686      20 14          BRA     $D69C  ;
->
D688      7F D4 11       CLR     $D411  ;
D68B      F6 D4 12       LDB     $D412  ;
D68E \    5C             INCB           ;
D68F      C1 07          CMPB    #$07   ;
D691 '    27 0C          BEQ     $D69F  ;
D693      F7 D4 12       STB     $D412  ;
D696      BE D4 0B       LDX     $D40B  ;
D699      BD DE 09       JSR     $DE09  ;
->
D69C      1C FE          ANDCC   #$FE   ;
D69E 9    39             RTS            ;
->
D69F      1A 01          ORCC    #$01   ;
D6A1 9    39             RTS            ;
->
Routine:
D6A2      8D C7          BSR     $D66B  ;
D6A4      BE D4 0B       LDX     $D40B  ;
D6A7      BD DE 0C       JSR     $DE0C  ;
D6AA %    25 20          BCS     $D6CC  ;
->
D6AC      BE D4 0B       LDX     $D40B  ;
D6AF      8D B0          BSR     $D661  ;
D6B1      BD DE 03       JSR     $DE03  ;
D6B4 &    26 0A          BNE     $D6C0  ;
D6B6   5  B6 D4 35       LDA     $D435  ;
D6B9 '7   27 37          BEQ     $D6F2  ;
D6BB      BD DE 06       JSR     $DE06  ;
D6BE '2   27 32          BEQ     $D6F2  ;
->
D6C0  @   C5 40          BITB    #$40   ;
D6C2 &    26 0B          BNE     $D6CF  ;
D6C4 4    34 04          PSHS    B      ;
D6C6      8D AB          BSR     $D673  ;
D6C8 5    35 04          PULS    B      ;
D6CA $    24 E0          BCC     $D6AC  ;
->
D6CC 9    39             RTS            ;
->
D6CD C6 20                                           .                  ;
->
D6CF      1A 01          ORCC    #$01   ;
D6D1 9    39             RTS            ;
->
Routine:
D6D2      BE D4 0B       LDX     $D40B  ;
D6D5   ;  E6 88 3B       LDB     $3B,X  ;
D6D8 +=   2B 3D          BMI     $D717  ;
D6DA      81 20          CMPA    #$20   ;
D6DC &    26 0F          BNE     $D6ED  ;
D6DE \    5C             INCB           ;
D6DF   ;  E7 88 3B       STB     $3B,X  ;
D6E2      C1 7F          CMPB    #$7F   ;
D6E4 &    26 0C          BNE     $D6F2  ;
D6E6      20 0D          BRA     $D6F5  ;
->
D6E8      8D 0B          BSR     $D6F5  ;
D6EA $    24 E6          BCC     $D6D2  ;
D6EC 9    39             RTS            ;
->
D6ED ]    5D             TSTB           ;
D6EE ''   27 27          BEQ     $D717  ;
D6F0      20 F6          BRA     $D6E8  ;
->
D6F2      1C FE          ANDCC   #$FE   ;
D6F4 9    39             RTS            ;
->
Routine:
D6F5 4    34 02          PSHS    A      ;
D6F7      C1 01          CMPB    #$01   ;
D6F9 &    26 04          BNE     $D6FF  ;
D6FB      86 20          LDA     #$20   ;
D6FD      20 10          BRA     $D70F  ;
->
D6FF      86 09          LDA     #$09   ;
D701      8D 14          BSR     $D717  ;
D703 5    35 02          PULS    A      ;
D705 %    25 0F          BCS     $D716  ;
D707 4    34 02          PSHS    A      ;
D709      BE D4 0B       LDX     $D40B  ;
D70C   ;  A6 88 3B       LDA     $3B,X  ;
->
D70F o ;  6F 88 3B       CLR     $3B,X  ;
D712      8D 03          BSR     $D717  ;
D714 5    35 02          PULS    A      ;
->
D716 9    39             RTS            ;
->
Routine:
D717      BE D4 0B       LDX     $D40B  ;
D71A      E6 02          LDB     $02,X  ;
D71C      C1 02          CMPB    #$02   ;
D71E  &   10 26 FE D1    LBNE    $D5F3  ;
D722   "  E6 88 22       LDB     $22,X  ;
D725      C1 04          CMPB    #$04   ;
D727 &    26 08          BNE     $D731  ;
D729 4    34 02          PSHS    A      ;
D72B  !   8D 21          BSR     $D74E  ;
D72D 5    35 02          PULS    A      ;
D72F %    25 0F          BCS     $D740  ;
->
D731      BD D5 80       JSR     $D580  ;
D734 $    24 0A          BCC     $D740  ;
D736      C6 04          LDB     #$04   ;
D738      BE D4 0B       LDX     $D40B  ;
D73B   "  E7 88 22       STB     $22,X  ;
D73E      1C FE          ANDCC   #$FE   ;
->
D740 9    39             RTS            ;
->
Routine:
D741      BE D4 0B       LDX     $D40B  ;
D744 O    4F             CLRA           ;
D745 _    5F             CLRB           ;
D746      ED 88 20       STD     $20,X  ;
D749   B  ED 88 42       STD     $42,X  ;
D74C  '   20 27          BRA     $D775  ;
->
Routine:
D74E      E6 88 12       LDB     $12,X  ;
D751 &"   26 22          BNE     $D775  ;
D753      E6 88 17       LDB     $17,X  ;
D756 'D   27 44          BEQ     $D79C  ;
D758 o    6F 88 17       CLR     $17,X  ;
D75B  ?   8D 3F          BSR     $D79C  ;
D75D %*   25 2A          BCS     $D789  ;
D75F      8D E0          BSR     $D741  ;
D761 %&   25 26          BCS     $D789  ;
D763      8D DC          BSR     $D741  ;
D765 %"   25 22          BCS     $D789  ;
D767      BE D4 0B       LDX     $D40B  ;
D76A      C6 02          LDB     #$02   ;
D76C      E7 88 17       STB     $17,X  ;
D76F      EC 88 11       LDD     $11,X  ;
D772 ~    7E DC 8E       JMP     $DC8E  ;
->
D775      8D 0E          BSR     $D785  ;
D777      BE D4 0B       LDX     $D40B  ;
D77A   @  ED 88 40       STD     $40,X  ;
D77D      BD D6 A2       JSR     $D6A2  ;
D780 $    24 1A          BCC     $D79C  ;
D782 ~    7E DB CD       JMP     $DBCD  ;
->
Routine:
D785      8D 03          BSR     $D78A  ;
D787      EC 84          LDD     ,X     ;
->
D789 9    39             RTS            ;
->
Routine:
D78A      BE D4 0B       LDX     $D40B  ;
D78D      E6 03          LDB     $03,X  ;
D78F      86 06          LDA     #$06   ;
D791 =    3D             MUL            ;
D792      8E D4 1D       LDX     #$D41D ;
D795 :    3A             ABX            ;
D796      BF D4 1B       STX     $D41B  ;
D799 m    6D 84          TST     ,X     ;
D79B 9    39             RTS            ;
->
Routine:
D79C      8D E7          BSR     $D785  ;
D79E &    26 05          BNE     $D7A5  ;
D7A0      C6 07          LDB     #$07   ;
->
D7A2      1A 01          ORCC    #$01   ;
D7A4 9    39             RTS            ;
->
D7A5      BE D4 0B       LDX     $D40B  ;
D7A8      ED 88 13       STD     $13,X  ;
D7AB m    6D 88 12       TST     $12,X  ;
D7AE &    26 03          BNE     $D7B3  ;
D7B0      ED 88 11       STD     $11,X  ;
->
D7B3 l    6C 88 16       INC     $16,X  ;
D7B6 &    26 03          BNE     $D7BB  ;
D7B8 l    6C 88 15       INC     $15,X  ;
->
D7BB m    6D 88 17       TST     $17,X  ;
D7BE '    27 0B          BEQ     $D7CB  ;
D7C0   O  BD DC 4F       JSR     $DC4F  ;
D7C3 %    25 DD          BCS     $D7A2  ;
D7C5      BE D4 0B       LDX     $D40B  ;
D7C8      EC 88 13       LDD     $13,X  ;
->
D7CB   #  BD D6 23       JSR     $D623  ;
D7CE %    25 D2          BCS     $D7A2  ;
D7D0      BE D4 0B       LDX     $D40B  ;
D7D3   @  EC 88 40       LDD     $40,X  ;
D7D6 4    34 06          PSHS    D      ;
D7D8      8D B0          BSR     $D78A  ;
D7DA 5    35 06          PULS    D      ;
D7DC      ED 84          STD     ,X     ;
D7DE &    26 0A          BNE     $D7EA  ;
D7E0 o    6F 02          CLR     $02,X  ;
D7E2 o    6F 03          CLR     $03,X  ;
D7E4 o    6F 04          CLR     $04,X  ;
D7E6 o    6F 05          CLR     $05,X  ;
D7E8      20 08          BRA     $D7F2  ;
->
D7EA      10 AE 04       LDY     $04,X  ;
D7ED 1?   31 3F          LEAY    $-01,Y ;
D7EF      10 AF 04       STY     $04,X  ;
->
D7F2 O    4F             CLRA           ;
D7F3      BE D4 0B       LDX     $D40B  ;
D7F6 l !  6C 88 21       INC     $21,X  ;
D7F9 &    26 03          BNE     $D7FE  ;
D7FB l    6C 88 20       INC     $20,X  ;
->
D7FE _    5F             CLRB           ;
->
D7FF   @  A7 88 40       STA     $40,X  ;
D802 0    30 01          LEAX    $01,X  ;
D804 Z    5A             DECB           ;
D805 &    26 F8          BNE     $D7FF  ;
D807      BE D4 0B       LDX     $D40B  ;
D80A      EC 88 20       LDD     $20,X  ;
D80D   B  ED 88 42       STD     $42,X  ;
D810      1C FE          ANDCC   #$FE   ;
D812 9    39             RTS            ;
->
Routine:
D813 _    5F             CLRB           ;
D814 4    34 04          PSHS    B      ;
D816      C6 03          LDB     #$03   ;
D818      20 08          BRA     $D822  ;
->
D81A F6 D4 13 34 04 F6 D4 14                         ...4....           ;
->
D822      BE D4 0B       LDX     $D40B  ;
D825   A  E7 88 41       STB     $41,X  ;
D828 5    35 04          PULS    B      ;
D82A   @  E7 88 40       STB     $40,X  ;
D82D      7F D4 18       CLR     $D418  ;
D830 _    5F             CLRB           ;
D831   "  E7 88 22       STB     $22,X  ;
D834 9    39             RTS            ;
->
D835 BE D4 0B E6 88 22 26 1E BD D6 0F 25 31 BE D4 0B ....."&....%1...   ;
D845 7D D4 18 26 06 CC 00 05 FD D4 18 86 10 A7 88 22 }..&..........."   ;
D855 EC 88 1E ED 88 2F A6 88 22 A7 88 31 C6 18 34 14 ...../.."..1..4.   ;
D865 BD D5 F8 35 14 A7 04 30 01 5A 26 F2 1C FE 39    ...5...0.Z&...9    ;
->
Routine:
D874      BE D4 0B       LDX     $D40B  ;
D877   1  A6 88 31       LDA     $31,X  ;
D87A   "  A7 88 22       STA     $22,X  ;
D87D      C6 18          LDB     #$18   ;
->
D87F 4    34 14          PSHS    X,B    ;
D881      A6 04          LDA     $04,X  ;
D883      BD D7 17       JSR     $D717  ;
D886 5    35 14          PULS    X,B    ;
D888 0    30 01          LEAX    $01,X  ;
D88A Z    5A             DECB           ;
D88B &    26 F2          BNE     $D87F  ;
D88D ~    7E D6 A2       JMP     $D6A2  ;
->
D890 BE D4 0B A6 03 A7 88 23 B6 D4 17 7D D4 1A 26 31 .......#...}..&1   ;
D8A0 A7 03 BE D4 15 BF D4 13 8C 00 05 27 0C 8D 22 23 ...........'.."#   ;
D8B0 37 BE D4 18 BF D4 13 20 EF BE D4 0B A6 88 23 A7 7...... ......#.   ;
D8C0 03 2A 0E BD DD CA 25 36 8D 07 23 1C BD DD BA 20 .*....%6..#....    ;
D8D0 F2 BE D4 0B 7F D4 1A BD D5 48 BD D8 1A BD D8 35 .........H.....5   ;
D8E0 24 07 C1 08 27 18 1A 01 39 BE D4 0B A6 04 27 0C $...'...9.....'.   ;
D8F0 2A 02 8D 0F BD D5 58 26 E4 1C FE 39 8D 05 1C FB *.....X&...9....   ;
D900 1C FE 39 A6 88 33 26 0C EC 88 2F ED 88 32 A6 88 ..9..3&.../..2..   ;
D910 31 A7 88 34 39 BD D7 8A 26 17 8D 18 25 15 C6 06 1..49...&...%...   ;
D920 10 BE D4 0B BE D4 1B A6 A8 5D 31 21 A7 80 5A 26 .........]1!..Z&   ;
D930 F6 1C FE 39                                     ...9               ;
->
Routine:
D934      BD D8 13       JSR     $D813  ;
D937      BD D6 0F       JSR     $D60F  ;
D93A %    25 08          BCS     $D944  ;
D93C      BE D4 0B       LDX     $D40B  ;
D93F      C6 10          LDB     #$10   ;
D941   "  E7 88 22       STB     $22,X  ;
->
D944 9    39             RTS            ;
->
Routine:
D945      BD D7 8A       JSR     $D78A  ;
D948      8D EA          BSR     $D934  ;
D94A %    25 F8          BCS     $D944  ;
D94C      C6 06          LDB     #$06   ;
D94E      10 BE D4 0B    LDY     $D40B  ;
D952      BE D4 1B       LDX     $D41B  ;
->
D955      A6 80          LDA     ,X+    ;
D957   ]  A7 A8 5D       STA     $5D,Y  ;
D95A 1!   31 21          LEAY    $01,Y  ;
D95C Z    5A             DECB           ;
D95D &    26 F6          BNE     $D955  ;
D95F      BD D6 A2       JSR     $D6A2  ;
D962 $    24 E0          BCC     $D944  ;
D964 ~    7E DB CD       JMP     $DBCD  ;
->
Routine:
D967      BE D4 0B       LDX     $D40B  ;
D96A      86 02          LDA     #$02   ;
D96C      A7 02          STA     $02,X  ;
D96E   /  EC 88 2F       LDD     $2F,X  ;
D971      ED 88 1E       STD     $1E,X  ;
D974   D  BD D6 44       JSR     $D644  ;
D977 %    25 08          BCS     $D981  ;
D979   t  BD D8 74       JSR     $D874  ;
D97C $    24 05          BCC     $D983  ;
D97E ~    7E DB CD       JMP     $DBCD  ;
->
D981      C6 0A          LDB     #$0A   ;
->
D983 9    39             RTS            ;
->
D984 BD D4 F9 25 3D BD D8 90 25 3F 26 3B BE D4 0B 7D ...%=...%?&;...}   ;
D994 D4 1A 27 06 A6 0F 85 20 26 29 BD DC CD 25 2A EC ..'.... &)...%*.   ;
D9A4 88 11 ED 88 40 BD DA 82 E6 88 17 27 13 34 04 BD ....@......'.4..   ;
D9B4 D6 0F 35 04 25 13 5A 26 F4 BE D4 0B 5F E7 88 22 ..5.%.Z&...._.."   ;
D9C4 1C FE 39 C6 11 20 02 C6 04 34 04 BD D5 0B 35 04 ..9.. ...4....5.   ;
D9D4 1A 01 39 BE D4 0B 6D 03 2A 08 BD DD CA 24 03 C6 ..9...m.*....$..   ;
D9E4 10 39 BD D4 F9 25 E2 BD D5 36 BD D9 15 25 DA BD .9...%...6...%..   ;
D9F4 D8 90 25 D5 26 04 C6 03 20 CF BD DC CD 25 CA BE ..%.&... ....%..   ;
DA04 D4 0B C6 0A 6F 0F 30 01 5A 26 F9 BE D4 0B EC 88 ....o.0.Z&......   ;
DA14 32 27 34 ED 88 2F A6 88 34 A7 88 31 FC CC 0E ED 2'4../..4..1....   ;
DA24 88 19 B6 CC 10 A7 88 1B A6 03 8E D4 36 A6 86 BE ............6...   ;
DA34 D4 0B A7 88 18 BD DD BA BD D9 67 25 8C 8D 3F 86 ..........g%..?.   ;
DA44 04 A7 88 22 1C FE 39 BE D4 0B 6F 88 17 6C 88 12 ..."..9...o..l..   ;
DA54 EC 88 2F BD D6 23 25 0D BD D7 75 25 08 BD D6 A2 ../..#%...u%....   ;
DA64 24 06 BD DB CD 7E D9 CD BE D4 0B EC 88 1E ED 88 $....~..........   ;
DA74 32 86 10 A7 88 34 BD D9 45 25 EA 7E D9 FE BE D4 2....4..E%.~....   ;
DA84 0B A6 84 A7 02 6F 84 6F 88 3B 4F A7 88 22 39 8D .....o.o.;O.."9.   ;
DA94 28 25 0E 6F 84 44 10 25 FB 71 C6 04 E7 88 22 1C (%.o.D.%.q....".   ;
DAA4 FE 39                                           .9                 ;
->
Routine:
DAA6      BE D4 0B       LDX     $D40B  ;
DAA9      A6 02          LDA     $02,X  ;
DAAB      81 83          CMPA    #$83   ;
DAAD &    26 0B          BNE     $DABA  ;
DAAF      86 03          LDA     #$03   ;
DAB1      A7 02          STA     $02,X  ;
->
Routine:
DAB3      BD D6 A2       JSR     $D6A2  ;
DAB6  %   10 25 01 13    LBCS    $DBCD  ;
->
DABA      1C FE          ANDCC   #$FE   ;
DABC 9    39             RTS            ;
->
Routine:
DABD      8D E7          BSR     $DAA6  ;
DABF %    25 0D          BCS     $DACE  ;
DAC1      BE D4 0B       LDX     $D40B  ;
DAC4      A6 02          LDA     $02,X  ;
DAC6      81 03          CMPA    #$03   ;
DAC8 #    23 F0          BLS     $DABA  ;
DACA      C6 12          LDB     #$12   ;
DACC      1A 01          ORCC    #$01   ;
->
DACE 9    39             RTS            ;
->
Routine:
DACF      8D EC          BSR     $DABD  ;
DAD1 %1   25 31          BCS     $DB04  ;
DAD3      81 02          CMPA    #$02   ;
DAD5 '    27 08          BEQ     $DADF  ;
->
DAD7      BE D4 0B       LDX     $D40B  ;
DADA o    6F 02          CLR     $02,X  ;
DADC ~    7E D5 0B       JMP     $D50B  ;
->
DADF      A6 88 12       LDA     $12,X  ;
DAE2 &    26 05          BNE     $DAE9  ;
DAE4      BD DB B3       JSR     $DBB3  ;
DAE7      20 19          BRA     $DB02  ;
->
DAE9      8D C8          BSR     $DAB3  ;
DAEB %    25 17          BCS     $DB04  ;
DAED      BE D4 0B       LDX     $D40B  ;
DAF0 m    6D 88 17       TST     $17,X  ;
DAF3 '    27 05          BEQ     $DAFA  ;
DAF5      BD DC A4       JSR     $DCA4  ;
DAF8 %    25 0A          BCS     $DB04  ;
->
DAFA   g  BD D9 67       JSR     $D967  ;
DAFD %    25 05          BCS     $DB04  ;
DAFF   E  BD D9 45       JSR     $D945  ;
->
DB02 $    24 D3          BCC     $DAD7  ;
->
DB04 9    39             RTS            ;
->
DB05 BD D9 84 25 28 BD D6 0F 25 23 86 03 20 18 BD D9 ...%(...%#.. ...   ;
DB15 84 25 1A BE D4 0B A6 0F 85 80 26 12 EC 88 13 BD .%........&.....   ;
DB25 D6 23 25 09 86 02 BE D4 0B A7 02 1C FE 39 C6 0B .#%..........9..   ;
DB35 1A 01 39 8D 35 BD D8 90 25 2A 27 24 BE D4 0B C6 ..9.5...%*'$....   ;
DB45 0B A6 88 24 A7 04 30 01 5A 26 F6 8D 4D 25 15 BE ...$..0.Z&..M%..   ;
DB55 D4 0B A6 0F 85 80 26 D6 85 60 26 09 8D 0C 20 55 ......&..`&... U   ;
DB65 C6 03 1A 01 39 C6 0C 1A 01 39 BE D4 0B 86 0B B7 ....9....9......   ;
DB75 D4 11 A6 04 E6 88 35 A7 88 35 E7 04 30 01 7A D4 ......5..5..0.z.   ;
DB85 11 26 EF BE D4 0B A6 0C 26 0C C6 03 A6 88 3D A7 .&......&.....=.   ;
DB95 0C 30 01 5A 26 F6 BE D4 0B 39 8D CE BD D8 90 25 .0.Z&....9.....%   ;
DBA5 07 26 06 BE D4 0B 1C FE 39 C6 04 1A 01 39       .&......9....9     ;
->
Routine:
DBB3      BE D4 0B       LDX     $D40B  ;
DBB6      86 FF          LDA     #$FF   ;
DBB8      A7 04          STA     $04,X  ;
DBBA   g  BD D9 67       JSR     $D967  ;
DBBD      BE D4 0B       LDX     $D40B  ;
DBC0      86 00          LDA     #$00   ;
DBC2      A7 02          STA     $02,X  ;
DBC4 9    39             RTS            ;
->
DBC5 ED 88 40 BD D6 A2 24 14                         ..@...$.           ;
->
DBCD  @   C5 40          BITB    #$40   ;
DBCF &    26 08          BNE     $DBD9  ;
DBD1      C5 80          BITB    #$80   ;
DBD3 '    27 0A          BEQ     $DBDF  ;
DBD5      C6 10          LDB     #$10   ;
DBD7      20 06          BRA     $DBDF  ;
->
DBD9      C6 0B          LDB     #$0B   ;
DBDB      20 02          BRA     $DBDF  ;
->
DBDD C6 0A                                           ..                 ;
->
DBDF      1A 01          ORCC    #$01   ;
DBE1 9    39             RTS            ;
->
DBE2 BD D9 15 25 5E 8D B8 25 5A BE D4 0B A6 0F 85 80 ...%^..%Z.......   ;
DBF2 26 52 85 60 26 52 BD D7 8A BE D4 1B EC 02 26 0F &R.`&R........&.   ;
DC02 BE D4 0B EC 88 11 27 33 BE D4 1B ED 84 20 14 BE ......'3..... ..   ;
DC12 D4 0B BD D6 23 25 2C BE D4 0B EC 88 11 27 1C 8D ....#%,......'..   ;
DC22 A2 25 20 BE D4 0B EC 88 13 BE D4 1B ED 02 BE D4 .% .............   ;
DC32 0B EC 88 15 BE D4 1B E3 04 ED 04 BD DB B3 25 03 ..............%.   ;
DC42 BD D9 45 39 C6 0B 20 02 C6 0C 1A 01 39          ..E9.. .....9      ;
->
Routine:
DC4F      EC 88 1E       LDD     $1E,X  ;
DC52 \    5C             INCB           ;
DC53   <  E1 88 3C       CMPB    $3C,X  ;
DC56 #    23 03          BLS     $DC5B  ;
DC58      C6 01          LDB     #$01   ;
DC5A L    4C             INCA           ;
->
DC5B      10 A3 88 13    CMPD    $13,X  ;
DC5F &    26 0E          BNE     $DC6F  ;
DC61   7  A6 88 37       LDA     $37,X  ;
DC64      81 FF          CMPA    #$FF   ;
DC66 '    27 07          BEQ     $DC6F  ;
DC68 L    4C             INCA           ;
DC69   7  A7 88 37       STA     $37,X  ;
DC6C      1C FE          ANDCC   #$FE   ;
DC6E 9    39             RTS            ;
->
DC6F  3   8D 33          BSR     $DCA4  ;
DC71 %0   25 30          BCS     $DCA3  ;
DC73      BE D4 0B       LDX     $D40B  ;
DC76   :  A6 88 3A       LDA     $3A,X  ;
DC79      8B 03          ADDA    #$03   ;
DC7B &    26 16          BNE     $DC93  ;
DC7D      EC 88 1E       LDD     $1E,X  ;
DC80      10 A3 88 11    CMPD    $11,X  ;
DC84 '    27 05          BEQ     $DC8B  ;
DC86      C6 17          LDB     #$17   ;
DC88      1A 01          ORCC    #$01   ;
DC8A 9    39             RTS            ;
->
DC8B   @  EC 88 40       LDD     $40,X  ;
->
DC8E   8  ED 88 38       STD     $38,X  ;
DC91      86 04          LDA     #$04   ;
->
DC93   :  A7 88 3A       STA     $3A,X  ;
DC96      EC 88 13       LDD     $13,X  ;
DC99   5  ED 88 35       STD     $35,X  ;
DC9C      86 01          LDA     #$01   ;
DC9E   7  A7 88 37       STA     $37,X  ;
DCA1      1C FE          ANDCC   #$FE   ;
->
DCA3 9    39             RTS            ;
->
Routine:
DCA4   8  EC 88 38       LDD     $38,X  ;
DCA7   #  BD D6 23       JSR     $D623  ;
DCAA %    25 F7          BCS     $DCA3  ;
DCAC      BE D4 0B       LDX     $D40B  ;
DCAF      1F 12          TFR     X,Y    ;
DCB1   :  E6 88 3A       LDB     $3A,X  ;
DCB4      12             NOP            ;
DCB5 :    3A             ABX            ;
DCB6      C6 03          LDB     #$03   ;
->
DCB8   5  A6 A8 35       LDA     $35,Y  ;
DCBB 1!   31 21          LEAY    $01,Y  ;
DCBD   @  A7 88 40       STA     $40,X  ;
DCC0 0    30 01          LEAX    $01,X  ;
DCC2 Z    5A             DECB           ;
DCC3 &    26 F3          BNE     $DCB8  ;
DCC5      BD D6 A2       JSR     $D6A2  ;
DCC8 $    24 D9          BCC     $DCA3  ;
DCCA ~    7E DB CD       JMP     $DBCD  ;
->
DCCD BD D8 13 BD D6 0F 25 46 BE D4 0B 4F 5F ED 88 20 ......%F...O_..    ;
DCDD A6 88 67 A7 88 3C 5F 6F 88 40 30 01 5A 26 F8 BE ..g..<_o.@0.Z&..   ;
DCED D4 0B 1C FE 39 BE D4 0B A6 88 17 27 1D EC 88 20 ....9......'...    ;
DCFD 83 00 01 2A 03 7E DD A7 ED 88 20 BD DA BD 25 0E ...*.~.... ...%.   ;
DD0D 46 24 07 6F 84 A6 88 17 26 05 C6 12 1A 01 39 7F F$.o....&.....9.   ;
DD1D D4 11 EC 88 11 10 AE 88 20 27 6A BD DD AC 25 EE ........ 'j...%.   ;
DD2D 4F 5F 6D 02 27 74 EB 02 89 00 BF D4 0F BE D4 0B O_m.'t..........   ;
DD3D 10 A3 88 20 24 2C BE D4 0F 30 03 34 02 B6 D4 11 ... $,...0.4....   ;
DD4D 4C B7 D4 11 81 54 27 08 81 A8 35 02 27 4C 20 D2 L....T'...5.'L .   ;
DD5D 34 04 BE D4 0B EC 88 40 8D 45 25 3E 35 04 35 02 4......@.E%>5.5.   ;
DD6D 20 C0 A3 88 20 BE D4 0F A6 02 34 04 A0 E0 4A 1F  ... .....4...J.   ;
DD7D 89 A6 84 EB 01 BE D4 0B 25 05 E1 88 3C 23 06 E0 ........%...<#..   ;
DD8D 88 3C 4C 20 F5 BD D6 23 25 14 BE D4 0B EC 88 42 .<L ...#%......B   ;
DD9D 10 A3 88 20 27 14 C6 19 20 02 C6 18 1A 01 39 BD ... '... .....9.   ;
DDAD D6 23 25 08 BE D4 0B C6 44 3A 1C FE 39 BE D4 0B .#%.....D:..9...   ;
DDBD C6 0B A6 88 24 A7 04 30 01 5A 26 F6 39 BE D4 0B ....$..0.Z&.9...   ;
DDCD A6 03 4C 81 04 24 0F A7 03 26 05 BD DE 0F 20 03 ..L..$...&.... .   ;
DDDD BD DE 12 25 E8 39 C6 10 1A 01 39 00 00 00 00 00 ...%.9....9.....   ;
DDED 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 ................   ;
DDFD 00 00 00                                        ...                ;
->
Routine:
DE00 ~ $  7E DE 24       JMP     $DE24  ;			Read Single Sector
->
Routine:
DE03 ~    7E DE B2       JMP     $DEB2  ;			Write Single Sector
->
Routine:
DE06 ~    7E DE DE       JMP     $DEDE  ;			Verify Last Sector Written
->
Routine:
DE09 ~    7E DE EF       JMP     $DEEF  ;			Restore Head To Track 0
->
Routine:
DE0C ~    7E DF 0E       JMP     $DF0E  ;			Select Specified Drive
->
Routine:
DE0F ~ [  7E DF 5B       JMP     $DF5B  ;			Check for Drive Ready
->
Routine:
DE12      7E DF 40       JMP     $DF40  ;			Quick Check for Drive Ready
->
Routine:
DE15 ~ k  7E DF 6B       JMP     $DF6B  ;			Drive Initialisation (cold start)
->
Routine:
DE18 ~ u  7E DF 75       JMP     $DF75  ;			Drive Initialisation (warm start)
->
Routine:
DE1B      7E DE 59       JMP     $DE59  ;			Seek to Specified Track
->
DE1E 00 00 00 00 00 00					;			initialised to 00 on cold start
->
;
;	READ SINGLE SECTOR (READ)
;	------------------
;
DE24  3   8D 33          BSR     $DE59  ;			FLEX:SEEK
DE26 ?    3F FC          SWI     #$FC   ;
DE28      1A 10          ORCC    #$10   ;
DE2A      86 88          LDA     #$88   ;
DE2C      B7 E0 18       STA     $E018  ;
DE2F   v  17 00 76       LBSR    $DEA8  ;
DE32 4    34 08          PSHS    DP     ;
DE34      86 E0          LDA     #$E0   ;
DE36      1F 8B          TFR     A,DP   ;
DE38      20 04          BRA     $DE3E  ;
->
DE3A      96 1B          LDA     $1B    ;(DP$1B);
DE3C      A7 80          STA     ,X+    ;
->
DE3E      D6 18          LDB     $18    ;(DP$18);
DE40      C5 02          BITB    #$02   ;
DE42 &    26 F6          BNE     $DE3A  ;
DE44      C5 01          BITB    #$01   ;
DE46 &    26 F6          BNE     $DE3E  ;
DE48 5    35 08          PULS    DP     ;
DE4A      1C EF          ANDCC   #$EF   ;
DE4C ?    3F FD          SWI     #$FD   ;
DE4E      C5 9C          BITB    #$9C   ;
DE50 9    39             RTS            ;
->
Routine:
DE51      F6 E0 18       LDB     $E018  ;			WD1771 status register
DE54      C5 01          BITB    #$01   ;			BUSY
DE56 &    26 F9          BNE     $DE51  ;			keep waiting
DE58 9    39             RTS            ;			DONE
->
Routine:
;
;	SEEK TO SPECIFIED TRACK (SEEK)
;	-----------------------
;	Entry:
;		A : Track Number
;		B : Sector Number
;	Exit:
;		X : Destroyed
;		A : Destroyed
;		B : Error
;		Z : Error ?
;
DE59 ?    3F FC          SWI     #$FC   ;		??
DE5B      F7 E0 1A       STB     $E01A  ;			WD1771 Sector register
DE5E      C1 0B          CMPB    #$0B   ;			sector numner > 11?
DE60      C6 00          LDB     #$00   ;			top side
DE62 %    25 02          BCS     $DE66  ;			
DE64  @   C6 40          LDB     #$40   ;			bottom side
->
DE66      FA DE 1E       ORB     $DE1E  ;		?? drive number
DE69      F7 E0 14       STB     $E014  ;			drive select register
DE6C      B1 E0 19       CMPA    $E019  ;			WD1771 Track register
DE6F      27 1D          BEQ     $DE8E  ;			no need to seek
DE71      B7 E0 1B       STA     $E01B  ;
DE74      8D 18          BSR     $DE8E  ;
DE76 ?    3F FC          SWI     #$FC   ;		??
DE78      86 1B          LDA     #$1B   ;
DE7A      B7 E0 18       STA     $E018  ;
DE7D  )   8D 29          BSR     $DEA8  ;
DE7F 4    34 14          PSHS    X,B    ;
DE81      8D CE          BSR     $DE51  ;
DE83   @  8E 01 40       LDX     #$0140 ;
->
DE86      8D 20          BSR     $DEA8  ;
DE88 0    30 1F          LEAX    $-01,X ;
DE8A &    26 FA          BNE     $DE86  ;
DE8C 5    35 94          PULS    PC,X,B ;			DONE
->
Routine:
DE8E 4    34 04          PSHS    B      ;
DE90      F6 E0 18       LDB     $E018  ;			WD1771 Status register
DE93 *    2A 02          BPL     $DE97  ;
DE95      8D 04          BSR     $DE9B  ;
->
DE97 ?    3F FD          SWI     #$FD   ;		??
DE99 5    35 84          PULS    PC,B   ;			DONE
->
Routine:
DE9B 4    34 10          PSHS    X      ;
DE9D  :   8E 3A 98       LDX     #$3A98 ;
->
DEA0      8D 06          BSR     $DEA8  ;
DEA2 0    30 1F          LEAX    $-01,X ;
DEA4 &    26 FA          BNE     $DEA0  ;
DEA6 5    35 90          PULS    PC,X   ;
->
Routine:
DEA8      17 00 00       LBSR    $DEAB  ;
->
Routine:
DEAB      17 00 00       LBSR    $DEAE  ;
->
Routine:
DEAE      17 00 00       LBSR    $DEB1  ;
->
Routine:
DEB1 9    39             RTS            ;
->
;
;	WRITE SINGLE SECTOR (WRITE)
;	-------------------
;
DEB2      8D A5          BSR     $DE59  ;			FLEX SEEK
DEB4 ?    3F FC          SWI     #$FC   ;			enter protected mode
DEB6      1A 10          ORCC    #$10   ;
DEB8      86 A8          LDA     #$A8   ;			1010 (write single sector) 1000 (disable spin-up sequence)
DEBA      B7 E0 18       STA     $E018  ;			command register
DEBD      8D E9          BSR     $DEA8  ;			wait
DEBF 4    34 08          PSHS    DP     ;			save DP
DEC1      86 E0          LDA     #$E0   ;			set DP to E000
DEC3      1F 8B          TFR     A,DP   ;			via A
DEC5      20 02          BRA     $DEC9  ;			jump 1
->
DEC7      97 1B          STA     $1B    ;(DP$1B);	WD1771 data register
->
DEC9      A6 80          LDA     ,X+    ;			get next byte to write
->
DECB      D6 18          LDB     $18    ;(DP$18);	WD1771 status register
DECD      C5 02          BITB    #$02   ;			DRQ flag
DECF &    26 F6          BNE     $DEC7  ;			ready to write so do so
DED1      C5 01          BITB    #$01   ;			BUSY flag
DED3 &    26 F6          BNE     $DECB  ;			keep checking until not busy
DED5 5    35 08          PULS    DP     ;			get DP back
DED7      1C EF          ANDCC   #$EF   ;
DED9 ?    3F FD          SWI     #$FD   ;			exit protected mode
DEDB      C5 DC          BITB    #$DC   ;
DEDD 9    39             RTS            ;			DONE
->
;
;	VERIFY LAST SECTOR WRITTEN (VERIFY)
;	--------------------------
;	This does not do what it is supposed to!
;
DEDE ?    3F FC          SWI     #$FC   ;			enter prot
DEE0      86 88          LDA     #$88   ;			1000 (read single sector) 1000 (disable spin-up sequence)
DEE2      B7 E0 18       STA     $E018  ;			WD1771 command register
DEE5      8D C1          BSR     $DEA8  ;			wait
DEE7   g  17 FF 67       LBSR    $DE51  ;			wait until not BUSY
DEEA ?    3F FD          SWI     #$FD   ;			exit prot
DEEC      C5 98          BITB    #$98   ;
DEEE 9    39             RTS            ;
->
;
;	RESTORE HEAD TO TRACK 0 (RESTORE)
;	-----------------------
;
DEEF 4    34 10          PSHS    X      ;
DEF1      8D 1B          BSR     $DF0E  ;
DEF3 ?    3F FC          SWI     #$FC   ;
DEF5      86 0B          LDA     #$0B   ;
DEF7      B7 E0 18       STA     $E018  ;
DEFA      8D AC          BSR     $DEA8  ;
DEFC   R  17 FF 52       LBSR    $DE51  ;
DEFF 5    35 10          PULS    X      ;
DF01 ?    3F FD          SWI     #$FD   ;
DF03  @   C5 40          BITB    #$40   ;
DF05 &    26 03          BNE     $DF0A  ;
DF07      1C FE          ANDCC   #$FE   ;
DF09 9    39             RTS            ;
->
DF0A      C6 16          LDB     #$16   ;
DF0C W    57             ASRB           ;
DF0D 9    39             RTS            ;
->
Routine:
;
;	SELECT SPECIFIED DRIVE (DRIVE)
;	----------------------
;
DF0E      A6 03          LDA     $03,X  ;
DF10      81 04          CMPA    #$04   ;
DF12 %    25 04          BCS     $DF18  ;
DF14      C6 1F          LDB     #$1F   ;
DF16 W    57             ASRB           ;
DF17 9    39             RTS            ;
->
DF18 ?    3F FC          SWI     #$FC   ;			Enter Prot
DF1A      8D 1C          BSR     $DF38  ;
DF1C      F6 E0 19       LDB     $E019  ;			WD1771 Track register
DF1F      E7 84          STB     ,X     ;
DF21      B7 E0 14       STA     $E014  ;			WD1771 drive register
DF24      B1 DE 1E       CMPA    $DE1E  ;
DF27 '    27 03          BEQ     $DF2C  ;
DF29   |  17 FF 7C       LBSR    $DEA8  ;
->
DF2C      B7 DE 1E       STA     $DE1E  ;
DF2F      8D 07          BSR     $DF38  ;
DF31      A6 84          LDA     ,X     ;
DF33      B7 E0 19       STA     $E019  ;
DF36  *   20 2A          BRA     $DF62  ;
->
Routine:
DF38      8E DE 1F       LDX     #$DE1F ;
DF3B      F6 DE 1E       LDB     $DE1E  ;
DF3E :    3A             ABX            ;
DF3F 9    39             RTS            ;
->
Routine:
;
;	QUICK CHECK FOR DRIVE READY (QUICK)
;	---------------------------
;
DF40      A6 03          LDA     $03,X  ;
DF42 ?    3F FC          SWI     #$FC   ;
DF44      B7 E0 14       STA     $E014  ;
->
Routine:
DF47   ^  17 FF 5E       LBSR    $DEA8  ;
DF4A ?    3F FC          SWI     #$FC   ;			enter prot
DF4C      F6 E0 18       LDB     $E018  ;			WD1771 Status register
DF4F *    2A 05          BPL     $DF56  ;			drive ready
DF51 ?    3F FD          SWI     #$FD   ;			exit prot
DF53      1A 01          ORCC    #$01   ;			turn on the carry bit (drive not ready)
DF55 9    39             RTS            ;			DONE
->
DF56 ?    3F FD          SWI     #$FD   ;			exit prot
DF58      1C FE          ANDCC   #$FE   ;			turn off the carry bit (drive ready)
DF5A 9    39             RTS            ;
->
;
;	CHECK FOR DRIVE READY (CHKRDY)
;	---------------------
;
DF5B      A6 03          LDA     $03,X  ;
DF5D ?    3F FC          SWI     #$FC   ;
DF5F      B7 E0 14       STA     $E014  ;
->
DF62      8D E3          BSR     $DF47  ;
DF64 $    24 F0          BCC     $DF56  ;
DF66   2  17 FF 32       LBSR    $DE9B  ;
DF69      20 DC          BRA     $DF47  ;
->
;
;	DRIVE INITIALISATION - COLD START (INIT)
;	---------------------------------
;
DF6B      8E DE 1E       LDX     #$DE1E ;			Clear 6 bytes from DE1E
DF6E      C6 06          LDB     #$06   ;
->
DF70 o    6F 80          CLR     ,X+    ;
DF72 Z    5A             DECB           ;
DF73 &    26 FB          BNE     $DF70  ;
->
;
;	DRIVE INITIALISATION - WARM START (WARM)
;	---------------------------------
;
DF75 9    39             RTS            ;			DONE
->
