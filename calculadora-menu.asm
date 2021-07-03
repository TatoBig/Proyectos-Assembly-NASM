%include        'stdio.asm'

SECTION .bss                                    
        n1:     resb    10                
		n2:     resb 	10
        op:     resb    10
        
SECTION .data
    msg1    db  'Escribir una opcion', 0Ah, 0h
    msg2 	db 	'1. Suma: ', 0Ah, 0h
	msg3 	db 	'2. Resta: ', 0Ah, 0h
	msg4 	db 	'3. Multiplicacion: ', 0Ah, 0h
    msg5 	db 	'4. Division: ', 0Ah, 0h
    msg6    db  '5. Ingresar numeros', 0Ah, 0h
    msg7    db  '6. Salir', 0Ah, 0h
    msg8    db  'Residuo: ', 0Ah, 0h
    msg9    db  'n1: ', 0h
    msg10   db  'n2: ', 0h
    msg12   db  'Opcion desconocida ', 0Ah, 0h
    msg13   db  'Resultado: ', 0Ah, 0h

SECTION .text
    global  _start
    _start:      
        jmp     menu      
    menu:            
        mov     eax, msg1
        call    printStr
        mov     eax, msg2
        call    printStr
        mov     eax, msg3
        call    printStr
        mov     eax, msg4
        call    printStr
        mov     eax, msg5
        call    printStr
        mov     eax, msg6
        call    printStr
        mov     eax, msg7
        call    printStr
        mov     eax, 3
        mov     ebx, 0
        mov     ecx, op
        mov     edx, 4
        int     80h
        mov     ah, [op]
        sub     ah, 48
        cmp     ah, 1
        je      sumar
        cmp     ah, 2
        je      restar
        cmp     ah, 3
        je      multiplicar
        cmp     ah, 4
        je      dividir
        cmp     ah, 5
        je      ingresarNumeros
        cmp     ah, 6
        je      finalizar
        jg      noEncontrado            
    sumar:      
        mov	    eax, msg2
        call	printStr
        mov	    eax, n1            
        call 	atoi
        mov	    ebx, eax
        push	ebx                  
        mov     eax, msg13
        call    printStr    
        mov	    eax, n2
        call 	atoi    
        pop	    ebx
        add	    ebx, eax
        mov	    eax, ebx
        call	iprintLn
        jmp     menu
    restar: 
        mov     eax, msg3     
        call    printStr   
        mov	    eax, n1
        call	atoi
        mov	    ebx, eax
        push	ebx                  
        mov     eax, msg13
        call    printStr
        mov	    eax, n2
        call	atoi            
        pop	    ebx
        sub	    ebx, eax
        mov	    eax, ebx
        call	iprintLn     
        mov     eax, 162
        int     80h
        jmp     menu
    multiplicar:    
        mov	    eax, msg4
        call	printStr
        mov	    eax, n1
        call	atoi
        mov	    ebx, eax
        push	ebx            
        mov	    eax, msg13
        call	printStr	
        mov	    eax, n2
        call	atoi                
        pop	    ebx
        mul	    ebx
        call	iprintLn
        jmp     menu
    dividir:
        mov	    eax, msg5
        call	printStr
        mov	    eax, n2
        call	atoi
        mov	    ebx, eax
        push	ebx
        mov	    eax, msg13
        call	printStr
        mov	    eax, n1
        call	atoi
        mov     edx, 0
        pop	    ebx
        div	    ebx
        call	iprintLn
        mov	    eax, msg8
        call    printStr
        mov 	eax, edx
        call	iprintLn
        jmp     menu
    noEncontrado:     
        mov     eax, msg12
        call    printStr
        jmp     menu
    ingresarNumeros:
        mov     eax, msg9
        call    printStr
        mov     edx, 10            
        mov     ebx, 0
        mov     ecx, n1
        mov     eax, 3
        int     80h
        mov     eax, msg10
        call    printStr
        mov     edx, 10            
        mov     ebx, 0
        mov     ecx, n2
        mov     eax, 3
        int     80h
        jmp     menu
    atoi:
        push    ebx            
        push    ecx             
        push    edx             
        push    esi             
        mov     esi, eax        
        mov     eax, 0          
        mov     ecx, 0          
    _loop:
        xor     ebx, ebx      
        mov     bl, [esi+ecx] 
        cmp     bl, 48          
        jl      _endLoop       
        cmp     bl, 57          
        jg      _endLoop   
        sub     bl, 48
        add     eax, ebx        
        mov     ebx, 10         
        mul     ebx      
        inc     ecx             
        jmp     _loop   
    _endLoop:
        mov     ebx, 10         
        div     ebx            
        pop     esi             
        pop     edx             
        pop     ecx             
        pop     ebx             
        ret  
    finalizar:                
        call    salir


