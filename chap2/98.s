    ;; This program calculate 98 + 7 - (6 * 5) + (4 * 3 * 2) + 1 and print that answer
    section .text
    global _start
_start:
    mov ebx, 98     ;ebx = 98
    add ebx, 7      ;ebx = ebx + 7
    mov edx, 6      ;edx = 6
    mov eax, 5      ;eax = 5
    mul edx         ;eax = eax * edx
    sub ebx, eax    ;edx = edx - eax
    mov edx, 4      ;edx = 4
    mov eax, 3      ;eax = 3
    mul edx         ;eax = eax * edx
    mov edx, 2      ;edx = 2
    mul edx         ;eax = eax * edx
    add ebx, eax    ;ebx = ebx + eax
    add ebx, 1      ;ebx = ebx + 1
    mov eax, 1      ;number of system call
    int 0x80        ;exit system call
