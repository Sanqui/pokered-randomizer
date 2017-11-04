DisplayStartMenu:: ; 2acd (0:2acd)
	ld a,$04 ; hardcoded Bank, not sure what's it refers to
	ld [H_LOADEDROMBANK],a
	ld [$2000],a ; ROM bank 4
	ld a,[wWalkBikeSurfState] ; walking/biking/surfing
	ld [wWalkBikeSurfStateCopy],a
	ld a, RBSFX_02_3f ; Start menu sound
	call PlaySound

RedisplayStartMenu:: ; 2adf (0:2adf)
	callba DrawStartMenu
	callba PrintSafariZoneSteps ; print Safari Zone info, if in Safari Zone
	call UpdateSprites ; move sprites
.loop
	call HandleMenuInput
	ld b,a
    ld a, b
	cp SELECT
	jr nz, .notselect
    ld a, [RandomizerFlags]
    bit 1, a
    jr z, .loop ; debug menu disabled
	jp StartMenu_Debug
.notselect
.checkIfUpPressed
    ld a, b
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
	bit 5,a ; does the player have the pokedex?
	ld a,6 ; there are 7 menu items with the pokedex, so the max index is 6
	jr nz,.wrapMenuItemId
	dec a ; there are only 6 menu items without the pokedex
.wrapMenuItemId
	ld [wCurrentMenuItem],a
	call EraseMenuCursor
	jr .loop
.checkIfDownPressed
	bit 7,a
	jr z,.buttonPressed
; if the player pressed tried to go past the bottom item, wrap around to the top
	ld a,[wd74b]
	bit 5,a ; does the player have the pokedex?
	ld a,[wCurrentMenuItem]
	ld c,7 ; there are 7 menu items with the pokedex
	jr nz,.checkIfPastBottom
	dec c ; there are only 6 menu items without the pokedex
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
	jp nz,CloseStartMenu
	call SaveScreenTilesToBuffer2 ; copy background from wTileMap to wTileMapBackup2
	ld a,[wd74b]
	bit 5,a ; does the player have the pokedex?
	ld a,[wCurrentMenuItem]
	jr nz,.displayMenuItem
	inc a ; adjust position to account for missing pokedex menu item
.displayMenuItem
	cp a,0
	jp z,StartMenu_Pokedex
	cp a,1
	jp z,StartMenu_Pokemon
	cp a,2
	jp z,StartMenu_Item
	cp a,3
	jp z,StartMenu_TrainerInfo
	cp a,4
	jp z,StartMenu_SaveReset
	cp a,5
	jp z,StartMenu_Option

; EXIT falls through to here
CloseStartMenu:: ; 2b70 (0:2b70)
	call Joypad
	ld a,[hJoyPressed]
	bit 0,a ; was A button newly pressed?
	jr nz,CloseStartMenu
	call LoadTextBoxTilePatterns
	jp CloseTextDisplay

StartMenu_Debug:
    callab DebugMenu
    jp CloseStartMenu
