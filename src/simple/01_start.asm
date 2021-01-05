!cpu m65
!to "./build/01_start.prg", cbm
!src "./src/includes/m65-macros.asm"


        ; ************************************************************************************************
        ;                                                                                                
        ;   start.asm                                                                                    
        ;                                                                                                
        ;   You should start with this program, just to get your first little success...                    
        ;                                                                                                
        ;   ./build.sh simple 01_start
        ;                                                                                               
        ; ************************************************************************************************

        +basicStarter

        *=$2020
        sei
        lda #$35
        sta $01
        
        +enableVicIV

        ; Disable CIA and IRQ interrupts
        lda #$7f
        sta $dc0d
        sta $dd0d
        lda #$00
        sta $d01a

        cli


loop
        inc $d020
        jmp loop
