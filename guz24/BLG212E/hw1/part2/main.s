;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
	;Hilal Kartal 
	;150210087
	;PART2
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
								;define the constants variables
W_Capacity 	EQU 	200			;50*4
SIZE		EQU		12			;3*4


			AREA for_dp_array, DATA, READWRITE		;Define that this part will write in DATA area
			ALIGN
dp_array	SPACE 	W_Capacity 					;allocate memory space for dp	
dp_array_end


			AREA knapsack_iteration, CODE, READONLY		;define that this part will read from CODE area
			ENTRY
			THUMB
			ALIGN

__main 		FUNCTION
			EXPORT __main
				
				
			LDR r1, =profit			
			LDR r2, =weight				
			LDR r3, =dp_array

knapsack	;return value should be loaded to r0
			
			MOVS r4, #4 	; index i = 1
			MOVS r5, #SIZE	; n = SIZE
			ADDS r5, r5, #4	; n-> n+1
loop_i		CMP r4, r5		; i and n+1 comparison
			BGE	stop_i		; stop i loop if i >= n+1
			MOVS r6, #W_Capacity	; w = W
loop_w		MOVS r7, #0		; 0 value for comparison
			CMP r6, r7		; w >= 0
			BLT stop_w		; stop w loop if w < 0
			;;;;;;;;;;getting ready the if state checks
			PUSH {r4}			; push i to stack to retrieve at end of if statement
			SUBS r4, #4		; i -> i-1
			LDR r4, [r2, r4]; r4 = weight[i-1]
			MOVS r0, #4		; for multiply
			MULS r4, r0, r4 ; r4 = weight[i-1] * 4
if_sta		CMP r4, r6		; weight[i-1] * 4 and w
			BGT	skip_if		; weight[i-1] * 4 > w


max			;r0 = dp[w] and r7 = dp[[w - weight[i-1]] + profit[i-1]]
			LDR r0, [r3, r6] 	; r0  = dp[w]
			SUBS r7, r6, r4		; r7 = [w - weight[i-1]
			LDR r7, [r3, r7]	; r7 = dp[w - weight[i-1]]
			POP {r4}			; r4 = i
			PUSH {r4} 			; push i back to stack
			SUBS r4, r4, #4		; i -> i-1
			LDR r4, [r1, r4]	; r4 = profit[i-1]
			ADDS r7, r7, r4; r7 = dp[[w - weight[i-1]] + profit[i-1]]
			CMP	r0, r7		; r0 = dp[w] and r7 = dp[[w - weight[i-1]] + profit[i-1]]
			BGE	store_r0	;if dp[w] >= dp[[w - weight[i-1]] + profit[i-1]]  
			STR r7, [r3, r6]; store r7 at dp[w]				
			B skip_if
			
store_r0 	STR r0, [r3, r6]; store r0 at dp[w]
			B skip_if	;storing is done, go to end of if
			

skip_if		SUBS r6, #4		; w decrement
			POP {r4}		; retrival of i
			B loop_w		; go back to loop_w
	
					 
stop_w		ADDS r4, #4		; increment i
			B loop_i		; go back to loop i
		
			
stop_i		MOVS r5, #W_Capacity	; get the W value for dp[w]
			LDR r0, [r3, r5]		; r0 = dp[W] 

			

while_1		B while_1         ; Branch back to while_1 indefinitely

			ALIGN		;close the main function       
			ENDFUNC
profit	DCD 60, 100, 120		;initialize the given arrays
weight 	DCD 10, 20, 30
			END