nchar:	equ	10		

	section .text
        global  print_eax_int       ; 別ファイルから参照可能にする
	
print_eax_int:

	push	eax
	push	ebx
	push	ecx
	push	edx
	push	esi
	push	edi
	push	ebp
	push	esp

	mov	ebx, 0		; ebxのリセット
	cmp	eax, 0		; 正負の判定
	jge	Positive
Negative:
	not	eax
	inc	eax
	mov	ebx, 1		; 負の判定
Positive:	
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

	cmp	ebx, 1
	jne	Draw
	inc	esi		; 長さ
	dec	ecx		
	add	edx, '-'
	mov	[ecx], dl

Draw:	
        mov     eax, 4          ; writeのシステムコール番号
        mov     ebx, 1          ; 標準出力
        mov     edx, esi        ; 文字列の長さ
        int     0x80
	
	pop	esp
	pop	ebp
	pop	edi
	pop	esi
	pop	edx
	pop	ecx
	pop	ebx
	pop	eax
	
        ret                     

        section .data
buf:	times nchar db 0	; 文字列の領域確保
	db	0x0a		; 改行
