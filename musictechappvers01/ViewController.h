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

- (IBAction)slowerPressed:(UIButton *)sender;
- (IBAction)fasterPressed:(UIButton *)sender;

@end

