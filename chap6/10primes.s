	;; 任意定数N以下の素数のうち大きい方から10番目の数までを計算して出力するプログラム
	section .text
	global _start
	extern print_eax	; 別ファイルのラベル
N:	equ 255			; 素数判定対象数 n
_start:
	mov ebx, N		; 素数判定対象数 n を代入
	mov ecx, 2		; (n までの除数) 各整数 d
	mov esi, 0		; 素数の個数
loop0:	
	mov eax, ebx		; n を eax にコピー
	mov edx, 0		; 剰余を0にする
	div ecx			; n を d で割る

	cmp edx, 0		; 剰余が0かどうか
	je false		; 等しければ false へ
	
	inc ecx			; そうでないなら d を 1 増やす
	cmp ecx, ebx		; d が n より小さいかどうか
	jl loop0		; 小さいなら loop0 へ

	jmp true		; n が素数であるため true へ
	
true:				; n が素数のとき
	mov eax, ebx		; ebx (素数)の値を eax に代入
	call print_eax		; eaxの値を10進数で出力
	inc esi			; 素数の個数を 1 増やす
	cmp esi, 10		; 素数の個数が 10 かどうか
	je end			; 10 番目の素数のとき
	
false:				; n が素数でないとき(trueの後処理と同じ)
	dec ebx			; n の数字から 1 引く
	mov ecx, 2		; d の値の初期化
	cmp ebx, 2		; n が 2 以下かどうか
	jle end			; 2 以下なら end へ
	jmp loop0		; そうでないなら loop0 へ
	
end:
	mov eax, 1		; システムコール番号
	int 0x80		; exit システムコール
