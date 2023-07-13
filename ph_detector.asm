section .data
a db 0,1,1,1,1,0
b db 0,0,0,1,0,1



SECTION .text

										;BAR is Base Address Register
LOC_i2c   			EQU 	0x90007000	;[BAR0] - I2C	
LOC_gpio			EQU		0x90006000 	;[BAR1] - GPIO

IC_ENABLE 			EQU 	6Ch				;Enable 
IC_CON				EQU 	0h				;Control Register
IC_TAR				EQU 	4h				;Master Target Address 
IC_DATA_CMD			EQU 	10h				;Data Buffer and Command
IC_RAW_INTR_STAT	EQU 	34h				;Raw Interrupt Status
IC_TX_TL			EQU 	38h				;Receive FIFO Threshold Level 
IO_expander_ADDR			EQU 0x20		;I/O Expander I2c address

GPIO_Port_A_Data			EQU 0h			;GPIO Port data
GPIO_Port_A_Dir				EQU 4h			;GPIO Port direction

setup:
nop									;no operation
nop

call setup_multiplexer				;setup Intel Galileo board I/O multiplexer 
call GPIO_6_set_output				;set GPIO_6 as Output
call GPIO_7_set_output				;set GPIO_7 as Output
mov eax,4


main:
    mov ebp, esp; for correct debugging

cmp eax,7


JL LESS_THAN ; jump to LESS_THAN if AX < 7
JE EQUAL ; jump to EQUAL if AX == 7
JG MORE_THAN ; jump to MORE_THAN if AX > 7


LESS_THAN:
call GPIO_6_off						;switch off GPIO 6
call GPIO_7_on
jmp main ; jump to end the program

EQUAL:
call GPIO_6_on						;switch off GPIO 6
call GPIO_7_on
jmp main ; jump to end the program

MORE_THAN:
call GPIO_6_off						;switch off GPIO 6
call GPIO_7_on
JMP main ; jump to end the program
							;unconditional loop

check:
mov eax, [LOC_i2c + IC_RAW_INTR_STAT]
and eax, 0x00000010 				;mask for TX_EMPTY
jz check
ret


GPIO_6_set_input:
	mov eax, [LOC_gpio + GPIO_Port_A_Dir]	;reads the Port direction register contents
	and eax, 0xffffffbf                     ;set GPIO_6 as input
	mov [LOC_gpio + GPIO_Port_A_Dir], eax 
	ret
	
GPIO_6_set_output:
	mov eax, [LOC_gpio + GPIO_Port_A_Dir]	;reads the Port direction register contents
	or eax , 0x00000040                     ;set GPIO_6 as output
	mov [LOC_gpio + GPIO_Port_A_Dir], eax 
	ret	

GPIO_6_on:
	mov eax, [LOC_gpio + GPIO_Port_A_Data]	;reads the Port data register contents
	or eax , 0x00000040                     ;turn on GPIO_6
	mov [LOC_gpio + GPIO_Port_A_Data], eax 
	ret
	
GPIO_6_off:
	mov eax, [LOC_gpio + GPIO_Port_A_Data]	;reads the Port data register contents
	and eax, 0x000000bf                     ;turn off GPIO_6
	mov [LOC_gpio + GPIO_Port_A_Data], eax 
	ret

GPIO_7_set_input:
	mov eax, [LOC_gpio + GPIO_Port_A_Dir]	;reads the Port direction register contents
	and eax, 0xffffff7f                     ;set GPIO_7 as input
	mov [LOC_gpio + GPIO_Port_A_Dir], eax 
	ret
	
GPIO_7_set_output:
	mov eax, [LOC_gpio + GPIO_Port_A_Dir]	;reads the Port direction register contents
	or eax , 0x00000080                     ;set GPIO_7 as input
	mov [LOC_gpio + GPIO_Port_A_Dir], eax 
	ret	
	
GPIO_7_on:
	mov eax, [LOC_gpio + GPIO_Port_A_Data]	;reads the Port data register contents
	or eax , 0x00000080                     ;turn on GPIO_7
	mov [LOC_gpio + GPIO_Port_A_Data], eax 
	ret
	
GPIO_7_off:
	mov eax, [LOC_gpio + GPIO_Port_A_Data]	; reads the Port data register contents
	and eax, 0x0000007f                     ;turn off GPIO_7
	mov [LOC_gpio + GPIO_Port_A_Data], eax 
	ret

setup_multiplexer:
mov [LOC_i2c + IC_ENABLE]	, dword 0x00000000	;disable i2c
mov [LOC_i2c + IC_CON]		, dword 0x00000023	;configure i2c
mov [LOC_i2c + IC_TAR]		, dword IO_expander_ADDR  ;slave address
mov [LOC_i2c + IC_TX_TL] 	, dword 0x000000ff	;configure transmit FIFO
mov [LOC_i2c + IC_ENABLE] 	, dword 0x00000001	;enable i2c

mov [LOC_i2c + IC_DATA_CMD]	, dword 0x00000018	;port select
mov [LOC_i2c + IC_DATA_CMD]	, dword 0x00000001	;port 1
mov [LOC_i2c + IC_DATA_CMD]	, dword 0x000000ff	; [19] Interrupt mask
mov [LOC_i2c + IC_DATA_CMD]	, dword 0x00000000	; [1A] Select PWM for port output
mov [LOC_i2c + IC_DATA_CMD]	, dword 0x00000000	; [1B] Inversion
mov [LOC_i2c + IC_DATA_CMD]	, dword 0x00000000	; [1C] Pin direction - Input/Output
mov [LOC_i2c + IC_DATA_CMD]	, dword 0x00000000	; [1D] Drive Mode - Pull Up
mov [LOC_i2c + IC_DATA_CMD]	, dword 0x00000000  ; [1E] Drive Mode - Pull Down
mov [LOC_i2c + IC_DATA_CMD]	, dword 0x00000000	; [1F] Drive Mode - Open Drain High
mov [LOC_i2c + IC_DATA_CMD]	, dword 0x00000000	; [20] Drive Mode - Open Drain Low 
mov [LOC_i2c + IC_DATA_CMD]	, dword 0x000000ff 	; [21] Drive Mode - Strong
mov [LOC_i2c + IC_DATA_CMD]	, dword 0x00000000 	; [22] Drive Mode - Slow Strong
mov [LOC_i2c + IC_DATA_CMD]	, dword 0x00000200 	; [23] Drive Mode - High Z
call check

mov [LOC_i2c + IC_DATA_CMD]	, dword 0x00000009 	;port 1
mov [LOC_i2c + IC_DATA_CMD]	, dword 0x0000023f 	;for mux IO2 and IO3  
call check

mov [LOC_i2c + IC_ENABLE] 	, dword 0x00000000	; disable i2c

ret
