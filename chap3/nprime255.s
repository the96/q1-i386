	;; 255 以下の素数の個数を計算して出力するプログラム
	section .text
	global _start
_start:
	mov ebx, 255		; 素数判定対象数 n
	mov ecx, 2		; (除算に使用する n までの) 各整数 d
	mov esi, 1		; 素数の個数(2は素数であるためすでにカウントしている)
loop0:	
	mov eax, ebx		; n を eax にコピー
	mov edx, 0		; 前回の計算結果の剰余を消去
	div ecx			; n を d で割る

	cmp edx, 0		; 剰余が0かどうか
	je false		; 等しければ false へ
	
	inc ecx			; そうでないなら d を 1 増やす
	cmp ecx, ebx		; d が n より小さいかどうか
	jl loop0		; 小さいなら loop0 へ

	jmp true		; n が素数であるため true へ
	
true:				; n が素数のとき
	inc esi			; 素数の個数を 1 増やす
	
false:				; n が素数でないとき(trueの後処理と同じ)
	dec ebx			; n の数字から 1 引く
	mov ecx, 2		; d の値の初期化
	cmp ebx, 2		; n が 2 以下かどうか
	jle end			; 2 以下なら end へ
	jmp loop0		; そうでないなら loop0 へ
	
end:
	mov ebx, esi		; 素数の個数を代入
	mov eax, 1		; システムコール番号
	int 0x80		; exitシステムコール
