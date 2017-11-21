    section .text
    global isPrime
isPrime:
    mov eax, [esp + 4]      ; 引数を取得
    mov ecx, 2              ; 除数の初期値をセット
    cmp eax, ecx            ; 2未満の数は素数ではない
    jl notPrime
loop0:
    cmp eax, ecx            ; 除数と被除数が一致した場合は素数
    je itsPrime
    mov edx, 0
    div ecx                 ; 試し割り
    cmp edx, 0              ; 余りが0なら素数ではない
    je notPrime
    cmp eax, ecx            ; 商が除数より小さい場合、除数は平方根を越えている
    jl itsPrime
    inc ecx                 ; 次の除数へ
    mov eax, [esp + 4]      ; 被除数をセット
    jmp loop0

itsPrime:
    mov eax, 1
    ret

notPrime:
    mov eax, 0
    ret
