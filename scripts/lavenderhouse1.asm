LavenderHouse1Script: ; 1d8a8 (7:58a8)
	call EnableAutoTextBoxDrawing
	ret

LavenderHouse1TextPointers: ; 1d8ac (7:58ac)
	dw LavenderHouse1Text1
	dw LavenderHouse1Text2
	dw LavenderHouse1Text3
	dw LavenderHouse1Text4
	dw LavenderHouse1Text5
	dw LavenderHouse1Text6

LavenderHouse1Text1: ; 1d8b8 (7:58b8)
	db $08 ; asm
	ld a, [wd7e0]
	bit 7, a
	jr nz, .asm_72e5d ; 0x1d8be
	ld hl, LavenderHouse1Text_1d8d1
	call PrintText
	jr .asm_6957f ; 0x1d8c6
.asm_72e5d ; 0x1d8c8
	ld hl, LavenderHouse1Text_1d8d6
	call PrintText
.asm_6957f ; 0x1d8ce
	jp TextScriptEnd

LavenderHouse1Text_1d8d1: ; 1d8d1 (7:58d1)
	TX_FAR _LavenderHouse1Text_1d8d1
	db "@"

LavenderHouse1Text_1d8d6: ; 1d8d6 (7:58d6)
	TX_FAR _LavenderHouse1Text_1d8d6
	db "@"

LavenderHouse1Text2: ; 1d8db (7:58db)
	db $08 ; asm
	ld a, [wd7e0]
	bit 7, a
	jr nz, .asm_06470 ; 0x1d8e1
	ld hl, LavenderHouse1Text_1d8f4
	call PrintText
	jr .asm_3d208 ; 0x1d8e9
.asm_06470 ; 0x1d8eb
	ld hl, LavenderHouse1Text_1d8f9
	call PrintText
.asm_3d208 ; 0x1d8f1
	jp TextScriptEnd

LavenderHouse1Text_1d8f4: ; 1d8f4 (7:58f4)
	TX_FAR _LavenderHouse1Text_1d8f4
	db "@"

LavenderHouse1Text_1d8f9: ; 1d8f9 (7:58f9)
	TX_FAR _LavenderHouse1Text_1d8f9
	db "@"

LavenderHouse1Text3: ; 1d8fe (7:58fe)
	TX_FAR _LavenderHouse1Text3
	db $8
	ld a, PSYDUCK
	call PlayCry
	jp TextScriptEnd

LavenderHouse1Text4: ; 1d90b (7:590b)
	TX_FAR _LavenderHouse1Text4
	db $8
	ld a, NIDORINO
	call PlayCry
	jp TextScriptEnd

OWItemPokeFlute: db POKE_FLUTE

LavenderHouse1Text5: ; 1d918 (7:5918)
	db $08 ; asm
	ld a, [wd76c]
	bit 0, a
	jr nz, .asm_15ac2 ; 0x1d91e
	ld hl, LavenderHouse1Text_1d94c
	call PrintText
	lda b, [OWItemPokeFlute]
	ld c, 1
	call GiveItem
	jr nc, .BagFull
	ld hl, ReceivedFluteText
	call PrintText
	ld hl, wd76c
	set 0, [hl]
	jr .asm_da749 ; 0x1d939
.BagFull
	ld hl, FluteNoRoomText
	call PrintText
	jr .asm_da749 ; 0x1d941
.asm_15ac2 ; 0x1d943
	ld hl, MrFujiAfterFluteText
	call PrintText
.asm_da749 ; 0x1d949
	jp TextScriptEnd

LavenderHouse1Text_1d94c: ; 1d94c (7:594c)
	TX_FAR _LavenderHouse1Text_1d94c
	db "@"

ReceivedFluteText: ; 1d951 (7:5951)
	TX_FAR _ReceivedFluteText
	db $11
	TX_FAR _FluteExplanationText
	db "@"

FluteNoRoomText: ; 1d95b (7:595b)
	TX_FAR _FluteNoRoomText
	db "@"

MrFujiAfterFluteText: ; 1d960 (7:5960)
	TX_FAR _MrFujiAfterFluteText
	db "@"

LavenderHouse1Text6: ; 1d965 (7:5965)
	TX_FAR _LavenderHouse1Text6
	db "@"
