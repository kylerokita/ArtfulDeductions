//
//  ARTStartViewController.h
//  Artful Deductions
//
//  Created by Kyle Rokita on 8/1/14.
//  Copyright (c) 2014 Artful Deductions LLC. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ArtDailyViewDelegate.h"


@class ARTMenuObject;
@class ARTGame;


@interface ARTStartViewController : UIViewController <UINavigationControllerDelegate,UIScrollViewDelegate,ARTDailyViewDelegate>

@property (strong, nonatomic) IBOutlet UILabel *tagLineLabel;
@property (strong, nonatomic) IBOutlet UIImageView *logoImageView;
@property (strong, nonatomic) IBOutlet UIView *imageViewPlaceholder;
@property (strong, nonatomic) UIImageView *imageView;
@property (strong, nonatomic) UIImageView *backgroundImageview;


@property (strong, nonatomic) IBOutlet UIView *menuPlaceholder;
@property (strong, nonatomic) ARTMenuObject *menu;

@property (strong, nonatomic) IBOutlet NSLayoutConstraint *menuPlaceholderHeightConstraint;
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *menuPlaceholderBottomConstraint;
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *logoImageViewTopMarginConstraint;
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *imageViewPlaceholderTopConstraint;
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *imageViewPlaceholderBottomConstraint;

@property (strong, nonatomic) NSMutableArray *gameSaves;

@property (strong, nonatomic) UIView *tranformedView;

@property (strong, nonatomic) UILabel *textLabel;
@property (strong, nonatomic) UIView *cardImageGridView;
@property (strong, nonatomic) NSMutableArray *cardImageViews;

@property (strong, nonatomic) UIView *cardImageGridView2;
@property (strong, nonatomic) NSMutableArray *cardImageViews2;


@property (strong, nonatomic) NSTimer *animationTimer;

@property (nonatomic) BOOL isOKToAnimateLabel;
@property (nonatomic) BOOL isDailyCardJustPlayed;


@property (strong, nonatomic) NSMutableArray *sortedCardsFromDailyDecks;
@property (strong, nonatomic) NSMutableArray *dailyDecks;
@property ( nonatomic) NSInteger deckIndex;
@property ( nonatomic) NSInteger cardIndex;

@end
