#include <stdio.h>
#include <stdlib.h>
#include <stdint.h>
#include "regdef.h"

extern uint32_t fadd(uint32_t uint1, uint32_t uint2);
extern uint32_t fmul(uint32_t data1, uint32_t data2);
extern uint32_t finv(uint32_t before);

void execline(unsigned line,FILE *inputfp,FILE *outputfp) {
	rtype rl;
	rl.line = line;


	if(aflag == 1) {
		linecount[pc]++;
	}


	ecount++;

//Op:0 rtype
	if (rl.op == 0) {
	
	//Shift Left Logical: sll
		if (rl.func == 0x00) {
			r[rl.d] = ((unsigned)r[rl.s] << rl.shift);
			icount[2]++;
		}
	//Shift Right Logical: srl
		else if (rl.func == 0x02) {
			r[rl.d] = ((unsigned)r[rl.s] >> rl.shift);
			icount[3]++;
		}
	//and
		else if (rl.func == 0x24) {
			r[rl.d] = r[rl.s] & r[rl.t];
			icount[4]++;
		}
	//or
		else if (rl.func == 0x25) {
			r[rl.d] = r[rl.s] | r[rl.t];
			icount[5]++;
		}
	//nor
		else if (rl.func == 0x27) {
			r[rl.d] = ~(r[rl.s] | r[rl.t]);
			icount[6]++;
		}
/*
	//mult
		else if (rl.func == 0x18) {
			r[rl.d] = (((long)r[rl.s] * (long)r[rl.t]) << 32) >> 32;
		}
	//div
		else if (rl.func == 0x1a) {
			r[rl.d] = r[rl.s] / r[rl.t];
		}
	//rem
		else if (rl.func == 0x1b) {
			r[rl.d] = r[rl.s] % r[rl.t];
		}
*/
	//add
		else if (rl.func == 0x20) {
			r[rl.d] = r[rl.s] + r[rl.t];
			icount[9]++;
		}
	//sub
		else if (rl.func == 0x22) {
			r[rl.d] = r[rl.s] - r[rl.t];
			icount[10]++;
		}
	//Jump Register:jr
		else if (rl.func == 0x08) {
			pc = r[rl.s] - 1;
			icount[12]++;
		}
	//Set Less Than:slt
		else if (rl.func == 0x2a) {
			r[rl.d] = (r[rl.s] < r[rl.t]) ? 1 : 0;
			icount[13]++;
		}
		else {
			printf("%lu:Unknown Instruction(%x)",pc,line);
		}

	}
//Op:1 rtype
	else if (rl.op == 1) {
	//InputByte:in
		if (rl.func == 0x00) {
			fread(&r[rl.d],1,1,inputfp);
			icount[0]++;
		}
	//OutPutByte:out
		else if (rl.func == 0x01) {
			fwrite(&r[rl.s],1,1,outputfp);
			icount[1]++;
		}
		else {
			printf("%lu:Unknown Instruction(%x)",pc,line);
		}
	}
//Op:0x02 jtype jump:j
	else if (rl.op == 0x02) {
		jtype jl;
		jl.line = line;
		pc = jl.addr - 1;
		icount[14]++;
	}
//Op:0x03 jtype Jump And Link:jal
	else if (rl.op == 0x03) {
		jtype jl;
		jl.line = line;
		r[31] = pc + 1;
		pc = jl.addr - 1;
		icount[15]++;
	}
//Op:0x04 itype Branch On Equal: beq
	else if (rl.op == 0x04) {
		itype il;
		il.line = line;
		if (r[il.s] == r[il.t])
			pc = pc + (int)il.imm;
		icount[16]++;
	}
//Op:0x05 itype Branch On Not Equal: bne
	else if (rl.op == 0x05) {
		itype il;
		il.line = line;
		if (r[il.s] != r[il.t])
			pc = pc + (int)il.imm;
		icount[17]++;
	}

//Op:0x08 itype addi
	else if (rl.op == 0x08) {
		itype il;
		il.line = line;
		r[il.t] = r[il.s] + (int)il.imm;
		icount[11]++;
	}
//Op:0x0a itype Set Less Than Imm:slti
	else if (rl.op == 0x0a) {
		itype il;
		il.line = line;
		r[il.t] = (r[il.s] < (int)il.imm) ? 1 : 0;
		icount[18]++;
	}
//Op:0x0c itype andi
	else if (rl.op == 0x0c) {
		itype il;
		il.line = line;
		unsigned zeroextimm = ((unsigned)il.imm << 16) >> 16;
		r[il.t] = (unsigned)r[il.s] & zeroextimm;
		icount[7]++;
	}
//Op:0x0c itype ori
	else if (rl.op == 0x0d) {
		itype il;
		il.line = line;
		unsigned zeroextimm = ((unsigned)il.imm << 16) >> 16;
		r[il.t] = (unsigned)r[il.s] | zeroextimm;
		icount[8]++;
	}
//Op:11 frtype
	else if (rl.op == 0x11) {
		frtype frl;
		frl.line = line;
	//FP Add Single:fadd
		if (frl.func == 0x00 && frl.fmt == 0x10) {
			if (flag[0] == 0) {
				f[frl.d] = f[frl.s] + f[frl.t];
			}
			else {
				myfloat mf1,mf2,mf3;
				mf1.f32 = f[frl.s];
				mf2.f32 = f[frl.t];
				mf3.u32 = fadd(mf1.u32,mf2.u32);
				f[frl.d] = mf3.f32;
			}
			icount[21]++;
		}
	//FP Subtract Single:fsub
		else if (frl.func == 0x01 && frl.fmt == 0x10) { 
			if (flag[0] == 0) {
				f[frl.d] = f[frl.s] - f[frl.t];
			}
			else {
				myfloat mf1,mf2,mf3;
				mf1.f32 = f[frl.s];
				mf2.f32 = -f[frl.t];
				mf3.u32 = fadd(mf1.u32,mf2.u32);
				f[frl.d] = mf3.f32;
			}
			icount[22]++;
		}
	//FP Multiply Single:fmul
		else if (frl.func == 0x02 && frl.fmt == 0x10) { 
			if (flag[2] == 0) {
				f[frl.d] = f[frl.s] * f[frl.t];
			}
			else {
				myfloat mf1,mf2,mf3;
				mf1.f32 = f[frl.s];
				mf2.f32 = f[frl.t];
				mf3.u32 = fmul(mf1.u32,mf2.u32);
				f[frl.d] = mf3.f32;
			}
			icount[23]++;
		}
	//FP Inverse Single:finv
		else if (frl.func == 0x03 && frl.fmt == 0x10) { 
			if (flag[2] == 0) {
				f[frl.d] = 1.0f / f[frl.s];
			}
			else {
				myfloat mf1;
				mf1.f32 = f[frl.s];
				mf1.u32 = finv(mf1.u32);
				f[frl.d] = mf1.f32;
			}

			icount[24]++;
		}
/*
	//fitype Branch On ~
		else if (frl.fmt == 0x08) {
			fitype fil;
			fil.line = line;
		//FP Branch On FP False:bclf
			if (fil.t == 0) {
				if (fcc == 0) {
					fseek(fp,pc + 4 + (fil.imm * 4),SEEK_SET);
				}
			}
			if (fil.t == 1) {
		//FP Branch On FP True:bclt
				if (fcc == 1) {
					fseek(fp,pc + 4 + (fil.imm * 4),SEEK_SET);
				}
			}
	
		}

	//FP Compare Single
		else if (frl.fmt == 0x10) { 
			//c.eq.s
			if (frl.t == 0x32) {
				fcc = (f[frl.s] == f[frl.t]) ? 1 : 0;
			}
			//c.lt.s
			if (frl.t == 0x3c) {
				fcc = (f[frl.s] < f[frl.t]) ? 1 : 0;
			}
			//c.le.s
			if (frl.t == 0x3e) {
				fcc = (f[frl.s] <= f[frl.t]) ? 1 : 0;
			}
		}
*/
		else {
			printf("%lu:Unknown Instruction(%x)",pc,line);
		}
	}

//Op:0x12 frtype 
	else if (rl.op == 0x12) {
		frtype frl;
		frl.line = line;
	//FP Set Less Than:fslt
		if (frl.fmt == 0x10 && frl.func == 0) {
			r[frl.d] = (f[frl.s] < f[frl.t]) ? 1 : 0;
			icount[25]++;
		}
	//FP Set Equal:feq
		else if (frl.fmt == 0x10 && frl.func == 1) {
			r[frl.d] = (f[frl.s] == f[frl.t]) ? 1 : 0;
			icount[26]++;
		}
		else {
			printf("%lu:Unknown Instruction(%x)",pc,line);
		}
	}


//Op:0x23 itype Load Word:lw
	else if (rl.op == 0x23) {
		itype il;
		il.line = line;
		r[il.t] = maddr[r[il.s] + (int)il.imm];
		icount[19]++;
	}
//Op:0x24 itype Load Word Const:lwc
	else if (rl.op == 0x24) {
		itype il;
		il.line = line;
		r[il.t] = prog[r[il.s] + (int)il.imm];
		icount[32]++;
	}
//Op:0x2b itype Store Word:sw
	else if (rl.op == 0x2b) {
		itype il;
		il.line = line;
		maddr[r[il.s] + (int)il.imm] = r[il.t];
		mtrace[mtnum] = r[il.s] + (int)il.imm;
		mtracebody[mtnum] = r[il.t];
		MTRACE;
		icount[20]++;
	}
//Op:0x31 itype Load FP Single:lwcl
	else if (rl.op == 0x31) {
		itype il;
		il.line = line;
		myfloat mf;
		mf.u32 = maddr[r[il.s] + (int)il.imm];
		f[il.t] = mf.f32;
		icount[27]++;
	}
//Op:0x32 itype Load FP Single Const:lwclc
	else if (rl.op == 0x32) {
		itype il;
		il.line = line;
		myfloat mf;
		mf.u32 = prog[r[il.s] + (int)il.imm];
		f[il.t] = mf.f32;
		icount[31]++;
	}
//Op:0x33 rtype
	else if (rl.op == 0x33) {
	//func:0x00 FP Move fmov
		if (rl.func == 0x00) {
			f[rl.d] = f[rl.s];
			icount[29]++;
		}
	//func:0x01 FP Negation fneg
		else if (rl.func == 0x01) {
			f[rl.d] = -f[rl.s];
			icount[30]++;
		}

	}

//Op:0x39 itype Store FP Single:swcl
	else if (rl.op == 0x39) {
		itype il;
		il.line = line;
		myfloat mf;
		mf.f32 = f[il.t];
		maddr[r[il.s] + (int)il.imm] = mf.u32;
		mtrace[mtnum] = r[il.s] + (int)il.imm;
		mtracebody[mtnum] = mf.u32;
		MTRACE;
		icount[28]++;
	}

//Op:3F rtype Break Point:bp
	else if (rl.op == 0x3F) {
		bpoint = 1;
	}
	else {
		printf("%lu:Unknown Instruction(%x)",pc,line);
	}


}

