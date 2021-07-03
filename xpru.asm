%include 'studio.asm'

SECTION .data
    tamanoPila:     dd 0        
    pila: times 256 dd 0   
    msg1            db      'Expresión inválida', 0h
    msg2            db      'Resultado: ', 0h
    msg3            db      'salir', 0h
    msg4            db      'Salindo...', 0h
    msg5            db      'Opción invalida', 0h
    msg6            db      'Ingreso por parametro', 0h
    msg7            db      'Ingreso rpn', 0h
    msg8            db      'Ingresar expresión RPN: ', 0h
    opSalir         db      'salir', 0h
    rpn             db      'rpn', 0h
    sum             db      '+', 0h
    res             db      '-', 0h
    multi           db      '*', 0h
    divisi          db      '/', 0h


SECTION .bss                                    
    numero:         resb    20                

SECTION .text
    global _start
        _start:
            pop     ecx
            pop     ebx
            dec     ecx
        iniciar:                    
            pop     ebx
            mov     eax, [ebx]
            cmp     eax, [rpn]
            je      rpnDetectado
            mov     eax, msg5
            call    printStrLn
            call    salir        
        rpnDetectado:
            dec     ecx
            cmp     ecx, 0
            jne     ingresoPorParametro
            je      ingresoRpn                        
        ingresoPorParametro:
            mov     eax, msg6
            call    printStrLn
            mov     esi, [esp]        
            push    esi
;------------------------------------------------------------------------
;Lo primero que debemos saber es cuanto mide la cadena que ingresamos por parametro, para ello utilizamos esta función
            call    longitudCadena
            ;La longitud obtenida se guarda en ebx
            mov     ebx, eax          
            ;Al apuntador de esp se le suma 4 para ir a la siguiente posicion de la pila
            add     esp, 4
            ;ecx se deja en 0 porque sera el contador para ir viendo que posicion de caracter se va a leer
            mov     ecx, 0            
        inicio:
            ;Si la longitu de la cadena, es igual al contador que lleva la cuenta de que caracter se va a leer, se pasa a la fase final del programa
            cmp     ecx, ebx            
            jge     terminar
            ;Si no, se deja edx en 0
            mov     edx, 0
            ;Se va a comparar el primer simbolo ya que se va a recorrer la cadena
            mov     dl, [esi + ecx]      
            cmp     edx, '0'
            ;Los simbolos como + - * /, se encuentran en valores ascii inferiores al de '0' que es 48, por loque si es menor es un simbolo
            jl      compararSimbolo
            cmp     edx, '9'
            ;Si es mayor, solo querdarian letras y otros simbolos que no tendrian validez en la expresion
            jg      error
            ;Si llega a esta parte es porque es un numero, se le resta '0' par que quede en el valor ascii equivalente al numero que le toca
            sub     edx, '0'
            ;Se deja el valor de este caracter en eax
            mov     eax, edx         
            ;Ocurre que pasa al siguiente caracter pero se explica mas abajo como funciona esta operacon    
            jmp     siguienteCaracter
;------------------------------------------------------------------------
;Sirve para obtener que operacion se debe efectuar en el programa
        compararSimbolo:
            ;Se ingresa ecx que es el contador y ebx donde estaba el dato a la pila
            push    ecx
            push    ebx
            ;Se extrae de la pila un dato para poder se operado
            call    extraerDePila
            mov     edi, eax            
            ;Se extrae el segundo dato para poder se operado por el primero
            ;Estos se extrae de la "otra pila" que es done estamos guardando los numeros
            call    extraerDePila    
            ;Se extraen los registros de la pila para que no se pierdan, el contador y el valor 
            pop     ebx
            pop     ecx
            ;Ahora si se compara el valor a que simbolo equivale
            cmp     edx, '+'
            je      suma
            cmp     edx, '-'
            je      resta
            cmp     edx, '*'
            je      multiplicacion
            cmp     edx, '/'
            je      division
            ;Si llega al final, y no es ninguna operacion basica, es un caracter desconocido y la expresion se invalidara
            jmp     error
        suma: 
            ;Si es suma sea hace la operacion resta
            add     eax, edi
            jmp     siguienteCaracter
        resta:
            ;Si es resta se restan los valores
            sub     eax, edi                 
            jmp     siguienteCaracter
        multiplicacion:            
            ;multiplicacion
            imul     eax, edi                
            jmp     siguienteCaracter
        division:          
            ;el valor que esta en edx se guarda en la pila para poder igualarse en 0 donde se guardara el residuo  
            push    edx                     
            mov     edx, 0
            idiv    edi                    
            pop     edx
;------------------------------------------------------------------------
;Esta funcion se utiliza al terminar de clasificar el caracter como simbolo o letra  
        siguienteCaracter:
            ;Se ingresan los registros a la pila
            push    eax
            push    ecx
            push    edx
            push    eax          
            ;Se ingresa eax a la pila, donde estaba nuestro caracter
            call    ingresarAPila
            ;Se mueve el puntero de la pila
            add     esp, 4
            ;Se extraen los elementos de la pila
            pop     edx
            pop     ecx
            pop     eax
            ;En ecx esta el contador de caracteres, como se pasa al siguiente, este debe de aumentar
            inc     ecx
            ;Se regresa al inicio para seguir leyendo la expresion ingresada ya con el siguiente caracter
            jmp     inicio
        terminar:
            ;Ya se termino de leer la expresion
            cmp     byte [tamanoPila], 1      
            jne     error
            ;Si el tamaño de la pila no es igual a 1, signfica que quedo algun valor almacenado a parte del resultado y ocurrira un error
            mov     eax, msg2
            call    printStr
            ;Se mueve el resultado que se encuentra en la pila a eax para imprimirse
            mov     eax, [pila]            
            call    iprintLn           
            call    salir            
;------------------------------------------------------------------------
;Esta parte se utiliza cuando el usuario ingresa una expresion que no es valida, y hara que termine el programa
        error:
            mov     eax, msg1
            call    printStrLn
            call    salir
        ingresarAPila:
            enter   0, 0
            ;Se ingresa eax en la pila que es donde estaba el 
            push    eax
            ;Se ingresa edx tambien a la pila
            push     edx
            ;Se utiliza otra pila para guardar los valores que vayamos almancenando
            mov     eax, [tamanoPila]
            mov     edx, [ebp+8]
            ;En la pila se guarda el caracter
            mov     [pila + 4*eax], edx   
            ;Se incrementa el tamaño de la pila ya que se ingreso un dato
            inc     dword [tamanoPila]
            ;Se extraen los registros
            pop     edx
            pop     eax
            ;Termina y regresa a donde estaba el programa
            leave
            ret
        extraerDePila:
            ;Esta parte sirve para extraer de la otra pila
            enter   0, 0            
            ;Primero disminuira su tamaño
            dec     dword [tamanoPila]          
            ;Y se guarda el nuevo tamaño en eax    
            mov     eax, [tamanoPila]
            ;Para poder dejar en eax el valor que esta en la pila en la nueva posicion
            mov     eax, [pila + 4*eax]     
            leave
            ret          
        ingresoRpn:
            mov     eax, msg7
            call    printStrLn
            mov     eax, msg8
            call    printStrLn
            mov     eax, 3
            mov     ebx, 0
            mov     ecx, numero
            mov     edx, 20
            int     80h
            mov     eax, [numero]
            cmp     eax, [opSalir]
            je      terminar
            jne     procesarExpresionRpn
        procesarExpresionRpn:
            mov     ebx, 0           
            mov     eax, numero
            call    strlen
        procesarNumeros:            
            jmp     ingresoRpn       
;----------------------------------------------------------------------
;funcion que convierte el numero en eax a un int para poder realizar las operaciones
;utilizando manejo de pila
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
;------------------------------------------------------------------------
;Funcion auxiliar que solo sirve para obtener el tamaño de la pila que se ingresa
        longitudCadena:
            ;Eax se deja en 0
            enter   0, 0              
            mov     eax, 0           
            ;Y ecx sera el contador   
            mov     ecx, [ebp+8]
        cicloLongitudCadena:
            ;Se compara si el contador ya llego a 0, para terminar el ciclo
            cmp     byte [ecx], 0       
            je      terminarCiclo 
            ;Si no ha llegado, se incrementan los contadores    
            inc     eax         
            inc     ecx         
            ;Se pasa al siguiente caracter
            jmp     cicloLongitudCadena  
        terminarCiclo:
            leave                   
            ret
