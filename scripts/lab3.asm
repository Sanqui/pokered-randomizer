Lab3Script: ; 75c87 (1d:5c87)
	jp EnableAutoTextBoxDrawing

Lab3TextPointers: ; 75c8a (1d:5c8a)
	dw Lab3Text1
	dw Lab3Text2
	dw Lab3Text3
	dw Lab3Text4
	dw Lab3Text5

OWItemTM35: db TM_35

Lab3Text1: ; 75c94 (1d:5c94)
	db $08 ; asm
	ld a, [wd7a1]
	bit 7, a
	jr nz, .asm_e551a ; 0x75c9a
	ld hl, TM35PreReceiveText
	call PrintText
	lda b, [OWItemTM35]
	ld c, 1
	call GiveItem
	jr nc, .BagFull
	ld hl, ReceivedTM35Text
	call PrintText
	ld hl, wd7a1
	set 7, [hl]
	jr .asm_eb896 ; 0x75cb5
.BagFull
	ld hl, TM35NoRoomText
	call PrintText
	jr .asm_eb896 ; 0x75cbd
.asm_e551a ; 0x75cbf
	ld hl, TM35ExplanationText
	call PrintText
.asm_eb896 ; 0x75cc5
	jp TextScriptEnd

TM35PreReceiveText: ; 75cc8 (1d:5cc8)
	TX_FAR _TM35PreReceiveText
	db "@"

ReceivedTM35Text: ; 75ccd (1d:5ccd)
	TX_FAR _ReceivedTM35Text
	db $0B, "@"

TM35ExplanationText: ; 75cd3 (1d:5cd3)
	TX_FAR _TM35ExplanationText
	db "@"

TM35NoRoomText: ; 75cd8 (1d:5cd8)
	TX_FAR _TM35NoRoomText
	db "@"

Lab3Text2: ; 75cdd (1d:5cdd)
	TX_FAR _Lab3Text2
	db "@"

Lab3Text4: ; 75ce2 (1d:5ce2)
Lab3Text3: ; 75ce2 (1d:5ce2)
	TX_FAR _Lab3Text3
	db "@"

Lab3Text5: ; 75ce7 (1d:5ce7)
	TX_FAR _Lab3Text5
	db "@"
