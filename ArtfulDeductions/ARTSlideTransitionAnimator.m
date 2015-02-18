//
//  ARTSlideTransitionAnimator.m
//  Artful Deductions
//
//  Created by Kyle Rokita on 10/13/14.
//  Copyright (c) 2014 Artful Deductions LLC. All rights reserved.
//

#import "ARTSlideTransitionAnimator.h"

@implementation ARTSlideTransitionAnimator

- (NSTimeInterval)transitionDuration:(id <UIViewControllerContextTransitioning>)transitionContext {
    return 0.5;
}

- (void)animateTransition:(id <UIViewControllerContextTransitioning>)transitionContext {
    // Grab the from and to view controllers from the context
    UIViewController *fromViewController = [transitionContext viewControllerForKey:UITransitionContextFromViewControllerKey];
    UIViewController *toViewController = [transitionContext viewControllerForKey:UITransitionContextToViewControllerKey];
    
    [transitionContext.containerView addSubview:fromViewController.view];
    [transitionContext.containerView addSubview:toViewController.view];
    
    if ([self.direction isEqualToString:@"up"] ){
        toViewController.view.center = CGPointMake(toViewController.view.center.x, toViewController.view.center.y - toViewController.view.frame.size.height);
    } else {
        toViewController.view.center = fromViewController.view.center;
        [transitionContext.containerView bringSubviewToFront:fromViewController.view];

    }
    
    CGPoint toViewNextCenter;
    CGPoint fromViewNextCenter;
    if ([self.direction isEqualToString:@"up"] ){
        fromViewNextCenter = fromViewController.view.center;
        toViewNextCenter = fromViewController.view.center;
    } else {
        fromViewNextCenter = CGPointMake(fromViewController.view.center.x, fromViewController.view.center.y - fromViewController.view.frame.size.height);
        toViewNextCenter = fromViewController.view.center;
    }

    
    [UIView animateWithDuration:[self transitionDuration:transitionContext]
                          delay:0.0
                        options:UIViewAnimationOptionCurveEaseInOut | UIViewAnimationOptionAllowAnimatedContent
                     animations:^{
                         
                         toViewController.view.center = toViewNextCenter;
                         fromViewController.view.center = fromViewNextCenter;

                         
                     } completion:^(BOOL finished) {
                         [transitionContext completeTransition:YES];

                     }];
    
}

@end
