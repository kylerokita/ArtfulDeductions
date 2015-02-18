//
//  ARTCardScrollView.m
//  Artful Deductions
//
//  Created by Kyle Rokita on 9/12/14.
//  Copyright (c) 2014 Artful Deductions LLC. All rights reserved.
//

#import "ARTCardScrollView.h"
#import "ARTConstants.h"

@implementation ARTCardScrollView



-(BOOL)pointInside:(CGPoint)point withEvent:(UIEvent *)event {
    
    CGFloat height;
    if (IS_IPAD) {
        height = 100.0;
    } else {
        height = 75.0;
    }
    
    CGRect topViewFrame = CGRectMake([UIScreen mainScreen].bounds.origin.x, [UIScreen mainScreen].bounds.origin.y, [UIScreen mainScreen].bounds.size.width, height);
    CGRect topViewFrameInScrollView = [self convertRect:topViewFrame fromView:[self superview]];

    if (CGRectContainsPoint(topViewFrameInScrollView, point)) {
        return NO;
    }
        
        return YES;
}



@end
