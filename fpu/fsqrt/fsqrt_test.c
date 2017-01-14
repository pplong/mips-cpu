#include <stdio.h>
#include <stdint.h>
#include <math.h>

extern float fsqrt(float x);

union myfloat {
  struct {
    unsigned int fraction : 23;
    unsigned int exponent : 8;
    unsigned int sign : 1;
  };
  float f32;
  uint32_t u32;
};

int main() {
  int j;
  unsigned int i;
  unsigned int diff[17] = {};

  for (i = 0; i < (1U << 31); ++i) {
    union myfloat in, out, ans;
    in.u32 = i;
    if (in.exponent == 0) {
      in.fraction = 0;
    }
    out.f32 = fsqrt(in.f32);
    ans.f32 = sqrtf(in.f32);
    
    int d = out.u32 - ans.u32;
    if (out.exponent == 255 && out.fraction != 0 && ans.exponent == 255 && ans.fraction != 0) {
      d = 0;
    }
    if (d < -8 || d > 8) {
      printf("in: %g(%08x), out: %g, ans: %g\n", in.f32, i, out.f32, ans.f32);
      printf("i  exp: %u, frac: %u\n", in.exponent, in.fraction);
      printf("o  exp: %u, frac: %u\n", out.exponent, out.fraction);
      printf("a  exp: %u, frac: %u\n", ans.exponent, ans.fraction);
      if (d < -8) d = -8;
      else        d = 8;
      while (1);
    }
    ++diff[8 + d];

    if (i % 50000000 == 0) {
      fprintf(stderr, "%u finished\n", i);
    }
  }

  for (j = 0; j < 17; ++j) {
    printf("%2d: %u\n", j - 8, diff[j]);
  }
  return 0;
}
