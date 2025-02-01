;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
	;Hilal Kartal 
	;150210087
	;PART1
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
								;define the constants variables
W_Capacity 	EQU 	200			;50*4
SIZE		EQU		12			;3*4


			AREA knapsack_recursion, CODE, READONLY		;define that this part will read from CODE area
			ENTRY
			THUMB
			ALIGN

__main 		FUNCTION
			EXPORT __main
				
				
			LDR r1, =profit			
			LDR r2, =weight				
			;move the parameters for knapsack
			MOVS r3, #W_Capacity	; W = W_Capacity
			MOVS r4, #SIZE			; n = SIZE 
			BL knapsack				; branch with link to knapsack
									; now LR holds the return address
			;when i come back to here i should see r0 as the value

while_1		B while_1         		; Branch back to while_1 indefinitely

knapsack	; return value should be loaded to r0 
			; parameters are r3 and r4
			PUSH {LR}		; oush the return address onto stack
			PUSH {r3}		; push the parameters onto stack
			PUSH {r4}		; to get them back when returning
			
if_1		MOVS r5, #0				; to check conditions
			CMP r3, r5              ; Compare W with 0
			BEQ return1      		; If W == 0, branch to return1

			CMP r4, r5              ; Compare n with 0
			BEQ return1      		; If n == 0, branch to return1

if_2		SUBS r4, r4, #4			; n -> n-1
			LDR r7, [r2, r4]		; r7 = weight[n-1]
			;need to multiply weight[i-1] with 4 
			MOVS r6, #4				; for multiplying
			MULS r7, r6, r7			; r7 = weight[i-1] * 4
			CMP r7, r3				; r7 = weight[n-1] * 4 and r3 = W
			BGT return2

else_2 		; need to go into knapsack once retturn value will be max(a ,b)'s a
			; need to ready the parameters for first knapsack
			; r3 is already W
			; r4 is laready n - 1 
			BL knapsack				; branch for first knapsack
			; return value is already at r0
			PUSH {r0}				; r0 is max(a, b)'s a and at stack
			
			; ready the parameters for secodn knapsack
			; r4 is already n-1
			LDR r5, [r2, r4]		; r5 = weight[n-1]
			;need to multiply weight[i-1] with 4 
			MOVS r6, #4				; for multiplying
			MULS r5, r6, r5			; r5 = weight[i-1] * 4
			SUBS r3, r3, r5 		; r3 = W - weight[n-1]
			BL knapsack				; r3 = W - weight[n-1] and r4 = n-1
			; r0 = knapsack(W - weight[n-1], n-1) 
			LDR r6, [r1, r4]; r6 = profit[i-1]
			ADDS r0, r0, r6 ; r0 = profit[i-1] + knapsack(W - weight[n-1], n-1) 
			POP {r6} 		; r6 = knapsack(W - weight[n-1], n-1) (first knapsacks r0)

max			CMP	r0, r6		;r0 = profit[i-1] + knapsack(W - weight[n-1], n-1) and r6 = knapsack(W - weight[n-1], n-1)
			BGE	return_3	;if r0 >= r6 
			MOVS r0, r6		; move r7 to r0	

return_3	;return r0
			POP {r4}		; get n from stack
			POP {r3}		; get W from stack
			POP {r7}		; get LR from stack
			BX r7			; go to LR
			;POP {r7}		; get the LR value
			;BX r7			; branch to LR


return1 	MOVS r0, #0		; if_1 returns 0 
			POP {r4}		; get n from stack
			POP {r3}		; get W from stack
			POP {r7}		; get LR from stack
			BX r7			; go to LR


return2		; need to go into knapsack
			; r4 is already n - 1
			; r3 is already W
			; r3 = W and r4 = n - 1			
			BL knapsack		; r3 = W , r4 = n-1
			POP {r4}		; get n from stack
			POP {r3}		; get W from stack
			POP {r7}		; get the LR value
			BX r7			; branch to LR

			ALIGN		;close the main function       
			ENDFUNC
profit	DCD 60, 100, 120		;initialize the given arrays
weight 	DCD 10, 20, 30
			END