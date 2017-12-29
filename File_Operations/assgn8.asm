;=======================================================================================================================
;Author: Sangat Das
;Contact Mail: sangatdas5@gmail.com
;Title: File Operations (Copy, Write, Delete)
;=======================================================================================================================


%macro  print 2
	mov rax,1
	mov rdi,1
	mov rsi,%1
	mov rdx,%2
	syscall
%endmacro

%macro read 2
	mov rax,0
	mov rdi,0
	mov rsi,%1
	mov rdx,%2
	syscall
%endmacro

%macro fileopen 2	
	mov rax,2
	mov rdi,%1
	mov rsi,%2
	mov rdx,0777
	syscall
	mov qword[temp],rax
%endmacro

%macro readf 3
	mov rax,0
	mov rdi,%1
	mov rsi,%2
	mov rdx,%3
	syscall
%endmacro

%macro writef 3
	mov rax,1
	mov rdi,%1
	mov rsi,%2
	mov rdx,%3
	syscall
%endmacro

%macro closef 1
	mov rax,3
	mov rsi,%1
	syscall
%endmacro

section .data
msg0 :  db "=============================",10
	db " MENU      ",10
	db "=============================",10
	db " 1]. Type",10
	db " 2]. Copy",10
	db " 3]. Delete",10
	db " 4]. Exit",10
	db "Enter your choice",10
len0 :	equ $-msg0
msg2 :  db "Successful opening of file",10
len2 :  equ $-msg2
msg3 :  db "Unsuccessful opening of file",10
len3 :  equ $-msg3
msg4 :  db "Enter text",10
len4 :  equ $-msg4
cnt: dq 00H
buffer : times 100 db ' '



section .bss
fname  : resb 8
fname1 : resb 8
fname2 : resb 8
fd_in  : resb 8
fd_in1 : resb 8
temp   : resq 1
message : resb 200
inst : resb 2

section .text
global _start
_start:
pop r8
pop r8
pop r8

mov al, byte[r8]
mov byte[inst],al

cmp al,54H
je accept_type

cmp al,43H
je accept_copy

cmp al,44H
je accept_delete

accept_type:
pop r8
mov rax,qword[r8]
mov qword[fname],rax
jmp menu

accept_copy:
pop r8
mov rax,qword[r8]
mov qword[fname],rax

pop r8
mov rax,qword[r8]
mov qword[fname1],rax

jmp menu

accept_delete:
pop r8
mov rax,qword[r8]
mov qword[fname2],rax
jmp menu


menu:
;========================First file Opening=====================


 	fileopen fname,1		;write mode opening
	mov rax,qword[temp]
 	mov qword[fd_in],rax
	bt qword[fd_in],63
	jc next_type
	print msg2,len2
	jmp open_2
	next_type: print msg3,len3

	

  
;========================Second file Opening=====================

open_2:	fileopen fname1,1			;write mode opening
 	mov rax,qword[temp]
 	mov qword[fd_in1],rax
	bt qword[fd_in1],63
	jc next_copy
	print msg2,len2
	jmp menu1
	next_copy: print msg3,len3

menu1:
cmp byte[inst],54H
je case_1

cmp byte[inst],43H
je case_2

cmp byte[inst],44H
je case_3

case_1:
	print msg4,len4
	read message,100
	
	 mov qword[cnt],00H
	 mov rsi,message
	 
	 counting:
	 inc qword[cnt]
	 inc rsi
	 cmp byte[rsi],00H
	 jne counting
	 
	 dec qword[cnt]
	
	writef [fd_in],message,qword[cnt]
	closef [fd_in]
	
 	fileopen fname,0
	mov rax,qword[temp]
 	mov qword[fd_in],rax
 	
 	readf [fd_in],buffer,qword[cnt]
 	closef [fd_in]
 	
	print buffer,qword[cnt]
 	jmp case_4
 	
case_2:
	fileopen fname,0
	mov rax,qword[temp]
 	mov qword[fd_in],rax
 	
	readf [fd_in],buffer,100
	
	writef [fd_in1],buffer,100
	 	
	closef [fd_in]
	closef [fd_in1]
	
	jmp case_4
	
case_3:
	mov rax,87
	mov rdi,fname2
	syscall
	jmp case_4
	
case_4:
	mov rax,60
	mov rdi,0
	syscall	
	


							;OUTPUT
;chinmay@chinmay-HP-Notebook:~/Downloads$ nasm -f elf64 assgn8.asm
;chinmay@chinmay-HP-Notebook:~/Downloads$ ld -o assgn8 assgn8.o
;chinmay@chinmay-HP-Notebook:~/Downloads$ ./assgn8 Type file.txt
;Successful opening of file
;Unsuccessful opening of file
;Enter text
;chinmay is PICT student.
;chinmay is PICT student.
;chinmay@chinmay-HP-Notebook:~/Downloads$ ./assgn8 Copy file.txt file1.txt
;Successful opening of file
;Successful opening of file
;chinmay@chinmay-HP-Notebook:~/Downloads$ ./assgn8 Delete file2.txt
;Unsuccessful opening of file
;Unsuccessful opening of file

