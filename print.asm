;	associates the defined segments with the segment registers
ASSUME CS:codeStored, DS:dataStored 

dataStored SEGMENT
	msg DB "this is a sentence !!!!!","$" 
dataStored ENDS

codeStored SEGMENT
	THIS_IS_START:
		MOV AX, dataStored
		MOV DS, AX

		;	prints the msg
		MOV AH, 09h
		LEA DX, msg 
		INT 21h

	STOP:
		;	built in function to exit back to dosbox
		MOV AX, 4C00h
		INT 21h
codeStored ENDS

;	specifying as directive where the code entry point is (THIS_IS_START)
END THIS_IS_START
