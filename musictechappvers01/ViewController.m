//
//  ViewController.m
//  musictechappvers01
//
//  Created by Jordan Watson on 4/5/15.
//  Copyright (c) 2015 Jordan Watson. All rights reserved.
//

#import "ViewController.h"
#include <arpa/inet.h>
#include <fcntl.h>
#include <ifaddrs.h>
#include <netinet/in.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <sys/types.h>
#include <sys/socket.h>
#include <unistd.h>

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    timer = [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(checkMessages:) userInfo:nil repeats:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)checkMessages:(NSTimer*)timer {
    NSLog(@"Checking for Messages");
}

- (IBAction)slowerPressed:(UIButton *)sender {

    // When slower button is pressed, the message slower is sent to the debug window
    NSLog(@"slower");

    /* open the socket */
    int sock;
    sock = socket(PF_INET, SOCK_DGRAM, IPPROTO_UDP);
    if (-1 == sock) /* if socket failed to initialize, exit */
    {
        fprintf(stderr,"Error creating socket: %s\n",strerror(errno));
        exit(EXIT_FAILURE);
    }
    
    /* set the IP address and port */
    struct sockaddr_in sa;
    memset(&sa, 0, sizeof(sa));
    sa.sin_family = AF_INET;
    sa.sin_addr.s_addr = htonl(0x7F000001); /* IP address: 127.0.0.1 */
    sa.sin_port = htons(1337);
    
    /* set the OSC message and message length */
    char OutBuffer[1024];
    ssize_t OutBufferLength;
    OutBufferLength = 12;
    memcpy(OutBuffer,"/slower\0,\0\0\0",OutBufferLength);

    /* send the message */
    ssize_t bytes_sent;
    bytes_sent = sendto(sock, OutBuffer, OutBufferLength, 0,(struct sockaddr*)&sa, sizeof (struct sockaddr_in));
    if (bytes_sent < 0)
        fprintf(stderr,"Error sending packet: %s\n",strerror(errno));

    /* close the socket */
    close(sock);
}


- (IBAction)fasterPressed:(UIButton *)sender {

    // When faster button is pressed, the message faster is sent to the debug window
    NSLog(@"faster");
}

@end




