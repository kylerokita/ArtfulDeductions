//
//  ARTFadeTransitionAnimator.m
//  Artful Deductions
//
//  Created by Kyle Rokita on 8/4/14.
//  Copyright (c) 2014 Artful Deductions LLC. All rights reserved.
//

#import "ARTFadeTransitionAnimator.h"

//#define statements go here

//static NSInteger const declarations go here

@interface ARTFadeTransitionAnimator () {
	//global variables go here
}

//"private" properties go here

@end

@implementation ARTFadeTransitionAnimator

- (NSTimeInterval)transitionDuration:(id <UIViewControllerContextTransitioning>)transitionContext {
    return 0.5;
}

- (void)animateTransition:(id <UIViewControllerContextTransitioning>)transitionContext {
    // Grab the from and to view controllers from the context
    UIViewController *fromViewController = [transitionContext viewControllerForKey:UITransitionContextFromViewControllerKey];
    UIViewController *toViewController = [transitionContext viewControllerForKey:UITransitionContextToViewControllerKey];
    
    [transitionContext.containerView addSubview:fromViewController.view];
    [transitionContext.containerView addSubview:toViewController.view];

    [UIView transitionFromView:fromViewController.view
                        toView:toViewController.view
                      duration:[self transitionDuration:transitionContext]
                       options:self.options
                    completion:^(BOOL finished) {
                        [transitionContext completeTransition:YES];
                    }];

}


@end
