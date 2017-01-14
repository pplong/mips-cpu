#include <stdio.h>
#include <stdint.h>

#include "flt.h"

float fsin(float x) {
  myfloat in, ans;
  int sign;

  in.f32 = x;
  sign = in.sign;
  in.sign = 0;
  x = in.f32;

  x = reduction_2pi(x);
  if (x >= PI) {
    x -= PI;
    sign ^= 1;
  }
  if (x >= PI / 2) {
    x = PI - x;
  }
  if (x <= PI / 4) {
    x = kernel_sin(x);
  } else {
    x = PI / 2 - x;
    x = kernel_cos(x);
  }

  ans.f32 = x;
  ans.sign = sign;
  return ans.f32;
}
