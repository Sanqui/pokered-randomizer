VermilionHouse2Script: ; 56070 (15:6070)
	jp EnableAutoTextBoxDrawing

VermilionHouse2TextPointers: ; 56073 (15:6073)
	dw VermilionHouse2Text1

OWItemOldRod: db OLD_ROD

VermilionHouse2Text1: ; 56075 (15:6075)
	db $08 ; asm
	ld a, [wd728]
	bit 3, a
	jr nz, .asm_03ef5
	ld hl, VermilionHouse2Text_560b1
	call PrintText
	call YesNoChoice
	ld a, [wCurrentMenuItem]
	and a
	jr nz, .asm_eb1b7
	lda b, [OWItemOldRod]
	ld c, 1
	call GiveItem
	jr nc, .BagFull
	ld hl, wd728
	set 3, [hl]
	ld hl, VermilionHouse2Text_560b6
	jr .asm_5dd95
.BagFull
	ld hl, VermilionHouse2Text_560ca
	jr .asm_5dd95
.asm_eb1b7
	ld hl, VermilionHouse2Text_560c0
	jr .asm_5dd95
.asm_03ef5
	ld hl, VermilionHouse2Text_560c5
.asm_5dd95
	call PrintText
	jp TextScriptEnd

VermilionHouse2Text_560b1: ; 560b1 (15:60b1)
	TX_FAR _VermilionHouse2Text_560b1
	db "@"

VermilionHouse2Text_560b6: ; 560b6 (15:60b6)
	TX_FAR _VermilionHouse2Text_560b6 ; 0x9c554
	db $0B
	TX_FAR _VermilionHouse2Text_560bb ; 0x9c5a4
	db "@"

VermilionHouse2Text_560c0: ; 560c0 (15:60c0)
	TX_FAR _VermilionHouse2Text_560c0
	db "@"

VermilionHouse2Text_560c5: ; 560c5 (15:60c5)
	TX_FAR _VermilionHouse2Text_560c5
	db "@"

VermilionHouse2Text_560ca: ; 560ca (15:60ca)
	TX_FAR _VermilionHouse2Text_560ca
	db "@"
