.data
.balign	8
.text
xor.8:
	cmpl	$0, %eax
	jne	je_else.23
	movl	%ebx, %eax
	ret
je_else.23:
	cmpl	$0, %ebx
	jne	je_else.24
	movl	$1, %eax
	ret
je_else.24:
	movl	$0, %eax
	ret
func.12:
	jmp	min_caml_ext
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
	movl	$1, %eax
	movl	$0, %ebx
	call	xor.8
	movl	$0, %eax
	movl	$1, %ebx
	call	func.12
	call	min_caml_ext2
	popl	%ebp
	popl	%edi
	popl	%esi
	popl	%edx
	popl	%ecx
	popl	%ebx
	popl	%eax
	ret
