    ;Solving problem 1.6.5.
    ;This source code used hash algorithm, xxHash.
    section .text
    global map_init, map_add, map_get

map_init:           ;do nothing
    ret

map_add:
    push    eax
    push    ebx
    push    ecx
    push    edx
    push    esi
    push    edi

    push ecx        ;escape score
    mov eax, 0      ;init hash key
    mov esi, 0      ;init counter
    mov edx, 0      ;init index of ebx

createHash0:
    push eax        ;escape hash
    mov eax, 0      ;calc new hash

read4Bytes0:
    push edx
    mov ecx, 0xff
    mul ecx
    pop edx

    mov ecx, 0
    mov cl, [ebx + edx]
    cmp cl, 0
    je skip0         ;reach end of string
    add eax, ecx
    inc edx

skip0:
    inc esi
    cmp esi, 4
    jl read4Bytes0

    ;<don't overwriter>
    ;cl > end of read and hash
    ;eax > hash key
    ;edx > index of ebx
    ;ebx > address of input string

xxHash:
    ;xxHash is hash algorithm thought by Cyan4973
    ;https://github.com/Cyan4973/xxHash
    ;I referenced this article.
    ;https://qiita.com/yuji_yasuhara/items/adefc967c51a6becca08
    push edx

    mov esi, PRIME32_3          ;eax *= PRIME32_3
    mul esi

    mov esi, eax                ;eax = (eax << 17) || (eax >>> 15)
    shl esi, 17
    shr eax, 15
    add eax, esi

    mov esi, PRIME32_4          ;eax *= PRIME32_4
    mul esi

    mov esi, eax                ;eax ^= eax>>15
    shr esi, 15
    xor eax, esi

    mov esi, PRIME32_2          ;eax *= PRIME32_2
    mul esi

    mov esi, eax                ;eax ^= eax >> 13
    shr esi, 13
    xor eax, esi

    mov esi, PRIME32_3          ;eax *= PRIME32_3
    mul esi

    mov esi, eax                ;eax ^= eax << 16
    shr esi, 16
    xor eax, esi
    
    mov edx, 0
    mov esi, ndata
    div esi
    mov esi, edx                ;esi = eax % ndata

    pop edx
    pop eax
    
    add eax, esi                ;add total of hash and hash

    cmp ecx, 0
    jne createHash0

    mov edx, 0
    mov ecx, ndata
    div ecx
    mov eax, edx                ;eax = eax % nadata

checkAddress0:                  ;check the address is inputable
    cmp eax, ndata              ;over range of address
    jl else0
    mov eax, 0

else0:
    mov esi, 0
    cmp [data + eax * 8], esi   ;input none
    je inputScore

    mov esi, 0
compareString0:
    mov edi, [data + eax * 8]
    mov cl, [edi + esi]
    mov dl, [ebx + esi]
    cmp cl, dl
    je equal0

    inc eax                     ;not same name, next address
    jmp checkAddress0
equal0:
    cmp cl, 0                   ;same name
    je inputScore

    inc esi
    jmp compareString0

inputScore:
    pop ecx
    mov [data + eax * 8], ebx
    mov [data + eax * 8 + 4], ecx

    pop    edi
    pop    esi
    pop    edx
    pop    ecx
    pop    ebx
    pop    eax
    ret

;;; ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
map_get:    
    push    ebx
    push    ecx
    push    edx
    push    esi
    push    edi

    mov eax, 0      ;init hash key
    mov esi, 0      ;init counter
    mov edx, 0      ;init index of ebx

createHash1:
    push eax
    mov eax, 0

read4Bytes1:
    push edx
    mov ecx, 0xff
    mul ecx
    pop edx

    mov ecx, 0
    mov cl, [ebx + edx]
    cmp cl, 0
    je skip1         ;reach end of string
    add eax, ecx
    inc edx

skip1:
    inc esi
    cmp esi, 4
    jl read4Bytes1

    ;<don't overwriter>
    ;cl > end of read and hash
    ;eax > hash key
    ;edx > index of ebx
    ;ebx > address of input string

xxHash1:
    ;same code(51-102 lines)
    push edx

    mov esi, PRIME32_3
    mul esi

    mov esi, eax
    shl esi, 17
    shr eax, 15
    add eax, esi

    mov esi, PRIME32_4
    mul esi

    mov esi, eax
    shr esi, 15
    xor eax, esi

    mov esi, PRIME32_2
    mul esi

    mov esi, eax
    shr esi, 13
    xor eax, esi

    mov esi, PRIME32_3
    mul esi

    mov esi, eax
    shr esi, 16
    xor eax, esi

    mov edx, 0
    mov esi, ndata
    div esi
    mov esi, edx

    pop edx
    pop eax

    add eax, esi

    cmp ecx, 0
    jne createHash1

    mov edx, 0
    mov ecx, ndata
    div ecx
    mov eax, edx                ;eax = eax % nadata

checkAddress1:                  ;check the address is inputable
    cmp eax, ndata              ;over range of address
    jl else1
    mov eax, 0

else1:
    mov esi, 0
    cmp [data + eax * 8], esi   ;input none
    je notfound

    mov esi, 0
compareString1:
    mov edi, [data + eax * 8]
    mov cl, [edi + esi]
    mov dl, [ebx + esi]
    cmp cl, dl
    je equal1

    inc eax                     ;not same name, next address
    jmp checkAddress1
equal1:
    cmp cl, 0                   ;same name
    je outputScore

    inc esi                     ;read more
    jmp compareString1

outputScore:
    mov ebx, 8
    mul ebx
    add eax, data
    add eax, 4
    jmp return

notfound:
    mov eax, 0

return:
    pop edi
    pop esi
    pop edx
    pop ecx
    pop ebx
    ret

    section .data
data:    times 400000 dd 0    ; ハッシュテーブル
ndata:    equ    ($ - data) / 8    ; データの件数

PRIME32_2: equ 2246822519
PRIME32_3: equ 3266489917
PRIME32_4: equ 668265263
PRIME32_5: equ 374761393
