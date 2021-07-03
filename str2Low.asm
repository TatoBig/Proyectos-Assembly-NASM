;-----------------------------------------
;Programa que utiliza el ingreso de una cadena para transformarla en minusculas
;Creado el 6 de abril de 2021
;Por Santiago Navas
;------------------
;Utiliza la misma estructura que el programa inverso de str2Low, ya que solo debe cambiar la comparacion

%include        'studio.asm'

SECTION .data
        msg1    db      'Ingrese una cadena: str2Low (', 0h
        msg2    db      'Na cadena en minusculas: ', 0h

SECTION .bss                                    ; BLOCK Started Symbol
        cadenaNueva: resb    60                 ;reserva 60 bytes

SECTION .text   
        global  _start
_start:
        mov     eax, msg1
        call    printStr
        ;--------------------------------------------------------------------------------------
        mov     edx, 60                 ;cantidad de bytes a leer
        mov     ecx, cadenaNueva        ;apunta al espacio reservado
        mov     ebx, 0                  ;escritura a STDIN
        mov     eax, 3                  ;invoca SYS_READ
        int     80h
        ;-------------------------------------------------------------------------------------
        mov     eax, msg2               ;llama al segundo mensaje
        call    printStr                ;imprime el mensaje preparado
        mov     eax, cadenaNueva        ;mueve la nueva cadena a transformar a eax
        push    eax                     ;eax entra a la pila para comprarse
str2Low:
        cmp     byte[eax],  0h          ;si ya no hay caracteres, termina el programa
        jz      finalizar               ;salta al final
        cmp     byte[eax],  41h         ;compara el caracter de la cadena dentro de eax con A
        jl      siguiente_caracter      ;si tiene un valor menor a 41 (A) pasa al siguiente caracter
        cmp     byte[eax],  5Ah         ;compara el caracter de la cadena dentro de eax con Z
        jg      siguiente_caracter      ;si tiene un valor mayor a 5A (Z) pasa al siguiente caracter
        xor     byte[eax],  20h         ;si llega hasta aqui el caracter, se transforma con xor y pasa al siguiente
        jmp     siguiente_caracter
siguiente_caracter:
        inc     eax                     ;eax pasa al ver el siguiente caracter
        jmp     str2Low                 ;regresa a comparar el byte del nuevo caracter (siguiente caracter)
finalizar: 
        pop     eax
        call    printStrLn
        call    salir
        ret
