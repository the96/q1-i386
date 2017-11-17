	section	.text
	global	cos
	extern	print_eax_int, print_eax_frac

cos:
	push	ebx
	push	ecx
	push	edx
	push	esi
	push	edi
	push	ebp
	push	esp

	mov	edx, eax
	call	multiple	
	mov	ebx, eax 	; ebx == x ^ 2

	mov	edx, ebx
	call	multiple
	mov	ecx, eax	; ecx == x ^ 4

	mov	edx, ebx
	call	multiple	; eax == x ^ 6

	mov	edx, 0		; 割り算準備  6! == 720
	mov	esi, - 720
	idiv	esi
	mov	edi, eax	; edi == - (x ^ 6) / 6!

	mov	edx, 0		; 割り算準備  4! == 24
	mov	eax, ecx
	mov	esi, 24
	idiv	esi
	add	edi, eax	; edi == (x ^ 4) / 4! - (x ^ 6) / 6!
	
	mov	edx, 0		; 割り算準備  2! == 2
	mov	eax, ebx
	mov	esi, - 2
	idiv	esi
	add	eax, edi
	mov	esi, 0x01000000	; esi == 1.0
	add	eax, esi	; eax == 1 - (x ^ 2) / 2! + (x ^ 4) / 4! - (x ^ 6) / 6!
	
	pop	esp
	pop	ebp
	pop	edi
	pop	esi
	pop	edx
	pop	ecx
	pop	ebx

	ret
	
	;;  eax * edx をeaxに格納して返す
multiple:
	
	imul	edx
	shl	edx, 8
	shr	eax, 24
	or	eax, edx

	ret
	
