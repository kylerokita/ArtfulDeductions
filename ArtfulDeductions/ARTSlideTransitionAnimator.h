//
//  ARTSlideTransitionAnimator.h
//  Artful Deductions
//
//  Created by Kyle Rokita on 10/13/14.
//  Copyright (c) 2014 Artful Deductions LLC. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ARTSlideTransitionAnimator : NSObject  <UIViewControllerAnimatedTransitioning>

@property (nonatomic) NSString *direction;

@end
