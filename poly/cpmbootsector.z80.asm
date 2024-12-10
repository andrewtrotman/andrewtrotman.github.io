;
;	PROTEUS CP/M BOOT SECTOR
;	------------------------
;	Commented Dissassembly by Andrew Trotman andrew@cs.otago.ac.nz
;
;	-----------------------------
;	CP/M BOOT SECTOR (6809 Entry)
;	-----------------------------
;
;	Use the 6809 to set up the Z80 reset vector to branch to $C010 (0000: C3 10 C0)
;	then switch from the 6809 CPU to the Z80 CPU
;
C000 [86C3] LDA #$C3					; Z80 JP instruction
C002 [B70000] STA $0000					; Z80 Reset vector
C005 [8E10C0] LDX $10C0					; $C010 in Zilog byte order
C008 [BF0001] STX $0001					; Z80 Reset vector
C00B [BFE060] STX $E060					; Switch to Z80 (reset by branch to 0000)
C00E [0000] 00 00

;
;	----------------------------
;	CP/M BOOT SECTOR (Z80 Entry)
;	----------------------------
;	Use the Z80 to load the remainder of the first track into memory
;	starting at $E000, then branch to the CP/M cold start address ($F600)
;
C010 [318000] LD SP,00080h				; STACK = $0080
C013 [97] SUB A,A						; A = 0
C014 [D314] OUT (014h),A				; drive select (select drive 0)
C016 [3E08] LD A,008h					; A = $08
C018 [CD56C0] CALL (0C056h)				; RECALIBRATE DRIVE COMMAND (seek track 0)
C01B [1E02] LD E,002h					; E = $02		(start sector of CP/M on first track of disk)
C01D [2100E0] LD HL,0E000h				; HL = $E000	(address into which to load CP/M)
;
C020 [7B] LD A,E						; A = $02
C021 [D31A] OUT (01Ah),A				; DISK SECTOR REGISTER (goto sector 2)
C023 [3E88] LD A,088h					; A = $88
C025 [CD4DC0] CALL (0C04Dh)				; ISSUE READ SECTOR COMMAND
C028 [0E1B] LD C,01Bh					; C = $1B (FDC DATA REGISTER)
C02A [1802] JR (PC+2)					; skip next instruction
;
C02C [EDA2] INI							; HL = IN *C; HL++; B--;
;
C02E [DB18] IN A,(018h)					; disk STATUS REGISTER 
C030 [CB4F] BIT 1,A						; check DATA READY flag
C032 [20F8] JR NZ,(PC+248)				; if DATA READY get more data (GOTO:C02C)
C034 [1F] RRA							; check BUSY flag
C035 [38F7] JR C,(PC+247)				; while BUSY try again (GOTO:C02E) 
C037 [17] RLA							; put the flags back
C038 [E69C] AND 09Ch					; %1001 1100  (MOTOR_ON | RECORD_NOT_FOUND | CRC_ERROR | LOST_DATA)
C03A [20D4] JR NZ,(PC+212)				; start all over again (GOTO:C010)
C03C [1C] INC E							; E = E + 1 	(next sector to read)
C03D [7B] LD A,E						; A = E
C03E [FE11] CP 011h						; if A = $11 (17 decimal) last sector of first track on CP/M on disk
C040 [CA00F6] JP Z,(0F600h)				; DONE (CP/M COLD START)
C043 [FE09] CP 009h						; if A = $09
C045 [20D9] JR NZ,(PC+217)				; more (GOTO C020)
C047 [3E40] LD A,040h					; A = $40			(switch to second side of disk)
C049 [D314] OUT (014h),A				; DRIVE SELECT
C04B [18D3] JR (PC+211)					; goto C020
;
;	DISK COMMAND AND WAIT
;
C04D [D318] OUT (018h),A				; do disk command
C04F [CD52C0] CALL (0C052h)				; timing loop
C052 [CD55C0] CALL (0C055h)				; timing loop
C055 [C9] RET							; timing loop
;
;	DISK COMMAND AND CHECK BUSY
;
C056 [CD4DC0] CALL (0C04Dh)
C059 [DB18] IN A,(018h)					; disk STATUS REGISTER
C05B [1F] RRA							; check bottom bit (BUSY)
C05C [38FB] JR C,(PC+251)				; repeat while bust
C05E [C9] RET							; DONE

