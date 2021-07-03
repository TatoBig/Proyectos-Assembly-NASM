;Creado el 15 de abril de 2021
;por Santiago Navas 
;
;T4 - Despligue de cadena en pantalla
;Este programa limpia la pantalla, luego le pide al usuario un nombre
;Luego de haberlo pedido, vuelve a limpiar la pantalla, y muestra
;El nombre centrado en pantalla

%include	'studio.asm'

SECTION .data
        msg1        db          'Ingrese su nombre: ', 0h       ;11 caracteres
        msg2        db          'Nombre ingresado: ', 0h
        posInicial  db          1Bh, '[0;01H', 0h
        pos1        db          1Bh, '[12;34H', 0h             ;posicion centrada
        pos2        db          1Bh, '[13;34H', 0h             ;posicion centrada
        posal       db          1Bh, '[24;01H', 0h              ;posicion inicial

SECTION .bss                                    ; BLOCK Started Symbol
        nombre: resb    60

SECTION .text
        global  _start
        _start:
                ;-----------------------------------
                ;Ingreso de datos
                call    clrscr                  ;Se limpia la pantalla
                mov     eax, posInicial         ;Posicion del ingreso de la cadena
                call    printStr
                mov     eax, msg1
                call    printStr
                mov     edx, 60                 ;cantidad de bytes a leer
                mov     ecx, nombre             ;apunta al espacio reservado
                mov     ebx, 0                  ;escritura a STDIN
                mov     eax, 3                  ;invoca SYS_READ
                int     80h
                ;-----------------------------------
                ;Impresion en el centro
        impresion:
                call    clrscr                  ;Luego de haber pedido, limpia otra vez y muestra en el centro el nombre ingresado
                mov     eax, pos1               ;Se va a la posicion centrada 1
                call    printStr
                mov     eax, msg2               ;Se imprime el mensaje en el centro
                call    printStr
                mov     eax, pos2               ;Se va a la posicion centrada 2
                call    printStr
                mov     eax, nombre             ;Se escribe el nombre ingresado previamente
                call    printStr
                mov     eax, posal              ;Se mueve a un espacio mas abajo para poder continuar escribiendo
                call    printStr    
                call    salir
