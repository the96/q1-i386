	section	.text
	extern	map_init, map_add, map_get
	global	c_map_init, c_map_add, c_map_get
c_map_init:
	jmp	map_init

c_map_add:
	push	ebx
	mov	ebx, [esp + 8]
	mov	ecx, [esp + 12]
	call	map_add
	pop	ebx
	ret

c_map_get:
	push	ebx
	mov	ebx, [esp + 8]
	call	map_get
	pop	ebx
	ret
