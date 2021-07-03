;programa desarrollado por Santiago Navas
;Ejercicio del examen final - Concatenar cadena
;Creado el 3-05-2021

%include    'studio.asm'

SECTION .data
msg1	            db	'Escriba la cadena 1 a utilizar: ',0h
msg2	            db	'Escriba la cadena 2 a utilizar: ',0h
msg3	            db	'Cadena copiada: ',0h

SECTION .bss
cadena1              resb    40 
cadena2              resb    40 

SECTION .text
    global _start
        _start:
            mov     eax, msg1
            call    printStrLn
            mov 	eax, 3
            mov	    ebx, 0
            mov 	ecx, cadena1
            mov	    edx, 40
            int	    80h 
            mov     eax, msg2
            call    printStrLn
            mov 	eax, 3
            mov	    ebx, 0
            mov 	ecx, cadena2
            mov	    edx, 40
            int	    80h 
            mov     eax, msg3
            call    printStr            
            
        terminar: 
            call    salir