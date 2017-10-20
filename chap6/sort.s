    section .text
    global sort             ;allow global access
sort:
    push eax
    push ebx
    push ecx
    push edx
    push esi
    push edi
    ;ebx = address of array's first
    ;ecx = array's length

    cmp ecx, 1 
    jle endSort 

    ;calculation last address
    mov eax, ecx        ;set multiplicand
    dec eax             ;index = number - 1
    mov edx, 4          ;set multiplier
    mul edx             ;calc address difference
    add eax, ebx        ;add first address of array
    mov edi, eax
    ;edi = address of array's last

    cmp ebx, edi        ;left < right
    jl quicksort        ;
    jmp endSort         ;

quicksort:
    ;calculation center address
    mov eax, ecx        ;set dividend
    mov edx, 0          ;set dividend (top 32bits)
    mov esi, 2          ;set divisor
    div esi             ;eax = ecx / 2
    ;dec eax
    mov esi, 4          ;double word = 4bytes
    mul esi             ;calc address difference
    add eax, ebx        ;add first address of array
    mov esi, eax
    mov eax, [esi]
    ;esi = address of array's center(partition border)
    
    ;swap border / array[right]
    mov eax, [edi]      ;
    mov edx, [esi]      ;
    mov [esi], eax      ;
    mov [edi], edx      ;
    mov esi, [edi]      ;
    ;esi = partition border
    ;edi = address of array's last(partition border)

    ;compare and swap
    mov eax, ebx        ;set first address of array
    mov edx, edi        ;set last address of array
    sub edx, 4          ;set the second to last address of array
    ;eax = left
    ;edx = right

partition:
    cmp eax, edx        ;left > right
    jg endPartition    ;end loop(partition)

searchGreater:
    cmp [eax], esi      ;
    jge searchLessEqual ;end loop and jump next loop
    add eax, 4          ;next address
    jmp searchGreater   ;continue loop

searchLessEqual:
    cmp [edx], esi      ;[edx] < esi
    jl swap             ;end loop and jump next step
    cmp edx, eax        ;edx < eax
    jl swap             ;end loop and jump next step
    sub edx, 4          ;next address
    jmp searchLessEqual ;continue loop

swap:
    cmp eax, edx        ;left < right
    jge skipSwap        ;else
    
    ;swap [eax]/[edx]
    push dword [eax]    ;
    push dword [edx]    ;
    pop dword [eax]     ;
    pop dword [edx]     ;
skipSwap:
    jmp partition       ;continue loop

endPartition:
    ;swap [eax],[edi]
    push dword [eax]    ;
    push dword [edi]    ;
    pop dword [eax]     ;
    pop dword [edi]     ;

    ;中身が必要なレジスタ
    ;eax,ebx,edi
    push eax            ;save
    sub eax, ebx        ;difference
    mov edx, 0          ;dividend top 32bits
    mov ecx, 4          ;
    div ecx             ;eax = number of data
    mov ecx, eax        ;
    pop eax             ;restore
    call sort

    add eax, 4          ;eax + 4bytes
    mov ebx, eax        ;
    mov eax, edi        ;
    sub eax, ebx        ;eax = edi - ebx(center ~ last address)
    add eax, 4          ;add 4bytes(edi)
    mov edx, 0          ;dividend top 32bits
    mov ecx, 4          ;
    div ecx             ;eax = number of data
    mov ecx, eax        ;
    call sort

endSort:

    pop edi             ;
    pop esi             ;
    pop edx             ;
    pop ecx             ;
    pop ebx             ;
    pop eax             ;

    ret
