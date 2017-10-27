    section .text
    global print_mem
print_mem:
    push eax
    push ebx
    push ecx
    push edx

    ;ecx = first address
    ;edx = length
    mov ecx, [eax]
    mov edx, 0

cntLength:
    mov al, [ecx + edx]
    cmp al, 0
    je print
    inc edx
    jmp cntLength

print:
    mov eax, 4
    mov ebx, 1
    int 0x80

    mov eax, 4
    mov ebx, 1
    mov ecx, nl
    mov edx, 1
    int 0x80

    pop edx
    pop ecx
    pop ebx
    pop eax
    ret
    
    section .data
nl: db 0xa
