; Bloque de programacion en ensamblador - holamundo
; Creado el 15 de marzo de 2021
; por: santiago

; Declaracion de la seccion datos
SECTION .data
	msg 	db	'Hola mundo!', 0Ah

SECTION .text 
	global _start
_start:
	mov 	edx, 12
	mov 	ecx, msg
	mov	ebx, 1
	mov 	eax, 4
	int	80h
	mov	ebx, 0
	mov	eax, 1
	int	80h
