PewterPokecenterScript: ; 5c587 (17:4587)
	call Func_22fa
	jp EnableAutoTextBoxDrawing

PewterPokecenterTextPointers: ; 5c58d (17:458d)
	dw PewterPokecenterText1
	dw PewterPokecenterText2
	dw PewterPokecenterText3
	dw PewterPokecenterText4

PewterPokecenterText1: ; 5c595 (17:4595)
	db $ff

PewterPokecenterText2: ; 5c596 (17:4596)
	TX_FAR _PewterPokecenterText1
	db "@"

PewterPokecenterText3: ; 5c59b (17:459b)
	db $8
	ld a, $1
	ld [wDoNotWaitForButtonPressAfterDisplayingText], a
	ld hl, PewterPokecenterText5
	call PrintText
	ld a, $ff
	call PlaySound
	ld c, $20
	call DelayFrames
	ld hl, Unknown_5c608 ; $4608
	ld de, wTrainerFacingDirection
	ld bc, $0004
	call CopyData
	ld a, [wSpriteStateData1 + $32]
	ld hl, wTrainerFacingDirection
.asm_5c5c3
	cp [hl]
	inc hl
	jr nz, .asm_5c5c3 ; 0x5c5c5 $fc
	dec hl
	push hl
	ld c, 0 ; BANK(Music_JigglypuffSong)
	ld a, MUSIC_JIGGLYPUFF_SONG
	call PlayMusic
	pop hl
.asm_5c5d1
	ld a, [hl]
	ld [wSpriteStateData1 + $32], a
	push hl
	ld hl, wTrainerFacingDirection
	ld de, wTrainerEngageDistance
	ld bc, $0004
	call CopyData
	ld a, [wTrainerEngageDistance]
	ld [wcd42], a
	pop hl
	ld c, $18
	call DelayFrames
	push hl
	call IsSongPlaying
	pop hl
	jr c, .asm_5c5d1 ; 0x5c5f6 $d9
	ld c, $30
	call DelayFrames
	call PlayDefaultMusic
	jp TextScriptEnd

PewterPokecenterText5: ; 5c603 (17:4603)
	TX_FAR _PewterPokecenterText5
	db "@"

Unknown_5c608: ; 5c608 (17:4608)
	db $30, $38, $34, $3c

PewterPokecenterText4: ; 5c60c (17:460c)
	db $f6
