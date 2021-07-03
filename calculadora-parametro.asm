;Calculadora utilizando Argumentos desde la linea de comandos (parametros)
;Creado  del 18 de abril de 2021
;Por Santiago Navas

%include	'studio.asm'

SECTION .bss
    resultado:       resb    11
    n1:             resb 10
    n2:             resb 10

SECTION .data
	msg1 	db 	'Suma: ', 0Ah, 0h
	msg2 	db 	'Resta: ', 0Ah, 0h
	msg3 	db 	'Multiplicacion: ', 0Ah, 0h
    msg4 	db 	'Division: ', 0Ah, 0h
    msg5    db  'Residuo de la division: ', 0Ah, 0h
    msg6    db  'Ingrese primer valor: ', 0h
    msg7    db  'Ingrese segundo valor: ', 0h

SECTION .text
	global	_start
	_start:
		pop		ecx				;ecx el primer valor de la pila
	;sigArg:
		pop		ebx				;extrae el argumento en eax
                
        pop     eax
        mov     [n1], eax
        mov     eax, [n1]
        call    printStrLn

        pop     eax
        mov     [n2], eax
        mov     eax, [n2]
        call    printStrLn

        mov     eax, [n1]
        sub     eax, '0'
        mov     ebx, [n2]
        sub     ebx, '0'

        add     eax, ebx
        add     eax, '0'
        mov     [resultado], eax
        
        mov     eax, 4
        mov     ebx, 1
        mov     ecx, resultado
        mov     edx, 11
        int     80h

		call	salir
        ret

