//
//  XYView.h
//  musictechappvers01
//
//  Created by Jordan Watson on 5/12/15.
//  Copyright (c) 2015 Jordan Watson. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface XYView : UIView


- (void)sendOSC: (NSString *)logMessage :(NSString *)labelMessage :(int)lengthOutBuffer :(NSString *)oscMessage;
-(void)doTouches: (NSSet *)touches withEvent: (UIEvent *)event;


@end

