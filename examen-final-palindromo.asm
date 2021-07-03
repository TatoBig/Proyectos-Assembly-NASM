;programa desarrollado por Santiago Navas
;Ejercicio del examen final - Cadena es palindromo
;Creado el 3-05-2021

%include    'studio.asm'

SECTION .data
msg1	            db	'Ingrese una cadena:',0h
msg2	            db	'La cadena ingresada es palindromo: ',0h
msg3	            db	'La cadena ingresada no es palindromo: ',0h

SECTION .bss
cadena              resb    40 

SECTION .text
    global _start
        _start:
            ;Comienzo del programa
            mov     eax, msg1
            call    printStrLn
            ;Se realiza el bloque de input para que el usuario ignrese la cadena
            mov 	eax, 3
            mov	    ebx, 0
            mov 	ecx, cadena
            mov	    edx, 40
            int	    80h 
            ;Se mueve la cadena a esi
            mov	    esi, cadena
            ;Se limpia ah, y ecx a 0 ya se van a utilizar al leer la cadena
            mov	    ah, 0	
            mov	    ecx, 0	         
        PrepararCadena:
            ;Comienza a leer el primer caracter de la cadena, ya que esta esta en esi
            mov	    al, [esi]
            ;Si el primer caracter es 10, es que hay un ENTER, ya no se debe de considerar, y comienza a comparar
            cmp	    al, 10 
            je	    comparar
            ;Se deja un caracter en la pila
            push	ax
            ;Se incrementa esi y ecx para que se muevan a la siguiente posicion de la cadena, y ecx como contador
            inc	    esi
            inc	    ecx
            jmp	    PrepararCadena
        comparar:
            ;Si encontro el enter, ya puede comenzar a comparar la cadena actual, con la cadena guardada en pila
            mov	    esi, cadena
        leerCadena:
            ;Se saca un caracater de la cadena de la pila
            pop	    ax
            cmp	    al,[esi]
            ;El primer caracter debe coincidir con el ultimo, ya que como se ingreso en la pila, la cadena quedó al reves
            ;Si no coincide en algun punto el primero con el ultimo, no es un palindromo y termina el programa
            jne	    noEsPalindromo
            ;Se pasa a la siguiente posicion de la cadena
            inc	    esi
            ;Se continua toda la cadena para ver si en algun punto no coincide
            loop	leerCadena
        esPalindromo: 
            ;Si no encontro un error, el ciclo termina y signfica que si es un palindromo
            ;Solo se imprimen los mensajes para indicar el resultado
            mov     eax, msg2
            call    printStr
            mov     eax, cadena
            call    printStrLn 
            jmp     terminar       
        noEsPalindromo:
            ;Se indica el resultado que no es palindromo
            mov     eax, msg3
            call    printStr
            mov     eax, cadena
            call    printStrLn
            jmp	    terminar 
        terminar: 
            call    salir