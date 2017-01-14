#include <stdio.h>
#include <stdint.h>

#include "flt.h"

float reduction_2pi(float x) {
  float p = PI * 2;
  while (x >= p) {
    p *= 2;
  }
  while (x >= PI * 2) {
    if (x >= p) {
      x = x - p;
    }
    p /= 2;
  }
  return x;
}
