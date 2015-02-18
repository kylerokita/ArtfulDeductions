//
//  ARTButton.h
//  Artful Deductions
//
//  Created by Kyle Rokita on 8/2/14.
//  Copyright (c) 2014 Artful Deductions LLC. All rights reserved.
//

#import <UIKit/UIKit.h>

extern CGFloat const buttonPressDelay;

@interface ARTButton : UIButton

- (id)applyStandardFormatting;

- (void)setCustomHighlighted:(BOOL)highlighted;

- (void)setCustomEnabled:(BOOL)enabled;

- (void)makeGlossy;

- (void)setEmergencyRed;

+ (UIColor *) getButtonColorForHighlighted:(BOOL)isHighlighted;

+ (UIColor *) getButtonColorForBlinked:(BOOL)isBlinked;

@end
