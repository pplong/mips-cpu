start:
  in    r2
  li    r3, 0
  li    r4, 1
  li    r6, 1

loop:
  beq   r2, 0, output
  add   r5, r3, r4
  add   r3, 0, r4
  add   r4, 0, r5
  sub   r2, r2, r6
  j     loop

output:
  out   r3
  j     start
