//
//  ARTTransitionAnimator.m
//  Artful Deductions
//
//  Created by Kyle Rokita on 8/1/14.
//  Copyright (c) 2014 Artful Deductions LLC. All rights reserved.
//

#import "ARTNoTransitionAnimator.h"
#import "ARTCardViewController.h"
#import "ARTCard.h"
#import "ARTGalleryViewController.h"
#import "ARTGalleryCardViewController.h"
#import "ARTButton.h"
#import "ARTCategoryViewController.h"

//#define statements go here

//static NSInteger const declarations go here

@interface ARTNoTransitionAnimator () {
	//global variables go here
}

//"private" properties go here

@end

@implementation ARTNoTransitionAnimator

- (NSTimeInterval)transitionDuration:(id <UIViewControllerContextTransitioning>)transitionContext {
    return 0.0;
}

- (void)animateTransition:(id <UIViewControllerContextTransitioning>)transitionContext {
    // Grab the from and to view controllers from the context
    UIViewController *fromViewController = [transitionContext viewControllerForKey:UITransitionContextFromViewControllerKey];
    UIViewController *toViewController = [transitionContext viewControllerForKey:UITransitionContextToViewControllerKey];
    
    
    [transitionContext.containerView addSubview:fromViewController.view];
    [transitionContext.containerView addSubview:toViewController.view];

    
        //going to the game view
    if ([toViewController isMemberOfClass:[ARTCategoryViewController class]]) {
        
        [transitionContext completeTransition:YES];
    }
    
    //going to the gallery view from the gallery card view
    else if ([toViewController isMemberOfClass:[ARTGalleryViewController class]]) {
        
        NSInteger sectionIndex = ((ARTGalleryCardViewController *)fromViewController).deckIndex;
        NSInteger rowIndex = ((ARTGalleryCardViewController *)fromViewController).cardIndex;
        
        NSIndexPath *indexPath = [NSIndexPath indexPathForItem:rowIndex inSection:sectionIndex];
                
        [(ARTGalleryViewController *)toViewController animateTappedCardToPileWithIndexPath:indexPath];
        
        [transitionContext completeTransition:YES];
    }
    
    else {
        [transitionContext completeTransition:YES];
    }
    

}


@end
