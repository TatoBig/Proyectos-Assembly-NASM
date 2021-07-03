%include        'stdio.asm'

SECTION .bss                                    
        cadena1: resb    60                
		cadena2: resb 	 60

SECTION .data
	msg1 	db 	'Ingrese la cadena 1: ', 0Ah, 0h
	msg2 	db 	'Ingrese la cadena 2: ', 0Ah, 0h
	msg3 	db 	'Las cadenas son diferentes: ', 0Ah, 0h
    msg4 	db 	'Las cadenas son iguales: ', 0Ah, 0h

SECTION .text
        global  _start
        _start:
            mov     eax, msg1
            call    printStr
            mov     edx, 60                  
            mov     ecx, cadena1                 
            mov     ebx, 0                  
            mov     eax, 3                  
            int     80h
            mov     eax, msg2
            call    printStr
            mov     edx, 60                  
            mov     ecx, cadena2                 
            mov     ebx, 0                  
            mov     eax, 3                  
            int     80h
            mov     eax, [cadena1]
            mov     ebx, [cadena2]
            cmp     eax, ebx
            je      cadenaIgual
            cmp     eax, ebx
            jne     cadenaNoIgual
        cadenaIgual:
            mov     eax, msg4
            call    printStrLn
            jmp     terminar
        cadenaNoIgual:
            mov     eax, msg3
            call    printStrLn
            jmp     terminar
            
        terminar:      
            call    salir
        convertirNumero:
            push    ebx            
            push    ecx             
            push    edx             
            push    esi             
            mov     esi, eax        
            mov     eax, 0          
            mov     ecx, 0          
;En esta parte, se multiplica cada cifra del numero
        multiplicarCifras:
            xor     ebx, ebx      
            ;Empieza a leer el numero en la posicion 0  
            mov     bl, [esi+ecx] 
            ;Compara si el numero es mayor que '0' o mayor a '9' (en bytes) para terminar la conversion 
            cmp     bl, 48          
            jl      terminarConversion       
            cmp     bl, 57          
            jg      terminarConversion   
            ;A la cifra, le resta 48 para dejar solo su valor en bytes     
            sub     bl, 48
            add     eax, ebx        
            ;Si hay otra cifra, la suma a la que ya se convirtio
            mov     ebx, 10         
            ;Se multiplica el dato en ebx * 10 por la cifra
            mul     ebx      
            ;Se incrementa ecx para pasar al siguiente caracter       
            inc     ecx             
            jmp     multiplicarCifras   
;Finalmente se divide el numero de eax, por 10 y se extraen los valores de la pila
        terminarConversion:
            mov     ebx, 10         
            div     ebx            
            pop     esi             
            pop     edx             
            pop     ecx             
            pop     ebx             
            ret  