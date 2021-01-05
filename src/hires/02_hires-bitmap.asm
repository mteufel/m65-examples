!cpu m65
!to "./build/02_hires-bitmap.prg", cbm
!src "./src/includes/m65-macros.asm"
!src "./src/includes/bitmap-macros.asm"

        ; ************************************************************************************************
        ;                                                                                                
        ;                                                                                                
        ;   This examples show how to load a picture painted and downloaded with "Just Pixel"            
        ;   This program is meant to be run on a MEGA65 in 65 Mode!                                      
        ;  
        ;   In the sub folder "grafics" there are some more grafics you can try out
        ;
        ;   In this example the default color palette is replaced with a better one by putting new RGB-Values
        ;   to the registers $D100,$D200,$D300 (see simple/03_color.asm for more details on how to calculate the RGB values)
        ;
        ;                                                                                                
        ;   ./build.sh hires 02_hires_bitmap                      
        ;                                                                                                       
        ; ************************************************************************************************

ZP_HELP_ADR               = $fb
VIC_BITMAP_ADR            = $6000
VIC_SCREEN_RAM            = $4800

        +basicStarter

        ; --- Shows a colorful start of an 'M' ---

        ;*=$6000
        ;!bin "./src/hires/grafics/pixels-bitmap.bin"  
        ;*=$4800
        ;!bin "./src/hires/grafics/pixels-colors.bin"  

        ; --- A nice pixeled block ---

        *=$6000
        !bin "./src/hires/grafics/block.bin", 8000,0       ; puts the bitmap data directly to $6000
        *=$4800
        !bin "./src/hires/grafics/block.bin", 1000,8000    ; puts the colors in screen ram directly to $4800

        ; --- Test for screen edges ---
        
        ;*=$6000
        ;!bin "./src/hires/grafics/screentest.bin", 8000,0       ; puts the bitmap data directly to $6000
        ;*=$4800
        ;!bin "./src/hires/grafics/screentest.bin", 1000,8000    ; puts the colors in screen ram directly to $4800


        ; =================================================================================================
        ; Start
        ; =================================================================================================
        *=$2020

        ;sei           

        +enableVicIV

        +bankInIo
        +blackScreen
        +activate640x200
        +activateBitmapMode
        +switchVicBank1                     
        +setStartOfBitmapAndScreenRam

        ldx #$00
.la     lda $9500,x
        sta $d100,x
        lda $9510,x
        sta $d200,x
        lda $9520,x
        sta $d300,x
        inx
        cpx #$0f
        bne .la


        jmp *


        *=$9500
        ; R
        !byte $0,$ef,$86,$7,$e6,$85,$43,$8b,$e6,$24,$a9,$44,$c6,$a9,$c6,$49
        ; G
        !byte $0,$ff,$73,$4a,$d3,$58,$82,$7c,$f4,$93,$76,$44,$c6,$2d,$e5,$59
        ; B
        !byte $0,$ff,$b2,$2b,$68,$34,$97,$f6,$52,$00,$95,$44,$c6,$48,$5b,$59     