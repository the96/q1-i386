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
	
loop1:
	mov ch, 0xff
	mov [bx], cx
	add bx, 12
	mov [bx], cx
	add bx, 4

	mov [bx], cx
	add bx, 2
	mov [bx], cx
	add bx, 2
	mov [bx], cx
	add bx, 2
	mov [bx], cx
	add bx, 2
	;;
	mov ch, 0xaa
	mov [bx], cx
	add bx, 2
	mov [bx], cx
	add bx, 2
	mov [bx], cx
	add bx, 4
	mov ch, 0xff

	mov [bx], cx
	add bx, 2
	mov [bx], cx
	add bx, 2
	mov [bx], cx
	add bx, 2
	mov [bx], cx
	add bx, 2
	mov [bx], cx
	add bx, 2
	mov [bx], cx
	add bx, 4

	mov [bx], cx
	add bx,2
	mov [bx], cx
	add bx, 2
	mov [bx], cx
	add bx, 2
	mov [bx], cx
	add bx, 2
	mov [bx], cx
	add bx, 2
	mov [bx], cx

loop2:
	
	add bx, 104

	mov [bx], cx
	add bx, 12
	mov [bx], cx
	add bx, 4

	mov [bx], cx
	add bx, 10
	;; 
	mov ch, 0xaa
	mov [bx], cx
	add bx, 6
	mov ch, 0xff

	mov [bx], cx
	add bx, 10
	mov [bx], cx
	add bx, 4

	mov [bx], cx
	add bx, 6
	mov [bx], cx
	add bx, 6
	mov [bx], cx

loop3:
	add bx, 102

	mov [bx], cx
	add bx, 6
	mov [bx], cx
	add bx, 6
	mov [bx], cx
	add bx, 4

	mov [bx], cx
	add bx, 10
	;;
	mov ch, 0xaa
	mov [bx], cx
	add bx, 6
	mov ch, 0xff

	mov [bx], cx
	add bx, 10
	mov [bx], cx
	add bx, 4

	mov [bx], cx
	add bx, 6
	mov [bx], cx
	add bx, 6
	mov [bx], cx
	
loop4:	
	add bx, 102

	mov [bx], cx
	add bx, 6
	mov [bx], cx
	add bx, 6
	mov [bx], cx
	add bx, 4

	mov [bx], cx
	add bx, 10
	;;
	mov ch, 0xaa
	mov [bx], cx
	add bx, 6
	mov ch, 0xff

	mov [bx], cx
	add bx, 2
	mov [bx], cx
	add bx, 2
	mov [bx], cx
	add bx, 2
	mov [bx], cx
	add bx, 2
	mov [bx], cx
	add bx, 6

	mov [bx], cx
	add bx, 6
	mov [bx], cx
	add bx, 6
	mov [bx], cx
loop5:	
	add bx, 104
	mov [bx], cx
	add bx, 2
	mov [bx], cx
	add bx, 4
	mov [bx], cx
	add bx, 2
	mov [bx], cx
	add bx, 6

	mov [bx], cx
	add bx, 2
	mov [bx], cx
	add bx, 2
	mov [bx], cx
	add bx, 2
	;;
	mov ch, 0xaa
	mov [bx], cx
	add bx, 2
	mov [bx], cx
	add bx, 2
	mov [bx], cx
	add bx, 6
	mov ch, 0xff

	mov [bx], cx
	add bx, 10
	mov [bx], cx
	add bx, 4

	mov [bx], cx
	add bx, 6
	mov [bx], cx
	add bx, 6
	mov [bx], cx


	mov ch, 0x02
	mov bx, 3520		; 最後から3行目の座標
	add bx, 2
	mov cl, 'w'
	mov [bx], cx
	add bx, 2
	mov cl, ':'
	mov [bx], cx
	add bx, 2
	mov cl, 0x18
	mov [bx], cx

	add bx, 4
	mov cl, 'a'
	mov [bx], cx
	add bx, 2
	mov cl, ':'
	mov [bx], cx
	add bx, 2
	mov cl, 0x1b
	mov [bx], cx
	
	add bx, 4
	mov cl, 's'
	mov [bx], cx
	add bx, 2
	mov cl, ':'
	mov [bx], cx
	add bx, 2
	mov cl, 0x1a
	mov [bx], cx

	add bx, 4
	mov cl, 'd'
	mov [bx], cx
	add bx, 2
	mov cl, ':'
	mov [bx], cx
	add bx, 2
	mov cl, 0x1c
	mov [bx], cx

        hlt                     ; HALT (CPUを停止)

        ; 以降はセクタサイズに合わせるための詰め物
        times   510-($-$$) db 0 ; セクタ末尾まで0で埋める ($$は開始番地)
        db      0x55, 0xaa      ; Boot Signature
