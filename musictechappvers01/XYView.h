//
//  XYView.h
//  musictechappvers01
//
//  Created by Jordan Watson on 5/12/15.
//  Copyright (c) 2015 Jordan Watson. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface XYView : UIView


-(void)sendOSCFloats: (int)lengthOutBuffer :(const char *)oscMessage;
-(void)appendToOSCMsg_Value:(void*)osc_str :(int)osc_str_length :(void*)val;
-(void)doTouches: (NSSet *)touches withEvent: (UIEvent *)event;




@end

