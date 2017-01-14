#ifndef __FLT_H__
#define __FLT_H__

#include <stdint.h>

typedef union {
  struct {
    unsigned int fraction : 23;
    unsigned int exponent : 8;
    unsigned int sign : 1;
  };
  float f32;
  uint32_t u32;
} myfloat;

extern float PI;

float reduction_2pi(float x);
void kernel_init();
float kernel_sin(float x);
float kernel_cos(float x);
float kernel_atan(float x);

#endif
