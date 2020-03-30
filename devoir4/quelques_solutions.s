/** Opération 0 ******************/ //
taille:                             // taille(s)
    SAVE                            // {
    mov     x28, 0                  //   n = 0
taille_debut:                       //   i = 0
    ldrb    w19, [x0]               //
    cbz     w19, taille_fin         //   while (s[i] != 0)
                                    //   {
    // Caractère d'un octet         //
    mov     x20, 1                  //     k = 1
    tbz     w19, 7, taille_suiv     //     if (s[i] != 0*******₂)
                                    //     {
    // Caractère de ≥ 2 octets      //
    mov     w21, 0xE0               //       masque = 11100000₂
    mov     w22, 0xC0               //       format = 11000000₂
taille_cas:                         //       do {
    add     x20, x20, 1             //         k += 1
    and     w23, w19, w21           //         c = s[i] & masque1
    cmp     w23, w22                //
    b.eq    taille_suiv             //         if (c == format) { break }
                                    //
    orr     w21, w21, w21, lsr 1    //         masque = 10000000₂ | (masque >> 1)
    orr     w22, w22, w22, lsr 1    //         format = 10000000₂ | (format >> 1)
    cmp     x20, 4                  //       }
    b.lo    taille_cas              //       while (k < 4)
taille_suiv:                        //     }
    add     x28, x28, 1             //     n += k
    add     x0, x0, x20             //     i += k
    b       taille_debut            //   }
taille_fin:                         //
    mov     x0, x28                 //
    RESTORE                         //
    ret                             //   return n
                                    // }
/** Opération 3 (avec bonus) *****/ //
bin2int:                            // bin2int(x) {
    ldrb    w10, [x0, 2]!           //   i = 2
    lsl     x10, x10, 63            //   v = bit de signe de x
    asr     x10, x10, 63            //              répété 64 fois
bin2int_boucle:                     //   do {
    ldrb    w9, [x0, 1]!            //     c = x[++i]
    cbz     w9, bin2int_fin         //     if (c == 0) { break }
    and     x9, x9, 1               //
    orr     x10, x9, x10, lsl 1     //     v = (v << 1) | (c & 00000001₂)
    b       bin2int_boucle          //   }
bin2int_fin:                        //
    mov     x0, x10                 //
    ret                             //   return v
                                    // }
/** Opération 5 ******************/ //
perm:                               // perm(s)
    SAVE                            // {
    mov     x19, x0                 //
    bl      taille                  //
    mov     x2, x0                  //   n = taille(s)
    mov     x1, 0                   //
    mov     x0, x19                 //
    bl      perm_aux                //   perm_aux(s, 0, n)
    RESTORE                         //
    ret                             // }
                                    //
perm_aux:                           // perm_aux(s, i, n)
    SAVE                            // {
    mov     x19, x0                 //
    mov     x20, x1                 //
    mov     x28, x2                 //
                                    //
    // Reste lettre à choisir?      //
    cmp     x20, x28                //   if (i < n)
    b.hs    perm_aux_afficher       //   {
                                    //
    // Choisir lettre et            //
    //  compléter récursivement     //
    mov     x21, x20                //     for (j = i; j < n; j++)
perm_aux_boucle:                    //     {
    ldrb    w22, [x19, x20]         //
    ldrb    w23, [x19, x21]         //
    strb    w23, [x19, x20]         //
    strb    w22, [x19, x21]         //       s[i] ↔ s[j]
                                    //
    mov     x0, x19                 //
    add     x1, x20, 1              //
    mov     x2, x28                 //
    bl      perm_aux                //       perm_aux(s, i + 1, n)
                                    //
    strb    w22, [x19, x20]         //
    strb    w23, [x19, x21]         //       s[i] ↔ s[j]
                                    //
    add     x21, x21, 1             //
    cmp     x21, x28                //
    b.lo    perm_aux_boucle         //     }
    b       perm_aux_fin            //   }
perm_aux_afficher:                  //   else
    adr     x0, fmtStr              //   {
    mov     x1, x19                 //
    bl      printf                  //     printf("%s ", s)
perm_aux_fin:                       //   }
    RESTORE                         //
    ret                             // }
