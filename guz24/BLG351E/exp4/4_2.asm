;-------------------------------------------------------------------------------
; MSP430 Assembler Code Template for use with TI Code Composer Studio
;
;
;-------------------------------------------------------------------------------
            .cdecls C,LIST,"msp430.h"       ; Include device header file
            
;-------------------------------------------------------------------------------
            .def    RESET                   ; Export program entry-point to

;-------------------------------------------------------------------------------
; Data Section
;-------------------------------------------------------------------------------
            .data                           ; Data memory
Avar		.word	8
Bvar		.word   16
Cvar		.word	4
Dvar		.word   3
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
;r1 is the SP

;first i need values
Setup	mov.w	Avar, r4	; get varA to r4 = 8
		mov.w	Bvar, r5	; get varB to r5 = 16
		mov.w	Cvar, r6	; get varA to r4 = 20
		mov.w	Dvar, r7	; get varB to r5 = 12

;ADD call--------------
		; push variables onto stack
		push.w	r4
		push.w	r5
		; now parameters are ready for the fucntion call
		call	#m_add		; add is called
		pop.w 	r8			; now result is at r6 = 24
		pop.w	r4			; ???
;SUB call----------------
		; push variables onto stack
		push.w	r6
		push.w	r7
		; now parameters are ready for the fucntion call
		call	#m_sub		; sub is called
		pop.w 	r9			; now result is at r9 = 8

;MUL call--------------
		; push variables onto stack
		push.w	r6
		push.w	r7
		; now parameters are ready for the fucntion call
		call	#m_mul		; sub is called
		pop.w 	r10			; now result is at r10 = 240


;DIV call--------------
		; push variables onto stack
		mov.w	Avar, r4	; get varA to r4 = 8
		mov.w	Cvar, r6	; get varA to r4 = 20
		push.w	r4
		push.w	r6
		; now parameters are ready for the fucntion call
		call	#m_div		; sub is called
		pop.w 	r11			; now result is at r11 = 1

;function definitions
;-----------------------
m_add	mov.w	2(SP), r5	; get varB to r5 from stack
		mov.w	4(SP), r4	; get varA to r4 from stack
		add.w	r4, r5		; r5 = r4 + r5

		mov.w	r5, 2(sp)	; move the result to stack
		ret
;-----------------------
m_sub	mov.w	2(SP), r5	; get varB to r5 from stack
		mov.w	4(SP), r4	; get varA to r4 from stack
		sub.w	r5, r4		; r4 = r4 - r5

		mov.w	r4, 2(sp)	; move the result to stack
		ret
;-----------------------
m_mul	mov.w	2(SP), r5	; get varB to r5 from stack
		mov.w	4(SP), r4	; get varA to r4 from stack

		mov.w	#0, r6		; result keeper

iter_m	dec		r5			; B--
		push.w	r5			; to get original r5 from stack after return from add call
		cmp		#0, r5		; do r5-0 = B-0
		jl		ret_mul		; if B<0 go to return_mul
		push.w	r4
		push.w	r6
		call 	#m_add
		pop.w	r6
		pop.w	r4			;???
		pop.w	r5			; get r5 back
		jmp		iter_m

ret_mul	mov.w r6, 4(SP)
		pop.w r5
		ret
;-----------------------
m_div	mov.w	#0, r6		; result keeper

		mov.w	2(SP), r5	; get varB to r5 from stack
		mov.w	4(SP), r4	; get varA to r4 from stack
iter_d	;maybe here(cmp		#0, r4		; do r4-0 = A-0)
		push.w	r4
		push.w	r5
		call	#m_sub
		pop.w	r4
		pop.w	r14
		cmp		#0, r4		; do r4-0 = A-0
		jl		ret_d		; if A<0 go to ret_div
		inc		r6
		jmp		iter_d

ret_d	mov.w	r6, 2(SP)
		ret
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
            
