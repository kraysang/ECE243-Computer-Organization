
.equ HEX_ADDR, 0xFF200020
.equ KEY_ADDR, 0xFF200050 //points to KEY
.equ KEY_EDGE, 0xFF20005C //points to edge 
.equ TIMER,0xFFFEC600 //points to timer

.text
.global _start

_start:
        LDR R0,=0xFF200020	//HEX_ADDR
		LDR R1,=0xFF200050	//KEY_ADDR
        LDR R2,=0xFF20005C	//KEY_EDGE
        LDR R3, =0xFFFEC600 //TIMER

        LDR R8, =DATA //ones digit
        LDR R9, =DATA //tens digit
        MOV R4, #0 			//if key pressed R4=1,released =0
        MOV R5, #0 			//if Start =1 Stop =0

        LDR R7, =2000000 //the counting value
        STR R7,[R3]
        
POLL:   LDR R6,[R1]
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
        BNE STOP_COUNT
        B POLL 
         
INCRE_DISPLAY:
        MOV R7,#0b011 //start counter
        STR R7,[R3,#0x8]
		
        MOV R12,#0
        
        LDR R7,[R9] 
        LSL R7,#8
        ADD R12,r7
        
        LDR R7,[R8] 
        ADD R12,r7
        
        STR R12,[R0]
        
        //start counting down
        LDR R7,[R3,#0xC]
        CMP R7,#1
        BEQ INCRE
        B POLL
        
INCRE:  
        STR R7,[R3,#0xC]//restart timmer
        LDR R7,=DATA
        ADD R7,#36
        
        CMP R8,R7 //9
        LDREQ R8, =DATA //ones digit
        ADDEQ R9, #4
        ADDNE R8, #4
        
        CMP R9,R7 //90
        LDREQ R9, =DATA //tens digit
        ADDEQ R10,#4
        
        LDREQ R8, =DATA 
        LDREQ R9, =DATA 
      
        
        B POLL
        
STOP_COUNT:
        MOV R7,#0b010 //stop counter
        STR R7,[R3,#0x8]
        B POLL


DATA:           .word 0b00111111                        // '0'
                        .word 0b00000110                        // '1'
                        .word 0b01011011                        // '2'
                        .word 0b01001111                        // '3'
                        .word 0b01100110                        // '4'
                        .word 0b01101101                        // '5'
                        .word 0b01111101                        // '6'
                        .word 0b00000111                        // '7'
                        .word 0b01111111                        // '8'
                        .word 0b01100111                        // '9'

.end
        
        
        
        