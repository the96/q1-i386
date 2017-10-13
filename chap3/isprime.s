    ;check if target number is a prime number
    section .text
    global _start
_start:
    mov ebx, 12379  ;input tested number
    mov ecx, 2      ;start test divisor
checkPrime:
    mov eax, ebx    ;a dividend
    mov edx, 0      ;a dividend(top 32 bit)
    div ecx         ;edx = edx % ecx

    cmp edx, 0      ;if edx == 0(edx % ecx == 0)
    jne else        ;edx == 0 => jump then

;then:
    mov ebx, 1      ;not prime number
    jmp end         ;loop end
else:
    inc ecx         ;ecx += 1
    cmp ecx, ebx    ;if ecx == ebx(end case)
    jne checkPrime  ;jump loop head
    mov ebx, 0      ;prime number
    jmp end         ;loopend
end:
    mov eax, 1      ;system call number
    int 0x80        ;exit system call
