;Calcula la suma de dos valores
;Creado el 14 de abril de 2021
;por Santiago Navas

;El programa no funciona con numeros mayores a 1 digito
;Esto porque no me dio tiempo de implementarlo en una funcion
;Que transformara todos los valores del digito a bytes,
;Pero funciona de forma correcta con valores de un solo digito.

%include        'studio.asm'

SECTION .bss                                    ; BLOCK Started Symbol
        n1: resb    4                 ;reserva 60 bytes
		n2: resb 	4

SECTION .data
	msg1 	db 	'Suma: ', 0Ah, 0h
	msg2 	db 	'Resta: ', 0Ah, 0h
	msg3 	db 	'Multiplicacion: ', 0Ah, 0h
    msg4 	db 	'Division: ', 0Ah, 0h
    msg5    db  'Residuo de la division: ', 0Ah, 0h
    msg6    db  'Ingrese primer valor: ', 0h
    msg7    db  'Ingrese segundo valor: ', 0h

SECTION .text
        global  _start
        _start:
            ;Ingreso primer numero
            mov     eax, msg6
            call    printStr
            mov     edx, 4                  ;cantidad de bytes a leer
            mov     ecx, n1                 ;apunta al espacio reservado
            mov     ebx, 0                  ;escritura a STDIN
            mov     eax, 3                  ;invoca SYS_READ
            int     80h
            ;Ingreso segundo numero
            mov     eax, msg7
            call    printStr
            mov     edx, 4                  ;cantidad de bytes a leer
            mov     ecx, n2                 ;apunta al espacio reservado
            mov     ebx, 0                  ;escritura a STDIN
            mov     eax, 3                  ;invoca SYS_READ
            int     80h
            
            ;--------------------
            ;Conversion del numero a bytes
            mov     eax, [n1]   
            ;sub     eax, 2608
            call    iprintLn     ;---- Para hacer pruebas
            mov     eax, [n2]
            ;sub     eax, 2608
            ;mov     ebx, eax
            call    iprintLn                      
            ;-------------------            
            call    salir