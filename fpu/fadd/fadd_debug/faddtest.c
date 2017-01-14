#include <stdio.h>
#include <stdint.h>
#include <math.h>
#include <signal.h>

uint32_t fadd(uint32_t a,uint32_t b);

union myfloat {
	struct {
		unsigned int frc : 23;
		unsigned int exp : 8;
		unsigned int sign : 1;
	};

uint32_t u32;
};

void fr(void *buf,FILE *fp){
while(fread(buf,4,1,fp) != 1);
}

int main() {



FILE *fp_i1;
FILE *fp_i2;
FILE *fp_o;

unsigned int i;
int cnt = 0;

union myfloat i1,i2,o,ans;

fp_i1 = fopen("input1.bin","rb");
fp_i2 = fopen("input2.bin","rb");
fp_o = fopen("output.bin","rb");

for(i=0;i<200502;i++) {

	fr(&i1.u32,fp_i1);
	fr(&i2.u32,fp_i2);
	fr(&o.u32,fp_o);

	ans.u32 = fadd(i1.u32,i2.u32);

	//NaNが返るときは、frcを8388607としておく
	if (o.exp == 255 && o.frc != 0) {
		o.sign = 0;
		o.frc = 8388607;
	}	

	//Subnormal は +zeroとみなす(-0を+0にしないように注意)
	if (o.exp == 0 && !(o.sign == 1 && o.exp == 0 && o.frc == 0)) {
		o.sign = 0;
		o.frc = 0;
	}

	if (ans.u32 != o.u32) {
		printf("NG:\n");
		printf("%u + %u:output:%u answer:%u\n",i1.u32,i2.u32,ans.u32,o.u32);
	}
	else {
		cnt++;
	}

}

printf("Test Finished:%d cases\n",cnt);

fclose(fp_i1);
fclose(fp_i2);
fclose(fp_o);

return 0;
}
