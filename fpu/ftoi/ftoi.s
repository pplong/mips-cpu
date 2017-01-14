j min_caml_ftoi_main

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

min_caml_ftoi_main:
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
	#jr r31

