    ;the tenth largest prime number under 255
    section .text
    global _start
_start:
    mov edi, 0      ;count number of prime number
    mov ebx, 255    ;input first test number

nPrimeLoop:
    mov ecx, 2      ;start test division

checkPrime:
    mov eax, ebx    ;a divisor
    mov edx, 0      ;a divisor(top 32 bit)
    div ecx         ;edx = edx % ecx

    cmp edx, 0      ;if edx == 0(edx % ecx == 0)
    jne else        ;edx != 1

    jmp endChkPrime ;then loop end

else:
    inc ecx         ;ecx += 1
    cmp ecx, ebx    ;if ecx == ebx(end case)
    jne checkPrime  ;else jump loop head

    inc edi         ;then find prime number
    jmp endChkPrime ;loopend

endChkPrime:
    cmp edi, 10     ;found 10th largest prime number
    je end          ;then jump end

    dec ebx         ;else decrement
    jmp nPrimeLoop  ;jump loop head

end:
    mov eax, 1      ;system call number
    int 0x80        ;exit system call
