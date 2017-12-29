;============================================================
;Author: Sangat Das
;Contact Mail: sangatdas5@gmail.com
;Title: Displaying system descriptor registers (LDTR, GDTR, TR, IDTR, MSW)
;=============================================================

section .data
msg1: db "Mode of Operation:-"
      db "Protected Mode!!", 10
len1: equ $-msg1
msg2: db "Mode of Operation:-"
      db "Real Mode!!",10
len2: equ $-msg2
nl: db " ",10
lnl: equ $-nl

msg4: db "Value of MSW-:",10
len4: equ $-msg4
msg5: db "Value of GDTR-:",10
len5: equ $-msg5
msg6: db "Value of LDTR-:",10
len6: equ $-msg6
msg7: db "Value of IDTR-:",10
len7: equ $-msg7
msg8: db "Value of TR-:",10
len8: equ $-msg8

section .bss
var1: resb 1
count: resb 1
temp: resb 6

%macro print 2
mov rax,1
mov rdi,1
mov rsi,%1
mov rdx,%2
syscall
%endmacro

section .text
global _start
_start:
;==================Checking Mode==============
smsw ax
bt ax,0
jc down
print msg2,len2
jmp disp
down: print msg1,len1
print msg4,len4
disp:call display_16bit
print nl,lnl

;==============Diplaying GDTR==========
print msg5,len5
sgdt [temp]
call display_48bit
print nl,lnl

;================Displaying LDTR==========
print msg6,len6
sldt ax
call display_16bit
print nl,lnl

;================Displaying IDTR==========
print msg7,len7
sidt [temp]
call display_48bit
print nl,lnl

;===============Displaying TR===========
print msg8,len8
str ax
call display_16bit
print nl,lnl

exit:
mov rax,60
mov rdi,0
syscall


display_48bit:
		mov byte[count],12
		mov rbx,[temp]
		rol rbx,16
	addr_48:
		rol rbx,4
		mov r10,rbx
		and rbx,000000000000000FH
		cmp bl,09H
		jbe next2
		add bl,07H
		next2: add bl,30H
		mov byte[var1],bl
		print var1,1
		mov rbx,r10
		dec byte[count]
		jnz addr_48
ret

display_16bit:
		mov byte[count],4
		mov bx,ax
		
	addr_16:
		rol bx,4
		mov r10w,bx
		and bx,000FH
		cmp bl,09H
		jbe next3
		add bl,07H
		next3: add bl,30H
		mov byte[var1],bl
		print var1,1
		mov bx,r10w
		dec byte[count]
		jnz addr_16
ret

											;OUTPUT
;chinmay@chinmay-HP-Notebook:~/Downloads$ nasm -f elf64 mode.asm
;chinmay@chinmay-HP-Notebook:~/Downloads$ ld -o mode mode.o
;chinmay@chinmay-HP-Notebook:~/Downloads$ ./mode
;Mode of Operation:-Protected Mode!!
;Value of MSW-:
;000F 
;Value of GDTR-:
;82489000007F 
;Value of LDTR-:
;0000 
;Value of IDTR-:
;FF5780000FFF 
;Value of TR-:
;0040 

