    section .text
    global isPrime
isPrime:
    mov eax, [esp + 4]
    mov ecx, 2
    cmp eax, ecx
    jl notPrime
loop0:
    cmp eax, ecx
    je itsPrime
    mov edx, 0
    div ecx
    cmp edx, 0
    je notPrime
    cmp eax, ecx
    jl itsPrime
    inc ecx
    mov eax, [esp + 4]
    jmp loop0

itsPrime:
    mov eax, 1
    ret

notPrime:
    mov eax, 0
    ret
