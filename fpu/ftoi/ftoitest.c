#include <stdio.h>
#include <stdint.h>


extern int ftoi(float fa);

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

  long myround(float x) {
      if (x >= 0)
         return (long) (x+0.5);
      return (long) (x-0.5);
   }


int main() {
	unsigned long  i;
	union myfloat a,out,ans;
	unsigned long long analysis[17] = {};
	int zure;

	for (i=0;i<=4294967295;i++) {
		a.u32 = (unsigned)i;

		if (a.f32 <= 2147483647.0 && a.f32 >= -2147483648.0) {

			out.i32 = ftoi(a.f32);
			ans.i32 = myround(a.f32);
		
			zure = ans.i32 - out.i32;
			if (zure <= -1) {
				printf("-1:a:%f out:%d ans:%d\n",a.f32,out.i32,ans.i32);

				zure = -1;
			}

			if (zure >= 1) {
				zure = 1;
				printf("1:a:%f out:%d ans:%d\n",a.f32,out.i32,ans.i32);
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
