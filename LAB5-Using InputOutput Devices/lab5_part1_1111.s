          .text                   // executable code follows
          .global _start                  
_start:  
		LDR     R0, =0xFF200020     // HEX3-0
		MOV	    R5, #0		//count                     
        MOV     R2, #BIT_CODES       // pattern to start
          


POLL: 	 LDR		R4, =0xFF200050		// KEYs 
		 LDR		R4,[R4]
		 CMP	R4, #0
		 MOVNE	R3,R4
		 CMP	R4, #0
		 BNE	POLL
		 
		 CMP		R3, #1				//if KEY0		
		 MOVEQ		R5,#0
		 
		 
		 CMP		R3, #2				//if KEY1
		 ADDEQ		R5, #1
		 CMP		R5, #9					
       	 MOVGT		R5, #0
		 
		 CMP	  	R3, #4				//if KEY2
		 SUBEQ		R5, #1			//decrease 1
		 CMP		R5, #0				// Check if < 0
       	 MOVLT		R5, #9

		 CMP		R3,#8
		 BLT		DISPLAY
			
			
		 CMP		R3, #8				//KEY3
		 BEQ		CLEAR		//CLEAR the display
	     
		 
		 B       	POLL   		 
		 
DISPLAY:	
		MOV     R2, #BIT_CODES
		LDRB    R2, [R2, R5]
		STR		R2, [R0]
		MOV		R3, #0
		B       POLL


		 	 
CLEAR: 
		MOV     R5, #0
        STR		R5, [R0]
		MOV		R3, #0
		
		LDR 	R4, =0xFF200050		// Load the value of the keys
        LDR		R4, [R4]
		CMP		R4, #0
		BEQ		CLEAR

        
WAIT:		
		LDR 	R4, =0xFF200050		// Load the value of the keys
        LDR		R4, [R4]
		MOV		R5,#0
        CMP		R4, #0
		BNE		WAIT
		
		MOV     R2, #BIT_CODES
		LDRB    R2, [R2, R5]
		STR		R2, [R0]
		MOV		R3, #0
		
		B		POLL

		           

//END:      B       END             


                                   
BIT_CODES:  .byte   0b00111111, 0b00000110, 0b01011011, 0b01001111, 0b01100110
            .byte   0b01101101, 0b01111101, 0b00000111, 0b01111111, 0b01100111
            .skip   2      // pad with 2 bytes to POLLtain word alignment

CLEAR_CODE:.byte   0b00000000



