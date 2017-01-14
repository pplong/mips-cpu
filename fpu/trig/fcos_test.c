#include <stdio.h>
#include <stdint.h>
#include <math.h>

#include "flt.h"

extern float fcos(float x);

int main() {
  int j;
  unsigned long long i_;
  unsigned int i, diff[65] = {};

  kernel_init();

  for (i_ = 0; i_ < (1ULL << 32); ++i_) {
    i = i_;
    myfloat in, out, ans;
    in.u32 = i;
    if (in.f32 > PI / 4) {
      break;
    }
    if (in.exponent == 0) {
      in.fraction = 0;
    }
    out.f32 = fcos(in.f32);
    ans.f32 = cosf(in.f32);
    
    int d = out.u32 - ans.u32;
    if (out.exponent == 255 && out.fraction != 0 && ans.exponent == 255 && ans.fraction != 0) {
      d = 0;
    }
    if (d < -32 || d > 32) {
      printf("in: %g(%08x), out: %g, ans: %g\n", in.f32, i, out.f32, ans.f32);
      printf("i  exp: %u, frac: %u\n", in.exponent, in.fraction);
      printf("o  exp: %u, frac: %u\n", out.exponent, out.fraction);
      printf("a  exp: %u, frac: %u\n", ans.exponent, ans.fraction);
      if (d < -32) d = -32;
      else         d = 32;
    }
    ++diff[32 + d];

    if (i % 50000000 == 0) {
      fprintf(stderr, "%u finished\n", i);
    }
  }

  for (j = 0; j < 65; ++j) {
    printf("%3d: %u\n", j - 32, diff[j]);
  }
  return 0;
}
