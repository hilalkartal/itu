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
; Data Section
;-------------------------------------------------------------------------------
            .data                           ; Data memory
hash        .space 58                       ; Allocate 58 bytes for hash table
;splitID     .word 150, 210, 087    ;Store values directly in memory
Avar		.word	150
Mvar		.word	210
Nvar		.word	187
Bvar		.word	29
Cvar		.word 	0x00
Dvar		.word	0x00
;-------------------------------------------------------------------------------
			.text


;-------------------------------------------------------------------------------
; Main code starts here
;-------------------------------------------------------------------------------
;Setup0
;    mov     &splitId, R0      ; Load the address of splitId into R0
;    mov     @R0, R7           ; Load the value at address in R0 into R7
;    add     #4, R0            ; Increment R0 by 4 to point to the next value
;    mov     @R0, R8           ; Load the value at address in R0 (now R0 + 4) into R8
;    add     #4, R0            ; Increment R0 by 4 again to point to the next value
;    mov     @R0, R9           ; Load the value at address in R0 (now R0 + 8) into R9

; selinin modulus fonksiyonuna call etmemiz lazým sonra dönen value remainder olmalý
; onu da r4'te store etmiþ

hash1	mov   #hash, r10  ; load the start of hash

			mov.w	#00000000b, &P2SEL
			mov.w	Avar, R12
			;mov.w	#150d, R12
			mov.w	Bvar, Cvar
			mov.w	Avar, Dvar

			mov.w	Bvar, R13
			;mov.w	#10d, R13

			mov.w	Dvar, R5					;A=D
			mov.w 	Cvar, R4					;B=C



		;mov.w r12, r7	; A'yý first value yaptýk
		;mov.w #29, r13   ; B'yi 29 yaptýk
		call  		#modulus	; þuan r4'te a'nýn modulusu olmalý
		;call  		#cf_storage    ; go to linear prob check
		add.w		r5, r5
		add.w 		r5, r10  ; get #hash + remainder
		;str r7, [r10]	; store the value at the proper place
		mov.w   	Avar, 0(R10)  ; Store the value in R8 to the memory address pointed to by R10


		mov &hash, r10  ; load the start of hash

			mov.w	#00000000b, &P2SEL
			mov.w	Mvar, R12
			;mov.w	#150d, R12
			mov.w	Bvar, Cvar
			mov.w	Avar, Dvar

			mov.w	Bvar, R13
			;mov.w	#10d, R13

			mov.w	Dvar, R5					;A=D
			mov.w 	Cvar, R4

		;mov.w r12, r8	; A'yý second value yaptýk
		;mov.w #29, r13   ; B'yi 29 yaptýk
		call  #modulus	; þuan r4'te a'nýn modulusu olmalý
		;call  #cf_storage    ; go to linear prob check
		add.w	r5, r5
		add.w r5, r10  ; get #hash + remainder
		;str r8, [r10]	; store the value at the proper place
		mov Mvar, 0(R10)

		mov &hash, r10  ; load the start of hash


			mov.w	#00000000b, &P2SEL
			mov.w	Nvar, R12
			;mov.w	#150d, R12
			mov.w	Bvar, Cvar
			mov.w	Avar, Dvar

			mov.w	Bvar, R13
			;mov.w	#10d, R13

			mov.w	Dvar, R5					;A=D
			mov.w 	Cvar, R4

		;mov.w r12, r9	; A'yý third value yaptýk
		;mov.w #29, r13   ; B'yi 29 yaptýk
		call  		#modulus	; þuan r4'te a'nýn modulusu olmalý
		;call  		#cf_storage    ; go to linear prob check
		add.w		r5, r5
		add.w 		r5, r10  ; get #hash + remainder
		;str r9, [r10]	; store the value at the proper place
		mov.w 		Nvar, 0(R10)
		jmp 		end

cf_storage	mov.w 	#58, r1 	;load table size


		;ldr r6, [r4, r5, lsl, #2] ;Load value at hash[r4] (index * 4, as each entry is 4 bytes)
    ;??????????
    mov     R5, R12          ; Copy index (r4) into R12
    ;shl     #2, R12          ; Shift index left by 2 (index * 4)
    rla		R12
    rla		R12
    add     R12, R10          ; Add base address (R5) to the shifted index
    mov     0(R10), R6          ; Load the value from the computed address into R6


		cmp #0, r6     ; compare if it is zero
		jeq turn_back

		; If not empty, try the next (linear probing)
        	add.w 	r5, r5                    ; Increment by 4 because value are 4 byte? (probe next slot)
        	cmp 	r5, r10                      ; Check if we've wrapped around to the start
        	jl 		cf_storage                   ; If not wrapped, continue probing
           	;mov.w 	#0, r5                        ; If wrapped around, start from index 0
           	jmp 	cf_storage                     ; Continue probing from the beginning

turn_back	ret


modulus


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

			jmp		end_modulus

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

end_modulus		ret

end			jmp		end
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
