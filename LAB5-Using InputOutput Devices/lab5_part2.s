.text
.global _start

_start:
		LDR R0,=0xFF200020	//HEX_ADDR
		LDR R1,=0xFF200050	//KEY_ADDR
        LDR R2,=0xFF20005C	//KEY_EDGE
		LDR R8, =DATA 		//ones digit
        LDR R9, =DATA 		//tens digit
		LDR R7, =0x2        //counting value
		MOV R4, #0 			//if key pressed R4=1,released =0
        MOV R5, #0 			//if Start =1 Stop =0
       
POLL:
		LDR R6,[R1]
		CMP R6, #0
		BNE START_STOP		//if some key is pressed 
        BEQ NO_KEY_PRESS	//if no key is pressed 
		
START_STOP:
        CMP R4,#0 			//if key is released perviously
		EOREQ R5,#1			//Flip the start/stop signal(if it is stop currently, flip to start,else it is start, flip to stop)
        MOV R4,#1 			//R4 = 1 when key pressed
        
NO_KEY_PRESS:    
       
        LDR R6, [R2]
		CMP R6, #0     		//check press
        STRNE R6, [R2] 		//to reset edge flag store 1 into that key edge
        MOVNE R4, #0		//reset key pressed signal
        
        CMP R5,#1           //if the start flag is on, go to display
        BEQ INCRE_DISPLAY
       
        B POLL //if the start flag is off

         
INCRE_DISPLAY:
	    LDR R11,[R9] //load tens digit
        LSL R11,#8
        LDR R10,[R8] //load ones digit
        ADD R6,R10,R11
        STR R6,[R0]
        //start counting down
        SUBS R7,#1
        BEQ INCRE
        B POLL
        
INCRE:	
		LDR R7, =0x2000 //reset counting value
        CMP R10,#9 //ones =9
        LDREQ R8, =DATA //ones digit
        ADDEQ R9, #4
        ADDNE R8, #4
        
        MOV R12,#99
        CMP R6,R12 //99
        LDREQ R8, =DATA //ones digit
        LDREQ R9, =DATA //tens digit
		
        B POLL


DATA:		.word 0b00111111			// '0'
			.word 0b00000110			// '1'
			.word 0b01011011			// '2'
			.word 0b01001111			// '3'
			.word 0b01100110			// '4'
			.word 0b01101101			// '5'
			.word 0b01111101			// '6'
			.word 0b00000111			// '7'
			.word 0b01111111			// '8'
			.word 0b01100111			// '9'


.end






