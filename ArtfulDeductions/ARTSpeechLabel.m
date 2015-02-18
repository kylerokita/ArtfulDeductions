//
//  ARTSpeechLabel.m
//  Artful Deductions
//
//  Created by Kyle Rokita on 10/22/14.
//  Copyright (c) 2014 Artful Deductions LLC. All rights reserved.
//

#import "ARTSpeechLabel.h"
#import "ARTConstants.h"

 CGFloat const speechBubbleInsetOffsetIphone = 20.0;
 CGFloat const speechBubbleInsetOffsetIpad = 35.0;

@implementation ARTSpeechLabel

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

- (void)drawTextInRect:(CGRect)rect {
    
    CGFloat inset;
    if (IS_IPAD) {
        inset = speechBubbleInsetOffsetIpad;
    } else {
        inset = speechBubbleInsetOffsetIphone;
    }
    
    
    UIEdgeInsets insets = {inset, inset, inset, inset};
    return [super drawTextInRect:UIEdgeInsetsInsetRect(rect, insets)];
}

@end
