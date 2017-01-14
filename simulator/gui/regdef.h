#ifndef REGDEF
#define REGDEF

extern int r[32];
extern float f[32];
extern long pc;
extern unsigned *maddr;
extern unsigned *mtrace;
extern int *mtracebody;
extern unsigned mtnum;
extern unsigned ecount;
extern unsigned *icount;

extern int bpoint;
extern char cline[30];

extern char fname[50];
extern char aname[50];
extern char *prog;
extern char *out1;
extern unsigned stepline;
extern long int steplnum;
extern long int inpc;

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
		unsigned t : 5;
		unsigned s : 5;
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

