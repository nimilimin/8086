;	associating defined segments with segment registers
ASSUME CS:codeStored, DS:dataStored

;	defining segment for data
dataStored SEGMENT
	;	Define Bytes($->terminator)(13->carraige return)(10->newline) 
	msg DB 13, 10, "yoooooooo !!!!!!!!","$"
dataStored ENDS

;	defining segment for code
codeStored SEGMENT
	START_FROM_HERE:
		;	selecting the data segment for use
		MOV AX, dataStored
		MOV DS, AX

		;	print msg
		MOV AH, 09h
		LEA DX, msg
		INT 21h

	STOP:
		;	exit to dosbox
		MOV AX, 4C00h
		INT 21h
codeStored ENDS

;	specify code entry point
END START_FROM_HERE

