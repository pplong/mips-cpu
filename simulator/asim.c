#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <math.h>
#include "regdef.h"

extern void finv_init();
extern void finv_term();

extern void kernel_init();
extern float fsin(float x);
extern float fcos(float x);
extern float fatan(float x);

extern float fsqrt(float x);

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


void printreg() {
	int i,j;
	for (i=0;i<32;i=i+8) {
		for (j=0;j<8;j++) {
			printf("r%02d:%-4d ",i+j,r[i+j]);
		}
		printf("\n");
	}
	for (i=0;i<32;i=i+8) {
		for (j=0;j<8;j++) {
			printf("f%02d:%-4.2f ",i+j,f[i+j]);
		}
		printf("\n");
	}
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


unsigned trans_endian(unsigned x) {
	return (x << 24) | (x << 8 & 0x00ff0000) | (x >> 8 & 0x0000ff00) | (x >> 24);
}


void reginit() {
	int i;
	for (i=0;i<=31;i++) {
		r[i] = 0;
		f[i] = 0;
	}
}


//本体
int main(int argc,char *argv[]) {
	unsigned psize = 0;
	unsigned line;
	FILE *inputfp;
	FILE *outputfp;
	unsigned long i;
	int j;
	long long analysis[17] = {};
	int zure;

//def
	myfloat out,ans;


//引数の個数
	if (argc != 2 && argc != 3) {
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
		memset(prog,0,PROGSIZE);
		fread(&line,sizeof(int),1,fp);
		while(1) {
			if (fread(&line,sizeof(int),1,fp) == 0)
				break;
			prog[psize] = trans_endian(line);
			psize++;
		}
	}

//memory作成
	initmem();

	finv_init();


//メインループ
	for (i=0;i<=4294967295;i++) {

	//レジスタ初期化	
		reginit();

		r[2] = i;
		ans.f32 = (float)(i);


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
		while(pc <= psize) {
			execline(prog[pc],inputfp,outputfp);
			pc++;
		}

		out.f32 = f[0];

		zure = (ans.u32 ^ out.u32);
		if (zure <= -1) {
			printf("-1:a:%d out:%f ans:%f\n",i,out.f32,ans.f32);
			zure = -1;
		}
		if (zure >= 1) {
			zure = 1;
			printf("1:a:%d out:%f ans:%f\n",i,out.f32,ans.f32);
		}
		zure = zure + 8;
		analysis[zure] = analysis[zure] + 1;

		if (i % 5000000 == 0) {
			printf("%lu finished\n",i);
		}

		pc = 0;
		for(j=0;j<INUM;j++) {
			icount[j] = 0;
		}
		fclose(inputfp);
		fclose(outputfp);
	}


	for (j=0;j<17;j++) {
		printf("%d:%lld\n",j-8,analysis[j]);
	}


	free(maddr);
	free(mtrace);
	free(mtracebody);
	free(icount);
	free(prog);

	finv_term();


	return 0;
}



