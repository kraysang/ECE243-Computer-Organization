// Program that counts consecutive 1s

          .text                   // executable code follows
          .global _start                  
_start:                             
          MOV     R5, #0          // R5 hold the largest result of ONES
          MOV     R6, #0          // R6 hold the largest result of ZEROS
          MOV     R7, #0          // R7 hold the largest result of ALTERNATE
		  MOV     R0, #TEST_NUM   // R0 point to address to load data    
		  MOV     R10, #MAX        
          LDR     R10, [R10]        // R10 = ffffffff
          MOV     R11, #ALT        
          LDR     R11, [R11]        // R11 = aaaaaaaa

MAIN:     LDR	  R1, [R0]	  // R1<-[R0]
          CMP     R1, #0          // check if reach end of the list
          BEQ	  END      	      //branch if equal
		  
		  LDR	  R1, [R0]	  // R1<-[R0]
		  BL      ONES            // Find longest string of 1
		  CMP     R0,R5           //if(R0 > R5)
          MOVGT   R5,R0           //R5 = R0 (Z==0&N==V)
		  
		  LDR	  R1, [R0]	  // R1<-[R0]
		  BL      ZEROS           // Find longest string of 0
		  CMP     R0,R6           //if(R0 > R6)
          MOVGT   R6,R0           //R6 = R0 (Z==0&N==V)
		  
		  LDR	  R1, [R0]	  // R1<-[R0]
   		  BL      ALTER           // Find longest string of alternating 1 and 0
		  CMP     R0,R7           //if(R0 > R6)
          MOVGT   R7,R0           //R7 = R0 (Z==0&N==V)
		  
		  ADD	R0, #4	
		  B		MAIN
//--------------------------------------------------------------------------------		  
//--------------------------------------------------------------------------------		  
ONES:	 MOV     R0, #0			  // R0 will hold the result
            
ONES_LOOP:CMP     R1, #0          // loop until the data contains no more 1's
          BEQ     ONES_DONE             
          LSR     R2, R1, #1      // perform SHIFT, followed by AND
          AND     R1, R1, R2      
          ADD     R0, #1          // count the string length so far
          B       ONES_LOOP 
		  
ONES_DONE:	 BX 	  LR
//--------------------------------------------------------------------------------
//--------------------------------------------------------------------------------		  
ZEROS:	 MOV     R0, #0			  // R0 will hold the result	 
		 EORS    R1, R10
            
ZEROS_LOOP: 
		  CMP     R1, #0          // loop until the data contains no more 1's
          BEQ     ZEROS_DONE             
          LSR     R2, R1, #1      // perform SHIFT, followed by AND
          AND    R1, R1, R2      
          ADD     R0, #1          // count the string length so far
          B       ZEROS_LOOP

ZEROS_DONE:	 BX 	  LR
//--------------------------------------------------------------------------------
//--------------------------------------------------------------------------------		  

ALTERNATE:MOV     R0, #0          // R0 will hold the result
		  EORS     R1, R11
		  
ALT_LOOP: CMP     R1, #0          // loop until the data contains no more 1's
          BEQ     ALT_DONE       
          LSR     R2, R1, #1      // perform SHIFT, followed by AND
          AND     R1, R1, R2      
          ADD     R0, #1          // count the string length so far
          B       ALT_LOOP 
		
ALT_DONE: BX 	  LR
//--------------------------------------
END:      B       END 

MAX:      .word   0xffffffff//10101010101010101010101010101010
TEST_NUM: .word   0x103fe00f
		  .word   55
          .word   111
          .word   239


          .end                            
