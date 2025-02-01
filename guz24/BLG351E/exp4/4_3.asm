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
array_A		.word	15, 3, 7, 5
lastA
array_B		.word	2, -1, 7, 3
lastB
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
Setup		mov		#array_A, r8
			mov		#array_B, r9

			mov.w	#0, r7		;result keeper
dotproduct	push.w	@r8
			push.w	@r9
			inc		r8
			inc		r8
			inc		r9
			inc		r9
			call	#m_mul
			pop.w	r6
			add.w	r6, r7
			cmp		#lastA, r8
			jlo		dotproduct
			jmp		finish
;-----------------------
m_mul		mov.w	2(SP), r5	; get varB to r5 from stack
			mov.w	4(SP), r4	; get varA to r4 from stack
			mov.w	#0, r6		; result keeper
			;if r5 minus go to sub_mul
			;if r5 plus continue with add_mul
			cmp	#0,  r5			;do r5-0 = B-0
			jl	iter_m_m

iter_m_p	dec		r5			; B--
			;push.w	r5			; to get original r5 from stack after return from add call
			cmp		#0, r5		; do r5-0 = B-0
			jl		ret_mul		; if B<0 go to return_mul
			;----------------
			;push.w	r4
			;push.w	r6
			;call 	m_add
			;---------------
			add.w	r4, r6
			;pop.w	r6
			;pop.w	r4			;???
			;pop.w	r5			; get r5 back
			jmp		iter_m_p


iter_m_m	inc		r5			; B++
			;push.w	r5			; to get original r5 from stack after return from add call
			cmp		#1, r5		; do
			jge		ret_mul		; if B>=1 go to return_mul
			;----------------
			;push.w	r4
			;push.w	r6
			;call 	m_add
			;---------------
			sub.w	r4, r6
			;pop.w	r6
			;pop.w	r4			;???
			;pop.w	r5			; get r5 back
			jmp		iter_m_m


ret_mul		mov.w r6, 2(SP)
			ret

;-----------------------

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
            
