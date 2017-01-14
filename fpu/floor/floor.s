j min_caml_floor


#itof

itof_0x00000000:
	data 0x00000000

itof_0x4b000000:
	data 0x4b000000

itof_8388608:
	data 8388608

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



#ftoi

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

min_caml_ftoi:
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


#floor

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

	sw 	r31, r30, 0
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
	#jr 31


