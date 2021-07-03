;Hola mundo con llamadas a funcion desde archivo incluido
;creado el 22 de marzo de 2021
;por santiago navas

%include 	'studio.asm'

SECTION .data
	msg1 	db 	'Hola mundo mejorado!', 0Ah, 0h
	msg2 	db 	'Arquitectura del computador 1', 0Ah, 0h
	msg3 	db 	'Cualquier otra cosa...', 0Ah, 0h

SECTION .text
	global _start
	_start:
		mov		eax, msg1		;Coloca msg1 en eax
		call 	printStr		;imprime en pantalla
		mov 	eax, msg2
		call 	printStr
		mov 	eax, msg3
		call 	printStr
		call 	salir

