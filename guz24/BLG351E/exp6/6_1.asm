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
            .data
array		.word	00111111b, 00000110b, 01011011b, 01001111b
lastElement			;	0			1		2			3

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
Setup       mov.b   #00000000b, &P2SEL      ; Set P2SEL for GPIO mode
            mov.b   #11111111b, &P1DIR      ; Set P1DIR as output for 7-segment segments
            mov.b   #00001111b, &P2DIR      ; Set P2DIR as output for digit selection (P2.0-P2.3)
            mov.b   #00000000b, &P1OUT      ; Initialize P1OUT (all segments OFF)
            mov.b   #00000000b, &P2OUT      ; Initialize P2OUT (all digits OFF)
            mov.w   #array, r13             ; Load starting address of lookup table into r13

Mainloop    mov.b   0(r13), &P1OUT          ; Load segment value for '0' into P1OUT
            mov.b   #1, &P2OUT              ; Enable first digit (P2.0)
            call    #ShortDelay             ; Brief delay to maintain high refresh rate

            mov.b   2(r13), &P1OUT          ; Load segment value for '1' into P1OUT
            mov.b   #2, &P2OUT              ; Enable second digit (P2.1)
            call    #ShortDelay

            mov.b   4(r13), &P1OUT          ; Load segment value for '2' into P1OUT
            mov.b   #4, &P2OUT              ; Enable third digit (P2.2)
            call    #ShortDelay

            mov.b   6(r13), &P1OUT          ; Load segment value for '3' into P1OUT
            mov.b   #8, &P2OUT              ; Enable fourth digit (P2.3)
            call    #ShortDelay

            jmp     Mainloop                ; Repeat the sequence indefinitely

;HIGH FREGUENCY FOR VISIBILITY
ShortDelay  mov.w   #0010h, r14             ; Small loop counter for short delay
DelayLoop   dec.w   r14
            jnz     DelayLoop
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
            
