;----------------------------
; int strlen(String message)

strlen:
    push   ebx
    mov    ebx, eax

.nextchar:
    cmp    byte[eax], 0
    jz     .finished
    inc    eax
    jmp    .nextchar

.finished:
    sub    eax, ebx
    pop    ebx
    ret

;----------------------------
; void sprint(String message)

sprint:
    push   edx
    push   ecx
    push   ebx
    push   eax
    call   strlen

    mov    edx, eax ; move string len from eax to edx
    pop    eax      ; restore eax to string pointer

    mov    ecx, eax ; move string pointer to ecx
    mov    ebx, 1   ; 
    mov    eax, 4   ; opcode 4
    int    80h      ; make syscall

    pop    ebx
    pop    ecx
    pop    edx
    ret

;----------------------------
; void sprintln (String message)

sprintln:
    call   sprint    ; print string found at eax
    push   eax       ; preserve eax
    mov    eax, 0Ah
    call   putchar
    pop    eax
    ret

;----------------------------
; void putchar (char)

putchar:
    push   edx 
    push   ebx
    push   ecx
    push   eax     ; eax has character
    mov    edx, 1
    mov    ecx, esp
    mov    ebx, 1
    mov    eax, 4
    int    80h
    pop    eax
    pop    ecx
    pop    ebx
    pop    edx 
    ret

;------------------------------
; newline

newline:
    push   eax
    mov    eax, 0ah
    call   putchar
    pop    eax
    ret

;-----------------------------
; void iprint(int)

iprint:
    push   eax
    push   ecx
    push   edx
    push   esi
    push   edi

    xor    edi, edi
    xor    ecx, ecx
    test   eax, eax
    js     .negate

.divide:
    inc    ecx
    xor    edx, edx
    mov    esi, 10
    idiv   esi
    add    edx, 48
    push   edx
    cmp    eax, 0
    jnz    .divide

    cmp    edi, 1
    je     .printNegative

.print:
    dec    ecx
    mov    eax, esp
    call   sprint
    pop    eax
    cmp    ecx, 0
    jnz    .print
    jmp    .end

.negate:
    mov    edi, 1
    neg    eax
    jmp    .divide

.printNegative:
    push   45d
    inc    ecx
    jmp    .print

.end:
    pop    edi
    pop    esi
    pop    edx
    pop    ecx
    pop    eax
    ret

;-----------------------
; iprintln 

iprintln:
    call   iprint
    call   newline
    ret


;----------------------------
; atoi

atoi:
    push   ecx
    push   esi
    push   ebx

    mov    esi, eax  ; move string pointer to esi as eax will be used for math
    mov    eax, 0
    mov    ecx, 0

    xor    edi, edi  ; negative flag and error flag

    cmp    byte [esi], 45   ; "-"
    je     .negative

.parse:
    xor    ebx, ebx
    mov    bl, [esi + ecx]

    cmp    bl, 10
    je     .terminated
    cmp    bl, 0
    jz     .terminated
    cmp    bl, 48     ; "0"
    jl     .error
    cmp    bl, 57     ; "9"
    jg     .error

    sub    bl, 48
    add    eax, ebx
    mov    ebx, 10
    mul    ebx
    inc    ecx
    jmp    .parse

.negative:
    inc    ecx
    mov    edi, 1     ; make sign negative
    jmp    .parse


.negate:
    neg    eax
    mov    edi, 0     ; because edi is both negative and error, make sure to clear it
    jmp    .end

.error:
    mov    edi, 1
    jmp    .end

.terminated:
    mov    ebx, 10
    div    ebx
    cmp    edi, 1
    je     .negate

.end:
    pop    ebx
    pop    esi
    pop    ecx
    ret


;----------------------------
; void quit()

quit:
    mov    ebx, 0  ; exit code 0
    mov    eax, 1  ; opcode 
    int    80h
    ret