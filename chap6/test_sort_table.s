        section .text
        global  _start
;        extern  sort_by_name, print_table
        extern print_table, sort_by_name, print_eax
_start:
        mov     ebx, data
        mov     ecx, ndata
        call    print_table     ; 整列前のテーブルを出力
        call    sort_by_name    ; 名前の辞書順に整列
        call    print_table     ; 整列後のテーブルを出力
        mov     eax, 1
        mov     ebx, 0
        int     0x80    ; exit

        section .data
data:   ; データテーブル
        ; 各エントリは名前(の番地)と得点からなる.
        dd      s0, 968
        dd      s1, 897
        dd      s2, 657
        dd      s3, 542
        dd      s4, 347
        dd      s5, 391
        dd      s6, 513
        dd      s7, 938
        dd      s8, 760
        dd      s9, 344
ndata:  equ     ($ - data)/8

        section .rodata         ; read-only data
        ; 名前文字列. ヌル文字で文字列の終端を表す.
        ; 読み出し専用の記憶領域に格納されている.
s0:     db      'Bobbygarcia', 0
s1:     db      'Usonlygib', 0
s2:     db      'Folsomprimitivi', 0
s3:     db      'Eneurmuffintop', 0
s4:     db      'Kerrieakcore', 0
s5:     db      'Vinmantingandsh', 0
s6:     db      'Pathothiastylis', 0
s7:     db      'Enehies', 0
s8:     db      'Westernbaseball', 0
s9:     db      'Chandramgadhana', 0
