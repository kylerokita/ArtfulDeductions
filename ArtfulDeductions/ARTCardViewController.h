//
//  ARTCardViewController.h
//  Artful Deductions
//
//  Created by Kyle Rokita on 8/1/14.
//  Copyright (c) 2014 Artful Deductions LLC. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <iAd/iAd.h>
#import "ARTGameDelegate.h"
#import "ARTCardDelegate.h"

@class ARTMenuObject;
@class ARTCard;
@class ARTGame;
@class ARTLabel;
@class ARTCardStackView;
@class ARTCategory;
@class ARTCategoryViewController;
@class ARTDeck;
@class ARTTopView;

@interface ARTCardViewController : UIViewController <ARTGameDelegate,UITextFieldDelegate, UIScrollViewDelegate,UINavigationControllerDelegate,UIViewControllerTransitioningDelegate>

- (IBAction)backButtonTapped:(id)sender;

@property (strong, nonatomic) ARTGame *currentGame;
@property (strong, nonatomic) ARTDeck *selectedDeck;
@property (strong, nonatomic) ARTCard *selectedCard;
@property (nonatomic, weak) id <ARTCardDelegate> delegate;

@property (strong, nonatomic) UIView *scorePlaceholderView;
@property (strong, nonatomic) UILabel *scoreLabel;
@property (strong, nonatomic) ARTTopView *topView;

@property (strong, nonatomic) UIView *overlay;


- (void)questionTimerExpired;
- (void)updateCardOverlayStatusViews;

- (void)showOverlay:(BOOL)show;

- (UIImage *)pb_takeSnapshot;
- (UIView *)pb_takeSnapshotView;

//- (void)updateForCardOverlayViewBoundsChange;

@end
