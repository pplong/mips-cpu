#include <stdio.h>
#include <stdint.h>

union myfloat {
	struct {
		unsigned int fraction : 23;
		unsigned int exponent : 8;
		unsigned int sign : 1;
	};
float f32;
uint32_t u32;
};



float itof(int a) {
	int sign = 0;
	unsigned abs = a;
	if (a < 0) {
		sign = 1;
		abs = -1*(unsigned)a;
	}



//Case1:a<8388608
	if (abs <= 8388608) {
		union myfloat ans,c;
		ans.u32 = abs + 0x4b000000;
		c.u32 = 0x4b000000;

		ans.f32 = ans.f32 - c.f32;
		ans.sign = sign;
		return ans.f32;
	}
//Case2:a>=8388608
	else {
		int i;
		union myfloat ans,ans1,ans2,c;
		unsigned m = abs / 8388608;
		c.u32 = 0x4b000000;

		ans1.u32 = 0;
		for (i=0;i<m;i++) {
			ans1.f32 = ans1.f32 + c.f32;
		}
//		printf("%.300f\n",ans1.f32);

		ans2.u32 = (abs % 8388608) + 0x4b000000;
		ans2.f32 = ans2.f32 - c.f32;
//		printf("%.300f\n",ans2.f32);

		ans.f32 = ans1.f32 + ans2.f32;
		ans.sign = sign;
		return ans.f32;
	}



}


/*
int main() {
	int a = -1;
	printf("%.300f\n",itof(a));
	return 0;
}
*/

