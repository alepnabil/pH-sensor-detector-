%include "io.inc"

;declare variable
section .data

data dq 'abdcefgh',0
password dq '12345678',0
correct dq 0

section .text
global CMAIN
CMAIN:
    mov ebp, esp; for correct debugging
    ;write your code here
    xor eax, eax
    
    
    ;declare variable


    MOV ebp, esp ; debug

    XOR EAX, EAX ;clear register

    XOR ECX, ECX 

    

    MOV EAX, [ds:password]
    MOV EBX, [ds:data]

    MOV ecx, 8    ;load our counter into register counter

    compare:
        CMP EAX,EBX ;

        JE  equal

        JNE not_equal

           equal:
    
                MOV DX, 1
    
                MOV [ds:correct], DX    
    
                JMP done
    
           not_equal:
    
                MOV DX, 0
    
                MOV [ds:correct ], DX
    
                JMP done

done:

loop compare
ret

