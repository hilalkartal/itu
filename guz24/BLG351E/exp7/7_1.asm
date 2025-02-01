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
			mov.b	#00000000b, &P2SEL
init_INT	bis.b	#020h, &P2IE     ; Enable interrupt for P2.5
			and.b	#0DFh, &P2SEL    ; Clear P2.5 selection bits in P2SEL
			and.b	#0DFh, &P2SEL2   ; Clear P2.5 selection bits in P2SEL2

			bis.b	#020H, &P2IES    ; Set interrupt edge for P2.5
			clr		&P2IFG          ; Clear interrupt flag for port 2
			eint                    ; Enable general interrupts

			mov.b	#11111111b, &P1DIR	;make A,B,C,D,E,F,G and dot output
			mov.b	#00100000b, &P2DIR	;only make the P2.5 output
			mov.b	#00000000b, &P1OUT	;make the pins closed off at first

Setup		mov.w	#11, r10	;p = 11
			mov.w	#13, r11	;q = 13
			mov.w	#5, r12	;s = 5
			mov.w	#0, r5	;s = 5
			;push variables onto stack before mul call
			push.w	r10			;p
			push.w	r11			;q
			call	#m_mul
			pop.w 	r10			; now result is at r4 = M
			pop.w	r11			;empty stack

blumblum	;push these onto stack for power
			push.w	r12		;s
			push.w	r12		;s (for power)
			call	#m_mul
			pop.w	r13		;r
			pop.w	r12		;empty stack

			push.w	r13		;r
			push.w	r10		;M
			call #modulo
			pop.w	r8		; r = cevap
			mov.w	r8, r12	; s = r
			jmp	blumblum


;if the button is pushed we need to show the value at r at leds
ISR			dint
			;;;; what happends at interrupt
			;r8u ledlerde göstericem
			call 	#binary_to_bcd
			call 	#shownumber
			clr		&P2IFG
			eint
			reti
;-----------------------
m_mul	mov.w	2(SP), r5	; get varB to r5 from stack
		mov.w	4(SP), r4	; get varA to r4 from stack
		push.w	r5
		mov.w	#0, r6		; result keeper

iter_m	dec		r5			; B--
		;push.w	r5			; to get original r5 from stack after return from add call
		cmp		#0, r5		; do r5-0 = B-0
		jl		ret_mul		; if B<0 go to return_mul

		add.w	r4, r6
		;;;;;;;; for add call
		;push.w	r4
		;push.w	r6
		;call 	#m_add
		;pop.w	r6
		;pop.w	r4			;???
		;;;;;;;;;
		;pop.w	r5			; get r5 back

		jmp		iter_m

ret_mul	mov.w r6, 4(SP)
		pop.w r5
		ret
;-----------------------
;-----------------------
;m_add	mov.w	2(SP), r5	; get varB to r5 from stack
;		mov.w	4(SP), r4	; get varA to r4 from stack
;		add.w	r4, r5		; r5 = r4 + r5

;		mov.w	r5, 2(sp)	; move the result to stack
;		ret
;-----------------------
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

    			cmp     #143, r8         ; Check if the input exceeds 143
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
			mov.b   r12, &P1OUT          ; Load segment value for '0' into P1OUT
            mov.b   #1, &P2OUT              ; Enable first digit (P2.0)
            call    #ShortDelay             ; Brief delay to maintain high refresh rate

			mov		r5, r12
			call	#led_value
            mov.b   r12, &P1OUT          ; Load segment value for '1' into P1OUT
            mov.b   #2, &P2OUT              ; Enable second digit (P2.1)
            call    #ShortDelay

			mov		r6, r12
			call	#led_value
            mov.b   r12, &P1OUT          ; Load segment value for '2' into P1OUT
            mov.b   #4, &P2OUT              ; Enable third digit (P2.2)
            call    #ShortDelay


;HIGH FREGUENCY FOR VISIBILITY
ShortDelay  mov.w   #0010h, r14             ; Small loop counter for short delay
DelayLoop   dec.w   r14
            jnz     DelayLoop
            ret

led_value	push    r5                 ; Save R5 (used as index register)
    		mov.w   #array, r5			; Load address of array
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
