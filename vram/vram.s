; 下記に掲載のプログラムを基に作成した:
; http://d.hatena.ne.jp/rudeboyjet/20080108/p1
; テキストVRAMの使い方は下記を参照:
; https://en.wikipedia.org/wiki/VGA-compatible_text_mode

	; ブートストラップコードは Real-address mode で実行されるので,
	; 32ビットの番地を指定しても下位16ビットのみ使用される.

	; AX, CX, DXは番地の指定に使えない (EAX, ECX, EDXは使える).

	org	0x0		; 開始番地
	mov	ax, 0xB800
	mov	ds, ax		; セグメントレジスタにVRAMの番地を代入

	mov	bx, 0		; VRAM上の番地
	mov	cx, 25		; ループ回数
	mov	al, 'A'		; 表示する文字
	mov	ah, 0x1c	; 表示属性 (青背景, 赤字)
loop0:
	mov	[bx], ax	; 文字と属性をVRAMに書き込む
	add	bx, 2 * 82	; 82文字後ろ (= 右下)
	inc	al		; 次の文字
	dec	cx		; 残り回数を減らす
	jnz	loop0		; 0でなければループ

	hlt			; HALT (CPUを停止)

	times	510-($-$$) db 0	; セクタ末尾まで0で埋める ($$は開始番地)
	db	0x55, 0xaa	; Boot Signature
