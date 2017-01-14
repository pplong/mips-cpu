#include <stdio.h>
#include <stdint.h>

#include "flt.h"

float fatan(float x) {
  myfloat in, ans;
  int sign;

  in.f32 = x;
  sign = in.sign;
  in.sign = 0;
  x = in.f32;

  if (x < 0.4375) { // 0x3ee00000
    x = kernel_atan(x);
  } else if (x < 2.4375) { // 0x401c0000
    x = PI / 4 + kernel_atan((x - 1.0) / (x + 1.0));
  } else {
    x = PI / 2 - kernel_atan(1.0 / x);
  }

  ans.f32 = x;
  ans.sign = sign;
  return ans.f32;
}
