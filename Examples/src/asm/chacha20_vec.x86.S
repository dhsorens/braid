/* ChaCha20 (RFC 8439), vectorised, for x86-64 with AVX-512VL: the block function of
   Examples/src/c/chacha20_vec.c written by hand, in the instructions the pinned x86-64 model
   has. Compiled from the C, the function uses pxor, pslld, psrld and por (or their VEX
   forms), which the model's parser does not read (docs/ISA.md); here an exclusive or is
   vpternlogd with the table 0x5a (the first operand xor the third) and a rotation to the
   left by n is vprord by 32 - n.

     void chacha20_block_vec(u32 *out, const u32 *in);

   `out` is in rdi and `in` in rsi. The rows of the state are xmm0 to xmm3. */
	.text
	.globl	chacha20_block_vec
	.type	chacha20_block_vec, @function

/* Four quarter rounds, one in each lane, on the rows a, b, c, d. */
.macro	QR4 a, b, c, d
	vpaddd	\b, \a, \a
	vpternlogd	$0x5a, \a, \a, \d
	vprord	$16, \d, \d
	vpaddd	\d, \c, \c
	vpternlogd	$0x5a, \c, \c, \b
	vprord	$20, \b, \b
	vpaddd	\b, \a, \a
	vpternlogd	$0x5a, \a, \a, \d
	vprord	$24, \d, \d
	vpaddd	\d, \c, \c
	vpternlogd	$0x5a, \c, \c, \b
	vprord	$25, \b, \b
.endm

chacha20_block_vec:
	vmovdqu32	(%rsi), %xmm0
	vmovdqu32	16(%rsi), %xmm1
	vmovdqu32	32(%rsi), %xmm2
	vmovdqu32	48(%rsi), %xmm3
	movl	$10, %eax
.Lround:
	QR4	%xmm0, %xmm1, %xmm2, %xmm3
	pshufd	$0x39, %xmm1, %xmm1
	pshufd	$0x4e, %xmm2, %xmm2
	pshufd	$0x93, %xmm3, %xmm3
	QR4	%xmm0, %xmm1, %xmm2, %xmm3
	pshufd	$0x93, %xmm1, %xmm1
	pshufd	$0x4e, %xmm2, %xmm2
	pshufd	$0x39, %xmm3, %xmm3
	decl	%eax
	jne	.Lround
	vpaddd	(%rsi), %xmm0, %xmm0
	vpaddd	16(%rsi), %xmm1, %xmm1
	vpaddd	32(%rsi), %xmm2, %xmm2
	vpaddd	48(%rsi), %xmm3, %xmm3
	vmovdqu32	%xmm0, (%rdi)
	vmovdqu32	%xmm1, 16(%rdi)
	vmovdqu32	%xmm2, 32(%rdi)
	vmovdqu32	%xmm3, 48(%rdi)
	ret
	.size	chacha20_block_vec, .-chacha20_block_vec
