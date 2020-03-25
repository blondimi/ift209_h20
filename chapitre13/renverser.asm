dir:      .rs 1 ; vaut 0 (gauche) ou 1 (droite)
tuile:    .rs 4 ; (posY, identifiant, attributs, posX)

renverser:                       ; renverser()
    lda   dir                    ; {
    cmp   #0                     ;
    ldx   #2                     ;
    lda   tuile, x               ;
    bne   renverser_un           ;   if (dir == 0)
renverser_zero:                  ;   {
    and   #%10111111             ;     a = tuile[2] & 0xBF
    jmp   renverser_fin          ;   }
renverser_un:                    ;   else
    ora   #%01000000             ;     a = tuile[2] | 0x40
renverser_fin:                   ;
    sta   tuile, x               ;   tuile[2] = a
    rts                          ; }
