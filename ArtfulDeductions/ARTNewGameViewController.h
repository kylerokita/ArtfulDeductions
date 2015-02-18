//
//  ARTNewGameViewController.h
//  Artful Deductions
//
//  Created by Kyle Rokita on 8/4/14.
//  Copyright (c) 2014 Artful Deductions LLC. All rights reserved.
//

#import <UIKit/UIKit.h>

@class ARTDeck;
@class ARTButton;
@class URBAlertView;
@class ARTGame;
@class ARTTopView;

@interface ARTNewGameViewController : UIViewController <UINavigationControllerDelegate,UITextFieldDelegate,UIScrollViewDelegate,UICollectionViewDataSource,UICollectionViewDelegate>

@property (strong, nonatomic) UIButton *backButton;

@property (strong, nonatomic) IBOutlet UIImageView *logoImageView;
@property (strong, nonatomic) IBOutlet UILabel *topLabel;
@property (strong, nonatomic) ARTTopView *topView;

@property (strong, nonatomic) IBOutlet UILabel *playerNamesLabel;
@property (strong, nonatomic) IBOutlet UIView *playersNamePlaceholderView;
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *playersNameLabelHeightConstraint;

@property (strong, nonatomic) IBOutlet UITextField *firstPlayerTextField;
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *firstPlayerTextFieldHeightConstraint;

@property (strong, nonatomic) IBOutlet UICollectionView *collectionView;

@property (nonatomic) BOOL firstPlayerTextFieldIsGrowing;
@property (nonatomic) CGFloat firstPlayerTextFieldDefaultBorder;

@property (strong, nonatomic) IBOutlet UILabel *cardDeckLabel;
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *cardDeckLabelHeightConstraint;
@property (strong, nonatomic) IBOutlet UIView *cardDeckPlaceholderView;

@property (strong, nonatomic) IBOutlet ARTButton *startButton;
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *buttonHeightConstraint;

@property (strong, nonatomic) NSArray *IAPProducts;
@property (strong, nonatomic) NSMutableArray *decks;

@property (strong, nonatomic) ARTDeck *selectedDeck;
@property (strong, nonatomic) NSMutableDictionary *playerNames;

@property (nonatomic, strong) URBAlertView *playerNotSetupAlertView;
@property (nonatomic, strong) URBAlertView *bioAlertView;
@property (nonatomic, strong) URBAlertView *avatarNotEnabledAlertView;

@property (strong, nonatomic) NSTimer *animationTimer;

@property (nonatomic) BOOL newPlayer;
@property (strong, nonatomic) ARTGame *game;


- (IBAction)startButtonTapped:(id)sender;

@end
