;==================================================================
;Name: Chinmay Saraf
;Contact Mail: chinmay.saraf98@gmail.com
;Title: Mean,Variance, S.D. of data without printf and scanf
;===================================================================

section .data
array: dq 102.56, 56.89, 111.11, 134.78, 34.99
array_square: dq  0, 0, 0, 0, 0
msg : db "Mean is-: ",10
len : equ $-msg
msg2 : db  "Variance is-: ", 10
len2 : equ $-msg2
msg3 : db "Standart Deviation is-:  ",10
len3 : equ $-msg3
nl: db " ",10
lnl: equ $-nl
cnt: db 05H
fact: dq 10000.00
dot : db "."
lendot: equ $-dot

section .bss

%macro print 2
	mov rax,1
	mov rdi,1
	mov rsi,%1
	mov rdx,%2
	syscall
%endmacro

temp: resq 1
temp2: resq 1
temp3: resq 1
mean : resq 1
variance : resq 1
sd : resq 1
var1: resb 1
result: resb 9

section .text
global main
main:
;=================Mean==================
mov r15,array
mov byte[cnt],04H

mov byte[temp],05H		
fild qword[temp]
fstp qword[temp]					;temp= 5.0000

fld qword[r15]
mn:
add r15,8
fadd qword[r15]
dec byte[cnt]
jnz mn

fdiv  qword[temp]			;Dividing by '5'
fstp qword[mean]				;Storing mean in 'mean'



;============Variance===========
;-----------FInding square of each entry nd storing in 'array_square'-------------------------
mov r15,array
mov r14,array_square
mov byte[cnt],05H
square:
fld qword[r15]
fmul qword[r15]
fstp qword[r14]
add r15,8
add r14,8
dec byte[cnt]
jnz square

;------------------- Finding summation of square nd dividing it by '5'-----------
mov r15,array_square
mov byte[cnt],04H
fld qword[r15]
var:
add r15,8
fadd qword[r15]
dec byte[cnt]
jnz var

fdiv qword[temp]			;temp=5.0000
fstp qword[temp2]		;temp2=(x^2)/5

;------------Finding square of mean-----------
fld qword[mean]
fmul qword[mean]
fstp qword[temp3]				;temp3= mean^2

;------------Finding variance------------
fld qword[temp2]
fsub qword[temp3]

fstp qword[variance]

;=================S.D================
fld qword[variance]
fsqrt
fstp qword[sd]

;==============Printing mean,Variance,S.D==============

;---------------------Mean---------------------
print msg,len
fld qword[mean]
fmul qword[fact]
fbstp [result]
mov r8d,dword[result]
call h2a_float
print nl,lnl

;--------------------------Variance---------------
print msg2,len2
fld qword[variance]
fmul qword[fact]
fbstp [result]
mov r8d,dword[result]
call h2a_float
print nl,lnl

;--------------------S.D.-----------------------
print msg3,len3
fld qword[sd]
fmul qword[fact]
fbstp [result]
mov r8d,dword[result]
call h2a_float
print nl,lnl

exit:
mov rax,60
mov rdi,0
syscall

;===========================================Procedures======================================
h2a_float:
	mov byte[cnt],8
	mov ebx,r8d
	floata:
		rol ebx,4
		mov r9d,ebx
		and ebx,0000000FH
		cmp bl,09H
		jbe next2
		add bl,07H
		next2: add bl,30H
		mov byte[var1],bl
		cmp byte[cnt],4
		jne next
		print dot,lendot
		next: print var1,1
		mov ebx,r9d
				
		dec byte[cnt]
		jnz floata
ret 

													;OUTPUT
;chinmay@chinmay-HP-Notebook:~/Documents$ nasm -f elf64 mean.asm
;chinmay@chinmay-HP-Notebook:~/Documents$ ld -o mean mean.o
;chinmay@chinmay-HP-Notebook:~/Documents$ ./mean
;Mean is-: 
;0088.0660 
;Variance is-: 
;1342.4609 
;Standart Deviation is-:  
;0036.6396 

