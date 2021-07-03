;Proyecto final, por Santiago Navas
;Creado el 2-5-2021
;El programa cuenta con las dos opciones para poder ingresar una expresion polaca inversa
;para obtener un resultado.

;Para poder utilizarse debe escribir "rpn" como parametro, luego si desea solo utilizar parametros para ingresar la expresion
;Esta se escribiría de la siguiente forma 62 42 23 x +, se utiliza x por problemas al usar *. Esta parte funciona al 100%, 
;No tiene errores y hasta funciona con operaciones negativas y numeros de varios digitos

;Por otra parte, esta la calculadora ingresada por texto, esta si tuve mas problemas al realizarla por el manejo de
;la cadena, ya que los numeros y operadores en este caso van "juntos" porque no se pueden separar facilmente como cuando
;lleganm por parametros, por ello, utilice la calculadora rpn entregada previamente, esta solo recone expresiones
;con un solo digito como podría ser 62*7+, cuando uno escribe salir si sale del programa correctamente.

%include 'studio.asm'

SECTION .data
    tamanoPila:     dd 0        
    pila: times 256 dd 0   
    msg1            db      'La expresion ingresada es invalida', 0h
    msg2            db      'Resultado: ', 0h
    msg3            db      'salir', 0h
    msg4            db      'Saliendo del programa', 0h
    msg5            db      'Opción invalida', 0h
    msg6            db      'Ingreso por parametros (modo parametros)', 0h
    msg7            db      'Ingreso manual por texto (modo calculadora)', 0h
    msg8            db      'Ingresar expresión en formato RPN o "salir" para finalizar: ', 0h
    msg9            db      'Caracter desconocido: ', 0h
    msg10           db      'No se puede utilizar el simbolo * por la terminal, utilice x en vez', 0h
    msg11           db      'La expresión ingresada es invalida', 0h
    cadenaSalir     db      'salir', 0h
    cadenaRpn       db      'rpn', 0h

SECTION .bss                                    
    expresion:         resb        20  
    parametros      resw        100             

SECTION .text
    global _start

;Esta parte si esta mas basada en un programa encontrado de internet, ya que facilitaba mucho el manejar las operaciones dentro de la pila
;Porque si es necesario mencionarlo ya que no vimos macros en clase.
%macro operacionPrevia 0
    ;Si solo hay dos parametros, la operacion no es valida
    cmp    ecx, 2
    jl     expresionInvalida
    dec    ecx
    ;Se decrementa la cantidad de parametros, y se pasa al primero de los parametros
    mov    esi, [parametros + ecx * 4]
    dec    ecx
    ;Se vuelve a decrementar ecx y se pasa al segudo parametro
    mov    eax, [parametros + ecx * 4]
%endmacro

%macro operacionTerminada 0
    ;Al terminar la operacion, se deja el resultado en un nuevo parametro, así poder utilizarla si es necesario mas adelante
    ;Esto sirve para guardar el resultado todavía en la pila
    mov    [parametros + ecx * 4], eax
    inc    ecx
    ;Ya que hay un nuevo parametro se aumenta ecx
    jmp    terminarCicloComparacion
%endmacro
        ;Se inicia el programa
        _start:
            ;Se obtiene la cantidad de parametros
            pop     ecx
            ;Se desecha el priemro en edx
            pop     edx
            ;Se decrementa ecx para mantener un mejor control
            dec     ecx
        iniciar:       
            ;Se obtiene el primer parametros que debe ser el que contenga la cadena de letras rpn             
            pop     ebx
            mov     eax, [ebx]
            ;Si ebx que se guarda en eax, es igual a la cadena que contiene cadenaRpn ('rpn') si podra continuar el programa
            ;Ya que así debe empezar siemrpe el programa para poder utilizarse
            cmp     eax, [cadenaRpn]
            ;Si si se ingreso RPN ahora el programa continua
            je      continuarPrograma
            ;Sino, el programa termina ya que no se inicio con RPN
            mov     eax, msg5
            call    printStrLn
            call    salir        
        continuarPrograma:
            ;Ya que se encontro que si se puso rpn, ahora se verifica si hay mas parametros, para ver en que modo inicia
            dec     ecx
            cmp     ecx, 0
            ;Si no hay parametros, ira al modo de ingreso manual, y si si hay, al modo por parametros
            jne     ingresoParametros
            je      ingresoManual
            ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
            ;Estos dos modos fueron trabajados de diferente manera, ya que para uno había que leer cada parametro
            ;Y para el otro leer una cadena de texto y en base a eso trabajarla, por ello es que para la del ingreso
            ;Manual, se utilizo la calculadora-rpn anteriormente desarrollada, por lo que esta solo se podrá utilizar 
            ;Con un digito, por ejemplo 54*2+ debería de dar 22, ya que si se complico bastante la parte de separar
            ;La cadena por cada espacio.

            ;La otra calculadora por parametros sin embargo, tuvo muchas mejoras, ya que se facilito bastante mas
            ;Al poder manejar cada parametro individualmente, y con los macros de ir almacenandolos en la pila, por
            ;Lo que puede realizar cualquier operacion del estilo 54 45 * 65 + o hasta operaciones que tengan 
            ;Valores negativos, como 45 75 -
            ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;------------------------------------------------------------------------
;El primer modo es el que utiliza las operaciones por parametros
        ingresoParametros:
            ;Lo primero que se hace es que se reincia la pila como si no se hubiera trabajado
            ;PEro también si en el RPN ya que yan o es necesario
            push    edx
            ;Se regresa edx y se incrementa ecx
            inc     ecx
            push    ecx
            ;Se regresa ecx tambien con el valor de cuantos parametros hay
            mov     ebp, esp
            ;Se arregla la cantidad en ecx si es necesario
            xor     ecx, ecx      
            mov     ebx, 2       
            ;En esta parte se irá comparando cada parametro de la pila para ver que operacion corresponde hacer 
        cicloComparacion:
            ;Se mueve al primer parametro, manejado de esta manera para no afectar la pila
            ;Al momento de hacer pop y no interferir con los macros
            mov     eax, [ebp + ebx * 4]          
            ;EL primer dato se compara si no es 0, por lo que si es un numero se debe convertir  
            cmp     byte [eax + 1], 0
            jnz    conversionNumero            
            ;Si es +
            cmp     byte [eax], 43          
            je      suma_parametro
            cmp     byte [eax], 45     
            ;Si es -     
            je      resta_parametro
            cmp     byte [eax], 47      
            ;Si es /    
            je      dividir_parametro          
            cmp     byte [eax], 120         
            ;Si es x, esta parte fue una alternativa a utilizar el simbolo de *, ya que al utilizarlo como parametro en la terminar
            ;Ocasionaba el error de que me devolvía el nombre de los archivos dentro de la carpeta actual y no se porqué
            ;Por lo que se trabajo con una x en su lugar
            je      multiplicar_parametro        
            cmp     byte [eax], 48         
            ;SI es menor que 0, es un caracter desconocido 
            jl      expresionError
            cmp     byte [eax], 57          
            ;Si es valor mayor a 9, tambien sera desconocido
            jg      expresionError
        conversionNumero:
            xor     edi, edi
            ;Funcion desarrolada previamente, fue trasladada a studio.asm, por comodidad ya que el programa en si
            ;Ya es bastante cargado, pero queda constancia del codigo en trabajos previos
            call    convertirNumero
            ;Se compara edi si solo queda 1 parametro, y ocurrira un error
            cmp     edi, 1
            je      numeroError
            ;Si no es el caso, continua con el siguiente parametro
            mov     [parametros + ecx * 4], eax
            ;Y se icrementa ecx
            inc     ecx
        terminarCicloComparacion:
            ;Se terminan las comparaaciones
            inc     ebx
            cmp     ebx, [ebp]
            ;Si todavía hay parametros, el ciclo continúa
            jle     cicloComparacion
            ;Cuando ya no hayan si se pasa al resultado final
            jmp     resultado_final
        suma_parametro:
            ;Esta es la estructura de las operaciones, que primero se prepara la pila para una operación previa,
            ;Luego se realiza la operacion, y finalmente se vuelve a utilizar la pila para dejar todo en su lugar para una 
            ;Siguiente operacion
            operacionPrevia
            ;En este caso cuando encontraba un + se suma
            add     eax, esi
            operacionTerminada
        resta_parametro:
            operacionPrevia
            ;Si encuentra un - se resta
            sub     eax, esi
            operacionTerminada
        multiplicar_parametro:
            operacionPrevia
            ;Si encuentra una x, por lo anterior mencionado, multiplica
            imul    eax, esi
            operacionTerminada
        dividir_parametro:
            operacionPrevia
            ;Si encuentra / divide
            div     si
            operacionTerminada
        numeroError:
            ;Si ocurre un error, se muestra en que lugar fue, a traves de la posicion
            ;Que es estaba leyendo
            mov     eax, msg10
            call    printStr
            ;Se muestra la posicion del error
            mov     eax, [ebp + ebx * 4]
            call    printStrLn
            ;Termina el programa
            jmp     terminar_rpn_parametros
        expresionError: 
            ;Cuando ocurre un error en la expresion, se muestra el error y termina el programa
            push    eax
            mov     eax, msg9
            call    printStr
            ;Se prepara el programa para terminar y limpiar la pila
            pop     esi
            mov     eax, [esi]
            ;Termina el programa con error
            jmp     terminar_rpn_parametros
        expresionInvalida:
            ;Si se encuentra una expresion invalida en los macros llegara a estar parte y tambien terminara el programa
            mov     eax, msg11
            call    printStrLn
            jmp     terminar_rpn_parametros
        resultado_final:
            cmp     ecx, 1
            ;Si no hay solo un paremetro en la pila, la expresion es invalida ya que no se realizo correctamente las operaciones
            jne     expresionInvalida
            ;Si si es igual a 1 la cantidad en la pila, solo queda la respuesta y se muestr            
            sub     ecx, 1
            ;ECX se deja en la posicion 0 de la pila donde esta el resultado
            mov     eax, msg2
            call    printStr
            mov     eax, [parametros + ecx * 4]
            ;Se imprime el resultado
            call    iprintLn
        terminar_rpn_parametros:
            ;Termina el programa de rpn por parametros
            call    salir
;-----------------------------------------------------------------------
;-----------------------------------------------------------------------
;-----------------------------------------------------------------------
;Commienza el codigo que sucede si el usuario elige la opcion de utilizar el ingreso
;De cadena para obtener el resultado de la expresion
;Esta se llega cuando el usuario solo escribe rpn sin ningun parametro
        ingresoManual:
            mov     ecx, 0
            mov     eax, msg7
            call    printStrLn
            mov     eax, msg8
            call    printStrLn
            ;input de la expresion
            mov     eax, 3
            mov     ebx, 0
            mov     ecx, expresion
            mov     edx, 20
            int     80h
            ;Ingresado el numero se compara con la cadena de cadenaSalir (salir)
            ;Si coincide, salta a terminar el programa ya que el usuario
            ;Escribio "salir"
            ;Sino, continua el proceso de la expresion
            
        procesarExpresionRpn:           
            mov     esi, expresion       
            push    esi
;------------------------------------------------------------------------
;Este codigo es que es reuitlizado del trabajo anterior, ya como se tenía que leer una cadena de texto, es trabajado 
;De diferente manera, los comentarios son los mismos de la tarea anterior

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

            ;Esta parte fue la que cambio al anterior, ya que al ser una cadena ingresada, cuando encuentra el caracter 10, que
            ;Equivale a un ENTER, se debe terminar la cadena, ya que significa que llego a su fin           
            cmp     edx, 10
            je      terminar
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
            ;cmp     byte [tamanoPila], 3                 
            ;jne     error
            ;Si el tamaño de la pila no es igual a 1, signfica que quedo algun valor almacenado a parte del resultado y ocurrira un error
            mov     eax, msg2
            call    printStr
            ;Se mueve el resultado que se encuentra en la pila a eax para imprimirse
            mov     eax, [pila]            
            call    iprintLn           
            jmp     ingresoManual
;------------------------------------------------------------------------
;Esta parte se utiliza cuando el usuario ingresa una expresion que no es valida, y hara que termine el programa
        error:
            mov     eax, msg4
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