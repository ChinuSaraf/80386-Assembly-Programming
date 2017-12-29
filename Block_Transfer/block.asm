;============================================================
;Author Name:Chinmay Saraf
;Contact Mail: chinmay.saraf98@gmail.com
;Title: Block Transfer
;============================================================

section .data
	msg0    db "=============================",10
db " MENU      ",10
db "=============================",10
db " 1]. nonoverlap without string",10
db " 2]. overlap without string",10
db " 3]. nonoverlap with string",10
db " 4]. overlap with string",10
db " 5]. Exit",10
db "Enter your choice",10
    len0:equ     $-msg0
	msg1 db 10,"Source block contents are "
	len1 equ $-msg1
	msg2 db 10,"Destination block contents are "
	len2 equ $-msg2
	nl db "",10
    nll equ $-nl
    m db " : "
    ml equ $-m
    source :db "Source array:"
    lens :equ $-source
    destin :db "Destination array:" 
    lend :equ $-destin
    combo :db "Combined array:"
    lenc :equ $-combo
    array : db 0x1C,0x22,0xAB,0x45,0x3A
    array2: db 0x00,0x00,0x00,0x00,0x00
    cnt : db 16
    count:db 5
section .bss
	var1  : resb 2
	opt   : resb 2
	
	
%macro print 2
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

section .text
global _start:
_start:


menu:
print msg0,len0
read  opt ,2


cmp byte[opt],31H
je case1
cmp byte[opt],32H
je case2
cmp byte[opt],33H
je case3
cmp byte[opt],34H
je case4
cmp byte[opt],35H
je exit

case1:
;========================Source array Display==================
	print source,lens			
	print nl,nll
	print nl,nll 
	print nl,nll 
	mov byte[count],05H
	mov r8,array
	call array_display
	 
;==================Copy fron array to array2===================
	mov byte[count],05H
	mov r8,array
	mov r9,array2
	call copy_array
	
;=====================Destination array Display================
	print destin,lend
	print nl,nll 
	print nl,nll 
	print nl,nll 
	mov byte[count],05H
	mov r8,array2
	call array_display
	 
;==================Combo Array Display=========================
	print combo,lenc
	print nl,nll 
	print nl,nll 
	print nl,nll 
	mov byte[count],05H
	mov r8,array
	call array_display
	mov byte[count],05H
	mov r8,array2
	call array_display
jmp menu
	
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
case2:

;========================Source array Display==================
	print source,lens			
	print nl,nll
	print nl,nll 
	print nl,nll 
	mov byte[count],05H
	mov r8,array
	call array_display
	

;==================Copy from array to array2===================
	mov byte[count],05H
	mov r8,array
	mov r9,array2
	call copy_array
	 

;=====================Destination array Display================
	print destin,lend			
	print nl,nll
	print nl,nll 
	print nl,nll 
	mov byte[count],05H
	mov r8,array2
	call array_display
	
;==================Copy from array2 to array+2===================
	mov r9,array
	add r9,2
	mov r8,array2
	mov byte[count],05H
	call copy_array
	
;==================Combo array Display======================
	 print combo,lenc
	 print nl,nll
	 print nl,nll 
	 print nl,nll  
	 mov byte[count],07H
	mov r8,array
	call array_display
	
jmp menu
	
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;	
case3:
;========================Source array Display==================
	print source,lens			
	print nl,nll
	print nl,nll 
	print nl,nll 
	mov byte[count],05H
	mov r8,array
	call array_display
	
;==================Copy from array to array2===================
	mov rcx,05H
	mov rsi,array
	mov rdi,array2
	rep movsb
	
;=====================Destination array Display================
	print destin,lend
	print nl,nll 
	print nl,nll 
	print nl,nll 
	mov byte[count],05H
	mov r8,array2
	call array_display
	 
;==================Combo array Display======================
	print combo,lenc
	print nl,nll 
	print nl,nll 
	print nl,nll 
	mov byte[count],05H
	mov r8,array
	call array_display
	mov byte[count],05H
	mov r8,array2
	call array_display
 
	jmp menu
	
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;	
case4:
;========================Source array Display==================
	print source,lens			
	print nl,nll
	print nl,nll 
	print nl,nll 
	mov byte[count],05H
	mov r8,array
	call array_display
	
;==================Copy from array to array2===================
	mov rcx,05H
	mov rsi,array
	mov rdi,array2
	rep movsb

;=====================Destination array Display================
	print destin,lend			
	print nl,nll
	print nl,nll 
	print nl,nll 
	mov byte[count],05H
	mov r8,array2
	call array_display
	
;==================Copy from array2 to array+2===================
	mov rcx,05H
	mov rsi,array2
	mov rdi,array+2
	rep movsb
	
;==================Combo array Display======================	
	 print combo,lenc
	 print nl,nll
	 print nl,nll 
	 print nl,nll  
	 mov byte[count],07H
	mov r8,array
	call array_display
	jmp menu

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
exit:
	mov rax,60
	mov rsi,0
	syscall

;===================================Procedures=====================
h2a_word:
	mov byte[cnt],2
	byt:
		rol bl,4
		mov r9b,bl
		and bl,0FH
		cmp bl,09H
		jbe next1
		add bl,07H
		next1: add bl,30H
		mov byte[var1],bl
		print var1,1
		mov bl,r9b
		dec byte[cnt]
		jnz byt
ret

h2a_addr:
	mov byte[cnt],16
	mov rbx,r8
	addr:
		
		rol rbx,4
		mov r9,rbx
		and rbx,000000000000000FH
		cmp bl,09H
		jbe next2
		add bl,07H
		next2: add bl,30H
		mov byte[var1],bl
		print var1,1
		mov rbx,r9
		dec byte[cnt]
		jnz addr
ret

array_display:
	arr:
	 call h2a_addr
	print nl,nll
	 mov bl,byte[r8]
	 call h2a_word
	print nl,nll
	 xor bx,bx
	 inc r8
	 dec byte[count]
   jnz arr
ret

copy_array:
	copy:
	mov cl,byte[r8]
	mov byte[r9],cl
	inc r8
	inc r9
	dec byte[count]
	jnz copy 
ret

;OUTPUT
;roninx@roninx-Lenovo-ideapad-500-15ISK:~/Downloads$ nasm -f elf64 block.asm
;roninx@roninx-Lenovo-ideapad-500-15ISK:~/Downloads$ ld -o block block.o
;roninx@roninx-Lenovo-ideapad-500-15ISK:~/Downloads$ ./block
;=============================
; MENU      
;=============================
; 1]. nonoverlap without string
; 2]. overlap without string
; 3]. nonoverlap with string
; 4]. overlap with string
; 5]. Exit
;Enter your choice
;1
;Source array:
;

;0000000000600EED
;1C
;0000000000600EEE
;22
;0000000000600EEF
;AB
;0000000000600EF0
;45
;0000000000600EF1
;3A
;Destination array:
;

;0000000000600EF2
;1C
;0000000000600EF3
;22
;0000000000600EF4
;AB
;0000000000600EF5
;45
;0000000000600EF6
;3A
;Combined array:
;

;0000000000600EED
;1C
;0000000000600EEE
;22
;0000000000600EEF
;AB
;0000000000600EF0
;45
;0000000000600EF1
;3A
;0000000000600EF2
;1C
;0000000000600EF3
;22
;0000000000600EF4
;AB
;0000000000600EF5
;45
;0000000000600EF6
;3A
;=============================
; MENU      
;=============================
; 1]. nonoverlap without string
; 2]. overlap without string
; 3]. nonoverlap with string
; 4]. overlap with string
; 5]. Exit
;Enter your choice
;2
;Source array:
;

;0000000000600EED
;1C
;0000000000600EEE
;22
;0000000000600EEF
;AB
;0000000000600EF0
;45
;0000000000600EF1
;3A
;Destination array:
;

;0000000000600EEF
;1C
;0000000000600EF0
;22
;0000000000600EF1
;AB
;0000000000600EF2
;45
;0000000000600EF3
;3A
;Combined array:


;0000000000600EED
;1C
;0000000000600EEE
;22
;0000000000600EEF
;1C
;0000000000600EF0
;22
;0000000000600EF1
;AB
;0000000000600EF2
;45
;0000000000600EF3
;3A
;=============================
; MENU      
;=============================
; 1]. nonoverlap without string
; 2]. overlap without string
; 3]. nonoverlap with string
; 4]. overlap with string
; 5]. Exit
;Enter your choice
;3
;Source array:


;0000000000600EED
;1C
;0000000000600EEE
;22
;0000000000600EEF
;1C
;0000000000600EF0
;22
;0000000000600EF1
;AB
;Destination array:
;

;0000000000600EF2
;1C
;0000000000600EF3
;22
;0000000000600EF4
;1C
;0000000000600EF5
;22
;0000000000600EF6
;AB
;Combined array:
;

;0000000000600EED
;1C
;0000000000600EEE
;22
;0000000000600EEF
;1C
;0000000000600EF0
;22
;0000000000600EF1
;AB
;0000000000600EF2
;1C
;0000000000600EF3
;22
;0000000000600EF4
;1C
;0000000000600EF5
;22
;0000000000600EF6
;AB
;=============================
; MENU      
;=============================
; 1]. nonoverlap without string
; 2]. overlap without string
; 3]. nonoverlap with string
; 4]. overlap with string
; 5]. Exit
;Enter your choice
;4
;Source array:
;

;0000000000600EED
;1C
;0000000000600EEE
;22
;0000000000600EEF
;1C
;0000000000600EF0
;22
;0000000000600EF1
;AB
;Destination array:


;0000000000600EEF
;1C
;0000000000600EF0
;22
;0000000000600EF1
;1C
;0000000000600EF2
;22
;0000000000600EF3
;AB
;Combined array:


;0000000000600EED
;1C
;0000000000600EEE
;22
;0000000000600EEF
;1C
;0000000000600EF0
;22
;0000000000600EF1
;1C
;0000000000600EF2
;22
;0000000000600EF3
;AB
;=============================
; MENU      
;=============================
; 1]. nonoverlap without string
; 2]. overlap without string
; 3]. nonoverlap with string
; 4]. overlap with string
; 5]. Exit
;Enter your choice
;5
	
