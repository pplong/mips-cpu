#include <stdio.h>
#include <stdint.h>

#include "flt.h"

float fcos(float x) {
  myfloat in, ans;
  int sign = 0;

  in.f32 = x;
  in.sign = 0;
  x = in.f32;

  x = reduction_2pi(x);
  if (x >= PI) {
    x -= PI;
    sign ^= 1;
  }
  if (x >= PI / 2) {
    x = PI - x;
    sign ^= 1;
  }
  if (x <= PI / 4) {
    x = kernel_cos(x);
  } else {
    x = PI / 2 - x;
    x = kernel_sin(x);
  }

  ans.f32 = x;
  ans.sign = sign;
  return ans.f32;
}
