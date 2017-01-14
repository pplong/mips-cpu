#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include "regdef.h"



void dassline(unsigned line) {
	rtype rl;
	rl.line = line;


//Op:0 rtype
	if (rl.op == 0) {
	
	//Shift Left Logical: sll
		if (rl.func == 0x00) {
			sprintf(cline,"sll r%u,r%u,%u",rl.d,rl.s,rl.shift);
		}
	//Shift Right Logical: srl
		else if (rl.func == 0x02) {
			sprintf(cline,"srl r%u,r%u,%u",rl.d,rl.s,rl.shift);
		}
	//and
		else if (rl.func == 0x24) {
			sprintf(cline,"and r%u,r%u,r%u",rl.d,rl.s,rl.t);
		}
	//or
		else if (rl.func == 0x25) {
			sprintf(cline,"or r%u,r%u,r%u",rl.d,rl.s,rl.t);
		}
	//nor
		else if (rl.func == 0x27) {
			sprintf(cline,"nor r%u,r%u,r%u",rl.d,rl.s,rl.t);
		}
/*
	//mult
		else if (rl.func == 0x18) {
			sprintf(cline,"mult r%u,r%u,r%u",rl.d,rl.s,rl.t);
		}
	//div
		else if (rl.func == 0x1a) {
			sprintf(cline,"div r%u,r%u,r%u",rl.d,rl.s,rl.t);
		}
	//rem
		else if (rl.func == 0x1b) {
			sprintf(cline,"rem r%u,r%u,r%u",rl.d,rl.s,rl.t);
		}
*/
	//add
		else if (rl.func == 0x20) {
			sprintf(cline,"add r%u,r%u,r%u",rl.d,rl.s,rl.t);
		}
	//sub
		else if (rl.func == 0x22) {
			sprintf(cline,"sub r%u,r%u,r%u",rl.d,rl.s,rl.t);
		}
	//Jump Register:jr
		else if (rl.func == 0x08) {
			sprintf(cline,"jr r%u",rl.s);
		}
	//Set Less Than:slt
		else if (rl.func == 0x2a) {
			sprintf(cline,"slt r%u,r%u,r%u",rl.d,rl.s,rl.t);
		}
		else {
			sprintf(cline,"");
			printf("%lu:Unknown Instruction(%x)",pc,line);
		}
	}
//Op:1 rtype
	else if (rl.op == 1) {
	//InputByte:in
		if (rl.func == 0x00) {
			sprintf(cline,"in r%u",rl.d);
		}
	//OutPutByte:out
		else if (rl.func == 0x01) {
			sprintf(cline,"out r%u",rl.s);
		}
		else {
			sprintf(cline,"");
			printf("%lu:Unknown Instruction(%x)",pc,line);
		}
	}
//Op:0x02 jtype jump:j
	else if (rl.op == 0x02) {
		jtype jl;
		jl.line = line;
		sprintf(cline,"j %u",jl.addr);
	}
//Op:0x03 jtype Jump And Link:jal
	else if (rl.op == 0x03) {
		jtype jl;
		jl.line = line;
		sprintf(cline,"jal %u",jl.addr);
	}
//Op:0x04 itype Branch On Equal: beq
	else if (rl.op == 0x04) {
		itype il;
		il.line = line;
		sprintf(cline,"beq r%u,r%u,%d",il.t,il.s,il.imm);
	}
//Op:0x05 itype Branch On Not Equal: bne
	else if (rl.op == 0x05) {
		itype il;
		il.line = line;
		sprintf(cline,"bne r%u,r%u,%d",il.t,il.s,il.imm);
	}
//Op:0x08 itype addi
	else if (rl.op == 0x08) {
		itype il;
		il.line = line;
		sprintf(cline,"addi r%u,r%u,%d",il.t,il.s,il.imm);
	}
//Op:0x0a itype Set Less Than Imm:slti
	else if (rl.op == 0x0a) {
		itype il;
		il.line = line;
		sprintf(cline,"slti r%u,r%u,%d",il.t,il.s,il.imm);
	}
//Op:0x0c itype andi
	else if (rl.op == 0x0c) {
		itype il;
		il.line = line;
		sprintf(cline,"andi r%u,r%u,%d",il.t,il.s,il.imm);
	}
//Op:0x0c itype ori
	else if (rl.op == 0x0d) {
		itype il;
		il.line = line;
		sprintf(cline,"ori r%u,r%u,%d",il.t,il.s,il.imm);
	}
//Op:11 frtype
	else if (rl.op == 0x11) {
		frtype frl;
		frl.line = line;
	//FP Add Single:fadd
		if (frl.func == 0x00 && frl.fmt == 0x10) {
			sprintf(cline,"fadd f%u,f%u,f%u",frl.d,frl.s,frl.t);
		}
	//FP Subtract Single:fsub
		else if (frl.func == 0x01 && frl.fmt == 0x10) { 
			sprintf(cline,"fsub f%u,f%u,f%u",frl.d,frl.s,frl.t);
		}
	//FP Multiply Single:fmul
		else if (frl.func == 0x02 && frl.fmt == 0x10) { 
			sprintf(cline,"fmul f%u,f%u,f%u",frl.d,frl.s,frl.t);
		}
	//FP Divide Single:fdiv
		else if (frl.func == 0x03 && frl.fmt == 0x10) { 
			sprintf(cline,"fdiv f%u,f%u,f%u",frl.d,frl.s,frl.t);
		}
/*
	//fitype Branch On ~
		else if (frl.fmt == 0x08) {
			fitype fil;
			fil.line = line;
		//FP Branch On FP False:bclf
			if (fil.t == 0) {
				sprintf(cline,"bclf %d",fil.imm);
			}
			else if (fil.t == 1) {
		//FP Branch On FP True:bclt
				sprintf(cline,"bclt %d",fil.imm);
			}
			else {
				printf("%ld:Unknown Instruction(%x)",(pc-4)/4,line);
			}
		}
	//FP Compare Single
		else if (frl.fmt == 0x10) { 
			//c.eq.s
			if (frl.t == 0x32) {
				sprintf(cline,"c.eq.s f%u,f%u",frl.t,frl.s);
			}
			//c.lt.s
			else if (frl.t == 0x3c) {
				sprintf(cline,"c.lt.s f%u,f%u",frl.t,frl.s);
			}
			//c.le.s
			else if (frl.t == 0x3e) {
				sprintf(cline,"c.le.s f%u,f%u",frl.t,frl.s);
			}
			else {
				printf("%ld:Unknown Instruction(%x)",(pc-4)/4,line);
			}
		}
*/
		else {
			sprintf(cline,"");
			printf("%lu:Unknown Instruction(%x)",pc,line);
		}
	}
//Op:0x12 frtype 
	else if (rl.op == 0x12) {
		frtype frl;
		frl.line = line;
	//FP Set Less Than
		if (frl.fmt == 0x10 && frl.func == 0) {
			sprintf(cline,"fslt r%u,f%u,f%u",frl.d,frl.s,frl.t);
		}
	//FP Set Equal:feq
		else if (frl.fmt == 0x10 && frl.func == 1) {
			sprintf(cline,"feq r%u,f%u,f%u",frl.d,frl.s,frl.t);
		}
		else {
			sprintf(cline,"");
			printf("%lu:Unknown Instruction(%x)",pc,line);
		}
	}

//Op:0x23 itype Load Word:lw
	else if (rl.op == 0x23) {
		itype il;
		il.line = line;
		sprintf(cline,"lw r%u,r%u,%d",il.t,il.s,il.imm);
	}
//Op:0x24 itype Load Word Const:lwc
	else if (rl.op == 0x24) {
		itype il;
		il.line = line;
		sprintf(cline,"lwc r%u,r%u,%d",il.t,il.s,il.imm);
	}
//Op:0x2b itype Store Word:sw
	else if (rl.op == 0x2b) {
		itype il;
		il.line = line;
		sprintf(cline,"sw r%u,r%u,%d",il.t,il.s,il.imm);
	}
//Op:0x31 itype Load FP Single:lwcl
	else if (rl.op == 0x31) {
		itype il;
		il.line = line;
		sprintf(cline,"lwcl f%u,r%u,%d",il.t,il.s,il.imm);
	}
//Op:0x32 itype Load FP Single Const:lwclc
	else if (rl.op == 0x32) {
		itype il;
		il.line = line;
		sprintf(cline,"lwclc f%u,r%u,%d",il.t,il.s,il.imm);
	}
//Op:0x33 rtype
	else if (rl.op == 0x33) {
	//func:0x00 FP Move fmov
		if (rl.func == 0x00) {
			sprintf(cline,"fmov f%u f%u",rl.d,rl.s);
		}
	//func:0x01 FP Negation fneg
		else if (rl.func == 0x01) {
			sprintf(cline,"fneg f%u f%u",rl.d,rl.s);
		}

	}
//Op:0x39 itype Store FP Single:swcl
	else if (rl.op == 0x39) {
		itype il;
		il.line = line;
		sprintf(cline,"swcl r%u,f%u,%d",il.t,il.s,il.imm);
	}
//Op:3F rtype Break Point:bp
	else if (rl.op == 0x3f) {
		sprintf(cline,"bp");
	}
	else {
		sprintf(cline,"");
		printf("%lu:Unknown Instruction(%x)",pc,line);
	}

}

