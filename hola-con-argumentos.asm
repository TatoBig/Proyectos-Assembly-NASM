;Hola mundo utilizando Argumentos desde la linea de comandos (parametros)
;Creado  del 5 de abril de 2021
;Por Santiago Navas

%include	'studio.asm'

SECTION .text
	global	_start
	_start:
		pop		ecx				;ecx el primer valor de la pila
	sigArg:
		cmp		ecx, 0h			;si ecx es 0
		jz		terminar		;salta a terminar el programa
		pop		eax				;extrae el argumento en eax
		call 	printStrLn		;lo imprime en pantalla
		dec 	ecx 			;ecx--
		jmp		sigArg			;salta a siguiente argumento
	terminar:
		call	salir
