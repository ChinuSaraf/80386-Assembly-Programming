;==========================================================================
;Author Name: Chinmay Saraf
;Title: Number of Positive and Negative numbers in array
;==========================================================================

section .data
arr  : dq 0000000000000000H,4578457845784578H,9965589699655896H,7878787878787878H
cnt  : db 04H
pos  : db 00H
neg  : db 00H
msg1 : db "Count of positive & negative numbers.",0x0A
len1 : equ $-msg1
msg2 : db "Count of positive numbers= "
len2 : equ $-msg2
msg3 : db "Count of negative numbers= "
len3 : equ $-msg3
nl   : db " ",0x0A
lennl: equ $-nl


section .text
global _start
_start:

mov rax,1
mov rdi,1
mov rsi,msg1
mov rdx,len1
syscall

mov rsi,arr
up: 
    bt qword[rsi],63
        jc next
    inc byte[pos]
        jmp step
next:
     inc byte[neg]
step:
     ADD RSI,08H
     dec byte[cnt]
     jnz up

CMP byte[pos],09H
JBE next1
ADD byte[pos],07H
next1: ADD byte[pos],30H

CMP byte[neg],09H
JBE next2
ADD byte[neg],07H
next2: ADD byte[neg],30H

MOV rax,1
MOV rdi,1
MOV rsi,msg2
MOV rdx,len2
SYSCALL

MOV rax,1
MOV rdi,1
MOV rsi,pos
MOV rdx,1
SYSCALL

MOV rax,1
MOV rdi,1
MOV rsi,nl
MOV rdx,lennl
SYSCALL

MOV rax,1
MOV rdi,1
MOV rsi,msg3
MOV rdx,len3
syscall

MOV rax,1
MOV rdi,1
MOV rsi,neg
MOV rdx,1
SYSCALL

MOV rax,1
MOV rdi,1
MOV rsi,nl
MOV rdx,lennl
SYSCALL

MOV rax,60		
MOV rdi,0
SYSCALL

;OUTPUT
;roninx@roninx-Lenovo-ideapad-500-15ISK:~$ nasm -f elf64 assign_1.asm
;roninx@roninx-Lenovo-ideapad-500-15ISK:~$ ld -o assign_1 assign_1.o
;roninx@roninx-Lenovo-ideapad-500-15ISK:~$ ./assign_1
;Count of positive & negative numbers.
;Count of positive numbers= 3 
;Count of negative numbers= 1 
 

