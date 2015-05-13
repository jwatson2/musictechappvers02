//
//  XYView.m
//  musictechappvers01
//
//  Created by Jordan Watson on 5/12/15.
//  Copyright (c) 2015 Jordan Watson. All rights reserved.
//

#import "XYView.h"
#import "ViewController.h"

@implementation XYView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/



-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    for (UITouch* t in touches)
    {
        CGPoint pt = [t locationInView:self];
        Float64 x = pt.x/self.bounds.size.width;
        Float64 y = pt.y/self.bounds.size.height;
        //UIViewController *soundOSCSend = [[UIViewController alloc] init];
        //[soundOSCSend sendOSC: @"Sending Sounds" "Pitch and Amplitude" :16 :@"soundx\0,s\0\0one\0"];
        /*
        need to create method that takes a variable for the coordinate point and creates an OSC message with float arg
        [self sendOSC:@"sending sounds" :@"pitch and amplitude" :16 :@"/soundx\0,f\0\0one\0"];
        [self sendOSC:@"sending sounds" :@"pitch and amplitude" :16 :@"/soundy\0,f\0\0one\0"];
        */
    }
}

-(void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event
{
    
}

-(void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
    
}

-(void)touchesCancelled:(NSSet *)touches withEvent:(UIEvent *)event
{
    
}
@end
