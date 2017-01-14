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

extern float itof(int a);
extern int ftoi(float fa);


float myfloor(float fa) {
	union myfloat ans,c;
	float fb;
	ans.f32 = fa;
	int sign = ans.sign;
	ans.sign = 0;
	c.u32 = 0x4b000000;

	if(ans.f32 < c.f32) {
		fb = itof(ftoi(fa));

		if (fb - 1.0f < fa && fa  < fb) {
			ans.f32 = fb - 1.0f;
		}
		else {
			ans.f32 = fb;
		}

	}

	ans.sign = sign;

	return ans.f32;
}


/*
int main() {
	int a = -0.502288;
	printf("%d\n",ftoi(0.5));
	return 0;
}

*/
