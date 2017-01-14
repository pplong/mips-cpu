##
## SIN
##
min_caml_sin:
  swcl  f0, r30, 0
  lw    r2, r30, 0
  srl   r3, r2, 31  # r3 = sign
  sll   r2, r2, 1
  srl   r2, r2, 1   # take abs
  sw    r2, r30, 0
  lwcl  f0, r30, 0
  move  r4, r31

  # reduction0
  jal   _trig_reduction
  lwclc f1, r0, _trig_PI
  fbgt  f1, f0, _sin_reduction2

  # reduction1
  fsub  f0, f0, f1
  addi  r3, r3, 1

_sin_reduction2:
  lwclc f2, r0, _trig_PI2
  fbgt  f2, f0, _sin_reduction3
  fsub  f0, f1, f0

_sin_reduction3:
  lwclc f3, r0, _trig_PI4
  fbgt  f0, f3, _sin_kernel_cos
  jal   _trig_kernel_sin
  j     _sin_done

_sin_kernel_cos:
  fsub  f0, f2, f0
  jal   _trig_kernel_cos

_sin_done:
  swcl  f0, r30, 0
  lw    r2, r30, 0
  sll   r3, r3, 31
  add   r2, r2, r3
  sw    r2, r30, 0
  lwcl  f0, r30, 0
  jr    r4

##
## COS
##
min_caml_cos:
  swcl  f0, r30, 0
  lw    r2, r30, 0
  sll   r2, r2, 1
  srl   r2, r2, 1  # take abs
  li    r3, 0      # r3 = sign
  sw    r2, r30, 0
  lwcl  f0, r30, 0
  move  r4, r31

  # reduction0
  jal   _trig_reduction
  lwclc f1, r0, _trig_PI
  fbgt  f1, f0, _cos_reduction2

  # reduction1
  fsub  f0, f0, f1
  addi  r3, r3, 1

_cos_reduction2:
  lwclc f2, r0, _trig_PI2
  fbgt  f2, f0, _cos_reduction3
  fsub  f0, f1, f0
  addi  r3, r3, 1

_cos_reduction3:
  lwclc f3, r0, _trig_PI4
  fbgt  f0, f3, _cos_kernel_sin
  jal   _trig_kernel_cos
  j     _cos_done

_cos_kernel_sin:
  fsub  f0, f2, f0
  jal   _trig_kernel_sin

_cos_done:
  swcl  f0, r30, 0
  lw    r2, r30, 0
  sll   r3, r3, 31
  add   r2, r2, r3
  sw    r2, r30, 0
  lwcl  f0, r30, 0
  jr    r4

##
## ATAN
##
min_caml_atan:
  swcl  f0, r30, 0
  lw    r2, r30, 0
  srl   r3, r2, 31  # r3 = sign
  sll   r2, r2, 1
  srl   r2, r2, 1
  sw    r2, r30, 0
  lwcl  f0, r30, 0  # take abs
  move  r4, r31

  lwclc f1, r0, _trig_0.4375
  fble  f1, f0, _atan_part2
  jal   _trig_kernel_atan
  j     _atan_done

_atan_part2:
  lwclc f1, r0, _trig_2.4375
  fble  f1, f0, _atan_part3
  lwclc f1, r0, _trig_1.0
  fadd  f2, f0, f1
  fsub  f3, f0, f1
  fdiv  f0, f3, f2
  jal   _trig_kernel_atan
  lwclc f1, r0, _trig_PI4
  fadd  f0, f0, f1
  j     _atan_done

_atan_part3:
  lwclc f1, r0, _trig_1.0
  fdiv  f0, f1, f0
  jal   _trig_kernel_atan
  lwclc f1, r0, _trig_PI2
  fsub  f0, f1, f0

_atan_done:
  swcl  f0, r30, 0
  lw    r2, r30, 0
  sll   r3, r3, 31
  add   r2, r2, r3
  sw    r2, r30, 0
  lwcl  f0, r30, 0
  jr    r4  

##
## reduction
##
_trig_reduction:
  lwclc f5, r0, _trig_2PI
  fmov  f6, f5  # f6 = p
  lwclc f7, r0, _trig_2.0

_reduction_init:
  fbgt  f6, f0, _reduction_main
  fmul  f6, f6, f7
  j     _reduction_init

_reduction_main:
  fbgt  f5, f0, _reduction_done
  fbgt  f6, f0, _reduction_next
  fsub  f0, f0, f6
_reduction_next:
  fdiv  f6, f6, f7
  j     _reduction_main

_reduction_done:
  jr    r31

##
## kernel_sin
##
_trig_kernel_sin:
  fmul  f5, f0, f0
  fmov  f6, f0

  lwclc f7, r0, _trig_S7
  fmul  f0, f7, f5
  lwclc f7, r0, _trig_S5
  fadd  f0, f0, f7
  fmul  f0, f0, f5
  lwclc f7, r0, _trig_S3
  fadd  f0, f0, f7
  fmul  f0, f0, f5
  lwclc f7, r0, _trig_1.0
  fadd  f0, f0, f7
  fmul  f0, f0, f6
  jr    r31

##
## kerlenl_cos
##
_trig_kernel_cos:
  fmul  f5, f0, f0

  lwclc f6, r0, _trig_C6
  fmul  f0, f5, f6
  lwclc f6, r0, _trig_C4
  fadd  f0, f0, f6
  fmul  f0, f0, f5
  lwclc f6, r0, _trig_C2
  fadd  f0, f0, f6
  fmul  f0, f0, f5
  lwclc f6, r0, _trig_C0
  fadd  f0, f0, f6
  jr    r31

##
## kernel_atan
##
_trig_kernel_atan:
  fmul  f5, f0, f0
  fmov  f6, f0

  lwclc f7, r0, _trig_A13
  fmul  f0, f5, f7
  lwclc f7, r0, _trig_A11
  fadd  f0, f0, f7
  fmul  f0, f0, f5
  lwclc f7, r0, _trig_A9
  fadd  f0, f0, f7
  fmul  f0, f0, f5
  lwclc f7, r0, _trig_A7
  fadd  f0, f0, f7
  fmul  f0, f0, f5
  lwclc f7, r0, _trig_A5
  fadd  f0, f0, f7
  fmul  f0, f0, f5
  lwclc f7, r0, _trig_A3
  fadd  f0, f0, f7
  fmul  f0, f0, f5
  lwclc f7, r0, _trig_1.0
  fadd  f0, f0, f7
  fmul  f0, f0, f6
  jr    r31

# constants
_trig_2PI:
  data  0x40c90fdb
_trig_PI:
  data  0x40490fdb
_trig_PI2:
  data  0x3fc90fdb
_trig_PI4:
  data  0x3f490fdb
_trig_S3:
  data  0xbe2aaaac
_trig_S5:
  data  0x3c088666
_trig_S7:
  data  0xb94d64b6
_trig_C0:
_trig_1.0:
  data  0x3f800000
_trig_C2:
  data  0xbf000000
_trig_C4:
  data  0x3d2aa789
_trig_C6:
  data  0xbab38106
_trig_2.0:
  data  0x40000000
_trig_A3:
  data  0xbeaaaaaa
_trig_A5:
  data  0x3e4ccccd
_trig_A7:
  data  0xbe124925
_trig_A9:
  data  0x3de38e38
_trig_A11:
  data  0xbdb7d66e
_trig_A13:
  data  0x3d75e7c5
_trig_0.4375:
  data  0x3ee00000
_trig_2.4375:
  data  0x401c0000
