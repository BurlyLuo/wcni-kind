#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <unistd.h>
#include <arpa/inet.h>
#include <sys/socket.h>
#include <time.h>
#include <getopt.h>

#define BUF_SIZE 65507  // UDP最大有效载荷

void error_handling(char *message);
void print_usage(char *program_name);

int main(int argc, char *argv[]) {
    int serv_sock;
    struct sockaddr_in serv_addr, clnt_addr;
    socklen_t clnt_addr_size;
    char buffer[BUF_SIZE];
    int str_len;
    int i;
    int opt;
    char *bind_ip = NULL;
    int bind_port = 0;
    
    // 解析命令行参数
    while ((opt = getopt(argc, argv, "h")) != -1) {
        switch (opt) {
            case 'h':
                print_usage(argv[0]);
                exit(EXIT_SUCCESS);
            default:
                print_usage(argv[0]);
                exit(EXIT_FAILURE);
        }
    }
    
    // 检查参数数量
    if (argc - optind < 1 || argc - optind > 2) {
        print_usage(argv[0]);
        exit(EXIT_FAILURE);
    }
    
    // 解析IP和端口
    if (argc - optind == 2) {
        bind_ip = argv[optind];
        bind_port = atoi(argv[optind+1]);
    } else {
        bind_ip = "0.0.0.0"; // 默认绑定所有接口
        bind_port = atoi(argv[optind]);
    }
    
    // 创建UDP socket
    serv_sock = socket(PF_INET, SOCK_DGRAM, 0);
    if (serv_sock == -1) {
        error_handling("socket() error");
    }
    
    // 设置SO_REUSEADDR选项，以便快速重启
    int reuse = 1;
    if (setsockopt(serv_sock, SOL_SOCKET, SO_REUSEADDR, &reuse, sizeof(reuse)) < 0) {
        perror("setsockopt");
        close(serv_sock);
        exit(EXIT_FAILURE);
    }
    
    memset(&serv_addr, 0, sizeof(serv_addr));
    serv_addr.sin_family = AF_INET;
    
    // 设置绑定地址
    if (strcmp(bind_ip, "0.0.0.0") == 0) {
        serv_addr.sin_addr.s_addr = htonl(INADDR_ANY); // 绑定所有接口
    } else {
        serv_addr.sin_addr.s_addr = inet_addr(bind_ip); // 绑定指定IP
        if (serv_addr.sin_addr.s_addr == INADDR_NONE) {
            printf("Error: Invalid IP address: %s\n", bind_ip);
            close(serv_sock);
            exit(EXIT_FAILURE);
        }
    }
    
    serv_addr.sin_port = htons(bind_port);
    
    // 绑定socket
    if (bind(serv_sock, (struct sockaddr*)&serv_addr, sizeof(serv_addr)) == -1) {
        perror("bind error");
        error_handling("bind() error");
    }
    
    printf("UDP receiver listening on %s:%d...\n", 
           (strcmp(bind_ip, "0.0.0.0") == 0) ? "all interfaces" : bind_ip, 
           bind_port);
    
    while (1) {
        clnt_addr_size = sizeof(clnt_addr);
        // 接收数据
        str_len = recvfrom(serv_sock, buffer, BUF_SIZE, 0, 
                          (struct sockaddr*)&clnt_addr, &clnt_addr_size);
        
        if (str_len == -1) {
            perror("recvfrom error");
            continue; // 继续等待下一个数据包
        }
        
        // 获取当前时间
        time_t now = time(NULL);
        struct tm *tm_info = localtime(&now);
        char time_buf[20];
        strftime(time_buf, 20, "%Y-%m-%d %H:%M:%S", tm_info);
        
        // 打印接收信息
        printf("[%s] Received %d bytes from %s:%d\n", 
               time_buf,
               str_len, 
               inet_ntoa(clnt_addr.sin_addr), 
               ntohs(clnt_addr.sin_port));
        
        // 打印数据包内容（前50个字节）
        int print_len = str_len < 50 ? str_len : 50;
        printf("First %d bytes: ", print_len);
        for (i = 0; i < print_len; i++) {
            if (buffer[i] >= 32 && buffer[i] <= 126) { // 可打印ASCII字符
                printf("%c", buffer[i]);
            } else {
                printf("."); // 非打印字符用点表示
            }
        }
        printf("\n");
        
        // 计算校验和（简单的字节和）
        unsigned int checksum = 0;
        for (i = 0; i < str_len; i++) {
            checksum += (unsigned char)buffer[i];
        }
        printf("Checksum: 0x%04X\n\n", checksum & 0xFFFF);
    }
    
    close(serv_sock);
    return 0;
}

void error_handling(char *message) {
    fputs(message, stderr);
    fputc('\n', stderr);
    exit(1);
}

void print_usage(char *program_name) {
    printf("Usage: %s [<IP>] <port>\n", program_name);
    printf("  If only port is provided, binds to all interfaces (0.0.0.0)\n");
    printf("  If both IP and port are provided, binds to the specified IP\n");
    printf("Examples:\n");
    printf("  %s 8080                # Listen on all interfaces, port 8080\n", program_name);
    printf("  %s 192.168.1.100 8080  # Listen on 192.168.1.100, port 8080\n", program_name);
    printf("Options:\n");
    printf("  -h     Show this help message\n");
}
