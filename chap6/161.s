	section .text
	global	_start
	extern	print_eax
_start:
	mov	ebx, 1
	mov	ecx, 100100
	mov	edx, 1000000000
	mov	esi, 0xf0f0f0f0
	mov	edi, 0xff00ff00
	mov	ebp, ecx
	mov	eax, 0xffffffff
	call	print_eax
	inc	eax
	call	print_eax
	mov	eax, ebx
	call	print_eax
	mov	eax, ecx
	call	print_eax
	mov	eax, edx
	call	print_eax
	mov	eax, esi
	call	print_eax
	mov	eax, edi
	call	print_eax
	mov	eax, ebp
	call	print_eax
	mov	eax,1
	mov	ebx,0
	int	0x80
