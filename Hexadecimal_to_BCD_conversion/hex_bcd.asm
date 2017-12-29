;============================================================
;Author: Sangat Das
;Contact Mail: sangatdas5@gmail.com
;Title: Conversion of Hex number to BCD number
;============================================================

section .data
	msg1 : db "Enter Hexadecimal number: ",10
	len1 : equ $- msg1
	msg2 : db "Enter BCD number: ",10
	len2 : equ $- msg2
	msg3 : db "Enter option number: ",10
	len3 : equ $- msg3
	msg4 : db "1.Hexadecimal to BCD: ",10
	len4 : equ $- msg4
	msg5 : db "2 .BCD to Hexadecimal ",10
	len5 : equ $- msg5
	msg6 : db "3. Exit ",10
	len6 : equ $- msg6
	msg7 : db "BCD number is:",10
	len7 : equ $- msg7
	msg8 : db "Hexadecimal number is:",10
	len8 : equ $- msg8
	nl: db " ",10
    lnl: equ $-nl
	    x: dw 10000

section .bss
	opt : resb 2
	num1 :resb 5
	num2 :resb 6
	result: resb 4
	cnt: resb 1
	
section .text
    global _start
      _start:

	%macro print 2							;Print macro creation
	mov rax,1
	mov rdi,1
	mov rsi,%1
	mov rdx,%2
	syscall
	%endmacro

	%macro accept 2							;Read macro creation
	mov rax,0
	mov rdi,0
	mov rsi,%1
	mov rdx,%2
	syscall
	%endmacro
	
	menu:
	print nl,lnl
	print msg4,len4							;Calling print macro
	print msg5,len5
	print msg6,len6
	print msg3,len3
	
	accept opt,2								;Calling read macro
	
	cmp byte[opt],31H
	je case_1
	cmp byte[opt],32H
	je case_2
	cmp byte[opt],33H
	je case_3
	
	case_1:
		call accept_no	
		
		mov ax,bx
		mov rbx,10
		mov byte[cnt],00H
		
	    loop1:
	    xor rdx,rdx
		div rbx
		push dx
		inc byte[cnt]
		cmp rax,0H
		jne loop1
		
	  display:
	  
		pop dx
		add dl,30H
		mov byte[result],dl
		
		print result,1
		dec byte[cnt]
		jnz display
		jmp menu
		
accept_no:
	
	accept num1,5
		
	mov rsi,num1
	xor bx,bx							;making bx NULL
	mov rcx,4
	
   convert:
   
	rol bx,4							;Rotate bx in left direction by 4 bits
	mov al, byte[rsi]
	cmp al, 39H
	jbe nxt
	sub al,07H
	nxt:sub al,30H
	
    	
	add bx,ax
	inc rsi
	loop convert
	
ret

	 case_2:
	  	
	  										;r8,r9,....,r15 are extra registers
	  	accept num2,6
	  	
	  	mov rcx,5
	  	xor rbx,rbx
	  	mov rsi,num2
	  	call bcd_hex
	  	
	  
	  mov r10,result	
	  mov r9w,bx
	  mov byte[cnt],4
	  
	  beg:
	  rol r9w,4
	  mov r8w,r9w
	  and r8b,0x0F
	  cmp r8b,9
	  jbe l1
	  add r8b,07h
	  l1:
	  add r8b,30h
	  mov byte[r10],r8b	
	  inc r10 
	  dec byte[cnt]
	  jnz beg
	  print result,4
	  	 
	  jmp menu	
	   
	  	
	  	
	   bcd_hex:
	   	
	        sub byte[rsi],30H
	        mov ax,0
	        mov al,byte[rsi]
	      
	   	mul word[x]
	   	
	   	add ebx,eax  					;converting BCD to HEX
	   	
	   	xor edx,edx
	   	
	   	mov ax,word[x]
	   	mov r8w,000AH
	   	div r8w
	   	
	   	xor edx,edx
	   	
	   	mov word[x],ax
	  
	   	inc rsi
	   	dec cl
	   	jnz bcd_hex
	   	
	  ret
	  
	
	  
	case_3:
	  	mov rax,60
	  	mov rdi,0
	  	syscall
	
								;OUTPUT
;chinmay@chinmay-HP-Notebook:~/Downloads$ nasm -f elf64 hex_bcd.asm
;chinmay@chinmay-HP-Notebook:~/Downloads$ ld -o hex_bcd hex_bcd.o
;chinmay@chinmay-HP-Notebook:~/Downloads$ ./hex_bcd
 
;1.Hexadecimal to BCD: 
;2 .BCD to Hexadecimal 
;3. Exit 
;Enter option number: 
;1
;FFFF
;65535 
;1.Hexadecimal to BCD: 
;2 .BCD to Hexadecimal 
;3. Exit 
;Enter option number: 
;2
;65535
;FFFF 
;1.Hexadecimal to BCD: 
;2 .BCD to Hexadecimal 
;3. Exit 
;Enter option number: 
;3
	
