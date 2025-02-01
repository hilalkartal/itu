;-------------------------------------------------------------------------------
; MSP430 Assembler Code Template for use with TI Code Composer Studio
;
;
;-------------------------------------------------------------------------------
            .cdecls C,LIST,"msp430.h"       ; Include device header file
            
;-------------------------------------------------------------------------------
            .def    RESET                   ; Export program entry-point to
                                            ; make it known to linker.
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
SetupP1		mov.b 	#11011111b, &P1DIR	;enable the P1.5 pin for input
			mov.b 	#11111111b, &P2DIR	; p2 is the output port
			mov.b	#00000100b, &P2OUT	; make all outputs zero
			mov.b	#00000000b, &P1OUT

			mov.b	#0b, R5
wait		mov.w	#50000, R6
decR			dec.w	R6
			jnz decR

Mainloop1	bit.b 	#00100000b, &P1IN	; check if the button is pressed
			jz 	Mainloop1				; if pressed go to ledOn2
			xor.b	#00001100b, &P2OUT
			;call	#Debounce

loo2			bit.b 	#00100000b, &P1IN
			jnz		loo2
			jmp wait
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
            
