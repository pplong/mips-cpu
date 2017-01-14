start:
  li    r30, 0
  in    r2
  jal   fib
  out   r3
  j     start

fib:
  li    r20, 1
  beq   r2, 0, zero
  beq   r2, r20, one
  sw    r31, r30, 0
  addi  r30, r30, 1
  sw    r2, r30, 0
  addi  r30, r30, 1
  sub   r2, r2, r20
  jal   fib
  addi  r30, r30, -1
  lw    r2, r30, 0
  sw    r3, r30, 0
  addi  r30, r30, 1
  addi  r2, r2, -2
  jal   fib
  addi  r30, r30, -1
  lw    r4, r30, 0
  add   r3, r3, r4
  addi  r30, r30, -1
  lw    r31, r30, 0
  jr    r31

zero:
  li    r3, 0
  jr    r31

one:
  li    r3, 1
  jr    r31
