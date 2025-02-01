;-------------------------------------------------------------------------------
; MSP430 Assembler Code Template for use with TI Code Composer Studio
;
;
;-------------------------------------------------------------------------------
            .cdecls C,LIST,"msp430.h"       ; Include device header file
            
;-------------------------------------------------------------------------------
            .def    RESET                   ; Export program entry-point to
                                             ; make it known to linker.

			.data
array_even	.word	00111111b,  01011011b, 01100110b, 01111101b,  01111111b
lastEven			;	0			2			4		6			8
array_odd	.word	00000110b, 01001111b, 01101101b, 00000111b, 01101111b
lastOdd				;	1			3		5			7			9
boolvar		.byte	00000000b
;-------------------------------------------------------------------------------
            .text                           ; Assemble into program memory.
            .retain                         ; Override ELF conditional linking
                                            ; and retain current section.
            .retainrefs                     ; And retain any sections that have
                                            ; references to current section.

;-------------------------------------------------------------------------------
RESET       mov.w   #__STACK_END,SP         ; Initialize stackpointer
StopWDT     mov.w   #WDTPW|WDTHOLD,&WDTCTL  ; Stop watchdog timer


;-------------------------------------------------------------------------------
; Main loop here
;-------------------------------------------------------------------------------
			mov.b	#00000000b, &P2SEL
init_INT	bis.b	#040h, &P2IE
			and.b	#0BFh, &P2SEL
			and.b	#0BFh, &P2SEL2

			bis.b	#040H, &P2IES
			clr		&P2IFG
			eint

			mov.b	#11111111b, &P1DIR	;make A,B,C,D,E,F,G and dot output
			mov.b	#00001000b, &P2DIR	;only make the P2.3 output
			mov.b	#00000000b, &P1OUT	;make the pins closed off at first
Setup		mov.w		#array_even, r13	;move the first element of the even array to r13
			mov.w		#array_odd, r12
			;mov.b		#boolvar, r9
			;mov.b		0(r9), r11
			mov.b	#00h, r11
			mov.b	#00000000b, r10		;make counter value zero

decidemode	;mov.b		#boolvar, r9
			;mov.b		0(r9), r11
			cmp		#0, r11
			jeq		even_loop
			jmp		odd_loop

even_loop	mov.b	0(r13), &P1OUT			;move the value in r13 to P1OUT
			call	#Delay
			inc.w	r13					;inrement the index
			inc.w	r13
			inc.b	r10					;inrement counter
			cmp		#5, r10				;if r10 is lesser then 10 go to decideloop
			jl		decidemode
			call	#r_counter
			jmp		decidemode

odd_loop	;mov.b	#00000000b, r10		;make counter value zero
			;jl		decidemode
			mov.b	0(r12), &P1OUT			;move the value in r13 to P1OUT
			call	#Delay
			inc.w	r12					;inrement the index
			inc.w	r12
			inc.b	r10					;inrement counter
			cmp		#5, r10				;if r10 is lesser then 10 go to mainloop
			jl		decidemode
			call	#r_counter
			jmp		decidemode


Delay		mov.w	#0Ah, r14			;delay to r14
L2			mov.w	#07A00h, r15
L1			dec.w	r15
			jnz		L1
			dec.w	r14
			jnz		L2
			ret

ISR			dint
			;call 	#Delay
			;mov.b		#boolvar, r9
			;mov.b		0(r9), r11
			xor.b	#11111111b, r11
			;mov.b	r11, 0(r9)
			call 	#r_counter
			clr		&P2IFG
			eint
			reti

r_counter 	mov.b	#00000000b, r10		;make counter value zero
			mov.w		#array_even, r13	;move the first element of the even array to r13
			mov.w		#array_odd, r12
			ret

finish		nop
;-------------------------------------------------------------------------------
; Stack Pointer definition
;-------------------------------------------------------------------------------
            .global __STACK_END
            .sect   .stack
            
;-------------------------------------------------------------------------------
; Interrupt Vectors
;-------------------------------------------------------------------------------
            .sect   ".reset"                ; MSP430 RESET Vector
            .short  RESET
            .sect	".int03"
            .short	ISR
