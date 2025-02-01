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
array		.word	00111111b, 00000110b, 01011011b, 01001111b, 01100110b, 01101101b, 01111101b, 00000111b, 01111111b, 01101111b
lastElement			;	0			1		2			3			4			5			6		7			8			9


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
Setup		mov.b	#00000000b, &P2SEL
			mov.b	#11111111b, &P1DIR	;make A,B,C,D,E,F,G and dot output
			mov.b	#00001000b, &P2DIR	;only make the P2.3 output
			mov.b	#00000000b, &P1OUT	;make the pins closed off at first
			mov.w		#array,	r13			;move the first element of the array to r13

counter		mov.b	#00000000b, r10		;make counter value zero
Mainloop	mov.b	0(r13), &P1OUT			;move the value in r13 to P1OUT
			mov.b	r13, r9
			call	#Delay
			inc.w	r13					;inrement the index
			inc.w	r13
			inc.b	r10					;inrement counter
			cmp		#10, r10			;if r10 is lesser then 10 go to mainloop
			jl		Mainloop
			jmp		Setup

Delay		mov.w	#0Ah, r14			;delay to r14
L2			mov.w	#07A00h, r15
L1			dec.w	r15
			jnz		L1
			dec.w	r14
			jnz		L2
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
            
