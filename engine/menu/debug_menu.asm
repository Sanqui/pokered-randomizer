DEBUG_MENU_LAST_ITEM EQU 10

DebugMenu:
    ld hl, $fff6
    set 1, [hl] ; one spaced
	hlCoord 0, 0
	ld b,$0e
	ld c,$08
	call TextBoxBorder
	ld a,$02
	ld [wTopMenuItemY],a ; Y position of first menu choice
	ld a,$01
	ld [wTopMenuItemX],a ; X position of first menu choice
	xor a
	ld [wCurrentMenuItem],a
	ld [wLastMenuItem],a
	ld [wcc37],a
	
	ld hl,wd730
	set 6,[hl] ; no pauses between printing each letter

	hlCoord 2, 2
	ld de,DebugMenuItem0
	call PrintDebugMenuItem
	ld de,DebugMenuItem1
	call PrintDebugMenuItem
	ld de,DebugMenuItem2
	call PrintDebugMenuItem
	ld de,DebugMenuItem3
	call PrintDebugMenuItem
	ld de,DebugMenuItem4
	call PrintDebugMenuItem
	ld de,DebugMenuItem5
	call PrintDebugMenuItem
	ld de,DebugMenuItem6
	call PrintDebugMenuItem
	ld de,DebugMenuItem7
	call PrintDebugMenuItem
	ld de,DebugMenuItem8
	call PrintDebugMenuItem
	ld hl,wd730
	res 6,[hl] ; turn pauses between printing letters back on
	
	call DebugMenuLoop
	jp CloseDebugMenu
	
DebugMenuLoop
.loop
	call HandleMenuInput
	ld b,a
.checkIfUpPressed
	bit 6,a ; was Up pressed?
	jr z,.checkIfDownPressed
	ld a,[wCurrentMenuItem] ; menu selection
	and a
	jr nz,.loop
	ld a,[wLastMenuItem]
	and a
	jr nz,.loop
; if the player pressed tried to go past the top item, wrap around to the bottom
	ld a,[wd74b]
	ld a,DEBUG_MENU_LAST_ITEM
	ld [wCurrentMenuItem],a
	call EraseMenuCursor
	jr .loop
.checkIfDownPressed
	bit 7,a
	jr z,.buttonPressed
; if the player pressed tried to go past the bottom item, wrap around to the top
	ld a,[wCurrentMenuItem]
	ld c,DEBUG_MENU_LAST_ITEM
.checkIfPastBottom
	cp c
	jr nz,.loop
; the player went past the bottom, so wrap to the top
	xor a
	ld [wCurrentMenuItem],a
	call EraseMenuCursor
	jr .loop
.buttonPressed ; A, B, or Start button pressed
	call PlaceUnfilledArrowMenuCursor
	ld a,[wCurrentMenuItem]
	ld [wcc2d],a ; save current menu item ID
	ld a,b
	and a,%00001010 ; was the Start button or B button pressed?
	jp nz,CloseDebugMenu
	call SaveScreenTilesToBuffer2 ; copy background from wTileMap to wTileMapBackup2
	ld a,[wd74b]
	ld a,[wCurrentMenuItem]
	
	cp a, 0
	jp z, DebugMenuWTW
	
	cp a, 1
	jp z, DebugMenuFly
	
	cp a, 2
	jp z, DebugMenu251
	
	cp a, 3
	jp z, DebugMenuMasterB
	
	cp a, 4
	jp z, DebugMenuDex
	
	cp a, 5
	jp z, DebugMenuL100
	
	cp a, 6
	jp z, DebugMenuTestMove1
	cp a, 7
	jp z, DebugMenuTestMove2
	cp a, 8
	jp z, DebugMenuPSNMe

CloseDebugMenu:: 
	xor a
	ld [wCurrentMenuItem],a
	ld [wLastMenuItem],a
	ld [wcc37],a
	
    ld hl, $fff6
    res 1, [hl] ; one spaced
    ret
	;call Joypad
	;ld a,[hJoyPressed]
	;bit 0,a ; was A button newly pressed?
	;jr nz,CloseDebugMenu
	;call LoadTextBoxTilePatterns
	;jp CloseTextDisplay

PrintDebugMenuItem: ; 71bb (1:71bb)
	push hl
	call PlaceString
	pop hl
	ld de,$28/2
	add hl,de
	ret

DebugMenuItem0: db "WTW@"
DebugMenuItem1: db "FLY@"
DebugMenuItem2: db "Wild 251@"
DebugMenuItem3: db "MasterB",$f0,"@"
DebugMenuItem4: db "DEX@"
DebugMenuItem5: db "L100@"
DebugMenuItem6: db "TESTMOV1@"
DebugMenuItem7: db "TESTMOV2@"
DebugMenuItem8: db "PSN me!@"

DebugMenuWTW:
    ld a, 1
    ld [$cd38], a
    ret

DebugMenuFly:
    ld hl, W_TOWNVISITEDFLAG
    ld a, $ff
    ld [hli], a
    ld [hl], a
    call ChooseFlyDestination
    ret

DebugMenu251:
    ld hl, wd72d
    res 4, [hl]
    ld hl, wd72e
    res 4, [hl]
    ld a, 251
    ld [W_CUROPPONENT], a
    ld a, 5
    ld [W_CURENEMYLVL], a
    ret

DebugMenuMasterB:
    ld a, $99
    ld [wPlayerMoney], a
    ld [wPlayerMoney+1], a
    ld [wPlayerMoney+2], a
    ld b, MASTER_BALL
    ld b, b
    ld c, 99
    jp GiveItem

DebugMenuDex:
	ld a,[wd74b]
	set 5, a
	ld a, $ff
	ld bc, 512/8
	ld hl, wPokedexOwned
	call FillMemory
	
	predef ShowPokedexMenu
	call LoadScreenTilesFromBuffer2 ; restore saved screen
	call Delay3
	call LoadGBPal
	call UpdateSprites
	
    ret

DebugMenuL100:
    ld bc,(151 << 8) | 100
    jp GivePokemon

DebugMenuTestMove1:
    ld d, DRAIN_PUNCH
    jr DebugMenuTestMoveCommon

DebugMenuTestMove2:
    ld d, BUG_BUZZ
DebugMenuTestMoveCommon:
    ld hl, wPartyMon1Moves
    ld c, 0
.monloop
    ld b, 0
.moveloop
    ld a, d
    ld [hli], a
    inc d
    inc b
    ld a, b
    cp 4
    jr nz, .moveloop
    
    ld a, l
    add wPartyMon1PP - (wPartyMon1Moves+4)
    ld l, a
    jr nc, .nc
    inc h
.nc
    ld a, $ff
    ld [hli], a
    ld [hli], a
    ld [hli], a
    ld [hl], a
    
    ld a, l
    add wPartyMon2Moves - (wPartyMon1PP+3)
    ld l, a
    jr nc, .nc2
    inc h
.nc2
    
    inc c
    ld a, c
    cp 6
    jr nz, .monloop
    
    
    ret

DebugMenuPSNMe:
	ld a, 1 << PSN
	ld [wPartyMon1Status], a
	ret
    
    
