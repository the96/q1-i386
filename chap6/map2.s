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
	;call print_eax
	;; ハッシュ値を算出
    push ecx
    mov edi, 0

read4Bytes:
    mov eax, 0      ;calc hash
    mov esi, 0      ;counter
    mov ecx, 0      ;flag
    push edi
    mov edi, 0xff
loop0:
    mul edi         ;eax * 1byte
	mov	edx, 0
    cmp ecx, 1
    je skip

	mov	dl, [ebx + esi]	; 1文字ずつ読み込む
    cmp dl, 0
    jne skip
    mov ecx, 1
skip:
    add eax, edx
    cmp esi, 4
    jge xxHash
    inc esi
    jmp loop0

xxHash:
;xxHash is hash algorithm thought by Cyan4973
;https://github.com/Cyan4973/xxHash
    pop edi
    mov esi, PRIME32_3
    mul esi
    
    mov esi, eax
    shl esi, 17
    shr eax, 15
    add eax, esi

    mov esi, PRIME32_4
    mul esi

    mov esi, eax
    shr esi, 15
    xor eax, esi

    mov esi, PRIME32_2
    mul esi

    mov esi, eax
    shr esi, 13
    xor eax, esi

    mov esi, PRIME32_3
    mul esi

    mov esi, eax
    shr esi, 16
    xor eax, esi

    push edx
    mov esi, ndata      ;calc hash key
    mov edx, 0
    div esi
    add edi, edx
    pop edx

    cmp ecx, 1
    je read4Bytes
    push edx
    mov edx, 0
    mov esi, ndata
    mov eax, edi
    div esi
    mov eax, edx
    pop edx
    
    ;call print_eax

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
	;mov	eax, 77777
	;call	print_eax
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
	;mov eax, 99999
	;call print_eax
	pop eax

	;; ハッシュ値を算出
    mov edi, 0

read4Bytes2:
    mov eax, 0      ;calc hash
    mov esi, 0      ;counter
    mov ecx, 0      ;flag
    push edi
    mov edi, 0xff
loop1:
    mul edi         ;eax * 1byte
	mov	edx, 0
    cmp ecx, 1
    je skip2

	mov	dl, [ebx + esi]	; 1文字ずつ読み込む
    cmp dl, 0
    jne skip2
    mov ecx, 1
skip2:
    add eax, edx
    cmp esi, 4
    jge xxHash2
    inc esi
    jmp loop1

xxHash2:
    pop edi
    mov esi, PRIME32_3
    mul esi
    
    mov esi, eax
    shl esi, 17
    shr eax, 15
    add eax, esi

    mov esi, PRIME32_4
    mul esi

    mov esi, eax
    shr esi, 15
    xor eax, esi

    mov esi, PRIME32_2
    mul esi

    mov esi, eax
    shr esi, 13
    xor eax, esi

    mov esi, PRIME32_3
    mul esi

    mov esi, eax
    shr esi, 16
    xor eax, esi

    push edx
    mov edx, 0
    mov esi, ndata      ;calc hash key
    div esi
    add edi, edx
    pop edx

    cmp ecx, 1
    je read4Bytes

    push edx
    mov esi, ndata
    mov edx, 0
    mov eax, edi
    div esi
    mov eax, edx
    pop edx
	
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
data:	times 4000000 dd 0	; ハッシュテーブル
ndata:	equ	($ - data) / 8	; データの件数

PRIME32_2: equ 2246822519
PRIME32_3: equ 3266489917
PRIME32_4: equ 668265263
PRIME32_5: equ 374761393
