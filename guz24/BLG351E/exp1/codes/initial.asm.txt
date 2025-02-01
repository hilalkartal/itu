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

SetupP1		mov.b	#11111111b,&P1DIR		;can set every bit bit as output
			mov.b	#11111111b,&P2DIR		; b -> bit ; h -> hexadecimal ; d -> decimal ; .b -> byte
			mov.b	#00000000b,&P1OUT		;all leds are set to 0 initially
			mov.b	#00000000b,&P2OUT
			mov.b	#00001000b, R6			;will be used in mainloop1
			mov.b	#00010000b, R7			;will move them to P1OUT and P2OUT
			mov.b	#0d, R8                 ;will be used to keep the loop variable
											;for(int R8=0; R8<4; R8++)

			;What is the difference between mov and bis
Mainloop1	bis.b	R6, &P1OUT
			bis.b	R7, &P2OUT
			inc 	R8
			rra		R6						;rotate right arithmetically
			rla		R7						;rotate left arithmetically
			mov.w	#00500000,	R15

L1			dec.w	R15
			jnz 	L1						;jump to L1 if not zero
			cmp		#4d, R8
			jeq		SetupP1
			jmp		Mainloop1

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
            
