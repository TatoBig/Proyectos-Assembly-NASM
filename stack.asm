;Calculadora utilizando Argumentos desde la linea de comandos (parametros)
;Creado  del 18 de abril de 2021
;Por Santiago Navas

%include	'studio.asm'

SECTION .bss
    datos   resb    1

SECTION .text
	global	_start
	_start:
        pop     eax
        add     eax,48
        mov     [datos], eax
        call    printStrLn
        pop ebx

        mov     eax, 4
        mov     ebx, 0
        pop     ecx
        mov     edx, 1
		call	salir
        ret

