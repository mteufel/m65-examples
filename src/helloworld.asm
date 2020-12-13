!cpu m65
!to "./build/helloworld.prg", cbm
!src "src/includes/m65macros.asm"

            +basicStarter

            *=$2020
            sei

            lda #$35
            sta $01
            
            +mapMemory
        
            jsr printtext
            rts


printtext   ldx #$00
loop        lda .string,x
            beq exit
            sta $0800,x
            inx
            jmp loop
exit        rts

.string     !scr "Hello World", 0
