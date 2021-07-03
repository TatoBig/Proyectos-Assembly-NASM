;Parcial 2 - Invertir cadena de caracteres
;Por Santiago Navas 
;Creado el 18-04-21

%include 'studio.asm'

SECTION .data
        msg1                db      'Ingrese una cadena: ', 0
        msg2                db      'Cadena invertida: ', 0

SECTION .bss
        cadena              resb    60  
        cadenaInvertida     resb    60
        contador            resb    2
        resultado           resb    4
SECTION .text
    global _start
        _start:
;-----------------------------------------------------------
;Imprime el mensaje
            mov     eax, msg1
            call    printStr
;-----------------------------------------------------------
;Input de la cadena a invertir
            mov     eax, 3                     
            mov     ebx, 0
            mov     ecx, cadena                 
            mov     edx, 60
            int     80h                   
;-----------------------------------------------------------
;Establece el contador en 0
            mov     byte [contador], 0   
;-----------------------------------------------------------
;Mueve a esi la futura cadena que se va a crear
            mov     esi, cadenaInvertida
;-----------------------------------------------------------
;Primero se debe obtener la longitud de la cadena que habiamos ingresado
        obtenerLongitud:
            cmp     byte [ecx], 0
            ;Si el si el valor llega 0, pasa a invertir
            je      invertir                    
            inc     ecx
            ;Se incrementan el contador
            inc     byte [contador]
            ;Si llega al final, repite el ciclo
            jmp     obtenerLongitud                    
;-----------------------------------------------------------
;Inicio de la funcion invertir
        invertir:
            ;Si el contador llega a 0, termina el programa     
            cmp     byte [contador], 0   
            je      terminar
            ;Mueve las posiciones del os bytes de la cadena original
            mov     al, [ecx-1]
            mov     [esi], al      
            ;Decrementa el contador, y la longitud de la cadena          
            dec     byte [contador]            
            dec     ecx
            ;Incrementa esi y sigue con el siguiente caracter   
            inc     esi                        
            jmp     invertir                
;-----------------------------------------------------------
;Imprime los mensajes finales
        terminar:
            mov     eax, msg2
            call    printStr           
            mov     eax, cadenaInvertida
            call    printStrLn
            call    salir