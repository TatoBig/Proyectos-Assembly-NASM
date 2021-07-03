;Calcula las operaciones basicas de dos valores
;Creado el 18 de abril de 2021
;por Santiago Navas

%include        'studio.asm'

SECTION .bss
    n1:             resb 10
    n2:             resb 10

SECTION .data
	msg1 	db 	'Suma: ', 0Ah, 0h
	msg2 	db 	'Resta: ', 0Ah, 0h
	msg3 	db 	'Multiplicacion: ', 0Ah, 0h
    msg4 	db 	'Division: ', 0Ah, 0h
    msg5    db  'Residuo de la division: ', 0Ah, 0h
SECTION .text
        global  _start
        _start: 
            pop		ecx				;ecx el primer valor de la pila
        
            pop		ebx				;extrae el nombre del archivo ya que lo toma como argumento
            
            ;pop     eax
            ;mov     [n1], eax
            ;mov     eax, [n1]
            ;call    printStr       ;parametro 1 = 44

            ;pop     eax
            ;mov     [n2], eax
            ;mov     eax, [n2]
            ;call    printStr       ;parametro 2 = 26
            
            ;Si pude obtener los valores de la pila, pero no supe como manipularlos en bytes para 
            ;Poder hacer las operaciones, ya que el valor que tenian en n1 y n2, no era el ascii,
            ;Ya que de ser asi si habia que restarle 48 y efectuar la suma, sin embargo, me daba un
            ;Numero muy grande, si investigue lo mas que pude, pero si no fui capaz.
            ;-------------------
            ;Suma
            mov     eax, msg1
            call    printStr
            mov     eax, 44             ;En esta parte tengo duda, ya que
            mov     ebx, 26
            add     eax, ebx            ;Llama a la suma
            call    iprintLn
            ;--------------------
            ;Resta
            mov     eax, msg2
            call    printStr
            mov     eax, 44             
            mov     ebx, 26
            sub     eax, ebx            ;Llama a la resta
            call    iprintLn
            ;--------------------
            ;Multiplicacion
            mov     eax, msg3
            call    printStr
            mov     eax, 44          
            mov     ebx, 26
            mul     ebx                 ;multiplica ebx * eax
            call    iprintLn
            ;--------------------
            ;Division y residuo
            mov     eax, msg4
            call    printStr
            mov     edx, 0              ;se limpia edx ya que ahi estara el residuo de la division
            mov     eax, 44             
            mov     ebx, 26
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

