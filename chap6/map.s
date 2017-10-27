	section .text
	extern print_eax, print_mem
	global map_init, map_add, map_get

map_init:
	ret

map_add:
	push	eax
	push	ebx
	push	ecx
	push	edx
	push	esi
	push	edi
	mov eax, 11111
	;; 	call print_eax
	;; ハッシュ値を算出
	mov	esi, 0		; カウンタの初期化
	mov	edi, 0		; ハッシュ値の初期化
loop0:
	mov	edx, 0
	mov	dl, [ebx + esi]	; 1文字ずつ読み込む
	cmp	dl, 0
	je	endloop0
	cmp	dl, 'Z'		; 大文字小文字の判断
	jg	lowerCase3	; 小文字の場合
	sub	dl, 'A'		;
	jmp	endIf3
lowerCase3:	
	sub	dl, 'a'
endIf3:
	mov	eax, edi
	push	edx
	mov	dl, 26		; 2 ^ 5
	mul	dl
	pop	edx
	add	eax, edx
	cmp	dl, 128		; 最上位bitがtrueなら
	jl	else0		;
	xor	eax, 623525857	; 仮P＝0
else0:
	mov	edi, eax
	inc	esi
	jmp	loop0
endloop0:
	mov	eax, edi
	mov	edi, ndata
	div	edi
	mov	eax, edx
	push	ecx
checkAddress0:
	cmp	eax, ndata
	jl	else1
	mov	eax, 0

else1:
	mov	edi, 0
	cmp	[data + eax * 8], edi
	je	inputScore

	mov	esi, 0		; カウンタの初期化
compareString0:
	mov edi, [data + eax * 8]
;;; 	 	mov	ecx, 0
;;; 	 	mov	edx, 0
	mov	cl, [edi + esi]
	mov	dl, [ebx + esi]
	cmp	cl, dl
	je	equal0

	push	eax
	mov	eax, 77777
	call	print_eax
	pop	eax
	
	inc	eax
	jmp	checkAddress0
equal0:
	cmp	cl, 0
	je	inputScore
	inc	esi
	jmp	compareString0
inputScore:	
	pop ecx
	mov	[data + eax * 8], ebx
	mov	[data + eax * 8 + 4], ecx

	pop	edi
	pop	esi
	pop	edx
	pop	ecx
	pop	ebx
	pop	eax
        ret

;;; ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
map_get:	
	push	ebx
	push	ecx
	push	edx
	push	esi
	push	edi
	push eax
	mov eax, 99999
	;; 	call print_eax
	pop eax

	;; ハッシュ値を算出
	mov	esi, 0		; カウンタの初期化
	mov	edi, 0		; ハッシュ値の初期化
loop1:
	mov	edx, 0
	mov	dl, [ebx + esi]	; 1文字ずつ読み込む
	cmp	dl, 0
	je	endloop1
	cmp	dl, 'Z'		; 大文字小文字の判断
	jg	lowerCase1	; 小文字の場合
	sub	dl, 'A'		;
	jmp	endIf1
lowerCase1:	
	sub	dl, 'a'
endIf1:
	mov	eax, edi
	push	edx
	mov	dl, 26		; 2 ^ 5
	mul	dl
	pop	edx
	add	eax, edx
	cmp	dl, 128		; 最上位bitがtrueなら
	jl	else2		;
	xor	eax, 623525857		; 仮P＝0
else2:
	mov	edi, eax
	inc	esi
	jmp	loop1
endloop1:
	mov	eax, edi
	mov	edi, ndata
	div	edi
	mov	eax, edx
	
checkAddress1:
	cmp	eax, ndata
	jl	else3
	mov	eax, 0
else3:
	mov	edi, 0
	cmp	[data + eax * 8], edi
	jne	else4		; データが見つからないとき
	mov	eax, 0
	jmp	restore
else4:
	mov	esi, 0		; カウンタの初期化
compareString1:
	mov ecx, 0
	mov edx, 0
	mov edi, [data + eax * 8]
	mov	cl, [edi + esi]
	mov	dl, [ebx + esi]
	
	push eax
	mov eax, ecx
	;; 	call print_eax
	mov eax, edx
	;; 	call print_eax
	pop eax
	
	cmp	cl, dl
	je	equal1
	inc	eax
	jmp	checkAddress1
equal1:
	cmp	cl, 0
	je	outputScore
	inc	esi
	jmp	compareString1
outputScore:
	mov 	ebx, 8
	mul 	ebx
	add	eax, data
	add	eax, 4
	;; 	mov	eax, data + eax * 8 + 4 

restore:	
	pop	edi
	pop	esi
	pop	edx
	pop	ecx
	pop	ebx
        ret


print_string:	
	push eax
	push ebx
	push ecx
	push edx
	
	mov ecx, ebx
	mov edx, 0
loop123:
	mov al, [ecx + edx]
	cmp al, 0
	je print
	inc edx
	jmp loop123

print:	
	
	mov eax, 4
	mov ebx, 1
	int 0x80
	mov eax, 0
	call print_eax

	pop edx
	pop ecx
	pop ebx
	pop eax

	ret
	
	section .data
data:	times 400000 dd 0	; ハッシュテーブル
ndata:	equ	($ - data) / 8	; データの件数
