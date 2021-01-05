!cpu m65
!to "./build/02_multicolor-bitmap.prg", cbm
!src "./src/includes/m65-macros.asm"
!src "./src/includes/bitmap-macros.asm"

        ; ************************************************************************************************
        ;                                                                                               
        ;   multicolor.asm                                                                               
        ;                                                                                                
        ;   brings grafics designed with "Just Pixel" to the screen                              
        ;   in the sub-folder "grafics" are some sample multi color bitmaps which can be shown
        ;
        ;   In this example the default color palette is replaced with a better one by putting new RGB-Values
        ;   to the registers $D100,$D200,$D300 (see simple/03_color.asm for more details on how to calculate the RGB values)
        ;
        ;                                                                                                
        ;   ./build.sh mcm 02_multicolor-bitmap                                                                                                                                                           *        
        ;                                                                                               
        ; ************************************************************************************************

ZP_HELP_ADR               = $fb
VIC_BITMAP_ADR            = $6000
VIC_SCREEN_RAM            = $4800


;!bin "table", 2, 9 ; insert 2 bytes from offset 9

        +basicStarter

        ; Just Pixel exports a file with following structure
        ;  0000-1F3F Bitmap data
        ;  1F40-2327 Colors in Screen RAM
        ;  2328-270F Colors for Color RAM $D8000
        ;  2F10      background color
        ;  2F11      mode  (0=hires,1=mcm)        

        
        *=$6000
        !bin "./src/mcm/grafics/f.bin", 8000,0       ; puts the bitmap data directly to $6000
        *=$4800
        !bin "./src/mcm/grafics/f.bin", 1000,8000    ; puts the colors in screen ram directly to $4800
        *=$8000
        !bin "./src/mcm/grafics/f.bin", 1050,9000    ; puts the color ram data to $8000, will be copied to $d800 later


        ;*=$6000
        ;!bin "./src/mcm/grafics/block-3color.bin", 8000,0       ; puts the bitmap data directly to $6000
        ;*=$4800
        ;!bin "./src/mcm/grafics/block-3color.bin", 1000,8000    ; puts the colors in screen ram directly to $4800
        ;*=$8000
        ;!bin "./src/mcm/grafics/block-3color.bin", 1050,9000    ; puts the color ram data to $8000, will be copied to $d800 later


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

        ; set Color Palette to my individual palette
        ;lda #$24
        ;sta $d100+9
        ;lda #$93
        ;sta $d200+9
        ;lda #$00
        ;sta $d300+9

        ; Copy the Color-RAM Data
        ldx #$00
.loop   lda $8000,x               
        sta $d800,x                    
        dex                            
        bne .loop              

        ; Set Background color
        lda #$00
        sta $d021

        ; activate a custom color palette (the MEGA65 16 default colors I dont like)
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