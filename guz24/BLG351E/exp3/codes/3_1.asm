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

			.data
			.align
Avar		.word	150
Bvar		.word	10
Cvar		.word 	0x00
Dvar		.word	0x00
;-------------------------------------------------------------------------------
RESET       mov.w   #__STACK_END,SP         ; Initialize stackpointer
StopWDT     mov.w   #WDTPW|WDTHOLD,&WDTCTL  ; Stop watchdog timer


;-------------------------------------------------------------------------------
; Main loop here
;-------------------------------------------------------------------------------
SetupP1		mov.w	#00000000b, &P2SEL
			mov.w	Avar, R12
			;mov.w	#150d, R12
			mov.w	Bvar, Cvar
			mov.w	Avar, Dvar

			mov.w	Bvar, R13
			;mov.w	#10d, R13

			mov.w	Dvar, R5					;A=D
			mov.w 	Cvar, R4					;B=C

_start		;clrc							;clear carry flag
			mov.w 	R12, R11				;R1 = A
			rra		R11						;R1 = A / 2

comparison_c
			cmp		R11, R4					;compare C with A/2
			jl		_multiply_c				;C < A/2 go to multiplication

comparison_d
			cmp		R5, R13					;compare B with D
			jl		_subtract_d
			jeq		_subtract_d
			;D = R5 is the remainder now
			sub.w	R5, R12					;A - D => A  (R2 - R5 = R2)

			jmp		end

_multiply_c
			rla		R4						;C * 2
			jmp		comparison_c

_subtract_d
			cmp		R4, R5					;compare D and C		ERROR HERE MAYBE
			jl		_divide_c				;if D < C go to _divide_c
			sub.w	R4, R5					;D - C = D (R5)
			rra		R4
			jmp		comparison_d

_divide_c	;clrc							;clear carry flag
			rra		R4						;C / 2
			jmp		_subtract_d

end			jmp 	end
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
            
