.global     main

/*******************************************************************************
  Solution au labo 5
*******************************************************************************/
main:                                   // main()
    // Lire x                           // {
    adr     x0, fmtLecture              //
    adr     x1, temp                    //
    bl      scanf                       //   scanf("%lf", &temp)
    ldr     d8, temp                    //   x = temp
                                        //
    // Lire ε                           //
    adr     x0, fmtLecture              //
    adr     x1, temp                    //
    bl      scanf                       //   scanf("%lf", &temp)
    ldr     d9, temp                    //   ε = temp
                                        //
    // Calculer racine carrée de x      //
    fmov    d0, d8                      //
    fmov    d1, d9                      //
    bl      racine                      //
    fmov    d8, d0                      //   r = racine(x, ε)
                                        //
    // Afficher racine carrée           //
    adr     x0, fmtSortie               //
    fmov    d0, d8                      //
    bl      printf                      //   printf("%lf\n", r)
                                        //
    // Quitter programme                //
    mov     x0, 0                       //
    bl      exit                        //   return 0
                                        // }
/*******************************************************************************
  Entrée: nombres en virgule flottante double précision x ≥ 1 et 0 < ε < 1
  Sortie: √x approximée à une erreur absolue d'au plus ε
  Usage:  d0 - x      d16 - a (borne de gauche)      d19 - c² (var. temp.)
          d1 - ε      d17 - b (borne de droite)      d20 - erreur de [a, b]
                      d18 - c (point milieu)         d31 - 2.0 (constante)
*******************************************************************************/
racine:                                 // double racine(double x, double ε)
    fmov     d31, 2.0                   // {
    fmov     d16, 1.0                   //   a = 1
    fmov     d17, d0                    //   b = x
    fadd     d18, d16, d17              //
    fdiv     d18, d18, d31              //   c = (a + b) / 2
                                        //
racine_boucle:                          //
    fsub    d20, d17, d16               //
    fdiv    d20, d20, d31               //
    fcmp    d20, d1                     //   while ((b - a) / 2 > ε))
    b.le    racine_ret                  //   {
                                        //
    fmul    d19, d18, d18               //
    fcmp    d19, d0                     //
    b.ge    racine_geq                  //     if (c² < x) {
    fmov    d16, d18                    //       a = c
    b       racine_suiv                 //     }
racine_geq:                             //     else {
    fmov    d17, d18                    //       b = c
racine_suiv:                            //     }
    fadd    d18, d16, d17               //
    fdiv    d18, d18, d31               //     c = (a + b) / 2
    b       racine_boucle               //   }
racine_ret:                             //
    fmov    d0, d18                     //
    ret                                 //   return c
                                        // }

/* Remarque: j'utilise d16 – d31 plutôt que d8 – d15 afin de ne pas avoir
   à préserver les registres sur la pile. En effet, cela respecte la convention
   d'appel car ce serait à l'appelant (donc «main») de sauvegarder d16 – d31
   au besoin, et il n'a pas à le faire comme il n'utilise pas ces registres.  */

.section ".rodata"
fmtLecture: .asciz  "%lf"
fmtSortie:  .asciz  "%lf\n"

.section ".bss"
            .align  8
temp:       .skip   8
