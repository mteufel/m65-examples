!macro basicStarter {
    
    *=$2001
    !word +
    !word 2020
    !byte $fe,$02
    !text "0:"
    !byte $9e
    !text "8224"
    !byte 0
+   !word 0


}

!macro mapMemory {

	lda #$00
	tax 
	tay 
	taz 
	map
	eom

}

!macro enableVicII {

    +mapMemory

    ; Enable VIC II  (user guide page 681)
	lda #$00	
	sta $d02f
	lda #$00
	sta $d02f

}

!macro enableVicIV {

    +mapMemory

    ; Enable VIC IV  (user guide page 681)
	lda #$47	
	sta $d02f
	lda #$53
	sta $d02f

}

!macro bankInIo {
	; --------------------------------------------------------------------------------------------------
    ; Bank IO in via C64 mechanism (user guide page 456)
    ; --------------------------------------------------------------------------------------------------
    lda #$35
    sta $01
}

!macro blackScreen {
	lda #$00
	sta $d020
	sta $d021
}