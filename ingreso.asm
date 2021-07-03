;-----------------------------------------
;Saludo con repeticion de datos en pantalla, ignreso por teclado
;Creado el 26 de marzo de 2021
;Por santiago
;------------------
;Para reservar espacio se declara en la seccion bss, con el sig. formato
;       variable1:      resb    1       - reserva 1 byte
;       variable2:      resw    1       - reserva 1 word
;       variable3:      resd    1       - reserva 1 doble word

%include        'studio.asm'

SECTION .data
        msg1    db      'Ingrese su nombre: ', 0h
        msg2    db      'Hola, ', 0h

SECTION .bss                            ; BLOCK Started Symbol
        nombre: resb    60              ;reserva 60 bytes

SECTION .text   
        global  _start
_start:
        mov     eax, msg1
        call    printStr
        ;-------------------
        mov     edx, 60                 ;cantidad de bytes a leer
        mov     ecx, nombre             ;apunta al espacio reservado
        mov     ebx, 0                  ;escritura a STDIN
        mov     eax, 3                  ;invoca SYS_READ
        int     80h
        ;--------------------
        mov     eax, msg2
        call    printStr
        mov     eax, nombre
        call    printStr
        call    salir
