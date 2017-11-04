Route22Script: ; 50eb2 (14:4eb2)
	call EnableAutoTextBoxDrawing
	ld hl, Route22ScriptPointers
	ld a, [W_ROUTE22CURSCRIPT]
	jp CallFunctionInTable

Route22ScriptPointers: ; 50ebe (14:4ebe)
	dw Route22Script0
	dw Route22Script1
	dw Route22Script2
	dw Route22Script3
	dw Route22Script4
	dw Route22Script5
	dw Route22Script6
	dw Route22Script7

Route22Script_50ece: ; 50ece (14:4ece)
	xor a
	ld [wJoyIgnore], a
	ld [W_ROUTE22CURSCRIPT], a
Route22Script7: ; 50ed5 (14:4ed5)
	ret

Route22Script_50ed6: ; 50ed6 (14:4ed6)
	ld a, [W_RIVALSTARTER] ; wd715
	ld b, a
.asm_50eda
	ld a, [hli]
	cp b
	jr z, .asm_50ee1
	inc hl
	jr .asm_50eda
.asm_50ee1
	ld a, [hl]
	ld [W_TRAINERNO], a ; wd05d
	ld a, 1
	ld [wIsTrainerBattle], a
	ret

Route22MoveRivalSprite: ; 50ee6 (14:4ee6)
	ld de, Route22RivalMovementData ; $4efb
	ld a, [wcf0d]
	cp $1
	jr z, .asm_50ef1
	inc de
.asm_50ef1
	call MoveSprite
	ld a, $c
	ld [$ff8d], a
	jp SetSpriteFacingDirectionAndDelay

Route22RivalMovementData: ; 50efb (14:4efb)
	db $C0,$C0,$C0,$C0,$FF ; move right 4 times

Route22Script0: ; 50f00 (14:4f00)
	ld a, [wd7eb]
	bit 7, a
	ret z
	ld hl, .Route22RivalBattleCoords  ; $4f2d
	call ArePlayerCoordsInArray
	ret nc
	ld a, [wWhichTrade]
	ld [wcf0d], a
	xor a
	ld [hJoyHeld], a
	ld a, $f0
	ld [wJoyIgnore], a
	ld a, $2
	ld [wd528], a
	ld a, [wd7eb]
	bit 0, a ; is this the rival battle at the beginning of the game?
	jr nz, .firstRivalBattle ; 0x50f25 $b
	bit 1, a ; is this the rival at the end of the game?
	jp nz, Route22Script_5104e
	ret

.Route22RivalBattleCoords
	db $04, $1D
	db $05, $1D
	db $FF

.firstRivalBattle
	ld a, $1
	ld [wcd4f], a
	xor a
	ld [wcd50], a
	predef EmotionBubble
	ld a, [wWalkBikeSurfState]
	and a
	jr z, .asm_50f4e ; 0x50f44 $8
	ld a, $ff
	ld [wc0ee], a
	call PlaySound
.asm_50f4e
	ld c, 0 ; BANK(Music_MeetRival)
	ld a, MUSIC_MEET_RIVAL
	call PlayMusic
	ld a, $1
	ld [$ff8c], a
	call Route22MoveRivalSprite
	ld a, $1
	ld [W_ROUTE22CURSCRIPT], a
	ret

Route22Script1: ; 50f62 (14:4f62)
	ld a, [wd730]
	bit 0, a
	ret nz
	ld a, [wcf0d]
	cp $1
	jr nz, .asm_50f78 ; 0x50f6d $9
	ld a, $4
	ld [wd528], a
	ld a, $4
	jr .asm_50f7a ; 0x50f76 $2
.asm_50f78
	ld a, $c
.asm_50f7a
	ld [$ff8d], a
	ld a, $1
	ld [$ff8c], a
	call SetSpriteFacingDirectionAndDelay
	xor a
	ld [wJoyIgnore], a
	ld a, $1
	ld [$ff8c], a
	call DisplayTextID
	ld hl, wd72d
	set 6, [hl]
	set 7, [hl]
	ld hl, Route22RivalDefeatedText1
	ld de, Route22Text_511bc
	call SaveEndBattleTextPointers
	ld a, SONY1 + $c8
	ld [W_CUROPPONENT], a
	ld hl, StarterMons_50faf ; $4faf
	call Route22Script_50ed6
	ld a, $2
	ld [W_ROUTE22CURSCRIPT], a
	ret

StarterMons_50faf: ; 50faf (14:4faf)
; starter the rival picked, rival trainer number
	db STARTER2,$04
	db STARTER3,$05
	db STARTER1,$06

Route22Script2: ; 50fb5 (14:4fb5)
	ld a, [W_ISINBATTLE]
	cp $ff
	jp z, Route22Script_50ece
    xor a
    ld [wIsTrainerBattle], a
	ld a, [wSpriteStateData1 + 9]
	and a
	jr nz, .asm_50fc7 ; 0x50fc1 $4
	ld a, $4
	jr .asm_50fc9 ; 0x50fc5 $2
.asm_50fc7
	ld a, $c
.asm_50fc9
	ld [$ff8d], a
	ld a, $1
	ld [$ff8c], a
	call SetSpriteFacingDirectionAndDelay
	ld a, $f0
	ld [wJoyIgnore], a
	ld hl, wd7eb
	set 5, [hl]
	ld a, $1
	ld [$ff8c], a
	call DisplayTextID
	ld a, $ff
	ld [wc0ee], a
	call PlaySound
	callba Music_RivalAlternateStart
	ld a, [wcf0d]
	cp $1
	jr nz, .asm_50fff ; 0x50ff8 $5
	call Route22Script_51008
	jr .asm_51002 ; 0x50ffd $3
.asm_50fff
	call Route22Script_5100d
.asm_51002
	ld a, $3
	ld [W_ROUTE22CURSCRIPT], a
	ret

Route22Script_51008: ; 51008 (14:5008)
	ld de, Route22RivalExitMovementData1 ; $5017
	jr asm_51010

Route22Script_5100d: ; 5100d (14:500d)
	ld de, Route22RivalExitMovementData2 ; $501f
asm_51010
	ld a, $1
	ld [H_SPRITEHEIGHT], a
	jp MoveSprite

Route22RivalExitMovementData1: ; 51017 (14:5017)
	db $C0,$C0,$00,$00,$00,$00,$00,$FF

Route22RivalExitMovementData2: ; 5101f (14:501f)
	db $40,$C0,$C0,$C0,$00,$00,$00,$00,$00,$00,$FF

Route22Script3: ; 5102a (14:502a)
	ld a, [wd730]
	bit 0, a
	ret nz
	xor a
	ld [wJoyIgnore], a
	ld a, HS_ROUTE_22_RIVAL_1
	ld [wcc4d], a
	predef HideObject
	call PlayDefaultMusic
	ld hl, wd7eb
	res 0, [hl]
	res 7, [hl]
	ld a, $0
	ld [W_ROUTE22CURSCRIPT], a
	ret

Route22Script_5104e: ; 5104e (14:504e)
	ld a, $2
	ld [wcd4f], a
	xor a
	ld [wcd50], a
	predef EmotionBubble
	ld a, [wWalkBikeSurfState]
	and a
	jr z, .skipYVisibilityTesta
	ld a, $ff
	ld [wc0ee], a
	call PlaySound
.skipYVisibilityTesta
	ld a, $ff
	ld [wc0ee], a
	call PlaySound
	callba Music_RivalAlternateTempo
	ld a, $2
	ld [H_DOWNARROWBLINKCNT2], a ; $ff8c
	call Route22MoveRivalSprite
	ld a, $4
	ld [W_ROUTE22CURSCRIPT], a
	ret

Route22Script4: ; 51087 (14:5087)
	ld a, [wd730]
	bit 0, a
	ret nz
	ld a, $2
	ld [H_DOWNARROWBLINKCNT2], a ; $ff8c
	ld a, [wcf0d]
	cp $1
	jr nz, .asm_510a1
	ld a, $4
	ld [wd528], a
	ld a, $4
	jr .asm_510a8
.asm_510a1
	ld a, $2
	ld [wd528], a
	ld a, $c
.asm_510a8
	ld [$ff8d], a
	call SetSpriteFacingDirectionAndDelay
	xor a
	ld [wJoyIgnore], a
	ld a, $2
	ld [H_DOWNARROWBLINKCNT2], a ; $ff8c
	call DisplayTextID
	ld hl, wd72d
	set 6, [hl]
	set 7, [hl]
	ld hl, Route22RivalDefeatedText2 ; $51cb
	ld de, Route22Text_511d0 ; $51d0
	call SaveEndBattleTextPointers
	ld a, SONY2 + $c8
	ld [W_CUROPPONENT], a ; wd059
	ld hl, StarterMons_510d9 ; $50d9
	call Route22Script_50ed6
	ld a, $5
	ld [W_ROUTE22CURSCRIPT], a
	ret

StarterMons_510d9: ; 510d9 (14:50d9)
	db STARTER2,$0a
	db STARTER3,$0b
	db STARTER1,$0c

Route22Script5: ; 510df (14:50df)
	ld a, [W_ISINBATTLE] ; W_ISINBATTLE
	cp $ff
	jp z, Route22Script_50ece
    xor a
    ld [wIsTrainerBattle], a
	ld a, $2
	ld [H_DOWNARROWBLINKCNT2], a ; $ff8c
	ld a, [wcf0d]
	cp $1
	jr nz, .asm_510fb
	ld a, $4
	ld [wd528], a
	ld a, $4
	jr .asm_51102
.asm_510fb
	ld a, $2
	ld [wd528], a
	ld a, $c
.asm_51102
	ld [$ff8d], a
	call SetSpriteFacingDirectionAndDelay
	ld a, $f0
	ld [wJoyIgnore], a
	ld hl, wd7eb
	set 6, [hl]
	ld a, $2
	ld [H_DOWNARROWBLINKCNT2], a ; $ff8c
	call DisplayTextID
	ld a, $ff
	ld [wc0ee], a
	call PlaySound
	callba Music_RivalAlternateStartAndTempo
	ld a, [wcf0d]
	cp $1
	jr nz, .asm_51134
	call Route22Script_5113d
	jr .asm_51137
.asm_51134
	call Route22Script_51142
.asm_51137
	ld a, $6
	ld [W_ROUTE22CURSCRIPT], a
	ret

Route22Script_5113d: ; 5113d (14:513d)
	ld de, MovementData_5114c ; $514c
	jr asm_51145

Route22Script_51142: ; 51142 (14:5142)
	ld de, MovementData_5114d ; $514d
asm_51145: ; 51145 (14:5145)
	ld a, $2
	ld [H_DOWNARROWBLINKCNT2], a ; $ff8c
	jp MoveSprite

MovementData_5114c: ; 5114c (14:514c)
	db $80 ; left

MovementData_5114d: ; 5114d (14:514d)
	db $80,$80,$80,$FF ; left x3

Route22Script6: ; 51151 (14:5151)
	ld a, [wd730]
	bit 0, a
	ret nz
	xor a
	ld [wJoyIgnore], a
	ld a, HS_ROUTE_22_RIVAL_2
	ld [wcc4d], a
	predef HideObject
	call PlayDefaultMusic
	ld hl, wd7eb
	res 1, [hl]
	res 7, [hl]
	ld a, $7
	ld [W_ROUTE22CURSCRIPT], a
	ret

Route22TextPointers: ; 51175 (14:5175)
	dw Route22Text1
	dw Route22Text2
	dw Route22FrontGateText

Route22Text1: ; 5117b (14:517b)
	db $08 ; asm
	ld a, [wd7eb]
	bit 5, a
	jr z, .asm_a88cf ; 0x51181
	ld hl, Route22RivalAfterBattleText1
	call PrintText
	jr .asm_48088 ; 0x51189
.asm_a88cf ; 0x5118b
	ld hl, Route22RivalBeforeBattleText1
	call PrintText
.asm_48088 ; 0x51191
	jp TextScriptEnd

Route22Text2: ; 51194 (14:5194)
	db $08 ; asm
	ld a, [wd7eb]
	bit 6, a
	jr z, .asm_58c0a ; 0x5119a
	ld hl, Route22RivalAfterBattleText2
	call PrintText
	jr .asm_673ee ; 0x511a2
.asm_58c0a ; 0x511a4
	ld hl, Route22RivalBeforeBattleText2
	call PrintText
.asm_673ee ; 0x511aa
	jp TextScriptEnd

Route22RivalBeforeBattleText1: ; 511ad (14:51ad)
	TX_FAR _Route22RivalBeforeBattleText1
	db "@"

Route22RivalAfterBattleText1: ; 511b2 (14:51b2)
	TX_FAR _Route22RivalAfterBattleText1
	db "@"

Route22RivalDefeatedText1: ; 511b7 (14:51b7)
	TX_FAR _Route22RivalDefeatedText1
	db "@"

Route22Text_511bc: ; 511bc (14:51bc)
	TX_FAR _Route22Text_511bc
	db "@"

Route22RivalBeforeBattleText2: ; 511c1 (14:51c1)
	TX_FAR _Route22RivalBeforeBattleText2
	db "@"

Route22RivalAfterBattleText2: ; 511c6 (14:51c6)
	TX_FAR _Route22RivalAfterBattleText2
	db "@"

Route22RivalDefeatedText2: ; 511cb (14:51cb)
	TX_FAR _Route22RivalDefeatedText2
	db "@"

Route22Text_511d0: ; 511d0 (14:51d0)
	TX_FAR _Route22Text_511d0
	db "@"

Route22FrontGateText: ; 511d5 (14:51d5)
	TX_FAR _Route22FrontGateText
	db "@"
