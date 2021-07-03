;Hola parametros
;
;

%include 'studio.asm'

SECTION .text  
        global  _start
        _start:
                pop     ecx         ;ecx = el primer valor de la pila
        sigArg:
                cmp     ecx, 0h     ;si ecx = 0
                jz      terminar    ;salta a terminar el programa
                pop     eax         ;extrae el argumento en eax
                jmp     comparar    ;lo imprime en pantalla
                dec     ecx         ;ecx--
        terminar:
                call    salir
        comparar:
                cmp     byte[eax],  0h
                jz      final
                cmp     byte[eax],  41h
                jl      siguiente
                cmp     byte[eax],  5Ah
                jg      siguiente
                xor     byte[eax],  20h
                jmp     siguiente
        siguiente:
                inc     eax
                jmp     comparar
        final: 
                pop     eax
                call    printStrLn
                jmp     sigArg

;_ hola-arg