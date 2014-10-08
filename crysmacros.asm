; rgbds macros


; macros require rst vectors to be defined
FarCall    EQU $08
Bankswitch EQU $10
JumpTable  EQU $28


NONE       EQU 0



dt: MACRO ; three-byte (big-endian)
	db (\1 >> 16) & $ff
	db (\1 >> 8) & $ff
	db \1 & $ff
	ENDM

bigdw: MACRO ; big-endian word
	dw ((\1)/$100) + (((\1)&$ff)*$100)
	ENDM

lb: MACRO ; r, hi, lo
	ld \1, \2 << 8 + \3
	ENDM



note: MACRO
	db \1 << 4 + (\2 - 1)
	ENDM

; pitch
__ EQU 0
C_ EQU 1
C# EQU 2
D_ EQU 3
D# EQU 4
E_ EQU 5
F_ EQU 6
F# EQU 7
G_ EQU 8
G# EQU 9
A_ EQU 10
A# EQU 11
B_ EQU 12

inc_octave: MACRO
	db $f4
	ENDM

dec_octave: MACRO
	db $f5
	ENDM

notetype0: MACRO
	db $f6, \1
	ENDM

notetype1: MACRO
	db $f7, \1
	ENDM

notetype2: MACRO
	db $f8, \1
	ENDM
