min_caml_mul: # r2 * r3
  li  r4, 0
  li  r6, 1
_mul_loop:
  beq   r3, r0, _mul_end
  
  and   r5, r3, r6
  beq   r5, r0, _mul_next
  
  add   r4, r4, r2
_mul_next:
  add   r2, r2, r2
  srl   r3, r3, 1
  j     _mul_loop
_mul_end:
  move  r2, r4
  jr    r31

min_caml_div10: # r2 / 10 (r2 > 0)
  li    r7, 0
  srl   r8, r2, 2
  move  r10, r2
  li    r11, 1
_div10_loop:
  sub   r9, r8, r7
  ble   r9, r11, _div10_end
  
  add   r9, r7, r8
  srl   r9, r9, 1
  move  r2, r9
  li    r3, 10
  sw    r31, r30, 0
  jal   min_caml_mul
  lw    r31, r30, 0
  bgt   r2, r10, _div10_set_hi
  
  move  r7, r9
  j     _div10_loop
_div10_set_hi:
  move  r8, r9
  j     _div10_loop
_div10_end:
  move  r2, r7
  jr    r31

min_caml_rem10: # r2 % 10
  move  r12, r2
  sw    r31, r30, 0
  addi  r30, r30, 1
  jal   min_caml_div10
  addi  r30, r30, -1
  li    r3, 10
  jal   min_caml_mul
  lw    r31, r30, 0
  sub   r2, r12, r2
  jr    r31

min_caml_print_byte: # out(r2)
min_caml_print_char:
  out   r2
  jr    r31

min_caml_print_newline: # out('\n')
  li    r2, 10
  out   r2
  jr    r31


min_caml_print_int_0x00040000:
	data	0x00040000

min_caml_print_int_0x4c7e502b:
	data	0x4c7e502b

min_caml_print_int_0x3F000000:
	data	0x3F000000

min_caml_print_int:
	lwc r13,r0,min_caml_print_int_0x00040000
	lw r14,r13,0
	li r15,2
	bgt r14,r15,min_caml_print_int2
	addi r14,r14,1
	sw r14,r13,0
	j min_caml_print_int_body

min_caml_print_int2:
	lw r14,r13,1
	li r15,1
	bgt r14,r15,min_caml_print_int_red
	addi r14,r14,1
	sw r14,r13,1
	move r15,r14
	add r15,r15,r13
	addi r15,r15,1
	sw r2,r15,0
	j min_caml_print_int_body

min_caml_print_int_red:
	lw r16,r13,2
	lw r17,r13,3
	move r18,r2
	
	sll r17,r17,1
	sll r18,r18,1
	
	li r19,0
	li r15,128
	bgt r15,r16,min_caml_print_int_green
	li r19,1

min_caml_print_int_green:
	sw r2,r13,5
	sw r31,r13,4
	addi r2,r17,440
	jal min_caml_itof
	lwclc f3,r0,min_caml_print_int_0x4c7e502b
	finv f0,f0
	fmul f15,f3,f0

min_caml_print_int_blue:
	addi r2,r18,440
	jal min_caml_itof
	lwclc f3,r0,min_caml_print_int_0x4c7e502b
	finv f0,f0
	fmul f16,f3,f0

	beq r19,r0,min_caml_print_int_2f
	j min_caml_print_int_synth

min_caml_print_int_2f:
	lwclc f3,r0,min_caml_print_int_0x3F000000
	fmul f15,f15,f3
	fmul f26,f16,f3

min_caml_print_int_synth:
	li r22,1
	sll r22,22,31
	move r23,r22

	li r15,1
	sll r15,r15,23
	or r23,r23,r15
		
	sll r19,r19,20
	or r22,r22,r19
	or r23,r23,r19

	fmov f0,f15
	jal min_caml_ftoi
	move r20,r2
	fmov f0,f26
	jal min_caml_ftoi
	move r21,r2

	or r22,r22,r20
	or r23,r23,r21
	
	synth r22
	synth r23

	lw r31,r13,4
	lw r2,r13,5
	sw r0,r13,1


min_caml_print_int_body: # output r2 as integer (r2 >= 0)
  move  r13, r2
  li    r14, 10
  bge   r13, r14, _print_int_recur
  addi  r13, r13, 48
  out   r13
  jr    r31
_print_int_recur:
  sw    r31, r30, 0
  addi  r30, r30, 2
  jal   min_caml_rem10
  sw    r2, r30, -1
  move  r2, r13
  jal   min_caml_div10
  jal   min_caml_print_int_body
  addi  r30, r30, -2
  lw    r13, r30, 1
  addi  r13, r13, 48
  out   r13
  lw    r31, r30, 0
  jr    r31

_read_word:
	in    r2
	sll   r2, r2, 8
	in    r2
	sll   r2, r2, 8
	in    r2
	sll   r2, r2, 8
	in    r2
	jr    r31

_write_word:
  swcl  f0, r30, 1
  lw    r2, r30, 1
  srl   r3, r2, 24
  out   r3
  srl   r3, r2, 16
  out   r3
  srl   r3, r2, 8
  out   r3
  out   r2
  jr    r31

min_caml_dump_float:
  sw    r31, r30, 0
  jal   _write_word
  lw    r31, r30, 0
  jr    r31

min_caml_read_int:
	sw		r31, r30, 0
	jal		_read_word
	lw		r31, r30, 0
	jr		r31

min_caml_read_float:
	sw		r31, r30, 0
	jal		_read_word
	lw		r31, r30, 0
  sw    r2, r30, 1
  lwcl  f0, r30, 1
	jr		r31

min_caml_shift_right1:
  srl   r2, r2, 1
  jr    r31

min_caml_create_array:
	li    r4, 0
	move	r5, r29
_create_array_loop:
	beq   r4, r2, _create_array_exit
  
	sw		r3, r5, 0
	addi	r5, r5, 1
	addi	r4, r4, 1
	j     _create_array_loop
_create_array_exit:
	move	r5, r29
	add   r29, r29, r2
	move	r2, r5
	jr		r31

min_caml_create_float_array:
	li		r4, 0
	move	r5, r29
_create_float_array_loop:
	beq		r4, r2, _create_float_array_exit
  
	swcl	f0, r5, 0
	addi	r5, r5, 1
	addi	r4, r4, 1
	j     _create_float_array_loop
_create_float_array_exit:
	move	r5, r29
	add 	r29, r29, r2
	move 	r2, r5
	jr    r31

################################################################################
# ITOF
################################################################################
itof_0x00000000:
  data 0x00000000

itof_0x4b000000:
  data 0x4b000000

itof_8388608:
  data 8388608

min_caml_float_of_int:
min_caml_itof:
  li r3,0
  move r4,r2
  li r5,0
  li r6,0
  li r7,0
  
    #sign:r3
    #abs:r4
  bge r4,r0,itof_abs_if
  
  li r3,1
  sub r4,r0,r4


itof_abs_if:
    #f1 = 0x4b000000
  lwclc f1,r0,itof_0x4b000000
  lwclc f2,r0,itof_0x00000000
  lwclc f3,r0,itof_0x00000000
    #r10 = 0x4b000000
  lwc r10,r0,itof_0x4b000000
    #r11 = 8388608
  lwc r11,r0,itof_8388608

    #if abs <= 8388608

  bgt r4,r11,itof_else1
  
    #r5:ans.u32 = abs + 0x4b000000
  add r5,r4,r10
    #f2:ans.u32 -> ans.f32
  sw r5,r30,0
  lwcl f2,r30,0
    #ans.f32 = ans.f32 - (0x4b000000)f1

  lwclc f1,r0,itof_0x4b000000
  fsub f0,f2,f1
  j itof_ans
  
itof_else1:
    #r5:m = abs / 8388608
  srl r5,r4,23
    #f2:ans1.f32 = 0;
  lwclc f2,r0,itof_0x00000000
    #for r6=0;r6<m(r5);r6++; {f2 + 0x4b000000;}
  li r6,0
itof_loop1:
  bge r6,r5,itof_loop1_end
  
  fadd f2,f2,f1
  addi r6,r6,1
  j itof_loop1
itof_loop1_end:
    #r7:ans2.u32 = (abs % 8388602) + 0x4b00000000
  sll r7,r4,9
  srl r7,r7,9
  add r7,r7,r10
    #f3:ans2.u32 -> ans2.f32
  sw r7,r30,0
  lwcl f3,r30,0
  fsub f3,f3,f1
  
    #f0 = f2 + f3
  fadd f0,f2,f3
    #sign f0
itof_ans:
  bne r3,r0,itof_minus1
  
  jr r31

itof_minus1:
  fneg f0,f0
  jr r31

################################################################################
# FTOI
################################################################################

ftoi_0x00000000:
  data 0x00000000

ftoi_0x4b000000:
  data 0x4b000000

ftoi_1073741824:
  data 1073741824

ftoi_0x4E800000:
  data 0x4E800000
ftoi_0x4E000000:
  data 0x4E000000
ftoi_0x4D800000:
  data 0x4D800000
ftoi_0x4D000000:
  data 0x4D000000
ftoi_0x4C800000:
  data 0x4C800000
ftoi_0x4C000000:
  data 0x4C000000
ftoi_0x4B800000:
  data 0x4B800000

ftoi_8388608:
  data 8388608

min_caml_int_of_float:
min_caml_ftoi:
min_caml_truncate:
  li r3,0
  li r4,0
  li r5,0
  lwc r10,r0,ftoi_0x4b000000
  lwc r11,r0,ftoi_8388608
  lwc r12,r0,ftoi_1073741824

  fmov f1,f0
  lwclc f2,r0,ftoi_0x00000000
  lwclc f10,r0,ftoi_0x00000000
  lwclc f11,r0,ftoi_0x4b000000


    # f1 = |fa|
  fslt r1,f1,f10
  beq r1,r0,ftoi_if1
  
  li r3,1
  fneg f1,f1

ftoi_if1:

  fslt r1,f1,f11
  beq r1,r0,ftoi_big
  

    #abs.f32 < 8388608.0
  fadd f2,f1,f11
  swcl f2,r30,0
  lw r2,r30,0
  sub r2,r2,r10
  
  j ftoi_neg


ftoi_big:
  lwclc f12,r0,ftoi_0x4E800000
  lwclc f13,r0,ftoi_0x4E000000
  lwclc f14,r0,ftoi_0x4D800000
  lwclc f15,r0,ftoi_0x4D000000
  lwclc f16,r0,ftoi_0x4C800000
  lwclc f17,r0,ftoi_0x4C000000
  lwclc f18,r0,ftoi_0x4B800000

  fslt r1,f1,f12
  bne r1,r0,ftoi_big2
  
  fsub f1,f1,f12
  add r5,r5,r12

ftoi_big2:
  srl r12,r12,1
  fslt r1,f1,f13
  bne r1,r0,ftoi_big3
  
  fsub f1,f1,f13
  add r5,r5,r12

ftoi_big3:
  srl r12,r12,1
  fslt r1,f1,f14
  bne r1,r0,ftoi_big4
  
  fsub f1,f1,f14
  add r5,r5,r12

ftoi_big4:
  srl r12,r12,1
  fslt r1,f1,f15
  bne r1,r0,ftoi_big5
  
  fsub f1,f1,f15
  add r5,r5,r12

ftoi_big5:
  srl r12,r12,1
  fslt r1,f1,f16
  bne r1,r0,ftoi_big6
  
  fsub f1,f1,f16
  add r5,r5,r12

ftoi_big6:
  srl r12,r12,1
  fslt r1,f1,f17
  bne r1,r0,ftoi_big7
  
  fsub f1,f1,f17
  add r5,r5,r12

ftoi_big7:
  srl r12,r12,1
  fslt r1,f1,f18
  bne r1,r0,ftoi_big8
  
  fsub f1,f1,f18
  add r5,r5,r12

ftoi_big8:
  srl r12,r12,1
  fslt r1,f1,f11
  bne r1,r0,ftoi_loop1_end
  
  fsub f1,f1,f11
  add r5,r5,r12 

ftoi_loop1_end:
  fadd f1,f1,f11
  swcl f1,r30,0
  lw r2,r30,0
  sub r2,r2,r10
  add r2,r2,r5

ftoi_neg:
  ble r3,r0,ftoi_end
  
  sub r2,r0,r2
  
ftoi_end:
  jr r31


##
## FABS
##
min_caml_abs_float:
min_caml_fabs:
  swcl  f0, r30, 0
  lw    r2, r30, 0
  sll   r2, r2, 1
  srl   r2, r2, 1
  sw    r2, r30, 0
  lwcl  f0, r30, 0
  jr    r31

_fcmp_zero:
  data  0x00000000

##
## FISZERO
##
min_caml_fiszero:
  swcl  f0, r30, 0
  lw    r2, r30, 0
  sll   r2, r2, 1
  srl   r2, r2, 1
  beq   r2, r0, _iszero_zero
  
  li    r2, 0
  jr    r31
_iszero_zero:
  li    r2, 1
  jr    r31

##
## FISPOS
##
min_caml_fispos:
  lwclc f1, r0, _fcmp_zero
  fslt  r2, f1, f0
  jr    r31

##
## FISNEG
##
min_caml_fisneg:
  lwclc f1, r0, _fcmp_zero
  fslt  r2, f0, f1
  jr    r31

##
## FNEG
##
min_caml_fneg:
  fneg  f0, f0
  jr    r31

##
## FSQR
##
min_caml_fsqr:
  fmul  f0, f0, f0
  jr    r31

##
## FLESS
##
min_caml_fless:
  fslt  r2, f0, f1
  jr    r31

##
## FHALF
##
min_caml_fhalf:
  lwclc f1, r0, _trig_2.0
  finv  f31, f1
  fmul  f0, f0, f31
  jr    r31

##
## FSQRT
##
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
  finv  f31, f3
  fmul  f3, f2, f31
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


##
## FLOOR
##
floor_0x3F800000:
  data 0x3F800000

min_caml_floor:

  lwclc f30,r0,ftoi_0x00000000
  lwclc f29,r0,floor_0x3F800000
  lwclc f28,r0,ftoi_0x4b000000
  li r23,0

  fslt r1,f0,f30
  beq r1,r0,floor_abs
  
  li r23,1
  fneg f0,f0

floor_abs:
  fslt r1,f0,f28
  beq r1,r0,floor_end2
  

  fmov f20,f0

  sw  r31, r30, 0
  addi r30, r30, 1
  jal min_caml_ftoi
  jal min_caml_itof
  addi r30, r30, -1
  lw   r31, r30, 0
    #f0:fb f1:fb-1 f20:fa 

  beq r23,r0,floor_end
  
  fneg f20,f20
  fneg f0,f0

floor_end:
  fsub f1,f0,f29
  fslt r1,f1,f20
  beq r1,r0,floor_comp
  

  fslt r1,f20,f0
  beq r1,r0,floor_comp
  

  fmov f0,f1
  j floor_comp

floor_end2:
  beq r23,r0,floor_comp
  
  fneg f0,f0


floor_comp:
  jr 31


################################################################################
# TRIGONOMETRIC FUNCTIONS
################################################################################
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
  finv  f31, f2
  fmul  f0, f3, f31
  # fdiv  f0, f3, f2
  jal   _trig_kernel_atan
  lwclc f1, r0, _trig_PI4
  fadd  f0, f0, f1
  j     _atan_done

_atan_part3:
  lwclc f1, r0, _trig_1.0
  finv  f31, f0
  fmul  f0, f31, f1
  # fdiv  f0, f1, f0
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
  finv  f31, f7
  fmul  f6, f6, f31
  # fdiv  f6, f6, f7
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

__end:
	#j __end
