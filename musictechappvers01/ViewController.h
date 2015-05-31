//
//  ViewController.h
//  musictechappvers01
//
//  Created by Jordan Watson on 4/5/15.
//  Copyright (c) 2015 Jordan Watson. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ViewController : UIViewController {
    NSTimer *timer;
    NSThread *thread;
}
- (void)changeMessageLabel: (NSString *)message;
- (void)sendOSC: (NSString *)logMessage :(NSString *)labelMessage :(int)lengthOutBuffer :(const char *)oscMessage;
- (IBAction)playSound:(UIButton *)sender;
- (IBAction)sparsePressed:(UIButton *)sender;
- (IBAction)densePressed:(UIButton *)sender;
- (IBAction)quieterPressed:(UIButton *)sender;
- (IBAction)louderPressed:(UIButton *)sender;
- (IBAction)slowerPressed:(UIButton *)sender;
- (IBAction)fasterPressed:(UIButton *)sender;
-(void)appendToOSCMsg_FloatValue:(const char*)osc_str :(int)osc_str_length :(float)val;
@property (strong, nonatomic) IBOutlet UILabel *messageLabel;


@end

