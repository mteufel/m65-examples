!cpu m65
!to "./build/hires.prg", cbm
!src "src/includes/m65macros.asm"


ZP_HELP_ADR               = $fb
VIC_BITMAP_ADR            = $4000
VIC_SCREEN_RAM            = $4800

        +basicStarter

        ; =================================================================================================
        ; Start
        ; =================================================================================================
        *=$2020

        sei           

        +enableVicIV

        ; --------------------------------------------------------------------------------------------------
        ; Bank IO in via C64 mechanism (user guide page 456)
        ; --------------------------------------------------------------------------------------------------
        lda #$35
        sta $01

        lda #$00
        sta $d020
        sta $d021

        ; --------------------------------------------------------------------------------------------------
        ; Activate 320x200 / 640x400
        ; --------------------------------------------------------------------------------------------------
        lda $d031
        ;bit  76543210
        and #%00000000                  ; bit 7 (user guide page 709)  0=320x200 1=640x400     
        sta $d031

        ; --------------------------------------------------------------------------------------------------
        ; Switch to VIC Bank 1 $4000-$7FFF
        ; --------------------------------------------------------------------------------------------------
        lda #%00000011                     ;prepare write action to select bank
        sta $dd02 
        
        ; Bits | Bank| Memory Area
        ; -----+-----+----------------------------
        ; %00  |  3  | $C000-$FFFF
        ; %01  |  2  | $8000-$BFFF
        ; %10  |  1  | $4000-$7FFF
        ; %11  |  0  | $0000-$3FFF
 
        lda #%00000010                     ;select Bank #1 $4000-$7FFF
        sta $dd00                          ;

        ; --------------------------------------------------------------------------------------------------
        ;  Activate Bitmap Mode
        ; --------------------------------------------------------------------------------------------------
        lda $d011                          ;load VIC Register 17 (Hex 11) into the accu

        ;bit  76543210
        ora #%00100000                     ;and activate the bitmap modes with bit 5

        sta $d011                          ;activate by writing the modified value back to the register

        ; --------------------------------------------------------------------------------------------------
        ;  Select the start of the bitmap memory
        ; --------------------------------------------------------------------------------------------------
        
        
        ; the selected bank has 16kb and is divided into 2 8kb blocks
        ; bit 3 of $d018 defines which of the bitmap areas will be used

        ; Bit | # | Memory Area
        ; ----+---+----------------------------
        ;     |   | Bank 0             Bank 1           ...
        ; %0  | 0 | $0000-$1FFF        $4000-$5FFF
        ; %1  | 1 | $2000-$3FFF        $6000-$7FFF

        lda $d018                          ;load VIC Register 24 (Hex 18) into the accu
        ;bit  76543210
        and #%11110111                     ;storing 0 in bit 3 means the bitmap locates $4000-5FFFF
        ora #%00000000                      
        sta $d018           
        jsr clear
        

        ldx #7                             ;Schleifenzähler
        lda #$ff                           ;Pixelmuster
.loop
        sta VIC_BITMAP_ADR,X               ;Pixel ausgeben
        lsr                                ;Muster im Akku ändern
        dex                                ;Schleifenzähler verringern
        bpl .loop                          ;solange positiv nochmal -> .loop

        

        lda #$23
        sta VIC_SCREEN_RAM
        jmp *                           



; --------------------------------------------------------------------------
;  Clear screen
; --------------------------------------------------------------------------
!zone clear
clear
        lda #<VIC_BITMAP_ADR               ;auf die Zero-Page  --> das HIGHBYTE
        sta ZP_HELP_ADR       
        lda #>VIC_BITMAP_ADR               ;                   --> das LOWBYTE
        sta ZP_HELP_ADR+1
        
        ldx #32                            ;Schleifenzähler 32 Pages (32 * 256 = 8192 = 8KB)
        ldy #0                             ;Schleifenzähler für 256 BYTES je Page
        
        lda #$00                           ;Akku auf 0 setzen
.loop   sta (ZP_HELP_ADR),Y                ;Akku 'ausgeben'
        dey                                ;Y verringern
        bne .loop                          ;solange größer 0 nochmal -> .loop
        inc ZP_HELP_ADR+1                  ;Adresse auf der Zeropage um eine Page erhöhen
        dex                                ;Pagezähler verringern
        bne .loop                          ;solange größer 0 nochmal -> .loop
        rts  

!zone clear_hires_color
clear_hires_color
        ldx #0                             ;Schleifenzähler 256 BYTES
        lda #$00 
.loop   sta VIC_SCREEN_RAM,X               ;1. Page des Bildschirmspeichers
        sta VIC_SCREEN_RAM+256,X           ;2. Page
        sta VIC_SCREEN_RAM+512,X           ;3. Page
        sta VIC_SCREEN_RAM+768,X           ;4. Page
        dex                                ;Schleifenzähler verringern
        bne .loop                          ;solange nicht 0 nochmal -> .loop
        rts                                ;zurück zum Aufrufe