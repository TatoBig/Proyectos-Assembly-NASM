%include	'studio.asm'

SECTION .data
        msg1        db          'Nombre: ', 0h       
        pos1        db          1Bh, '[0;01H', 0h
        pos2        db          1Bh, '[12;34H', 0h             
        pos3        db          1Bh, '[24;01H', 0h              

SECTION .bss                                    ; BLOCK Started Symbol
        n1: resb    20

SECTION .text
        global  _start
    _start:            
        call    clrscr                  
        mov     eax, pos1         
        call    printStr
        mov     eax, msg1
        call    printStr
        mov     edx, 20                 ;cantid de bytes a leer
        mov     ecx, n1                 ;apunta al espacio reservado
        mov     ebx, 0                  ;escritura a STDIN
        mov     eax, 3                  ;invoca SYS_READ
        int     80h
        mov     eax, pos2               
        call    printStr
        mov     eax, n1             
        call    printStr
        mov     eax, pos3              
        call    printStr    
        call    salir
