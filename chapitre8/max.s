.global main

.macro SAVE
  stp   x29, x30, [sp, -96]!
  mov   x29, sp
  stp   x27, x28, [sp, 16]
  stp   x25, x26, [sp, 32]
  stp   x23, x24, [sp, 48]
  stp   x21, x22, [sp, 64]
  stp   x19, x20, [sp, 80]
.endm

.macro RESTORE
  ldp   x27, x28, [sp, 16]
  ldp   x25, x26, [sp, 32]
  ldp   x23, x24, [sp, 48]
  ldp   x21, x22, [sp, 64]
  ldp   x19, x20, [sp, 80]
  ldp   x29, x30, [sp], 96
.endm

main:
        mov         x0, x19         // a   = x19
        mov         x1, x20         // b   = x20
        bl          max             // m   = max(a, b)
        mov         x21, x0         // x21 = m
                                    //
        mov         x0, 0           //
        bl          exit            //
                                    //
max:                                //
        SAVE                        //
        cmp         x0, x1          //
        b.lt        max_sinon       // if (a >= b) {
        mov         x19, x0         //   m = a
        b           max_retour      // }
max_sinon:                          // else {
        mov         x19, x1         //   m = b
max_retour:                         // }
        mov         x0, x19         //
        RESTORE                     //
        ret                         // return m
