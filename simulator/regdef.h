#ifndef REGDEF
#define REGDEF


#define PROGSIZE 1048575 //命令メモリ(BlockRAM領域)
#define MTSIZE 10000 //メモリトレース領域
#define INUM 33  //命令種数33
#define MTRACE //(mtnum++) //メモリトレースON(OFFはこの行をコメントアウト)



extern int r[32];
extern float f[32];
extern unsigned long pc;
extern unsigned *maddr;
extern unsigned *mtrace;
extern int *mtracebody;
extern unsigned mtnum;
extern unsigned long long ecount;
extern unsigned long long *icount;
extern unsigned *prog;
extern unsigned flag[3];

extern int aflag;


extern unsigned *linecount;


extern int bpoint;
extern char cline[30];

//myfloat

typedef union myfloat_def {
	struct {
		unsigned int fraction : 23;
		unsigned int exponent : 8;
		unsigned int sign : 1;
	};
	int i32;
	unsigned u32;
	float f32;
} myfloat;



//lineの型
typedef union u_rtype {
	unsigned line;
	struct {
		unsigned func : 6;
		unsigned shift : 5;
		unsigned d : 5;
		unsigned t : 5;
		unsigned s : 5;
		unsigned op : 6;
	};
} rtype;

typedef union u_itype{
	unsigned line;
	struct {
		int imm : 16;
		unsigned t : 5;
		unsigned s : 5;
		unsigned op : 6;
	};
} itype;

typedef union u_jtype {
	unsigned line;
	struct {
		unsigned addr : 26;
		unsigned op : 6;
	};
} jtype;

typedef union u_frtype {
	unsigned line;
	struct {
		unsigned func : 6;
		unsigned d : 5;
		unsigned s : 5;
		unsigned t : 5;
		unsigned fmt : 5;
		unsigned op : 6;
	};
} frtype;

typedef union u_fitype {
	unsigned line;
	struct {
		int imm : 16;
		unsigned t : 5;
		unsigned fmt : 5;
		unsigned op : 6;
	};
} fitype;

extern rtype urtype;
extern itype uitype;
extern jtype ujtype;
extern frtype ufrtype;
extern fitype ufitype;



#endif

