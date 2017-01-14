_sqrt_0x00000000:   # 0.0
  data  0x00000000

_sqrt_0x007fffff:   # bit mask for fraction
  data  0x007fffff

_sqrt_0x3f800000:   # 1.0
  data  0x3f800000

_sqrt_0x40000000:   # 2.0
  data  0x40000000

min_caml_sqrt:  # sqrt(f0)
  swcl  f0, r30, 0
  lw    r2, r30, 0
  move  r3, r2

  # exceptional case
  srl   r2, r2, 23
  beq   r2, 0, _sqrt_exceptional
  li    r4, 255
  beq   r2, r4, _sqrt_exceptional

  # normalize
  addi  r2, r2, -127
  lwc   r4, r0, _sqrt_0x007fffff
  and   r4, r3, r4  # fraction
  li    r5, 127     # exponent
  li    r6, 1
  and   r6, r2, r6
  beq   r6, 0, _sqrt_normalized
  bgt   r2, 0, _sqrt_normalize_expo_positive
  addi  r5, r5, -1
  j     _sqrt_normalized

_sqrt_normalize_expo_positive:
  addi  r5, r5, 1

_sqrt_normalized:
  bge   r2, 0, _sqrt_halfexp_positive
  li    r7, 1
  and   r7, r2, r7
  srl   r2, r2, 1
  li    r6, 1
  sll   r6, r6, 31
  or    r2, r2, r6
  beq   r7, r0, _sqrt_newton_start
  addi  r2, r2, 1
  j     _sqrt_newton_start

_sqrt_halfexp_positive:
  srl   r2, r2, 1

_sqrt_newton_start:
  li    r6, 0
  or    r6, r6, r5
  sll   r6, r6, 23
  or    r6, r6, r4
  sw    r6, r30, 0
  lwcl  f0, r30, 0

  # newton method
  li    r3, 10
  lwclc f1, r0, _sqrt_0x3f800000
  lwclc f4, r0, _sqrt_0x40000000
_sqrt_newton_loop:
  beq   r3, 0, _sqrt_newton_loop_end
  addi  r3, r3, -1
  fmul  f2, f1, f1
  fsub  f2, f2, f0
  fmul  f3, f1, f4
  fdiv  f3, f2, f3
  fsub  f2, f1, f3
  fbeq  f1, f2, _sqrt_newton_loop_end
  fmov  f1, f2
  j     _sqrt_newton_loop

_sqrt_newton_loop_end:
  swcl  f1, r30, 0
  lw    r3, r30, 0
  lwc   r4, r0, _sqrt_0x007fffff
  and   r4, r3, r4  # fraction
  srl   r3, r3, 23
  add   r3, r3, r2
  sll   r3, r3, 23
  or    r3, r3, r4
  sw    r3, r30, 0
  lwcl  f0, r30, 0

_sqrt_exceptional:
  jr    r31
