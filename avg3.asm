;	associates the defined segments with the segment registers
ASSUME CS:codeStored, DS:dataStored 

dataStored SEGMENT
	asking_num1 DB "num1:","$" 
	asking_num2 DB "num2:","$" 
	asking_num3 DB "num3:","$" 
	msg_avg DB "average is:","$"
dataStored ENDS

codeStored SEGMENT
	

	START_FROM_HERE:
		MOV AX, dataStored
		MOV DS, AX

		;	prints the msg
		MOV AH, 09h
		LEA DX, msg_avg 
		INT 21h

	STOP:
		;	built in function to exit back to dosbox
		MOV AX, 4C00h
		INT 21h
codeStored ENDS

;	specifying as directive where the code entry point is (START_FROM_HERE)
END START_FROM_HERE
