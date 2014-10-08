PlayDefaultMusic:: ; 2307 (0:2307)
	call WaitForSoundToFinish
	xor a
	ld c, a
	ld d, a
	ld [wcfca], a
	jr asm_2324

Func_2312:: ; 2312 (0:2312)
	ld c, $a
	ld d, $0
	ld a, [wd72e]
	bit 5, a
	jr z, asm_2324
	xor a
	ld [wcfca], a
	ld c, $8
	ld d, c
asm_2324:: ; 2324 (0:2324)
	ld a, [wWalkBikeSurfState]
	and a
	jr z, .asm_2343
	cp $2
	jr z, .asm_2332
	ld a, MUSIC_BIKE_RIDING
	jr .asm_2334
.asm_2332
	ld a, MUSIC_SURFING
.asm_2334
	ld b, a
	ld a, d
	and a
	ld a, 0 ; 0 ; BANK(Music_BikeRiding)
	jr nz, .asm_233e
	ld [wc0ef], a
.asm_233e
	ld [wc0f0], a
	jr .asm_234c
.asm_2343
	ld a, [wd35b]
	ld b, a
	call Func_2385
	jr c, .asm_2351
.asm_234c
	ld a, [wcfca]
	cp b
	ret z
.asm_2351
	ld a, c
	ld [wMusicHeaderPointer], a
	ld a, b
	ld [wcfca], a
	ld [wc0ee], a
	
	ld [MusicFadeID], a
	ld a, 1
	ld [MusicFade], a
	;call FadeMusic ; called in updatemusic
	ret

Func_235f:: ; 235f (0:235f)
    ;jp UpdateSound
    ret ; XXX UpdateMusic

Func_2385:
    
    ret

; plays music specified by a. If value is $ff, music is stopped
PlaySound:: ; 23b1 (0:23b1)
    jp PlayMusic

OpenSRAMForSound::
	ld a, SRAM_ENABLE
	ld [MBC1SRamEnable], a
	xor a
	ld [MBC1SRamBankingMode], a
	ld [MBC1SRamBank], a
	ret

SoundRestart:: ; 3b4e

	push hl
	push de
	push bc
	push af
	
    call OpenSRAMForSound
    
	ld a, [hROMBank]
	push af
	ld a, BANK(_SoundRestart)
	ld [hROMBank], a
	ld [$2000], a

	call _SoundRestart

	pop af
	ld [hROMBank], a
	ld [$2000], a

	pop af
	pop bc
	pop de
	pop hl
	ret
; 3b6a


UpdateSound:: ; 3b6a

	push hl
	push de
	push bc
	push af
	
    call OpenSRAMForSound
    
	ld a, [hROMBank]
	push af
	ld a, BANK(_UpdateSound)
	ld [hROMBank], a
	ld [$2000], a

	call _UpdateSound

	pop af
	ld [hROMBank], a
	ld [$2000], a

	pop af
	pop bc
	pop de
	pop hl
	ret
; 3b86

PlayMusic:: ; 3b97
    ld e, a
    xor a
    ld d, a
; Play music de.

	push hl
	push de
	push bc
	push af
	
    call OpenSRAMForSound
    
	ld a, [hROMBank]
	push af
	ld a, BANK(_PlayMusic) ; and BANK(_SoundRestart)
	ld [hROMBank], a
	ld [$2000], a

	ld a, e
	and a
	jr z, .nomusic

	call _PlayMusic
	jr .end

.nomusic
	call _SoundRestart

.end
	pop af
	ld [hROMBank], a
	ld [$2000], a
	pop af
	pop bc
	pop de
	pop hl
	ret
; 3bbc


_LoadMusicByte:: ; 3b86
; CurMusicByte = [a:de]
GLOBAL LoadMusicByte
    
	ld [hROMBank], a
	ld [$2000], a

	ld a, [de]
	ld [CurMusicByte], a
	ld a, BANK(LoadMusicByte)

	ld [hROMBank], a
	ld [$2000], a
	ret
