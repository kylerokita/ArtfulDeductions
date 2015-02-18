//
//  ARTPopoverAnimator.m
//  Artful Deductions
//
//  Created by Kyle Rokita on 10/16/14.
//  Copyright (c) 2014 Artful Deductions LLC. All rights reserved.
//

#import "ARTPopoverAnimator.h"
#import "ARTCategoryViewController.h"
#import "ARTCardViewController.h"
#import "ARTNavigationController.h"

@implementation ARTPopoverAnimator

- (NSTimeInterval)transitionDuration:(id <UIViewControllerContextTransitioning>)transitionContext {
    return 6.00;
}

- (void)animateTransition:(id <UIViewControllerContextTransitioning>)transitionContext {
    // Grab the from and to view controllers from the context
    UIViewController *fromViewController = [transitionContext viewControllerForKey:UITransitionContextFromViewControllerKey];
    UIViewController *toViewController = [transitionContext viewControllerForKey:UITransitionContextToViewControllerKey];
    
    
    CGAffineTransform transform = CGAffineTransformIdentity;
    
    if (self.onScreenIndicator) {
        
        if ([self.delegateController isMemberOfClass:[ARTCategoryViewController class]]) {
            [(ARTCategoryViewController *)self.delegateController handleEnteredBackground];
        }
        UIView *backgroundViewLight = [(ARTCategoryViewController *)self.delegateController pb_takeSnapshotView];
        backgroundViewLight.opaque = YES;
        [transitionContext.containerView addSubview:backgroundViewLight];
        
        
        [(ARTCategoryViewController *)self.delegateController showOverlay:YES];

        
        UIView *backgroundViewDark = [(ARTCategoryViewController *)self.delegateController pb_takeSnapshotView];
        backgroundViewDark.opaque = YES;
        
        
        fromViewController.view.hidden = YES;
        
        [(ARTNavigationController*)fromViewController setLandscapeOK:NO];
        
        toViewController.view.alpha = 0.0;
        toViewController.view.transform = CGAffineTransformScale(transform, 0.8, 0.8);
        
        [transitionContext.containerView addSubview:toViewController.view];
        [transitionContext.containerView bringSubviewToFront:toViewController.view];
        
        [UIView animateWithDuration:0.18 animations:^{
            toViewController.view.transform = CGAffineTransformScale(transform, 1.1, 1.1);
            toViewController.view.alpha = 1.0;
        } completion:^(BOOL finished) {
            [transitionContext.containerView addSubview:backgroundViewDark];
            [transitionContext.containerView insertSubview:backgroundViewDark aboveSubview:backgroundViewLight];
            [backgroundViewLight removeFromSuperview];
            
            [UIView animateWithDuration:0.13 animations:^{
                toViewController.view.transform = CGAffineTransformScale(transform, 0.9, 0.9);
            } completion:^(BOOL finished) {
                [UIView animateWithDuration:0.1 animations:^{
                    toViewController.view.transform = transform;
                } completion:^(BOOL finished) {
                    
                    [(ARTCategoryViewController *)self.delegateController showOverlay:YES];
                    fromViewController.view.hidden = NO;

                    [backgroundViewDark removeFromSuperview];
                    
                    [transitionContext completeTransition:YES];

                }];
            }];
        }];
    }
    else {
        
        [transitionContext.containerView bringSubviewToFront:fromViewController.view];
        
        toViewController.view.hidden = NO;
               UIView *backgroundViewDark = [(ARTCategoryViewController *)self.delegateController pb_takeSnapshotView];
        
        backgroundViewDark.opaque = YES;
        [transitionContext.containerView addSubview:backgroundViewDark];
        [transitionContext.containerView insertSubview:backgroundViewDark belowSubview:fromViewController.view];
        
        [(ARTCategoryViewController *)self.delegateController showOverlay:NO];
        UIView *backgroundViewLight = [(ARTCategoryViewController *)self.delegateController pb_takeSnapshotView];

        
        toViewController.view.hidden = YES;
        
        [UIView animateWithDuration:0.15 animations:^{
            fromViewController.view.transform = CGAffineTransformScale(transform, 1.15, 1.15);
        } completion:^(BOOL finished) {
            [transitionContext.containerView addSubview:backgroundViewLight];
            [transitionContext.containerView insertSubview:backgroundViewLight aboveSubview:backgroundViewDark];
            [backgroundViewDark removeFromSuperview];
            
            [UIView animateWithDuration:0.2 animations:^{
                fromViewController.view.transform = CGAffineTransformScale(transform, 0.7, 0.7);
                fromViewController.view.alpha = 0.0;
            } completion:^(BOOL finished) {
       
                [fromViewController.view removeFromSuperview];
                fromViewController.view = nil;
                
                toViewController.view.hidden = NO;
                
                [backgroundViewLight removeFromSuperview];
                
                if (self.landscapeOKOnExit) {
                    [(ARTNavigationController*)toViewController setLandscapeOK:YES];
                }
                
                if ([self.delegateController isMemberOfClass:[ARTCategoryViewController class]]) {
                    [(ARTCategoryViewController *)self.delegateController handleDidBecomeActive];
                }
                
                
                [transitionContext completeTransition:YES];
                

            }];
        }];
    }

    


    
}


@end
