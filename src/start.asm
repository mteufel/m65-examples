!cpu m65
!to "./build/start.prg", cbm
!src "src/includes/m65macros.asm"

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
