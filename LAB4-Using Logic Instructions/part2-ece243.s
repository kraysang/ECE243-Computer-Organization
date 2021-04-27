/* Program that counts consecutive 1s */

          .text                   // executable code follows
          .global _start                  
_start:                             
          MOV     R1, #TEST_NUM   // R3 point to first number in the list
          MOV     R5, #0          // R5 will hold the result of longest ones
		  
LIST:     LDR     R3, [R1],#4       // R3<-[R1],R1=R1+4
		  CMP     R3,#0 			//check if reach end of the list
		  BEQ     END               //branch if equal
		  BL      ONES              //else go the ones
		  CMP     R0,R5           //if(R0 > R5)
          MOVGT   R5,R0           //R5 = R0 (Z==0&N==V)
          B       LIST

ONES: 	  MOV     R0, #0          // R0 will hold the result

LOOP:     CMP     R3, #0          // loop until the data contains no more 1's
          BEQ     END_LOOP             
          LSR     R2, R3, #1      // perform SHIFT, followed by AND
          AND     R3, R3, R2      
          ADD     R0, #1          // count the string length so far
          B       LOOP            

END:      B       END            

END_LOOP:  BX LR                 

TEST_NUM: .word   0x103fe00f
		  .word   55
          .word   111
          .word   239


          .end                            
