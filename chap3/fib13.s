        ; フィボナッチ数列の13番目を計算して出力するプログラムです。
        section .text
        global  _start
_start:
        mov     edx, 0          ; f(0) = 0
        mov     eax, 1          ; f(1) = 1
	mov	ecx, 2		; n = 2
loop0:
        add     edx, eax        ; f(n - 1) + f(n - 2)
	mov	ebx, edx	; ebx = f(n - 1) + f(n - 2)
	mov	edx, eax	; f(n - 2) = f(n - 1)
	mov	eax, ebx	; f(n) = ebx
        inc     ecx             ; n++
        cmp     ecx, 13         ; nと13を比較
        jle     loop0           ; 13以下ならloop0に戻る

        mov     eax, 1          ; システムコール番号
        int     0x80            ; exitシステムコール
