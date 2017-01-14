#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include "regdef.h"

extern void finv_init();
extern void finv_term();

extern void execline(unsigned line,FILE *inputfp,FILE *outputfp);
extern void dassline(unsigned line);

/* Register Define */

//register
int r[32] = {};
float f[32] = {};
unsigned long pc = 0;
unsigned *maddr;
unsigned *mtrace;
int *mtracebody;
unsigned mtnum = 0;
unsigned long long ecount = 0;
unsigned long long *icount;
unsigned *prog;
unsigned flag[3] = {};


unsigned *linecount;


int aflag=0;


int bpoint = 0;
char cline[30] = {};

//lineの型
rtype urtype;
itype uitype;
jtype ujtype;
frtype ufrtype;
fitype ufitype;

//メモリ表示
void printmem(int madd1,int madd2) {
	int i;

	for (i=madd1;i<=madd2;i++) {
		printf("mem[%d]:%d\n",i,maddr[i]);
	}

}

//レジスタ内容表示
void printreg() {
	int i,j;
	for (i=0;i<32;i=i+8) {
		for (j=0;j<8;j++) {
			printf("r%02d:%-4d ",i+j,r[i+j]);
		}
		printf("\n");
	}
	for (i=0;i<32;i=i+4) {
		for (j=0;j<4;j++) {
			printf("f%02d:%-4.9f ",i+j,f[i+j]);
		}
		printf("\n");
	}
}

//命令回数解析
void print_a() {
	FILE *fpa;
	fpa = fopen("_eanalysis.txt","w");
	int i;
	char buf[64] = {};
	char iname[INUM][8] = 
{"in","out","sll","srl","and","or","nor","andi","ori","add",
 "sub","addi","jr","slt","j","jal","beq","bne","slti","lw",
 "sw","fadd","fsub","fmul","fdiv","fslt","feq","lwcl","swcl","fmov",
 "fneg","lwclc","lwc"};
	for (i=0;i<INUM;i++){
		sprintf(buf,"%s:%llu\n",iname[i],icount[i]);
		fputs(buf,fpa);
	}


	fclose(fpa);
}

//memory関連初期化
void initmem() {
	int i;
	maddr = (unsigned *)malloc(sizeof(int) * 1048576);
	mtrace = (unsigned *)malloc(sizeof(int) * MTSIZE);
	mtracebody = (int *)malloc(sizeof(int)*MTSIZE);
	icount = (unsigned long long *)malloc(sizeof(unsigned long long)*INUM);


	for(i=0;i<INUM;i++) {
		icount[i] = 0;
	}

}

//flag
void flagmake(int fl) {
	if (fl < 0 || fl > 7) {
		printf("Oops!Flag is invalid(%d)\n",fl);
		fl = 0;
	}
	flag[0] = fl & 1;
	flag[1] = fl & 2;	
	flag[2] = fl & 4;
}


//トランスエンディアン
unsigned trans_endian(unsigned x) {
	return (x << 24) | (x << 8 & 0x00ff0000) | (x >> 8 & 0x0000ff00) | (x >> 24);
}


//本体
int main(int argc,char *argv[]) {
		unsigned psize = 0;
		unsigned line;
		FILE *inputfp;
		FILE *outputfp;
//引数の個数

	if (argc != 2 && argc != 3 && argc != 4) {
		printf("Error:Number of hikisu(%d)\n",argc);
		return 0;
	}
	else {
	//ファイルの存在確認
		FILE *fp;
		if ((fp = fopen(argv[1],"rb")) == NULL) {
			printf("Error:File open\n");
			return 0;
		}
	//プログラムを配列に読み込み
		prog = (unsigned *)malloc(sizeof(unsigned)*PROGSIZE);
		memset(prog,0,sizeof(unsigned)*PROGSIZE);
		fread(&line,sizeof(int),1,fp);
		while(1) {
			if (fread(&line,sizeof(int),1,fp) == 0)
				break;
			prog[psize] = trans_endian(line);

			psize++;
		}
	}
	finv_init();
	if (argc >= 3 && strcmp(argv[2],"step") == 0) {
	//ステップ実行モード

		char buf[40],buf2[20];
		int i;
		unsigned long old_pc=0;
		int bnum;
		int madd1,madd2;

	//I/O Open
		if ((inputfp = fopen("input.bin","rb")) == NULL) {
      inputfp = fopen("input.bin","wb");
      fclose(inputfp);
      inputfp = fopen("input.bin","rb");
		}
		if ((outputfp = fopen("output.bin","wb")) == NULL) {
			printf("Error:Open [output.bin]\n");
			return 0;
		}

	//flagmake
		if (argc == 4) {
			flagmake(atoi(argv[3]));
		}
	//memory作成など
		initmem();


		while(fgets(buf,20,stdin) != NULL && pc < psize) {
		//step
			if (strcmp(buf,"\n") == 0) {
				printf("%lu:",pc);
				dassline(prog[pc]);
				printf("%s\n",cline);
				execline(prog[pc],inputfp,outputfp);
				pc++;
				printreg();
			}
		//break
			else if (strcmp(buf,"b\n") == 0) {
				while(bpoint == 0 && pc < psize) {
						old_pc = pc;
						execline(prog[pc],inputfp,outputfp);
						pc++;
				}
				printf("%ld:",old_pc);
				dassline(prog[old_pc]);
				printf("%s\n",cline);
				printreg();
			}
			else if (strcmp(buf,"ms\n") == 0) {
				memset(mtrace,0,mtnum);
				memset(mtracebody,0,mtnum);
				mtnum = 0;
			}
			else if (strcmp(buf,"mt\n") == 0) {
				for (i=0;i<mtnum;i++) {
					printf("mem[%d]:%d\n",mtrace[i],mtracebody[i]);
				}
			}
			//takusan
			else {
				bnum = sscanf(buf,"%s %d %d\n",buf2,&madd1,&madd2);
			//memory
				if (strcmp(buf2,"m")==0) {
					if (bnum == 2) {
						printmem(madd1,madd1);
					}
					if (bnum == 3) {
						printmem(madd1,madd2);
					}
				}
			}

			bpoint = 0;
		}

		printf("Exection Count:%llu\n",ecount);
		printf("End of Step Simulation\n");
		fclose(inputfp);
		fclose(outputfp);
		free(maddr);
		free(mtrace);
		free(mtracebody);
		free(icount);
		free(prog);

	}
	//逆アセンブラモード
	else if (argc == 3 && strcmp(argv[2],"dass") == 0) {

		FILE *fpw;
		if ((fpw = fopen("dass.txt","w")) == NULL) {
			printf("Error:File open\n");
			return 0;
		}
		while(pc < psize) {
			dassline(prog[pc]);
			fwrite(cline,strlen(cline),1,fpw);
			fwrite("\n",1,1,fpw);
			pc++;
		}
		free(prog);
		fclose(fpw);
	}

//アナライズモード
	else if (argc >= 3 && strcmp(argv[2],"g") == 0) {
		unsigned *callcount;
		unsigned *usecount;
		int *funcstart;
		int *funcdomain;
		char **funcname;
		int fnum;
		int namelen;
		int i,j;
		char buf[200] = {};

	//flagmake
		if (argc == 4) {
			flagmake(atoi(argv[3]));
		}
	//関数データの解釈
		fnum = prog[3];
		if(fnum == 0) {
			printf("This binary is not for analyze.\n");
			return 0;
		}

		aflag = 1;
		funcstart = (int *)malloc(sizeof(unsigned)*psize);
		funcdomain = (int *)malloc(sizeof(unsigned)*psize);
		callcount = (unsigned *)malloc(sizeof(unsigned)*psize);
		usecount = (unsigned *)malloc(sizeof(unsigned)*psize);
		linecount = (unsigned *)malloc(sizeof(unsigned)*psize);

		funcname = (char **)malloc(sizeof(char *) * fnum);
		pc = 4;

		for (i=0;i<psize;i++) {
			funcstart[i] = -1;
			funcdomain[i] = -1;
			callcount[i] = 0;
			usecount[i] = 0;
			linecount[i] = 0;
		}


		for (i=0;i<fnum;i++) {
			funcstart[prog[pc]] = i;
			for (j=prog[pc];j<=prog[pc+1];j++) {
				funcdomain[j] = i;
			}
			pc = pc + 2;
			namelen = prog[pc];
			pc++;
			funcname[i] = (char *)malloc(sizeof(char)*namelen);
			for (j=0;j<=namelen;j++) {
				funcname[i][j] = (char)prog[pc];
				pc++;
			}
		}
	
		pc = 0;
	
	//memory作成
		initmem();
	//I/O Open
		if ((inputfp = fopen("input.bin","rb")) == NULL) {
			inputfp = fopen("input.bin","wb");
            fclose(inputfp);
            inputfp = fopen("input.bin","rb");
		}

		if ((outputfp = fopen("output.bin","wb")) == NULL) {
			printf("Error:Open [output.bin]\n");
			return 0;
		}

	//終端まで実行

		while(pc < psize) {
			execline(prog[pc],inputfp,outputfp);
			pc++;
		}
		
	//解析
		for (pc=0;pc<psize;pc++) {
			if (funcstart[pc] != -1) callcount[funcstart[pc]] = linecount[pc];
			if (funcdomain[pc] != -1) usecount[funcdomain[pc]] += linecount[pc];
		}
		pc = 0;

	//表示
		//関数分析
		FILE *fpf;
		fpf = fopen("_fanalysis.txt","w");
		for (i=0;i<fnum;i++){
			sprintf(buf,"---%s\ncall:%u\ntime:%u\n",funcname[i],callcount[i],usecount[i]);
			fputs(buf,fpf);
		}

		//行分析
		FILE *fpw;
		if ((fpw = fopen("_lanalysis.txt","w")) == NULL) {
			printf("Error:File open\n");
			return 0;
		}
		while(pc < psize) {
			if (funcstart[pc] != -1) {
				sprintf(buf,"---%s:\n",funcname[funcstart[pc]]);
				fputs(buf,fpw);
			}
			dassline(prog[pc]);
			sprintf(buf,"%s\t\t-%u\n",cline,linecount[pc]);
			fputs(buf,fpw);
			pc++;
		}


		
		print_a();
		printreg();
		printf("Exection Count:%llu\n",ecount);
		fclose(fpf);
		fclose(fpw);
		fclose(inputfp);
		fclose(outputfp);
		free(linecount);
		free(funcname);
		free(funcstart);
		free(funcdomain);
		free(maddr);
		free(mtrace);
		free(mtracebody);
		free(icount);
		free(prog);
		
	}

//シミュレートモード
	else {
	//flagmake
		if (argc == 3) {
			flagmake(atoi(argv[2]));
		}

	//memory作成
		initmem();
	//I/O Open
		if ((inputfp = fopen("input.bin","rb")) == NULL) {
			inputfp = fopen("input.bin","wb");
            fclose(inputfp);
            inputfp = fopen("input.bin","rb");
		}

		if ((outputfp = fopen("output.bin","wb")) == NULL) {
			printf("Error:Open [output.bin]\n");
			return 0;
		}

	//終端まで実行

		while(pc < psize) {
			execline(prog[pc],inputfp,outputfp);
			pc++;
		}

		printreg();
		print_a();
		printf("Exection Count:%llu\n",ecount);
		fclose(inputfp);
		fclose(outputfp);
		free(maddr);
		free(mtrace);
		free(mtracebody);
		free(icount);
		free(prog);
	}


	finv_term();


	return 0;
}



