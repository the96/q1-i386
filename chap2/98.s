    section .text
    global _start
_start:
    mov     ebx, 98     ;ebx=98
    add     ebx, 7      ;ebx=edx+7
    mov     eax, 6      ;eax=6
    mov     edx, 5      ;edx=5
    mul     edx         ;eax=eax*edx
    sub     ebx, eax    ;edx=ebx-eax
    mov     eax, 4      ;eax=4
    mov     edx, 3      ;edx=3
    mul     edx         ;eax=eax*edx
    mov     edx, 2      ;edx=2
    mul     edx         ;eax=eax*edx
    add     ebx, eax    ;ebx=eax
    add     ebx, 1      ;ebx=ebx+1
    mov     eax, 1      ;number of system call
    int     0x80        ;exit system call
