PrintTextNext:
    ld a, [wVWFCurTileNum]
    inc a
    ld [wVWFCurTileNum], a
    jr PrintTextCommon
PrintText:
    ld a, d
    ld [wVWFCurTileNum], a
PrintTextCommon:
    ld [wVWFFirstTileNum], a
    xor a
    ld [wVWFCurTileCol], a
PrintTextContinuous:
.loop
    ld a, [hli]
    cp "@"
    ret z
    call WriteChar
    jr .loop

CopyColumn:
    ; b = source column
    ; c = dest column
    ; de = source number
    ; hl = dest number
    push hl
    push de
    ld a, $08
.Copy
    push af
    ld a, [de]
    and a, b
    jr nz, .CopyOne
.CopyZero
    ld a, %11111111
    xor c
    and [hl]
    jp .Next
.CopyOne
    ld a, c
    or [hl]
.Next
    ld [hli],a
    inc de
    pop af
    dec a
    jp nz, .Copy
    pop de
    pop hl
    ret

WriteChar:
    push de
    push hl
    ld [wVWFChar], a
    
    ; Store the character tile in BuildArea0.
    ld hl, VWFFont
    ld b, 0
    ld c, a
    ld a, $8
    call AddNTimes
    ld bc, $0008
    ld de, wVWFBuildArea0
    call CopyData ; copy bc source bytes from hl to de
    
    ld a, $1
    ld [wVWFNumTilesUsed], a
    
    ; Get the character length from the width table.
    ld a, [wVWFChar]
    ld c, a
    ld b, $00
    ld hl, VWFTable
    add hl, bc
    ld a, [hl]
    ld [wVWFCharWidth], a
.WidthWritten
    ; Set up some things for building the tile.
    ; Special cased to fix column $0, which is invalid (not a power of 2)
    ld de, wVWFBuildArea0
    ld hl, wVWFBuildArea2
    ;ld b, a
    ld b, %10000000
    ld a, [wVWFCurTileCol]
    and a
    jr nz, .ColumnIsFine
    ld a, $80
.ColumnIsFine
    ld c, a ; a
.DoColumn
    ; Copy the column.
    call CopyColumn
    rr c
    jr c, .TileOverflow
    rrc b
    ld a, [wVWFCharWidth]
    dec a
    ld [wVWFCharWidth], a
    jr nz, .DoColumn
    jr .Done
.TileOverflow
    ld c, $80
    ld a, $2
    ld [wVWFNumTilesUsed], a
    ld hl, wVWFBuildArea3
    jr .ShiftB
.DoColumnTile2
    call CopyColumn
    rr c
.ShiftB
    rrc b
    ld a, [wVWFCharWidth]
    dec a
    ld [wVWFCharWidth], a
    jr nz, .DoColumnTile2
.Done
    ld a, c
    ld [wVWFCurTileCol], a
    
    ; 1bpp -> 2bpp
    ld b, $10
    ld de, wVWFBuildArea2
    ld hl, wVWFCopyArea
    
.doubleloop
    ld a, [de]
    inc de
    ld [hli], a
    ld [hli], a
    dec b
    jr nz, .doubleloop

    ; Get the tileset offset.
    ld hl, $8800
    ld a, [wVWFCurTileNum]
    ld b, $0
    ld c, a
    ld a, 16
    call AddNTimes
    
    push hl
    pop de
    ld hl, wVWFCopyArea
    
    ; Write the new tile(s)
    
    ld a, [hli]
    ld [de], a
    inc de

    ld a, [wVWFNumTilesUsed]
    dec a
    jr z, .copied
    
    ld a, [hli]
    ld [de], a
    inc de

.copied

    ld a, [wVWFNumTilesUsed]
    dec a
    dec a
    jr nz, .SecondAreaUnused
    
    ; If we went over one tile, make sure we start with it next time.
    ; also move through the tilemap.
    ld a, [wVWFCurTileNum]
    inc a
    ld [wVWFCurTileNum], a
    
    ld hl, wVWFBuildArea3
    ld de, wVWFBuildArea2
    ld bc, 8
    call CopyData ; Copy bc bytes from hl to de.
    
    ld hl, wVWFBuildArea3
    ld bc, 8
    xor a
    call FillMemory ; Fill bc bytes at hl with a.
    
    ld hl, wVWFCopyArea
    ld bc, 16
    xor a
    call FillMemory ; Fill bc bytes at hl with a.

.SecondAreaUnused
    
.AlmostDone
    pop hl
    pop de
    ret
    
VWFTable:
    db 6, 6, 6, 6, 6, 6, 6, 6, 6, 6, 6, 6, 6, 6, 6, 6
    db 6, 6, 6, 6, 6, 6, 6, 6, 6, 6, 6, 6, 6, 6, 6, 6
    
    db 4, 6, 6, 6, 6, 6, 6, 6, 6, 6, 6, 6, 6, 6, 6, 6
    db 8, 8, 8, 8, 8, 8, 8, 8, 8, 8, 8, 8, 8, 8, 8, 8
    
    db 6, 6, 6, 6, 6, 6, 6, 6, 6, 6, 6, 6, 6, 6, 6, 6
    db 6, 6, 6, 6, 6, 6, 6, 6, 6, 6, 6, 6, 6, 6, 6, 6
    db 6, 6, 5, 5, 5, 5, 4, 5, 5, 3, 3, 5, 3, 6, 5, 5
    db 5, 5, 5, 5, 5, 5, 6, 5, 5, 5, 5, 0, 0, 0, 0, 0
    
    db 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0

VWFFont:
    INCBIN "splash/vwffont.1bpp"
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
