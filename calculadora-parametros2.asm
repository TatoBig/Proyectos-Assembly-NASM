%include 'studio.asm'

SECTION .data
    msg1            db      '1. Suma: ', 0h
    msg2            db      '2. Resta: ', 0h
    msg3            db      '3. Multiplicacion: ', 0h
    msg4            db      '4. Division: ', 0h
    msg5            db      'Residuo de la division: ', 0h    
    msg6            db      'La cantidad de argumentos es invalida', 0h
    msg7            db      'Operaciones basicas de los valores ingresados ', 0h
SECTION .text
    global _start
        _start:            
            pop     ecx             
            pop     edx             
            sub     ecx, 1          
            mov     edx, 0          
        
        leerArgumentos:
            ;Compara cuantos argumentos ingreso el usuario para ver si es posible ejecutar el programa
            cmp     ecx, 2
            je      operar              
            jne     invalidar

        operar:
            mov     eax, msg7
            call    printStrLn
;----------------------------------------------------------------------
;Suma:
            mov     eax, msg1
            call    printStr
            ;Saca el primer argumento de la pila y lo convierte
            pop     eax
            call    convertirNumero
            ;Se guarda el numero en ebx
            mov     ebx, eax
            ;Se obtiene el segundo argumento
            pop     eax
            call    convertirNumero
            ;Se mueve a ecx el segundo numero
            mov     ecx, eax
            ;Se vuelve a ingresar en la pila que contiene el primer argumento
            push    eax
            ;Se realiza la suma y se muestra el resultado en eax
            add     ecx, ebx
            mov     eax, ecx
            call    iprintLn
;----------------------------------------------------------------------
;Resta
            mov     eax, msg2
            call    printStr
            ;Se saca el primer argument nuevamnete, el segundo ya esta en ebx
            pop     eax
            ;Se realiza la resta
            sub     ebx, eax
            ;Se vuelven a guardar ambos valores en la pila
            push    eax
            push    ebx
            mov     eax, ebx
            call    iprintLn
;----------------------------------------------------------------------
;Mutiplicacion            
            mov     eax, msg3
            call    printStr            
            ;Los dos argumentos esta en la pila, se deben sacar
            pop     eax
            pop     ebx
            ;El primero queda en edx y se vuelve a guardar
            mov     edx, eax
            push    edx
            ;Se realiza la multiplicacion que queda en ebx
            add     eax, ebx
            mul     ebx
            call    iprintLn           
;----------------------------------------------------------------------
;Division:
            mov     eax, msg4
            call    printStr
            ;El primer argumento quedo en edx
            pop     edx
            add     edx, ebx
            mov     eax, edx
            ;Para la division, edx debe quedar en 0 porque allí queda el residuo
            mov     edx, 0
            div     ebx
            call    iprintLn
            ;Se muestra la division
            mov    eax, msg5
            call    printStr
            ;Se muestra el residuo que estaba en edx
            mov    eax, edx
            call    iprintLn
            ;Termina el programa
            call    salir
;----------------------------------------------------------------------
;Codigo que se ejecuta cuando el usuario ingresa mas argumentos de los que debe
        invalidar:
            mov     eax, msg6
            call    printStrLn
            call    salir
;----------------------------------------------------------------------
;Este codigo lo desarrolle despues de la entrega, por ello la modificacion, ya que teniendo esta parte
;Ya pude terminar el programa. Mas tarde lo movere a stdio.asm ya que es una funcion muy util en general
;pero por ahora lo dejo para que pueda ver el funcionamiento
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