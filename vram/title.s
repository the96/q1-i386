	org     0x7c00          ; 開始番地

	mov     ax, 0xb800      ; VRAMの開始番地 (÷ 16)
	mov     ds, ax          ; セグメントレジスタにVRAMの番地を代入

blackout:
	mov cl, ''
	mov ch, 0x00
	mov bx, 0
fill:
	mov [bx], cx
	add bx, 2
	cmp bx, 4000
	jle fill

	
	mov bx, 210
	mov eax, data1		; データ領域の先頭番地を代入
	push bx
	add bx, 162
	mov ch, 0x28
	mov cl, 0xdb
	call drawWORm
	pop bx

	
	mov eax, data1
	mov ch, 0x2a
	mov cl, 0xdb
	push bx
	call drawWORm		
	pop bx

	mov eax, data2
	add bx, 24
	mov ch, 0xae
	mov cl, 0xdb
	call drawBanana

	mov ch, 0x02
	mov bx, 2944		; 最後から5行目の中央近くの座標
	mov cl, 0x18
	mov eax, data3
	mov si, bx

	call drawText

        hlt                     ; HALT (CPUを停止)

drawWORm:
	mov [bx], cx
	mov dx, 0
	mov dl, [cs:eax]
	add bx, dx
	inc ax
	mov dl, [cs: eax]
	cmp dl, 1
	jnz drawWORm
	ret

drawBanana:
	mov [bx], cx
	mov dx, 0
	mov dl, [cs:eax]
	add bx, dx
	inc ax
	mov dl, [cs: eax]
	cmp dl, 1
	jnz drawBanana
	ret

drawText:
	add bx, 2
	mov cl, [cs:eax]
	inc ax
	mov [bx], cx
	mov dl, [cs:eax]
	cmp dl, 0x0a
	jz compare 
	cmp dl, 0x00
	jnz drawText
	ret
compare:
	add si, 160
	mov bx, si
	inc ax
	jmp drawText

data1:	db 12, 4, 2, 2, 2, 2, 2, 2, 4, 2, 2, 2, 2, 2, 4, 2, 2, 2, 2, 2, 104, 12, 4, 10, 6, 10, 4, 6, 6, 102, 6, 6, 4, 10, 6, 10, 4, 6, 6, 102, 6, 6, 4, 10, 6, 2, 2, 2, 2, 6, 6, 6, 104, 2, 4, 2, 6, 2, 2, 2, 2, 2, 6, 10, 4, 6, 6, 4, 1

data2:	db 2, 2, 158, 160, 160, 156, 2, 2, 2, 1

data3:	db "start: push w key", 0x0a,
	db "up   : w key", 0x0a,
	db "down : s key", 0x0a,
	db "left : a key", 0x0a,
	db "right: d key", 0x00
	

	
        ; 以降はセクタサイズに合わせるための詰め物
        times   510-($-$$) db 0 ; セクタ末尾まで0で埋める ($$は開始番地)
        db      0x55, 0xaa      ; Boot Signature
