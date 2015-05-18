//
//  XYView.m
//  musictechappvers01
//
//  Created by Jordan Watson on 5/12/15.
//  Copyright (c) 2015 Jordan Watson. All rights reserved.
//

#import "XYView.h"

@implementation XYView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

- (void)sendOSC: (NSString *)logMessage :(NSString *)labelMessage :(int)lengthOutBuffer :(NSString *)oscMessage
{
    
}

-(void)doTouches:(NSSet *)touches withEvent:(UIEvent *)event
{
    for (UITouch* t in touches)
    {
        NSLog(@"%d",touches.count);
        CGPoint pt = [t locationInView:self];
        Float64 x = pt.x/self.bounds.size.width;
        Float64 y = pt.y/self.bounds.size.height;
        NSLog(@"%lf,%lf", x, (1. - y));
        /*UIViewController *soundOSCSend = [[UIViewController alloc] init];
         [soundOSCSend sendOSC: @"Sending Sounds" "Pitch and Amplitude" :16 :@"soundx\0,s\0\0one\0"];
         need to create method that takes a variable for the coordinate point and creates an OSC message with float arg
         [self sendOSC:@"sending sounds" :@"pitch and amplitude" :16 :@"/soundx\0,f\0\0one\0"];
         [self sendOSC:@"sending sounds" :@"pitch and amplitude" :16 :@"/soundy\0,f\0\0one\0"];
         */
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
    [self doTouches:touches withEvent:event];
}

-(void)touchesCancelled:(NSSet *)touches withEvent:(UIEvent *)event
{
    [self doTouches:touches withEvent:event];
}

@end
