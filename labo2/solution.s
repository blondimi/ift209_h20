.global main

/*******************************************************************************
  Programme qui calcule la somme et le produit de deux entiers de 16 bits

  Usage des registres:
     w19 - a (1er nombre)      x22 - acc  (accumulateur)
     w20 - b (2e  nombre)      x23 - i    (compteur)
     w21 - c (somme)           x28 - variable temporaire
*******************************************************************************/
main:                                   // int main()
    // Lire entier a de 16 bits         // {
    adr     x0, fmtEntree               //
    adr     x1, temp                    //
    bl      scanf                       //   scanf("%hd", &temp)
    adr     x28, temp                   //
    ldrsh   w19, [x28]                  //   int16 a = temp
                                        //
    // Lire entier b de 16 bits         //
    adr     x0, fmtEntree               //
    adr     x1, temp                    //
    bl      scanf                       //   scanf("%hd", &temp)
    adr     x28, temp                   //
    ldrsh   w20, [x28]                  //   int16 b = temp
                                        //
    // Calculer et afficher a + b       //
    // en arithmétique de 32 bits       //
addition:                               //
    add     w21, w19, w20               //   int32 c = a + b
                                        //
    adr     x0, fmtSortie               //
    mov     w1, w21                     //
    bl      printf                      //   printf("%d\n", c)
                                        //
    // Afficher si a + b aurait produit //
    // un débordement sur 16 bits       //
debordement:                            //
    cmp     w21, 32768                  //
    b.ge    debordement_sinon           //   if !(c >= 2¹⁶ ||
    cmp     w21, -32768                 //        c < -2¹⁶)
    b.lt    debordement_sinon           //   {
    adr     x0, msgSansDebordement      //     s = &msgSansDebordement
    b       debordement_afficher        //   }
debordement_sinon:                      //   else
    adr     x0, msgDebordement          //     s = &msgDebordement
debordement_afficher:                   //
    bl      printf                      //   printf(s)
                                        //
    // Calculer et afficher a * b       //
    // en arithmétique de 32 bits       //
produit:                                //
    mov     x28, 2                      //
    mov     x22, 0                      //   int64 acc = 0
    mov     x23, 0                      //
produit_boucle:                         //
    cmp     x23, 32                     //   for (i = 0; i < 32; i++)
    b.hs    produit_afficher            //   {
                                        //
    tbz     w20, 0, produit_bit_suivant //     if (bit poids faible de b == 1)
    add     x22, x22, x19               //       acc += a
produit_bit_suivant:                    //
    add     x19, x19, x19               //     décaler a à gauche (avec a *= 2)
    udiv    w20, w20, w28               //     décaler b à droite (avec b /= 2)
                                        //
    add     x23, x23, 1                 //
    b       produit_boucle              //   }
produit_afficher:                       //
    adr     x0, fmtSortie               //
    mov     w1, w22                     //
    bl      printf                      //   printf("%d\n", (int32)acc)
                                        //
    // Quitter le programme             //
    mov     x0, 0                       //   return 0
    bl      exit                        // }

// Données statiques
.section ".bss"
            .align  2
temp:       .skip   2                   // Variable temporaire d'un demi-mot

.section ".rodata"
fmtEntree:          .asciz  "%hd"
fmtSortie:          .asciz  "%d\n"
msgDebordement:     .asciz  "débordement\n"
msgSansDebordement: .asciz  "sans débordement\n"
