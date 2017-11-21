section .text
	global sort
sort:
	push ebp            ; ebpを退避
	mov ebp, esp        ; この時点のespをebpにコピー
	push ebx
	push esi
	push edi

	mov esi, [ebp + 8]	; 第1引数(配列の先頭アドレス)を読み出す
	mov edi, [ebp + 12]	; 第2引数(要素の個数)を読み出す
	mov edx, [ebp + 16]	; 第3引数(要素の大きさ)を読み出す

	cmp edi, 1 		; 要素数が1のとき
	jle endSort
loop0:
	push esi	        ; esi の番地を保存
	push edi		; edi を比較回数のカウンタとして一時使用
	dec edi
	mov ecx, 0		; 入れ替え回数カウンタ
loop1:	
	mov eax, dword [esi]
	add esi, edx		; 次の番地へ
	mov ebx, dword [esi]
	cmp eax, ebx		; 数字を比較して並べ替えるか確認する
	jl stay

	;; ecx に，要素の個数を一時的に代入する
	push ecx
	push eax
	push ebx
	push edx
	mov eax, edx
	mov edx, 0
	mov ebx, 4
	div ebx
	mov ecx, eax		; 値の個数
	pop edx
	pop ebx
	pop eax

	;; 値を交換
	push esi		; 現在の番地を保存
swap:	
	mov eax, [esi]		; その番地に格納されている値1を保存
	sub esi, edx		; 前の番地へ
	mov ebx, [esi]		; その番地に格納されている値2を保存
	mov [esi], eax		; 値1を代入
	add esi, edx		; 次の番地へ
	mov [esi], ebx		; 値2を代入
	dec ecx
	jz swapEnd		; 要素の個数回の交換が終了したとき
	add esi, 4		; 次の交換する要素の番地に移動
	jmp swap
swapEnd:
	pop esi			; 番地を元に戻す
	pop ecx
	inc ecx			; 入れ替え回数カウント
stay:
	dec edi			; 比較回数カウント
	jz check
	jmp loop1
check:
	pop edi
	pop esi
	cmp ecx, 0
	je endSort		; 入れ替えが発生していないなら
	jmp loop0
endSort:
	pop edi
	pop esi
	pop ebx
	pop ebp
	
	ret
