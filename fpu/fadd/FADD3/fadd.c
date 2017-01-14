/*VHDLにするためにfor文とwhile文はなるべくないように*/

#include <stdio.h>
#include <stdint.h>
#include <string.h>
#include <stdlib.h>
#include <fcntl.h>
#include <sys/stat.h>
#include <sys/types.h>

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


/*NaNとinfの判断********************************************************************************/
int NaNtf(uint32_t uint1){
  if((exponentextract(uint1)==0xff)&&(fractionextract(uint1)!=0)){
	return 1;/*true*/
  }
  else{
	return 0;/*false*/
  }
}

int inftf(uint32_t uint1){
  if((exponentextract(uint1)==0xff)&&(fractionextract(uint1)==0)){
	return 1;/*true*/
  }
  else{
	return 0;/*false*/
  }
}


/************************************************************************************************/
uint32_t fadd(uint32_t uint1, uint32_t uint2){

/*特殊な値を返す場合***************************************/
  if((NaNtf(uint1)==1)||(NaNtf(uint2)==1)){
	return 0xfff00000;
  }/*どちらでもNaNだったらNaNをかえす*/
  if((inftf(uint1)==1)&&(inftf(uint2)==1)){
	if(signextract(uint1)==signextract(uint2)){
	  return uint1;
	}/*無限の符号が同じ時*/
	else{
	  return 0xfff00000;
	}/*無限の符号が違う時*/
  }
  if(inftf(uint1)==1){
	return uint1;/*どちらかが無限*/
  }
  if(inftf(uint2)==1){
	return uint2;/*どちらかが無限*/
  }
	

/*非正規化数の場合(０とみなす)*******************************/
  if(exponentextract(uint1)==0&&exponentextract(uint2)==0){
	if((uint1 & 0x7fffffff)>(uint2 & 0x7fffffff)){
	  return (signextract(uint1)<<31);
	}
	else{
	  return (signextract(uint2)<<31);
	}
  }
  if(exponentextract(uint1)==0){
	return uint2;
  }
  if(exponentextract(uint2)==0){
	return uint1;
  }
	  
/*通常の計算************************************************/
  if((uint1&0x7fffffff)>(uint2&0x7fffffff)){
	uint32_t temp;
	temp=uint1;
	uint1=uint2;
	uint2=temp;
  }/*uint1よりuint2のほうが大きい値になるようにふたつの引数を並び替える*/

  if(exponentextract(uint2)-exponentextract(uint1)>=26){
	return uint2;
  }/*２つの引数の指数部の値が26(23+3←丸め誤差分)以上離れているときは無視できるとする*/
  
  uint32_t fractionuint1,fractionuint2,fractionuint3,exponentuint1,exponentuint2,exponentuint3,signuint3,i=0,j=0,uint3;
  fractionuint1=fractionextract(uint1);
  fractionuint2=fractionextract(uint2);
  exponentuint1=exponentextract(uint1);
  exponentuint2=exponentextract(uint2);

  fractionuint1=(1<<26)|(fractionuint1<<3);
  fractionuint2=(1<<26)|(fractionuint2<<3);/*丸めや計算のために仮数部分を広げる(1[仮数]000)*/

  fractionuint3=fractionuint1;
  for(i=0;i<(exponentuint2-exponentuint1);i++){
	j=(fractionuint3&1)|j;
	fractionuint3=fractionuint3>>1;/*uint1の捨てられる部分に１はあるか*/
	/*---------for文使用注意-------------*/
  }
  fractionuint1=fractionuint1>>(exponentuint2-exponentuint1);/*uint2の指数部分にuint1の指数部分をあわせる*/
  
  signuint3=signextract(uint2);
  exponentuint3=exponentuint2;
  i=0;
  
  if(signextract(uint1)==signextract(uint2)){
	fractionuint3=fractionuint1+fractionuint2;
	fractionuint3=fractionuint3|j;
	if((fractionuint3>>27)==1){
	  exponentuint3=exponentuint3+1;
	  fractionuint3=(fractionuint3>>1)|(fractionuint3&1);
	}
  }/*符号が一致しているときの計算＆正規化*/

  if(signextract(uint1)!=signextract(uint2)){
	fractionuint3=fractionuint2-(fractionuint1|j);
	while((fractionuint3>>26)==0&&i!=26){
	  fractionuint3=fractionuint3<<1;
	  exponentuint3=exponentuint3-1;
	  if(exponentuint3==0){
		break;
	  }
	  i=i+1;
	}
	if(i==26){
	  return signextract(uint2)<<31;
	}
  }/*符号が異なるときの計算＆正規化*/
  
  if((fractionuint3&4)&&(fractionuint3&11)){
	fractionuint3=fractionuint3+8;
	if(fractionuint3>>27==1){
	  exponentuint3=exponentuint3+1;
	  fractionuint3=fractionuint3>>1;
	}
  }
  fractionuint3=(fractionuint3>>3)&0x7fffff;/*fractionの部分の値をみて丸める(最近接偶数丸め)*/
 
  if(exponentuint3>=255){
	uint3=(signuint3<<31)|0x7f800000;
	return uint3;
  }/*オーバーフロー*/

  if(exponentuint3<=0){
	uint3=(signuint3<<31);
	return uint3;
  }/*アンダーフロー*/

  uint3=(signuint3<<31)|(exponentuint3<<23)|(fractionuint3);
  return uint3;
}

/****************************************************************以下チェック用**********************************/

char *uinttobinary(uint32_t ui){
  char *ret=(char*)malloc(sizeof(char)*50);
  int i=0;
  for(i=0;i<32;i++){
	if((ui >> i)& 1u){
	  ret[31-i]='1';
	}
	else
	  ret[31-i]='0';
  }
  ret[32]='\0';
  return ret;
}

uint32_t binarytouint(char *bin){
  uint32_t ret =0;
  uint32_t temp=1u;
  int i=0;
  for(i=0;i<32;i++){
	if(bin[31-i]=='1'){
	  ret += temp << i;
	}
  }
  return ret;
}

int main(){
  char a[50];
  char b[50];
  char *o;
  int i=0;
  FILE *fp;
  fp = fopen("./random_for_read.txt","r");
  if(fp ==NULL){
    fprintf(stderr,"fopen,error\n");
    exit(1);
  }
  int fd=open("random_answer.txt",O_WRONLY | O_CREAT | O_TRUNC,0666);
  for(i=0;i<100000;i++){
    //printf("入力してください\n");
    fscanf(fp,"%s",a);
    fscanf(fp,"%s",b);
    o=uinttobinary(fadd(binarytouint(a),binarytouint(b)));
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
