/* 
 * finv.c の全数検査
 *
 * コンパイル
 * $ gcc -o test_all -O2 -DFINV_TEST test_all.c finv.c
 *
 * 実行（数十秒〜数分かかります）
 * $ ./test_all > result.txt
 */

#include "finv.h"

#include <stdio.h>
#include <stdint.h>

void print_uint32(uint32_t x) {
  int i;
  for (i = 31; i >= 0; --i) {
    putchar('0' + ((x >> i) & 1));
  }
}

uint32_t sign(uint32_t v) {
  return v >> 31;
}

uint32_t expo(uint32_t v) {
  return (v >> 23) & 0xff;
}

uint32_t frac(uint32_t v) {
  return v & ((1 << 23) - 1);
}

typedef union {
  float x;
  uint32_t bits;
} float_t;

uint32_t to_uint32(float x) {
  float_t t;
  t.x = x;
  return t.bits;
}

float from_uint32(uint32_t x) {
  float_t t;
  t.bits = x;
  return expo(x) == 0 ? (sign(x) ? -0.0f : 0.0f) : t.x;
}

int isnan(uint32_t v) {
  return (expo(v) == 255) && (frac(v) != 0);
}

int nan_correct = 0, nan_diff = 0, sign_diff = 0, exp_diff = 0;
int denormal_correct = 0, denormal_incorrect = 0;
uint32_t diff_distr[17] = {};

const int MAX_CASE_SAVED = 10;
typedef struct {
  int cnt;
  uint32_t in[MAX_CASE_SAVED], out[MAX_CASE_SAVED], ans[MAX_CASE_SAVED];
} diff_history;

diff_history nan_hist, sign_hist, exp_hist, frac_big_hist, frac_small_hist;

void history_add(diff_history* hist, uint32_t in, uint32_t out, uint32_t ans) {
  if (hist->cnt == MAX_CASE_SAVED) {
    return;
  }
  hist->in[hist->cnt] = in;
  hist->out[hist->cnt] = out;
  hist->ans[hist->cnt] = ans;
  ++hist->cnt;
}

void history_print(diff_history* hist) {
  int i;
  for (i = 0; i < hist->cnt; ++i) {
    printf("[case %d]\n", i + 1);
    printf("   in: "); print_uint32(hist->in[i]); puts("");
    printf("  out: "); print_uint32(hist->out[i]); puts("");
    printf("  ans: "); print_uint32(hist->ans[i]); puts("");
  }
}

void check_diff(uint32_t x, uint32_t ansx, uint32_t invx) {
  if (isnan(ansx) != isnan(invx)) {
    ++nan_diff;
    history_add(&nan_hist, x, invx, ansx);
    return;
  }

  if (isnan(ansx) && isnan(invx)) {
    ++nan_correct;
    return;
  }

  if (sign(ansx) != sign(invx)) {
    ++sign_diff;
    history_add(&sign_hist, x, invx, ansx);
    return;
  }

  if ((int)expo(ansx) - (int)expo(invx) >= 2 ||
      (int)expo(ansx) - (int)expo(invx) <= -2) {
    ++exp_diff;
    history_add(&exp_hist, x, invx, ansx);
    return;
  }

  if (expo(ansx) == 0) {
    if (expo(invx) == 0 && frac(invx) == 0) {
      ++denormal_correct;
    } else {
      ++denormal_incorrect;
    }
    return;
  }

  int diff = invx - ansx;
  if (diff > 8) {
    history_add(&frac_big_hist, x, invx, ansx);
    diff = 8;
  }
  if (diff < -8) {
    history_add(&frac_small_hist, x, invx, ansx);
    diff = -8;
  }
  ++diff_distr[8 + diff];
}

int main() {
  int i;
  uint32_t x;

  finv_init();

  x = 0;
  do {
    uint32_t invx = finv(x);
    uint32_t ansx = to_uint32(1.0f / from_uint32(x));
    check_diff(x, ansx, invx);
    ++x;
    if ((x & 0x00ffffff) == 0x00ffffff) {
      fprintf(stderr, "progress ... %u / %u\n", x >> 24, 255);
    }
  } while (x != 0xffffffff);

  finv_term();

  puts("***** finv all test summary *****\n");
  printf("#nan  differs: %d\n", nan_diff);
  printf("#nan  correct: %d\n", nan_correct);
  printf("#sign differs: %d\n", sign_diff);
  printf("#exp  differs: %d\n", exp_diff);
  printf("#denormal ans: %d (%d cases are correctly handled)\n",
    denormal_correct + denormal_incorrect, denormal_correct);

  printf("frac differences:\n");
  for (i = -8; i <= 8; ++i) {
    if (i == -8) {
      printf("<= ");
    } else if (i == 8) {
      printf(">= ");
    } else {
      printf("   ");
    }
    printf("%2d: %u\n", i, diff_distr[8 + i]);
  }
  puts("");

  puts("***** testcases: nan differs *****\n");
  history_print(&nan_hist);

  puts("\n***** testcases: sign differs *****\n");
  history_print(&sign_hist);

  puts("\n***** testcases: exp differs *****\n");
  history_print(&exp_hist);

  puts("\n***** testcases: out.frac - ans.frac >= 8 *****\n");
  history_print(&frac_big_hist);

  puts("\n***** testcases: out.frac - ans.frac <= -8 *****\n");
  history_print(&frac_small_hist);

  return 0;
}
