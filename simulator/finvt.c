/*テーブル作成方法*/

/*１…float型はシフト演算子が使えないのでuint32_tにする(unionの利用)
  ２…のちに使う2^(-10)の計算をする
  ※…[1.0,2.0)を2^(-10)刻みにする→1024個のindexができる
  ３…indexのはじまりの値を返す関数を作成
  ※…近似は-af+b
  　　aは1/nowindex*nextindex,bは((1/nowindex)^(1/2)+(1/nextindex)^(1/2))^2/2
  ４…aの値を返す関数とbの値を返す関数をつくる
  ５…ファイル書き出しのためにuintをbinaryにする関数を作る(エンディアンもなおす)
  ６…floatをuintになおす関数を作成
  ７…main関数でテーブル作成、ファイル入出力*/

/********************************************************************************/


#include <stdio.h>
#include <stdint.h>
#include <math.h>
#include <stdlib.h>
#include <fcntl.h>
#include <sys/stat.h>
#include <sys/types.h>
#include <unistd.h>
#include <stdlib.h>

/*1**************************************/
typedef union float_convert_uint{
  uint32_t uinttype;
  float floattype;
}float_convert_uint;


/*2**************************************/
double minuspower(){
  int i;
  double answer=1.0;
  for(i=0;i<10;i++){
	answer=answer/2;
  }
  return answer;
}

/*3**************************************/
double indexstart(int index){
  double answer;
  answer=1.0+index*minuspower();
  return answer;
}

/*4**************************************/
double approa(int index){
  double answer;
  answer=1/(indexstart(index)*indexstart(index+1));
  return answer;
}

double approb(int index){
  double answer;
  answer=(sqrt(1/indexstart(index))+sqrt(1/indexstart(index+1)))*(sqrt(1/indexstart(index))+sqrt(1/indexstart(index+1)))/2.0;
  return answer;
}

/*5***************************************/
char *uinttobinary(uint32_t uinta){
  char *answer=(char *)malloc(sizeof(char)*33);
  int i;
  answer[32]='\n';
  for(i=0;i<32;i++){
	if(((uinta>>i)&1)==1){
	  answer[31-i]='1';
	}
	else{
	  answer[31-i]='0';
	}
  }
  return answer;
}

/*6*****************************************/
uint32_t floattouint(float floata){
  uint32_t answer;
  float_convert_uint unionfu;
  unionfu.floattype=floata;
  answer=unionfu.uinttype;
  return answer;
}

/*7*****************************************/
int main(){
  FILE *fp1,*fp2;
  int i;
  char *a,*b;
  if((fp1=fopen("approa.txt","a"))==NULL){
	printf("file open error!!\n");
	exit(1);
  }
  if((fp2=fopen("approb.txt","a"))==NULL){
	printf("file open error!!\n");
	exit(1);/*追加モードでファイルをオープン*/
  }
  for(i=0;i<1024;i++){
	a=uinttobinary(floattouint((float)(approa(i))));
	b=uinttobinary(floattouint((float)(approb(i))));
	fwrite(a,sizeof(char),33,fp1);
	fwrite(b,sizeof(char),33,fp2);
	free(a);
	free(b);
  }
  fclose(fp1);
  fclose(fp2);
  return 0;
}
