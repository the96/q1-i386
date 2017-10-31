    section .text
    global mul_eax_edx
    extern print_eax
mul_eax_edx:
    push ebx
    push ecx
    push edx
    push esi
    push edi

    mov cl, 0      ;counter reset
    mov esi, 0
loop:
    mov ebx, edx
    and ebx, 1      ;get last bit
    cmp ebx, 1      ;last bit is 1
    jne skip
    mov edi, eax
    shl edi, cl     ;edi *= 2 ^ cl
    add esi, edi    ;sum
skip:
    shr edx, 1
    inc ecx
    cmp edx, 0
    jg loop

    mov eax, esi

    pop edi
    pop esi
    pop edx
    pop ecx
    pop ebx
    ret
