%include	'studio.asm'

SECTION .data
        msg     db          'Hola mundo!', 0h       ;11 caracteres
        nombre  db          'Arquitectura I', 0h    ;14 caracteres
        pos1    db          1Bh, '[12;34H', 0h
        pos2    db          1Bh, '[13;34H', 0h
        posal   db          1Bh, '[24;01H', 0h

SECTION .text
        global  _start
        _start:
                call    clrscr
                mov     eax, pos1
                call    printStr
                mov     eax, msg
                call    printStr
                mov     eax, pos2
                call    printStr
                mov     eax, nombre
                call    printStr
                mov     eax, posal
                call    printStr                
                call    salir
