#include <stdio.h>
#include <stdint.h> //uint32_t をよく使うかもしれない
#include <math.h> //-lm オプションをgccコマンドの末尾に付けること
#include <stdbool.h>
#include <stdlib.h>

void print_32bit(uint32_t i);

typedef
union float_bit_ {
	uint32_t i;
	float f;
} fbit;

typedef
union fman_{
	struct{
		uint32_t frct : 23;
		uint32_t exp : 8;
		char sign : 1;
	} bit;

	uint32_t i;
	float f;
} fman;

static const uint32_t NaN = 0xffffffff;

bool fisnan(fman f){
	//exp:11111111 means NaN if frct is not 0
	return (f.bit.exp == 0xff) && (f.bit.frct != 0);
}

bool fisinf(fman f){
	//this case exp:0xff but frct is 0, which means inf.
	return (f.bit.exp == 0xff) && (f.bit.frct == 0);
}

bool fissub(fman f){
	//sub. is "less than normalized value can express but greater than 0; for this time, assume it as 0
	return (f.bit.exp == 0) && (f.bit.frct != 0);
}

bool fiszero(fman f){
	//every bits except sign bit is 0 then 0, ignore sign bit.
	return (f.bit.exp == 0) && (f.bit.frct == 0);
}

uint32_t fmul(uint32_t data1, uint32_t data2, int Dflag){
	fman f1, f2;

	f1.i = data1;
	f2.i = data2;

	fman ans;
	ans.f = f1.f * f2.f;

	if(Dflag >= 1){
		printf("\n***********************************************************\n""initial numbers\n""f1\t:");
		print_32bit(f1.i);
		printf("f2\t:");
		print_32bit(f2.i);
	}

	if(Dflag >= 2){
		printf("multiplication: %f * %f\n", f1.f, f2.f);
	}

	//special cases
	//priority--> Nan >> 0 >> inf. >> subnormal
	//case : NaN detected
	if(fisnan(f1) || fisnan(f2)){
		if(Dflag == 3){
			printf("exception=>NAN detected\n");
		}
		return f1.i;
	}
	//case : zero * inf
	if((fiszero(f1) && fisinf(f2)) || (fiszero(f2) && fisinf(f2))){
		if(Dflag == 3){
			printf("exception=>zero * inf\n");
		}
		return NAN;
	}
	//case : sub * inf
	if((fissub(f1) && fisinf(f2)) || (fissub(f2) && fisinf(f2))){
		if(Dflag == 3){
			printf("exception=>sub * inf\n");
		}
		return NAN;
	}
	//case : clear 0
	if(fiszero(f1) || fiszero(f2)){
		if(Dflag == 3){
			printf("exception=>ZERO detected\n");
		}
		return 0x00000000;
	}
	//case : infinity
	if(fisinf(f1) || fisinf(f2)){
		if(f1.bit.sign == f2.bit.sign){
			if(Dflag == 3){
				printf("exception=>inf * inf +\n");
			}
			return 0x7f800000;//+inf. expression
		}
		else{
			if(Dflag == 3){
				printf("exception=>inf * inf -\n");
			}
			return 0xff800000;//-inf. expression
		}
	}
	//case : subnormal.
	if(fissub(f1) || fissub(f2)){
		if(Dflag == 3){
			printf("exception=>subnorm detected\n");
		}
		return 0x00000000;
	}

	/***********************************************************
                      normal cases below
	************************************************************/

	fman product; //return value
	uint32_t exp1 = f1.bit.exp;
	uint32_t exp2 = f2.bit.exp;
	uint32_t search = 0x8000000;//only 28th bit is '1' *maybe not needed in this program

	// figure out the exp part of the result
	//product.bit.exp
	uint32_t pexp = exp1 + exp2;

	uint32_t mts1H = 1 << 13 | (f1.bit.frct >> 10);
	uint32_t mts1L = f1.bit.frct & 0x3ff;
	uint32_t mts2H = 1 << 13 | (f2.bit.frct >> 10);
	uint32_t mts2L = f2.bit.frct & 0x3ff;
	uint32_t mts;
	uint32_t H1L2;
	uint32_t H2L1;
	uint32_t L1L2;
	int sticky = 0;

	H1L2 = mts1H * mts2L;
	sticky = ((H1L2 & 0x3ff) > 0) ? 1 : 0;
	H1L2 = H1L2 >> 10;
	if(Dflag >= 3){
		printf("H1L2\t\t:");
		print_32bit(H1L2);
	}

	H2L1 = mts2H * mts1L;
	sticky = (((H2L1 & 0x3ff) > 0) ? 1 : 0) | sticky;
	H2L1 = H2L1 >> 10;
	if(Dflag >= 3){
		printf("H2L1\t\t:");
		print_32bit(H2L1);
	}

	L1L2 = mts1L * mts2L;
	sticky = sticky | (((L1L2 & 0xfffff) > 0) ? 1 : 0);

	if (Dflag >= 2){
		printf("sticky bit \t:%d\n", sticky);
	}

	// mts holds 28bits, needs 27bits
	mts = mts1H * mts2H + H1L2 + H2L1;

	if(Dflag >= 1){
		printf("mts\t\t:");
		print_32bit(mts);
	}

	//normalize mts, shifting to make 27th bit '1'
	if((mts & search) == search){//branch if 28th bit of mts is '
		pexp += 1;
		if((mts & 0x1) == 1){
			sticky = 1;
			mts = (mts >> 1) | 0x1;
		}
		else {
			mts = mts >> 1;
		}
	}

	if (Dflag >= 2){
		printf("sticky check\t:%d\n", sticky);
	}

	char ou_flag = 0;
	/* overflow */
	if(pexp >= 255 + 127){
		ou_flag = 1;
		mts = 0;
	}
	/* underflow */
	else if(pexp <= 127){
		ou_flag = 2;
	}

	if(Dflag >= 2){
		printf("after 1st normalization\n1st mts\t\t:");
		print_32bit(mts);
		printf("pexp\t\t:");
		print_32bit(pexp);
	}
	/*************************************

    place executions on exceptions here

	**************************************/

	/* 丸め処理
	   if G == 1 and (ulp or R or S) == 1 then add 0x8
	*/
	if(((mts & 0x4) == 0x4) && (((mts & 0xb) > 0) || sticky)){
		mts = mts + 0x8;
		if(Dflag >= 2){
			printf("im proud of my job! -- rounding\n");
		}
	}

	// 桁上げ確認
	if((mts & search) == search){//branch if 28th bit of mts is '1
		pexp += 1;
		/* if((mts & 0x1) == 0x1 || sticky){ */
		/* 	mts = (mts >> 1) | 0x1; */
		/* } */
		/* else{ */
		mts = mts >> 1;
	}

	/* overflow */
	if(pexp >= 255 + 127){
		ou_flag = 1;
		mts = 0;
	}
	/* underflow */
	else if(pexp <= 127){
		ou_flag = 2;
	}
	else{
		ou_flag = 0;
	}
	//after rouding; debug
	if(Dflag >= 2){
		printf("after rouding\nrnd\t\t:");
		print_32bit(mts);
		printf("pexp\t\t:");
		print_32bit(pexp);
	}

	// culculate the sign of the product
	if(f1.bit.sign == f2.bit.sign){
		product.bit.sign = 0x0;
	}
	else{
		product.bit.sign = 0x1;
	}

	//finally over/under flow exception excution here!
	if(ou_flag == 1){
		product.bit.exp = 0xff;
		mts = 0;
	}
	else if(ou_flag == 2){
		//never handle subnormals, just make it 0
		product.bit.sign = 0x0; // accepts no -0
		product.bit.exp = 0x0;
		mts = 0;
	}
	else{
		product.bit.exp = pexp - 127;
	}
	product.bit.frct = mts >> 3;

	//debugging printfs
	if(Dflag >= 1){
		printf("result\t\t:");
		print_32bit(product.i);

		printf("correct bits\t:");
		print_32bit(ans.i);

		printf("fmul answer \t:%f\n", product.f);

		printf("correct answer\t:%f\n", ans.f);
		puts("");
	}
	return product.i;
}
