BikeShopScript: ; 1d73c (7:573c)
	jp EnableAutoTextBoxDrawing

BikeShopTextPointers: ; 1d73f (7:573f)
	dw BikeShopText1
	dw BikeShopText2
	dw BikeShopText3

OWItemBicycle: db BICYCLE

BikeShopText1: ; 1d745 (7:5745)
	db $08 ; asm
	ld a, [wd75f]
	bit 0, a
	jr z, .asm_260d4 ; 0x1d74b
	ld hl, BikeShopText_1d82f
	call PrintText
	jp .Done
.asm_260d4 ; 0x1d756
	ld b, BIKE_VOUCHER
	call IsItemInBag
	jr z, .asm_41190 ; 0x1d75b
	ld hl, BikeShopText_1d81f
	call PrintText
	lda b, [OWItemBicycle]
	ld c, 1
	call GiveItem
	jr nc, .BagFull
	ld a, BIKE_VOUCHER
	ldh [$db], a
	callba RemoveItemByID
	ld hl, wd75f
	set 0, [hl]
	ld hl, BikeShopText_1d824
	call PrintText
	jr .Done
.BagFull
	ld hl, BikeShopText_1d834
	call PrintText
	jr .Done
.asm_41190 ; 0x1d78c
	ld hl, BikeShopText_1d810
	call PrintText
	xor a
	ld [wCurrentMenuItem], a
	ld [wLastMenuItem], a
	ld a, $3
	ld [wMenuWatchedKeys], a
	ld a, $1
	ld [wMaxMenuItem], a
	ld a, $2
	ld [wTopMenuItemY], a
	ld a, $1
	ld [wTopMenuItemX], a
	ld hl, wd730
	set 6, [hl]
	ld hl, wTileMap
	ld b, $4
	ld c, $f
	call TextBoxBorder
	call UpdateSprites
	hlCoord 2, 2
	ld de, BikeShopMenuText
	call PlaceString
	hlCoord 8, 3
	ld de, BikeShopMenuPrice
	call PlaceString
	ld hl, BikeShopText_1d815
	call PrintText
	call HandleMenuInput
	bit 1, a
	jr nz, .asm_b7579 ; 0x1d7dc
	ld hl, wd730
	res 6, [hl]
	ld a, [wCurrentMenuItem]
	and a
	jr nz, .asm_b7579 ; 0x1d7e7
	ld hl, BikeShopText_1d81a
	call PrintText
.asm_b7579 ; 0x1d7ef
	ld hl, BikeShopText_1d82a
	call PrintText
.Done
	jp TextScriptEnd

BikeShopMenuText: ; 1d7f8 (7:57f8)
	db   "BICYCLE"
	next "CANCEL@"

BikeShopMenuPrice: ; 1d807 (7:5807)
	db "¥1000000@"

BikeShopText_1d810: ; 1d810 (7:5810)
	TX_FAR _BikeShopText_1d810
	db "@"

BikeShopText_1d815: ; 1d815 (7:5815)
	TX_FAR _BikeShopText_1d815
	db "@"

BikeShopText_1d81a: ; 1d81a (7:581a)
	TX_FAR _BikeShopText_1d81a
	db "@"

BikeShopText_1d81f: ; 1d81f (7:581f)
	TX_FAR _BikeShopText_1d81f
	db "@"

BikeShopText_1d824: ; 1d824 (7:5824)
	TX_FAR _BikeShopText_1d824 ; 0x98eb2
	db $11, "@"

BikeShopText_1d82a: ; 1d82a (7:582a)
	TX_FAR _BikeShopText_1d82a
	db "@"

BikeShopText_1d82f: ; 1d82f (7:582f)
	TX_FAR _BikeShopText_1d82f
	db "@"

BikeShopText_1d834: ; 1d834 (7:5834)
	TX_FAR _BikeShopText_1d834
	db "@"

BikeShopText2: ; 1d839 (7:5839)
	db $08 ; asm
	ld hl, BikeShopText_1d843
	call PrintText
	jp TextScriptEnd

BikeShopText_1d843: ; 1d843 (7:5843)
	TX_FAR _BikeShopText_1d843
	db "@"

BikeShopText3: ; 1d848 (7:5848)
	db $08 ; asm
	ld a, [wd75f]
	bit 0, a
	ld hl, BikeShopText_1d861
	jr nz, .asm_34d2d ; 0x1d851
	ld hl, BikeShopText_1d85c
.asm_34d2d ; 0x1d856
	call PrintText
	jp TextScriptEnd

BikeShopText_1d85c: ; 1d85c (7:585c)
	TX_FAR _BikeShopText_1d85c
	db "@"

BikeShopText_1d861: ; 1d861 (7:5861)
	TX_FAR _BikeShopText_1d861
	db "@"
