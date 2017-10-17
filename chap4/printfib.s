    ;print Fibonacci number 2 to 20
len:    equ 4      ;output max length
    section .text
    global _start
_start:
    mov dword [fn1], 1  ;f(1) = 1
    mov dword [fn2], 0  ;f(0) = 0
    mov edi,   2        ;n = 2

loopFib:
    mov eax,  [fn1] ;
    add [fn2], eax  ;f(n - 1) + f(n - 2)
    mov esi,  [fn2] ;esi = f(n - 1) + f(n - 2)
    mov [fn2], eax  ;f(n - 2) = f(n - 1)
    mov [fn1], esi  ;f(n) = esi

    jmp funcPrint   ;print f(n)
backFib:

    inc edi         ;n++
    cmp edi, 20     ;edi <= 20
    jle loopFib     ;continue loop
    jmp endProg     ;end calculate

;===Print=============================
funcPrint:
    mov eax, [fn1]  ;set dividend
    mov edx, 0      ;set dividend(top 32 bits)
    mov ebx, 10     ;set divisor
    mov ecx, buf + len  ;last char
    mov esi, 1      ;difine counter
loop0:
    dec ecx         ;next address
    div ebx         ;eax = N / 10,edx = N % 10
    add dl, '0'     ;get last single digit,add 0x30
    mov [ecx], dl   ;add char of digit
    mov edx, 0      ;edx reset
    inc esi         ;count digit
    cmp eax, 0      ;eax == 0
    jne loop0

    mov eax, 4      ;system call number
    mov ebx, 1      ;standard output
    mov edx, esi    ;output length
    int 0x80        ;write system call
    jmp backFib     ;end funcPrint
;===Print===================================


endProg:
    mov eax, 1      ;system call number
    mov ebx, 0      ;exit code
    int 0x80        ;exit system call

    section .data
buf:    times len db 0  ;len of char area
        db 0x0a         ;new line
fn1:    dd  0           ;f(n-1)
fn2:    dd  0           ;f(n-2)
