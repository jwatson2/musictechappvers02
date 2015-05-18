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

- (void)udpParse: (const char*) udpInBuffer :(ssize_t) udpInBufferSize
{
    ssize_t pos = 0;
    int osc_msg_element_id = 0;
    int osc_add_id = 0;
    
    while (pos < udpInBufferSize)
    {
        switch (osc_msg_element_id)
        {
            case 0:
            {
                /* this case is for OSC address string */
                
                /* the following example code should work, but I haven't tested it */
                /* there is a better solution, but for now let's use this */
                if (strcmp(udpInBuffer,"/message_1")==0) osc_add_id = 1;
                else if (strcmp(udpInBuffer,"/message_2")==0) osc_add_id = 2;
                else if (strcmp(udpInBuffer,"/message_3")==0) osc_add_id = 3;
                /* etc. */
                
                osc_msg_element_id = 1; /* for the next OSC message component: i.e., type tag string */
                break;
            }
            case 1:
            {
                /* this case is for OSC type tag string */
                /* this example code assumes only one argument so we won't do anything here */

                osc_msg_element_id = 2; /* for the next OSC message component: i.e., arguments */
                break;
            }
            case 2:
            {
                /* this case is for OSC arguments; for now it only supports one argument */
                switch (osc_add_id)
                {
                    case 1:
                    {
                        /* do something here if the OSC address ID is 1 */

                        NSLog(@"%@", [NSString stringWithCString:udpInBuffer+pos encoding:NSASCIIStringEncoding]);
                        [self changeMessageLabel: @"Going Slower"];

                        break;
                    }
                    case 2:
                    {
                        /* do something here if the OSC address ID is 2 */

                        NSLog(@"%@", [NSString stringWithCString:udpInBuffer+pos encoding:NSASCIIStringEncoding]);
                        [self changeMessageLabel: @"Going Faster"];

                        break;
                    }
                    case 3:
                    {
                        /* do something here if the OSC address ID is 3 */
                        NSLog(@"%@", [NSString stringWithCString:udpInBuffer+pos encoding:NSASCIIStringEncoding]);
                        [self changeMessageLabel: @"Play A Sound"];
                        break;
                    }
                    /* etc. */

                    default:
                        break;
                }
            }
            default:
                break;
        }
        
        pos += ((strlen(udpInBuffer+pos) / 4) + 1) * 4;
    }
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
        
        /* do something with the incoming message here, i.e. call udpParse */
        InBuffer[InBufferLength] = '\0';
        //NSLog(@"%s %ld",InBuffer,InBufferLength);
        [self udpParse:InBuffer :InBufferLength];
        //self.messageLabel.text = (@"testing");
        
        /* need a way to exit this infinite loop */
    }
    
    /* close the socket */
    close(sock);
}

-(void)changeMessageLabel: (NSString *)message {
    self.messageLabel.text = message;
}

-(void)sendOSC: (NSString *)logMessage :(NSString *)labelMessage :(int)lengthOutBuffer :(NSString *)oscMessage  {
    
    // When faster button is pressed, the message faster is sent to the debug window
    NSLog(@"%@", logMessage);
    
    //Change text of label
    [self changeMessageLabel: labelMessage];
    
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



@end
