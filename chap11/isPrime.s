    section .text
    global isPrime
isPrime:
    push ebp
    mov ebp, esp
    push ebx
    mov eax, [ebp + 8]
    mov ebx, [ebp + 12]
    mov [ebx], byte 1         ; 0は素数ではない(配列の初期化のことを考えて真偽値は反転)
    mov [ebx + 1], byte 1     ; 1は素数ではない
    cmp eax, [maxPrime]         ; 既に計算済みの範囲なら計算しない
    jle endPrime
    mov ecx, 2 

eratosthenes:
    mov edx, ecx
    cmp byte [ebx + edx], 1   ; 素数でないなら飛ばす
    je skipLoop0
loop0:
    add edx, ecx                ; 最大値(2^32)を越えたら終了
    jc skipLoop0                ; つまり、桁溢れが発生したら終了
    cmp edx, eax
    jg skipLoop0
    mov [ebx + edx], byte 1   ; 素数でないのでチェックをつける
    jmp loop0
skipLoop0:
    cmp ecx, maxNum
    je endPrime
    inc ecx
    cmp ecx, eax
    jge endPrime
    jmp eratosthenes

endPrime:
    cmp eax, [maxPrime]
    jle notMax
    mov [maxPrime], eax
notMax:
    mov ecx, 0
    mov cl, [ebx + eax]
    mov eax, ecx
    pop ebx
    pop ebp
    ret

maxNum: equ 4294967295
    section .data
maxPrime:   dd  2           ; 既に検索したもっとも大きな素数を代入しておく
                            ; 複数回実行したとき、計算量を減らすため
