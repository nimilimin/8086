;	associating defined segments with segment registers
ASSUME CS:codeStored, DS:dataStored

;	defining segment for data
dataStored SEGMENT
	;	Define Bytes($->terminator)(13->carriage return)(10->newline)
	theFunctionIs DB 13, 10, "the function is: f(x,y)=(x+y)*(x-y)","$"
	askForNumber DB 13, 10, "enter a number:","$"
	ansIsMsg DB 13, 10, "the answer is:","$"
	num1 DB 00h,"$"
	num2 DB 00h,"$"
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

	;	convert ascii char to hex
	asciiToHex PROC
		;	compare with 'a'
		CMP AL, 97
		JL DIGIT_HANDLE
		JMP ALPHABET_HANDLE

		DIGIT_HANDLE:
			SUB AL, 48
			RET
		ALPHABET_HANDLE:
			SUB AL, 97
			ADD AL, 10
			RET
	asciiToHex ENDP

	;	get number from kbd(8 bits long)(stored->BL)
	getNumber PROC
		CALL getChar
		CALL asciiToHex
		MOV BL, AL
		MOV CL, 4
		SHL BL, CL

		CALL getChar
		CALL asciiToHex
		ADD BL, AL
		RET
	getNumber ENDP

	;	put hex number as ascii 
	;	conv 16 bit hex to ascii char(data in BX)
	hexToAscii PROC
		CMP DL, 10
		JL DIGIT
		JMP ALPHABET

		DIGIT:
			ADD DL, 48
			RET
		ALPHABET:
			ADD DL, 97
			SUB DL, 10
			RET	
	hexToAscii ENDP
	
	;	(data->DL)
	putChar PROC 
		CALL hexToAscii
		MOV AH, 02h
		int 21h
		RET
	putChar ENDP

	printNumber PROC
		MOV CL, 4
		MOV CH, 0
		CHAR_LOOP:
			CMP CH, 4
			JE CHAR_OVER
			ROL BX,CL
			MOV DL,BL
			AND DL,0Fh
			CALL putChar
			INC CH
			JMP CHAR_LOOP
		CHAR_OVER:
			RET
	printNumber ENDP

	START_FROM_HERE:
		;	selecting the data segment for use
		MOV AX, dataStored
		MOV DS, AX

		;	print message(the function)
		LEA DX, theFunctionIs
		CALL msgPrint

		;	print message(ask num1)
		LEA DX, askForNumber
		CALL msgPrint

		;	read kbd
		CALL getNumber
		LEA DI, num1
		MOV [DI], BL
		
		;	print message(ask num2)
		LEA DX, askForNumber
		CALL msgPrint

		;	read kbd
		CALL getNumber
		LEA DI, num2
		MOV [DI], BL

		;	print message(the answer is)
		LEA DX, ansIsMsg
		CALL msgPrint
		
		;add num1 and num2
		MOV AX,0000h
		MOV BX,0000h
		
		LEA SI, num1
		LEA DI, num2

		MOV BL,[SI]
		MOV CL,[DI]
		ADD CL, BL

		;sub num1 and num2
		MOV AX,0000h
		MOV BX,0000h

		MOV AL,[SI]
		MOV BL,[DI]
		SUB AL, BL

		;multiply
		MUL CL
		MOV BX, AX
		CALL printNumber
	STOP:
		;	exit to dosbox
		MOV AX, 4C00h
		INT 21h
codeStored ENDS

;	specify code entry point
END START_FROM_HERE

