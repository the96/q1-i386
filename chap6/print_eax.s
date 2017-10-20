        ; eaxの値を10進数で標準出力に出力する.
        ; 汎用レジスタの値は保存される (破壊しない).
	
nchar:	equ	10		; 任意定数の桁数は10桁まで
	
        section .text
        global  print_eax       ; 別ファイルから参照可能にする
print_eax:
	push	eax		; push
	push	ebx
	push	ecx
	push	edx
	push	esi
	push	edi
	
	mov	ecx, buf + nchar ; 文字番地
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

	pop	edi		; pop
	pop	esi
	pop	edx
	pop	ecx
	pop	ebx
	pop	eax
	
        ret                     ; print_eaxの終端

        section .data
buf:	times nchar db 0	; 文字列の領域確保
	db	0x0a		; 改行
