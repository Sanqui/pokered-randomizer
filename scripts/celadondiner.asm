CeladonDinerScript: ; 49151 (12:5151)
	call EnableAutoTextBoxDrawing
	ret

CeladonDinerTextPointers: ; 49155 (12:5155)
	dw CeladonDinerText1
	dw CeladonDinerText2
	dw CeladonDinerText3
	dw CeladonDinerText4
	dw CeladonDinerText5

CeladonDinerText1: ; 4915f (12:515f)
	TX_FAR _CeladonDinerText1
	db "@"

CeladonDinerText2: ; 49164 (12:5164)
	TX_FAR _CeladonDinerText2
	db "@"

CeladonDinerText3: ; 49169 (12:5169)
	TX_FAR _CeladonDinerText3
	db "@"

CeladonDinerText4: ; 4916e (12:516e)
	TX_FAR _CeladonDinerText4
	db "@"

OWItemCoinCase: db COIN_CASE

CeladonDinerText5: ; 49173 (12:5173)
	db $08 ; asm
	ld a, [wd783]
	bit 0, a
	jr nz, .asm_eb14d ; 0x49179
	ld hl, CeladonDinerText_491a7
	call PrintText
	lda b, [OWItemCoinCase]
	ld c, 1
	call GiveItem
	jr nc, .BagFull
	ld hl, wd783
	set 0, [hl]
	ld hl, ReceivedCoinCaseText
	call PrintText
	jr .asm_68b61 ; 0x49194
.BagFull
	ld hl, CoinCaseNoRoomText
	call PrintText
	jr .asm_68b61 ; 0x4919c
.asm_eb14d ; 0x4919e
	ld hl, CeladonDinerText_491b7
	call PrintText
.asm_68b61 ; 0x491a4
	jp TextScriptEnd

CeladonDinerText_491a7: ; 491a7 (12:51a7)
	TX_FAR _CeladonDinerText_491a7
	db "@"

ReceivedCoinCaseText: ; 491ac (12:51ac)
	TX_FAR _ReceivedCoinCaseText
	db $11, "@"

CoinCaseNoRoomText: ; 491b2 (12:51b2)
	TX_FAR _CoinCaseNoRoomText
	db "@"

CeladonDinerText_491b7: ; 491b7 (12:51b7)
	TX_FAR _CeladonDinerText_491b7
	db "@"
