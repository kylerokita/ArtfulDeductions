//
//  ARTDailyViewController.h
//  Artful Deductions
//
//  Created by Kyle Rokita on 12/23/14.
//  Copyright (c) 2014 Artful Deductions LLC. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "ARTCardDelegate.h"
#import "ArtDailyViewDelegate.h"
#import <iAd/iAd.h>

@class ARTCard;
@class ARTMenuObject;
@class ARTCardScrollView;
@class ARTTopView;

@interface ARTDailyViewController : UIViewController <UINavigationControllerDelegate,UIScrollViewDelegate,ARTCardDelegate,ADInterstitialAdDelegate>


@property (strong, nonatomic) ARTTopView *topView;

@property (strong, nonatomic) IBOutlet UIImageView *logoImageView;
@property (strong, nonatomic) UILabel *logoImageLabel;

@property (strong, nonatomic) IBOutlet ARTCardScrollView *scrollView;
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *scrollViewTopHeightConstraint;
@property (nonatomic) CGFloat scrollViewTopHeightConstraintDefault;

@property (strong, nonatomic) IBOutlet NSLayoutConstraint *scrollViewBottomHeightConstraint;
@property (nonatomic) CGFloat scrollViewBottomHeightConstraintDefault;

@property (strong, nonatomic) IBOutlet ARTMenuObject *bottomMenu;
@property (strong, nonatomic) UIButton *backButton;

@property (strong, nonatomic) UILabel *scoreLabel;

@property (strong, nonatomic) NSMutableArray *sortedCardsFromSortedDecks;
@property (strong, nonatomic) NSMutableArray *sortedDecks;
@property ( nonatomic) NSInteger deckIndex;
@property ( nonatomic) NSInteger cardIndex;
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *bottomMenuHeightConstraint;

- (void)backToGalleryTapDetected:(id)sender;


@property (strong, nonatomic) NSMutableArray *gameSaves;

@property (nonatomic) BOOL isOKForStartButtonToBlink;

@property (nonatomic) BOOL isShowingImageSide;

@property (nonatomic) BOOL isCardJustPlayed;


@property (nonatomic) BOOL isCardNextCardButtonPressed;
@property (nonatomic) BOOL isCardBackButtonPressed;
@property (nonatomic) BOOL isCardContinueButtonPressed;
@property (nonatomic) BOOL isNonCardButtonPressed;

@property (strong,nonatomic) ARTCard *selectedCard;
@property (strong, nonatomic) ARTGame *currentGame;
@property (strong, nonatomic) ARTDeck *selectedDeck;

@property (nonatomic, weak) id <ARTDailyViewDelegate> delegate;


@end
