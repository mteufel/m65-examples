!cpu m65
!to "./build/01_multicolor.prg", cbm
!src "./src/includes/m65-macros.asm"
!src "./src/includes/bitmap-macros.asm"

        ; ************************************************************************************************
        ; *                                                                                              *
        ; * multicolor.asm                                                                               *
        ; *                                                                                              *
        ; * brings some mcm test-pixels to the screen (only the first char)                              *
        ; *                                                                                              *
        ; * ./build.sh mcm 01_multicolor                                                                    *                                                                                              *        
        ; *                                                                                              *
        ; ************************************************************************************************

ZP_HELP_ADR               = $fb
VIC_BITMAP_ADR            = $6000
VIC_SCREEN_RAM            = $4800

        +basicStarter

        ; =================================================================================================
        ; Start
        ; =================================================================================================
        *=$2020

        sei           

        +enableVicIV

        +bankInIo
        +blackScreen
        +activate320x200
        +activateBitmapMode
        +activateMulticolorMode
        +switchVicBank1                     
        +setStartOfBitmapAndScreenRam

        
        ; --------------------------------------------------------------------------------------------------
        ; Set some pixels to the first charachter
        ; --------------------------------------------------------------------------------------------------

        lda #0                         
        sta $d021                      ; background is black
        lda #%01001100                 ; purple (0100=4) and grey (1100=12)into 
        sta $4800                      ; screen ram
        lda #7                         ; yellow
        sta $D800                      ; into color ram

        ; set some pixels in the bitmap
        ; $E4 = %11100100   2 bits define one pixel on the screen, the bit combination defines where to take the color from
        ;                   00 = background color from $d021
        ;                   01 = upper 4 bits from screen ram
        ;                   10 = lower 4 bits from screen ram
        ;                   11 = color ram $d800+x

        *=$6000
        !byte $E4,$E4,$E4,$E4,$E4,$E4,$E4,$E4

        jmp *