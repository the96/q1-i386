    section .text
    global mul_eax_edx
mul_eax_edx:
    push ebx
    push ecx
    push edx
    push esi
    push edi

    mov esi, 0
loop:
    test edx, 1     ;get last bit
    jz skip         ;if zf,skip
    add esi, eax    ;if nz,esi += eax
skip:
    shr edx, 1      ;next carry
    shl eax, 1      ;carry up
    cmp edx, 0
    jg loop

    mov eax, esi

    pop edi
    pop esi
    pop edx
    pop ecx
    pop ebx
    ret
