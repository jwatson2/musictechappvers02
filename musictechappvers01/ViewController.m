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
    
    timer = [NSTimer scheduledTimerWithTimeInterval:5.0 target:self selector:@selector(checkMessages:) userInfo:nil repeats:YES];
    
    thread = [[NSThread alloc] initWithTarget:self selector:@selector(receiveUDP) object:nil];
    [thread start]; /* need to call [thread release]; at some point? */
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)checkMessages:(NSTimer*)timer {
    NSLog(@"Checking for Messages");
}

-(void)convertToCString: (NSString *)objCString {
    const char *cString = [objCString cStringUsingEncoding:NSASCIIStringEncoding];
}

-(void)receiveUDP {
    NSLog(@"receiveUDP started");
    
    int sock = socket(PF_INET, SOCK_DGRAM, IPPROTO_UDP);
    struct sockaddr_in sa;
    
    memset(&sa, 0, sizeof(sa));
    sa.sin_family = AF_INET;
    sa.sin_addr.s_addr = INADDR_ANY;
    sa.sin_port = htons(1338); /* hard-coded receive port number */
    
    if (-1 == bind(sock,(struct sockaddr *)&sa, sizeof(struct sockaddr)))
    {
        perror("error bind failed");
        close(sock);
        exit(EXIT_FAILURE);
    }
    
    char InBuffer[1024];
    ssize_t InBufferLength;
    socklen_t fromlen;
    while (true)
    {
        // recvfrom blocks the thread
        InBufferLength = recvfrom(sock, (void *)InBuffer, 1024, 0, (struct sockaddr *)&sa, &fromlen);
        if (InBufferLength < 0)
            fprintf(stderr,"%s\n",strerror(errno));
        
        /* do something with the incoming message here */
        InBuffer[InBufferLength] = '\0';
        NSLog(@"%s %ld",InBuffer,InBufferLength);
        /*NSLog(@"%@", [NSString stringWithCString:InBuffer encoding:NSASCIIStringEncoding]);*/
        self.messageLabel.text = (@"testing");
        /*
         NSLog(@"%@", receiveOSC);
         self.messageLabel.text = receiveOSC;*/
        
        /* need a way to exit this infinite loop */
    }
    
    /* close the socket */
    close(sock);
}

-(void)sendOSC: (NSString *)logMessage :(NSString *)labelMessage :(int)lengthOutBuffer :(NSString *)oscMessage  {
    
    // When faster button is pressed, the message faster is sent to the debug window
    NSLog(@"%@", logMessage);
    
    //Change text of label
    self.messageLabel.text = labelMessage;
    
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
    sa.sin_port = htons(1337);  /* hard-coded send port number */
    
    /* set the OSC message and message length */
    char OutBuffer[1024];
    ssize_t OutBufferLength;
    OutBufferLength = lengthOutBuffer;
    memcpy(OutBuffer,[oscMessage cStringUsingEncoding:NSASCIIStringEncoding],OutBufferLength);
    
    /* send the message */
    ssize_t bytes_sent;
    bytes_sent = sendto(sock, OutBuffer, OutBufferLength, 0,(struct sockaddr*)&sa, sizeof (struct sockaddr_in));
    if (bytes_sent < 0)
        fprintf(stderr,"Error sending packet: %s\n",strerror(errno));
    
    /* close the socket */
    close(sock);
}

- (IBAction)playSound:(UIButton *)sender {
    
    [self sendOSC:@"trigger sound" :@" " :12 :@"/play\0\0\0,\0\0\0"];
}

- (IBAction)sparsePressed:(UIButton *)sender {
    
    [self sendOSC:@"sparse" :@"Sparse has been pressed" :12 :@"/sparse\0,\0\0\0"];
}

- (IBAction)densePressed:(UIButton *)sender {
    
    [self sendOSC:@"dense" :@"Dense has been pressed" :12 :@"/dense\0\0,\0\0\0"];
}

- (IBAction)quieterPressed:(UIButton *)sender {
    
    [self sendOSC:@"quieter" :@"Quieter has been pressed" :16 :@"/quieter\0\0\0\0,\0\0\0"];
}

- (IBAction)louderPressed:(UIButton *)sender {
    
    [self sendOSC:@"louder" :@"Louder has been pressed" :12 :@"/louder\0,\0\0\0"];
}

- (IBAction)slowerPressed:(UIButton *)sender {
    
    [self sendOSC:@"slower" :@"Slower has been pressed" :12 :@"/slower\0,\0\0\0"];
}


- (IBAction)fasterPressed:(UIButton *)sender {
    
    [self sendOSC:@"faster" :@"Faster has been pressed" :12 :@"/faster\0,\0\0\0"];
}

- (IBAction)xyToPlaySounds:(UIPanGestureRecognizer *)recognizer {
    
}


@end