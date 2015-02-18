//
//  ARTPopoverAnimator.h
//  Artful Deductions
//
//  Created by Kyle Rokita on 10/16/14.
//  Copyright (c) 2014 Artful Deductions LLC. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ARTPopoverAnimator : NSObject  <UIViewControllerAnimatedTransitioning>

@property (nonatomic) BOOL onScreenIndicator;
@property (nonatomic) BOOL landscapeOKOnExit;

@property (weak, nonatomic) UIViewController *delegateController;

@end
