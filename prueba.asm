;Hola mundo utilizando Argumentos desde la linea de comandos (parametros)
;Creado  del 5 de abril de 2021
;Por Santiago Navas

%include	'studio.asm'

SECTION .bss                                    ; BLOCK Started Symbol
        n1: resb    60                 ;reserva 60 bytes
		n2: resb 	60

SECTION .text
	global	_start
	_start:		
		mov     edx, 60                 ;cantidad de bytes a leer
        mov     ecx, n1        ;apunta al espacio reservado
        mov     ebx, 0                  ;escritura a STDIN
        mov     eax, 3                  ;invoca SYS_READ
        int     80h
		mov     edx, 60                 ;cantidad de bytes a leer
        mov     ecx, n2        ;apunta al espacio reservado
        mov     ebx, 0                  ;escritura a STDIN
        mov     eax, 3                  ;invoca SYS_READ
        int     80h
		mov 	eax, n1
		call 	printStr
		mov 	eax, n2
		call 	printStr
		call	salir
        ret
