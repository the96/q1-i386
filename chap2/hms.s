	;; 12356秒が何時間何分何秒か求め、「時*10 + 分*5 + 秒」を出力するプログラム 
	section .text
	global _start
_start:
	mov ax, 12356
	mov bx, 3600
	div bx			; ax を bx で割る
	mov bx, ax		; bx に ax を代入(時間を保存)
	
	mov ax, dx		; ax に分と秒を求める値を移動
	mov dx, 0
	mov cx, 60
	div cx			; ax を cx で割る(分をax, 秒をdxが保有)
	
	mov cx, 5
	mov si, dx	        ; si に秒を格納する
	mul cx			; 分 * 5 を求める. 値は ax に格納している
	add si, ax		; その値を si に加算
	mov ax, bx
	mov cx, 10
	mul cx			; 時 * 10 を求める. 値は ax に格納している
	add si, ax		; その値を si に加算
	mov ebx, 0		; ebx の値の初期化
	mov bx, si		; ebx に出力させたい値を代入

	mov eax, 1		; システムコール番号
	int 0x80		; exitシステムコール
