#include <stdio.h>
#include <stdint.h>
#include <math.h>
#include <signal.h>
#include <stdbool.h>

uint32_t float1 = 0x7b43684f;
uint32_t float2 = 0x04f8cc00;

//for debugging
void print_32bit(uint32_t i) {
	int cnt = 0;
	uint32_t comp = 0x80000000;

	for (; cnt < 32; cnt++, comp = (comp >> 1)) {
		if ((i & comp) == comp) {
			printf("1");
		}
		else {
			printf("0");
		}
		if((cnt == 0) | (cnt == 3) | (cnt == 5) | (cnt == 8) | (cnt == 18) | (cnt == 28))
			printf(" ");
    }

	printf("\n");
	return;
}

void fprint_32(FILE* fd, uint32_t i) {
	int cnt = 0;
	uint32_t comp = 0x80000000;

	for (; cnt < 32; cnt++, comp = (comp >> 1)) {
		if ((i & comp) == comp) {
			fprintf(fd, "1");
		}
		else {
			fprintf(fd, "0");
		}
		if ((cnt == 0) | (cnt == 8)) {
			fprintf(fd, " ");
		}
    }

	fprintf(fd, "\n");
	return;
}

uint32_t fmul(uint32_t a,uint32_t b, int Dflag);

typedef
union fman_ {
	struct {
		uint32_t frct : 23;
		uint32_t exp : 8;
		char sign : 1;
	} bit;

	uint32_t i;
	float f;
} fman;

int main(int argc, char* argv[]) {
	if (argc == 2) {
		uint32_t answer;

		int Dflag = 0; // no print functions

		if (argv[1][0] == '-' && argv[1][1] == 'D') {
			if (argv[1][2] == '\0' || argv[1][2] == '1') {
				Dflag = 1; // Debug level 1
			}
			else if (argv[1][2] == '2') {
				Dflag = 2; //level 2
			}
			else if (argv[1][2] == '3') {
				Dflag = 3; //level 3
			}
		}

		answer = fmul(float1, float2, Dflag);
		print_32bit(answer);
		puts("***********************************************************");
	}
	else {
		//union myfloat
		fman ans,native_ans, a, b;
		FILE* fd_out, * fd_native;

		fd_out = fopen("c-result.out", "w");
		fd_native = fopen("native.out", "w");

		while (scanf("%08x %08x", &a.i, &b.i) == 2) {
			ans.i = fmul(a.i, b.i, 0);
			native_ans.f = a.f * b.f;
			if (ans.i != 0) {
				fprint_32(fd_out, ans.i);
				fprint_32(fd_native, native_ans.i);
			}
		}
		fclose(fd_out);
	}
	return 0;
}
