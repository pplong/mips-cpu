.data
.balign	8
.text
x.8:
	movl	%eax, %ebx
	negl	%ebx
	subl	%ebx, %eax
	movl	%eax, %ebx
	negl	%ebx
	movl	%ebx, %ecx
	negl	%ecx
	subl	%ecx, %ebx
	subl	%ebx, %eax
	movl	%eax, %ebx
	negl	%ebx
	subl	%ebx, %eax
	ret
.globl	min_caml_start
min_caml_start:
.globl	_min_caml_start
_min_caml_start: # for cygwin
	pushl	%eax
	pushl	%ebx
	pushl	%ecx
	pushl	%edx
	pushl	%esi
	pushl	%edi
	pushl	%ebp
	movl	32(%esp),%ebp
	movl	36(%esp),%eax
	movl	%eax,min_caml_hp
	movl	$125, %eax
	call	x.8
	movl	%eax, %ebx
	negl	%ebx
	subl	%ebx, %eax
	call	min_caml_print_int
	popl	%ebp
	popl	%edi
	popl	%esi
	popl	%edx
	popl	%ecx
	popl	%ebx
	popl	%eax
	ret
