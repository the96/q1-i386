	;; a0 = 0, a1 = 1, an = a(n-1) - 3 * a(n-2) (n >= 2)
	;; この整列の a2 から a20 までを1行につき1個順に出力するプログラム
	section .text
	global _start
	extern print_eax_int
_start:
	mov eax, 0		; 計算結果を一時的に格納する
	mov ebx, 0		; a0 {a(n-2)}
	mov ecx, 1		; a1 {a(n-1)}
	mov edi, 19		; 計算回数
	mov esi, -3		; 掛け算に使用する値
loop0:
	mov eax, ebx		; an = a(n-2)
	imul esi		; an = - 3 * a(n-2)
	add eax, ecx		; an = a(n-1) - 3 * a(n-2)
	call print_eax_int	; an を出力表示
	dec edi			; 計算回数を減らす
	jz exit			; a20 まで出力できたら終了
	mov ebx, ecx		; a(n-2) の更新
	mov ecx, eax		; a(n-1) の更新
	jmp loop0
exit:
	mov eax, 1		; exitシステムコール
	mov ebx, 0
	int 0x80
