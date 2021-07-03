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
            sub     eax, 2608
            ;call    iprintLn     ---- Para hacer pruebas
            mov     eax, [n2]
            sub     eax, 2608
            mov     ebx, eax
            ;call    iprintLn                      
            ;-------------------
            ;Suma
            mov     eax, msg1
            call    printStr
            mov     eax, [n1]           ;En esta parte tengo duda, ya que
            sub     eax, 2608           ;El numero que imprima me da en 2608+el numero, lo tengo que restar para que cuadre
            add     eax, ebx            ;Llama a la suma
            call    iprintLn
            ;--------------------
            ;Resta
            mov     eax, msg2
            call    printStr
            mov     eax, [n1] 
            sub     eax, 2608
            sub     eax, ebx            ;Llama a la resta
            call    iprintLn
            ;--------------------
            ;Multiplicacion
            mov     eax, msg3
            call    printStr
            mov     eax, [n1] 
            sub     eax, 2608
            mul     ebx                 ;multiplica ebx * eax
            call    iprintLn
            ;--------------------
            ;Division y residuo
            mov     eax, msg4
            call    printStr
            mov     edx, 0              ;se limpia edx ya que ahi estara el residuo de la division
            mov     eax, [n1] 
            sub     eax, 2608
            mov     ecx, ebx
            div     ecx                 ;divide ecx / eax
            call    iprintLn
            ;Residuo de la division
            mov     eax, msg5
            call    printStr
            mov     eax, edx            ;el residuo de la division quedo en edx
            call    iprintLn
            call    salir
            ret

