	;; 16進数で数字を表記するプログラム
	section .text
	global _start
_start:
	mov eax, N		; eax に表示したい文字列を代入
	mov esi, 16		; 16進数を求めるための除数
	mov ecx, buf + nchar	; 作業領域の末尾の次の番地
	mov edi, 1		; 表示文字列の長さ
	
loop0:	mov edx, 0		; 前回の計算結果である剰余を消去する
	div esi			; N を 16 で割る

	mov bx, '0'		; 文字 '0'
	cmp dx, 10		; 剰余と 10 を比較
	jl else			; 剰余が 9 以下なら下の1行は無視
	add bx, 0x27		; '9'=0x39、'a'=0x61 より差分の0x27を加算
else:	
	add bx, dx		; 剰余を代入する
	dec ecx			; 次の書き込み先
	inc edi 		; 表示文字列を増加
	mov [ecx], bl		; 作業領域に1文字書き込む

	cmp eax, 0		; eax と 0 を比較
	jg loop0		; eax が 0 より大きいなら loop0 へ
	
	;; システムコールを呼び出し、出力と終了を行う
	mov eax, 4		; write システムコール番号
	mov ebx, 1		; 標準出力
	mov ecx, buf		; 先頭のアドレス
	mov edx, nchar + 1	; 文字列の長さ
	int 0x80		; write システムコール
	mov eax, 1		; exit システムコール番号
	mov ebx, 0		; 終了コード
	int 0x80		; exit システムコール
	

	section .data
N:	equ 4294967295		; 表示したい数字の文字列
nchar:	equ 8			; 最大で表示する数字の桁数
buf:	times nchar db '0'	; nchar 文字分の領域
	db 0x0a			; 改行
