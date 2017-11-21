pi:	equ 	0x03243f6a		; Pi
	
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

	;; 対称性判定
	mov	esi, 0		; 初期化
	cmp	eax, pi / 2	; 第2象限の場合 pi/2 < eax <= pi
	jg	orthant2	
	push	eax		
	mov	eax, pi
	mov	ebx, - 2
	mov	edx, 0
	idiv	ebx
	mov	ecx, eax
	pop	eax
	cmp	eax, ecx	; 第3象限の場合 -pi <= eax < -pi/2
	jl	orthant3
	jmp	doubleangle	
	
orthant2:
	mov	ebx, - 1
	mov	edx, 0
	imul	ebx
	add	eax, pi		; x == pi - eax
	mov	esi, - 1	; push ebx  =======   -1 を保存
	jmp	doubleangle

orthant3:
	mov	ebx, - 1
	mov	edx, 0
	imul	ebx
	sub	eax, pi		; x == - pi - eax
	mov	esi, - 1	; push ebx ========   -1 を保存

	;; 2倍角判定
doubleangle:
	cmp	eax, pi / 4	; pi/4 < eax <= pi/2
	jg	orthant1
	push	eax		
	mov	eax, pi
	mov	ebx, - 4
	mov	edx, 0
	idiv	ebx
	mov	ecx, eax
	pop	eax
	cmp	eax, ecx	; -po/2 <= eax < -pi/4 の場合
	jl	orthant4

	call	cosx		; -pi <= eax <= pi/4　の場合
	jmp	endcos

orthant1:
	mov	ebx, 2		; cos(2x) == 2 * cos ^ 2 (x) - 1
	mov	edx, 0
	idiv	ebx
	call	cosx
	mov	edx, eax
	call	multiple	; eax == cos ^ 2 (x)
	mov	edx, 0
	imul	ebx		; eax == 2 * cos ^ 2 (x)
	sub	eax, 0x01000000	; eax == 2 * cos ^ 2 (x) - 1
	jmp	endcos
	
orthant4:
	xor	eax, 0xffffffff ; なぜか一度反転(-1を掛ける)させないとエラーになる
	mov	ebx, - 2	; cos(2x) == 2 * cos ^ 2 (x) - 1
	mov	edx, 0
	idiv	ebx
	call	cosx
	mov	edx, eax
	call	multiple	; eax == cos ^ 2 (x)
	mov	ebx, 2
	mov	edx, 0
	imul	ebx		; eax == 2 * cos ^ 2 (x)
	sub	eax, 0x01000000	; eax == 2 * cos ^ 2 (x) - 1

endcos:
	cmp	esi, -1		; 対称性の計算
	jne	end
	imul	esi
	
end:
	pop	esp
	pop	ebp
	pop	edi
	pop	esi
	pop	edx
	pop	ecx
	pop	ebx

	ret



	;; cos(eax) の値を出す
cosx:
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
	push	ebx
	push	ecx
	push	edx
	push	esi
	push	edi
	push	ebp
	push	esp
	
	imul	edx
	shl	edx, 8
	shr	eax, 24
	or	eax, edx

	pop	esp
	pop	ebp
	pop	edi
	pop	esi
	pop	edx
	pop	ecx
	pop	ebx
	
	ret
	
