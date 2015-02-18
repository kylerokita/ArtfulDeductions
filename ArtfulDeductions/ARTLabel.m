//
//  ARTLabel.m
//  ArtfulDeductions
//
//  Created by Kyle Rokita on 7/7/14.
//  Copyright (c) 2014 Artful Deductions LLC. All rights reserved.
//

#import "ARTLabel.h"
#import "ARTConstants.h"

CGFloat const edgeInsetOffsetIphone = 5.0;
CGFloat const edgeInsetOffsetIpad = 10.0;

@implementation ARTLabel

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void)drawTextInRect:(CGRect)rect {
    
    CGFloat inset;
    if (IS_IPAD) {
        inset = edgeInsetOffsetIpad;
    } else {
        inset = edgeInsetOffsetIphone;
    }
    
    
    UIEdgeInsets insets = {inset, inset, inset, inset};
    return [super drawTextInRect:UIEdgeInsetsInsetRect(rect, insets)];
}

@end
