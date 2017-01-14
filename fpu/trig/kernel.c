#include <stdio.h>
#include <stdint.h>

#include "flt.h"

static float from_u32(uint32_t u) {
  myfloat x;
  x.u32 = u;
  return x.f32;
}

static float S3, S5, S7;
static float C0, C2, C4, C6;
static float A3, A5, A7, A9, A11, A13;
float PI;

void kernel_init() {
  S3 = from_u32(0xbe2aaaac);
  S5 = from_u32(0x3c088666);
  S7 = from_u32(0xb94d64b6);
  C0 = 1.0;
  C2 = -0.5;
  C4 = from_u32(0x3d2aa789);
  C6 = from_u32(0xbab38106);
  PI = from_u32(0x40490fdb);
  A3 = from_u32(0xbeaaaaaa);
  A5 = from_u32(0x3e4ccccd);
  A7 = from_u32(0xbe124925);
  A9 = from_u32(0x3de38e38);
  A11= from_u32(0xbdb7d66e);
  A13= from_u32(0x3d75e7c5);
}

float kernel_sin(float x) {
  float p = x * x;
  return x * (1.0f + p * (S3 + p * (S5 + S7 * p)));
}

float kernel_cos(float x) {
  float p = x * x;
  return C0 + p * (C2 + p * (C4 + C6 * p));
}

float kernel_atan(float x) {
  float p = x * x;
  return x * (1.0f + p * (A3 + p * (A5 + p * (A7 + p * (A9 + p * (A11 + A13 * p))))));
}
