	section .text
        global  _start
        extern  map_init, map_add, map_get
        extern  print_eax
_start:
        call    map_init        ; データテーブルを初期化

        mov     ebx, key1
        mov     ecx, 980
        call    map_add         ; 名前 key1, 得点 980 からなるエントリを追加
        mov     ebx, key2
        mov     ecx, 325
        call    map_add         ; 名前 key2, 得点 325 からなるエントリを追加
        mov     ebx, key3
        call    map_get         ; 名前 key3 (key1と等しい) の得点を検索
        call    print_score     ; 検索結果を出力
        mov     ecx, 1234
        call    map_add         ; 名前 key3, 得点 1234 からなるエントリを追加
        mov     ebx, key1
        call    map_get         ; 名前 key1 の得点を検索
        call    print_score     ; 検索結果を出力
        mov     ebx, key4
        call    map_get         ; 名前 key4 の得点を検索
        call    print_score     ; 検索結果を出力
        ; -- 必要なだけ追加と検索を繰り返す --

        mov     eax, 1
        mov     ebx, 0
        int     0x80            ; exit

        ; 得点を出力
        ; eax = 得点の番地
print_score:
        cmp     eax, 0
        jz      print_not_found
        mov     eax, [eax]      ; 得点
        call    print_eax
        ret
print_not_found:
        push    ebx
        mov     eax, 4		; write
        mov     ebx, 1		; 標準出力
        mov     ecx, not_found
        mov     edx, not_found_len
        int     0x80
        pop     ebx
        ret

        section .rodata         ; read-only data
        ; 検索用名前文字列. ヌル文字で文字列の終端を表す.
key1:   db      'Westernbaseball', 0
key2:   db      'Usonlygib', 0
key3:   db      'Westernbaseball', 0    ; key1と等しい文字列
key4:   db      'Hello', 0

        ; 出力用文字列
not_found:      db      'not_found', 0x0a
not_found_len:  equ     $ - not_found
