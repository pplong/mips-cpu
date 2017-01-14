#include <stdio.h>
#include <stdint.h>
#include <math.h>

extern float myfloor(float fa);

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
	unsigned long  i;
	union myfloat a,out,ans;
	unsigned long long analysis[17] = {};
	int zure;

	for (i=0;i<=4294967295;i++) {
		a.u32 = (unsigned)i;

		if (a.f32 <= 2147483647.0 && a.f32 >= -2147483648.0) {

			out.f32 = myfloor(a.f32);
			ans.f32 = floorf(a.f32);
		
			zure = ans.i32 ^ out.i32;
			if (zure <= -1) {
				printf("-1:a:%g out:%g ans:%g\n",a.f32,out.f32,ans.f32);

				zure = -1;
			}

			if (zure >= 1) {
				zure = 1;
				printf("1:a:%g out:%g ans:%g\n",a.f32,out.f32,ans.f32);
			}

			zure = zure + 8;
			analysis[zure] = analysis[zure] + 1;
		}

		if (i % 50000000 == 0)
			fprintf(stderr,"%lu finished\n",i);
	}

	int j;
	for (j=0;j<17;j++) {
		printf("%d:%llu\n",j-8,analysis[j]);
	}




	return 0;
}
