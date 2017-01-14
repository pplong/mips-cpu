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

float fsqrt_newton(float x) {
  float v = 1.0;
  int lim = 10;
  while (lim--) {
    float vv = v - (v * v - x) / (2 * v);
    if (v == vv) {
      return v;
    }
    v = vv;
  }
  return v;
}

float fsqrt(float x) { // x >= 0.0
  union myfloat in, ans;
  in.f32 = x;

  if (in.exponent == 0 || in.exponent == 255) {
    return x;
  }

  int expo = in.exponent;
  expo -= 127;

  ans.f32 = +0.0;
  ans.fraction = in.fraction;
  ans.exponent = 127;
  if (expo & 1) {
    if (expo > 0) {
      ++ans.exponent;
    } else {
      --ans.exponent;
    }
  }

  expo /= 2;  // CAUTION: Watch out for sign of exponent for assembly implementation.
  ans.f32 = fsqrt_newton(ans.f32);
  ans.exponent += expo;

  return ans.f32;
}

