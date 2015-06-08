//
//  XYView.m
//  musictechappvers01
//
//  Created by Jordan Watson on 5/12/15.
//  Copyright (c) 2015 Jordan Watson. All rights reserved.
//

#import "XYView.h"
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

@interface XYView ()

@end

/* by declaring gVC as a global variable that has been defined in some other file (extern)
you can now call gVC's public methods from within this file */
extern ViewController* gVC;

@implementation XYView



-(void)sendOSCFloats: (int)lengthOutBuffer :(const char *)oscMessage
{
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
    memcpy(OutBuffer,oscMessage,OutBufferLength);
    
    /* send the message */
    ssize_t bytes_sent;
    bytes_sent = sendto(sock, OutBuffer, OutBufferLength, 0,(struct sockaddr*)&sa, sizeof (struct sockaddr_in));
    if (bytes_sent < 0)
        fprintf(stderr,"Error sending packet: %s\n",strerror(errno));
    
    /* close the socket */
    close(sock);
    
}

#pragma mark- OSC argument methods

// the following will now work for both int and float
-(void)appendToOSCMsg_Value:(void*)osc_str :(int)osc_str_length :(void*)val
{
    long temp;
    
    // copy the 4-byte value into the union structure
    memcpy(&temp,val,4);
    
    // convert it to the proper Endian format
    temp = htonl(temp);
    
    // append the 4-byte union value to the end of the OSC message
    memcpy(osc_str+osc_str_length,&temp,4);
}

-(void)doTouches:(NSSet *)touches withEvent:(UIEvent *)event
{
    for (UITouch* t in touches)
    {
        NSLog(@"%d",touches.count);
        CGPoint pt = [t locationInView:self];
        Float64 x = pt.x/self.bounds.size.width;
        Float64 y = pt.y/self.bounds.size.height;
        Float64 yInv = (1. - y);
        NSLog(@"%lf,%lf", x, yInv);
        
        
        char bufX[32];
        float valX = x;
        memcpy(bufX,"/soundx\0,f\0\0",12);
        
        char bufY[32];
        float valY = yInv;
        memcpy(bufY,"/soundy\0,f\0\0",12);
        
        [self appendToOSCMsg_Value:bufX :12 :&valX];
        [self sendOSCFloats: 16 :bufX];
        
        [self appendToOSCMsg_Value:bufY :12 :&valY];
        [self sendOSCFloats: 16 :bufY];
    }
}

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [self doTouches:touches withEvent:event];
}

-(void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event
{
    [self doTouches:touches withEvent:event];
}

-(void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
    //[self doTouches:touches withEvent:event];
    [gVC sendOSC:@"sound stop" :@" " :16 :"/soundstop\0\0,\0\0\0"];
}

-(void)touchesCancelled:(NSSet *)touches withEvent:(UIEvent *)event
{
    [self doTouches:touches withEvent:event];
}

@end