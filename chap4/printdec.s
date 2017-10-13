N:	equ	1234		; 任意定数
nchar:	equ	10		; 任意定数の桁数は10桁まで
	
	section .text
        global  _start
_start:
	mov	ecx, buf + nchar ; 文字番地
	mov	eax, N		; 割られる数
	mov	edx, 0		; 余り
	mov	esi, 1		; 文字列の長さ
	mov	edi, 10	 	; 割る数
loop0:
	dec	ecx		; 文字番地移動
	div	edi		; 下一桁を取り出す
	add	edx, '0'	
	mov	[ecx], dl	
	mov	edx, 0		; 次のループの割り算に備える
	inc 	esi		; 文字列の長さを測る
	cmp	eax, 0		; 文字列の長さを測り終えたら、ループを終える
	jne	loop0		

        mov     eax, 4          ; writeのシステムコール番号
        mov     ebx, 1          ; 標準出力
        mov     edx, esi        ; 文字列の長さ
        int     0x80
        mov     eax, 1          ; exitのシステムコール番号
        mov     ebx, 0          ; 終了コード
        int     0x80

        section .data
buf:	times nchar db 0	; 文字列の領域確保
	db	0x0a		; 改行
