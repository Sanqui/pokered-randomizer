CaterpieBaseStats: ; 384da (e:44da)
db DEX_CATERPIE ; pokedex id
db 45 ; base hp
db 30 ; base attack
db 35 ; base defense
db 45 ; base speed
db 20 ; base special
db BUG ; species type 1
db BUG ; species type 2
db 255 ; catch rate
db 53 ; base exp yield
INCBIN "pic/bmon/caterpie.pic",0,1 ; 55, sprite dimensions
dw CaterpiePicFront
dw CaterpiePicBack
; attacks known at lvl 0
db TACKLE
db STRING_SHOT
db 0
db 0
db 0 ; growth rate
; learnset
db %00000000
db %00000000
db %00000000
db %00000000
db %00000000
db %00000000
db %00000000
db BANK(CaterpiePicFront)
