	j itof_main

itof_0x00000000:
	data 0x00000000

itof_0x4b000000:
	data 0x4b000000

itof_8388608:
	data 8388608

itof_0x80000000:
	data 0x80000000

itof_0xCF000000:
	data 0xCF000000

itof_main:
		#f1 = 0x4b000000
	lwclc f1,r0,itof_0x4b000000
	lwclc f2,r0,itof_0x00000000
	lwclc f3,r0,itof_0x00000000
		#r10 = 0x4b000000
	lwc r10,r0,itof_0x4b000000
		#r11 = 8388608
	lwc r11,r0,itof_8388608
	lwc r12,r0,itof_0x80000000


	li r3,0
	move r4,r2
	li r5,0
	li r6,0
	li r7,0
	
		#sign:r3
		#abs:r4
	bge r4,r0,itof_abs_if
	beq r4,r12,itof_reigai
	li r3,1
	sub r4,r0,r4


itof_abs_if:

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
	#jr r31
	j end

itof_minus1:
	fneg f0,f0
	#jr r31
	j end

itof_reigai:
	lwclc f0,r0,itof_0xCF000000

end:

