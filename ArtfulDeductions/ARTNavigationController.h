//
//  ARTNavigationController.h
//  Artful Deductions
//
//  Created by Kyle Rokita on 8/4/14.
//  Copyright (c) 2014 Artful Deductions LLC. All rights reserved.
//

#import <UIKit/UIKit.h>

extern const CGFloat alertTitleFontSizeIphone5;
extern const CGFloat alertTitleFontSizeIphone6;
extern const CGFloat alertTitleFontSizeIpad;

extern const CGFloat alertMessageFontSizeIphone5;
extern const CGFloat alertMessageFontSizeIphone6;
extern const CGFloat alertMessageFontSizeIpad;

@interface ARTNavigationController : UINavigationController <UIPopoverPresentationControllerDelegate>

@property (nonatomic) BOOL landscapeOK;

- (void) setupAlertViewAppearance;

@end
