    ;Input strings sort by name.Using algorithm is quick sort.
    section .text
    extern print_eax
    global sort_by_name,print_table       ;allow global access
sort_by_name:
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
    mov edx, 8          ;set multiplier
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
    mov esi, 8          ;double word = 4bytes
    mul esi             ;calc address difference
    add eax, ebx        ;add first address of array
    mov esi, eax
    ;esi = address of array's center(partition border)
    
    ;swap border / array[right]
    push dword [edi]    ;
    push dword [esi]    ;
    pop dword [edi]     ;
    pop dword [esi]     ;
    push dword [edi+4]  ;
    push dword [esi+4]  ;
    pop dword [edi+4]   ;
    pop dword [esi+4]   ;
    mov esi, [edi]      ;
    ;esi = partition border
    ;edi = address of array's last(partition border)

    ;compare and swap
    mov eax, ebx        ;set first address of array
    mov edx, edi        ;set last address of array
    sub edx, 8          ;set the second to last address of array
    ;eax = left
    ;edx = right

partition:
    cmp eax, edx        ;left > right
    jg endPartition     ;end loop(partition)

searchGreater:
    push eax            ;escape
    push ebx
    push ecx
    push edx

    mov ebx, 0
    mov eax, [eax]      ;eax<=address1 [charcters]<-[address1]<-[address2]
compareString:
    mov ecx, 0          ;init resister
    mov edx, 0          ;
    mov cl, [eax + ebx] ;read char from eax
    mov dl, [esi + ebx] ;          from esi
    cmp cl,dl           ;compare char
    jne else            ;eax != esi
    cmp cl, 0           ;is it null
    je else             ;eax == esi(next process)
    inc ebx             ;next index of chars
    jmp compareString   ;continue
    
else:
    pop edx             ;restore
    pop ecx
    pop ebx
    pop eax
    jge searchLess      ;eax > esi (next process)
    jl nextString       ;eax < esi (next string)

nextString:
    add eax, 8          ;next address of string
    jmp searchGreater   ;continue

searchLess:
    push eax            ;escape
    push ebx
    push ecx
    push edx
    mov ecx, 0
    mov edx, [edx]      ;edx<=first char's address
compareString2:
    mov eax, 0          ;init resister
    mov ebx, 0          ;
    mov al, [edx + ecx] ;read char from edx
    mov bl, [esi + ecx] ;          from esi
    cmp al, bl          ;compare char
    jne else2           ;not continue
    inc ecx             ;next index of chars
    jmp compareString2  ;continue
else2:
    pop edx             ;restore
    pop ecx
    pop ebx
    pop eax
    jl swap             ;edx < esi (next process)
    jg nextString2      ;edx > esi (next string)
nextString2:
    cmp edx, eax        ;right index < left index
    jl partition        ;skip swap
    sub edx, 8          ;next address of string
    jmp searchLess      ;continue

swap:
    cmp eax, edx        ;left < right
    jge partition        ;else
    
    ;swap [eax]/[edx]
    push dword [eax]    ;
    push dword [edx]    ;
    pop dword [eax]     ;
    pop dword [edx]     ;
    push dword [eax+4]  ;
    push dword [edx+4]  ;
    pop dword [eax+4]   ;
    pop dword [edx+4]   ;

    jmp partition       ;continue partition

endPartition:
    ;swap [eax],[edi]
    push dword [eax]    ;
    push dword [edi]    ;
    pop dword [eax]     ;
    pop dword [edi]     ;
    push dword [eax+4]  ;
    push dword [edi+4]  ;
    pop dword [eax+4]   ;
    pop dword [edi+4]   ;

    ;中身が必要なレジスタ
    ;eax,ebx,edi
    push eax            ;save
    sub eax, ebx        ;difference
    mov edx, 0          ;dividend top 32bits
    mov ecx, 8          ;
    div ecx             ;eax = number of data
    mov ecx, eax        ;
    pop eax             ;restore
    call sort_by_name

    add eax, 8          ;eax + 4bytes
    mov ebx, eax        ;
    mov eax, edi        ;
    sub eax, ebx        ;eax = edi - ebx(center ~ last address)
    add eax, 8          ;add 4bytes(edi)
    mov edx, 0          ;dividend top 32bits
    mov ecx, 8          ;
    div ecx             ;eax = number of data
    mov ecx, eax        ;
    call sort_by_name

endSort:

    pop edi             ;
    pop esi             ;
    pop edx             ;
    pop ecx             ;
    pop ebx             ;
    pop eax             ;

    ret



print_table:
	push eax
	push ebx
	push ecx
	push edx

loopPrint:	
	cmp ecx, 0				;end rule
	jle end

	push ebx				;escape
	push ecx				;

	mov edx, 0				;init before countString
	mov ecx, [ebx]			;start address of output string

countString:
	mov al, [ecx + edx]	;read more char

	cmp al, 0				;eax == null
	je printString			;end loop
	inc edx					;count up
	jmp countString			;continue count

printString:
	mov eax, 4				;write system call number
	mov ebx, 1				;standard output
	int 0x80				;

printTabs:
	mov eax, 4
	mov ebx, 1
	mov ecx, tab			;insert tabs
	mov edx, 1				;length
	int 0x80

printScore:
	pop ecx					;restore
	pop ebx					;

	mov eax, [ebx + 4]		;input score
	call print_eax

    ;mov eax, ecx 
    ;call print_eax

Continue:
	add ebx, 8				;move next data
	dec ecx					;count remaining data
	jmp loopPrint			;continue print

end:	
	pop edx
	pop ecx
	pop ebx
	pop eax
	ret

	section .rodata			;read-only data
tab:	db	0x09			;tab
