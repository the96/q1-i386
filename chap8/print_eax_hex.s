	;; 16進数で数字を表記するプログラム
	section .text
	global print_eax_hex 
print_eax_hex:
    push eax
    push ebx
    push ecx
    push edx
    push esi
    push edi

	mov ecx, buf + nchar	; 作業領域の末尾の次の番地
    mov esi,1 
loop0:
    mov edx, eax    ;
    shr eax, 4      ; 16で割る
    and edx, 0x0000000f ; 16で割った余りを求める
	mov bx, '0'		; 文字 '0'
	cmp dx, 10		; 剰余と 10 を比較
	jl else			; 剰余が 9 以下なら下の1行は無視
	add bx, 0x27	; '9'=0x39、'a'=0x61 より差分の0x27を加算
else:	
	add bx, dx		; 剰余を代入す
    dec ecx         ;次のアドレス
    inc esi         ;文字数を数える
	mov [ecx], bl	; 作業領域に1文字書き込む

	cmp eax, 0		; eax と 0 を比較
	jg loop0		; eax が 0 より大きいなら loop0 へ

	;; システムコールを呼び出し、出力と終了を行う
	mov eax, 4		; write システムコール番号
	mov ebx, 1		; 標準出力
	mov edx, esi	; 文字列の長さ
	int 0x80		; write システムコール
    
    pop edi
    pop esi
    pop edx
    pop ecx
    pop ebx
    pop eax	
    
    ret 

	section .data
nchar:	equ 8			; 最大で表示する数字の桁数
buf:	times nchar db '0'	; nchar 文字分の領域
	db 0x0a			; 改行
