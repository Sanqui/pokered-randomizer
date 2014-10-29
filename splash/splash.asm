
SECTION "splash",ROMX

SplashScreen::
    ld hl, SplashText
    ld de, $8800
    call PrintText
    ret

SplashText:
ascii "Hi, this is a test splash screen.  More text more text.  This should "
ascii "all render automatically, including newlines and stuff.  We'll see if "
ascii "the Game Boy can handle it!@"

INCLUDE "splash/vwf.asm"
