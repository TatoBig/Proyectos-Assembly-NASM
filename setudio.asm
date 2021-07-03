SECTION .data
        clrscrStr       db      1Bh, '[2J', 1Bh, '[3J', 0h

clrscr:
        mov     eax, clrscrStr
        call printStr
        ret

;----------------------------------------------------------
;recibir en eax la posicion hacia donde se movera el cursor
;ah = x
;al = y
;gotoxy:

;--------------------------------------------
;int strlength (string mensaje)
;Calcula la longitud de la cadena <mensaje> y devuelve un valor entero
;recibe <mensaje> en eax y develve longitud de eax

reverse:
        push ebp           ; prologue
        mov ebp, esp       
        mov eax, [ebp+8]   ; eax <- points to string
        mov edx, eax
look_for_last:
        mov ch, [edx]      ; put char from edx in ch
        inc edx
        test ch, ch        
        jnz look_for_last  ; if char != 0 loop
        sub edx, 2         ; found last
swap:                      ; eax = first, edx = last (characters in string)
        cmp eax, edx       
        jg      end             ; if eax > edx reverse is done
        mov cl, [eax]      ; put char from eax in cl
        mov ch, [edx]      ; put char from edx in ch
        mov [edx], cl      ; put cl in edx
        mov [eax], ch      ; put ch in eax
        inc eax
        dec edx
        jmp swap            
end:
        mov eax, [ebp+8]   ; move char pointer to eax (func return)
        pop ebp            ; epilogue
        ret

strlen:
        push    ebx             ;coloca a ebx en la pila
        mov     ebx, eax        ;ebx igual a eax
sigChar:
        cmp     byte[eax],  0   ;compara el contendio de eax con NULL
        jz      finStrlen       ;si eax igual 0 salta a finStrlen
        inc     eax
        jmp     sigChar         ;si no eax igual eax + 1
finStrlen:
        sub     eax, ebx
        pop     ebx
        ret     
;printStr(string mensaje)
;imprime la cadena <mensaje> en pantalla
;recibe la cadena a imprimir en eax

printStr:
        push    edx             ;inserto edx a la pila
        push    ecx             ;inserto ecx a la pila
        push    ebx             ;inserto ebx a la pila
        push    eax             ;inserto eax a la pila
        call    strlen          ;llama a la longitud de cadena
        mov     edx, eax        ;edx igual eax
        pop     eax             ;extrae eax de la pila (cadena)
        mov     ecx, eax        ;coloca la cadena en ecx
        mov     ebx, 1
        mov     eax, 4
        int     80h
        pop     ebx
        pop     ecx
        pop     edx
        ret
;printStrLn(string mensaje)
;imprime la cadena <mensaje> en pantalla y agrega un salto de linea
;recibe la cadena a imprimir en eax
printStrLn:
        call    printStr        ;imprime en pantalla la cadena que recibe
        push    eax             ;almacena eax en la pila
        mov     eax, 0Ah
        push    eax             ;coloca eax en pila <0Ah>
        mov     eax, esp        ;eax = inicio de la pila
        call    printStr        ;llamada a imprimir en pantalla

        pop     eax
        pop     eax
        ret
        
;---------------------------------------------------------------------
;void salir()

;void iprintt(int numero)
;Impresion de numeros enteros en pantalla
iprint:
        push    eax             ;almacena eax en la pila
        push    ecx             ;almacena ecx en la pila
        push    edx             ;almacena edx en la pila
        push    esi             ;almacena esi en la pila (registro source)
        mov     ecx, 0          ;contador de bytes a imprimir
cicloDiv:
        inc     ecx             ;ecx++
        mov     edx, 0          ;edx = 0
        mov     esi, 10         ;esi = 10
        idiv    esi             ;eax = eax / esi y residuo en edx
        add     edx, 48         ;edx = edx + 48 equivalente ascii
        push    edx             ;almacena el codigo ascii en la pila
        cmp     eax, 0          ;verifica si eax == 0
        jnz     cicloDiv        ;si no es cero salta a cicloDiv
cicloImp:
        dec     ecx             ;ecx--
        mov     eax, esp        ;eax = esp (el puntero de pila)
        call    printStr
        pop     eax
        cmp     ecx, 0
        jnz     cicloImp
        pop     esi
        pop     edx
        pop     ecx
        pop     eax
        ret
        
stringInt:
        xor     ebx, ebx
.next:
        movzx   eax, byte[esi]
        inc     esi
        sub     al,  '0'
        imul    ebx, 10
        add     ebx, eax
        loop    .next
        mov     eax, ebx
        ret
;--------------------------------------
;void iprintLn(int numero)
;Impresion de numeros enteros con fin de linea
iprintLn:
        call    iprint
        push    eax
        mov     eax, 0Ah
        push    eax
        mov     eax, esp
        call    printStr
        pop     eax
        pop     eax
        ret
;---------------------------------------
salir: 
        mov     ebx, 0
        mov     eax, 1
        int     80h
        ret

;----------------------------
; int strlen(String message)

strlength:
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
    call   strlength

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

iprintt:
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

iprintlnn:
    call   iprintt
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