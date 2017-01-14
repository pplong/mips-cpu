/*finv本体*/

#include <stdio.h>
#include <stdint.h>
#include <string.h>
#include <stdlib.h>
#include <fcntl.h>
#include <sys/stat.h>
#include <sys/types.h>

/*テーブルのファイルをを読み込む*/
/*読み込んだ文字をuintになおす*/
/*通常の計算
  仮数部のみ値を残す（指数部と符号を分けて考えるため）
  仮数部の上１０文字でtableのindexをチェックできるので対応しているindexのapproaと
  approbを抜き出して計算*/

/*NaN,非正規化数、0の逆数はNaNを返す*/
/*無限のときの逆数は符号を合わせた０を返す*/
/*非正規化数のときの値はデバッグのときのぞくようにしている*/
  


/*符号、指数、仮数の情報を集める******************************************************************/
uint32_t signextract(uint32_t uint1){
  uint1 = uint1 & (1 << 31); /*符号部分以外を０にする*/
  uint1 = uint1 >> 31; /*符号部分を一桁目にもってくる*/
  return uint1;
}

uint32_t exponentextract(uint32_t uint1){
  uint1 = uint1 & (0xff << 23); /*指数部分以外を０にする*/
  uint1 = uint1 >> 23; /*指数部分を右によせる*/
  return uint1;
}

uint32_t fractionextract(uint32_t uint1){
  uint1 = uint1 & 0x7fffff; /*仮数部以外を０にする*/
  return uint1;
}

/*binary型をuint型になおす*******************************************************************/
uint32_t binarytouint(char *s){
  uint32_t answer=0;
  int i;
  for(i=0;i<32;i++){
  if(s[i]=='1'){
    answer=answer+(1<<(31-i));
    }
  }
  return answer;
}

/*テーブルのファイル読み込み********************************************************************/
/*approaの読み込み
 該当行をindexで指定して１行ごとに読みだしていき、上書きして指定行をとりだす*/

const int NUM_ENTRIES = 1024;

uint32_t *read_table(const char* filename) {
  FILE *fp;
  uint32_t *table;
  int i;

  fp = fopen(filename, "r");
  if (fp == NULL) {
    exit(1);
  }

  table = (uint32_t *)malloc(sizeof(uint32_t) * NUM_ENTRIES);
  for (i = 0; i < NUM_ENTRIES; ++i) {
    char buf[40];
    fscanf(fp, "%s", buf);
    table[i] = binarytouint(buf);
  }

  fclose(fp);
  return table;
}

static uint32_t *TBL_APPROA;
static uint32_t *TBL_APPROB;

void finv_init() {
  TBL_APPROA = read_table("approa.txt");
  TBL_APPROB = read_table("approb.txt");
}

void finv_term() {
  free(TBL_APPROA);
  free(TBL_APPROB);
}

/*変換のための共用体の準備********************************************************************/
typedef union float_convert_uint{
  uint32_t uinttype;
  float floattype;
}float_convert_uint;


/*通常の計算部分*****************************************************************************/

uint32_t finv(uint32_t before){
  float fractionans;
  uint32_t sign=signextract(before);
  uint32_t exponent=exponentextract(before);
  uint32_t fraction=fractionextract(before);
  uint32_t fractiononly=fraction|(0x7f<<23);
  uint32_t fractionten=fraction>>13;/*fractionの上10個をとりだす*/
  uint32_t approa=TBL_APPROA[fractionten];
  uint32_t approb=TBL_APPROB[fractionten];
  float_convert_uint unionfu;
  float approaf,approbf;
  uint32_t answer;
  unionfu.uinttype=approa;
  approaf=unionfu.floattype;
  unionfu.uinttype=approb;
  approbf=unionfu.floattype;
  unionfu.uinttype=fractiononly;/*uintをfloatにそれぞれ変換*/
  fractionans=-approaf*unionfu.floattype+approbf;
  if(((exponentextract(before)==255)&(fractionextract(before)!=0))){
	answer=(sign<<31)|0x7fffffff;
  }/*NaNのときNaNを返す*/
  else if((exponentextract(before)==0)) {
    answer = (sign<<31)|(0xff<<23);
  }/*0 のときは INF を返す*/
  else if((exponentextract(before)==255)&(fractionextract(before)==0)){
	answer=(sign<<31)|0x00000000;
  }/*無限大の時、符号を一致させた0を返す*/
  /* else if(fractionans==1){
	unionfu.floattype=fractionans;
	fraction=unionfu.uinttype & (0x7fffff);
	exponent=254-exponent;
	if(exponent==0){
	  answer=(sign<<31)|0x00000000;
	} /*計算結果がオーバーフロー、ゼロをかえす
	else{
	  answer=(sign<<31)|(exponent<<23)|fraction;
	  }
  }/*1の逆数だった場合*/
  else{
	unionfu.floattype=fractionans;
	fraction=unionfu.uinttype & (0x7fffff);
	exponent=254-exponent-1;
	if((exponent==0)|(exponent==-1)){
	  answer=(sign<<31)|0x00000000;
	}/*計算結果がオーバーフロー、ゼロをかえす*/
	else{
	  answer=(sign<<31)|(exponent<<23)|fraction;
	}
  }
  return answer;
}

/******************************************************************************************/

char *makebinary(){
  char *ret = (char*)malloc(sizeof(char)*50);
  int i,j=0;
  //srand(time(NULL));
  for(i=0;i<32;i++){
    int ra=rand()%2;
	//	printf("%d",ra);
    if(ra == 1)
      ret[i] = '1';
    else if(ra == 0)
      ret[i] = '0';
  }
  ret[32] = '\n';
  for(i=33;i<50;i++){
    ret[i] = 0;
  }
  /********************************/
  for(i=1;i<9;i++){
	if(ret[i]=='1'){
	  j=j+1;
	}
  }
  if(j==0){
	ret[2]='1';
  }
  /**デバッグのため（非正規化数の逆数を除く）************/
  return ret;
}
 
char *uinttobinary(uint32_t ui){
  char *ret=(char*)malloc(sizeof(char)*50);
  int i;
  for(i=0;i<32;i++){
    if((ui >> i) & 1u){
      ret[31-i]='1';
    }
    else
      ret[31-i]='0';
  }
  ret[32]='\0';
  return ret;
}

/*
#ifndef FINV_TEST
int main(){
  float_convert_uint temp,temp2;
  srand(time(NULL));
  int i;
  int count[17] = {0};
  int distance;
  int max=0,min=0;
  char my_maxstr[50]={0},my_minstr[50]={0};
  char ans_max[50]={0},ans_min[50]={0};
  char quest_max[50]={0},quest_min[50]={0};

  finv_init();

  for(i=0;i<10000;i++){
    char *random = makebinary();

    uint32_t ux = binarytouint(random);

    temp.uinttype = ux;
    uint32_t finv_answer = temp2.uinttype = finv(ux);
    //  printf("finv     : %s : %f\n",uinttobinary(finv_answer),temp2.ftemp);
    float fx = temp.floattype;
    temp.floattype = 1.0 / fx;
    distance = finv_answer - temp.uinttype;
    if(distance <= -8){
      count[0]++;
    }
    else if(distance >= 8){
      count[16]++;
    }
    else{
      count[distance+8]++;
    }
    if(max < distance){
      max = distance;
      strcpy(my_maxstr,uinttobinary(finv_answer));
      strcpy(ans_max,uinttobinary(temp.uinttype));
	  strcpy(quest_max,random);
    }
    else if(min > distance){
      min = distance;
      strcpy(my_minstr,uinttobinary(finv_answer));
      strcpy(ans_min,uinttobinary(temp.uinttype));
	  strcpy(quest_min,random);
    }
    free(random);
  }
  for(i=0;i<17;i++){
    printf("count[%d] = %d\n",i-8,count[i]);
  }

  printf("max = %d\n",max);
  printf("finv : %s\n",my_maxstr);
  printf("ansx : %s\n",ans_max);
  printf("qmax : %s\n\n",quest_max);
  printf("min = %d\n",min);
  printf("finv : %s\n",my_minstr);
  printf("ansn : %s\n",ans_min);
  printf("qmin : %s\n",quest_min);

  finv_term();

  return 0;
}
#endif
*/

int main(){
  char a[50];
  char *o;
  int i=0;
  FILE *fp;
  fp = fopen("./random_for_read.txt","r");
  if(fp ==NULL){
    fprintf(stderr,"fopen,error\n");
    exit(1);
  }
  int fd=open("random_answer.txt",O_WRONLY | O_CREAT | O_TRUNC,0666);
  for(i=0;i<200000;i++){
    //printf("入力してください\n");
    fscanf(fp,"%s",a);
    o=uinttobinary(finv(binarytouint(a)));
    o[32]='\n';
    //printf("出力は\n%s\n\n",o);
    if(write(fd,o,33)<33){
      fprintf(stderr,"error\n");
      exit(1);
    }
    free(o);
  }
  return 0;
}
