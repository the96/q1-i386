    section .text
    global _start
    extern print_eax_hex
_start:
    mov eax, 0x8a4
    call print_eax_hex
    mov eax, 0xffffffff
    call print_eax_hex
    mov eax, 0
    call print_eax_hex

    mov eax, 1          ;exit system call number
    mov ebx, 0          ;
    int 0x80
