        ; eaxの値を10進数で標準出力に出力する.
        ; 数字は8.24形式の固定小数点数とする． 
    
nchar:  equ 4                    ; 任意定数の桁数は4桁まで
    
    section .text
    global  print_eax_frac       ; 別ファイルから参照可能にする
print_eax_frac:
    push eax
    push ebx
    push ecx
    push edx
    push esi
    push edi
    mov ecx, buf + nchar        ; 文字を代入する先頭番地

    test eax,eax                ; 補数ならSFがTRUE
    jns notMinus
    dec eax
    not eax
    mov bl, '-'                 ; マイナスをいれておく

notMinus:
    push eax
    shr eax, 24                 ; 整数部分を取り出し
    mov edx, 0                  ; 余り
    mov esi, 0                  ; 文字列の長さ
    mov edi, 10                 ; 除数

loop0:
    dec ecx                     ; 代入先を移動
    div edi                     ; 下一桁を取り出す
    add edx, '0'                ; 文字コードに変換
    mov [ecx], dl               ; 代入
    mov edx, 0                  ; 次のループの割り算に備える
    inc esi                     ; 数列の長さを加算
    cmp eax, 0                  ; 各桁に分解し終えたら終了
    jne loop0

    cmp bl , '-'                ; マイナスだったら先頭に追加
    jne write
    dec ecx
    mov [ecx], bl
    inc esi
write:
    mov eax, 4                  ; writeのシステムコール番号
    mov ebx, 1                  ; 標準出力
    mov edx, esi                ; 文字列の長さ
    int 0x80

    pop eax
    mov ecx, frac               ; 小数用の領域の先頭番地を代入
    mov esi, 1                  ; 既に小数点が代入済みなので長さを1
    and eax, 0x00ffffff         ; 小数部のみを取り出す
loop1:
    mov ebx, eax
    shl eax, 1                  ; 2倍
    shl ebx, 3                  ; 8倍
    add ebx, eax                ; 足して10倍
    mov eax, ebx
    shr ebx, 24                 ; 整数部を取り出し
    add bl, '0'                 ; 文字コードに変換
    mov [ecx + esi], bl         ; 出力用の主記憶に書き込み
    inc esi                     ; 桁数をカウント
    and eax, 0x00ffffff         ; 小数部を取り出し
    cmp eax, 0                  ; 小数部がなくなれば終了
    je writeFrac
    jmp loop1
writeFrac:
    mov [ecx + esi], byte 0x0a
    inc esi
    mov eax, 4
    mov ebx, 1
    mov edx, esi
    int 0x80

    pop edi
    pop esi
    pop edx
    pop ecx
    pop ebx
    pop eax
    
        ret                     ; print_eaxの終端

        section .data
buf:    times nchar db 0        ; 文字列の領域確保
frac:   db '.'                  ; 小数部分の領域確保
