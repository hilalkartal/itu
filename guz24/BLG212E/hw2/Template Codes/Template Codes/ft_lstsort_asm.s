; Function: ft_lstsort_asm
; Parameters:
;   R0 - Pointer to the list (address of t_list *)
;   R1 - Pointer to comparison function (address of int (*f_comp)(int, int))
        AREA    Sorting_Code, CODE, READONLY
        ALIGN
        THUMB
        EXPORT  ft_lstsort_asm

ft_lstsort_asm FUNCTION
		PUSH	{R0-R1, LR}
		;LDR	R3, [SP]	 ; you will see the first argument
								; of the function in R3
		;LDR	R3, [SP, #4] ; you will see the second argument
								; of the function in R3
		; Given a singly linked list,
			; sort it using bubble sort by swapping nodes
		POP		{R0-R1, PC}
		ENDFUNC
