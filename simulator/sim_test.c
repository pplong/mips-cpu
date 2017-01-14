#include <stdio.h>


unsigned trans_endian(unsigned x) {
	return (x << 24) | (x << 8 & 0x00ff0000) | (x >> 8 & 0x0000ff00) | (x >> 24);
}


int main() {
	FILE *fp;
	char *filename = "prog.bin";
	int i;
	int out[] = {
0x00000010,
0x2003000A,
0x28740002,
0x10140002,
0x20080001,
0x0800000F,
0x20040000,
0x20050000,
0x20060000,
0x20070001,
0xFC000000,
0x0083A82A,
0x10150005,
0x00C72820,
0x20C70000,
0x20A60000,
0x20840001,
0x0800000a};

	if ((fp = fopen(filename,"wb"))==NULL) {
		printf("file open error\n");
		return 0;
	}

	for (i=0;i<18;i++) {
		out[i] = trans_endian(out[i]);
	}

	fwrite(out,sizeof(int),18,fp);

	fclose(fp);

	return 0;
}
