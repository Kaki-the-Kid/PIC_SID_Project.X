
  .org $07ff         ;Two bytes earlier to make room for loading address.
  .word $0801        ;Loading address
;Assume that our code can be placed at 0xb800, 47104

;basic end:
  .byte $0c,$08
;row number:
  .byte $b6,$07
;sys
  .byte $9e
;where
  .byte $34,$39,$31,$35,$32
;end:
  .byte $0,$0,$0

packedStart:
  .incbin "packed.prg"
packedEnd:

.RES $c000-*,$00
  sei
;ever2:
;  inc $d020
;  jmp ever2
  lda #$36
  sta $01
  lda #$0
  sta $d020
  sta $d021
  ldx #0
  lda #$0
clrCol: 
  sta $d828,x
  sta $d900,x
  sta $da00,x
  sta $db00,x
  dex
  bne clrCol
  ldx #$27
  lda #$e
clrCol2:  
  sta $d800,x
  dex
  bpl clrCol2

;assume that screen is at $0400
  lda #$15    ;Screen at $0400, charset at $e000-
  sta $d018
  lda $DD00
  and #%11111100
  ora #%00000011 ;choose $0000-$3fff bank3
  sta $DD00





; Time to move the packed data back into $0801


  ldx #$00
mover:
  lda packedStart+2,x
mover2:
  sta $0801,x
  inx
  bne mover
  inc mover+2
  inc mover2+2
  lda mover+2
  cmp #$bf
  bne mover

;Need to set basic end, I guess...
  lda #<(packedEnd-packedStart+$07ff)
  sta $2d
;  sta $2f
;  sta $31
;  sta $ae
  lda #>(packedEnd-packedStart+$07ff)
  sta $2e
;  sta $30
;  sta $32
;  sta $af

  jmp $080d

