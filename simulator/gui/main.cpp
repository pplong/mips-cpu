#include "mainwindow.h"
#include <QApplication>

#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include "regdef.h"

#define MTSIZE 10000
#define INUM 29

extern void execline(FILE *fp,FILE *inputfp,FILE *outputfp,unsigned line);
extern void dassline(unsigned line);

/* Register Define */

//register
int r[32] = {};
float f[32] = {};
long pc = 0;
unsigned *maddr;
unsigned *mtrace;
int *mtracebody;
unsigned mtnum = 0;
unsigned ecount = 0;
unsigned *icount;

int bpoint = 0;
char cline[30] = {};

char fname[50];
char aname[50];
char *prog;
char *out1;
unsigned stepline;
long int steplnum;
long int inpc = 0;


//lineの型
rtype urtype;
itype uitype;
jtype ujtype;
frtype ufrtype;
fitype ufitype;


void printreg(char *out) {
    int i,j;
    char buf[100];
    for (i=0;i<32;i=i+8) {
        for (j=0;j<8;j++) {
            printf("r%02d:%-4d ",i+j,r[i+j]);
            sprintf(buf,"r%02d:%-4d ",i+j,r[i+j]);
            strcat(out,buf);
        }
        printf("\n");
        sprintf(buf,"\n");
        strcat(out,buf);
    }
    for (i=0;i<32;i=i+8) {
        for (j=0;j<8;j++) {
            printf("f%02d:%-4.2f ",i+j,f[i+j]);
            sprintf(buf,"f%02d:%-4.2f ",i+j,f[i+j]);
            strcat(out,buf);
        }
        printf("\n");
        sprintf(buf,"\n");
        strcat(out,buf);
    }

}




unsigned trans_endian(unsigned x) {
    return (x << 24) | (x << 8 & 0x00ff0000) | (x >> 8 & 0x0000ff00) | (x >> 24);
}


void reginit() {
//memory作成
    int i;

    maddr = (unsigned *)malloc(sizeof(int) * 1048576);
    mtrace = (unsigned *)malloc(sizeof(int) * MTSIZE);
    mtracebody = (int *)malloc(sizeof(int)*MTSIZE);
    icount = (unsigned *)malloc(sizeof(int)*INUM);

    for(i=0;i<INUM;i++) {
        icount[i] = 0;
    }
}

void cntinit() {
    memset(maddr,0,sizeof(int)*1048576);
    memset(mtrace,0,sizeof(int)*mtnum);
    memset(mtracebody,0,sizeof(int)*mtnum);
    memset(icount,0,sizeof(int)*INUM);
    ecount=0;
    mtnum=0;
    memset(r,0,sizeof(int)*32);
    memset(f,0,sizeof(float)*32);
}


void execmode() {
        ecount = 0;
        pc = 0;
    //バイナリをオープン
        FILE *fp;
        FILE *inputfp;
        FILE *outputfp;
        char buf[100] ={};
        unsigned line;
        if ((inputfp = fopen("input.bin","rb")) == NULL) {
            inputfp = fopen("input.bin","wb");
            fclose(inputfp);
            inputfp = fopen("input.bin","rb");
        }
        else if ((outputfp = fopen("output.bin","wb")) == NULL) {
            printf("Error:Open [output.bin]\n");
        }
        if ((fp = fopen(fname,"rb")) == NULL) {
            printf("Error:File open\n");
            sprintf(out1,"Error:File open\n");
        }
        else {
            fread(&line,sizeof(int),1,fp);
            pc = ftell(fp);
    //バイナリを終端まで読みつつ行ごとに実行
         while(1) {
              if (fread(&line,sizeof(int),1,fp) == 0)
                 break;
                  execline(fp,inputfp,outputfp,trans_endian(line));
                  pc = ftell(fp);
           }

            printreg(out1);
            printf("Exection Count:%u\n",ecount);
            sprintf(buf,"Exection Count:%u\n",ecount);
            strcat(out1,buf);
            fclose(fp);
            fclose(inputfp);
            fclose(outputfp);
            pc = 0;
        }
}

void dasmode() {
    FILE *fp;
    FILE *fpw;
    unsigned line;
    if ((fp = fopen(fname,"rb")) == NULL) {
        printf("Error:File open\n");
        sprintf(out1,"Error:File open\n");
    }
    else if ((fpw = fopen(aname,"w")) == NULL) {
        printf("Error:File open\n");
        sprintf(out1,"Error:File open\n");
    }
    else {
        fread(&line,sizeof(int),1,fp);
        pc = ftell(fp);
        while(1) {
            if (fread(&line,sizeof(int),1,fp) == 0)
                break;
            dassline(trans_endian(line));
            fwrite(cline,strlen(cline),1,fpw);
            fwrite("\n",1,1,fpw);
        }
    }
    sprintf(out1,"Completed");

fclose(fp);
fclose(fpw);
}

void dasmode2() {
    FILE *stepfp;
    char lno[8];
    unsigned line;
    if ((stepfp = fopen(fname,"rb")) == NULL) {
        printf("Error:File open\n");
        sprintf(prog,"Error:File open\n");
    }
    else {
        fread(&line,sizeof(int),1,stepfp);
        while(1) {
            if (fread(&line,sizeof(int),1,stepfp) == 0)
                break;
            pc = ftell(stepfp);
            sprintf(lno,"%02ld:",(pc-8)/4);
            strcat(prog,lno);
            dassline(trans_endian(line));
            strcat(cline,"\n");
            strcat(prog,cline);
        }
        fclose(stepfp);
    }


}


int main(int argc, char *argv[])
{
    QApplication a(argc, argv);
    MainWindow w;
    w.show();

    return a.exec();
}
