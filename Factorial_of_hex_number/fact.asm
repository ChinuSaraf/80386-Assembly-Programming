;==============================================
;Name: Chinmay Saraf
;Contact Mail: chinmay.saraf98@gmail.com
;Title: Factorial (upto 0C)
;==============================================

section .data
msg1 : db "Enter your number: "
len1 : equ $-msg1
msg2 : db "Factorial of your number is: "
len2 : equ $-msg2
count: db 00H

section .bss
num : resb 2
cnt: resb 1
var1:resb 1

section .text
global _start
_start:
xor rax,rax
xor rbx,rbx
xor rcx,rcx
xor rdx,rdx

pop rsi
pop rsi
pop rsi
mov ax,word[rsi]
mov word[num],ax

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


mov rsi,num
xor ebx,ebx


cmp byte[rsi],39H
jbe next
sub byte[rsi],07H
next: sub byte[rsi],30H
add bl,byte[rsi]
rol bl,4
inc rsi

cmp byte[rsi],39H
jbe next1
sub byte[rsi],07H
next1: sub byte[rsi],30H
add bl, byte[rsi]

pushing:
	push bx
	inc byte[count]
	dec bx      
	jnz pushing

mov eax,00000001H

popping:
	pop r8w

	mul r8d
	dec byte[count]
	jnz popping

mov byte[count],8
mov ebx,eax

	addr:
		
		rol ebx,4
		mov r10d,ebx
		and ebx,0000000FH
		cmp bl,09H
		jbe next2
		add bl,07H
		next2: add bl,30H
		mov byte[var1],bl
		print var1,2
		mov ebx,r10d
		dec byte[count]
	jnz addr


exit:
	mov rax,60
	mov rdi,0
	syscall



																																										;OUTPUT
;chinmay@chinmay-HP-Notebook:/media/chinmay/New Volume1/study/SE Programs/SE_SEM_2/ML/Assignment_9$ nasm -f elf64 fact.asm
;chinmay@chinmay-HP-Notebook:/media/chinmay/New Volume1/study/SE Programs/SE_SEM_2/ML/Assignment_9$ ld -o fact fact.o
;chinmay@chinmay-HP-Notebook:/media/chinmay/New Volume1/study/SE Programs/SE_SEM_2/ML/Assignment_9$ ./fact 08
;00009D80chinmay@chinmay-HP-Notebook:/media/chinmay/New Volume1/study/SE Programs2/ML/Assignment_9$ ./fact 0C
;1C8CFC00chinmay@chinmay-HP-Notebook:/media/chinmay/New Volume1/study/SE Programs2/ML/Assignment_9$ 

