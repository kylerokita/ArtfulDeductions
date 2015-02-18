//
//  ARTCategoryViewController.h
//  Artful Deductions
//
//  Created by Kyle Rokita on 9/30/14.
//  Copyright (c) 2014 Artful Deductions LLC. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ARTCardDelegate.h"
#import "ArtDailyViewDelegate.h"


@class ARTGame;
@class ARTCard;
@class ARTDeck;
@class ARTCategoryCollectionViewCell;
@class ARTTopView;
@class URBAlertView;

@interface ARTCategoryViewController : UIViewController <UINavigationControllerDelegate, UICollectionViewDataSource,UICollectionViewDelegate,UICollectionViewDelegateFlowLayout,UIPopoverPresentationControllerDelegate,UIViewControllerTransitioningDelegate,ARTCardDelegate,ARTDailyViewDelegate>

@property (strong, nonatomic) IBOutlet UIImageView *logoImageView;

@property (strong, nonatomic) UIView *avatarPlaceholderView;
@property (strong, nonatomic) UILabel *avatarLabel;
@property (strong, nonatomic) UIImageView *avatarImageview;
@property (strong, nonatomic) ARTTopView *topView;


@property (strong, nonatomic) IBOutlet UIView *categoryPlaceholderView;
@property (strong, nonatomic) IBOutlet UICollectionView *collectionView;

@property (strong, nonatomic) UIView  *overlay;

@property (strong, nonatomic) UIButton *backButton;

@property (strong,nonatomic) NSIndexPath *tappedIndexPath;
@property (strong,nonatomic) UIImageView *tappedImageview;

@property (strong, nonatomic) ARTGame *currentGame;
@property (strong,nonatomic) ARTCard *selectedCard;
@property (strong, nonatomic) ARTDeck *selectedDeck;

@property (strong, nonatomic) NSTimer *animationTimer;
@property (strong, nonatomic) NSTimer *headerAnimationTimer;


@property (strong, nonatomic) NSMutableArray *gameSaves;

@property (strong, nonatomic) NSMutableArray *visibleHeaderViews;

@property (strong, nonatomic) UIView *screenView;

@property (nonatomic) BOOL isShowingHeaderSampleCount;
@property (nonatomic) BOOL isShowingImageSide;
@property (nonatomic) BOOL isCardNextCardButtonPressed;
@property (nonatomic) BOOL isCardBackButtonPressed;
@property (nonatomic) BOOL isCardContinueButtonPressed;
@property (nonatomic) BOOL isNonCardButtonPressed;

@property (nonatomic)BOOL isOKToAnimateHeaderView;
@property (nonatomic)BOOL isOKToAnimateImageFlips;

@property (strong, nonatomic) URBAlertView *deckNotEnabledAlertView;


- (void)showOverlay:(BOOL)show;

- (UIImage *)pb_takeSnapshot;
- (UIView *)pb_takeSnapshotView;

- (void)handleEnteredBackground;
- (void)handleDidBecomeActive;


@end
