;-------------------------------------------------------------------------------
; MSP430 Assembler Code Template for use with TI Code Composer Studio
;
;
;-------------------------------------------------------------------------------
            .cdecls C,LIST,"msp430.h"       ; Include device header file
            
;-------------------------------------------------------------------------------
            .def    RESET                   ; Export program entry-point to
         .data                                    ; make it known to linker.
; 0, 1, 2, 3, 4, 5, 6, 7, 8, 9
arr     .byte   00111111b, 00000110b, 01011011b, 01001111b, 01100110b, 01101101b, 01111101b, 00000111b, 01111111b, 01101111b
arr_end

sec     .byte   00h
csec    .byte   00h
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
setup_INT:
      bis.b   #0F0h, &P2IE       ; Enable interrupts for P2.7, P2.6, P2.5, P2.4
      and.b   #00Fh, &P2SEL      ; Configure P2.7, P2.6, P2.5, P2.4 as GPIO
      and.b   #00Fh, &P2SEL2     ; Configure P2.7, P2.6, P2.5, P2.4 as GPIO
      bis.b   #0F0h, &P2IES      ; Set edge select to high-to-low for P2.7, P2.6, P2.5, P2.4
      clr     &P2IFG             ; Clear all interrupt flags for P2

      eint

; r4 = 1, r5 = 10, r6 = 100, r7 = 1000
Setup:
    bis.b   #0FFh, &P1DIR
    bis.b   #00Fh, &P2DIR
    bic.b   #0FFh, &P1OUT
    mov.b   #001h, &P2OUT
	mov.b	#2d, r10
Set_timer:
    ; TA0CTL: 15-10 ..100001x010
    ; TA0CCR0: #10486d
    ; TA0CCTL0: 00??x?x00011x?x0
    mov.w   #01000010000b, TA0CTL
    mov.w   #10486d, TA0CCR0
    mov.w   #0000000000010000b, TA0CCTL0

Main:
	call	#decidemode
    call    #BCD2Dec
    mov.b   @r4, &P1OUT
    mov.b   #08h, &P2OUT
    nop
    nop
    clr     &P1OUT
    clr     &P2OUT
    mov.b   @r5, &P1OUT
    mov.b   #04h, &P2OUT
    nop
    nop
    clr     &P1OUT
    clr     &P2OUT
    mov.b   @r6, &P1OUT
    mov.b   #02h, &P2OUT
    nop
    nop
    clr     &P1OUT
    clr     &P2OUT
    mov.b   @r7, &P1OUT
    mov.b   #01h, &P2OUT
    nop
    nop
    clr     &P1OUT
    clr     &P2OUT
    jmp     Main


decidemode	cmp	#0, r10
			jeq Setup
			cmp #1, r10
			jeq stop
			cmp	#2, r10
			jeq	continue
			;cmp	#3, r10
			;jeq save
continue	ret


stop		nop
			jmp decidemode

ISR:
    dint
    mov.b   #00h, sec
    mov.b   #00h, csec
    clr     &P2IFG
    eint
    reti

TISR:
    dint
    push    r15
    add.b   #1b, csec
    mov.b   csec, r15
    bic.b   #0F0h, r15
    cmp     #0Ah, r15
    jz      ADDDecSec
    jmp     TISRend

ADDDecSec:
    add.b   #010h, csec
    bic.b   #00Fh, csec
    mov.b   csec, r15
    cmp     #0A0h, r15
    jz      ADDSec
    jmp     TISRend

ADDSec:
    add.b   #001h, sec
    bic.b   #0FFh, csec
    mov.b   sec, r15
    cmp     #0Ah, r15
    jz      ADDDekSec
    jmp     TISRend

ADDDekSec:
    add.b   #010h, sec
    bic.b   #00Fh, sec
    mov.b   sec, r15
    cmp     #0A0h, r15
    jz      RESET

TISRend:
    pop     r15
    eint
    reti

BCD2Dec:
    push    r14

    mov.b   csec, r14
    bic.b   #0F0h, r14
    mov.w   #arr, r4
    add.w   r14, r4

    mov.b   csec, r14
    rra.b   r14
    rra.b   r14
    rra.b   r14
    rra.b   r14
    bic.b   #0F0h, r14
    mov.w   #arr, r5
    add.w   r14, r5

    mov.b   sec, r14
    bic.b   #0F0h, r14
    mov.w   #arr, r6
    add.w   r14, r6

    mov.b   sec, r14
    rra.b   r14
    rra.b   r14
    rra.b   r14
    rra.b   r14
    bic.b   #0F0h, r14
    mov.w   #arr, r7
    add.w   r14, r7

    pop     r14
    ret

;registerdaki deðeri deðiþicem
ISR_reset   dint
            ; Handle Reset (P2.7)
            mov.w #0, r10
            eint
            reti

ISR_stop    dint
            ; Handle Stop (P2.6)
            mov.w #1, r10
            eint
            reti

ISR_start   dint
            ; Handle Start (P2.5)
            mov.w	#2, r10
            eint
            reti



                                            

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
            
			.sect   ".int09"                ; MSP430 RESET Vector
            .short  TISR

             .sect   ".int07"           ; Vector for P2.7 (Reset)
            .short  ISR_reset

            .sect   ".int06"           ; Vector for P2.6 (Stop)
            .short  ISR_stop

            .sect   ".int05"           ; Vector for P2.5 (Start)
            .short  ISR_start
