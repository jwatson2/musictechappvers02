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

/* by declaring gVC as a global variable that has been defined in some other file (extern)
you can now call gVC's public methods from within this file */
extern ViewController* gVC;

@end

@implementation XYView

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
        [gVC sendOSCFloats: 16 :bufX];
        
        [self appendToOSCMsg_Value:bufY :12 :&valY];
        [gVC sendOSCFloats: 16 :bufY];
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