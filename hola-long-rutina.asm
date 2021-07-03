;Archivo de inclusion de funciones de entrada-salida estandar
;Creado el 22 de marzo de 2021
;por Santiago Navas
;-----------------------------------
SECTION .data
        msg     db      'Hola arquitectura del computador I!', 0Ah
SECTION .text
        global  _start
        _start:
                mov     eax, msg
                call    strlen
                mov     edx,  eax
                mov     ecx, msg
                mov     ebx, 1
                mov     eax, 4
                int     80h
;----------------------------FIN DEL PROGRAMA
                mov     ebx, 0
                mov     eax, 1
                int     80h
;-----------------------------RUTINA STRLEN
        strlen:
                push    ebx
                mov     ebx, eax
        siguiente:
                cmp     byte[eax],  0
                jz      fincadena
                inc     eax
                jmp     siguiente
        fincadena:
                sub     eax, ebx
                pop     ebx
                ret