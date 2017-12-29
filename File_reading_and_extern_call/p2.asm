;====================================================
;Name: Chinmay Saraf
;Contact Mail: chinmay.saraf98@gmail.com
;Title: File Reading using extern call (load this after p1.asm)
;====================================================

section .data

section .bss
global count
count : resb 1

section .text

extern buffer

;ASCII value for space is 20H
global no_space
no_space:
 	mov rsi,buffer
 	mov byte[count],00H
 	
 	loop_space:
 		cmp byte[rsi],20H
 		jne down
 		inc byte[count]
 		down: inc rsi
 		cmp byte[rsi],00H
 		jne loop_space 
 	
 	cmp byte[count],09H
 	jbe down1
 	add byte[count],07H
 	down1: add byte[count],30H
ret


;ASCII value for space is 0AH
global no_line
no_line:
 	mov rsi,buffer
 	mov byte[count],00H
 	
 	loop_line:
 		cmp byte[rsi],0AH
 		jne down22
 		inc byte[count]
 		down22: inc rsi
 		cmp byte[rsi],00H
 		jne loop_line 
 	
 	cmp byte[count],09H
 	jbe down2
 	add byte[count],07H
 	down2: add byte[count],30H
ret


global no_char
no_char:
	extern char
	

	mov r8b,byte[char]
 	mov rsi,buffer
 	mov byte[count],00H
 	
 	loop_char:
 		cmp byte[rsi],r8b
 		jne down33
 		inc byte[count]
 		down33: inc rsi
 		cmp byte[rsi],00H
 		jne loop_char
 	
 	cmp byte[count],09H
 	jbe down3
 	add byte[count],07H
 	down3: add byte[count],30H
ret

