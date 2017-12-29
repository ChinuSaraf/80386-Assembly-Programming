;=======================================================
;Author: Sangat Das
;Contact Mail: sangatdas5@gmail.com
;Title: Multiplication of two 2 digits numbers
;=======================================================
  
section .data
	nl   : db "",10
	lnl  : equ $- nl
	msg1 : db "Enter first number: ",10
	len1 : equ $- msg1
	msg2 : db "Enter second number: ",10
	len2 : equ $- msg2
	msg3 : db "Enter option number: ",10
	len3 : equ $- msg3
	msg4 : db "1. Multiplication by repeatitive addition: ",10
	len4 : equ $- msg4
	msg5 : db "2 .Multiplication by shift and add: ",10
	len5 : equ $- msg5
	msg6 : db "3. Exit ",10
	len6 : equ $- msg6
	msg7 : db "Your product is: ",10
	len7 : equ $- msg7
	
section .bss
	choice : resb 1
	num1 :resb 2
	num2 :resb 2
	temp: resb 1
	cnt: resb 1
section .text
    global _start
      _start:

	%macro print 2
	mov rax,1
	mov rdi,1
	mov rsi,%1
	mov rdx,%2
	syscall
	%endmacro

	%macro accept 2
	mov rax,0
	mov rdi,0
	mov rsi,%1
	mov rdx,%2
	syscall
	%endmacro



;===============Accepting data nd choice=================
menu:
	print nl,lnl
	print msg3,len3
	print msg4,len4
	print msg5,len5
	print msg6,len6
	accept choice,2

	cmp byte[choice],33H
	je exit

	print msg1,len1
	accept num1,3
	print msg2,len2
	accept num2,3

;====================Converting numbers to HEX============
xor r9,r9
xor r10,r10

mov rsi,num1
call A_H
mov r9b,al					;r9 has first number

mov rsi,num2
call  A_H
mov r10b,al				;r10 has second number

cmp byte[choice],31H
je case1
cmp byte[choice],32H
je case2


;========================Repetative Addition==================
case1:
mov byte[cnt],r10b
mov bx,00H

rep_add:
add bx,r9w
dec byte[cnt]
jnz rep_add
call H_A
jmp menu

;=======================Shift and Add=======================
case2:
mov byte[cnt],08H
	xor bx,bx
	shift:
	shl bx,1
	shl r10b,1
	jnc down
	add bx,r9w
	down: 
	dec byte[cnt]
	jnz shift

	call H_A
jmp menu

;===================Exiting===============
exit:
mov rax,60
mov rdi,0
syscall

;=================Procedures==============
A_H:
xor ax,ax
mov byte[cnt],02H
conv:
	rol al,4
	mov bl,byte[rsi]
	cmp bl,39H
	jbe subt
	sub bl,07H
	subt: sub bl,30H
	add al,bl
	inc rsi
	dec byte[cnt]
	jnz conv
ret

H_A:
print msg7,len7
mov byte[cnt],4
xor r8,r8
conv1:
	rol bx,4
	mov r8w,bx
	and ebx,000FH
	cmp bl,09H
	jbe addi
	add bl,07H
	addi: add bl,30H
	mov byte[temp],bl
	print temp,1
	mov bx,r8w
	dec byte[cnt]
	jnz conv1
ret
