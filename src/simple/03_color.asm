!cpu m65
!to "./build/03_color.prg", cbm
!src "./src/includes/m65-macros.asm"

        ; ************************************************************************************************
        ;                                                                                                
        ;   color.asm                                                                                    
        ;                                                                                                
        ;   This program show how you can manipalette the default colors. First it set's the border color 
        ;   to red and then id modifies the red to completely different different RGB-Value (brown)                
        ;
        ;   Calculating from a HTML-Hexcode to the correct Mega65 RGB-Values is a bit tricky because you have
        ;   to swap the nibbles and mask out a bit from the R-Value. 
        ;   Here's some JavaScript to show how to calculate the values:
        ;
        ;              const maskBit = (value, bit) => value & ~(1<<bit);
        ;              const swapNibbles = (value) => {
        ;                   return ( (value & 0x0F) << 4 | (value & 0xF0) >> 4 )
        ;              }
        ;              const colorMega65 = (color) => {
        ;                 let result = { r: 0, g: 0, b: 0}
        ;                 result.r = maskBit(color.r,0)
        ;                 result.r = swapNibbles(result.r)
        ;                 result.g = swapNibbles(color.g)
        ;                 result.b = swapNibbles(color.b)
        ;                 return result
        ;              }
        ;                                                                                                 
        ;   ./build.sh simple 03_color
        ;                                                                                               
        ; ************************************************************************************************
        
        +basicStarter

        *=$2020
        sei
       
        +bankInIo
        +enableVicIV
        

        lda #$02
        sta $d020

        lda #$24
        sta $d100+2
        lda #$93
        sta $d200+2
        lda #$00
        sta $d300+2


        rts
