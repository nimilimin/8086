;	associating defined segments with segment registers
ASSUME CS:codeStored, DS:dataStored

;	defining segment for data
dataStored SEGMENT
	;	Define Bytes($->terminator)(13->carriage return)(10->newline)
	askForString DB 13, 10, "enter a string:","$"
	theStringWas DB 13, 10, "the entered string:","$"
	theString DB "$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$"
dataStored ENDS

;	defining segment for code
codeStored SEGMENT
	
	;defining procedures

	;	prints(address->DX)	
	msgPrint PROC
		MOV AH, 09h
		INT 21h
		RET
	msgPrint ENDP

	;	get char from keyboard(stored->AL)
	getChar PROC
		MOV AH, 01h
		INT 21h
		RET
	getChar ENDP
	
	;	get string from keyboard till \r(Enter pressed)(base address->SI)
	getString PROC
		GET_CHAR:
			CALL getChar
			
			CMP AL, 13
			JZ CARRIAGE_RETURN

			MOV [SI],AL
			INC SI
			JMP GET_CHAR
		CARRIAGE_RETURN:
			RET
	getString ENDP


	START_FROM_HERE:
		;	selecting the data segment for use
		MOV AX, dataStored
		MOV DS, AX

		;	print message(ask for string)
		LEA DX, askForString
		CALL msgPrint

		;	read keyboard
		LEA SI, theString 
		CALL	getString 

		;	print message(this was entered string)
		LEA DX, theStringWas
		CALL msgPrint

		LEA DX, theString
		CALL msgPrint

	STOP:
		;	exit to dosbox
		MOV AX, 4C00h
		INT 21h
codeStored ENDS

;	specify code entry point
END START_FROM_HERE

