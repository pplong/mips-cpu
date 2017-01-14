#include <stdio.h>
#include <stdlib.h>
#include "regdef.h"



void execline(FILE *fp,FILE *inputfp,FILE *outputfp,unsigned line) {
    rtype rl;
    rl.line = line;

    ecount++;

//Op:0 rtype
    if (rl.op == 0) {

    //Shift Left Logical: sll
        if (rl.func == 0x00) {
            r[rl.d] = r[rl.s] << rl.shift;
            icount[2]++;
        }
    //Shift Right Logical: srl
        else if (rl.func == 0x02) {
            r[rl.d] = r[rl.s] >> rl.shift;
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
            fseek(fp,4*r[rl.s],SEEK_SET);
            icount[12]++;
        }
    //Set Less Than:slt
        else if (rl.func == 0x2a) {
            r[rl.d] = (r[rl.s] < r[rl.t]) ? 1 : 0;
            icount[13]++;
        }
        else {
            printf("%ld:Unknown Instruction(%x)",(pc-4)/4,line);
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
            printf("%ld:Unknown Instruction(%x)",(pc-4)/4,line);
        }
    }
//Op:0x02 jtype jump:j
    else if (rl.op == 0x02) {
        jtype jl;
        jl.line = line;
        fseek(fp,((pc >> 28) << 28) + (jl.addr * 4) + 4,SEEK_SET);
        icount[14]++;
    }
//Op:0x03 jtype Jump And Link:jal
    else if (rl.op == 0x03) {
        jtype jl;
        jl.line = line;
        r[31] = (pc/4) + 1;
        fseek(fp,((pc >> 28) << 28) + (jl.addr * 4) + 4,SEEK_SET);
        icount[15]++;
    }
//Op:0x04 itype Branch On Equal: beq
    else if (rl.op == 0x04) {
        itype il;
        il.line = line;
        if (r[il.s] == r[il.t])
            fseek(fp,pc + 4 + (il.imm * 4),SEEK_SET);
        icount[16]++;
    }
//Op:0x05 itype Branch On Not Equal: bne
    else if (rl.op == 0x05) {
        itype il;
        il.line = line;
        if (r[il.s] != r[il.t])
            fseek(fp,pc + 4 + (il.imm * 4),SEEK_SET);
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
    //FP Add Single:add.s
        if (frl.func == 0x00 && frl.fmt == 0x10) {
            f[frl.d] = f[frl.s] + f[frl.t];
            icount[21]++;
        }
    //FP Subtract Single:sub.s
        else if (frl.func == 0x01 && frl.fmt == 0x10) {
            f[frl.d] = f[frl.s] - f[frl.t];
            icount[22]++;
        }
    //FP Multiply Single:mul.s
        else if (frl.func == 0x02 && frl.fmt == 0x10) {
            f[frl.d] = f[frl.s] * f[frl.t];
            icount[23]++;
        }
    //FP Divide Single:div.s
        else if (frl.func == 0x03 && frl.fmt == 0x10) {
            f[frl.d] = f[frl.s] / f[frl.t];
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
            printf("%ld:Unknown Instruction(%x)",(pc-4)/4,line);
        }
    }

//Op:0x12 frtype
    else if (rl.op == 0x12) {
        frtype frl;
        frl.line = line;
    //FP Set Less Than:fslt
        if (frl.fmt == 0x10 && frl.func == 0) {
            r[frl.d] = ((unsigned)f[frl.s] < (unsigned)f[frl.t]) ? 1 : 0;
            icount[25]++;
        }
    //FP Set Equal:feq
        else if (frl.fmt == 0x10 && frl.func == 0) {
            r[frl.d] = ((unsigned)f[frl.s] == (unsigned)f[frl.t]) ? 1 : 0;
            icount[26]++;
        }
        else {
            printf("%ld:Unknown Instruction(%x)",(pc-4)/4,line);
        }
    }


//Op:0x23 itype Load Word:lw
    else if (rl.op == 0x23) {
        itype il;
        il.line = line;
        r[il.t] = maddr[r[il.s] + (int)il.imm];
        icount[19]++;
    }
//Op:0x2b itype Store Word:sw
    else if (rl.op == 0x2b) {
        itype il;
        il.line = line;
        maddr[r[il.s] + (int)il.imm] = r[il.t];
        mtrace[mtnum] = r[il.s] + (int)il.imm;
        mtracebody[mtnum] = r[il.t];
        mtnum++;
        icount[20]++;
    }
//Op:0x31 itype Load FP Single:lwcl
    else if (rl.op == 0x31) {
        itype il;
        il.line = line;
        f[il.t] = maddr[r[il.s] + (int)il.imm];
        icount[27]++;
    }
//Op:0x39 itype Store FP Single:swcl
    else if (rl.op == 0x39) {
        itype il;
        il.line = line;
        maddr[r[il.s] + (int)il.imm] = f[il.t];
        mtrace[mtnum] = r[il.s] + (int)il.imm;
        mtracebody[mtnum] = f[il.t];
        mtnum++;
        icount[28]++;
    }

//Op:3F rtype Break Point:bp
    else if (rl.op == 0x3F) {
        bpoint = 1;
    }
    else {
        printf("%ld:Unknown Instruction(%x)",(pc-4)/4,line);
    }

}
