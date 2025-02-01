        AREA    Timing_Code, CODE, READONLY
        ALIGN
        THUMB
        EXPORT  Systick_Start_asm
        EXPORT  Systick_Stop_asm
		;EXPORT	SysTick_Handler ; When the correct time comes,
									; remove this from the comments.
		EXTERN	ticks

SysTick_Handler FUNCTION
		PUSH	{LR}
		; You should only increment ticks here.
		POP		{PC}
		ENDFUNC

Systick_Start_asm FUNCTION
		PUSH	{LR}
		; You should initialize SysTick here.
        POP		{PC}
		ENDFUNC

Systick_Stop_asm FUNCTION
		PUSH	{LR}
		; You should stop SysTick, zero the ticks,
			; and return "non-zero value of ticks".
		POP		{PC}
		ENDFUNC

		END
