	;; N の階乗を出力するプログラム
	section .text
        global  _start
	extern print_eax_hex, mul_eax_edx
N:	equ	12  		; 任意定数(0~12)
	
_start:
	mov	eax, N		; eax に任意定数 N を代入
	mov	edx, N - 1	; edx に N - 1 を代入
	cmp	eax, 1
	jle	else		; N が 0 または 1 のとき else へ
factorial:	
	call	mul_eax_edx	; eax * edx
	dec	edx		; 乗じる数字(回数)を減らす
	cmp	edx, 0		; 乗算の残りの回数が 0 か否か
	jne	factorial	; 0 でないなら factorial へ
	jmp	end
else:
	mov	eax, 1		; 0! = 1，1! = 1 より
end:	
	call	print_eax_hex	; 出力呼び出し
	
        mov     eax, 1          ; exitのシステムコール番号
        mov     ebx, 0          ; 終了コード
        int     0x80
