;	associating defined segments with segment registers
ASSUME CS:codeStored, DS:dataStored

;	defining segment for data
dataStored SEGMENT
	;	Define Bytes($->terminator)(13->carraige return)(10->newline) 
	msg1 DB 13, 10, "enter a character:","$"
	msg2 DB 13, 10, "entered character:","$"
dataStored ENDS

;	defining segment for code
codeStored SEGMENT
	START_FROM_HERE:
		;	selecting the data segment for use
		MOV AX, dataStored
		MOV DS, AX

		;	print msg
		MOV AH, 09h
		LEA DX, msg1
		INT 21h

		;	store char in AL
		MOV AH, 01h
		INT 21h
		
		;	show the keyboard input
		MOV AH, 09h
		LEA DX, msg2
		INT 21h

		MOV AH, 02h
		MOV DL, AL
		INT 21h

	STOP:
		;	exit to dosbox
		MOV AX, 4C00h
		INT 21h
codeStored ENDS

;	specify code entry point
END START_FROM_HERE

