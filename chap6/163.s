section	.text
	global	_start
	extern	sort, print_eax
_start:
	mov	eax, 0x5a5a5a5a
	mov	edx, 0x7cffccff
	mov	esi, 0xf0f0
	mov	edi, 0x6ba98765
	mov	ebp, 0x5091a2b3
	mov	ebx, data
	mov	ecx, ndata
	call	sort

	mov	[ebx-24], eax
	mov	[ebx-20], edx
	mov	[ebx-16], esi
	mov	[ebx-12], edi
	mov	[ebx-8],  ebp
	sub	ebx, 24
	add	ecx, 7
.loop:	mov	eax, [ebx]
	call	print_eax
	add	ebx, 4
	dec	ecx
	jnz	.loop

	mov	ebx, data
	mov	[ebx + 4], edx
	mov	ecx, 1
	call	sort		; 1個の0からなる列を整列
	add	ebx, 4 * (ndata-1)
	mov	[ebx - 4], edi
	call	sort		; 1個の0x7fffffffからなる列を整列
	sub	ebx, 8
	inc	ecx
	call	sort		; 2個の数からなる列を整列

	sub	ebx, 4 * ndata - 8
	mov	ecx, ndata + 2
.loop2:	mov	eax, [ebx]
	call	print_eax
	add	ebx, 4
	dec	ecx
	jnz	.loop2
	mov	eax, 1
	mov	ebx, 0
	int	0x80

	section	.data
	times 6 dd 0x55aa55aa
data:	dd	0x7fffffff, 0, 0x7fffffff, 0x7fffffff, 0, 0
ndata:	equ	6
	dd	0x55aa55aa
