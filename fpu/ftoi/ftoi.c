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



int ftoi(float fa) {
	int sign,ians;
	union myfloat abs,c,ans,r;
	unsigned ri;
	abs.f32 = fa;
	sign = abs.sign;
	abs.sign = 0;
	c.u32 = 0x4b000000;

//Case1:abs<8388608.0
	if (abs.f32 < c.f32) {
		ans.f32 = abs.f32 + c.f32;

	    ans.u32 = ans.u32 - 0x4b000000;
		ians = ans.u32;
		if (sign == 1) 
			ians = -ians;

		return ians;
	}
//Case2:a>=8388608
	else {
		union myfloat ans1,ans2;
		int i;

		ri = 1073741824;
		r.u32 = 0x4E800000;
		ans1.u32 = 0;
		while(1) {
			if (abs.f32 < c.f32)
				break;
			
			if (abs.f32 >= r.f32) {
				abs.f32 = abs.f32 - r.f32;
				ans1.u32 = ans1.u32 + ri;
			}
			ri = ri / 2;
			r.u32 = r.u32 - 0x800000;
		}


//		printf("%.300f\n",ans1.f32);

		ans2.f32 = abs.f32 + c.f32;
		ans2.u32 = ans2.u32 - 0x4b000000;
//		printf("%.300f\n",ans2.f32);
		ians = ans1.u32 + ans2.u32;

		if (sign == 1)
			ians = -ians;

		return ians;
	}



}


/*
int main() {
	int a = -0.502288;
	printf("%d\n",ftoi(0.5));
	return 0;
}

*/
