!cpu m65
!to "./build/02_helloworld.prg", cbm
!src "./src/includes/m65-macros.asm"

        ; ************************************************************************************************
        ;                                                                                                
        ;   helloworld.asm                                                                                    
        ;                                                                                                
        ;   This program demonstrates how you can bring "hello world" to the screen (by calling the subroutine "printtext")                  
        ;   Also a very simple example for a loop is included (subroutine "printloop")
        ;                                                                                                 
        ;   ./build.sh simple 02_helloworld
        ;                                                                                               
        ; ************************************************************************************************


            +basicStarter

            *=$2020
            sei

            lda #$35
            sta $01
            
            +mapMemory
        
            jsr printtext
            ;jsr printloop
            rts

; Example to loop 5X
printloop   ldx #$00
            lda #$10
l           sta $0800,x
            inx
            cpx #$05
            bne l
            rts


; Example to loop through bytes
printtext   ldx #$00
loop        lda .string,x
            beq exit
            sta $0800,x
            inx
            jmp loop
exit        rts

.string     !scr "hello mega65 world", 0
