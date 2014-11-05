
AUDIO_1 EQU $2
AUDIO_2 EQU $8
AUDIO_3 EQU $1f

INCLUDE "constants.asm"
INCLUDE "crysmacros.asm"

; crystal.py macros: 
octave: MACRO
	db $d8 - (\1)
	ENDM
	
notetype: MACRO
	db $d8, \1
IF _NARG==2
    db \2
ENDC
	ENDM
forceoctave: MACRO
	db $d9, \1
	ENDM
tempo: MACRO
	db $da
	bigdw \1
	ENDM
dutycycle: MACRO
	db $db, \1
	ENDM
intensity: MACRO
	db $dc, \1
	ENDM
soundinput: MACRO
	db $dd, \1
	ENDM
unknownmusic0xde: MACRO
	db $de, \1
	ENDM
togglesfx: MACRO
	db $df
	ENDM
unknownmusic0xe0: MACRO
	db $e0, \1, \2
	ENDM
vibrato: MACRO
	db $e1, \1, \2
	ENDM
unknownmusic0xe2: MACRO
	db $e2, \1
	ENDM
togglenoise: MACRO
	db $e3, \1
	ENDM
panning: MACRO
	db $e4, \1
	ENDM
volume: MACRO
	db $e5, \1
	ENDM
tone: MACRO
	db $e6
	bigdw \1
	ENDM
unknownmusic0xe7: MACRO
	db $e7, \1
	ENDM
unknownmusic0xe8: MACRO
	db $e8, \1
	ENDM
globaltempo: MACRO
	db $e9
	bigdw \1
	ENDM
restartchannel: MACRO
	dbw $ea, \1
	ENDM
newsong: MACRO
	db $eb
	bigdw \1
	ENDM
sfxpriorityon: MACRO
	db $ec
	ENDM
sfxpriorityoff: MACRO
	db $ed
	ENDM
unknownmusic0xee: MACRO
	dbw $ee, \1
	ENDM
stereopanning: MACRO
	db $ef, \1
	ENDM
sfxtogglenoise: MACRO
	db $f0, \1
	ENDM
ftempo: MACRO
	db $f1
	bigdw \1
	ENDM
fdutycycle: MACRO
	db $f2, \1
	ENDM
music0xf3: MACRO
	db $f3
	ENDM
incoctave: MACRO
	db $f4
	ENDM
decoctave: MACRO
	db $f5
	ENDM
music0xf6: MACRO
	db $f6
	ENDM
music0xf7: MACRO
	db $f7
	ENDM
music0xf8: MACRO
	db $f8
	ENDM
unknownmusic0xf9: MACRO
	db $f9, \1
	ENDM
setcondition: MACRO
	db $fa, \1
	ENDM
jumpif: MACRO
	db $fb, \1
	dw \2
	ENDM
jumpchannel: MACRO
	dbw $fc, \1
	ENDM
loopchannel: MACRO
	db $fd, \1
	dw \2
	ENDM
callchannel: MACRO
	dbw $fe, \1
	ENDM
endchannel: MACRO
	db $ff
	ENDM
	
	
sound: MACRO
    db \1, \2
    dw \3
    ENDM

noise: MACRO
    db \1, \2, \3
    ENDM
    
toggleperfectpitch: MACRO ; XXX XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX
	ENDM
; red:

SECTION "Battle SFX Shim", ROMX
Bank08OldSFXHeaderPositions:
    db $01, $02, $03, $04, $05, $06, $07, $08, $09, $0A, $0B, $0C, $0D, $0E, $0F, $10, $11, $12, $13, $14, $17, $1A, $1D, $20, $23, $26, $29, $2C, $2F, $32, $35, $38, $3B, $3E, $41, $44, $47, $4A, $4D, $50, $53, $56, $59, $5C, $5F, $62, $65, $68, $6B, $6E, $71, $74, $77, $7A, $7D, $80, $83, $86, $89, $8C, $8D, $8E, $8F, $90, $91, $93, $95, $97, $98, $9A, $9D, $9E, $9F, $A0, $A1, $A2, $A3, $A4, $A5, $A6, $A7, $A8, $A9, $AA, $AB, $AC, $AD, $AE, $AF, $B0, $B1, $B2, $B3, $B4, $B6, $B7, $B8, $B9, $BA, $BB, $BD, $BE, $BF, $C2, $C5, $C7, $CA, $CC, $CF, $D2, $D5, $D8, $DB, $DD, $DF, $E1, $E4, $E6, $E9
    db $ff

_PlayAnimSoundShim::
    ; Okay, so, basically, we need to convert old SFX IDs into
    ; new ones.
    ; This is done via a lookup table.
    ld a, d
    ld b, 1
    ld c, a
    ld hl, Bank08OldSFXHeaderPositions
.loop
    ld a, [hli]
    cp c
    jr z, .found
    cp $ff
    jr z, .not_found
    inc b
    jr .loop
.found
    ld a, b
    ; Is this ID shared (02), or unique to the battle bank? (08)
    ; $5d is the first 1F-only sfx
    cp $40
    jr c, .done
    add $20 ; - $40 + $60
.done
    ld d, a
    ret
.not_found
    ld b, b
    ret

SECTION "Sound Effect Headers 1", ROMX, BANK[AUDIO_1]
INCLUDE "audio/headers/sfxheaders02.asm"
SECTION "Sound Effect Headers 2", ROMX, BANK[AUDIO_2]
INCLUDE "audio/headers/sfxheaders08.asm"
SECTION "Sound Effect Headers 3", ROMX, BANK[AUDIO_3]
INCLUDE "audio/headers/sfxheaders1f.asm"

SECTION "Sound Effects 1", ROMX, BANK[AUDIO_1]

SFX_02:
INCLUDE "audio/sfx/sfx_02_01.asm"
INCLUDE "audio/sfx/sfx_02_02.asm"
INCLUDE "audio/sfx/sfx_02_03.asm"
INCLUDE "audio/sfx/sfx_02_04.asm"
INCLUDE "audio/sfx/sfx_02_05.asm"
INCLUDE "audio/sfx/sfx_02_06.asm"
INCLUDE "audio/sfx/sfx_02_07.asm"
INCLUDE "audio/sfx/sfx_02_08.asm"
INCLUDE "audio/sfx/sfx_02_09.asm"
INCLUDE "audio/sfx/sfx_02_0a.asm"
INCLUDE "audio/sfx/sfx_02_0b.asm"
INCLUDE "audio/sfx/sfx_02_0c.asm"
INCLUDE "audio/sfx/sfx_02_0d.asm"
INCLUDE "audio/sfx/sfx_02_0e.asm"
INCLUDE "audio/sfx/sfx_02_0f.asm"
INCLUDE "audio/sfx/sfx_02_10.asm"
INCLUDE "audio/sfx/sfx_02_11.asm"
INCLUDE "audio/sfx/sfx_02_12.asm"
INCLUDE "audio/sfx/sfx_02_13.asm"

Music2_WavePointers: INCLUDE "audio/wave_instruments.asm"

INCLUDE "audio/sfx/sfx_02_3f.asm"
INCLUDE "audio/sfx/sfx_02_5e.asm"
INCLUDE "audio/sfx/sfx_02_56.asm"
INCLUDE "audio/sfx/sfx_02_57.asm"
INCLUDE "audio/sfx/sfx_02_58.asm"
INCLUDE "audio/sfx/sfx_02_3c.asm"
INCLUDE "audio/sfx/sfx_02_59.asm"
INCLUDE "audio/sfx/sfx_02_5a.asm"
INCLUDE "audio/sfx/sfx_02_5b.asm"
INCLUDE "audio/sfx/sfx_02_5c.asm"
INCLUDE "audio/sfx/sfx_02_40.asm"
INCLUDE "audio/sfx/sfx_02_5d.asm"
INCLUDE "audio/sfx/sfx_02_3d.asm"
INCLUDE "audio/sfx/sfx_02_43.asm"
INCLUDE "audio/sfx/sfx_02_3e.asm"
INCLUDE "audio/sfx/sfx_02_44.asm"
INCLUDE "audio/sfx/sfx_02_45.asm"
INCLUDE "audio/sfx/sfx_02_46.asm"
INCLUDE "audio/sfx/sfx_02_47.asm"
INCLUDE "audio/sfx/sfx_02_48.asm"
INCLUDE "audio/sfx/sfx_02_49.asm"
INCLUDE "audio/sfx/sfx_02_4a.asm"
INCLUDE "audio/sfx/sfx_02_4b.asm"
INCLUDE "audio/sfx/sfx_02_4c.asm"
INCLUDE "audio/sfx/sfx_02_4d.asm"
INCLUDE "audio/sfx/sfx_02_4e.asm"
INCLUDE "audio/sfx/sfx_02_4f.asm"
INCLUDE "audio/sfx/sfx_02_50.asm"
INCLUDE "audio/sfx/sfx_02_51.asm"
INCLUDE "audio/sfx/sfx_02_52.asm"
INCLUDE "audio/sfx/sfx_02_53.asm"
INCLUDE "audio/sfx/sfx_02_54.asm"
INCLUDE "audio/sfx/sfx_02_55.asm"
INCLUDE "audio/sfx/sfx_02_5f.asm"
INCLUDE "audio/sfx/sfx_02_unused.asm"
INCLUDE "audio/sfx/sfx_02_1d.asm"
INCLUDE "audio/sfx/sfx_02_37.asm"
INCLUDE "audio/sfx/sfx_02_38.asm"
INCLUDE "audio/sfx/sfx_02_25.asm"
INCLUDE "audio/sfx/sfx_02_39.asm"
INCLUDE "audio/sfx/sfx_02_17.asm"
INCLUDE "audio/sfx/sfx_02_23.asm"
INCLUDE "audio/sfx/sfx_02_24.asm"
INCLUDE "audio/sfx/sfx_02_14.asm"
INCLUDE "audio/sfx/sfx_02_22.asm"
INCLUDE "audio/sfx/sfx_02_1a.asm"
INCLUDE "audio/sfx/sfx_02_1b.asm"
INCLUDE "audio/sfx/sfx_02_19.asm"
INCLUDE "audio/sfx/sfx_02_1f.asm"
INCLUDE "audio/sfx/sfx_02_20.asm"
INCLUDE "audio/sfx/sfx_02_16.asm"
INCLUDE "audio/sfx/sfx_02_21.asm"
INCLUDE "audio/sfx/sfx_02_15.asm"
INCLUDE "audio/sfx/sfx_02_1e.asm"
INCLUDE "audio/sfx/sfx_02_1c.asm"
INCLUDE "audio/sfx/sfx_02_18.asm"
INCLUDE "audio/sfx/sfx_02_2d.asm"
INCLUDE "audio/sfx/sfx_02_2a.asm"
INCLUDE "audio/sfx/sfx_02_2f.asm"
INCLUDE "audio/sfx/sfx_02_26.asm"
INCLUDE "audio/sfx/sfx_02_27.asm"
INCLUDE "audio/sfx/sfx_02_28.asm"
INCLUDE "audio/sfx/sfx_02_32.asm"
INCLUDE "audio/sfx/sfx_02_29.asm"
INCLUDE "audio/sfx/sfx_02_2b.asm"
INCLUDE "audio/sfx/sfx_02_30.asm"
INCLUDE "audio/sfx/sfx_02_2e.asm"
INCLUDE "audio/sfx/sfx_02_31.asm"
INCLUDE "audio/sfx/sfx_02_2c.asm"
INCLUDE "audio/sfx/sfx_02_33.asm"
INCLUDE "audio/sfx/sfx_02_34.asm"
INCLUDE "audio/sfx/sfx_02_35.asm"
INCLUDE "audio/sfx/sfx_02_36.asm"

INCLUDE "audio/sfx/sfx_02_3a.asm"
INCLUDE "audio/sfx/sfx_02_41.asm"
INCLUDE "audio/sfx/sfx_02_3b.asm"
INCLUDE "audio/sfx/sfx_02_42.asm"

SECTION "Sound Effects 2", ROMX, BANK[AUDIO_2]

SFX_08:
INCLUDE "audio/sfx/sfx_08_01.asm"
INCLUDE "audio/sfx/sfx_08_02.asm"
INCLUDE "audio/sfx/sfx_08_03.asm"
INCLUDE "audio/sfx/sfx_08_04.asm"
INCLUDE "audio/sfx/sfx_08_05.asm"
INCLUDE "audio/sfx/sfx_08_06.asm"
INCLUDE "audio/sfx/sfx_08_07.asm"
INCLUDE "audio/sfx/sfx_08_08.asm"
INCLUDE "audio/sfx/sfx_08_09.asm"
INCLUDE "audio/sfx/sfx_08_0a.asm"
INCLUDE "audio/sfx/sfx_08_0b.asm"
INCLUDE "audio/sfx/sfx_08_0c.asm"
INCLUDE "audio/sfx/sfx_08_0d.asm"
INCLUDE "audio/sfx/sfx_08_0e.asm"
INCLUDE "audio/sfx/sfx_08_0f.asm"
INCLUDE "audio/sfx/sfx_08_10.asm"
INCLUDE "audio/sfx/sfx_08_11.asm"
INCLUDE "audio/sfx/sfx_08_12.asm"
INCLUDE "audio/sfx/sfx_08_13.asm"

Music8_WavePointers: INCLUDE "audio/wave_instruments.asm"

INCLUDE "audio/sfx/sfx_08_40.asm"
INCLUDE "audio/sfx/sfx_08_3f.asm"
INCLUDE "audio/sfx/sfx_08_3c.asm"
INCLUDE "audio/sfx/sfx_08_3d.asm"
INCLUDE "audio/sfx/sfx_08_3e.asm"
INCLUDE "audio/sfx/sfx_08_77.asm"
INCLUDE "audio/sfx/sfx_08_41.asm"
INCLUDE "audio/sfx/sfx_08_42.asm"
INCLUDE "audio/sfx/sfx_08_43.asm"
INCLUDE "audio/sfx/sfx_08_44.asm"
INCLUDE "audio/sfx/sfx_08_45.asm"
INCLUDE "audio/sfx/sfx_08_pokeflute_ch3.asm"
INCLUDE "audio/sfx/sfx_08_47.asm"
INCLUDE "audio/sfx/sfx_08_48.asm"
INCLUDE "audio/sfx/sfx_08_49.asm"
INCLUDE "audio/sfx/sfx_08_4a.asm"
INCLUDE "audio/sfx/sfx_08_4b.asm"
INCLUDE "audio/sfx/sfx_08_4c.asm"
INCLUDE "audio/sfx/sfx_08_4d.asm"
INCLUDE "audio/sfx/sfx_08_4e.asm"
INCLUDE "audio/sfx/sfx_08_4f.asm"
INCLUDE "audio/sfx/sfx_08_50.asm"
INCLUDE "audio/sfx/sfx_08_51.asm"
INCLUDE "audio/sfx/sfx_08_52.asm"
INCLUDE "audio/sfx/sfx_08_53.asm"
INCLUDE "audio/sfx/sfx_08_54.asm"
INCLUDE "audio/sfx/sfx_08_55.asm"
INCLUDE "audio/sfx/sfx_08_56.asm"
INCLUDE "audio/sfx/sfx_08_57.asm"
INCLUDE "audio/sfx/sfx_08_58.asm"
INCLUDE "audio/sfx/sfx_08_59.asm"
INCLUDE "audio/sfx/sfx_08_5a.asm"
INCLUDE "audio/sfx/sfx_08_5b.asm"
INCLUDE "audio/sfx/sfx_08_5c.asm"
INCLUDE "audio/sfx/sfx_08_5d.asm"
INCLUDE "audio/sfx/sfx_08_5e.asm"
INCLUDE "audio/sfx/sfx_08_5f.asm"
INCLUDE "audio/sfx/sfx_08_60.asm"
INCLUDE "audio/sfx/sfx_08_61.asm"
INCLUDE "audio/sfx/sfx_08_62.asm"
INCLUDE "audio/sfx/sfx_08_63.asm"
INCLUDE "audio/sfx/sfx_08_64.asm"
INCLUDE "audio/sfx/sfx_08_65.asm"
INCLUDE "audio/sfx/sfx_08_66.asm"
INCLUDE "audio/sfx/sfx_08_67.asm"
INCLUDE "audio/sfx/sfx_08_68.asm"
INCLUDE "audio/sfx/sfx_08_69.asm"
INCLUDE "audio/sfx/sfx_08_6a.asm"
INCLUDE "audio/sfx/sfx_08_6b.asm"
INCLUDE "audio/sfx/sfx_08_6c.asm"
INCLUDE "audio/sfx/sfx_08_6d.asm"
INCLUDE "audio/sfx/sfx_08_6e.asm"
INCLUDE "audio/sfx/sfx_08_6f.asm"
INCLUDE "audio/sfx/sfx_08_70.asm"
INCLUDE "audio/sfx/sfx_08_71.asm"
INCLUDE "audio/sfx/sfx_08_72.asm"
INCLUDE "audio/sfx/sfx_08_73.asm"
INCLUDE "audio/sfx/sfx_08_74.asm"
INCLUDE "audio/sfx/sfx_08_75.asm"
INCLUDE "audio/sfx/sfx_08_76.asm"
INCLUDE "audio/sfx/sfx_08_unused.asm"
INCLUDE "audio/sfx/sfx_08_1d.asm"
INCLUDE "audio/sfx/sfx_08_37.asm"
INCLUDE "audio/sfx/sfx_08_38.asm"
INCLUDE "audio/sfx/sfx_08_25.asm"
INCLUDE "audio/sfx/sfx_08_39.asm"
INCLUDE "audio/sfx/sfx_08_17.asm"
INCLUDE "audio/sfx/sfx_08_23.asm"
INCLUDE "audio/sfx/sfx_08_24.asm"
INCLUDE "audio/sfx/sfx_08_14.asm"
INCLUDE "audio/sfx/sfx_08_22.asm"
INCLUDE "audio/sfx/sfx_08_1a.asm"
INCLUDE "audio/sfx/sfx_08_1b.asm"
INCLUDE "audio/sfx/sfx_08_19.asm"
INCLUDE "audio/sfx/sfx_08_1f.asm"
INCLUDE "audio/sfx/sfx_08_20.asm"
INCLUDE "audio/sfx/sfx_08_16.asm"
INCLUDE "audio/sfx/sfx_08_21.asm"
INCLUDE "audio/sfx/sfx_08_15.asm"
INCLUDE "audio/sfx/sfx_08_1e.asm"
INCLUDE "audio/sfx/sfx_08_1c.asm"
INCLUDE "audio/sfx/sfx_08_18.asm"
INCLUDE "audio/sfx/sfx_08_2d.asm"
INCLUDE "audio/sfx/sfx_08_2a.asm"
INCLUDE "audio/sfx/sfx_08_2f.asm"
INCLUDE "audio/sfx/sfx_08_26.asm"
INCLUDE "audio/sfx/sfx_08_27.asm"
INCLUDE "audio/sfx/sfx_08_28.asm"
INCLUDE "audio/sfx/sfx_08_32.asm"
INCLUDE "audio/sfx/sfx_08_29.asm"
INCLUDE "audio/sfx/sfx_08_2b.asm"
INCLUDE "audio/sfx/sfx_08_30.asm"
INCLUDE "audio/sfx/sfx_08_2e.asm"
INCLUDE "audio/sfx/sfx_08_31.asm"
INCLUDE "audio/sfx/sfx_08_2c.asm"
INCLUDE "audio/sfx/sfx_08_33.asm"
INCLUDE "audio/sfx/sfx_08_34.asm"
INCLUDE "audio/sfx/sfx_08_35.asm"
INCLUDE "audio/sfx/sfx_08_36.asm"

INCLUDE "audio/sfx/sfx_08_3a.asm"
INCLUDE "audio/sfx/sfx_08_3b.asm"
INCLUDE "audio/sfx/sfx_08_46.asm"
INCLUDE "audio/sfx/sfx_08_pokeflute.asm"
INCLUDE "audio/sfx/sfx_08_unused2.asm"


SECTION "Sound Effects 3", ROMX, BANK[AUDIO_3]

SFX_1F:
INCLUDE "audio/sfx/sfx_1f_01.asm"
INCLUDE "audio/sfx/sfx_1f_02.asm"
INCLUDE "audio/sfx/sfx_1f_03.asm"
INCLUDE "audio/sfx/sfx_1f_04.asm"
INCLUDE "audio/sfx/sfx_1f_05.asm"
INCLUDE "audio/sfx/sfx_1f_06.asm"
INCLUDE "audio/sfx/sfx_1f_07.asm"
INCLUDE "audio/sfx/sfx_1f_08.asm"
INCLUDE "audio/sfx/sfx_1f_09.asm"
INCLUDE "audio/sfx/sfx_1f_0a.asm"
INCLUDE "audio/sfx/sfx_1f_0b.asm"
INCLUDE "audio/sfx/sfx_1f_0c.asm"
INCLUDE "audio/sfx/sfx_1f_0d.asm"
INCLUDE "audio/sfx/sfx_1f_0e.asm"
INCLUDE "audio/sfx/sfx_1f_0f.asm"
INCLUDE "audio/sfx/sfx_1f_10.asm"
INCLUDE "audio/sfx/sfx_1f_11.asm"
INCLUDE "audio/sfx/sfx_1f_12.asm"
INCLUDE "audio/sfx/sfx_1f_13.asm"

Music1f_WavePointers: INCLUDE "audio/wave_instruments.asm"

INCLUDE "audio/sfx/sfx_1f_3f.asm"
INCLUDE "audio/sfx/sfx_1f_56.asm"
INCLUDE "audio/sfx/sfx_1f_57.asm"
INCLUDE "audio/sfx/sfx_1f_58.asm"
INCLUDE "audio/sfx/sfx_1f_3c.asm"
INCLUDE "audio/sfx/sfx_1f_59.asm"
INCLUDE "audio/sfx/sfx_1f_5a.asm"
INCLUDE "audio/sfx/sfx_1f_5b.asm"
INCLUDE "audio/sfx/sfx_1f_5c.asm"
INCLUDE "audio/sfx/sfx_1f_40.asm"
INCLUDE "audio/sfx/sfx_1f_5d.asm"
INCLUDE "audio/sfx/sfx_1f_3d.asm"
INCLUDE "audio/sfx/sfx_1f_43.asm"
INCLUDE "audio/sfx/sfx_1f_3e.asm"
INCLUDE "audio/sfx/sfx_1f_44.asm"
INCLUDE "audio/sfx/sfx_1f_45.asm"
INCLUDE "audio/sfx/sfx_1f_46.asm"
INCLUDE "audio/sfx/sfx_1f_47.asm"
INCLUDE "audio/sfx/sfx_1f_48.asm"
INCLUDE "audio/sfx/sfx_1f_49.asm"
INCLUDE "audio/sfx/sfx_1f_4a.asm"
INCLUDE "audio/sfx/sfx_1f_4b.asm"
INCLUDE "audio/sfx/sfx_1f_4c.asm"
INCLUDE "audio/sfx/sfx_1f_4d.asm"
INCLUDE "audio/sfx/sfx_1f_4e.asm"
INCLUDE "audio/sfx/sfx_1f_4f.asm"
INCLUDE "audio/sfx/sfx_1f_50.asm"
INCLUDE "audio/sfx/sfx_1f_51.asm"
INCLUDE "audio/sfx/sfx_1f_52.asm"
INCLUDE "audio/sfx/sfx_1f_53.asm"
INCLUDE "audio/sfx/sfx_1f_54.asm"
INCLUDE "audio/sfx/sfx_1f_55.asm"
INCLUDE "audio/sfx/sfx_1f_5e.asm"
INCLUDE "audio/sfx/sfx_1f_5f.asm"
INCLUDE "audio/sfx/sfx_1f_60.asm"
INCLUDE "audio/sfx/sfx_1f_61.asm"
INCLUDE "audio/sfx/sfx_1f_62.asm"
INCLUDE "audio/sfx/sfx_1f_63.asm"
INCLUDE "audio/sfx/sfx_1f_64.asm"
INCLUDE "audio/sfx/sfx_1f_65.asm"
INCLUDE "audio/sfx/sfx_1f_66.asm"
INCLUDE "audio/sfx/sfx_1f_67.asm"
INCLUDE "audio/sfx/sfx_1f_unused.asm"
INCLUDE "audio/sfx/sfx_1f_1d.asm"
INCLUDE "audio/sfx/sfx_1f_37.asm"
INCLUDE "audio/sfx/sfx_1f_38.asm"
INCLUDE "audio/sfx/sfx_1f_25.asm"
INCLUDE "audio/sfx/sfx_1f_39.asm"
INCLUDE "audio/sfx/sfx_1f_17.asm"
INCLUDE "audio/sfx/sfx_1f_23.asm"
INCLUDE "audio/sfx/sfx_1f_24.asm"
INCLUDE "audio/sfx/sfx_1f_14.asm"
INCLUDE "audio/sfx/sfx_1f_22.asm"
INCLUDE "audio/sfx/sfx_1f_1a.asm"
INCLUDE "audio/sfx/sfx_1f_1b.asm"
INCLUDE "audio/sfx/sfx_1f_19.asm"
INCLUDE "audio/sfx/sfx_1f_1f.asm"
INCLUDE "audio/sfx/sfx_1f_20.asm"
INCLUDE "audio/sfx/sfx_1f_16.asm"
INCLUDE "audio/sfx/sfx_1f_21.asm"
INCLUDE "audio/sfx/sfx_1f_15.asm"
INCLUDE "audio/sfx/sfx_1f_1e.asm"
INCLUDE "audio/sfx/sfx_1f_1c.asm"
INCLUDE "audio/sfx/sfx_1f_18.asm"
INCLUDE "audio/sfx/sfx_1f_2d.asm"
INCLUDE "audio/sfx/sfx_1f_2a.asm"
INCLUDE "audio/sfx/sfx_1f_2f.asm"
INCLUDE "audio/sfx/sfx_1f_26.asm"
INCLUDE "audio/sfx/sfx_1f_27.asm"
INCLUDE "audio/sfx/sfx_1f_28.asm"
INCLUDE "audio/sfx/sfx_1f_32.asm"
INCLUDE "audio/sfx/sfx_1f_29.asm"
INCLUDE "audio/sfx/sfx_1f_2b.asm"
INCLUDE "audio/sfx/sfx_1f_30.asm"
INCLUDE "audio/sfx/sfx_1f_2e.asm"
INCLUDE "audio/sfx/sfx_1f_31.asm"
INCLUDE "audio/sfx/sfx_1f_2c.asm"
INCLUDE "audio/sfx/sfx_1f_33.asm"
INCLUDE "audio/sfx/sfx_1f_34.asm"
INCLUDE "audio/sfx/sfx_1f_35.asm"
INCLUDE "audio/sfx/sfx_1f_36.asm"


INCLUDE "audio/sfx/sfx_1f_3a.asm"
INCLUDE "audio/sfx/sfx_1f_41.asm"
INCLUDE "audio/sfx/sfx_1f_3b.asm"
INCLUDE "audio/sfx/sfx_1f_42.asm"

SECTION "SFX previously interleaved with music", ROMX
;INCLUDE "audio/music/pkmnhealed.asm"




SECTION "Bill's PC", ROMX
INCLUDE "engine/menu/bills_pc.asm"

SECTION "Music Routines", ROMX
PlayBattleMusic:: ; 0x90c6
	xor a
	ld [wMusicHeaderPointer], a
	ld [wd083], a
	dec a
	ld [wc0ee], a
	call PlayMusic ; stop music
	call DelayFrame
	;ld c, BANK(Music_GymLeaderBattle)
	ld a, [W_GYMLEADERNO]
	and a
	jr z, .notGymLeaderBattle
	ld a, MUSIC_GYM_LEADER_BATTLE
	jr .playSong
.notGymLeaderBattle
	ld a, [W_CUROPPONENT]
	cp $c8
	jr c, .wildBattle
	cp SONY3 + $c8
	jr z, .finalBattle
	cp LANCE + $c8
	jr nz, .normalTrainerBattle
	ld a, MUSIC_GYM_LEADER_BATTLE ; lance also plays gym leader theme
	jr .playSong
.normalTrainerBattle
	ld a, MUSIC_TRAINER_BATTLE
	jr .playSong
.finalBattle
	ld a, MUSIC_FINAL_BATTLE
	jr .playSong
.wildBattle
	ld a, MUSIC_WILD_BATTLE
.playSong
	jp PlayMusic

SECTION "Alt Music Routines", ROMX
Music_RivalAlternateStart:: ; 0x9b47
	ld a, MUSIC_MEET_RIVAL
	jp PlayMusic
	;ld hl, wc006
	;ld de, Music_MeetRival_branch_b1a2
	;call Music2_OverwriteChannelPointer
	;ld de, Music_MeetRival_branch_b21d
	;call Music2_OverwriteChannelPointer
	;ld de, Music_MeetRival_branch_b2b5

; an alternate tempo for MeetRival which is slightly slower
Music_RivalAlternateTempo:: ; 0x9b65
	ld c, BANK(Music_MeetRival)
	ld a, MUSIC_MEET_RIVAL
	jp PlayMusic
	;ld hl, wc006
	;ld de, Music_MeetRival_branch_b119
	;jp Music2_OverwriteChannelPointer

; applies both the alternate start and alternate tempo
Music_RivalAlternateStartAndTempo:: ; 0x9b75
	jp Music_RivalAlternateStart
	;ld hl, wc006
	;ld de, Music_MeetRival_branch_b19b
	;jp Music2_OverwriteChannelPointer

; an alternate tempo for Cities1 which is used for the Hall of Fame room
Music_Cities1AlternateTempo:: ; 0x9b81
	ld a, $a
	ld [wcfc8], a
	ld [wcfc9], a
	ld a, $ff
	ld [wMusicHeaderPointer], a
	ld c, $64
	call DelayFrames
	ld c, BANK(Music_Cities1)
	ld a, MUSIC_CITIES1
	jp PlayMusic
	;ld hl, wc006
	;ld de, Music_Cities1_branch_aa6f
	;jp Music2_OverwriteChannelPointer

SECTION "Pokedex Rating SFX Routines", ROMX
Func_7d13b:: ; 7d13b (1f:513b)
	ld a, [$ffdc]
	ld c, $0
	ld hl, OwnedMonValues
.getSfxPointer
	cp [hl]
	jr c, .gotSfxPointer
	inc c
	inc hl
	jr .getSfxPointer
.gotSfxPointer
	push bc
	ld a, $ff
	ld [wc0ee], a
	call PlaySoundWaitForCurrent
	pop bc
	ld b, $0
	ld hl, PokedexRatingSfxPointers
	add hl, bc
	add hl, bc
	ld a, [hli]
	ld c, [hl]
	call PlayMusic
	jp PlayDefaultMusic

PokedexRatingSfxPointers: ; 7d162 (1f:5162)
	db RBSFX_1f_51, BANK(SFX_1f_51)
	db RBSFX_02_41, BANK(SFX_02_41)
	db RBSFX_02_3a, BANK(SFX_02_3a)
	db RBSFX_08_46, BANK(SFX_08_46)
	db RBSFX_08_3a, BANK(SFX_08_3a)
	db RBSFX_02_42, BANK(SFX_02_42)
	db RBSFX_02_3b, BANK(SFX_02_3b)

OwnedMonValues: ; 7d170 (1f:5170)
	db 10, 40, 60, 90, 120, 150, $ff

; crystal:
    
SECTION "Audio Engine 1", ROMX, BANK[AUDIO_1]


INCLUDE "crysaudio/engine.asm"

; What music plays when a trainer notices you
;INCLUDE "crysaudio/trainer_encounters.asm"

MusicMT:
INCLUDE "crysaudio/music_pointers_music_test.asm"

Music:
INCLUDE "crysaudio/red_pointers.asm"
;INCLUDE "crysaudio/music_pointers.asm"

Music2:
INCLUDE "crysaudio/music_pointers2.asm"


INCLUDE "crysaudio/music/nothing.asm"

Cries:
INCLUDE "crysaudio/cry_pointers.asm"

;SFX:
INCLUDE "crysaudio/rbsfx.asm"


SECTION "Songs 1", ROMX

INCLUDE "crysaudio/music/route36.asm"
INCLUDE "crysaudio/music/rivalbattle.asm"
INCLUDE "crysaudio/music/rocketbattle.asm"
INCLUDE "crysaudio/music/elmslab.asm"
INCLUDE "crysaudio/music/darkcave.asm"
INCLUDE "crysaudio/music/johtogymbattle.asm"
INCLUDE "crysaudio/music/championbattle.asm"
INCLUDE "crysaudio/music/ssaqua.asm"
INCLUDE "crysaudio/music/newbarktown.asm"
INCLUDE "crysaudio/music/goldenrodcity.asm"
INCLUDE "crysaudio/music/vermilioncity.asm"
INCLUDE "crysaudio/music/titlescreen.asm"
INCLUDE "crysaudio/music/ruinsofalphinterior.asm"
INCLUDE "crysaudio/music/lookpokemaniac.asm"
INCLUDE "crysaudio/music/trainervictory.asm"


SECTION "Songs 2", ROMX

INCLUDE "crysaudio/music/route1.asm"
INCLUDE "crysaudio/music/route3.asm"
INCLUDE "crysaudio/music/route12.asm"
INCLUDE "crysaudio/music/kantogymbattle.asm"
INCLUDE "crysaudio/music/kantowildbattle.asm"
INCLUDE "crysaudio/music/pokemoncenter.asm"
INCLUDE "crysaudio/music/looklass.asm"
INCLUDE "crysaudio/music/lookofficer.asm"
INCLUDE "crysaudio/music/route2.asm"
INCLUDE "crysaudio/music/mtmoon.asm"
INCLUDE "crysaudio/music/showmearound.asm"
INCLUDE "crysaudio/music/gamecorner.asm"
INCLUDE "crysaudio/music/bicycle.asm"
INCLUDE "crysaudio/music/looksage.asm"
INCLUDE "crysaudio/music/pokemonchannel.asm"
INCLUDE "crysaudio/music/lighthouse.asm"
INCLUDE "crysaudio/music/lakeofrage.asm"
INCLUDE "crysaudio/music/indigoplateau.asm"
INCLUDE "crysaudio/music/route37.asm"
INCLUDE "crysaudio/music/rockethideout.asm"
INCLUDE "crysaudio/music/dragonsden.asm"
INCLUDE "crysaudio/music/ruinsofalphradio.asm"
INCLUDE "crysaudio/music/lookbeauty.asm"
INCLUDE "crysaudio/music/route26.asm"
INCLUDE "crysaudio/music/ecruteakcity.asm"
INCLUDE "crysaudio/music/lakeofragerocketradio.asm"
INCLUDE "crysaudio/music/magnettrain.asm"
INCLUDE "crysaudio/music/lavendertown.asm"
INCLUDE "crysaudio/music/dancinghall.asm"
INCLUDE "crysaudio/music/contestresults.asm"
INCLUDE "crysaudio/music/route30.asm"


SECTION "Songs 3", ROMX

INCLUDE "crysaudio/music/violetcity.asm"
INCLUDE "crysaudio/music/route29.asm"
INCLUDE "crysaudio/music/halloffame.asm"
INCLUDE "crysaudio/music/healpokemon.asm"
INCLUDE "crysaudio/music/evolution.asm"
INCLUDE "crysaudio/music/printer.asm"


SECTION "Songs 4", ROMX

INCLUDE "crysaudio/music/viridiancity.asm"
INCLUDE "crysaudio/music/celadoncity.asm"
INCLUDE "crysaudio/music/wildpokemonvictory.asm"
INCLUDE "crysaudio/music/successfulcapture.asm"
INCLUDE "crysaudio/music/gymleadervictory.asm"
INCLUDE "crysaudio/music/mtmoonsquare.asm"
INCLUDE "crysaudio/music/gym.asm"
INCLUDE "crysaudio/music/pallettown.asm"
INCLUDE "crysaudio/music/profoakspokemontalk.asm"
INCLUDE "crysaudio/music/profoak.asm"
INCLUDE "crysaudio/music/lookrival.asm"
INCLUDE "crysaudio/music/aftertherivalfight.asm"
INCLUDE "crysaudio/music/surf.asm"
INCLUDE "crysaudio/music/nationalpark.asm"
INCLUDE "crysaudio/music/azaleatown.asm"
INCLUDE "crysaudio/music/cherrygrovecity.asm"
INCLUDE "crysaudio/music/unioncave.asm"
INCLUDE "crysaudio/music/johtowildbattle.asm"
INCLUDE "crysaudio/music/johtowildbattlenight.asm"
INCLUDE "crysaudio/music/johtotrainerbattle.asm"
INCLUDE "crysaudio/music/lookyoungster.asm"
INCLUDE "crysaudio/music/tintower.asm"
INCLUDE "crysaudio/music/sprouttower.asm"
INCLUDE "crysaudio/music/burnedtower.asm"
INCLUDE "crysaudio/music/mom.asm"
INCLUDE "crysaudio/music/victoryroad.asm"
INCLUDE "crysaudio/music/pokemonlullaby.asm"
INCLUDE "crysaudio/music/pokemonmarch.asm"
INCLUDE "crysaudio/music/goldsilveropening.asm"
INCLUDE "crysaudio/music/goldsilveropening2.asm"
INCLUDE "crysaudio/music/lookhiker.asm"
INCLUDE "crysaudio/music/lookrocket.asm"
INCLUDE "crysaudio/music/rockettheme.asm"
INCLUDE "crysaudio/music/mainmenu.asm"
INCLUDE "crysaudio/music/lookkimonogirl.asm"
INCLUDE "crysaudio/music/pokeflutechannel.asm"
INCLUDE "crysaudio/music/bugcatchingcontest.asm"


SECTION "Songs 5", ROMX

INCLUDE "crysaudio/music/mobileadaptermenu.asm"
INCLUDE "crysaudio/music/buenaspassword.asm"
INCLUDE "crysaudio/music/lookmysticalman.asm"
INCLUDE "crysaudio/music/crystalopening.asm"
INCLUDE "crysaudio/music/battletowertheme.asm"
INCLUDE "crysaudio/music/suicunebattle.asm"
INCLUDE "crysaudio/music/battletowerlobby.asm"
INCLUDE "crysaudio/music/mobilecenter.asm"
INCLUDE "crysaudio/music/kantotrainerbattle.asm"


SECTION "Extra Songs 1", ROMX

INCLUDE "crysaudio/music/credits.asm"
INCLUDE "crysaudio/music/clair.asm"
INCLUDE "crysaudio/music/mobileadapter.asm"

SECTION "Extra Songs 2", ROMX

INCLUDE "crysaudio/music/postcredits.asm"


SECTION "RBY Songs 1", ROMX

INCLUDE "crysaudio/music/RBY/bikeriding.asm"
INCLUDE "crysaudio/music/RBY/dungeon1.asm"
INCLUDE "crysaudio/music/RBY/gamecorner.asm"
INCLUDE "crysaudio/music/RBY/titlescreen.asm"
INCLUDE "crysaudio/music/RBY/dungeon2.asm"
INCLUDE "crysaudio/music/RBY/dungeon3.asm"
INCLUDE "crysaudio/music/RBY/cinnabarmansion.asm"
INCLUDE "crysaudio/music/RBY/oakslab.asm"
INCLUDE "crysaudio/music/RBY/pokemontower.asm"
INCLUDE "crysaudio/music/RBY/silphco.asm"
INCLUDE "crysaudio/music/RBY/meeteviltrainer.asm"
INCLUDE "crysaudio/music/RBY/meetfemaletrainer.asm"
INCLUDE "crysaudio/music/RBY/meetmaletrainer.asm"
INCLUDE "crysaudio/music/RBY/introbattle.asm"
INCLUDE "crysaudio/music/RBY/surfing.asm"
INCLUDE "crysaudio/music/RBY/jigglypuffsong.asm"
INCLUDE "crysaudio/music/RBY/halloffame.asm"
INCLUDE "crysaudio/music/RBY/credits.asm"
INCLUDE "crysaudio/music/RBY/gymleaderbattle.asm"
INCLUDE "crysaudio/music/RBY/trainerbattle.asm"
INCLUDE "crysaudio/music/RBY/wildbattle.asm"
INCLUDE "crysaudio/music/RBY/finalbattle.asm"

SECTION "RBY Songs 2", ROMX

INCLUDE "crysaudio/music/RBY/defeatedtrainer.asm"
INCLUDE "crysaudio/music/RBY/defeatedwildmon.asm"
INCLUDE "crysaudio/music/RBY/defeatedgymleader.asm"
INCLUDE "crysaudio/music/RBY/pkmnhealed.asm"
INCLUDE "crysaudio/music/RBY/routes1.asm"
INCLUDE "crysaudio/music/RBY/routes2.asm"
INCLUDE "crysaudio/music/RBY/routes3.asm"
INCLUDE "crysaudio/music/RBY/routes4.asm"
INCLUDE "crysaudio/music/RBY/indigoplateau.asm"
INCLUDE "crysaudio/music/RBY/pallettown.asm"
INCLUDE "crysaudio/music/RBY/unusedsong.asm"
INCLUDE "crysaudio/music/RBY/cities1.asm"
INCLUDE "crysaudio/music/RBY/museumguy.asm"
INCLUDE "crysaudio/music/RBY/meetprofoak.asm"
INCLUDE "crysaudio/music/RBY/meetrival.asm"
INCLUDE "crysaudio/music/RBY/ssanne.asm"
INCLUDE "crysaudio/music/RBY/cities2.asm"
INCLUDE "crysaudio/music/RBY/celadon.asm"
INCLUDE "crysaudio/music/RBY/cinnabar.asm"
INCLUDE "crysaudio/music/RBY/vermilion.asm"
INCLUDE "crysaudio/music/RBY/lavender.asm"
INCLUDE "crysaudio/music/RBY/safarizone.asm"
INCLUDE "crysaudio/music/RBY/gym.asm"
INCLUDE "crysaudio/music/RBY/pokecenter.asm"
INCLUDE "crysaudio/music/RBY/yellowintro.asm"
INCLUDE "crysaudio/music/RBY/surfingpikachu.asm"
INCLUDE "crysaudio/music/RBY/meetjessiejames.asm"
INCLUDE "crysaudio/music/RBY/yellowunusedsong.asm"

SECTION "Custom Songs 1", ROMX

INCLUDE "crysaudio/music/custom/johtoGSC.asm"
INCLUDE "crysaudio/music/custom/ceruleanGSC.asm"
INCLUDE "crysaudio/music/custom/cinnabarGSC.asm"
INCLUDE "crysaudio/music/custom/nuggetbridge.asm"
INCLUDE "crysaudio/music/custom/shop.asm"
INCLUDE "crysaudio/music/custom/pokeathelonfinal.asm"

SECTION "Custom Songs 2", ROMX

INCLUDE "crysaudio/music/custom/naljowildbattle.asm"
INCLUDE "crysaudio/music/custom/naljogymbattle.asm"
INCLUDE "crysaudio/music/custom/palletbattle.asm"
INCLUDE "crysaudio/music/custom/cinnabarremix.asm"
INCLUDE "crysaudio/music/custom/kantogymleaderremix.asm"

SECTION "DPPt Songs 1", ROMX

INCLUDE "crysaudio/music/DPPt/pokeradar.asm"
INCLUDE "crysaudio/music/DPPt/sinnohtrainer.asm"
INCLUDE "crysaudio/music/DPPt/sinnohwild.asm"
INCLUDE "crysaudio/music/DPPt/route206.asm"
INCLUDE "crysaudio/music/DPPt/jubilifecity.asm"

SECTION "TCG Songs 1", ROMX
INCLUDE "crysaudio/music/TCG/titlescreen.asm"
INCLUDE "crysaudio/music/TCG/dueltheme1.asm"
INCLUDE "crysaudio/music/TCG/dueltheme2.asm"
INCLUDE "crysaudio/music/TCG/dueltheme3.asm"
INCLUDE "crysaudio/music/TCG/pausemenu.asm"
INCLUDE "crysaudio/music/TCG/pcmainmenu.asm"
INCLUDE "crysaudio/music/TCG/deckmachine.asm"
INCLUDE "crysaudio/music/TCG/cardpop.asm"
INCLUDE "crysaudio/music/TCG/overworld.asm"
INCLUDE "crysaudio/music/TCG/pokemondome.asm"
INCLUDE "crysaudio/music/TCG/challengehall.asm"
INCLUDE "crysaudio/music/TCG/club1.asm"
INCLUDE "crysaudio/music/TCG/club2.asm"
INCLUDE "crysaudio/music/TCG/club3.asm"

SECTION "TCG Songs 2", ROMX
INCLUDE "crysaudio/music/TCG/ronald.asm"
INCLUDE "crysaudio/music/TCG/imakuni.asm"
INCLUDE "crysaudio/music/TCG/hallofhonor.asm"
INCLUDE "crysaudio/music/TCG/credits.asm"
INCLUDE "crysaudio/music/TCG/matchstart1.asm"
INCLUDE "crysaudio/music/TCG/matchstart2.asm"
INCLUDE "crysaudio/music/TCG/matchstart3.asm"
INCLUDE "crysaudio/music/TCG/matchvictory.asm"
INCLUDE "crysaudio/music/TCG/matchloss.asm"
INCLUDE "crysaudio/music/TCG/darkdiddly.asm"
INCLUDE "crysaudio/music/TCG/boosterpack.asm"
INCLUDE "crysaudio/music/TCG/medal.asm"

SECTION "TCG2 Songs 1", ROMX
INCLUDE "crysaudio/music/TCG2/titlescreen.asm"
INCLUDE "crysaudio/music/TCG2/herecomesgr.asm"
INCLUDE "crysaudio/music/TCG2/groverworld.asm"
INCLUDE "crysaudio/music/TCG2/fort1.asm"
INCLUDE "crysaudio/music/TCG2/fort2.asm"
INCLUDE "crysaudio/music/TCG2/fort3.asm"
INCLUDE "crysaudio/music/TCG2/fort4.asm"
INCLUDE "crysaudio/music/TCG2/grcastle.asm"
INCLUDE "crysaudio/music/TCG2/grchallengecup.asm"

SECTION "TCG2 Songs 2", ROMX
INCLUDE "crysaudio/music/TCG2/gamecorner.asm"
INCLUDE "crysaudio/music/TCG2/grblimp.asm"
INCLUDE "crysaudio/music/TCG2/grdueltheme1.asm"
INCLUDE "crysaudio/music/TCG2/grdueltheme2.asm"
INCLUDE "crysaudio/music/TCG2/grdueltheme3.asm"
INCLUDE "crysaudio/music/TCG2/ishihara.asm"

SECTION "TCG2 Songs 3", ROMX
INCLUDE "crysaudio/music/TCG2/imakuni2.asm"
INCLUDE "crysaudio/music/TCG2/credits.asm"
INCLUDE "crysaudio/music/TCG2/diddly1.asm"
INCLUDE "crysaudio/music/TCG2/diddly2.asm"
INCLUDE "crysaudio/music/TCG2/diddly3.asm"
INCLUDE "crysaudio/music/TCG2/diddly4.asm"
INCLUDE "crysaudio/music/TCG2/diddly5.asm"
INCLUDE "crysaudio/music/TCG2/diddly6.asm"

SECTION "Pinball Songs", ROMX
INCLUDE "crysaudio/music/pinball/redfield.asm"
INCLUDE "crysaudio/music/pinball/catchem_red.asm"
INCLUDE "crysaudio/music/pinball/hurryup_red.asm"
INCLUDE "crysaudio/music/pinball/pokedex.asm"
INCLUDE "crysaudio/music/pinball/gengarstage_gastly.asm"
INCLUDE "crysaudio/music/pinball/gengarstage_hauntergengar.asm" ; the two songs are interleaved
INCLUDE "crysaudio/music/pinball/bluefield.asm"
INCLUDE "crysaudio/music/pinball/catchem_blue.asm"
INCLUDE "crysaudio/music/pinball/hurryup_blue.asm"
INCLUDE "crysaudio/music/pinball/hiscorescreen.asm"
INCLUDE "crysaudio/music/pinball/gameover.asm"
INCLUDE "crysaudio/music/pinball/diglettstage_digletts.asm"
INCLUDE "crysaudio/music/pinball/diglettstage_dugtrio.asm"

SECTION "Pinball Songs 2", ROMX
INCLUDE "crysaudio/music/pinball/seelstage.asm"
INCLUDE "crysaudio/music/pinball/titlescreen.asm"
INCLUDE "crysaudio/music/pinball/mewtwostage.asm"
INCLUDE "crysaudio/music/pinball/options.asm"
INCLUDE "crysaudio/music/pinball/fieldselect.asm"
INCLUDE "crysaudio/music/pinball/meowthstage.asm"
INCLUDE "crysaudio/music/pinball/endcredits.asm"
INCLUDE "crysaudio/music/pinball/nameentry.asm"

SECTION "Sound Effects", ROMX

INCLUDE "crysaudio/sfx.asm"


SECTION "Crystal Sound Effects", ROMX

INCLUDE "crysaudio/sfx_crystal.asm"



SECTION "Cries", ROMX

CryHeaders:: INCLUDE "crysaudio/cry_headers.asm"

INCLUDE "crysaudio/cries.asm"



