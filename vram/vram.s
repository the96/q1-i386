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
    mov ch, 0x00
    call fillScreen

    mov bx, [cs:fruit] ; アイテムの座標
    cmp bx, 0xffff     ; 存在するか？
    jne exist          ; 存在する場合スキップ
    call genRandom
    mov [cs:fruit], bx

exist:
    mov cl, 'J'
    mov ch, 0x0a
    mov [bx], cx

    mov bx, di

input:
; 0x00の入力読込みでは、入力を受けるまで動作が停止するため、
; ステータス取得を先に行い、入力があれば入力読込みを実行する
    mov ah, 0x01            ; キーボードのステータスを取得
    int 0x16
    jz skipInput            ; zf が false のときは、入力がない状態
    mov ah, 0x00            ; キーボードの入力レジスタから取り出す
    int 0x16                ; (ステータス取得では、レジスタがクリアされない)
    cmp al, 'a'             ; 入力が操作に該当するキーなら受付
    je write
    cmp al, 'w'
    je write
    cmp al, 's'
    je write
    cmp al, 'd'
    je write

skipInput:
    mov al, [cs:direction]  ; 入力がなければ、前回の入力を引き継ぐ

    ; この時点で保持しておきたいレジスタの中身
    ; al : 入力されたキーのASCIIコード
    ; bx : ＠の位置を保持しておくための座標
write:
    mov [cs:direction], al
; caret+lengthの位置に移動前の頭の座標を書き込む。
    mov ecx, 0
    mov cl, [cs:caret]
    mov dl, [cs:length]
    add cl, dl
    cmp cl, max_len
    jl else
    sub cl, max_len
else:
    shl cl, 1
    mov [cs:body + ecx], bx

    call calcLine   ; 移動前の行位置を計算し、dhで保持
    mov dh, dl

    cmp al, 'a'     ; aの入力を受けた場合
    jne notA
    sub bx, 2       ; 右に移動する
    call calcLine   ; 移動後の座標が行をまたぐ場合、ゲームオーバー
    cmp dh, dl      ; 壁にぶつかった場合
    jne dead        ; ゲームオーバー時の処理にジャンプする
notA:

    cmp al, 's'     ; sの入力を受けた場合
    jne notS
    cmp bx, 3840    ; 一番下の行でsを入力した場合はゲームオーバー
    jge dead        ; ゲームオーバー時の処理にジャンプする
    add bx, 160     ; 下の行に移動する
notS:

    cmp al, 'd'     ; dの入力を受けた場合
    jne notD
    add bx, 2
    call calcLine   ; 移動後の座標が行をまたぐ場合、ゲームオーバー
    cmp dh, dl
    jne dead        ; ゲームオーバー時の処理にジャンプする
notD:

    cmp al, 'w'     ; wを受けた場合の処理
    jne notW
    cmp bx, 160     ; 一番上の行でwを入力した場合はゲームオーバー
    jle dead        ; ゲームオーバー時の処理にジャンプする
    sub bx, 160     ; 上の行に移動
notW:
    mov cl, '@'                 ; 入力文字と属性を設定
    mov ch, 0x0f
    mov	[bx], cx	            ; 文字と属性をVRAMに書き込む
    mov al, [cs:caret]          ; caretを進める処理
    inc al
    cmp al, max_len             ; 最後尾を越えたら0に戻す
    jl else3
    mov al, 0
else3:
    mov [cs:caret], al

    mov esi, ebx
    mov cl, 'o'
    mov eax, 0

drawBody:
    cmp al, [cs:length]         ; 体長の分だけ描画する
    jge break
    mov edx, 0
    mov dl, [cs:caret]          ; 身体の座標を取り出すためのアドレスを計算
    add dl, al 
    cmp dl, max_len
    jl else2
    sub dl, max_len
else2:
    shl dl, 1
    add edx, body
    mov bx, [cs:edx]            ; bxに身体を描画する座標を代入
    cmp bx, 0xffff              ; 初期値（身体の座標が指定されていない）
    je notDraw
    cmp bx, si                  ; 自分の身体にぶつかったときはゲームオーバー
    je dead
    mov [bx], cx                ; 描画
notDraw: 
    inc al
    jmp drawBody
break:
   
; アイテム（フルーツ）の拾得処理
    mov ebx, esi
    cmp bx, [cs:fruit]          ; ワームとフルーツの座標の比較
    jne notget                  ; 一致していない
    mov [cs:fruit], word 0xffff ; fruitの座標を削除
    mov eax, 0
    mov al, [cs:length]
    inc al
    cmp al, max_len
    jg notget
    mov [cs:length], al
    add al, [cs:caret]          ; 頭と胴体の間のアドレスの先頭からの距離を求める
    dec al
    cmp al, max_len             ; 配列を越えた場合、先頭に戻る
    jl else4
    sub al, max_len
else4:
    shl al, 1
    mov [cs:body + eax], bx     ; 頭と胴体の間の座標をセット
notget:

    call timer

    jmp blackout 
dead:
    mov ch, 0x44
    call fillScreen

	hlt             ; HALT (CPUを停止)

fillScreen:
    ;chの書式で画面を塗りつぶす
    mov di, bx
    mov cl, ''
    mov bx, 0
fill:
    mov [bx], cx
    add bx, 2
    cmp bx, 4000
    jle fill
    ret

timer:
    mov ah, 0x01
    mov dx, 0
    int 0x1a

loop:
    mov ah, 0x00
    int 0x1a
    cmp dx, 25
    jle loop
    ret

calcLine:
    ;bxが何行目にいるかを求め、dlに代入する
    push eax
    mov ax, bx
    mov cl, 160
    div cl
    mov dl, al
    pop eax
    ret
  
genRandom:
    ; fruitの座標を自作疑似乱数で生成してbxに代入
    ; xorshift32を用いて乱数を生成
    ; 詳しくは以下の記事を参照されたし。
    ; https://blog.visvirial.com/articles/575
    mov ah, 0x02    ; 残念ながらでたらめな時刻を取得
    int 0x1a
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
    ret

max_len:    equ 20 
fruit:      dw  0xffff          ; ワームが成長するために必要なアイテムの座標
direction:  db  0               ; ワームの向いている方向、進行方向
length:     db  0               ; ワームの体の長さ
caret:      db  0               ; ワームの体の配列のうち、現在先頭が何番目か
body:   times max_len dw 0xffff ; ワームの体の座標、初期値は体がない状態

	; 以降はセクタサイズに合わせるための詰め物
	times	510-($-$$) db 0	; セクタ末尾まで0で埋める ($$は開始番地)
	db	0x55, 0xaa	; Boot Signature
    
