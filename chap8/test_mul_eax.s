    section .text
    global _start
    extern mul_eax_edx, print_eax
_start:
    mov eax, 0
    mov edx, 0
    call mul_eax_edx
    call print_eax
    
    mov eax, 1
    mov edx, 2
    call mul_eax_edx
    call print_eax

    mov eax, 123
    mov edx, 234
    call mul_eax_edx
    call print_eax

    mov eax, 0xffffffff
    mov edx, eax
    call mul_eax_edx
    call print_eax

    mov eax, 1
    mov ebx, 0
    int 0x80
