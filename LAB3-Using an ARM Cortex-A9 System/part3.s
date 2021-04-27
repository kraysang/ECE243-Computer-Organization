/* Program that finds the largest number in a list of integers	*/

            .text                   // executable code follows
            .global _start
			
_start:                             
            MOV     R4, #RESULT     // R4 points to result location
            LDR     R0, [R4, #4]    // R0 holds the number of elements in the list
            MOV     R1, #NUMBERS    // R1 points to the start of the list
            BL      LARGE           
            STR     R0, [R4]        // R0 holds the subroutine return value

END:        B       END             

/* Subroutine to find the largest integer in a list
 * Parameters: R0 has the number of elements in the lisst
 *             R1 has the address of the start of the list
 * Returns: R0 returns the largest item in the list
 */
LARGE:		MOV		R2, R0      //set R2 hold the number of elements in the list
			LDR 	R0, [R1]	//get the first number in the list
			B 		LOOP		//loop
			

LOOP:	   	SUBS   R2, #1		//decreased R2 by 1 each time
			 BEQ 	DONE		//if R2==0, end the loop
			 ADD	R1, #4		
			 LDR 	R3, [R1]	//iterating,get next element
			 CMP 	R0, R3		//compare r0 r3
			 BLT 	LOAD		//if r0<r3,get the load
			 B		LOOP		//loop again
			 
LOAD:		MOV		 R0, R3
			B		LOOP

DONE:
			BX		LR			//return the largest value


RESULT:     .word   0           
N:           .word   7           // number of entries in the list
NUMBERS:    .word   4, 5, 3, 6  // the data
             .word   1, 8, 2                 

             .end                            

