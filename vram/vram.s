; 下記に掲載のプログラムを基に作成した:
; http://d.hatena.ne.jp/rudeboyjet/20080108/p1
; テキストVRAMの使い方は下記を参照:
; https://en.wikipedia.org/wiki/VGA-compatible_text_mode

	; ブートストラップコードは Real-address mode で実行されるので,
	; 32ビットの番地を指定しても下位16ビットのみ使用される.

	; AX, CX, DXは番地の指定に使えない (EAX, ECX, EDXは使える).

	org	0x7c00		; 開始番地

	mov	ax, 0xb800	; VRAMの開始番地 (÷ 16)
	mov	ds, ax		; セグメントレジスタにVRAMの番地を代入
    mov bx, 2000    ; 中央の座標

blackout:
    mov di, bx
    mov cl, ''
    mov ch, 0x00
    mov bx, 0
fill:
    mov [bx], cx
    add bx, 2
    cmp bx, 4000
    jle fill

    mov bx, [cs:fruit] ; アイテムの座標
    cmp bx, 0xffff     ; 存在するか？
    jne exist          ; 存在する場合スキップ
    call genRandom
    mov [cs:fruit], bx

exist:
    mov cl, 'J'
    mov ch, 0x0a
    mov [bx], cx
    call bxWrite

    mov bx, di

input:
    mov ah, 0x01
    int 0x16
    jz skipInput
    mov ah, 0x00
    int 0x16
    jmp write

skipInput:
    mov al, '0'

    ; この時点で保持しておきたいレジスタの中身
    ; al : 入力されたキーのASCIIコード
    ; bx : ＠の位置を保持しておくための座標
write:
    call calcLine   ; 移動前の行位置を計算し、dhで保持
    mov dh, dl

    cmp al, 'a'
    jne notA
    sub bx, 2
    call calcLine   ; 移動後の座標が行をまたぐ場合、移動しない
    cmp dh, dl
    je notA
    add bx, 2
notA:

    cmp al, 's'
    jne notS
    cmp bx, 3840
    jge notS
    add bx, 160
notS:

    cmp al, 'd'
    jne notD
    add bx, 2
    call calcLine   ; 移動後の座標が行をまたぐ場合、移動しない
    cmp dh, dl
    je notD
    sub bx, 2
notD:

    cmp al, 'w'
    jne notW
    cmp bx, 160
    jle notW        ; 画面外に出る場合、移動しない
    sub bx, 160
notW:

    mov cl, '@'
    mov ch, 0x0f
    mov	[bx], cx	; 文字と属性をVRAMに書き込む

    call timer
    jmp blackout 

	hlt             ; HALT (CPUを停止)

timer:
    push eax
    push ecx
    push edx
    mov ah, 0x01
    mov cx, 0
    mov dx, 0
    int 0x1a

loop:
    mov ah, 0x00
    int 0x1a
    cmp dx, 10
    jle loop

    pop edx
    pop ecx
    pop eax
    ret

calcLine:
    ;bxが何行目にいるかを求め、dlに代入する
    push eax
    push ecx
    push edx
    mov ax, bx
    mov cl, 160
    div cl
    pop edx
    mov dl, al
    pop ecx
    pop eax
    ret

bxWrite:
    push eax
    push ebx
    push ecx
    push edx
    mov ax, [cs:fruit] 
    mov bx, 0
divAX:
    mov dx, 0
    mov cx, 10
    div cx
    mov cl, dl
    add cl, '0'
    mov ch, 0x0f
    mov [bx], cx
    add bx, 2
    cmp ax, 0
    jne divAX

    pop edx
    pop ecx
    pop ebx
    pop eax
    ret
    

genRandom:
    ; fruitの座標を自作疑似乱数で生成してbxに代入
    ; xorshift32を用いて乱数を生成
    ; 詳しくは以下の記事を参照されたし。
    ; https://blog.visvirial.com/articles/575
    push eax
    push ecx
    push edx
    mov ah, 0x02    ; 残念ながらでたらめな時刻を取得
    int 0x1a
    mov eax, 0
    mov al, cl
    mov ah, dh
    shl eax, 16
    mov al, ch
    mov ecx, eax
    shl ecx, 13
    xor eax, ecx
    mov ecx, eax
    shr ecx, 17
    xor eax, ecx
    mov ecx, eax
    shl ecx, 15
    xor eax, ecx
    mov ecx, 2000
    mov edx, 0
    div ecx
    mov eax, edx
    mov cx, 2
    mul cx
    mov bx, ax      ; 座標は2の倍数なので2倍する
    pop edx
    pop ecx
    pop eax
    ret


fruit:  dw    0xffff      ; ワームが成長するために必要なアイテムの座標

	; 以降はセクタサイズに合わせるための詰め物
	times	510-($-$$) db 0	; セクタ末尾まで0で埋める ($$は開始番地)
	db	0x55, 0xaa	; Boot Signature
