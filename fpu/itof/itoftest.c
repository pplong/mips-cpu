#include <stdio.h>
#include <stdint.h>

extern float itof(int a);

union myfloat {
	struct {
		unsigned int fraction : 23;
		unsigned int exponent : 8;
		unsigned int sign : 1;
	};
float f32;
int i32;
uint32_t u32;
};


int main() {
	unsigned long i;
	union myfloat a,out,ans;
	long long analysis[17] = {};
	int zure;

	for (i=0;i<=4294967295;i++) {
		a.u32 = (unsigned)i;
		out.f32 = itof(a.i32);
		ans.f32 = (float)(a.i32);
	
		zure = (ans.u32 ^ out.u32);
		if (zure <= -8) {
			printf("-8:a:%d out:%f ans:%f\n",a.i32,out.f32,ans.f32);
			zure = -8;
		}
		if (zure >= 8) {
			zure = 8;
			printf("8:a:%d out:%f ans:%f\n",a.u32,out.f32,ans.f32);
		}
		zure = zure + 8;
		analysis[zure] = analysis[zure] + 1;

		if (i % 50000000 == 0)
			printf("%lu finished\n",i);
	}

	int j;
	for (j=0;j<17;j++) {
		printf("%d:%lld\n",j-8,analysis[j]);
	}




	return 0;
}
