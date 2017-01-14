#include <stdio.h>
#include <stdint.h>
#include <math.h>
#include <stdlib.h>
#include <time.h>

union myfloat {
	struct {
		unsigned int frc : 23;
		unsigned int exp : 8;
		unsigned int sign : 1;
	};
float f32;
uint32_t u32;
};

unsigned int mypow(unsigned int x,unsigned int y) {
unsigned int ans = 1;

while(y != 0) {
	ans = ans * x;
	y--;
}

return ans;
}

void fw(const void *ptr,FILE *stream) {
	while(fwrite(ptr,4,1,stream) != 1);
}

int main() {
FILE *fp_i1;
FILE *fp_i2;
FILE *fp_o;

int i;
int gap;

srand((unsigned)time(NULL));

union myfloat i1,i2,o;

fp_i1 = fopen("input1.bin","wb");
fp_i2 = fopen("input2.bin","wb");
fp_o = fopen("output.bin","wb");

//(+0)+(+0)
i1.u32 = 0;
i2.u32 = 0;
o.f32 = i1.f32 + i2.f32;
fw(&i1,fp_i1);fw(&i2,fp_i2);fw(&o,fp_o);

//(-0)+(+0)
i1.u32 = 0;i1.sign = 1;
i2.u32 = 0;
o.f32 = i1.f32 + i2.f32;
fw(&i1.u32,fp_i1);fw(&i2.u32,fp_i2);fw(&o.u32,fp_o);

//(+0)+(-0)
i1.u32 = 0;
i2.u32 = 0;i2.sign = 1;
o.f32 = i1.f32 + i2.f32;
fw(&i1.u32,fp_i1);fw(&i2.u32,fp_i2);fw(&o.u32,fp_o);

//(-0)+(-0)
i1.u32 = 0;i1.sign = 1;
i2.u32 = 0;i2.sign = 1;
o.f32 = i1.f32 + i2.f32;
fw(&i1.u32,fp_i1);fw(&i2.u32,fp_i2);fw(&o.u32,fp_o);


//x + NaN
for (i = 0;i<100;i++) {
	i1.sign = rand() % 2;i1.exp = 255;i1.frc = (rand() % 8388606) + 1;
	i2.sign = rand() % 2;i2.exp = (rand() % 254) + 1;i2.frc = rand() % 8388607;
	o.f32 = i1.f32 + i2.f32;
	fw(&i1.u32,fp_i1);fw(&i2.u32,fp_i2);fw(&o.u32,fp_o);
}
for (i = 0;i<100;i++) {
	i2.sign = rand() % 2;i2.exp = 255;i2.frc = (rand() % 8388606) + 1;
	i1.sign = rand() % 2;i1.exp = (rand() % 254) + 1;i1.frc = rand() % 8388607;
	o.f32 = i1.f32 + i2.f32;
	fw(&i1.u32,fp_i1);fw(&i2.u32,fp_i2);fw(&o.u32,fp_o);
}

//NaN + NaN
for (i = 0;i<100;i++) {
	i1.sign = rand() % 2;i1.exp = 255;i1.frc = (rand() % 8388606) + 1;
	i2.sign = rand() % 2;i2.exp = 255;i2.frc = (rand() % 8388606) + 1;
	o.f32 = i1.f32 + i2.f32;
	fw(&i1.u32,fp_i1);fw(&i2.u32,fp_i2);fw(&o.u32,fp_o);
}



//(+INF)+(+INF)
i1.sign = 0;i1.exp = 255;i1.frc = 0;
i2.sign = 0;i2.exp = 255;i2.frc = 0;
o.f32 = i1.f32 + i2.f32;
fw(&i1.u32,fp_i1);fw(&i2.u32,fp_i2);fw(&o.u32,fp_o);
//(-INF)+(-INF)
i1.sign = 1;i1.exp = 255;i1.frc = 0;
i2.sign = 1;i2.exp = 255;i2.frc = 0;
o.f32 = i1.f32 + i2.f32;
fw(&i1.u32,fp_i1);fw(&i2.u32,fp_i2);fw(&o.u32,fp_o);
//(+INF)+(-INF)
i1.sign = 0;i1.exp = 255;i1.frc = 0;
i2.sign = 1;i2.exp = 255;i2.frc = 0;
o.f32 = i1.f32 + i2.f32;
fw(&i1.u32,fp_i1);fw(&i2.u32,fp_i2);fw(&o.u32,fp_o);
//(-INF)+(+INF)
i1.sign = 1;i1.exp = 255;i1.frc = 0;
i2.sign = 0;i2.exp = 255;i2.frc = 0;
o.f32 = i1.f32 + i2.f32;
fw(&i1.u32,fp_i1);fw(&i2.u32,fp_i2);fw(&o.u32,fp_o);



//(INF)+x
for (i = 0;i<100;i++) {
	i1.sign = rand() % 2;i1.exp = (rand() % 255) + 1;i1.frc = rand() % 8388607;
	i2.sign = rand() % 2;i2.exp = 255;i2.frc = 0;
	o.f32 = i1.f32 + i2.f32;
	fw(&i1.u32,fp_i1);fw(&i2.u32,fp_i2);fw(&o.u32,fp_o);
}
for (i = 0;i<100;i++) {
	i2.sign = rand() % 2;i2.exp = (rand() % 255) + 1;i2.frc = rand() % 8388607;
	i1.sign = rand() % 2;i1.exp = 255;i1.frc = 0;
	o.f32 = i1.f32 + i2.f32;
	fw(&i1.u32,fp_i1);fw(&i2.u32,fp_i2);fw(&o.u32,fp_o);
}





//x + 0
for (i = 0;i<1000;i++) {
	i1.sign = rand() % 2;i1.exp = (rand() % 255) + 1;i1.frc = rand() % 8388607;
	i2.sign = rand() % 2;i2.exp = 0;i2.frc = 0;
	o.f32 = i1.f32 + i2.f32;
	fw(&i1.u32,fp_i1);fw(&i2.u32,fp_i2);fw(&o.u32,fp_o);
}
for (i = 0;i<1000;i++) {
	i2.sign = rand() % 2;i2.exp = (rand() % 255) + 1;i2.frc = rand() % 8388607;
	i1.sign = rand() % 2;i1.exp = 0;i1.frc = 0;
	o.f32 = i1.f32 + i2.f32;
	fw(&i1.u32,fp_i1);fw(&i2.u32,fp_i2);fw(&o.u32,fp_o);
}


//x + (-x)
for (i = 0;i<2000;i++) {
	i1.sign = rand() % 2;i1.exp = (rand() % 255) + 1;i1.frc = rand() % 8388607;
	if (i1.sign == 1) {i2.sign = 0;} else {i2.sign = 1;}
	i2.exp = i1.exp;i2.frc = i1.frc;
	o.f32 = i1.f32 + i2.f32;
	fw(&i1.u32,fp_i1);fw(&i2.u32,fp_i2);fw(&o.u32,fp_o);
}



//非正規化数 + 非正規化数
for (i = 0;i<42;i++) {
	i1.sign = rand() % 2;i1.exp = 255;i1.frc = (rand() % 8388606) + 1;
	i2.sign = rand() % 2;i2.exp = 255;i2.frc = (rand() % 8388606) + 1;
	o.f32 = i1.f32 + i2.f32;
	fw(&i1.u32,fp_i1);fw(&i2.u32,fp_i2);fw(&o.u32,fp_o);
}


//正規化数 + 非正規化数
for (i = 0;i<475;i++) {
	i1.sign = rand() % 2;i1.exp = (rand() % 254) + 1;i1.frc = rand() % 8388607;
	i2.sign = rand() % 2;i2.exp = 255;i2.frc = (rand() % 8388606) + 1;
	o.f32 = i1.f32 + i2.f32;
	fw(&i1.u32,fp_i1);fw(&i2.u32,fp_i2);fw(&o.u32,fp_o);
}
for (i = 0;i<475;i++) {
	i2.sign = rand() % 2;i2.exp = (rand() % 254) + 1;i2.frc = rand() % 8388607;
	i1.sign = rand() % 2;i1.exp = 255;i1.frc = (rand() % 8388606) + 1;
	o.f32 = i1.f32 + i2.f32;
	fw(&i1.u32,fp_i1);fw(&i2.u32,fp_i2);fw(&o.u32,fp_o);
}


//例外系のチェック5500cases


//情報落ち

for (i = 0;i<5000;i++) {
	while(1){
		i1.exp = (rand() % 254) + 1;i2.exp = (rand() % 254) + 1;
		if (i1.exp >= i2.exp) {
			if (i1.exp - i2.exp >= 26)
				break;
		}
		else {
			if (i2.exp - i1.exp >= 26)
				break;
		}
	}
	i1.sign = rand() % 2;i1.frc = rand() % 8388607;
	i2.sign = rand() % 2;i2.frc = rand() % 8388607;
	o.f32 = i1.f32 + i2.f32;
	fw(&i1.u32,fp_i1);fw(&i2.u32,fp_i2);fw(&o.u32,fp_o);
}

//オーバーフロー
for (i = 0;i<5000;i++) {

	while(1) {
		i1.sign = rand() % 2;i1.exp = (rand() % 28) + 227;i1.frc = rand() % 8388607;
		i2.sign = i1.sign;i2.exp = (rand() % 28) + 227;i2.frc = rand() % 8388607;
		o.f32 = i1.f32 + i2.f32;
		if (o.exp == 255)
			break;
	}
	fw(&i1.u32,fp_i1);fw(&i2.u32,fp_i2);fw(&o.u32,fp_o);
}

//アンダーフロー
for (i = 0;i<5000;i++) {
	while(1) {
		i1.sign = rand() % 2;i1.exp = (rand() % 254) + 1;i1.frc = rand() % 8388607;
		if (i1.sign == 1) {i2.sign = 0;} else {i2.sign = 1;}
		i2.exp = (rand() % 254) + 1;i2.frc = rand() % 8388607;
		o.f32 = i1.f32 + i2.f32;
		if (i1.exp >= i2.exp) {
			if (i1.exp - i2.exp < 26) {
				if(o.exp == 0)
					break;
			}
		}
		else {
			if (i2.exp - i1.exp < 26) {
				if(o.exp == 0)
					break;
			}
		}
	}
	fw(&i1.u32,fp_i1);fw(&i2.u32,fp_i2);fw(&o.u32,fp_o);
}

//情報落ちしない通常の計算
for (i = 0;i<100000;i++) {
	while(1){
		i1.exp = (rand() % 254) + 1;i2.exp = (rand() % 254) + 1;
		if (i1.exp >= i2.exp) {
			if (i1.exp - i2.exp < 26)
				break;
		}
		else {
			if (i2.exp - i1.exp < 26)
				break;
		}
	}
	i1.sign = rand() % 2;i1.frc = rand() % 8388607;
	i2.sign = rand() % 2;i2.frc = rand() % 8388607;
	o.f32 = i1.f32 + i2.f32;
	fw(&i1.u32,fp_i1);fw(&i2.u32,fp_i2);fw(&o.u32,fp_o);
}

//ガードビットが立つもの
for (i = 0;i<30000;i++) {
	while(1){
		i1.exp = (rand() % 254) + 1;i2.exp = (rand() % 254) + 1;
		if (i1.exp >= i2.exp) {
			if (i1.exp - i2.exp < 26 && i1.exp != i2.exp) {
				gap = i1.exp - i2.exp;
				break;
			}
		}
		else {
			if (i2.exp - i1.exp < 26 && i1.exp != i2.exp) {
				gap = i2.exp - i1.exp;
				break;
			}
		}
	}
	i1.sign = rand() % 2;i1.frc = rand() % 8388607;
	i2.sign = rand() % 2;i2.frc = rand() % 8388607;
	if (i1.f32 >= i2.f32) {
		i2.frc = (i2.frc | mypow(2,gap - 1));
	}
	else {
		i1.frc = (i1.frc | mypow(2,gap - 1));
	}
	o.f32 = i1.f32 + i2.f32;
	fw(&i1.u32,fp_i1);fw(&i2.u32,fp_i2);fw(&o.u32,fp_o);
}

//指数部が同じ
for (i = 0;i<50000;i++) {
	i1.exp = (rand() % 254) + 1;i2.exp = i1.exp;
	i1.sign = rand() % 2;i1.frc = rand() % 8388607;
	i2.sign = rand() % 2;i2.frc = rand() % 8388607;
	o.f32 = i1.f32 + i2.f32;
	fw(&i1.u32,fp_i1);fw(&i2.u32,fp_i2);fw(&o.u32,fp_o);
}

//丸めの結果桁上がり
i1.sign = 0;i1.exp = 16;i1.frc = 4163463;
i2.sign = 0;i2.exp = 15;i2.frc = 61681;
o.f32 = i1.f32 + i2.f32;
fw(&i1.u32,fp_i1);fw(&i2.u32,fp_i2);fw(&o.u32,fp_o);

i1.sign = 1;i1.exp = 130;i1.frc = 2047;
i2.sign = 1;i2.exp = 129;i2.frc = 8384513;
o.f32 = i1.f32 + i2.f32;
fw(&i1.u32,fp_i1);fw(&i2.u32,fp_i2);fw(&o.u32,fp_o);


printf("Success\n");

fclose(fp_i1);
fclose(fp_i2);
fclose(fp_o);

return 0;
}

