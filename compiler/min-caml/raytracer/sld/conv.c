#include <stdio.h>
#include <stdint.h>

int buf_ptr;
unsigned char buf[65536];

void write_buf(uint32_t x) {
  buf[buf_ptr++] = x >> 24;
  buf[buf_ptr++] = (x >> 16) & 255;
  buf[buf_ptr++] = (x >> 8) & 255;
  buf[buf_ptr++] = x & 255;
}

void read_float() {
  union {
    float f;
    uint32_t u;
  } x;
  scanf("%f", &x.f);
  write_buf(x.u);
}

int read_int() {
  union {
    int32_t i;
    uint32_t u;
  } x;
  scanf("%d", &x.i);
  write_buf(x.u);
  return x.i;
}

int read_int_seq() {
  int res = 0;
  while (read_int() != -1) {
    ++res;
  }
  return res;
}

int main() {
  int i;
  buf_ptr = 0;

  for (i = 0; i < 5; ++i) {
    read_float();
  }
  read_int();
  read_float();
  read_float();
  read_float();

  while (1) {
    if (read_int() == -1) {
      break;
    }
    int num = 12;
    read_int();
    read_int();
    if (read_int() != 0) {
      fprintf(stderr, "rot_p must be fixed to 0\n");
      num = 15;
    }
    for (i = 0; i < num; ++i) {
      read_float();
    }
  }

  for (i = 0; i < 2; ++i) {
    while (read_int_seq() != 0) ;
  }

  fwrite(buf, 1, buf_ptr, stdout);

  return 0;
}
