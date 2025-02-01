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

SetupP1		mov.b	#00000000b, &P2SEL
			;mov.b	#00000000b,&P2IN
			mov.b	#11111111b,&P1DIR
			mov.b	#11110111b,&P2DIR		;input port
			mov.b	#00000000b,&P1OUT
			mov.b	#00000000b,&P2OUT		;set pullup resistor
			mov.b	#10000000b, R6

			mov.b	#0d, R8

			;is.b   #00000001b, &P2REN     ; Enable pull-up/pull-down resistor on P2.0

Mainloop1	bis.b	R6, &P1OUT

			inc 	R8
			rra		R6

			mov.w	#00500000, R15
L1			cmp 	#00001000b, &P2IN
			jeq		stop
			dec.w 	R15

			jnz		L1

			cmp		#8d, R8
			jeq		SetupP1
			jmp		Mainloop1

stop		;mov.b	#00000000b, &P1OUT		;turn all leds off
			nop
			jmp		stop

			mov.w #00500000, R15
l3			dec.w R15
			jnz l3


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
            
