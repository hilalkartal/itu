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
lastElement
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
init_INT	bis.b	#020h, &P2IE     ; Enable interrupt for P2.5
			and.b	#0DFh, &P2SEL    ; Clear P2.5 selection bits in P2SEL
			and.b	#0DFh, &P2SEL2   ; Clear P2.5 selection bits in P2SEL2

			bis.b	#020H, &P2IES    ; Set interrupt edge for P2.5
			clr		&P2IFG          ; Clear interrupt flag for port 2
			eint                    ; Enable general interrupts

Setup       mov.b   #00000000b, &P2SEL      ; Set P2SEL for GPIO mode
			mov.b	#00000000b, &P2SEL2   ; Clear P2.5 selection bits in P2SEL2
            mov.b   #11111111b, &P1DIR      ; Set P1DIR as output for 7-segment segments
            mov.b   #00001111b, &P2DIR      ; Set P2DIR as output for digit selection (P2.0-P2.3)
            bic.b   #0FFh, &P1OUT      ; Initialize P1OUT (all segments OFF)
            mov.b   #001h, &P2OUT      ; Initialize P2OUT (all digits OFF)
            mov.w   #array, r13             ; Load starting address of lookup table into r13

			mov.w	#0, r12	;x
			mov.w	#0, r11	;w
			mov.w	#5, r10	;s
			mov.w	#0, r5

main		;there is a r at the end it is at r9
			;push for function call
			push.w	r12			;push x
			call	#square
			pop.w	r12			;x = x.x
			add.w	r10, r11	;w = w + s
			add.w	r11, r12    ;x = x + w
			push.w	r12			; to not lose original x
			mov.w	r12, r9 	; to left shift x
			rra		r12
			rra		r12
			rra		r12
			rra		r12

			rla		r9
			rla		r9
			rla		r9
			rla		r9

			bis.w	r12, r9		;r9 = r
			pop.w	r12			; to get original x back
			push.w	r9			;r
			push.w  #10000000b	;129 for modulo
			call	#modulo
			pop.w   r8
			jmp 	main


square		mov.w	2(SP), r4
			mov.w	#0, r5
			mov.w	r4, r6		;r6 counter
squ_cmp		cmp		#0, r6
			jeq		square_end
			add.w	r4, r5
			dec.w	r6
			jmp		squ_cmp
square_end	mov.w	r5, 2(SP)
			ret

;if the button is pushed we need to show the value at r at leds
ISR			dint
			;;;; what happends at interrupt
			push.w	r9			;r
			push.w  #10000001b	;129 for modulo
			call	#modulo
			pop.w	r8
			pop.w	r9			;empty stack
			;modulýnun returnunu r8'e at r8 cevap
			;call 	#binary_to_bcd
			;call 	#shownumber
			clr		&P2IFG
			eint
			reti

;r4, r5, r6 serbest
modulo		mov.w	2(SP), r4	;r4'te 129 var
			mov.w	4(SP), r5	;r5'te modunu bulmak istediðmiz sayý var
modloop		cmp 	r4, r5
			jl		ret_mod
			sub.w 	r4, r5
			jmp		modloop

ret_mod		mov.w	r5, 2(SP);
			ret


;;;;;;;;;binary to bcd lazým;;;;;;;;;;;;;;;;;;;
;r4 = hundreds
;r5 = tens
;r6 = ones
binary_to_bcd	mov.w	#0, r4              ; Clear hundreds digit
    			mov.w	#0, r5               ; Clear tens digit
    			mov.w	#0, r6               ; Clear ones digit

    			cmp     #129, r8         ; Check if the input exceeds 128
    			jge     error             ; Jump to error handler if out of range

    ; Extract hundreds digit
hundreds_loop	cmp     #100, r8         ; Compare binary value with 100
    			jl      tens_loop         ; If less than 100, proceed to tens digit
    			sub.w   #100, r8         ; Subtract 100
    			inc.w   r4               ; Increment hundreds digit
    			jmp     hundreds_loop     ; Repeat until R8 < 100

    ; Extract tens digit
tens_loop		cmp     #10, r8          ; Compare binary value with 10
    			jl      ones_loop         ; If less than 10, proceed to ones digit
    			sub     #10, R8          ; Subtract 10
    			inc     r5               ; Increment tens digit
    			jmp     tens_loop         ; Repeat until R12 < 10

    ; Extract ones digit
ones_loop		mov.w     r8, r6          ; Store remaining value in ones digit
    			ret                       ; Return with result in R13, R14, and R15

error			mov.w     #0xFF, r4        ; Error indicator: invalid input
    			mov.w     #0xFF, r5
    			mov.w     #0xFF, r6
    			ret


;will change the n(r13) n value according to result of the algorithm
shownumber  mov		r4, r12					; Load hundreds digit into r12
			call	#led_value
			mov.b   #2, &P2OUT              ; Enable second digit (P2.1)
			mov.b   r12, &P1OUT          ; Load segment value for '0' into P1OUT


            call    #ShortDelay             ; Brief delay to maintain high refresh rate

			mov		r5, r12
			call	#led_value
			mov.b   #4, &P2OUT              ; Enable third digit (P2.2)
            mov.b   r12, &P1OUT          ; Load segment value for '1' into P1OUT

            call    #ShortDelay

			mov		r6, r12
			call	#led_value
			mov.b   #8, &P2OUT              ; Enable fourth digit (P2.3)
            mov.b   r12, &P1OUT          ; Load segment value for '2' into P1OUT

            call    #ShortDelay




;HIGH FREGUENCY FOR VISIBILITY
ShortDelay  mov.w   #0010h, r14             ; Small loop counter for short delay
DelayLoop   dec.w   r14
            jnz     DelayLoop
            ret

led_value	push    r5                 ; Save R5 (used as index register)
    		mov.w   #array, r5			; Load address of array
    		;add.w   r12, r12
    		add.w   r12, r5            ; Offset to the correct pattern
    		mov.b   @r5, r12           ; Load segment pattern into R12
    		pop     r5                 ; Restore R5
    		ret                        ; Return with result in R12
                                            


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
