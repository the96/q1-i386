	;; 123 + 45 - 67 + 8 - 9を出力するあまり意味の無いプログラム
        section .text
        global  _start
_start:
        mov     ebx, 123        ; ebx = 123
        add     ebx, 45         ; ebx = ebx + 45
	sub	ebx, 67		; ebx = ebx - 67
	add     ebx, 8	        ; ebx = ebx + 8
	sub	ebx, 9		; ebx = ebx - 9
        mov     eax, 1          ; システムコール番号
        int     0x80            ; exitシステムコール
