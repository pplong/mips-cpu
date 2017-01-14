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
		char bufin[100];
		memset(bufin,0,sizeof(char)*30);
		char bufd[2000];
		memset(bufd,0,sizeof(char)*2000);
		char bufl[50];
		memset(bufl,0,sizeof(char)*50);

		int regtrace[32];
		int fregtrace[32];
		int regtracebody[32];
		float fregtracebody[32];
		int i,j,ii,jj;

		int regnum;
		int regbody;
		float fregbody;
		int matigai = 0;
		unsigned execnum = 1;
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


	//reg入力Read
		FILE *fpin;
		if ((fpin = fopen("in.txt","r")) == NULL) {
			printf("Error:Open [in.txt]\n");
			return 0;
		}
		
		FILE *fpans;
		if ((fpans = fopen("ans.txt","r")) == NULL) {
			printf("Error:Open [out.txt]\n");
			return 0;
		}




//メインループ
	while(1) {
	
	//レジスタ初期化	
		reginit();

	if(feof(fpin) != 0)
		break;


	i = 0;j = 0;
	//fpinからread
	while(1){
		if(fscanf(fpin,"r%d %d\n",&regnum,&regbody) != 0) {
			r[regnum] = regbody;
			regtrace[i] = regnum;
			regtracebody[i] = regbody;
			i++;
		}	
		else if(fscanf(fpin,"f%d %f\n",&regnum,&fregbody) != 0) {
			f[regnum] = fregbody;
			fregtrace[j] = regnum;
			fregtracebody[j] = fregbody;
			j++;
		}
		else {
			fscanf(fpin,"#\n");
			break;
		}
	}



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


	//fpansからread
		while(1){
			if(fscanf(fpans,"r%d %d\n",&regnum,&regbody) != 0) {
				if(r[regnum] != regbody) {
					sprintf(bufl,"r[%d] sim:%d ans:%d\n",regnum,r[regnum],regbody);
					strcat(bufd,bufl);
					matigai = 1;
				}
			}	
			else if(fscanf(fpans,"f%d %f\n",&regnum,&fregbody) != 0) {
				if (f[regnum] != fregbody) {
					sprintf(bufl,"f[%d] sim:%f ans:%f\n",regnum,f[regnum],fregbody);
					strcat(bufd,bufl);
					matigai = 1;
				}
			}
			else {
				fscanf(fpans,"#\n");
				sprintf(bufl,"\n");
				strcat(bufd,bufl);				
				break;
			}
		}


		if (matigai == 0) {
			printf("%u:OK\n",execnum);
		}
		else {
			printf("%u:Failed...\n",execnum);
			printf("--input\n");
			
			for(ii=0;ii<i;ii++) {
				printf("r[%d] = %d\n",regtrace[ii],regtracebody[ii]);
			}
			for(jj=0;jj<j;jj++) {
				printf("f[%d] = %f\n",fregtrace[jj],fregtracebody[jj]);
			}

			printf("--diff\n");
			printf("%s",bufd);

			if (argc == 3 && strcmp(argv[2],"p") == 0)
				printreg();
		}

		fclose(inputfp);
		fclose(outputfp);
		pc = 0;
		matigai = 0;
		memset(bufd,0,strlen(bufd));
		memset(bufl,0,strlen(bufl));



		execnum++;


	}




		free(maddr);
		free(mtrace);
		free(mtracebody);
		free(icount);
		free(prog);

		finv_term();


	return 0;
}



