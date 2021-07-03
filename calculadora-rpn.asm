%include 'studio.asm'

SECTION .data
    stack_size:     dd 0        
    stack: times 256 dd 0   
    msg1            db      'Error', 0h
    msg2            db      'Resultado: ', 0h
    msg3            db      '54*', 0h

SECTION .text
    global _start
    _start:
        mov     esi, msg3        
        push    esi
        call    strlen_1
        mov     ebx, eax          
        add     esp, 4
        mov     ecx, 0            
    inicio:
        cmp     ecx, ebx            
        jge     terminar
        mov     edx, 0
        mov     dl, [esi + ecx]      
        cmp     edx, '0'
        jl      simbolo
        cmp     edx, '9'
        jg      error
        sub     edx, '0'
        mov     eax, edx         
        jmp     charSiguiente
    simbolo:
        push    ecx
        push    ebx
        call    popPila
        mov     edi, eax            
        call    popPila    
        pop     ebx
        pop     ecx
        cmp     edx, '+'
        je      sumar
        cmp     edx, '-'
        je      restar
        cmp     edx, '*'
        je      multipilicar
        cmp     edx, '/'
        je      dividir
        jmp     error
    sumar: 
        add     eax, edi
        jmp     charSiguiente
    restar:
        sub     eax, edi                 
        jmp     charSiguiente
    multipilicar:            
        imul     eax, edi                
        jmp     charSiguiente
    dividir:          
        push    edx                     
        mov     edx, 0
        idiv    edi                    
        pop     edx
    charSiguiente:
        push    eax
        push    ecx
        push    edx
        push    eax          
        call    pushPila
        add     esp, 4
        pop     edx
        pop     ecx
        pop     eax
        inc     ecx
        jmp     inicio
    terminar:
        cmp     byte [stack_size], 1      
        jne     error
        mov     eax, msg2
        call    printStr
        mov     eax, [stack]            
        call    iprintLn           
        call    salir            
    error:
        mov     eax, msg1
        call    printStrLn
        call    salir
    pushPila:
        enter   0, 0
        push    eax
        push     edx
        mov     eax, [stack_size]
        mov     edx, [ebp+8]
        mov     [stack + 4*eax], edx   
        inc     dword [stack_size]
        pop     edx
        pop     eax
        leave
        ret
    popPila:
        enter   0, 0            
        dec     dword [stack_size]          
        mov     eax, [stack_size]
        mov     eax, [stack + 4*eax]     
        leave
        ret  
    strlen_1:
        enter   0, 0              
        mov     eax, 0           
        mov     ecx, [ebp+8]
    strlenloop:
        cmp     byte [ecx], 0       
        je      strlenend 
        inc     eax         
        inc     ecx         
        jmp     strlenloop  
    strlenend:
        leave                   
        ret