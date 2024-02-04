;	associating defined segments with segment registers
ASSUME CS:codeStored, DS:dataStored

;	defining segment for data
dataStored SEGMENT
	;	Define Bytes($->terminator)(13->carriage return)(10->newline)
	askForString DB 13, 10, "enter a string:","$"
	theConcatStr DB 13, 10, "concatenated string:","$"
	theString1 DB "$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$"
	theString2 DB "$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$"
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

	catStr PROC
		MOV DX, SI
		CALL msgPrint
		MOV DX, DI
		CALL msgPrint
		RET
	catStr ENDP

	START_FROM_HERE:
		;	selecting the data segment for use
		MOV AX, dataStored
		MOV DS, AX

		;	print message(ask for string)
		LEA DX, askForString
		CALL msgPrint

		;	read keyboard
		LEA SI, theString1 
		CALL getString 

		;	print message(ask for string)
		LEA DX, askForString
		CALL msgPrint

		;	read keyboard
		LEA SI, theString2 
		CALL getString

		;	print message(this was entered string)
		LEA DX, theConcatStr
		CALL msgPrint

		LEA SI, theString1
		LEA DI, theString2
		CALL catStr
	STOP:
		;	exit to dosbox
		MOV AX, 4C00h
		INT 21h
codeStored ENDS

;	specify code entry point
END START_FROM_HERE

