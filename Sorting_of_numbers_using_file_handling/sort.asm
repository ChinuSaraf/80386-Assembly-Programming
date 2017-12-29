;=====================================================
;Name: Chinmay Saraf
Contact Mail: chinmay.saraf98@gmail.com
;Title: Bubble Sort using File Handling (2 digit data)
;=====================================================
section .data
msg: db "Sorted array is-: ",10
len: equ $-msg
nl: db"  ",10
lnl: equ $-nl
array: db 00H, 00H, 00H, 00H, 00H
cnt: db 05H
fname:  db 'data.txt',0
msg2 :  db "Successful opening of file",10
len2 :  equ $-msg2
msg3 :  db "Unsuccessful opening of file",10
len3 :  equ $-msg3
buffer : times 1000 db ' '
section .bss
i: resb 1
j: resb 1
temp: resb 1
fd_in  : resb 9

%macro  print 2
	mov rax,1
	mov rdi,1
	mov rsi,%1
	mov rdx,%2
	syscall
%endmacro

section .text
global_start:
_start:
;====================File opening================
	mov rax,2
	mov rdi,fname
	mov rsi,2
	mov rdx,0777
	syscall
	
 	
 	mov qword[fd_in],rax
	bt qword[fd_in],63
	jc next_type
	print msg2,len2
	jmp down
	next_type: print msg3,len3

down:
	 mov rax,0
     mov rdi,[fd_in]
     mov rsi,buffer
	 mov rdx,200
     syscall

;=======================Storing data from buffer to array=================
mov r8,buffer
mov rsi,array

mov byte[cnt],05H
store:	
xor rbx,rbx																				;Storing in array
call bcd_hex
mov byte[rsi],bl
inc r8
inc r8																				;Ignoring " , "
inc rsi
dec byte[cnt]
jnz store

;==================Sorting======================
mov  byte[cnt],04H
	mov al,byte[cnt]
	mov byte[i],al

	outer_loop:
	mov al,byte[cnt]
	mov byte[j],al
	mov rsi,array
		inner_loop:
			mov al,byte[rsi]
			mov bl,byte[rsi+1]
			cmp  ax,bx
			jbe after_swap
			mov byte[rsi],bl
			mov byte[rsi+1],al
		after_swap:inc rsi
		dec byte[j]
		jnz inner_loop
	dec byte[i]
	jnz outer_loop


;=================Reopening file================
   
;========================Writing message in file================
  mov rax,1
  mov rdi,[fd_in]
   mov rsi,nl
   mov rdx,lnl
   syscall

  mov rax,1
  mov rdi,[fd_in]
   mov rsi,msg
   mov rdx,len
   syscall

mov rax,1
  mov rdi,[fd_in]
   mov rsi,nl
   mov rdx,lnl
   syscall

;==========================Display Sorted Array===============
print msg,len
mov byte[cnt],05H
mov r8,array

display:
mov bl,byte[r8]
mov bh,bl

rol bl,4
and bl,0x0F
cmp bl,09H
jbe addi
add bl,07H
addi : add bl,30H

mov byte[temp],bl
print temp,1
call write_file											;Writing elements in array

mov bl,bh
and bl,0x0F
cmp bl,09H
jbe addi1
add bl, 07H
addi1: add bl,30H

mov byte[temp],bl
print temp,1
print nl,lnl
inc r8

call write_file											;Writing elements in array
mov byte[temp],0x2C							;Writing "," in file
call write_file
dec byte[cnt]
jnz display

;====================Closing file==================
    mov rax,3			;Closing file
	mov rdi,[fd_in]
	syscall	
;================Exiting================
exit:
mov rax,60
mov rsi,0
syscall


write_file:
	mov rax,1
     mov rdi,[fd_in]
     mov rsi,temp
	 mov rdx,1
     syscall
ret

bcd_hex:																							;BCD to HEX conversion
	mov al, byte[r8]
	cmp al, 39H
	jbe nxt
	sub al,07H
	nxt:sub al,30H
	add bl,al
	rol bl,4
	inc r8
	mov al, byte[r8]
	cmp al, 39H
	jbe nxt1
	sub al,07H
	nxt1:sub al,30H
	add bl,al
ret

															;OUTPUT
;chinmay@chinmay-HP-Notebook:~/Downloads$ nasm -f elf64 sort.asm
;chinmay@chinmay-HP-Notebook:~/Downloads$ ld -o sort sort.o
;chinmay@chinmay-HP-Notebook:~/Downloads$ ./sort
;Successful opening of file
;Sorted array is-: 
;0B  
;0C  
;0D  
;0E  
;0F  

