!cpu m65
!to "./build/04_map.prg", cbm
!src "./src/includes/m65-macros.asm"

        ; ************************************************************************************************
        ;                                                                                                
        ;   map.asm                                                                                    
        ;                                                                                                
        ;   Demonstrates how to map memory by maping the default IO Personalitity $D000 to $6000.
        ;   So that in the end, you are able to change the border color by setting the color at $6020 (instead of $D020).
        ;   This example does not make sense, I know, but it shows the mechanics to do the mapping and even mor important
        ;   how to calculate the Offsets and the values you have to stick into the registers.
        ;   
        ;   A detailed description about the calculation you will find after the example source code in this file.
        ;                                                                                                 
        ;   ./build.sh simple 04_map
        ;                                                                                               
        ; ************************************************************************************************

            +basicStarter

            *=$2020
            sei

            lda #$ff
            ldx #$0f
            ldy #$00
            ldz #$00
            map
            eom

            lda #$d0
            ldx #$8c
            ldy #$00
            ldz #$00
            map
            eom

            lda #$04
            sta $6020

            jsr printtext
            rts


; Exampel to loop through bytes
printtext   ldx #$00
loop        lda .string,x
            beq exit
            sta $0800,x
            inx
            jmp loop
exit        rts

.string     !scr "the border color was changed via 6020 not d020!!!!", 0


; How to fill the Registers in simple steps:
;
; -------------------------------------------------------------------------------------------------------------
; Map $FFD3000 - $FFD3FFF to $6000
; Remember: The $D000 IO Personality in reality is at $FFD3000
; see also in the User Guide, VI Appendices, System Memory Map, MEGA65 Native Memory Map , 28-bit-Adresses
; -------------------------------------------------------------------------------------------------------------
;
; (1)  As $D000 begins at $FFD3000 first thing is cut off the prefix "$FF". $FFD3000 --> $D3000
;
; (2)  Calculate a offset, this is done by Substracting the Result of Step (1) minus the start adress you want to map it to.
;      $D3000-$6000 = CD000
;
; (3)  Convert the result "CD000" into bits and split it in 5 groups (for better understanding):

;
;      Group                      5      |       4     |      3    |    2    |    1
;      Bit number            19 18 17 16 | 15 14 13 12 | 11 10 9 8 | 7 6 5 4 | 3 2 1 0
;                            ------------+-------------+-----------+---------+--------
;      Value                 1   1  0  0 | 1   1  0  1 |  0  0 0 0 | 0 0 0 0 | 0 0 0 0 
;
;      Bits 8-15 or groups 3 and 4 are needed to calculate the value for the A-Register
;      Bits 16-19 and "a memory lookup table" are needed to define the values for the X-Register
;
; (4) Caluculate A-Register:
;     
;     Bits 8-15 are the two nibbles you need. Just take the value of the nibbles, concatenate them and you have the value for the A-Register
;    
;      Group 4 | Group 3        Group 4 | Group 3
;      1 1 0 1 | 0 0 0 0   ==>    D     |    0            ==>    #$D0    == LDA #$D0
;
; (5) Calculate the X-Register:
;     This is more complicated, the X-Register Low-Value (first nibble) is calculated the same as in step(4) only with bits 16-19:
;     
;     (a) Low Value:
;
;      Group 5       Group 5 
;      1 1 0 0   ==>    C    
;
;     (b) High Value
;
;     For the X-Register High-Value you need to look into a "memory lookup table" which looks like this:
;
;      Register | Bit | Block | Area
;     ----------+-----+-------+--------   
;          Y    |  3  | BLK7  | $FFFF
;          Y    |  2  | BLK6  | $E000
;          Y    |  1  | BLK5  | $A000
;          Y    |  0  | BLK4  | $8000
;     =========+=====+=======+========
;  +---    X    |  3  | BLK3  | $6000
;  |       X    |  2  | BLK2  | $4000
;  |       X    |  1  | BLK1  | $2000
;  |       X    |  0  | BLK0  | $0000
;  |
;  |    Okay, we want to map to $6000, that means the we have look into the table for $6000. Ah yes, this is in the group for the 
;  |    X-Register and to activate $6000 i need to set Bit 3! Easy, peasy:
;  |
;  |     Bit    3 2 1 0
;  +-->  Value  1 0 0 0        ==> 8  
;
;   If you put (a) and (b) togther you get the final value for X-Register ==> #$8C    ==> LDX #$8C
;
;
;  That's all, compare these steps and results of the steps with the values used in the example above.
;


