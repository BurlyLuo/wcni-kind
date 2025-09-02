#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <unistd.h>
#include <arpa/inet.h>
#include <sys/socket.h>
#include <time.h>
#include <getopt.h>

#define MAX_BUF_SIZE 65507  // UDP最大有效载荷

void error_handling(char *message);
void print_usage(char *program_name);

int main(int argc, char *argv[]) {
    int sock;
    struct sockaddr_in serv_addr;
    char *message;
    int str_len;
    int total_size;
    int i;
    int df_flag = 0; // 默认不允许分片
    int opt;
    
    // 解析命令行参数
    while ((opt = getopt(argc, argv, "df")) != -1) {
        switch (opt) {
            case 'd':
                df_flag = 1; // 设置DF标志，禁止分片
                break;
            case 'f':
                df_flag = 0; // 不设置DF标志，允许分片
                break;
            default:
                print_usage(argv[0]);
                exit(EXIT_FAILURE);
        }
    }
    
    // 检查剩余参数数量
    if (argc - optind != 3) {
        print_usage(argv[0]);
        exit(EXIT_FAILURE);
    }
    
    char *ip = argv[optind];
    char *port = argv[optind+1];
    total_size = atoi(argv[optind+2]);
    
    if (total_size > MAX_BUF_SIZE) {
        printf("Error: Size exceeds maximum UDP payload size of %d\n", MAX_BUF_SIZE);
        exit(1);
    }
    
    if (total_size <= 0) {
        printf("Error: Size must be a positive integer\n");
        exit(1);
    }
    
    // 分配和初始化消息缓冲区
    message = (char *)malloc(total_size);
    if (message == NULL) {
        error_handling("malloc() error");
    }
    
    // 填充消息内容（可以是有意义的数据或随机数据）
    srand(time(NULL));
    for (i = 0; i < total_size; i++) {
        message[i] = 'A' + (rand() % 26);  // 填充随机字母
    }
    
    // 创建UDP socket
    sock = socket(PF_INET, SOCK_DGRAM, 0);
    if (sock == -1) {
        error_handling("socket() error");
    }
    
    // 设置DF标志（如果需要）
    if (df_flag) {
        int val = IP_PMTUDISC_DO; // 设置DF标志，禁止分片
        if (setsockopt(sock, IPPROTO_IP, IP_MTU_DISCOVER, &val, sizeof(val)) < 0) {
            perror("setsockopt");
            close(sock);
            free(message);
            exit(EXIT_FAILURE);
        }
        printf("Setting DF flag: Don't Fragment (prohibited)\n");
    } else {
        int val = IP_PMTUDISC_DONT; // 不设置DF标志，允许分片
        if (setsockopt(sock, IPPROTO_IP, IP_MTU_DISCOVER, &val, sizeof(val)) < 0) {
            perror("setsockopt");
            close(sock);
            free(message);
            exit(EXIT_FAILURE);
        }
        printf("Not setting DF flag: Fragmentation allowed\n");
    }
    
    memset(&serv_addr, 0, sizeof(serv_addr));
    serv_addr.sin_family = AF_INET;
    serv_addr.sin_addr.s_addr = inet_addr(ip);
    serv_addr.sin_port = htons(atoi(port));
    
    // 验证IP地址是否有效
    if (serv_addr.sin_addr.s_addr == INADDR_NONE) {
        printf("Error: Invalid IP address: %s\n", ip);
        close(sock);
        free(message);
        exit(1);
    }
    
    // 发送数据
    str_len = sendto(sock, message, total_size, 0, 
                    (struct sockaddr*)&serv_addr, sizeof(serv_addr));
    
    if (str_len == -1) {
        perror("sendto error");
        error_handling("sendto() error");
    } else {
        printf("Sent %d bytes to %s:%s\n", str_len, ip, port);
    }
    
    free(message);
    close(sock);
    return 0;
}

void error_handling(char *message) {
    fputs(message, stderr);
    fputc('\n', stderr);
    exit(1);
}

void print_usage(char *program_name) {
    printf("Usage: %s [-d] [-f] <IP> <port> <size>\n", program_name);
    printf("Options:\n");
    printf("  -d    Set DF flag (Don't Fragment)\n");
    printf("  -f    Allow fragmentation (default)\n");
    printf("Example:\n");
    printf("  %s -d 192.168.1.100 8080 1500  # Don't Fragment\n", program_name);
    printf("  %s -f 192.168.1.100 8080 1500  # Allow fragmentation\n", program_name);
    printf("  %s 192.168.1.100 8080 1500     # Allow fragmentation (default)\n", program_name);
}
