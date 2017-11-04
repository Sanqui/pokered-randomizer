FanClubScript: ; 59b70 (16:5b70)
	jp EnableAutoTextBoxDrawing

FanClubBikeInBag:
; check if any bike paraphernalia in bag
	ld a, [wd771]
	bit 1, a ; got bike voucher?
	ret nz
	ld b, BICYCLE
	call IsItemInBag
	ret nz
	ld b, BIKE_VOUCHER
	jp IsItemInBag

FanClubTextPointers: ; 59b84 (16:5b84)
	dw FanClubText1
	dw FanClubText2
	dw FanClubText3
	dw FanClubText4
	dw FanClubText5
	dw FanClubText6
	dw FanClubText7
	dw FanClubText8

FanClubText1:
; pikachu fan
	db $08 ; asm
	ld a, [wd771]
	bit 7, a
	jr nz, .mineisbetter
	ld hl, .normaltext
	call PrintText
	ld hl, wd771
	set 6, [hl]
	jr .done
.mineisbetter
	ld hl, .bettertext
	call PrintText
	ld hl, wd771
	res 7, [hl]
.done
	jp TextScriptEnd

.normaltext
	TX_FAR PikachuFanText
	db "@"

.bettertext
	TX_FAR PikachuFanBetterText
	db "@"

FanClubText2:
; seel fan
	db $08 ; asm
	ld a, [wd771]
	bit 6, a
	jr nz, .mineisbetter
	ld hl, .normaltext
	call PrintText
	ld hl, wd771
	set 7, [hl]
	jr .done
.mineisbetter
	ld hl, .bettertext
	call PrintText
	ld hl, wd771
	res 6, [hl]
.done
	jp TextScriptEnd

.normaltext
	TX_FAR SeelFanText
	db "@"

.bettertext
	TX_FAR SeelFanBetterText
	db "@"

FanClubText3:
; pikachu
	db $8
	ld hl, .text
	call PrintText
	ld a, PIKACHU
	call PlayCry
	call WaitForSoundToFinish
	jp TextScriptEnd

.text
	TX_FAR FanClubPikachuText
	db "@"

FanClubText4:
; seel
	db $08 ; asm
	ld hl, .text
	call PrintText
	ld a, SEEL
	call PlayCry
	call WaitForSoundToFinish
	jp TextScriptEnd

.text
	TX_FAR FanClubSeelText
	db "@"

OWItemBikeVoucher: db BIKE_VOUCHER

FanClubText5:
; chair
	db $08 ; asm
	call FanClubBikeInBag
	jr nz, .nothingleft

	ld hl, .meetchairtext
	call PrintText
	call YesNoChoice
	ld a, [wCurrentMenuItem]
	and a
	jr nz, .nothanks

	; tell the story
	ld hl, .storytext
	call PrintText
	lda b, [OWItemBikeVoucher]
	ld c, 1
	call GiveItem
	jr nc, .BagFull
	ld hl, .receivedvouchertext
	call PrintText
	ld hl, wd771
	set 1, [hl]
	jr .done
.BagFull
	ld hl, .bagfulltext
	call PrintText
	jr .done
.nothanks
	ld hl, .nostorytext
	call PrintText
	jr .done
.nothingleft
	ld hl, .finaltext
	call PrintText
.done
	jp TextScriptEnd

.meetchairtext
	TX_FAR FanClubMeetChairText
	db "@"

.storytext
	TX_FAR FanClubChairStoryText
	db "@"

.receivedvouchertext
	TX_FAR ReceivedBikeVoucherText
	db $11
	TX_FAR ExplainBikeVoucherText
	db "@"

.nostorytext
	TX_FAR FanClubNoStoryText
	db "@"

.finaltext
	TX_FAR FanClubChairFinalText
	db "@"

.bagfulltext
	TX_FAR FanClubBagFullText
	db "@"

FanClubText6: ; 59c88 (16:5c88)
	TX_FAR _FanClubText6
	db "@"

FanClubText7: ; 59c8d (16:5c8d)
	TX_FAR _FanClubText7
	db "@"

FanClubText8: ; 59c92 (16:5c92)
	TX_FAR _FanClubText8
	db "@"
