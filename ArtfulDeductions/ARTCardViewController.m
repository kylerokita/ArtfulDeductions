//
//  ARTCardViewController.m
//  Artful Deductions
//
//  Created by Kyle Rokita on 8/1/14.
//  Copyright (c) 2014 Artful Deductions LLC. All rights reserved.
//

#import "ARTCardViewController.h"
#import "ARTMenuObject.h"
#import "ARTCard.h"
#import "ARTGame.h"
#import "ARTLabel.h"
#import "ARTAppDelegate.h"
#import "ARTCardViewController.h"
#import "ARTNoTransitionAnimator.h"
#import "ARTNavigationController.h"
#import "ARTPlayer.h"
#import "UIImage+Customization.h"
#import "ARTImageHelper.h"
#import "ARTUserInfo.h"
#import "ARTButton.h"
#import "UIColor+Extensions.h"
#import "UIButton+Extensions.h"
#import "ARTCardScrollView.h"
#import "ARTAnswer.h"
#import "URBAlertView.h"
#import "ARTConstants.h"
#import "ARTCategoryViewController.h"
#import "ARTAvatar.h"
#import "ARTTopView.h"
#import "ARTDeck.h"
#import "ARTScoreViewController.h"
#import "ARTPopoverAnimator.h"
#import "ARTPassTouchesView.h"
#import "ARTAlertImageView.h"
#import "ARTSpeechBubleView.h"
#import "ARTSpeechLabel.h"
#import "ARTMessageViewController.h"
#import "iRate.h"
#import "ARTCardOverlayView.h"

#import "MKStoreManager.h"


CGFloat const cardStatusCardOverlayXOffset = 5.0;
CGFloat const cardStatusCardOverlayYOffset = 20.0;

CGFloat const cardStatusCardOverlayDiameterIphone = 52.0;
CGFloat const cardStatusCardOverlayDiameterIphone6 = 62.0;
CGFloat const cardStatusCardOverlayDiameterIpad = 90.0;


CGFloat const questionViewXOffsetIphone = 5.0;
CGFloat const questionViewXOffsetIpad = 5.0;

@interface ARTCardViewController ()

@property (strong, nonatomic) ARTCardOverlayView *cardOverlayView;

@property (strong, nonatomic) UIImageView *logoImageView;
@property (strong, nonatomic) UIView *roundStatusView;
@property (strong, nonatomic) UILabel *roundTimerLabel;
@property (strong, nonatomic) UIView *roundStatusDotView;


@property (strong, nonatomic) ARTCardScrollView *cardOverlayScrollView;
@property (strong, nonatomic) UIImageView *cardOverlayFrontImageView;
@property (strong, nonatomic) UIImageView *cardOverlayBackImageView;

@property (strong, nonatomic) UIView *cardOverlayBottomView;
@property (strong, nonatomic) UIImageView *cardOverlayQImageView;
@property (strong, nonatomic) ARTLabel *cardOverlayQuestionLabel;
@property (strong, nonatomic) UIView *cardOverlayQuestionView;
@property (strong, nonatomic) ARTMenuObject *cardOverlayQuestionMenu;
@property (strong, nonatomic) UITapGestureRecognizer *cardOverlayButtonTapGesture;
@property (strong, nonatomic)UITextField *cardOverlayAnswerTextField;

@property (strong, nonatomic) ARTMenuObject *cardOverlayReviewArtMenu;

@property (strong, nonatomic) ARTMenuObject *cardOverlayAnswerMenu;
@property (strong, nonatomic) ARTLabel *cardOverlayAnswerLabel;
@property (strong, nonatomic) UILabel *cardOverlayAnswerTapLabel;
@property (strong, nonatomic) UIImageView *cardOverlayAImageView;
@property (strong, nonatomic) ARTButton *cardOverlayAnswerHintButton;
@property (strong, nonatomic) UIView *cardOverlayAnswerBackground;


@property (strong, nonatomic) URBAlertView *timerUpAlertView;
@property (strong, nonatomic) URBAlertView *correctAnswerAlertView;
@property (strong, nonatomic) URBAlertView *giveUpAlertView;
@property (strong, nonatomic) URBAlertView *giveUpConfirmedAlertView;
@property (strong, nonatomic) URBAlertView *topicCompletedAlertView;
@property (strong, nonatomic) URBAlertView *avatarUnlockedAlertView;


@property (strong, nonatomic) UIButton *backButton;
@property (strong, nonatomic) UIButton *continueButton;
@property (strong, nonatomic) UIButton *giveUpButton;

@property (nonatomic) BOOL flippingCardInProgress;
@property (nonatomic) BOOL hidingCardOverlayInProgress;
@property (nonatomic) BOOL flippingToHideCardOverlayInProgress;

@property (nonatomic) CGRect portraitCardOverlayStatusDefaultFrame;

@property (nonatomic) CGRect cardOverlayBottomViewDefaultFrame;
@property (nonatomic) CGRect cardOverlayMenuDefaultFrame;
@property (nonatomic) CGRect cardOverlayAnswerTextFieldDefaultFrame;
@property (nonatomic) CGRect cardOverlayQuestionDefaultFrame;
@property (nonatomic) CGFloat cardOverlayAnswerTextFieldDefaultBorder;

@property (nonatomic) BOOL isOKForCountdownTimerToBlink;
@property (nonatomic) BOOL isOKForAnimateRoundStatusViewDot;
@property (nonatomic) BOOL isOKForCardStackAnswerTextFieldToBlink;
@property (nonatomic) BOOL iscardStackAnswerTextFieldGrowing;
@property (nonatomic) BOOL isOKForStartButtonToBlink;
@property (nonatomic) BOOL isStartButtonBlinked;

@property (nonatomic) BOOL isShowingImageSide;
@property (nonatomic) BOOL isShowingQuestionLabel;
@property (nonatomic) BOOL isShowingAnswerLabel;
@property (nonatomic) BOOL isOKToShowQuestion;
@property (nonatomic) BOOL isOkToShowAnswer;
@property (nonatomic) BOOL isShowingAnswerForFirstTime;
@property (nonatomic) BOOL isShowingQuestionForFirstTime;
@property (nonatomic) BOOL isShowingGameOver;
@property (nonatomic) BOOL isShowingKeyboard;
@property (nonatomic) BOOL isCountdownTimerShowingBlack;
@property (nonatomic) BOOL isShowingFullAnswerMenu;

@property (nonatomic) BOOL isOKToShowReviewMenu;
@property (nonatomic) BOOL isOKToShowBottomView;
@property (nonatomic) BOOL isOKToShowNavigationBar;

@property (nonatomic) BOOL isRepeatPlayOfCard;

@property (nonatomic) NSInteger answerHintCounter;


@end

@implementation ARTCardViewController


- (void)viewDidLoad {
    [super viewDidLoad];
    
    if ([[[ARTUserInfo sharedInstance] getVisualTheme] isEqual:@"white"]) {
        self.originalContentView.backgroundColor = [UIColor lightBackgroundColor];
    } else {
        self.originalContentView.backgroundColor = [UIColor darkBackgroundColor];
    }
    
    [self initializeCardGlobalVariables];
    
    [self.selectedCard resetCard];
    
    self.currentGame.delegate = self;
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void) viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    self.navigationController.delegate = self;
    
    [(ARTNavigationController*)[self navigationController] setLandscapeOK:YES];
    [self.navigationController setNavigationBarHidden:YES animated:NO];
    self.navigationItem.hidesBackButton = YES;
    self.isOKToShowNavigationBar = YES;

    [self makeCardOverlayViewWithCard:self.selectedCard];
    
    [self.originalContentView layoutIfNeeded];
    [self.cardOverlayView layoutIfNeeded];
    
    self.backButton = [[UIButton alloc] backButtonWith:@"Topics" tintColor:[UIColor blueNavBarColor] target:self andAction:@selector(backButtonTapped:)];
    self.backButton.alpha = 0.0;
    [self.cardOverlayView addSubview:self.backButton];
    [self.cardOverlayView insertSubview:self.backButton aboveSubview:self.logoImageView];
    
    [self centerScrollViewContents];
    
    self.isOKToShowReviewMenu = YES;
    
    
    self.scorePlaceholderView.alpha = 0.0;
    
    /*   if ([[ARTUserInfo sharedInstance] showTutorialForScreen:@"questionScreen"] ) {
     self.originalContentView.userInteractionEnabled = NO; //beforetutorial is shown, no not allow user interaction
     [self performSelector:@selector(showTutorial) withObject:nil afterDelay:0.0 inModes:[NSArray arrayWithObject:NSRunLoopCommonModes]];
     [[ARTUserInfo sharedInstance] saveShowedTutorialForScreen:@"questionScreen"];
     
     } */
    

    [self startQuestionTapDetected:nil];
        
    if ([MKStoreManager isFeaturePurchased:kProductClassicSeries] || [MKStoreManager isFeaturePurchased:kProductRemoveAds]) {
        self.canDisplayBannerAds = NO;
     } else {
         self.canDisplayBannerAds = YES;
     }

}


- (void)setupScoreView {
    
    if (self.scorePlaceholderView) {
        [self.scorePlaceholderView removeFromSuperview];
        self.scorePlaceholderView = nil;
        self.scoreLabel = nil;
    }
    
    
    CGFloat width = 200.0;
    CGFloat height = self.logoImageView.frame.size.height;
    CGFloat x = self.originalContentView.bounds.size.width - width - 5.0;
    CGFloat y = self.logoImageView.frame.origin.y;
    
    CGRect avatarPlaceholderFrame = CGRectMake(x,y, width, height);
    
    self.scorePlaceholderView = [[UIView alloc] initWithFrame:avatarPlaceholderFrame];
    
    
    [self.originalContentView addSubview:self.scorePlaceholderView];
    
    
    NSMutableAttributedString *attrString = [self getScoreLabelText];
    
    CGFloat labelHeight = self.scorePlaceholderView.bounds.size.height;
    
    CGSize maximumLabelSize = CGSizeMake(self.originalContentView.bounds.size.width, labelHeight);
    
    NSString *string = attrString.string;
    CGRect textRect = [string boundingRectWithSize:maximumLabelSize
                                           options:(NSStringDrawingUsesLineFragmentOrigin|NSStringDrawingUsesFontLeading)
                                        attributes:[attrString attributesAtIndex:0 effectiveRange:nil]
                                           context:nil];
    string = nil;
    
    CGFloat labelWidth = ceil(textRect.size.width)+20.0 ;
    
    CGFloat labelX = self.scorePlaceholderView.bounds.size.width - labelWidth;
    CGFloat labelY = self.scorePlaceholderView.bounds.origin.y;
    
    CGRect labelFrame = CGRectMake(labelX,labelY, labelWidth, labelHeight);
    
    self.scoreLabel = [[UILabel alloc] initWithFrame:labelFrame];
    
    self.scoreLabel.textAlignment = NSTextAlignmentCenter;
    self.scoreLabel.numberOfLines = 0;
    
    self.scoreLabel.layer.cornerRadius = 15.0;
    self.scoreLabel.clipsToBounds = YES;
    
    if (self.selectedCard.isPlayed) {
        self.scoreLabel.backgroundColor = [UIColor greenishColor];
    } else {
        self.scoreLabel.backgroundColor = [UIColor emergencyRedColor];
    }
    
    self.scoreLabel.attributedText = attrString;
    
    [self.scorePlaceholderView addSubview:self.scoreLabel];
    [self.cardOverlayView addSubview:self.scorePlaceholderView];
    [self.cardOverlayView insertSubview:self.scorePlaceholderView aboveSubview:self.logoImageView];
    
    UITapGestureRecognizer *singleTapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(scoreTapDetected:)];
    singleTapGesture.numberOfTapsRequired = 1;
    self.scorePlaceholderView.userInteractionEnabled = YES;
    self.scoreLabel.userInteractionEnabled = YES;
    [self.scorePlaceholderView addGestureRecognizer:singleTapGesture];
    
}

- (void)updateScoreLabel {
    
    self.scoreLabel.attributedText = [self getScoreLabelText];
    
    
    
    
}

- (NSMutableAttributedString *)getScoreLabelText {
    
    //ARTPlayer *player = self.currentGame.players[@"Player1"];
    
    UIFont * font;
    UIFont * largeFont;
    if (IS_IPAD) {
        font = [UIFont fontWithName:@"HelveticaNeue" size:28];
        largeFont = [UIFont fontWithName:@"HelveticaNeue" size:34];

    }
    else {
        font = [UIFont fontWithName:@"HelveticaNeue" size:18];
        largeFont = [UIFont fontWithName:@"HelveticaNeue" size:24];
    }
    UIColor *color = [UIColor whiteColor];
    
    
    NSMutableAttributedString *attrString;
    
    if (self.selectedCard.isPlayed) {
        
        NSString *text = [NSString stringWithFormat:@"Score\n"];
        NSString *text2 = [NSString stringWithFormat:@"%ld",self.selectedCard.points];
        
        
        attrString = [[NSMutableAttributedString alloc] initWithString:text attributes:@{NSFontAttributeName:font,NSForegroundColorAttributeName:color}];
        
        NSMutableAttributedString *attrString2 = [[NSMutableAttributedString alloc] initWithString:text2 attributes:@{NSFontAttributeName:largeFont,NSForegroundColorAttributeName:color}];
        
        [attrString appendAttributedString:attrString2];
        
    } else {
        NSString *text = [NSString stringWithFormat:@"Not\nPlayed"];
        
        attrString = [[NSMutableAttributedString alloc] initWithString:text attributes:@{NSFontAttributeName:font,NSForegroundColorAttributeName:color}];
    }
    
    
    
    return attrString;
}



- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillShow:)
                                                 name:UIKeyboardWillShowNotification
                                               object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillHide:)
                                                 name:UIKeyboardWillHideNotification
                                               object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardDidShow:)
                                                 name:UIKeyboardDidShowNotification
                                               object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardDidHide:)
                                                 name:UIKeyboardDidHideNotification
                                               object:nil];
    
    NSLog(@"%@",self.originalContentView);
    NSLog(@"%@",self.view);
    NSLog(@"%@",self.cardOverlayView);

}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    
    self.isOKForCountdownTimerToBlink = NO;
    self.isOKForCardStackAnswerTextFieldToBlink = NO;
    self.isOKForStartButtonToBlink = NO;
    self.isOKForAnimateRoundStatusViewDot = NO;
    
    
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    
}


- (void)showOverlay:(BOOL)show {
    if (show) {
        
        if (!self.overlay) {
            self.overlay = [[UIView alloc] initWithFrame:self.originalContentView.bounds];
            self.overlay.opaque = YES;
            
            self.overlay.backgroundColor = [UIColor colorWithRed: 0 green: 0 blue: 0 alpha: 0.8];
            
            [self.originalContentView addSubview:self.overlay];
        }
        
    } else {
        
        if (self.overlay) {
            [self.overlay removeFromSuperview];
            self.overlay = nil;
        }
        
    }
}

- (void)willRotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation duration:(NSTimeInterval)duration {
    
    [self dismissKeyboard];
    
    UIInterfaceOrientation currentOrientation = [[UIApplication sharedApplication] statusBarOrientation];
    if ((UIDeviceOrientationIsLandscape(toInterfaceOrientation) && UIDeviceOrientationIsPortrait(currentOrientation)) || (UIDeviceOrientationIsPortrait(toInterfaceOrientation) && UIDeviceOrientationIsLandscape(currentOrientation))) {
        
        self.cardOverlayView.frame = CGRectMake(0, 0, self.originalContentView.frame.size.height, self.originalContentView.frame.size.width);
    }
    
    if (UIDeviceOrientationIsLandscape(toInterfaceOrientation)) {
        
        self.cardOverlayReviewArtMenu.hidden = YES;
        self.cardOverlayBottomView.hidden = YES;
        self.logoImageView.hidden = YES;
        self.cardOverlayQuestionView.hidden = YES;
        self.topView.hidden = YES;
        self.scorePlaceholderView.hidden = YES;
        
        
        if (self.continueButton) {
            self.continueButton.hidden = YES;
        }
        if (self.backButton) {
            self.backButton.hidden = YES;
        }
        if (self.giveUpButton) {
            self.giveUpButton.hidden = YES;
        }
        
    }
    else if (UIDeviceOrientationIsPortrait(toInterfaceOrientation)){
        
        self.logoImageView.hidden = NO;
        self.cardOverlayQuestionView.hidden = NO;
        self.topView.hidden = NO;
        self.scorePlaceholderView.hidden = NO;
        
        if (self.isOKToShowNavigationBar) {
            if (self.continueButton) {
                self.continueButton.hidden = NO;
            }
            if (self.backButton) {
                self.backButton.hidden = NO;
            }
            if (self.giveUpButton) {
                self.giveUpButton.hidden = NO;
            }
        }
        
        if (self.isOKToShowReviewMenu) {
            self.cardOverlayReviewArtMenu.hidden = NO;
        }
        
        if (self.isOKToShowBottomView) {
            self.cardOverlayBottomView.hidden = NO;
        }
        
    }
    
    self.roundStatusView.frame = [self makeCardOverlayRoundStatusViewFrameWithCard:self.selectedCard withScreenOrientation:toInterfaceOrientation];
    self.roundTimerLabel.frame = self.roundStatusView.bounds;
    self.cardOverlayScrollView.frame = [self makeCardOverlayScrollViewFrameWithCard:self.selectedCard withScreenOrientation:toInterfaceOrientation];
    
    // handles the rotation for card with landscape orientation
   /* if (UIDeviceOrientationIsPortrait(toInterfaceOrientation)) {
        CGFloat rotationAngle;
        if ([self.selectedCard.orientation  isEqual: @"portrait"]) {
            rotationAngle = 0;
        } else {
            rotationAngle = - M_PI_2;
        }
        
        UIView *tempView = [[UIView alloc] initWithFrame:self.cardOverlayScrollView.frame];
        CGAffineTransform trans = CGAffineTransformRotate(tempView.transform,rotationAngle);
        tempView.transform = trans;
        self.cardOverlayScrollView.frame = tempView.frame;
    }*/
    
}

- (void)didRotateFromInterfaceOrientation:(UIInterfaceOrientation)fromInterfaceOrientation {
    [self setZoomMinimumForView:self.cardOverlayScrollView withCardOrientation:self.selectedCard.orientation];
    [self.cardOverlayScrollView setZoomScale:self.cardOverlayScrollView.minimumZoomScale animated:YES];
}

- (CGFloat)setZoomMinimumForView:(UIScrollView *)scrollView withCardOrientation:(NSString *)cardOrientation {
    
    CGFloat scaleWidth;
    CGFloat scaleHeight;
    CGFloat minScale;
    
    
    
    scaleWidth = scrollView.bounds.size.width / self.cardOverlayFrontImageView.image.size.width;
    scaleHeight = scrollView.bounds.size.height / self.cardOverlayFrontImageView.image.size.height;
    
    
    UIInterfaceOrientation screenOrientation = [[UIApplication sharedApplication] statusBarOrientation];
    
    CGFloat zoomRatio;
    if (IS_OldIphone && [cardOrientation isEqualToString:@"portrait"] && UIDeviceOrientationIsPortrait(screenOrientation)) {
        zoomRatio = cardOverlayImageZoomIphone4Ratio;
    } else if (IS_IPHONE_5 && [cardOrientation isEqualToString:@"portrait"] && UIDeviceOrientationIsPortrait(screenOrientation)) {
        zoomRatio = cardOverlayImageZoomIphone5RatioPortrait;
    } else if (IS_IPAD && [cardOrientation isEqualToString:@"portrait"] && UIDeviceOrientationIsPortrait(screenOrientation) ) {
        zoomRatio = cardOverlayImageZoomIpadRatioPortrait;
    } else if (IS_IPAD && [cardOrientation isEqualToString:@"landscape"] ) {
        zoomRatio = cardOverlayImageZoomIpadRatioLandscape;
    } else {
        zoomRatio = cardOverlayImageZoomIphoneDefaultRatio;
    }
    
    minScale = MIN(scaleWidth, scaleHeight) / zoomRatio; //come back
    scrollView.minimumZoomScale = minScale;
    
    return minScale;
    
}


- (void)initializeCardGlobalVariables {
    self.isShowingImageSide = YES;
    self.isShowingAnswerForFirstTime = NO;
    self.isShowingQuestionForFirstTime = NO;
    self.isOKToShowQuestion = NO;
    self.isOkToShowAnswer = NO;
    self.isShowingAnswerLabel = NO;
    self.isShowingQuestionLabel = NO;
    self.flippingCardInProgress = NO;
    self.hidingCardOverlayInProgress = NO;
    self.flippingToHideCardOverlayInProgress = NO;
    self.isOKForCardStackAnswerTextFieldToBlink = YES;
    self.iscardStackAnswerTextFieldGrowing = YES;
    self.isCountdownTimerShowingBlack = YES;
    self.isShowingFullAnswerMenu = NO;
    self.isOKToShowReviewMenu = NO;
    self.isOKToShowBottomView = NO;
    self.isOKForStartButtonToBlink = YES;
    self.isStartButtonBlinked = NO;
    self.answerHintCounter = 0;
    self.isRepeatPlayOfCard = NO;
}

#pragma mark Game Overlay View Creation Methods

-(void)viewWillLayoutSubviews {

    self.cardOverlayView.frame = self.originalContentView.bounds;
    
    UIInterfaceOrientation currentOrientation = [[UIApplication sharedApplication] statusBarOrientation];
    
    self.cardOverlayScrollView.frame = [self makeCardOverlayScrollViewFrameWithCard:self.selectedCard withScreenOrientation:currentOrientation];
    [self.cardOverlayScrollView setZoomScale:self.cardOverlayScrollView.minimumZoomScale animated:NO];
    [self centerScrollViewContents];
}

/*- (void)updateForCardOverlayViewBoundsChange {
    
    UIInterfaceOrientation currentOrientation = [[UIApplication sharedApplication] statusBarOrientation];

    self.cardOverlayScrollView.frame = [self makeCardOverlayScrollViewFrameWithCard:self.selectedCard withScreenOrientation:currentOrientation];
    [self.cardOverlayScrollView setZoomScale:self.cardOverlayScrollView.minimumZoomScale animated:NO];
    [self centerScrollViewContents];
    //CGAffineTransform transform = self.cardOverlayScrollView.transform;
    //self.cardOverlayScrollView.frame =
    
    NSLog(@"scrollview: %@",self.cardOverlayScrollView);
}*/

- (void)makeCardOverlayViewWithCard:(ARTCard *)card {
    
    CGRect cardOverlayViewShape = self.originalContentView.bounds;
    self.cardOverlayView = [[ARTCardOverlayView alloc] initWithFrame:cardOverlayViewShape];
    self.cardOverlayView.delegateController = self;
    [self.originalContentView addSubview:self.cardOverlayView];
    
    NSLayoutConstraint *labelConstraintTop = [NSLayoutConstraint constraintWithItem:self.originalContentView attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:self.cardOverlayView attribute:NSLayoutAttributeTop multiplier:NSLayoutRelationEqual constant:0.0];
    
    NSLayoutConstraint *labelConstraintBottom = [NSLayoutConstraint constraintWithItem:self.originalContentView attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:self.cardOverlayView attribute:NSLayoutAttributeBottom multiplier:NSLayoutRelationEqual constant:0.0];
    
    NSLayoutConstraint *labelConstraintLeft = [NSLayoutConstraint constraintWithItem:self.originalContentView attribute:NSLayoutAttributeLeft relatedBy:NSLayoutRelationEqual toItem:self.cardOverlayView attribute:NSLayoutAttributeLeft multiplier:NSLayoutRelationEqual constant:0.0];
    
    NSLayoutConstraint *labelConstraintRight = [NSLayoutConstraint constraintWithItem:self.originalContentView attribute:NSLayoutAttributeRight relatedBy:NSLayoutRelationEqual toItem:self.cardOverlayView attribute:NSLayoutAttributeRight multiplier:NSLayoutRelationEqual constant:0.0];
    
    [self.originalContentView addConstraints:@[labelConstraintTop,labelConstraintBottom,labelConstraintLeft,labelConstraintRight]];
    
    [self.originalContentView layoutIfNeeded];
    [self.cardOverlayView layoutIfNeeded];
    
    self.cardOverlayView.backgroundColor = self.originalContentView.backgroundColor;
    
    self.logoImageView = [self makeLogoImageView];
    
    //setup status view, with timer label setup right after since it depends on status view frame
    self.roundStatusView = [self makeCardOverlayRoundStatusViewOffScreen];
    self.roundStatusView.hidden = YES;
    self.roundStatusView.frame = [self moveFrame:self.roundStatusView.frame offScreenInDirection:kRight withScreenRatio:0.5];
    
    //setup bottom view
    self.cardOverlayBottomView = [self makeCardOverlayBottomView];
    self.cardOverlayBottomView.hidden = YES;
    self.cardOverlayBottomView.frame = [self moveFrame:self.cardOverlayBottomView.frame offScreenInDirection:kDown withScreenRatio:1.0];
    
    //setup question label
    [self setupCardOverlayQuestionViewWithCard:card withScreenOrientation:UIInterfaceOrientationPortrait];
    self.isShowingQuestionLabel = YES;
    self.cardOverlayQuestionView.alpha = 0.0;
    self.cardOverlayQuestionView.frame = [self moveFrame:self.cardOverlayQuestionView.frame offScreenInDirection:kDown withScreenRatio:1.0];
    
    UIFont *font = [self getFontForLabels];
    NSString *answerText = self.cardOverlayAnswerLabel.attributedText.string;
    NSMutableAttributedString *attrString = [self getAnswerTextforOriginalText:answerText andHintCount:[self getAnswerHintCount] toCheckMaxLength:NO];
    CGFloat widthForALabel = self.cardOverlayQuestionView.frame.size.width - self.cardOverlayAImageView.frame.size.width - self.cardOverlayAImageView.frame.origin.x - self.cardOverlayAnswerHintButton.frame.size.width - 10.0;
    self.cardOverlayAnswerLabel.frame = [self makeCardOverlayAnswerLabelFrameWithText:attrString.string withScreenOrientation:UIInterfaceOrientationPortrait withFont:font withWidth:widthForALabel];
    
    //setup answer label
    self.isShowingAnswerLabel = YES;
    
    //scrollView must be made after bottom view and scroll view because its based on its height
    self.cardOverlayScrollView = [self makeCardOverlayScrollViewWithCard:card];
    
    //setup answer menu view
    self.cardOverlayAnswerMenu = [self makeCardOverlayAnswerMenuOffScreen];
    
    //setup answer menu view
    self.cardOverlayReviewArtMenu = [self makeCardOverlayReviewArtMenuOffScreen];
    
    self.roundStatusDotView = [self makeRoundStatusDotViewHidden];
    
    [self.cardOverlayView addSubview:self.logoImageView];
    [self.cardOverlayView addSubview:self.cardOverlayScrollView];
    [self.cardOverlayView addSubview:self.roundStatusView];
    [self.cardOverlayView addSubview:self.roundStatusDotView];
    [self.cardOverlayView addSubview:self.cardOverlayQuestionView];
    [self.cardOverlayView addSubview:self.cardOverlayBottomView];
    [self.cardOverlayView addSubview:self.cardOverlayAnswerMenu];
    [self.cardOverlayView addSubview:self.cardOverlayReviewArtMenu];
    
}

- (UIImageView *)makeLogoImageView {
    
    CGFloat width;
    CGFloat height;
    if (IS_IPAD) {
        width = 220.0;
        height = 75.0;
    } else {
        width = 150.0;
        height = 50.0;
    }
    
    CGFloat x = (self.cardOverlayView.bounds.size.width - width) /2.0;
    CGFloat y = 21.0;
    
    CGRect frame = CGRectMake(x, y, width, height);
    
    UIImageView *imageView = [[UIImageView alloc] initWithFrame:frame];
    
    imageView.image = [UIImage new];
    
    UILabel *label = [[UILabel alloc] initWithFrame:imageView.bounds];
    label.textAlignment = NSTextAlignmentCenter;
    
    if ([self.currentGame.gameMode isEqual:@"single"]) {
        label.text = [self setupLogoImageviewFromString:self.selectedCard.category];
    } else {
        label.text = [self setupDateStringFromString:self.selectedCard.category];
    }
    
    if ([[[ARTUserInfo sharedInstance] getVisualTheme] isEqual:@"white"]) {
        label.textColor = [UIColor blackColor];
    } else {
        label.textColor = [UIColor lightBlueColor];
    }
    label.numberOfLines = 0;
    
    if (IS_IPAD) {
        label.font = [UIFont fontWithName:@"HelveticaNeue-Medium" size:30];
    }
    else {
        label.font = [UIFont fontWithName:@"HelveticaNeue-Medium" size:20];
    }
    
    [imageView addSubview:label];
    
    if (self.topView) {
        [self.topView removeFromSuperview];
        self.topView = nil;
    }
    
    self.topView = [[ARTTopView alloc] init];
    
    
    [self.cardOverlayView addSubview:self.topView];
    [self.cardOverlayView sendSubviewToBack:self.topView];
    
    return imageView;
    
}

- (NSString *)setupDateStringFromString:(NSString *)cardString {
    
    NSString *YYYYMMDD = cardString;
    
    //  NSRange yearRange = NSMakeRange(0, 4);
    NSRange monthRange = NSMakeRange(4, 2);
    NSRange dayRange = NSMakeRange(6, 2);
    
    NSInteger monthInt = [[YYYYMMDD substringWithRange:monthRange] integerValue];
    NSDateFormatter *df = [[NSDateFormatter alloc] init] ;
    NSString *monthName = [[df monthSymbols] objectAtIndex:(monthInt-1)];
    
    //  NSString *year = [NSString stringWithFormat:@"%ld",(long)[[YYYYMMDD substringWithRange:yearRange] integerValue] ];
    NSString *month = [NSString stringWithFormat:@"%@",monthName];
    
    NSString *day = [NSString stringWithFormat:@"%ld",(long)[[YYYYMMDD substringWithRange:dayRange] integerValue]];
    
    return [NSString stringWithFormat:@"%@ %@",month,day];
}

- (NSString *)setupLogoImageviewFromString:(NSString *)cardString {
    
    NSString *category = cardString;
    
    NSString *questionNumber = [self.selectedCard.categoryNumber stringValue];
    
    return [NSString stringWithFormat:@"%@ #%@",category,questionNumber];
}

- (UIImageView *)makeCardOverlayImageViewWithCard:(ARTCard *)card forSide:(NSString *)sideString {
    
    NSString *cardFilename;
    if ([sideString  isEqual: @"front"]) {
        cardFilename = card.frontFilename;
    } else {
        cardFilename = card.backFilename;
    }
    
    UIImage *portraitImage = [[ARTImageHelper sharedInstance] getHQImageWithFileName:cardFilename ];
    
    UIImageView *imageView;
    //if ([card.orientation  isEqual: @"portrait"]) {
        imageView = [[UIImageView alloc] initWithImage:portraitImage];
        
    // } else {
    //    UIImage *landscapeImage = [[UIImage alloc] initWithCGImage:portraitImage.CGImage scale:1.0 orientation:UIImageOrientationRight];
        //     imageView = [[UIImageView alloc] initWithImage:landscapeImage];
        // }
    
    CGFloat imageViewWidth = imageView.image.size.width;
    CGFloat imageViewHeight = imageView.image.size.height;
    CGFloat imageViewX = 0.0;
    CGFloat imageViewY = 0.0;
    
    CGRect imageViewShape = CGRectMake(imageViewX, imageViewY, imageViewWidth, imageViewHeight);
    imageView.frame =  imageViewShape;
    
    if ([[[ARTUserInfo sharedInstance] getVisualTheme] isEqual:@"white"]) {
        
        CGFloat shadowOffset = [HQpixelsforPic floatValue] / 150.0 * shadowOffsetForDPI150;
        //add shadow
        imageView.layer.shadowColor = [UIColor blackColor].CGColor;
        imageView.layer.shadowOffset = CGSizeMake(shadowOffset, shadowOffset);

        imageView.layer.shadowOpacity = shadowOpacity;
        imageView.layer.shadowRadius = [HQpixelsforPic floatValue] / 150.0 * shadowRadiusForDPI150;
        imageView.layer.shadowPath = [UIBezierPath bezierPathWithRect:imageView.bounds].CGPath;
        
    } else {
        
    }
    
    imageView.clipsToBounds = NO;
    imageView.opaque = YES;
    
    return imageView;
}

- (ARTCardScrollView *)makeCardOverlayScrollViewWithCard:(ARTCard *)card {
    
    self.cardOverlayFrontImageView = [self makeCardOverlayImageViewWithCard:card forSide:@"front"];
    self.cardOverlayBackImageView = [self makeCardOverlayImageViewWithCard:card forSide:@"back"];
    
    CGRect cardViewShape = [self makeCardOverlayScrollViewFrameWithCard:card withScreenOrientation:UIInterfaceOrientationPortrait];
    
    CGFloat rotationAngle;
    if ([card.orientation  isEqual: @"portrait"]) {
        rotationAngle = 0;
    } else {
        rotationAngle = - M_PI_2;
    }
    
    ARTCardScrollView *scrollView = [[ARTCardScrollView alloc] initWithFrame:cardViewShape];
    scrollView.delegate = self;
    scrollView.contentSize = self.cardOverlayFrontImageView.image.size;
    
    //CGAffineTransform trans = CGAffineTransformRotate(scrollView.transform,rotationAngle);
    //scrollView.transform = trans;
    
    
    CGFloat minScale;
    if ([card.orientation  isEqual: @"portrait"]) {
        minScale = [self setZoomMinimumForView:scrollView withCardOrientation:@"portrait"];
    } else {
        minScale = [self setZoomMinimumForView:scrollView withCardOrientation:@"landscape"];
    }
    scrollView.maximumZoomScale = 1.0;
    scrollView.zoomScale = minScale;
    
    scrollView.showsHorizontalScrollIndicator = NO;
    scrollView.showsVerticalScrollIndicator = NO;
    
    UITapGestureRecognizer *doubleTapRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(scrollViewDoubleTapped:)];
    doubleTapRecognizer.numberOfTapsRequired = 2;
    doubleTapRecognizer.numberOfTouchesRequired = 1;
    doubleTapRecognizer.cancelsTouchesInView = NO;
    [scrollView addGestureRecognizer:doubleTapRecognizer];
    
    UITapGestureRecognizer *singleTapRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(scrollViewSingleTapped:)];
    singleTapRecognizer.numberOfTapsRequired = 1;
    singleTapRecognizer.numberOfTouchesRequired = 1;
    singleTapRecognizer.cancelsTouchesInView = NO;
    
    [scrollView addGestureRecognizer:singleTapRecognizer];
    
    if (self.isShowingImageSide) {
        [scrollView addSubview:self.cardOverlayFrontImageView];
    } else {
        [scrollView addSubview:self.cardOverlayBackImageView];
    }
    
    return scrollView;
}

- (void)setupCardOverlayQuestionViewWithCard:(ARTCard *)card withScreenOrientation:(UIInterfaceOrientation)screenOrientation {
    
    CGFloat xOffset;
    if (IS_IPAD) {
        xOffset = questionViewXOffsetIpad;
    } else {
        xOffset = questionViewXOffsetIphone;
    }
    
    CGRect initialShape= CGRectMake(xOffset, 0.0, self.originalContentView.frame.size.width - xOffset * 2.0, self.originalContentView.frame.size.height);
    self.cardOverlayQuestionView = [[UIView alloc] initWithFrame:initialShape];
    
    self.cardOverlayQuestionView.opaque = YES;
    if ([[[ARTUserInfo sharedInstance] getVisualTheme] isEqual:@"white"]) {
        self.cardOverlayQuestionView.backgroundColor = [UIColor colorWithRed:0.9 green:.92 blue:0.95 alpha:1.0];
        self.cardOverlayQuestionView.layer.borderWidth = 1.0;
        self.cardOverlayQuestionView.layer.borderColor = [UIColor blackColor].CGColor;
        
    }
    else {
        self.cardOverlayQuestionView.backgroundColor = [UIColor darkQuestionColor];
        self.cardOverlayQuestionView.layer.borderWidth = 1.0;
        self.cardOverlayQuestionView.layer.borderColor = [UIColor whiteColor].CGColor;
        
    }
    
    self.cardOverlayQuestionView.layer.cornerRadius=15.0;
    self.cardOverlayQuestionView.clipsToBounds = YES;
    self.cardOverlayQuestionView.userInteractionEnabled = YES; //touches will still pass through to scrollview
    
    self.cardOverlayQImageView = [self makeCardOverlayQImageView];
    
    CGFloat widthForQLabel = self.cardOverlayQuestionView.frame.size.width - self.cardOverlayQImageView.frame.size.width - self.cardOverlayQImageView.frame.origin.x;
    self.cardOverlayQuestionLabel = [self makeCardOverlayQuestionLabelWithCard:card withScreenOrientation:screenOrientation withWidth:widthForQLabel];
    
    self.cardOverlayAImageView = [self makeCardOverlayAImageView];
    self.cardOverlayAnswerHintButton = [self makeAnswerHintButtonWithinShape:self.cardOverlayQuestionView.frame];
    
    CGFloat widthForALabel = self.cardOverlayQuestionView.frame.size.width - self.cardOverlayAImageView.frame.size.width - self.cardOverlayAImageView.frame.origin.x - self.cardOverlayAnswerHintButton.frame.size.width - 10.0;
    self.cardOverlayAnswerLabel = [self makeCardOverlayAnswerLabelWithCard:card withScreenOrientation:screenOrientation withWidth:widthForALabel];
    
    
    [self.cardOverlayQuestionView addSubview:self.cardOverlayQImageView];
    [self.cardOverlayQuestionView addSubview:self.cardOverlayQuestionLabel];
    //[view addSubview:self.cardOverlayAnswerBackground];
    [self.cardOverlayQuestionView addSubview:self.cardOverlayAImageView];
    [self.cardOverlayQuestionView addSubview:self.cardOverlayAnswerLabel];
    [self.cardOverlayQuestionView addSubview:self.cardOverlayAnswerHintButton];
    
    
    CGRect updatedShape = self.cardOverlayQuestionView.frame;
    CGFloat newHeight = self.cardOverlayAImageView.frame.origin.y+ MAX(self.cardOverlayAnswerLabel.frame.size.height,MAX(self.cardOverlayAImageView.frame.size.height,self.cardOverlayAnswerHintButton.frame.size.height)) + 5.0;
    updatedShape.size.height = newHeight;
    
    self.cardOverlayQuestionView.frame = [self makeCardOverlayQuestionViewFrameWithSize:updatedShape.size withScreenOrientation:screenOrientation];
    
    
    
    UITapGestureRecognizer *singleTapRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(questionViewTapped:)];
    singleTapRecognizer.numberOfTapsRequired = 1;
    singleTapRecognizer.numberOfTouchesRequired = 1;
    singleTapRecognizer.cancelsTouchesInView = YES;
    [self.cardOverlayQuestionView addGestureRecognizer:singleTapRecognizer];
    
}


- (UIImageView *)makeCardOverlayQImageView {
    
    CGRect shape = [self makeCardOverlayQImageViewFrame];
    
    UIImageView *imageView = [[UIImageView alloc] initWithFrame:shape];
    imageView.image = [UIImage imageNamed:@"QLabel"];
    imageView.contentMode = UIViewContentModeScaleAspectFit;
    imageView.opaque = YES;
    imageView.backgroundColor = self.cardOverlayQuestionView.backgroundColor;
    
    
    return imageView;
}

- (UIImageView *)makeCardOverlayAImageView {
    
    CGRect shape = [self makeCardOverlayAImageViewFrame];
    
    UIImageView *imageView = [[UIImageView alloc] initWithFrame:shape];
    imageView.image = [UIImage imageNamed:@"ALabel"];
    imageView.contentMode = UIViewContentModeScaleAspectFit;
    imageView.opaque = YES;
    imageView.backgroundColor = self.cardOverlayQuestionView.backgroundColor;
    
    
    return imageView;
}

- (ARTButton *)makeAnswerHintButtonWithinShape:(CGRect)shape {
    
    NSMutableAttributedString *attrString = [self getHintButtonAttrText];
    
    
    CGRect frame = [self makeAnswerHintButtonFrameWithinShape:shape WithTitle:attrString WithScreenOrientation:UIInterfaceOrientationPortrait];
    ARTButton *button = [[ARTButton alloc] initWithFrame:frame];
    
    [button applyStandardFormatting];
    
    [button setAttributedTitle:attrString forState:UIControlStateNormal];
    
    
    UITapGestureRecognizer *buyTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(hintTapDetected:)];
    buyTap.numberOfTapsRequired = 1;
    buyTap.cancelsTouchesInView = YES;
    button.userInteractionEnabled = YES;
    [button addGestureRecognizer:buyTap];
    
    return button;
}


- (NSMutableAttributedString *)getHintButtonAttrText {
    
    UIFont * font = [self getFontForLabels];
    
    UIColor *color = [UIColor whiteColor];
    NSInteger hintCount = [self getAnswerHintCount];
    NSInteger hintsLeft = MAX(0, maxHintCount - hintCount);
    
    NSString *string = [NSString stringWithFormat:@"Hints: %ld",(long)hintsLeft];
    
    return [[NSMutableAttributedString alloc] initWithString:string attributes:@{NSFontAttributeName:font,NSForegroundColorAttributeName:color}];
}

- (UIFont *)getFontForLabels {
    
    NSInteger fontSize;
    if (IS_OldIphone) {
        fontSize = 16.; //custom font
    }
    else if (IS_IPHONE_5) {
        fontSize = 18.; //custom font
    }
    else if (IS_IPHONE_6) {
        fontSize = 20.; //custom font
    }
    else if (IS_IPHONE_6Plus) {
        fontSize = 21.; //custom font
    }
    else if (IS_IPAD) {
        fontSize = 30.;
    }
    else {
        fontSize = 14.0;
    }
    
    UIFont *customFont = [UIFont fontWithName:@"ArialMT" size:fontSize]; //custom font
    
    return customFont;
}


- (ARTLabel *)makeCardOverlayQuestionLabelWithCard:(ARTCard *)card withScreenOrientation:(UIInterfaceOrientation)screenOrientation withWidth:(CGFloat)viewWidth {
    
    NSString *text = [[NSString stringWithFormat:@"%@", card.questionText] stringByAppendingString:[NSString stringWithFormat:@""]];
    
    UIFont *customFont = [self getFontForLabels]; //custom font
    
    CGRect shape = [self makeCardOverlayQuestionLabelFrameWithText:text
                                             withScreenOrientation:screenOrientation
                                                          withFont:customFont
                                                         withWidth:viewWidth];
    ARTLabel *label = [[ARTLabel alloc] initWithFrame:shape];
    
    if ([[[ARTUserInfo sharedInstance] getVisualTheme] isEqual:@"white"]) {
        label.textColor = [UIColor blackColor];
    }
    else {
        label.textColor = [UIColor whiteColor];
        
    }
    
    label.font = customFont;
    label.text = text;
    
    label.layer.backgroundColor = self.cardOverlayQuestionView.backgroundColor.CGColor;
    
    
    UIFont *font = customFont;
    NSInteger maxSize = customFont.pointSize;
    NSInteger minSize = 1;
    
    CGFloat inset;
    if (IS_IPAD) {
        inset = edgeInsetOffsetIpad;
    } else {
        inset = edgeInsetOffsetIphone;
    }
    
    CGSize maximumLabelSize = CGSizeMake(shape.size.width - 2 * inset, MAXFLOAT);
    
    // start with maxSize and keep reducing until it doesn't clip
    for(NSInteger i = maxSize; i >= minSize; i--) {
        font = [font fontWithSize:i];
        
        
        // This step checks how tall the label would be with the desired font.
        
        CGRect textRect = [label.text boundingRectWithSize:maximumLabelSize
                                                   options:(NSStringDrawingUsesLineFragmentOrigin|NSStringDrawingUsesFontLeading)
                                                attributes:@{NSFontAttributeName:font}
                                                   context:nil];
        if(textRect.size.height <= shape.size.height - inset * 2.0)
            break;
    }
    // Set the UILabel's font to the newly adjusted font.
    label.font = font;
    
    CGRect textRect = [label.text boundingRectWithSize:maximumLabelSize
                                               options:(NSStringDrawingUsesLineFragmentOrigin|NSStringDrawingUsesFontLeading)
                                            attributes:@{NSFontAttributeName:font}
                                               context:nil];
    
    shape.size.height = ceil(textRect.size.height) + inset * 2.0;
    label.frame = shape;
    
    label.numberOfLines = 0;
    label.lineBreakMode = NSLineBreakByWordWrapping;
    
    
    return label;
}

- (ARTLabel *)makeCardOverlayAnswerLabelWithCard:(ARTCard *)card withScreenOrientation:(UIInterfaceOrientation)screenOrientation withWidth:(CGFloat)viewWidth{
    
    NSInteger maxTextLength = 0;
    NSMutableAttributedString *maxAttrString;
    for (NSInteger i = 0; i < maxHintCount + 1; i++) {
        NSMutableAttributedString *attrString = [self getAnswerTextforOriginalText:card.answerText andHintCount:i toCheckMaxLength:YES];
        
        if (attrString.length > maxTextLength) {
            maxAttrString = attrString;
            maxTextLength = attrString.length;
        }
        
    }
    
    UIFont *customFont = [self getFontForLabels]; //custom font
    
    NSString *string = maxAttrString.string;
    CGRect shape = [self makeCardOverlayAnswerLabelFrameWithText:string
                                           withScreenOrientation:screenOrientation
                                                        withFont:customFont
                                                       withWidth:viewWidth];
    string = nil;
    
    ARTLabel *label = [[ARTLabel alloc] initWithFrame:shape];
    
    NSInteger hintCount = [self getAnswerHintCount];
    NSMutableAttributedString *attrString = [self getAnswerTextforOriginalText:card.answerText andHintCount:hintCount toCheckMaxLength:NO];
    
    label.attributedText = attrString;
    label.numberOfLines = 0;
    label.lineBreakMode = NSLineBreakByWordWrapping;
    
    label.layer.backgroundColor = self.cardOverlayQuestionView.backgroundColor.CGColor;
    
    label.layer.cornerRadius = 5.0;
    label.clipsToBounds = YES;
    
    return label;
}

- (UIView *)makeRoundStatusDotViewHidden {
    CGFloat diameter;
    if (IS_IPAD || [[[ARTUserInfo sharedInstance] getVisualTheme] isEqual:@"white"]) {
        diameter = 7.0;
    } else {
        diameter = 5.0;
    }
    
    CGRect clearFrame = self.roundStatusView.frame;
    UIView *clearView = [[UIView alloc] initWithFrame:clearFrame];
    clearView.backgroundColor = [UIColor clearColor];
    clearView.hidden = YES;
    
    
    CGRect frame = CGRectMake(0.0, 0.0, diameter, diameter);
    UIView *view = [[UIView alloc] initWithFrame:frame];
    view.layer.cornerRadius = frame.size.height / 2.0;
    view.center = CGPointMake(clearView.bounds.size.width/2.0, self.roundStatusView.layer.borderWidth/2.0);
    [clearView addSubview:view];
    
    UIColor *color;
    if ([[[ARTUserInfo sharedInstance] getVisualTheme] isEqual:@"white"]) {
        view.layer.borderColor = [UIColor blackColor].CGColor;
        color = [UIColor lightBlueColor];
    }
    else {
        color = [UIColor whiteColor];
    }
    view.backgroundColor = color;
    
    return clearView;
}

- (void)animateRoundStatusDotView {
    
    CGFloat incrementTime = .497;
    
    CGAffineTransform nextTransform = CGAffineTransformRotate(self.roundStatusDotView.transform, .499*2.*M_PI);
    CGAffineTransform finalTransform = CGAffineTransformRotate(self.roundStatusDotView.transform, .5*2.*M_PI);
    
    if (self.isOKForAnimateRoundStatusViewDot) {
        self.roundStatusDotView.center = self.roundStatusView.center;
        
        
        [UIView animateWithDuration:incrementTime
                              delay:0.0
                            options:UIViewAnimationOptionCurveLinear | UIViewAnimationOptionAllowAnimatedContent | UIViewAnimationOptionBeginFromCurrentState
                         animations:^{
                             self.roundStatusDotView.transform = nextTransform;
                             
                         }
                         completion:^(BOOL finished) {
                             //   CGFloat nextProgress =  ((NSInteger)round((( progress + 1./increments ) * increments)) % incrementsInt ) / increments;
                             self.roundStatusDotView.transform = finalTransform;
                             [self animateRoundStatusDotView];
                         }];
        
    } else {
        self.roundStatusDotView.hidden = YES;
        
    }
    
}


- (NSMutableAttributedString *)getAnswerTextforOriginalText:(NSString *)originalText andHintCount:(NSInteger)hintCount toCheckMaxLength:(BOOL)maxLengthIndicator {
    
    UIFont * font = [self getFontForLabels];
    
    UIColor *color;
    if ([[[ARTUserInfo sharedInstance] getVisualTheme] isEqual:@"white"]) {
        color = [UIColor blackColor];
    }
    else {
        color = [UIColor whiteColor];
    }
    
    
    NSInteger correctKeywordCount = 0;
    for (NSNumber *keywordCorrectNumb in self.selectedCard.answerObject.answerKeywordsCorrect) {
        if ([keywordCorrectNumb boolValue]) {
            correctKeywordCount++;
        }
    }
    
    if (hintCount == 0 && correctKeywordCount == 0) {
        
        NSMutableAttributedString *firstString = [[NSMutableAttributedString alloc] initWithString:@"" attributes:@{NSUnderlineStyleAttributeName: @(NSUnderlineStyleNone),NSFontAttributeName:font,NSForegroundColorAttributeName:color}];
        
        NSInteger answerKeywordCount = self.selectedCard.answerObject.answerKeywordObjects.count;
        NSString *string;
        if (answerKeywordCount == 1) {
            string = [NSString stringWithFormat:@"(1 word)"];
        } else {
            string = [NSString stringWithFormat:@"(%ld words)",(long)answerKeywordCount];
        }
        NSMutableAttributedString *keywordCountAttrString = [[NSMutableAttributedString alloc] initWithString:string attributes:@{NSUnderlineStyleAttributeName: @(NSUnderlineStyleNone),NSFontAttributeName:font,NSForegroundColorAttributeName:color}];
        
        [firstString appendAttributedString:keywordCountAttrString];
        
        return firstString;
    }
    
    else {
        
        /*UIColor *color;
         if ([[[ARTUserInfo sharedInstance] getVisualTheme] isEqual:@"white"]) {
         color = [UIColor purpleColor];
         }
         else {
         color = [UIColor orangeColor];
         }*/
        
        NSString *customText = [originalText stringByReplacingOccurrencesOfString:@" " withString:@"   "];
        customText = [customText stringByReplacingOccurrencesOfString:@"-" withString:@" - "];
        
        NSMutableAttributedString *attrString = [[NSMutableAttributedString alloc] initWithString:customText attributes:@{NSUnderlineStyleAttributeName: @(NSUnderlineStyleNone),NSFontAttributeName:font,NSForegroundColorAttributeName:color}];
        
        NSArray *answerKeywordObjects = self.selectedCard.answerObject.answerKeywordObjects;
        for (NSInteger i = 0; i < answerKeywordObjects.count; i++) {
            NSString *answerKeyword = [self.selectedCard.answerObject getKeywordForAnswerObjectAtIndex:i];
            NSRange keywordRange = [attrString.string rangeOfString:answerKeyword];
            
            BOOL keywordAnswered = [self.selectedCard.answerObject.answerKeywordsCorrect[i] boolValue];
            if (!keywordAnswered) {
                
                NSInteger length = answerKeyword.length;
                NSMutableAttributedString *underscoreString = [[NSMutableAttributedString alloc] initWithString:@"" attributes:@{NSUnderlineStyleAttributeName: @(NSUnderlineStyleNone),NSFontAttributeName:font,NSForegroundColorAttributeName:color}];
                
                if (hintCount == 0 ) {
                    NSString *wordUnderscore = [self getUnderscoreStringForWordWithLength:answerKeyword.length];
                    
                    [underscoreString appendAttributedString:[[NSMutableAttributedString alloc] initWithString:wordUnderscore attributes:@{NSUnderlineStyleAttributeName: @(NSUnderlineStyleNone),NSFontAttributeName:font,NSForegroundColorAttributeName:color}]];
                }
                else {
                    
                    for (NSInteger j = 0; j < length; j++) {
                        
                        NSString *charString = [self getCharacterAtIndex:j forKeywordIndex:i forHintCount:hintCount toCheckMaxLength:maxLengthIndicator] ;
                        NSMutableAttributedString *charAttrString;
                        if (![charString isEqualToString:@"_"]) {
                            charAttrString = [[NSMutableAttributedString alloc] initWithString:charString attributes:@{NSFontAttributeName:font,NSForegroundColorAttributeName:color,NSUnderlineStyleAttributeName:@(NSUnderlineStyleSingle)}];
                        }
                        else {
                            charAttrString = [[NSMutableAttributedString alloc] initWithString:charString attributes:@{NSUnderlineStyleAttributeName: @(NSUnderlineStyleNone),NSFontAttributeName:font,NSForegroundColorAttributeName:color}];
                        }
                        
                        [underscoreString appendAttributedString:charAttrString];
                        
                        if ( j != length - 1) {
                            [underscoreString appendAttributedString:[[NSMutableAttributedString alloc] initWithString:@" " attributes:@{NSUnderlineStyleAttributeName: @(NSUnderlineStyleNone),NSFontAttributeName:font,NSForegroundColorAttributeName:color}]];
                        }
                        
                        if ( j == (length - 1) && i < (answerKeywordObjects.count - 1)) {
                            [underscoreString appendAttributedString:[[NSMutableAttributedString alloc] initWithString:@"" attributes:@{NSUnderlineStyleAttributeName: @(NSUnderlineStyleNone),NSFontAttributeName:font,NSForegroundColorAttributeName:color}]];
                        }
                        
                    }
                }
                
                
                //checking if the keyword is still not answered since another letter was filled in above
                BOOL keywordAnsweredCheck2 = [self.selectedCard.answerObject.answerKeywordsCorrect[i] boolValue];
                if (!keywordAnsweredCheck2) {
                    [attrString deleteCharactersInRange:keywordRange];
                    [attrString insertAttributedString:underscoreString atIndex:keywordRange.location];
                }
            }
        }
        
        for (NSInteger i = 0; i < answerKeywordObjects.count; i++) {
            NSString *answerKeyword = [self.selectedCard.answerObject getKeywordForAnswerObjectAtIndex:i];
            
            NSRange keywordRange2 = [attrString.string rangeOfString:answerKeyword];
            
            BOOL keywordAnswered = [self.selectedCard.answerObject.answerKeywordsCorrect[i] boolValue];
            if (keywordAnswered) {
                
                
                if (keywordRange2.location != NSNotFound) {
                    //answer found in string
                    
                    NSMutableAttributedString *answeredAttrString = [[NSMutableAttributedString alloc] initWithString:answerKeyword attributes:@{NSFontAttributeName:font,NSUnderlineStyleAttributeName:@(NSUnderlineStyleSingle),NSForegroundColorAttributeName:color}];
                    
                    NSMutableAttributedString *spaceAttrString = [[NSMutableAttributedString alloc] initWithString:@"" attributes:@{NSFontAttributeName:font,NSUnderlineStyleAttributeName:@(NSUnderlineStyleNone),NSForegroundColorAttributeName:color}];
                    
                    [answeredAttrString appendAttributedString:spaceAttrString];
                    
                    [attrString deleteCharactersInRange:keywordRange2];
                    [attrString insertAttributedString:answeredAttrString atIndex:keywordRange2.location];
                    
                    
                }
            }
        }
        
        return attrString;
        
    }
    
}

- (NSString *)getUnderscoreStringForWordWithLength:(NSInteger)length {
    
    NSString *string = @"_";
    
    if (length > 1) {
        string = [string stringByAppendingString:[self getUnderscoreStringForWordWithLength:(length-1)]];
    }
    
    return string;
}

- (NSString *)getCharacterAtIndex:(NSInteger)charIndex forKeywordIndex:(NSInteger)keywordIndex forHintCount:(NSInteger)hintCount toCheckMaxLength:(BOOL)maxLengthIndicator {
    
    NSString *keywordAtIndex = [self.selectedCard.answerObject getKeywordForAnswerObjectAtIndex:keywordIndex];
    NSString *hintAtIndex = [self.selectedCard.answerObject getHintForAnswerObjectAtIndex:keywordIndex withHintCount:hintCount];
    
    
    if (hintCount >= 1) {
        
        //find LAST OCCURENCE of hint string
        NSRange hintRange = [keywordAtIndex rangeOfString:hintAtIndex options:NSBackwardsSearch];
        
        NSInteger start = hintRange.location;
        NSInteger stop = start + hintRange.length;
        
        if (charIndex >= start && charIndex < stop) {
            
            if (!maxLengthIndicator) {
                [self.currentGame checkCorrectAnswerInString:hintAtIndex forCard:self.selectedCard wholeWord:YES]; //check if hint fills in the whole answer
                
                if([self.currentGame checkAllAnswerKeywordsCorrectForCard:self.selectedCard] && self.currentGame.questionRemainingTime > 0.0) {
                    [self allAnswersCorrectForCardWithTimeRemaining:YES];
                }
            }
            
            NSRange charRange = NSMakeRange(charIndex, 1);
            return [keywordAtIndex substringWithRange:charRange];
        }
        
    }
    
    return @"_";
}


- (ARTMenuObject *)makeCardOverlayQuestionMenu {
    
    CGRect menuShape = [self makeCardOverlayQuestionMenuFrame];
    
    ARTMenuObject *menu = [[ARTMenuObject alloc] initWithButtonCount:1
                                                           withFrame:menuShape
                                               withPortraitIndicator:NO];
    
    UIFont * font;
    if (IS_IPAD) {
        font = [UIFont fontWithName:@"HelveticaNeue" size:29];
    }
    else {
        font = [UIFont fontWithName:@"HelveticaNeue" size:19];
    }
    
    UIColor *color = [UIColor whiteColor];
    
    UIButton *button = menu.arrayOfButtons[0];
    
    NSMutableAttributedString *attrString = [[NSMutableAttributedString alloc] initWithString:@"Hide Q&A" attributes:@{NSFontAttributeName:font,NSForegroundColorAttributeName:color}];
    [button setAttributedTitle:attrString forState:UIControlStateNormal];
    
    self.cardOverlayButtonTapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(showHideQuestionTapped:)];
    self.cardOverlayButtonTapGesture.numberOfTapsRequired = 1;
    button.userInteractionEnabled = YES;
    [button addGestureRecognizer:self.cardOverlayButtonTapGesture];
    
    
    return menu;
}

- (UITextField *)makeCardOverlayAnswerTextField {
    
    CGRect textShape = [self makeCardOverlayAnswerTextFieldFrame];
    
    
    UITextField *textField = [[UITextField alloc] initWithFrame:textShape];
    [textField.layer setBorderWidth:2.0];
    [textField.layer setBorderColor:[UIColor orangeColor].CGColor];
    
    [textField.layer setCornerRadius:15.0];
    
    UIFont * font;
    if (IS_IPAD) {
        font = [UIFont fontWithName:@"HelveticaNeue" size:29];
    }
    else {
        font = [UIFont fontWithName:@"HelveticaNeue" size:19];
    }
    
    textField.font = font;
    textField.clearButtonMode = UITextFieldViewModeWhileEditing;
    textField.delegate = self;
    textField.autocapitalizationType = UITextAutocapitalizationTypeNone;
    textField.autocorrectionType = UITextAutocorrectionTypeNo;
    textField.returnKeyType = UIReturnKeyDone;
    
    if ([[[ARTUserInfo sharedInstance] getVisualTheme] isEqual:@"white"]) {
        textField.backgroundColor = [UIColor whiteColor];
        textField.textColor = [UIColor blackColor];
        UIColor *color = [UIColor blackColor];
        textField.attributedPlaceholder = [[NSAttributedString alloc] initWithString:@"Type answer here" attributes:@{NSForegroundColorAttributeName: color}];
    } else {
        textField.keyboardAppearance = UIKeyboardAppearanceDark; //darkmode
        textField.backgroundColor = [UIColor blackColor];
        textField.textColor = [UIColor whiteColor];
        UIColor *color = [UIColor whiteColor];
        textField.attributedPlaceholder = [[NSAttributedString alloc] initWithString:@"Type answer here" attributes:@{NSForegroundColorAttributeName: color}];
    }
    
    textField.textAlignment = NSTextAlignmentCenter;
    
    return textField;
}

- (UIView *)makeCardOverlayBottomView {
    
    // overlay menu determines offset from question label based on text so it needs to come before the answer textfield is setup
    self.cardOverlayQuestionMenu = [self makeCardOverlayQuestionMenu];
    self.cardOverlayAnswerTextField = [self makeCardOverlayAnswerTextField];
    
    CGRect viewShape = [self makeCardOverlayBottomViewFrameScreenOrientation:UIInterfaceOrientationPortrait];
    
    UIView *bottomView = [[UIView alloc] initWithFrame:viewShape];
    
    [bottomView setBackgroundColor:[[UIColor whiteColor] colorWithAlphaComponent:0.0]];
    
    [bottomView addSubview:self.cardOverlayQuestionMenu];
    [bottomView addSubview:self.cardOverlayAnswerTextField];
    
    return bottomView;
}


- (UIView *)makeCardOverlayRoundStatusViewOffScreen {
    
    CGRect statusWindowShape = [self makeCardOverlayRoundStatusViewFrameWithCard:nil withScreenOrientation:UIInterfaceOrientationPortrait];
    
    UIView *view = [[UIView alloc] initWithFrame:statusWindowShape];
    view.layer.cornerRadius = statusWindowShape.size.height / 2.0; //half of rect height or width
    
    if ([[[ARTUserInfo sharedInstance] getVisualTheme] isEqual:@"white"]) {
        view.layer.borderColor = [UIColor whiteColor].CGColor;
        view.layer.borderWidth = 1.0;
        view.backgroundColor = [UIColor blueButtonColor];
        
    } else {
        view.layer.borderColor = [UIColor whiteColor].CGColor;
        view.layer.borderWidth = 1.5;
        view.backgroundColor = [UIColor blueButtonColor];
    }
    
    view.clipsToBounds = YES;
    
    self.roundTimerLabel = [self makeCardOverlayRoundLabelViewWithinView:view];
    [view addSubview:self.roundTimerLabel];
    
    return view;
}

- (UILabel *)makeCardOverlayRoundLabelViewWithinView:(UIView *)view {
    CGFloat statusWindowX = 5;
    CGFloat statusWindowY = 5;
    CGFloat statusWindowWidth = view.bounds.size.width - statusWindowX * 2;
    CGFloat statusWindowHeight = view.bounds.size.height - statusWindowY * 2;
    
    CGRect statusWindowShape = CGRectMake(statusWindowX, statusWindowY, statusWindowWidth, statusWindowHeight);
    UILabel *label = [[UILabel alloc] initWithFrame:statusWindowShape];
    
    if ([[[ARTUserInfo sharedInstance] getVisualTheme] isEqual:@"white"]) {
        label.textColor = [UIColor whiteColor];
    } else {
        label.textColor = [UIColor whiteColor];
    }
    
    label.textAlignment = NSTextAlignmentCenter;
    
    return label;
}

- (ARTMenuObject *)makeCardOverlayAnswerMenuOffScreen {
    
    CGRect menuShape = [self makeCardOverlayAnswerMenuFrameScreenOrientation:UIInterfaceOrientationPortrait];
    menuShape.origin.y += 200.0;
    
    
    ARTMenuObject *menu = [[ARTMenuObject alloc] initWithButtonCount:2
                                                           withFrame:menuShape
                                               withPortraitIndicator:NO];
    
    UIFont * font;
    if (IS_IPAD) {
        font = [UIFont fontWithName:@"HelveticaNeue" size:31];
    }
    else if (IS_IPHONE_5) {
        font = [UIFont fontWithName:@"HelveticaNeue" size:17];
    }
    else {
        font = [UIFont fontWithName:@"HelveticaNeue" size:21];
    }
    
    UIColor *color = [UIColor whiteColor];
    
    UIButton *button0 = menu.arrayOfButtons[0];
    NSMutableAttributedString *attrString = [[NSMutableAttributedString alloc] initWithString:@"Flip Question" attributes:@{NSFontAttributeName:font,NSForegroundColorAttributeName:color}];
    [button0 setAttributedTitle:attrString forState:UIControlStateNormal];
    
    UITapGestureRecognizer *flipCardGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(flipCardTapDetected:)];
    flipCardGesture.numberOfTapsRequired = 1;
    button0.userInteractionEnabled = YES;
    [button0 addGestureRecognizer:flipCardGesture];
    
    UIButton *button1 = menu.arrayOfButtons[1];
    NSString *string;
    
    //this is check before the card is played so check that 1 card remains
    if (self.selectedDeck.remainingCardCount == 1) {
        string = @"Topic Completed!";
        
        NSMutableAttributedString *nextCardString = [[NSMutableAttributedString alloc] initWithString:string attributes:@{NSFontAttributeName:font,NSForegroundColorAttributeName:color}];
        [button1 setAttributedTitle:nextCardString forState:UIControlStateNormal];
        
        UITapGestureRecognizer *finalScoreGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(topicCompletedTapped:)];
        finalScoreGesture.numberOfTapsRequired = 1;
        button1.userInteractionEnabled = YES;
        [button1 addGestureRecognizer:finalScoreGesture];
    }
    else {
        string = @"Next Question";
        
        NSMutableAttributedString *nextCardString = [[NSMutableAttributedString alloc] initWithString:string attributes:@{NSFontAttributeName:font,NSForegroundColorAttributeName:color}];
        [button1 setAttributedTitle:nextCardString forState:UIControlStateNormal];
        
        [button1 addImage:[UIImage imageNamed:@"forward"] rightSide:YES withXOffset:8.0];
        
        UITapGestureRecognizer *nextCardGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(nextCardButtonTapped:)];
        nextCardGesture.numberOfTapsRequired = 1;
        button1.userInteractionEnabled = YES;
        [button1 addGestureRecognizer:nextCardGesture];
    }
    
    return menu;
}

- (ARTMenuObject *)makeCardOverlayReviewArtMenuOffScreen {
    
    CGRect menuShape = [self makeCardOverlayAnswerMenuFrameScreenOrientation:UIInterfaceOrientationPortrait];
    menuShape.origin.y += 200.0;
    
    
    ARTMenuObject *menu = [[ARTMenuObject alloc] initWithButtonCount:1
                                                           withFrame:menuShape
                                               withPortraitIndicator:NO];
    
    UIFont * font;
    if (IS_IPAD) {
        font = [UIFont fontWithName:@"HelveticaNeue" size:36];
    }
    else {
        font = [UIFont fontWithName:@"HelveticaNeue" size:26];
    }
    
    
    UIColor *color = [UIColor whiteColor];
    
    NSString *text = [NSString stringWithFormat:@"Tap to Play"];
    
    UIButton *button0 = menu.arrayOfButtons[0];
    NSMutableAttributedString *attrString = [[NSMutableAttributedString alloc] initWithString:text attributes:@{NSFontAttributeName:font,NSForegroundColorAttributeName:color}];
    [button0 setAttributedTitle:attrString forState:UIControlStateNormal];
    
    UITapGestureRecognizer *startQuestionGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(startQuestionTapDetected:)];
    startQuestionGesture.numberOfTapsRequired = 1;
    button0.userInteractionEnabled = YES;
    [button0 addGestureRecognizer:startQuestionGesture];
    
    return menu;
}


#pragma mark Game Overlay Frame Creation Methods

- (CGRect)makeCardOverlayAnswerMenuFrameScreenOrientation:(UIInterfaceOrientation)screenOrientation {
    
    CGFloat menuXOffset = 5.0;
    CGFloat menuYOffset = 5.0; //from bottom
    
    CGFloat width;
    CGFloat height = 0.0;
    CGFloat x;
    CGFloat y;
    
    if (UIDeviceOrientationIsPortrait(screenOrientation)) {
        width = self.cardOverlayView.frame.size.width - menuXOffset * 2.0;
        
        if (IS_OldIphone) {
            height = gameMenusHeightOldIphone;
        } else if (IS_IPHONE_5){
            height = gameMenusHeightIphone5;
        } else if (IS_IPHONE_6){
            height = gameMenusHeightIphone6;
        } else if (IS_IPHONE_6Plus){
            height = gameMenusHeightIphone6Plus;
        } else if (IS_IPAD){
            height = gameMenusHeightIpad;
        }
        
        x = menuXOffset;
        y = self.cardOverlayView.frame.size.height - height - menuYOffset;
        
    } else {
        width = self.cardOverlayAnswerMenu.frame.size.width;
        
        if (IS_OldIphone) {
            height = gameMenusHeightOldIphone;
        } else if (IS_IPHONE_5){
            height = gameMenusHeightIphone5;
        } else if (IS_IPHONE_6){
            height = gameMenusHeightIphone6;
        } else if (IS_IPHONE_6Plus){
            height = gameMenusHeightIphone6Plus;
        } else if (IS_IPAD){
            height = gameMenusHeightIpad;
        }
        
        x = (self.cardOverlayView.frame.size.height - width) / 2.0;
        y = self.cardOverlayView.frame.size.width - height - menuYOffset;
    }
    
    CGRect shape = CGRectMake(x, y, width, height);
    
    return shape;
}

- (CGRect)makeCardOverlayQuestionMenuFrame {
    CGFloat menuXOffset = 5.0; //from right
    CGFloat menuYOffset = 5.0; //from top (question label)
    
    CGFloat menuWidth;
    if (IS_IPAD) {
        menuWidth = 190.0;
    } else {
        menuWidth = 110.0;
    }
    
    CGFloat menuHeight = 0.0;
    
    if (IS_OldIphone) {
        menuHeight = gameMenusHeightOldIphone;
    } else if (IS_IPHONE_5){
        menuHeight = gameMenusHeightIphone5;
    } else if (IS_IPHONE_6){
        menuHeight = gameMenusHeightIphone6;
    } else if (IS_IPHONE_6Plus){
        menuHeight = gameMenusHeightIphone6Plus;
    } else if (IS_IPAD){
        menuHeight = gameMenusHeightIpad;
    }
    
    CGFloat menuX = menuXOffset;
    CGFloat menuY = menuYOffset;
    
    CGRect menuShape = CGRectMake(menuX, menuY, menuWidth, menuHeight);
    
    return menuShape;
}

- (CGRect)makeCardOverlayAnswerTextFieldFrame {
    CGFloat textXOffset = 5.0; //from left
    
    CGRect menuShape = [self makeCardOverlayQuestionMenuFrame];
    
    CGFloat textX = menuShape.origin.x + menuShape.size.width + textXOffset;
    CGFloat textY = menuShape.origin.y;
    CGFloat textWidth = self.originalContentView.frame.size.width - menuShape.size.width - textXOffset - menuShape.origin.x * 2.0;
    CGFloat textHeight = menuShape.size.height;
    
    CGRect textShape = CGRectMake(textX, textY, textWidth, textHeight);
    
    return textShape;
}


- (CGRect)makeCardOverlayBottomViewFrameScreenOrientation:(UIInterfaceOrientation)screenOrientation {
    
    
    CGFloat viewXOffset = 0.0;
    CGFloat viewYOffset = 0.0; //from bottom
    
    CGFloat width;
    CGFloat height;
    CGFloat x;
    CGFloat y;
    
    CGRect menuShape = [self makeCardOverlayQuestionMenuFrame];
    
    if (UIDeviceOrientationIsPortrait(screenOrientation)) {
        width = self.cardOverlayView.frame.size.width-viewXOffset * 2.0;
        height = menuShape.size.height + 10.0;
        x = viewXOffset;
        y = self.cardOverlayView.frame.size.height - height - viewYOffset;
        
    } else {
        
        width = self.cardOverlayBottomView.frame.size.width;
        height = self.cardOverlayBottomView.frame.size.height;
        x = (self.cardOverlayView.frame.size.height - width) / 2.0;
        y = self.cardOverlayView.frame.size.width - height - viewYOffset;
    }
    
    CGRect shape = CGRectMake(x, y, width, height);
    
    return shape;
}

- (CGRect)makeCardOverlayQImageViewFrame {
    
    CGFloat xOffset = 5.0;
    CGFloat yOffset = 5.0;
    
    CGFloat width = 0.0;
    if (IS_OldIphone) {
        width = 25.0;
    } else if (IS_IPHONE_5) {
        width = 25.0;
    } else if (IS_IPHONE_6) {
        width = 30.0;
    } else if (IS_IPHONE_6Plus) {
        width = 32.0;
    } else if (IS_IPAD) {
        width = 55.0;
    }
    
    CGFloat height = width;
    CGFloat x = xOffset;
    CGFloat y = yOffset;
    
    CGRect shape = CGRectMake(x, y, width, height);
    
    return shape;
}

- (CGRect)makeCardOverlayAImageViewFrame {
    
    CGFloat xOffset = 5.0;
    CGFloat yOffset = 8.0; //from bottom of question label frame
    
    CGFloat width = 0.0;
    if (IS_OldIphone) {
        width = 25.0;
    } else if (IS_IPHONE_5) {
        width = 25.0;
    } else if (IS_IPHONE_6) {
        width = 30.0;
    } else if (IS_IPHONE_6Plus) {
        width = 32.0;
    } else if (IS_IPAD) {
        width = 55.;
    }
    
    CGFloat height = width;
    CGFloat x = xOffset;
    CGFloat y = yOffset + self.cardOverlayQuestionLabel.frame.origin.y+ self.cardOverlayQuestionLabel.frame.size.height;
    
    CGRect shape = CGRectMake(x, y, width, height);
    
    return shape;
}

- (CGRect)makeCardOverlayQuestionViewFrameWithSize:(CGSize)size withScreenOrientation:(UIInterfaceOrientation)screenOrientation {
    
    CGFloat yOffset  = 0.0; //up from middle of screen
    
    CGFloat xOffset;
    if (IS_IPAD) {
        xOffset = questionViewXOffsetIpad;
    } else {
        xOffset = questionViewXOffsetIphone;
    }
    
    
    CGFloat width = size.width;
    CGFloat height = size.height;
    //CGFloat x = (self.cardOverlayView.frame.size.width - width) / 2.0;
    //CGFloat y = (self.cardOverlayView.frame.size.height - height) / 2.0 - yOffset;
    
    CGRect bottomViewFrame = [self makeCardOverlayBottomViewFrameScreenOrientation:screenOrientation];
    
    CGFloat x = bottomViewFrame.origin.x + xOffset;
    CGFloat y = (bottomViewFrame.origin.y - height) - yOffset;
    
    
    CGRect shape = CGRectMake(x, y, width, height);
    
    return shape;
}



- (CGRect)makeCardOverlayQuestionLabelFrameWithText:(NSString *)text withScreenOrientation:(UIInterfaceOrientation)screenOrientation withFont:(UIFont *)font withWidth:(CGFloat)viewWidth{
    
    CGFloat xOffset = self.cardOverlayQImageView.frame.size.width + self.cardOverlayQImageView.frame.origin.x;
    CGFloat yOffset = 0.0;
    
    CGFloat insets;
    if (IS_IPAD) {
        insets = edgeInsetOffsetIpad;
    } else {
        insets = edgeInsetOffsetIphone;
    }
    
    CGFloat maxWidth = viewWidth - 2.0 * insets;
    CGFloat maxHeight = 240.0;
    if (IS_OldIphone) {
        maxHeight = maxHeight + (screenHeightOldIphone - screenHeightIphone5);
    } else if (IS_IPHONE_5){
        maxHeight = maxHeight;
    } else if (IS_IPHONE_6){
        maxHeight = maxHeight + (screenHeightIphone6 - screenHeightIphone5);
    } else if (IS_IPHONE_6Plus){
        maxHeight = maxHeight + (screenHeightIphone6Plus - screenHeightIphone5);
    } else if (IS_IPAD){
        maxHeight = maxHeight + (screenHeightIpad - screenHeightIphone5);
    }
    
    CGSize maximumLabelSize = CGSizeMake(maxWidth, maxHeight);
    
    CGRect textRect = [text boundingRectWithSize:maximumLabelSize
                                         options:(NSStringDrawingUsesLineFragmentOrigin|NSStringDrawingUsesFontLeading)
                                      attributes:@{NSFontAttributeName:font}
                                         context:nil];
    
    
    
    CGFloat height = MAX(ceil(textRect.size.height) + 2.0 * insets,60.0);
    CGFloat x = xOffset;
    CGFloat y = yOffset;
    
    CGRect shape = CGRectMake(x, y, viewWidth, height);
    
    return shape;
}

- (CGRect)makeCardOverlayAnswerLabelFrameWithText:(NSString *)text withScreenOrientation:(UIInterfaceOrientation)screenOrientation withFont:(UIFont *)font withWidth:(CGFloat)viewWidth{
    
    CGFloat xOffset = self.cardOverlayAImageView.frame.size.width + self.cardOverlayAImageView.frame.origin.x;
    
    CGFloat maxWidth = viewWidth;
    
    CGFloat insets;
    if (IS_IPAD) {
        insets = edgeInsetOffsetIpad;
    } else {
        insets = edgeInsetOffsetIphone;
    }
    
    CGSize maximumLabelSize = CGSizeMake(maxWidth - 2.0 * insets, CGFLOAT_MAX);
    
    CGRect textRect = [text boundingRectWithSize:maximumLabelSize
                                         options:(NSStringDrawingUsesLineFragmentOrigin|NSStringDrawingUsesFontLeading)
                                      attributes:@{NSFontAttributeName:font}
                                         context:nil];
    
    CGFloat height = MAX(ceil(textRect.size.height) + 2.0 * insets,00.0);
    CGFloat width = MAX(ceil(textRect.size.width) + 2.0 * insets,00.0);
    CGFloat x = xOffset;
    CGFloat y = self.cardOverlayAImageView.frame.origin.y;
    
    CGRect shape = CGRectMake(x, y, width, height);
    
    return shape;
}



- (CGRect)makeAnswerHintButtonFrameWithinShape:(CGRect)shape WithTitle:(NSMutableAttributedString *)attrString WithScreenOrientation:(UIInterfaceOrientation)screenOrientation {
    
    CGFloat height = 0.0;
    if (IS_OldIphone) {
        height = 35.0;
    } else if (IS_IPHONE_5) {
        height = 35.0;
    } else if (IS_IPHONE_6) {
        height = 40.0;
    } else if (IS_IPHONE_6Plus) {
        height = 40.0;
    } else if (IS_IPAD) {
        height = 65.0;
    }
    
    CGSize maxTextSize = CGSizeMake(shape.size.width, height);
    
    CGRect textRect = [attrString.string boundingRectWithSize:maxTextSize
                                                      options:(NSStringDrawingUsesLineFragmentOrigin|NSStringDrawingUsesFontLeading)
                                                   attributes:[attrString attributesAtIndex:0 effectiveRange:nil]
                                                      context:nil];
    
    CGFloat xOffset = 5.0; //from right
    
    CGFloat width = textRect.size.width + 20.0;
    
    CGFloat x = shape.size.width - width - xOffset;
    CGFloat y = self.cardOverlayAImageView.frame.origin.y;
    
    CGRect rect = CGRectMake(x, y, width, height);
    
    return rect;
}

- (CGRect)makeCardOverlayScrollViewFrameWithCard:(ARTCard *)card withScreenOrientation:(UIInterfaceOrientation)screenOrientation {
    
    CGFloat cardViewXOffset = cardOverlayXOffset;
    CGFloat cardViewYOffset = cardOverlayYOffset;
    
    CGFloat cardViewWidth;
    CGFloat cardViewHeight;
    CGFloat cardViewX;
    CGFloat cardViewY;
    
    CGFloat verticalAdjustment = 0.0;
    if (IS_OldIphone) {
        verticalAdjustment = scrollViewVerticalAdjustmentOldIphone;
    }
    else if (IS_IPHONE_5) {
        verticalAdjustment = scrollViewVerticalAdjustmentIphone5;
    }
    else if (IS_IPHONE_6) {
        verticalAdjustment = scrollViewVerticalAdjustmentIphone6;
    }
    else if (IS_IPHONE_6Plus) {
        verticalAdjustment = scrollViewVerticalAdjustmentIphone6Plus;
    }
    else if (IS_IPAD) {
        verticalAdjustment = scrollViewVerticalAdjustmentIpad;
    }
    
    //if (UIDeviceOrientationIsPortrait(screenOrientation)) {
        // if ([card.orientation  isEqual: @"portrait"]) {
            cardViewX = cardViewXOffset;
            cardViewY = cardViewYOffset;
            cardViewWidth = self.cardOverlayView.frame.size.width - cardViewX * 2;
            cardViewHeight = self.cardOverlayView.frame.size.height - cardViewY - verticalAdjustment;
            
        /*} else {
            cardViewWidth = self.cardOverlayView.frame.size.height - cardViewYOffset * 2  - verticalAdjustment;
            cardViewHeight = self.cardOverlayView.frame.size.width - cardViewXOffset * 2;
            cardViewX = cardViewXOffset - (cardViewWidth - cardViewHeight)/2;
            cardViewY = cardViewYOffset + (cardViewWidth - cardViewHeight)/2;
        }*/
   /* } else {
        
        cardViewX = 0.0;
        cardViewY = 0.0;
        cardViewWidth = self.originalContentView.frame.size.height;
        cardViewHeight = self.originalContentView.frame.size.width - cardViewY;
    }*/
    
    CGRect cardViewShape = CGRectMake(cardViewX, cardViewY, cardViewWidth, cardViewHeight);
    
    return cardViewShape;
}

- (CGRect)makeCardOverlayRoundStatusViewFrameWithCard:(ARTCard *)card withScreenOrientation:(UIInterfaceOrientation)screenOrientation {
    
    CGFloat statusX; //from right
    CGFloat statusY;
    CGFloat statusWidth;
    CGFloat statusHeight;
    
    //making a circle
    if (IS_IPAD) {
        statusWidth = cardStatusCardOverlayDiameterIpad;
        statusHeight = cardStatusCardOverlayDiameterIpad;
    } else if (IS_IPHONE_6 || IS_IPHONE_6Plus) {
        statusWidth = cardStatusCardOverlayDiameterIphone6;
        statusHeight = cardStatusCardOverlayDiameterIphone6;
    } else {
        statusWidth = cardStatusCardOverlayDiameterIphone;
        statusHeight = cardStatusCardOverlayDiameterIphone;
    }
    
    statusX = self.cardOverlayView.frame.size.width - statusWidth - cardStatusCardOverlayXOffset;
    statusY = cardStatusCardOverlayYOffset;
    
    
    
    CGRect statusShape = CGRectMake(statusX, statusY, statusWidth, statusHeight);
    
    return statusShape;
}




#pragma mark Other View Methods

- (CGRect)moveFrame:(CGRect)frame offScreenInDirection:(screenDirection)direction withScreenRatio:(CGFloat)ratio {
    
    if (direction == kRight) {
        frame.origin.x += self.originalContentView.bounds.size.width * ratio;
    }
    else if (direction == kLeft) {
        frame.origin.x -= self.originalContentView.bounds.size.width * ratio;
    }
    else if (direction == kUp) {
        frame.origin.y -= self.originalContentView.bounds.size.height * ratio;
    }
    else if (direction == kDown) {
        frame.origin.y += self.originalContentView.bounds.size.height * ratio;
    }
    
    return frame;
}

- (CGFloat)setZoomMinimumForView:(UIScrollView *)scrollView withCardOrientation:(NSString *)cardOrientation andScreenOrientationIsPortrait:(BOOL)screenOrientationIsPortrait {
    
    CGFloat scaleWidth;
    CGFloat scaleHeight;
    CGFloat minScale;
    
    //if ([cardOrientation  isEqual: @"portrait"]) {
        
        scaleWidth = scrollView.frame.size.width / self.cardOverlayFrontImageView.image.size.width;
        scaleHeight = scrollView.frame.size.height / self.cardOverlayFrontImageView.image.size.height;
        
    // } else {
        
    //     scaleWidth = scrollView.frame.size.width / self.cardOverlayFrontImageView.image.size.height;
    //     scaleHeight = scrollView.frame.size.height / self.cardOverlayFrontImageView.image.size.width;
        
    // }
    
    CGFloat zoomRatio;
    if (IS_OldIphone && [cardOrientation isEqualToString:@"portrait"] && screenOrientationIsPortrait) {
        zoomRatio = cardOverlayImageZoomIphone4Ratio;
    } else if (IS_IPHONE_5 && [cardOrientation isEqualToString:@"portrait"] && screenOrientationIsPortrait) {
        zoomRatio = cardOverlayImageZoomIphone5RatioPortrait;
    } else if (IS_IPAD && [cardOrientation isEqualToString:@"portrait"] && screenOrientationIsPortrait) {
        zoomRatio = cardOverlayImageZoomIpadRatioPortrait;
    } else if (IS_IPAD && [cardOrientation isEqualToString:@"landscape"]) {
        zoomRatio = cardOverlayImageZoomIpadRatioLandscape;
    } else {
        zoomRatio = cardOverlayImageZoomIphoneDefaultRatio;
    }
    
    minScale = MIN(scaleWidth, scaleHeight) / zoomRatio; //come back
    scrollView.minimumZoomScale = minScale;
    
    return minScale;
}

- (UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView {
    // Return the view that you want to zoom
    if (self.isShowingImageSide) {
        return self.cardOverlayFrontImageView;
    } else {
        return self.cardOverlayBackImageView;
    }
    
    
}

- (void)scrollViewDidZoom:(UIScrollView *)scrollView {
    // The scroll view has zoomed, so you need to re-center the contents
    [self centerScrollViewContents];
}

- (void)scrollViewDidEndZooming:(UIScrollView *)scrollView withView:(UIView *)view atScale:(CGFloat)scale {
    if (self.flippingCardInProgress) {
        self.flippingCardInProgress = NO;
        [self animateFlipCardViewsPart2];
    }
    else if (self.hidingCardOverlayInProgress) {
        self.hidingCardOverlayInProgress = NO;
        
        [self animateHideCardOverlayWithCard:self.selectedCard];
    }
    
}

- (void)centerScrollViewContents {
    
    CGSize boundsSize = self.cardOverlayScrollView.bounds.size;
    CGRect contentsFrame;
    
    if (self.isShowingImageSide) {
        contentsFrame =  self.cardOverlayFrontImageView.frame;
    } else {
        contentsFrame =  self.cardOverlayBackImageView.frame;
    }
    
    if (contentsFrame.size.width < boundsSize.width) {
        contentsFrame.origin.x = (boundsSize.width - contentsFrame.size.width) / 2.0;
    } else {
        contentsFrame.origin.x = 0.0;
    }
    
    if (contentsFrame.size.height < boundsSize.height) {
        contentsFrame.origin.y = (boundsSize.height - contentsFrame.size.height) / 2.0;
    } else {
        contentsFrame.origin.y = 0.0;
    }
    
    if (self.isShowingImageSide) {
        self.cardOverlayFrontImageView.frame = contentsFrame;
    } else {
        self.cardOverlayBackImageView.frame = contentsFrame;    }
    
}


#pragma mark Animation Methods

- (void)transitionfromView:(UIView *)currentView toView:(UIView *)nextView {
    
    [UIView transitionFromView:currentView
                        toView:nextView
                      duration:0.4
                       options:UIViewAnimationOptionTransitionCrossDissolve |UIViewAnimationOptionAllowAnimatedContent
                    completion:^(BOOL finished) {
                        if (finished) {
                            
                        }
                    }];
    
    
    
}

- (void)animateCardOverlayBottomViewOnScreen:(BOOL)onScreenIndicator {
    
    CGRect nextFrame;
    
    UIInterfaceOrientation screenOrientation = [[UIApplication sharedApplication] statusBarOrientation];
    
    CGFloat delay;
    if (onScreenIndicator) {
        //alphaLevel = 1.0;
        CGRect currentFrame = [self makeCardOverlayBottomViewFrameScreenOrientation:screenOrientation];
        self.cardOverlayBottomView.frame = [self moveFrame:currentFrame offScreenInDirection:kDown withScreenRatio:1.0];
        self.cardOverlayBottomView.hidden = NO;
        
        nextFrame = [self makeCardOverlayBottomViewFrameScreenOrientation:screenOrientation];
        
        delay = 0.6;
    } else {
        
        nextFrame = [self makeCardOverlayBottomViewFrameScreenOrientation:screenOrientation];
        nextFrame = [self moveFrame:nextFrame offScreenInDirection:kDown withScreenRatio:0.5];
        
        delay = 0.0;
    }
    
    
    [UIView animateWithDuration:0.5
                          delay:delay
         usingSpringWithDamping:0.8
          initialSpringVelocity:1.0
                        options:UIViewAnimationOptionCurveEaseInOut | UIViewAnimationOptionAllowAnimatedContent | UIViewAnimationOptionAllowUserInteraction
                     animations:^() {
                         self.cardOverlayBottomView.frame = nextFrame;
                     }
                     completion:^(BOOL finished) {
                         if (onScreenIndicator == YES) {
                             [self.cardOverlayBottomView setBackgroundColor:[[UIColor whiteColor] colorWithAlphaComponent:0.0]]; //this is a temp change
                         } else {
                             [self.cardOverlayBottomView setBackgroundColor:[[UIColor whiteColor] colorWithAlphaComponent:0.0]];
                             self.isOKToShowBottomView = NO;
                         }
                     }];
    
    
}

- (void)animateCardOverlayAnswerMenuOnScreen:(BOOL)onScreenIndicator withCard:(ARTCard *)card {
    
    CGFloat menuYOffset;
    
    if (onScreenIndicator) {
        menuYOffset = 5.0; //from bottom
        self.isShowingFullAnswerMenu = YES;
    } else {
        menuYOffset = -70.0; //from bottom
    }
    
    CGFloat menuWidth = self.cardOverlayAnswerMenu.frame.size.width;
    CGFloat menuHeight = self.cardOverlayAnswerMenu.frame.size.height;
    CGFloat menuX = self.cardOverlayAnswerMenu.frame.origin.x;
    CGFloat menuY = self.originalContentView.frame.size.height - menuHeight - menuYOffset;
    
    
    CGRect nextFrame = CGRectMake(menuX, menuY, menuWidth, menuHeight);
    
    CGFloat duration;
    if (onScreenIndicator) {
        duration = 0.6;
    } else {
        duration = 0.3;
    }
    
    [UIView animateWithDuration:duration
                          delay:0.0
         usingSpringWithDamping:0.7
          initialSpringVelocity:1.0
                        options:UIViewAnimationOptionCurveEaseInOut | UIViewAnimationOptionAllowAnimatedContent | UIViewAnimationOptionAllowUserInteraction
                     animations:^() {
                         self.cardOverlayAnswerMenu.frame = nextFrame;
                     }
                     completion:^(BOOL finished) {
                         if (!onScreenIndicator) {
                             
                             
                             
                             [self animateFlipCardViews];
                             
                         }
                     }];
    
    
}

- (void)animateCardOverlayReviewArtMenuOnScreen:(BOOL)onScreenIndicator {
    
    CGFloat menuYOffset;
    CGFloat duration;
    if (onScreenIndicator) {
        menuYOffset = 5.0; //from bottom
        duration = 0.3;
        
    } else {
        menuYOffset = -70.0; //from bottom
        duration = 0.3;
        
        [self.backButton removeFromSuperview];
        
    }
    
    CGFloat menuWidth = self.cardOverlayReviewArtMenu.frame.size.width;
    CGFloat menuHeight = self.cardOverlayReviewArtMenu.frame.size.height;
    CGFloat menuX = self.cardOverlayReviewArtMenu.frame.origin.x;
    CGFloat menuY = self.originalContentView.frame.size.height - menuHeight - menuYOffset;
    
    
    CGRect nextFrame = CGRectMake(menuX, menuY, menuWidth, menuHeight);
    
    
    [UIView animateWithDuration:duration
                          delay:0.0
         usingSpringWithDamping:0.7
          initialSpringVelocity:1.0
                        options:UIViewAnimationOptionCurveEaseInOut | UIViewAnimationOptionAllowAnimatedContent | UIViewAnimationOptionAllowUserInteraction
                     animations:^() {
                         self.cardOverlayReviewArtMenu.frame = nextFrame;
                     }
                     completion:^(BOOL finished) {
                         
                         if (onScreenIndicator) {
                             
                             
                         }
                         else {
                             self.isOKToShowReviewMenu = NO;
                             
                             self.isOKToShowBottomView = YES;
                             [self animateCardOverlayBottomViewOnScreen:YES];
                             self.isShowingQuestionForFirstTime = YES;
                             [self animateQuestionOnScreen:YES];
                             
                             self.isOKToShowNavigationBar = YES;
                             
                             
                         }
                     }];
    
    
}


- (void)animateCardOverlayRoundStatusOnScreen:(BOOL)onScreenIndicator {
    CGRect nextFrame;
    
    UIInterfaceOrientation screenOrientation = [[UIApplication sharedApplication] statusBarOrientation];
    
    if (onScreenIndicator) {
        //alphaLevel = 1.0;
        CGRect currentFrame = [self makeCardOverlayRoundStatusViewFrameWithCard:self.selectedCard withScreenOrientation:screenOrientation];
        self.roundStatusView.frame = [self moveFrame:currentFrame offScreenInDirection:kUp withScreenRatio:0.5];
        self.roundStatusView.hidden = NO;
        
        nextFrame = [self makeCardOverlayRoundStatusViewFrameWithCard:self.selectedCard withScreenOrientation:screenOrientation];
    } else {
        
        nextFrame = [self makeCardOverlayRoundStatusViewFrameWithCard:self.selectedCard withScreenOrientation:screenOrientation];
        nextFrame = [self moveFrame:nextFrame offScreenInDirection:kUp withScreenRatio:0.5];
    }
    
    if (onScreenIndicator) {
        self.scorePlaceholderView.alpha = 0.0;
    } else {
        self.roundStatusDotView.hidden = YES;
        self.isOKForAnimateRoundStatusViewDot = NO;
        
    }
    
    
    // Transition using a image flip
    [UIView animateWithDuration:0.4
                          delay:0.0
                        options:UIViewAnimationOptionCurveEaseInOut | UIViewAnimationOptionAllowAnimatedContent
                     animations:^{
                         
                         self.roundStatusView.frame = nextFrame;
                         
                         
                     }
                     completion:^(BOOL finished){
                         if (!onScreenIndicator) {
                             self.roundStatusView.hidden = YES;
                             self.roundStatusDotView.hidden = YES;
                         }
                     }];
}

- (void)animateCountdownTimerBlink {
    
    if (self.isOKForCountdownTimerToBlink) {
        [UIView animateWithDuration:0.5
                              delay:0.0
                            options:UIViewAnimationOptionCurveLinear | UIViewAnimationOptionAllowAnimatedContent
                         animations:^{
                             if (self.isCountdownTimerShowingBlack) {
                                 self.roundStatusView.backgroundColor = [UIColor emergencyRedColor];
                                 self.isCountdownTimerShowingBlack = NO;
                             }
                             else {
                                 
                                 if ([[[ARTUserInfo sharedInstance] getVisualTheme] isEqual:@"white"]) {
                                     self.roundStatusView.backgroundColor = [UIColor blueButtonColor];
                                     
                                 } else {
                                     
                                     self.roundStatusView.backgroundColor = [UIColor blueButtonColor];
                                 }
                                 
                                 
                                 self.isCountdownTimerShowingBlack = YES;
                             }
                             
                         }
                         completion:^(BOOL finished){
                             [self animateCountdownTimerBlink];
                         }];
    } else {
        if ([[[ARTUserInfo sharedInstance] getVisualTheme] isEqual:@"white"]) {
            self.roundStatusView.backgroundColor = [UIColor blueButtonColor];
            
        } else {
            
            self.roundStatusView.backgroundColor = [UIColor blueButtonColor];
        }
    }
}

- (void)animateTextFieldBlink {
    CGFloat borderWidth = self.cardOverlayAnswerTextField.layer.borderWidth;
    if (self.cardOverlayAnswerTextFieldDefaultBorder == 0.0) {
        self.cardOverlayAnswerTextFieldDefaultBorder = self.cardOverlayAnswerTextField.layer.borderWidth;
    }
    
    if (self.iscardStackAnswerTextFieldGrowing) {
        
        borderWidth += 0.4;
        if (borderWidth >= 4.0) {
            self.iscardStackAnswerTextFieldGrowing = NO;
        }
    } else {
        
        borderWidth -= 0.4;
        if (borderWidth <= 1.5) {
            self.iscardStackAnswerTextFieldGrowing = YES;
        }
    }
    
    if (self.isOKForCardStackAnswerTextFieldToBlink) {
        self.cardOverlayAnswerTextField.layer.borderWidth = borderWidth;
        [self performSelector:@selector(animateTextFieldBlink) withObject:nil afterDelay:0.08 inModes:[NSArray arrayWithObject:NSRunLoopCommonModes]];
        
    } else {
        self.iscardStackAnswerTextFieldGrowing = YES;
        self.cardOverlayAnswerTextField.layer.borderWidth = self.cardOverlayAnswerTextFieldDefaultBorder;
    }
    
}

- (void)animateStartButtonFlash {
    CGAffineTransform currentTransform = self.cardOverlayReviewArtMenu.transform;
    
    if (self.isOKForStartButtonToBlink) {
        
        
        if (CGAffineTransformIsIdentity(currentTransform)) {
            
            [UIView animateWithDuration:0.35
                                  delay:0.0
                                options:UIViewAnimationOptionAllowAnimatedContent  | UIViewAnimationOptionAllowUserInteraction | UIViewAnimationOptionCurveLinear
                             animations:^{
                                 self.cardOverlayReviewArtMenu.transform = CGAffineTransformMakeScale(0.96, 0.96);
                                 self.cardOverlayReviewArtMenu.alpha = 1.0;
                             } completion:^(BOOL finished) {
                                 [self performSelector:@selector(animateStartButtonFlash) withObject:nil afterDelay:0.00 inModes:[NSArray arrayWithObject:NSRunLoopCommonModes]];
                                 
                             }];
        } else {
            
            [UIView animateWithDuration:0.35
                                  delay:0.0
                                options:UIViewAnimationOptionAllowAnimatedContent  | UIViewAnimationOptionAllowUserInteraction | UIViewAnimationOptionCurveLinear
                             animations:^{
                                 self.cardOverlayReviewArtMenu.transform = CGAffineTransformIdentity;
                                 self.cardOverlayReviewArtMenu.alpha = 1.0;
                             } completion:^(BOOL finished) {
                                 [self performSelector:@selector(animateStartButtonFlash) withObject:nil afterDelay:0.00 inModes:[NSArray arrayWithObject:NSRunLoopCommonModes]];
                             }];
        }
        
    } else {
        self.cardOverlayReviewArtMenu.transform = CGAffineTransformIdentity;
        self.cardOverlayReviewArtMenu.alpha = 1.0;
        
    }
    
}

- (void)animateFlipCardViews {
    
    
    [self animateQuestionOnScreen:NO];
    
    
    self.flippingCardInProgress = YES;
    //self.cardOverlayScrollView.zoomScale = self.cardOverlayScrollView.minimumZoomScale;
    if (self.cardOverlayScrollView.zoomScale != self.cardOverlayScrollView.minimumZoomScale) {
        [self.cardOverlayScrollView setZoomScale:self.cardOverlayScrollView.minimumZoomScale animated:YES];
    }
    else {
        self.flippingCardInProgress = NO;
        [self animateFlipCardViewsPart2];
    }
    
}

- (void)animateHideCardOverlayWithCard:(ARTCard *)card {
    
    
    self.hidingCardOverlayInProgress = YES;
    if (self.cardOverlayScrollView.zoomScale != self.cardOverlayScrollView.minimumZoomScale) {
        [self.cardOverlayScrollView setZoomScale:self.cardOverlayScrollView.minimumZoomScale animated:YES];
    }
    else {
        self.hidingCardOverlayInProgress = NO;
        /*if (self.isShowingImageSide == YES) {
         self.flippingToHideCardOverlayInProgress = YES;
         [self animateFlipCardViews];
         }
         else {
         */
        [self.navigationController popViewControllerAnimated:YES];
        
        
    }
    
}

- (void)animateFlipCardViewsPart2 {
    UIView *currentCardOverlayView;
    UIView *nextCardOverlayView;
    
    
    if (self.isShowingImageSide) {
        currentCardOverlayView = self.cardOverlayFrontImageView;
        
        nextCardOverlayView = self.cardOverlayBackImageView;
        
        self.isShowingImageSide = NO;
        self.delegate.isShowingImageSide = NO;
        
    } else {
        currentCardOverlayView = self.cardOverlayBackImageView;
        
        nextCardOverlayView = self.cardOverlayFrontImageView;
        
        self.isShowingImageSide = YES;
        self.delegate.isShowingImageSide = YES;
        
    }
    
    self.cardOverlayScrollView.zoomScale = self.cardOverlayScrollView.minimumZoomScale;
    
    [UIView transitionFromView:currentCardOverlayView
                        toView:nextCardOverlayView
                      duration:cardFlipDuration
                       options:UIViewAnimationOptionTransitionFlipFromLeft|UIViewAnimationOptionAllowAnimatedContent
                    completion:^(BOOL finished) {
                        if (finished) {
                            if (self.flippingToHideCardOverlayInProgress) {
                                self.flippingToHideCardOverlayInProgress = NO;
                                [self animateHideCardOverlayWithCard:self.selectedCard];
                            }
                            
                            [self animateHideCardOverlayWithCard:self.selectedCard];
                            
                        }
                    }];
    
    
}


-(void)animatePopUpViewWithAttrTitle:(NSString *)title andMessage:(NSString *)message andBackgroundColor:(UIColor *)backgroundColor andSpeechBubbleText:(NSString *)speechText fadeDuration:(CGFloat)fadeDuration forQuestionTimerStart:(BOOL)questionTimerStartIndicator {
    
    UIFont *messageFont;
    UIFont *titleFont;
    if (IS_IPAD) {
        messageFont = [UIFont fontWithName:@"HelveticaNeue" size:alertMessageFontSizeIpad];
        titleFont = [UIFont fontWithName:@"HelveticaNeue-Medium" size:alertTitleFontSizeIpad];
    }
    else if (IS_IPHONE_6Plus || IS_IPHONE_6) {
        messageFont = [UIFont fontWithName:@"HelveticaNeue" size:alertMessageFontSizeIphone6];
        titleFont = [UIFont fontWithName:@"HelveticaNeue-Medium" size:alertTitleFontSizeIphone6];
    }
    else {
        messageFont = [UIFont fontWithName:@"HelveticaNeue" size:alertMessageFontSizeIphone5];
        titleFont = [UIFont fontWithName:@"HelveticaNeue-Medium" size:alertTitleFontSizeIphone5];
    }
    
    CGFloat titleX = 10.0;
    CGFloat titleY = 15.0;
    CGPoint titlePoint = CGPointMake(titleX, titleY);
    
    
    CGRect titleLabelShape = [self makePopUpViewLabelFrameWithCGPoint:titlePoint
                                                              andText:title
                                                              andFont:titleFont];
    UILabel *titleLabel = [[UILabel alloc] initWithFrame:titleLabelShape];
    titleLabel.textAlignment = NSTextAlignmentCenter;
    titleLabel.font = titleFont;
    titleLabel.text = title;
    titleLabel.numberOfLines = 0;
    
    CGFloat messageSpacing = 15.0;
    CGFloat messageX = titleLabel.frame.origin.x;
    CGFloat messageY = titleLabel.frame.origin.y + titleLabel.frame.size.height + messageSpacing;
    CGPoint messagePoint = CGPointMake(messageX, messageY);
    
    
    CGRect messageLabelShape = [self makePopUpViewLabelFrameWithCGPoint:messagePoint
                                                                andText:message
                                                                andFont:messageFont];
    UILabel *messageLabel = [[UILabel alloc] initWithFrame:messageLabelShape];
    messageLabel.textAlignment = NSTextAlignmentCenter;
    messageLabel.font = messageFont;
    messageLabel.text = message;
    messageLabel.numberOfLines = 0;
    
    CGFloat maxWidth = MAX(titleLabel.frame.size.width,messageLabel.frame.size.width);
    if (titleLabel.frame.size.width < maxWidth) {
        titleLabel.frame = CGRectMake(titleLabel.frame.origin.x, titleLabel.frame.origin.y, maxWidth, titleLabel.frame.size.height);
    }
    else {
        messageLabel.frame = CGRectMake(messageLabel.frame.origin.x, messageLabel.frame.origin.y, maxWidth, messageLabel.frame.size.height);
    }
    
    CGFloat placeholderWidth = titleX * 2.0 + titleLabel.frame.size.width;
    CGFloat placeholderHeight = messageLabel.frame.origin.y + messageLabel.frame.size.height + (message == nil ? 0. : messageSpacing);
    CGFloat placeholderX = (self.originalContentView.frame.size.width - placeholderWidth) / 2.0;
    CGFloat placeholderY = (self.originalContentView.frame.size.height - placeholderHeight) / 2.0;
    
    CGRect placeHolderShape = CGRectMake(placeholderX, placeholderY, placeholderWidth, placeholderHeight);
    UIView *placeHolderView = [[UIView alloc] initWithFrame:placeHolderShape];
    
    
    placeHolderView.layer.cornerRadius = 15.0;
    placeHolderView.clipsToBounds = YES;
    
    placeHolderView.layer.borderColor = [UIColor whiteColor].CGColor;
    placeHolderView.layer.borderWidth = 1.5;
    
    
    placeHolderView.backgroundColor = [backgroundColor colorWithAlphaComponent:1.0];
    messageLabel.textColor = [UIColor whiteColor];
    titleLabel.textColor = [UIColor whiteColor];
    
    [placeHolderView addSubview:titleLabel];
    [placeHolderView addSubview:messageLabel];
    
    [self.originalContentView addSubview:placeHolderView];
    
    // convert button over to internal button
    
    ARTPassTouchesView *avatarImageContainerView;
    //ARTAlertImageView *alertImageView;
    UIImageView *clockImageView;
    
    CGRect roundStatusStartRect;
    CGRect placeHolderStartRect;
    
    CGRect roundStatusNormalFrame = [self makeCardOverlayRoundStatusViewFrameWithCard:nil withScreenOrientation:UIInterfaceOrientationPortrait];
    
    if (questionTimerStartIndicator) {
        
        CGFloat width = roundStatusNormalFrame.size.width;
        CGFloat height = width;
        CGFloat x = (placeHolderView.frame.size.width - width) / 2.0;
        CGFloat y = 0.0;
        
        CGRect timerFrame = CGRectMake(x,y, width, height);
        
        CGFloat yOverlap;
        if (IS_IPAD) {
            yOverlap = avatarOverlapIpad;
        }
        else {
            yOverlap = avatarOverlapIphone;
        }
        
        width = placeHolderView.frame.size.width;
        height = placeHolderView.frame.size.height + (timerFrame.size.height - yOverlap) * 2.0;
        x = placeHolderView.frame.origin.x;
        y = placeHolderView.frame.origin.y - timerFrame.size.height + yOverlap;
        
        CGRect avatarContainerFrame = CGRectMake(x,y, width, height);
        avatarImageContainerView  = [[ARTPassTouchesView alloc] initWithFrame:avatarContainerFrame];
        avatarImageContainerView.backgroundColor = [UIColor clearColor];
        
        self.roundStatusView.frame = timerFrame;
        self.roundStatusView.hidden = NO;
        self.scorePlaceholderView.alpha = 0.0;
        
        
        [avatarImageContainerView addSubview:self.roundStatusView];
        [self.originalContentView addSubview:avatarImageContainerView];
        
        
        
        roundStatusStartRect = [avatarImageContainerView convertRect:self.roundStatusView.frame toView:self.cardOverlayView];
        placeHolderStartRect = [self.originalContentView convertRect:placeHolderView.frame toView:self.cardOverlayView];
        
        UIImage *image = [[ARTImageHelper sharedInstance] getStopWatchImage];
        clockImageView = [[UIImageView alloc] initWithFrame:self.roundStatusView.bounds];
        clockImageView.image = image;
        clockImageView.contentMode = UIViewContentModeScaleAspectFit;
        clockImageView.backgroundColor = [UIColor blueButtonColor];
        clockImageView.transform = CGAffineTransformMakeScale(0.8, 0.8);
        
        [self.roundStatusView addSubview:clockImageView];
        
    }
    
    /*    else if (speechText) {
     
     CGFloat width;
     if (IS_IPAD) {
     width = avatarDiameterIpad;
     } else if (IS_IPHONE_6Plus || IS_IPHONE_6) {
     width = avatarDiameterIphone6;
     } else {
     width = avatarDiameterIphone;
     }
     
     //shift placeholder down for avatar
     placeHolderView.frame = CGRectMake(placeHolderView.frame.origin.x, placeHolderView.frame.origin.y + width/3., placeHolderView.frame.size.width, placeHolderView.frame.size.height);
     
     CGFloat height = width;
     CGFloat x = (placeHolderView.frame.size.width - width) / 2.0;
     CGFloat y = 0.0;
     
     CGRect avatarFrame = CGRectMake(x,y, width, height);
     
     CGFloat yOverlap;
     if (IS_IPAD) {
     yOverlap = avatarOverlapIpad;
     }
     else {
     yOverlap = avatarOverlapIphone;
     }
     
     width = placeHolderView.frame.size.width;
     height = placeHolderView.frame.size.height + (avatarFrame.size.height - yOverlap) * 2.0;
     x = placeHolderView.frame.origin.x;
     y = placeHolderView.frame.origin.y - avatarFrame.size.height + yOverlap;
     
     CGRect avatarContainerFrame = CGRectMake(x,y, width, height);
     avatarImageContainerView  = [[ARTPassTouchesView alloc] initWithFrame:avatarContainerFrame];
     avatarImageContainerView.backgroundColor = [UIColor clearColor];
     
     ARTAvatar *avatar = self.currentGame.currentPlayer.avatar;
     NSString * filePath = [[NSBundle mainBundle] pathForResource:avatar.imageFilename ofType:@"jpg"];
     UIImage *avatarImage = [UIImage imageWithContentsOfFile:filePath];
     
     alertImageView  = [[ARTAlertImageView alloc] initWithFrame:avatarFrame Image:avatarImage imageScale:1.0 backgroundColor:backgroundColor captionText:avatar.name];
     alertImageView.layer.cornerRadius = alertImageView.frame.size.height/2.0;
     
     
     [avatarImageContainerView addSubview:alertImageView];
     [self.originalContentView addSubview:avatarImageContainerView];
     
     
     ARTSpeechBubleView *avatarSpeechBubble = [[ARTSpeechBubleView alloc] initWithFrame:CGRectZero andSpeechText:speechText];
     
     CGFloat customMaxWidth;
     if (IS_IPAD) {
     customMaxWidth = 350.0;
     } else {
     customMaxWidth = 1000.0;
     }
     
     CGFloat bubbleX =  (alertImageView.frame.origin.x + alertImageView.frame.size.width / 1.6);
     
     CGFloat speechBubbleInsetAdjustment;
     if (IS_IPAD) {
     speechBubbleInsetAdjustment = speechBubbleInsetOffsetIpad * 2.0;
     } else {
     speechBubbleInsetAdjustment = speechBubbleInsetOffsetIphone * 2.0;
     }
     
     CGFloat maxWidth = MIN([UIScreen mainScreen].bounds.size.width -  (avatarImageContainerView.frame.origin.x + avatarImageContainerView.frame.size.width) + (avatarImageContainerView.frame.size.width - bubbleX),customMaxWidth) - speechBubbleInsetAdjustment ;
     
     CGFloat maxHeight = 1000.0;
     
     CGSize maxSize = CGSizeMake(maxWidth,maxHeight);
     
     
     CGRect speechRect = [avatarSpeechBubble.speechText boundingRectWithSize:maxSize
     options:(NSStringDrawingUsesLineFragmentOrigin|NSStringDrawingUsesFontLeading)
     attributes:@{NSFontAttributeName:avatarSpeechBubble.speechLabel.font}
     context:nil];
     CGFloat bubbleWidth = ceilf(speechRect.size.width) + speechBubbleInsetAdjustment;
     CGFloat bubbleHeight= ceilf(speechRect.size.height) + speechBubbleInsetAdjustment;
     
     CGFloat bubbleY = alertImageView.frame.origin.y - bubbleHeight / 1.1;
     
     avatarSpeechBubble.frame = CGRectMake(bubbleX,bubbleY, bubbleWidth, bubbleHeight);
     avatarSpeechBubble.speechLabel.frame = avatarSpeechBubble.bounds;
     
     [avatarImageContainerView addSubview:avatarSpeechBubble];
     
     }*/
    
    CGAffineTransform transform = placeHolderView.transform;
    placeHolderView.alpha = 0.0;
    placeHolderView.transform = CGAffineTransformScale(transform, 0.7, 0.7);
    avatarImageContainerView.alpha = 0.0;
    avatarImageContainerView.transform = CGAffineTransformScale(transform, 0.7, 0.7);
    
    [UIView animateWithDuration:0.18 animations:^{
        placeHolderView.transform = CGAffineTransformScale(transform, 1.1, 1.1);
        placeHolderView.alpha = 1.0;
        avatarImageContainerView.transform = CGAffineTransformScale(transform, 1.1, 1.1);
        avatarImageContainerView.alpha = 1.0;
    } completion:^(BOOL finished) {
        [UIView animateWithDuration:0.13 animations:^{
            placeHolderView.transform = CGAffineTransformScale(transform, 0.9, 0.9);
            avatarImageContainerView.transform = CGAffineTransformScale(transform, 0.9, 0.9);
            
        } completion:^(BOOL finished) {
            [UIView animateWithDuration:0.1 animations:^{
                placeHolderView.transform = transform;
                avatarImageContainerView.transform = transform;
                
            } completion:^(BOOL finished) {
                
                if (finished) {
                    if (!questionTimerStartIndicator) {
                        [UIView animateWithDuration:fadeDuration animations:^{
                            placeHolderView.alpha = 0.0;
                            avatarImageContainerView.alpha = 0.0;
                            
                        } completion:^(BOOL finished) {
                            [placeHolderView removeFromSuperview];
                            [avatarImageContainerView removeFromSuperview];
                            
                        }];
                    }
                    else {
                        [self.cardOverlayView insertSubview:placeHolderView belowSubview:self.cardOverlayQuestionView];
                        placeHolderView.frame = placeHolderStartRect;
                        
                        [self.cardOverlayView insertSubview:self.roundStatusView aboveSubview:placeHolderView];
                        self.roundStatusView.frame = roundStatusStartRect;
                        
                        UIFont *font;
                        if (IS_IPAD) {
                            font = [UIFont fontWithName:@"HelveticaNeue" size:29.0];
                            
                        } else {
                            font = [UIFont fontWithName:@"HelveticaNeue" size:19.0];
                        }
                        
                        
                        NSMutableAttributedString *attrString = [[NSMutableAttributedString alloc] initWithString:@"Give Up?" attributes:@{NSFontAttributeName:font,NSForegroundColorAttributeName:[UIColor whiteColor]}];
                        
                        self.giveUpButton = [[UIButton alloc] giveUpButtonWith:attrString tintColor:[UIColor whiteColor] target:self andAction:@selector(giveUpTapDetected:)];
                        [self.cardOverlayView addSubview:self.giveUpButton];
                        [self.cardOverlayView insertSubview:self.giveUpButton aboveSubview:self.logoImageView];
                        
                        self.giveUpButton.alpha = 0.0;
                        
                        [UIView animateWithDuration:0.3
                                              delay:0.6 options:UIViewAnimationOptionAllowAnimatedContent | UIViewAnimationOptionCurveEaseInOut
                                         animations:^{
                                             self.giveUpButton.alpha = 1.0;
                                             self.roundStatusView.frame = roundStatusNormalFrame;
                                             self.roundStatusDotView.frame = roundStatusNormalFrame;
                                             placeHolderView.alpha = 0.0;
                                             clockImageView.alpha = 0.0;
                                             
                                         }
                                         completion:^(BOOL finished) {
                                             
                                             if (self.selectedCard.isPlayed) {
                                                 self.isRepeatPlayOfCard = YES;
                                             }
                                             
                                             [self.currentGame playCard:self.selectedCard];
                                             [placeHolderView removeFromSuperview];
                                             [avatarImageContainerView removeFromSuperview];
                                             [clockImageView removeFromSuperview];
                                             
                                             [self.cardOverlayView insertSubview:self.roundStatusDotView aboveSubview:self.roundStatusView];
                                             self.isOKForAnimateRoundStatusViewDot = YES;
                                             self.roundStatusDotView.hidden = NO;
                                 
                                             
                                             //    NSMutableDictionary *dict = [[NSMutableDictionary alloc] init];
                                             //  [dict setValue:[NSNumber numberWithFloat:0.75] forKey:@"progressNumber"];
                                             //CGFloat radius = self.roundStatusView.frame.size.height / 2.0 - self.roundStatusView.layer.borderWidth / 2.0;
                                             //    [dict setValue:radiusNumber forKey:@"radiusNumber"];
                                             [self animateRoundStatusDotView];
                                         }];
                        
                    }
                }
            }];
        }];
    }];
    
    
}

- (void) showScore {
    
    
    UIStoryboard *storyboard;
    if (IS_IPAD) {
        storyboard = [UIStoryboard storyboardWithName:@"Storyboard" bundle:nil];
        
    } else {
        storyboard = [UIStoryboard storyboardWithName:@"Main_iPhone" bundle:nil];
        
    }
    ARTScoreViewController *vc = (ARTScoreViewController *)[storyboard instantiateViewControllerWithIdentifier:@"ScoreViewController"];
    vc.view.backgroundColor = [UIColor clearColor];
    vc.deck = self.selectedDeck;
    //vc.backgroundImage = [self pb_takeSnapshot];
    vc.delegate = self;
    
    vc.transitioningDelegate = self;
    vc.modalPresentationStyle = UIModalPresentationCustom;
    
    [self presentViewController:vc animated:YES completion:^{
        
    }];
}

- (UIImage *)pb_takeSnapshot {
    UIGraphicsBeginImageContextWithOptions(self.originalContentView.bounds.size, NO, [UIScreen mainScreen].scale);
    
    [self.originalContentView drawViewHierarchyInRect:self.originalContentView.bounds afterScreenUpdates:YES];
    
    // old style [self.layer renderInContext:UIGraphicsGetCurrentContext()];
    
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return image;
}

- (UIView *)pb_takeSnapshotView {
    //UIGraphicsBeginImageContextWithOptions(self.originalContentView.bounds.size, NO, [UIScreen mainScreen].scale);
    
    UIView *snapshot = [self.originalContentView snapshotViewAfterScreenUpdates:YES];
    
    // old style [self.layer renderInContext:UIGraphicsGetCurrentContext()];
    
    //UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    //UIGraphicsEndImageContext();
    return snapshot;
}

- (CGRect)makePopUpViewLabelFrameWithCGPoint:(CGPoint)point andText:(NSString *)text andFont:(UIFont *)font {
    
    if (text) {
        CGFloat x = point.x;
        CGFloat y = point.y;
        
        CGFloat maxWidth;
        if (IS_IPAD) {
            maxWidth = kURBAlertViewDefaultSizeIPad.width - 18.0;
        }
        else if (IS_IPHONE_6 || IS_IPHONE_6Plus) {
            maxWidth = kURBAlertViewDefaultSizeIPhone6.width - 18.0;
        }
        else {
            maxWidth = kURBAlertViewDefaultSizeIPhone5.width - 18.0;
        }
        
        CGFloat maxHeight = self.originalContentView.frame.size.height - y * 2.0;
        
        CGSize maxLabelSizeTitle = CGSizeMake(maxWidth, maxHeight);
        
        CGRect titleRect = [text boundingRectWithSize:maxLabelSizeTitle
                                              options:(NSStringDrawingUsesLineFragmentOrigin|NSStringDrawingUsesFontLeading)
                                           attributes:@{NSFontAttributeName:font}
                                              context:nil];
        
        
        
        CGFloat width = maxWidth ;
        CGFloat height = ceil(titleRect.size.height);
        
        return CGRectMake(x, y, width, height);
        
    }
    else {
        
        CGFloat x = point.x;
        CGFloat y = point.y;
        
        return CGRectMake(x, y, 0.0, 0.0);    }
    
}

- (void)animateQuestionOnScreen:(BOOL)onScreenIndicator {
    
    self.cardOverlayQuestionMenu.userInteractionEnabled = NO;
    self.cardOverlayAnswerTextField.userInteractionEnabled = NO;
    
    
    CGRect nextFrame;
    
    UIInterfaceOrientation screenOrientation = [[UIApplication sharedApplication] statusBarOrientation];
    
    UIFont * font;
    if (IS_IPAD) {
        font = [UIFont fontWithName:@"HelveticaNeue" size:28];
    }
    else {
        font = [UIFont fontWithName:@"HelveticaNeue" size:18];
    }
    
    UIColor *color = [UIColor whiteColor];
    
    CGFloat delay;
    if (onScreenIndicator) {
        if (self.isOKToShowQuestion) {
            self.isShowingQuestionLabel = YES;
            
            NSMutableAttributedString *attrString = [[NSMutableAttributedString alloc] initWithString:@"Hide Q&A" attributes:@{NSFontAttributeName:font,NSForegroundColorAttributeName:color}];
            [self.cardOverlayQuestionMenu.arrayOfButtons[0] setAttributedTitle:attrString forState:UIControlStateNormal];
            
            //alphaLevel = 1.0;
            CGRect currentFrame = [self makeCardOverlayQuestionViewFrameWithSize:self.cardOverlayQuestionView.frame.size withScreenOrientation:screenOrientation];
            self.cardOverlayQuestionView.frame = [self moveFrame:currentFrame offScreenInDirection:kDown withScreenRatio:1.0];
            self.cardOverlayQuestionView.alpha = 1.0;
            
            nextFrame = [self makeCardOverlayQuestionViewFrameWithSize:self.cardOverlayQuestionView.frame.size withScreenOrientation:screenOrientation];
            
        }
        if (self.isShowingQuestionForFirstTime) {
            delay = 0.40;
            self.cardOverlayQuestionLabel.alpha = 0.0;
            self.cardOverlayQImageView.alpha = 0.0;
            self.cardOverlayAnswerLabel.alpha = 0.0;
            self.cardOverlayAImageView.alpha = 0.0;
            self.cardOverlayAnswerHintButton.alpha = 0.0;
            self.cardOverlayQuestionView.alpha = 0.0;
            
        } else {
            delay = 0.0;
        }
        
    } else {
        
        self.isShowingQuestionLabel = NO;
        
        NSMutableAttributedString *attrString = [[NSMutableAttributedString alloc] initWithString:@"Show Q&A" attributes:@{NSFontAttributeName:font,NSForegroundColorAttributeName:color}];
        [self.cardOverlayQuestionMenu.arrayOfButtons[0] setAttributedTitle:attrString forState:UIControlStateNormal];
        
        nextFrame = [self makeCardOverlayQuestionViewFrameWithSize:self.cardOverlayQuestionView.frame.size withScreenOrientation:screenOrientation];
        nextFrame = [self moveFrame:nextFrame offScreenInDirection:kDown withScreenRatio:0.5];
        
        delay = 0.0;
    }
    
    [UIView animateWithDuration:0.5
                          delay:delay
         usingSpringWithDamping:0.8
          initialSpringVelocity:1.0
                        options:UIViewAnimationOptionCurveEaseInOut | UIViewAnimationOptionAllowAnimatedContent | UIViewAnimationOptionAllowUserInteraction
                     animations:^() {
                         self.cardOverlayQuestionView.frame = nextFrame;
                         
                         if (onScreenIndicator == YES ) {
                             
                         } else {
                             self.cardOverlayQuestionView.alpha = 0.0;
                         }
                     }
                     completion:^(BOOL finished) {
                         
                         if (onScreenIndicator == YES) {
                             if (self.isShowingQuestionForFirstTime) {
                                 self.isShowingQuestionForFirstTime = NO;
                                 self.cardOverlayQuestionView.alpha = 1.0;
                                 [self animateQuestionBlink];
                                 
                             }
                             
                         }
                         
                         self.cardOverlayQuestionMenu.userInteractionEnabled = YES;
                         self.cardOverlayAnswerTextField.userInteractionEnabled = YES;
                         
                     }];
    
    
}


#pragma mark TapGesture Methods

- (void)flipCardTapDetected:(UITapGestureRecognizer*)sender {
    NSLog(@"Tap Detected");
    
    [((ARTButton *)sender.view) setCustomHighlighted:YES];
    
    [self animateFlipCardViews];
}

- (void)startQuestionTapDetected:(UIGestureRecognizer *)sender {
    
    [((ARTButton *)sender.view) setCustomHighlighted:YES];
    
    [self.cardOverlayScrollView setZoomScale:self.cardOverlayScrollView.minimumZoomScale animated:YES];
    
    self.isOKToShowQuestion = YES;
    //[self animateCardOverlayRoundStatusOnScreen:YES];
    [self animateCardOverlayReviewArtMenuOnScreen:NO];
    self.isOKForStartButtonToBlink = NO;
    
    [self updateCardOverlayStatusViews];
    [self animateTextFieldBlink];
    self.cardOverlayReviewArtMenu.userInteractionEnabled = NO;
    
    NSString *message = [NSString stringWithFormat:@"You have\n%ld seconds!",(long)secondsForQuestion];
    
    UIColor *color;
    if ([[[ARTUserInfo sharedInstance] getVisualTheme] isEqual:@"white"]) {
        color = [UIColor darkBlueColor];
    } else {
        color = [UIColor darkBlueColor];
    }
    
    [self animatePopUpViewWithAttrTitle:message andMessage:nil andBackgroundColor:color andSpeechBubbleText:nil  fadeDuration:1.5 forQuestionTimerStart:YES];
    
}

- (BOOL)checkCorrectAnswerForUserString:(NSString *)userString {
    
    if ([self.currentGame checkCorrectAnswerInString:userString forCard:self.selectedCard wholeWord:NO]) {
        
        return YES;
    }
    
    NSInteger hintCount = [self getAnswerHintCount];
    if (hintCount >= 1) {
        
        NSInteger answerKeywordCount = self.selectedCard.answerObject.answerKeywordObjects.count;
        for (NSInteger i = 0; i < answerKeywordCount; i++) {
            
            NSString *keywordHint = [self.selectedCard.answerObject getHintForAnswerObjectAtIndex:i withHintCount:hintCount];
            NSString *appendFirst = [userString stringByAppendingString:keywordHint];
            NSString *appendLast = [keywordHint stringByAppendingString:userString];
            
            BOOL keywordCorrect = [self.selectedCard.answerObject.answerKeywordsCorrect[i] boolValue];
            
            if (!keywordCorrect) {
                if ([self.selectedCard.answerObject checkAnswerInString:appendFirst forAnswerKeywordInteger:i wholeWord:YES]) {
                    return  YES;
                }
                else if ([self.selectedCard.answerObject checkAnswerInString:appendLast forAnswerKeywordInteger:i wholeWord:YES]) {
                    return YES;
                }
            }
        }
    }
    
    
    return NO;
}

- (BOOL)keyboardInputChangedToString:(NSString *)newString {
    
    
    if ([self checkCorrectAnswerForUserString:newString]) {
        
        
        if ([self.currentGame checkAllAnswerKeywordsCorrectForCard:self.selectedCard]) {
            
            if (self.currentGame.questionRemainingTime > 0.0) {
                [self allAnswersCorrectForCardWithTimeRemaining:YES];
            }
            else {
                [self allAnswersCorrectForCardWithTimeRemaining:NO];
                
            }
        }
        return YES; //new text matches a keyword and should dissapper
    }
    else  {
        
        return NO;
    }
    
}

- (void)allAnswersCorrectForCardWithTimeRemaining:(BOOL)timeRemainingIndicator {
    
    [self dismissKeyboard];
    
    //ARTPlayer *player = self.currentGame.currentPlayer; //need to set player before game is advanced
    //NSString *playerName = player.name;
    
    NSString *message;
    if (timeRemainingIndicator && !self.isRepeatPlayOfCard) {
        NSInteger pointsForCard = [self.currentGame finishedWithCorrectAnswer:YES forCard:self.selectedCard andHintCount:self.answerHintCounter andIsRepeatPlay:self.isRepeatPlayOfCard];
        NSInteger hintCount = [self getAnswerHintCount];
        
        if (hintCount == 0) {
            
            if (pointsForCard == 1) {
                message = [NSString stringWithFormat:@"+%ld point\nNo hint required!",(long)pointsForCard];
            } else {
                message = [NSString stringWithFormat:@"+%ld points\nNo hint required!",(long)pointsForCard];
            }
        }
        else if (hintCount == 1) {
            if (pointsForCard == 1) {
                message = [NSString stringWithFormat:@"+%ld point\nYou used 1 hint.",(long)pointsForCard];
            } else {
                message = [NSString stringWithFormat:@"+%ld points\nYou used 1 hint.",(long)pointsForCard];
            }
        }
        else {
            if (pointsForCard == 1) {
                message = [NSString stringWithFormat:@"+%ld point\nYou used %ld hints.",(long)pointsForCard,(long)hintCount];
            } else {
                message = [NSString stringWithFormat:@"+%ld points\nYou used %ld hints.",(long)pointsForCard,(long)hintCount];
            }
        }
    }
    else if (timeRemainingIndicator && self.isRepeatPlayOfCard) {
        
        [self.currentGame finishedWithCorrectAnswer:NO forCard:self.selectedCard andHintCount:self.answerHintCounter andIsRepeatPlay:self.isRepeatPlayOfCard];
        
        message = [NSString stringWithFormat:@"However, this is a repeat play so you keep the original %ld points.",(long)self.selectedCard.points];
        
    } else {
        
        [self.currentGame finishedWithCorrectAnswer:NO forCard:self.selectedCard andHintCount:self.answerHintCounter andIsRepeatPlay:self.isRepeatPlayOfCard];
        
        message = @"However, time ran out. No points for you.";
        
    }
    
    __weak ARTCardViewController *wself = self;
    
    
    
    NSString *titleMessage = [NSString stringWithFormat:@"Correct Answer!\n\"%@\"",self.selectedCard.answerText];
    
    self.correctAnswerAlertView = [[URBAlertView alloc] initWithTitle:titleMessage message:message cancelButtonTitle:nil otherButtonTitles:@"Continue to Explanation", nil];
    
    self.correctAnswerAlertView.backgroundColor = [[UIColor greenishColor] colorWithAlphaComponent:1.0];
    self.correctAnswerAlertView.buttonBackgroundColor = [[UIColor greenishColor] colorWithAlphaComponent:1.0];
    
    // ARTAvatar *avatar = self.currentGame.currentPlayer.avatar;
    //  NSString *avatarMessage = [avatar getCorrectAnswerMessage];
    
    ///  NSString * filePath = [[NSBundle mainBundle] pathForResource:avatar.imageFilename ofType:@"jpg"];
    //  UIImage *avatarImage = [UIImage imageWithContentsOfFile:filePath];
    
    //  [self.correctAnswerAlertView addAlertImage:avatarImage imageScale:1.0 backgroundColor:[UIColor clearColor] captionText:avatar.name ];
    //  [self.correctAnswerAlertView addSpeechBubbleWithSpeechText:avatarMessage];
    
      UIImage *thumbsUpImage = [[ARTImageHelper sharedInstance] getThumbsUpImage];
    
     [self.correctAnswerAlertView addAlertImage:thumbsUpImage imageScale:0.82 backgroundColor:[UIColor greenishColor] captionText:nil ];
    
    
    [self.correctAnswerAlertView setHandlerBlock:^(NSInteger buttonIndex, URBAlertView *alertView) {
        __strong ARTCardViewController *sself = wself;
        
        [sself.correctAnswerAlertView hideWithAnimation:URBAlertAnimationDefault completionBlock:^{
            NSLog(@"See explanation clicked");
            [sself animateCardOverlayRoundStatusOnScreen:NO];
            sself.isOKToShowQuestion = YES;
            
            [sself showAnswer];
        }];
    }];
    [self.correctAnswerAlertView showWithAnimation:URBAlertAnimationDefault ];
    
}



- (void)showHideQuestionTapped:(UITapGestureRecognizer *)sender {
    
    [((ARTButton *)sender.view) setCustomHighlighted:YES];
    
    if (self.isShowingQuestionLabel) {
        
        [self animateQuestionOnScreen:NO];
        
        if (self.isShowingKeyboard) {
            [self dismissKeyboard];
        } else {
        }
    } else {
        
        [self animateQuestionOnScreen:YES];
    }
    
    if (self.isOkToShowAnswer) {
        if (self.isShowingAnswerLabel) {
            
        } else {
            
        }
    }
    
}

- (void)questionViewTapped:(UITapGestureRecognizer *)sender {
    
    if (self.isShowingKeyboard) {
        [self dismissKeyboard];
    } else {
        
        if (self.isShowingQuestionLabel) {
            [self.cardOverlayAnswerTextField becomeFirstResponder];
        } else {
        }
        
        if (self.isOkToShowAnswer) {
            if (self.isShowingAnswerLabel) {
                
            } else {
            }
        }
        
    }
    
    
}

- (void)scrollViewSingleTapped:(UITapGestureRecognizer*)sender {
    NSLog(@"Single tap detected");
    
    if (self.isShowingKeyboard) {
        [self dismissKeyboard];
    } else {
        
        if (self.isShowingQuestionLabel) {
            [self animateQuestionOnScreen:NO];
            
        } else {
        }
        
        if (self.isOkToShowAnswer) {
            if (self.isShowingAnswerLabel) {
                
            } else {
            }
        }
        
    }
    
    
    
    if (self.isShowingFullAnswerMenu) {
        
        [self animateFlipCardViews];
        
        self.isOKToShowNavigationBar = YES;
        
        [self.giveUpButton removeFromSuperview];
        
        if (!self.selectedDeck.isGameOver) {
            self.continueButton = [[UIButton alloc] backButtonWith:@"Topics" tintColor:[UIColor blueNavBarColor] target:self andAction:@selector(continueButtonTapped:)];
            [self.cardOverlayView addSubview:self.continueButton];
            [self.cardOverlayView insertSubview:self.continueButton aboveSubview:self.logoImageView];
            
            [self setupScoreView];
        }
        
        self.logoImageView.alpha = 1.0;
        
        self.isShowingFullAnswerMenu = NO;
        
    }
    
}

- (void)scrollViewDoubleTapped:(UITapGestureRecognizer*)sender {
    NSLog(@"Double tap detected");
    
    
    if (!self.isShowingKeyboard) {
        
        if (self.cardOverlayScrollView.zoomScale == self.cardOverlayScrollView.minimumZoomScale) {
            // 1
            CGPoint pointInView;
            if (self.isShowingImageSide) {
                pointInView = [sender locationInView:self.cardOverlayFrontImageView];
            } else {
                pointInView = [sender locationInView:self.cardOverlayBackImageView];    }
            
            // 2
            CGFloat newZoomScale = self.cardOverlayScrollView.zoomScale * 1.75;
            newZoomScale = MIN(newZoomScale, self.cardOverlayScrollView.maximumZoomScale);
            
            // 3
            CGSize scrollViewSize = self.cardOverlayScrollView.bounds.size;
            
            CGFloat w = scrollViewSize.width / newZoomScale;
            CGFloat h = scrollViewSize.height / newZoomScale;
            CGFloat x = pointInView.x - (w / 2.0);
            CGFloat y = pointInView.y - (h / 2.0);
            
            CGRect rectToZoomTo = CGRectMake(x, y, w, h);
            
            // 4
            [self.cardOverlayScrollView zoomToRect:rectToZoomTo animated:YES];
        }
        else {
            [self.cardOverlayScrollView setZoomScale:self.cardOverlayScrollView.minimumZoomScale animated:YES];
        }
    }
    
}

- (void)backToDeckTapDetected:(UITapGestureRecognizer*)sender {
    NSLog(@"Single tap detected");
    
    
    [self animateHideCardOverlayWithCard:self.selectedCard];
}


- (void)giveUpTapDetected:(UITapGestureRecognizer*)sender {
    NSLog(@"Single tap detected");
    
    //[self dismissKeyboard];//this is smoother animation
    
    __weak ARTCardViewController *wself = self;
    
    self.giveUpAlertView = [[URBAlertView alloc] initWithTitle:@"Give Up?" message:@"Are you sure?" cancelButtonTitle:@"Keep Trying" otherButtonTitles: @"Give Up", nil];
    
    //   ARTAvatar *avatar = self.currentGame.currentPlayer.avatar;
    //   NSString * filePath = [[NSBundle mainBundle] pathForResource:avatar.imageFilename ofType:@"jpg"];
    //   UIImage *avatarImage = [UIImage imageWithContentsOfFile:filePath];
    
    //   [self.giveUpAlertView addAlertImage:avatarImage imageScale:1.0 backgroundColor:[UIColor clearColor] captionText:avatar.name ];
    //   [self.giveUpAlertView addSpeechBubbleWithSpeechText:self.currentGame.currentPlayer.avatar.giveUpMessage];
    
    
    [self.giveUpAlertView setHandlerBlock:^(NSInteger buttonIndex, URBAlertView *alertView) {
        __strong ARTCardViewController *sself = wself;
        NSLog(@"alertview title font:%@",alertView.titleFont);
        
        [sself.giveUpAlertView hideWithAnimation:URBAlertAnimationDefault completionBlock:^{
            if (buttonIndex == 0) {
                NSLog(@"Keep trying clicked");
                
            }
            else if (buttonIndex == 1) {
                NSLog(@"Give up clicked");
                
                [sself giveUpConfirmed];
                
            }
        }];
    }];
    [self.giveUpAlertView showWithAnimation:URBAlertAnimationDefault ];
    
    
    
}

- (void)giveUpConfirmed {
    
    self.isOKToShowNavigationBar = NO;
    
    self.isOKToShowQuestion = YES;
    [self animateCardOverlayRoundStatusOnScreen:NO];
    
    [self.currentGame finishedWithCorrectAnswer:NO forCard:self.selectedCard andHintCount:self.answerHintCounter andIsRepeatPlay:self.isRepeatPlayOfCard];
    [self dismissKeyboard];
    
    
    NSString *titleMessage = [NSString stringWithFormat:@"Answer\n\"%@\"",self.selectedCard.answerText];
    
    NSString *message;
    if (self.isRepeatPlayOfCard) {
        message = [NSString stringWithFormat:@"However, this is a repeat play so you keep the original %ld points.",(long)self.selectedCard.points];
    } else {
        message = [NSString stringWithFormat:@"0 points awarded."];
    }
    
    __weak ARTCardViewController *wself = self;
    
    self.giveUpConfirmedAlertView = [[URBAlertView alloc] initWithTitle:titleMessage message:message cancelButtonTitle:nil otherButtonTitles:@"Continue to Explanation", nil];
    
    self.giveUpConfirmedAlertView.backgroundColor = [[UIColor emergencyRedColor] colorWithAlphaComponent:1.0];
    self.giveUpConfirmedAlertView.buttonBackgroundColor = [[UIColor emergencyRedColor] colorWithAlphaComponent:1.0];
    
    //UIImage *thumbsDownImage = [[ARTImageHelper sharedInstance] getThumbsDownImage];
    
    //[self.giveUpConfirmedAlertView addAlertImage:thumbsDownImage imageScale:0.82 backgroundColor:[UIColor emergencyRedColor] captionText:nil ];
    
    [self.giveUpConfirmedAlertView setHandlerBlock:^(NSInteger buttonIndex, URBAlertView *alertView) {
        __strong ARTCardViewController *sself = wself;
        
        [sself.giveUpConfirmedAlertView hideWithAnimation:URBAlertAnimationDefault completionBlock:^{
            
            [sself showAnswer];
        }];
    }];
    [self.giveUpConfirmedAlertView showWithAnimation:URBAlertAnimationDefault ];
    
}



- (void)hintTapDetected:(UITapGestureRecognizer*)sender {
    NSLog(@"Hint tap detected");
    
    [self incrementAnswerHintCount];
    
    NSInteger hintCount = [self getAnswerHintCount];
    self.cardOverlayAnswerLabel.attributedText = [self getAnswerTextforOriginalText:self.selectedCard.answerText andHintCount:hintCount toCheckMaxLength:NO];
    
    NSMutableAttributedString *attrString = [self getHintButtonAttrText];
    
    CGRect frame = [self makeAnswerHintButtonFrameWithinShape:self.cardOverlayQuestionView.frame WithTitle:attrString WithScreenOrientation:UIInterfaceOrientationPortrait];
    self.cardOverlayAnswerHintButton.frame = frame;
    [self.cardOverlayAnswerHintButton applyStandardFormatting];
    [self.cardOverlayAnswerHintButton makeGlossy];
    
    UIFont *font = [self getFontForLabels];
    CGFloat widthForALabel = self.cardOverlayQuestionView.frame.size.width - self.cardOverlayAImageView.frame.size.width - self.cardOverlayAImageView.frame.origin.x - self.cardOverlayAnswerHintButton.frame.size.width - 10.0;
    
    self.cardOverlayAnswerLabel.frame = [self makeCardOverlayAnswerLabelFrameWithText:self.cardOverlayAnswerLabel.attributedText.string withScreenOrientation:UIInterfaceOrientationPortrait withFont:font withWidth:widthForALabel];
    
    [((ARTButton *)sender.view) setAttributedTitle:attrString forState:UIControlStateNormal];
    
    
    if (hintCount >= maxHintCount) {
        [((ARTButton *)sender.view) setCustomEnabled:NO];
        
    } else {
        [((ARTButton *)sender.view) setCustomHighlighted:YES];
    }
    
    [self animateAnswerHintBlink];
}

- (void)animateAnswerHintBlink {
    
    UIColor *flashColor;
    if ([[[ARTUserInfo sharedInstance] getVisualTheme] isEqual:@"white"]) {
        flashColor = [[UIColor darkBlueColor] colorWithAlphaComponent:0.8];
        
    } else {
        flashColor = [[UIColor whiteColor] colorWithAlphaComponent:0.8];
        
    }
    //for UILabel, the backgroundcolor doesnt seem to animate but you can use the layer and it works ok
    
    [UIView animateWithDuration:0.0
                          delay:0.0
                        options:UIViewAnimationOptionOverrideInheritedOptions
                     animations:^{
                         
                         self.cardOverlayAnswerLabel.layer.backgroundColor = flashColor.CGColor;
                     } completion:^(BOOL finished) {
                         
                         [UIView animateWithDuration:0.5
                                               delay:0.0
                                             options:UIViewAnimationOptionOverrideInheritedOptions
                                          animations:^{
                                              
                                              self.cardOverlayAnswerLabel.layer.backgroundColor = self.cardOverlayQuestionView.backgroundColor.CGColor;
                                          } completion:^(BOOL finished) {
                                              
                                          }];
                     }];
    
    
}

- (void)animateQuestionBlink {
    
    UIColor *flashColor;
    if ([[[ARTUserInfo sharedInstance] getVisualTheme] isEqual:@"white"]) {
        flashColor = [[UIColor darkBlueColor]colorWithAlphaComponent:1.0];
        
    } else {
        flashColor = [[UIColor whiteColor] colorWithAlphaComponent:1.0];
        
    }
    
    UIColor *origColor = self.cardOverlayQuestionView.backgroundColor;
    
    [UIView animateWithDuration:0.075
                          delay:0.0
                        options:UIViewAnimationOptionOverrideInheritedOptions | UIViewAnimationOptionAllowAnimatedContent
                     animations:^{
                         
                         self.cardOverlayQuestionView.backgroundColor = flashColor;
                         self.cardOverlayQImageView.backgroundColor = flashColor;
                         self.cardOverlayAImageView.backgroundColor = flashColor;
                         self.cardOverlayAnswerLabel.layer.backgroundColor = flashColor.CGColor;
                         self.cardOverlayQuestionLabel.layer.backgroundColor = flashColor.CGColor;
                         
                         
                         
                     } completion:^(BOOL finished) {
                         
                         [UIView animateWithDuration:0.1
                                               delay:0.0
                                             options:UIViewAnimationOptionOverrideInheritedOptions | UIViewAnimationOptionAllowAnimatedContent
                                          animations:^{
                                              
                                              if ([[[ARTUserInfo sharedInstance] getVisualTheme] isEqual:@"white"]) {
                                                  self.cardOverlayQuestionView.backgroundColor = flashColor;
                                                  self.cardOverlayQImageView.backgroundColor = flashColor;
                                                  self.cardOverlayAImageView.backgroundColor = flashColor;
                                                  self.cardOverlayAnswerLabel.layer.backgroundColor = flashColor.CGColor;
                                                  self.cardOverlayQuestionLabel.layer.backgroundColor = flashColor.CGColor;
                                                  
                                              } else {
                                                  self.cardOverlayQuestionView.backgroundColor = [UIColor lightBlueColor];
                                                  self.cardOverlayQImageView.backgroundColor = [UIColor lightBlueColor];
                                                  self.cardOverlayAImageView.backgroundColor = [UIColor lightBlueColor];
                                                  self.cardOverlayAnswerLabel.layer.backgroundColor = [UIColor lightBlueColor].CGColor;
                                                  self.cardOverlayQuestionLabel.layer.backgroundColor = [UIColor lightBlueColor].CGColor;
                                                  
                                                  
                                              }
                                              
                                          } completion:^(BOOL finished) {
                                              
                                              [UIView animateWithDuration:0.4
                                                                    delay:0.0
                                                                  options:UIViewAnimationOptionOverrideInheritedOptions | UIViewAnimationOptionAllowAnimatedContent
                                                               animations:^{
                                                                   self.cardOverlayQuestionView.backgroundColor = origColor;
                                                                   self.cardOverlayQImageView.backgroundColor = origColor;
                                                                   self.cardOverlayAImageView.backgroundColor = origColor;
                                                                   self.cardOverlayAnswerLabel.layer.backgroundColor = origColor.CGColor;
                                                                   self.cardOverlayQuestionLabel.layer.backgroundColor = origColor.CGColor;
                                                                   
                                                                   self.cardOverlayQuestionLabel.alpha = 1.0;
                                                                   self.cardOverlayQImageView.alpha = 1.0;
                                                                   self.cardOverlayAnswerLabel.alpha = 1.0;
                                                                   self.cardOverlayAImageView.alpha = 1.0;
                                                                   self.cardOverlayAnswerHintButton.alpha = 1.0;
                                                               } completion:^(BOOL finished) {
                                                               }];
                                          }];
                         
                     }];
    
    
}

- (NSInteger)getAnswerHintCount {
    return self.answerHintCounter;
}


- (void)incrementAnswerHintCount {
    
    if (self.answerHintCounter < maxHintCount) {
        self.answerHintCounter++;
    }
}


#pragma mark Game Delegate Methods

- (void)updateCardOverlayStatusViews {
    UIColor *color;
    if ([[[ARTUserInfo sharedInstance] getVisualTheme] isEqual:@"white"]) {
        color = [UIColor whiteColor];
        
    } else {
        color = [UIColor whiteColor];
        
    }
    
    UIFont * font;
    
    if (IS_IPAD) {
        font = [UIFont fontWithName:@"HelveticaNeue" size:52];
    } else if (IS_IPHONE_6 || IS_IPHONE_6Plus) {
        font = [UIFont fontWithName:@"HelveticaNeue" size:36];
    } else {
        font = [UIFont fontWithName:@"HelveticaNeue" size:30];
    }
    
    
    //if (self.currentGame.cardIsInProgress) {
    
    if (self.currentGame.questionRemainingTime > 0.0 ) {
        
        NSInteger secondsForPanic = 10;
        if (self.currentGame.questionRemainingTime  <= secondsForPanic) {
            
            if (self.isOKForCountdownTimerToBlink == NO) {
                self.isOKForCountdownTimerToBlink = YES;
                [self animateCountdownTimerBlink];
            }
        } else {
            
            self.isOKForCountdownTimerToBlink = NO;
            
        }
        
        NSString *seconds = [self formatRoundLabelSecondsTextForSeconds:self.currentGame.questionRemainingTime];
        
        NSMutableAttributedString *secString = [[NSMutableAttributedString alloc] initWithString:seconds attributes:@{NSFontAttributeName:font,NSForegroundColorAttributeName:color}];
        
        /*NSString *tenths = [self formatRoundLabelTenthsTextForSeconds:self.currentGame.questionRemainingTime];
         UIFont * smallFont = [UIFont fontWithName:@"HelveticaNeue" size:14];
         NSMutableAttributedString *tenthString = [[NSMutableAttributedString alloc] initWithString:tenths attributes:@{NSFontAttributeName:smallFont,NSForegroundColorAttributeName:color}];
         
         [secString appendAttributedString:tenthString];*/
        self.roundTimerLabel.attributedText = secString;
        
    }
    
    else if (self.selectedCard.isPlayed) {
        
    }
    
    else {
        
        self.isOKForCountdownTimerToBlink = NO;
        
        NSString *seconds = [self formatRoundLabelSecondsTextForSeconds:90.0];
        
        NSMutableAttributedString *secString = [[NSMutableAttributedString alloc] initWithString:seconds attributes:@{NSFontAttributeName:font,NSForegroundColorAttributeName:color}];
        
        /*NSString *tenths = [self formatRoundLabelTenthsTextForSeconds:0.0];
         UIFont * smallFont = [UIFont fontWithName:@"HelveticaNeue" size:14];
         NSMutableAttributedString *tenthString = [[NSMutableAttributedString alloc] initWithString:tenths attributes:@{NSFontAttributeName:smallFont,NSForegroundColorAttributeName:color}];
         
         //[secString appendAttributedString:tenthString];*/
        self.roundTimerLabel.attributedText = secString;
        
    }
    
    
    //}
    //else {
    
    //}
}

- (NSString *)formatRoundLabelSecondsTextForSeconds:(float)seconds {
    NSString *text;
    
    /*NSInteger minutes;
     if (seconds > 60) {
     minutes = floor(seconds / 60);
     seconds = seconds % 60;
     if (seconds < 10) {
     text = [NSString stringWithFormat:@"%ld:0%ld",(long)minutes, (long)seconds];
     }
     else {
     text = [NSString stringWithFormat:@"%ld:%ld",(long)minutes, (long)seconds];
     }
     } else {
     text = [NSString stringWithFormat:@"%ld",(long)seconds];
     }
     */
    //float orig = 123456.3;
    float trunSec = floorf(seconds);
    
    text = [NSString stringWithFormat:@"%.0f", trunSec];
    
    return text;
}

- (NSString *)formatRoundLabelTenthsTextForSeconds:(float)seconds {
    NSString *text;
    
    float tenths = (truncf(seconds * 10.0)/10.0 - truncf(seconds)) * 10.0;
    
    text = [NSString stringWithFormat:@".%.0f", tenths];
    
    return text;
}


- (void)questionTimerExpired {
    
    self.isOKForCountdownTimerToBlink = NO;
    self.isOKForAnimateRoundStatusViewDot = NO;
    
    if (self.giveUpAlertView) {
        [self.giveUpAlertView hideWithAnimation:URBAlertAnimationNone];
        self.giveUpAlertView = nil;
    }
    
    [self dismissKeyboard];
    
    
    __weak ARTCardViewController *wself = self;
    
    NSString *message;
    if (self.isRepeatPlayOfCard) {
        message = [NSString stringWithFormat:@"However, this is a repeat play so you keep the original %ld points.\n\nFeel free to keep guessing.",(long)self.selectedCard.points];
    } else {
        message = @"0 points awarded.\n\nFeel free to keep guessing.";
    }
    
    self.timerUpAlertView = [[URBAlertView alloc] initWithTitle:@"Time up!" message:message cancelButtonTitle:@"Keep guessing" otherButtonTitles: @"See answer", nil];
    
    //   ARTAvatar *avatar = self.currentGame.currentPlayer.avatar;
    //   NSString * filePath = [[NSBundle mainBundle] pathForResource:avatar.imageFilename ofType:@"jpg"];
    //  UIImage *avatarImage = [UIImage imageWithContentsOfFile:filePath];
    
    //   [self.timerUpAlertView addAlertImage:avatarImage imageScale:1.0 backgroundColor:[UIColor clearColor] captionText:avatar.name];
    
    [self.timerUpAlertView setHandlerBlock:^(NSInteger buttonIndex, URBAlertView *alertView) {
        __strong ARTCardViewController *sself = wself;
        
        
        [sself.timerUpAlertView hideWithAnimation:URBAlertAnimationDefault completionBlock:^{
            if (buttonIndex == 0) {
                NSLog(@"Keep trying clicked");
                
            }
            else if (buttonIndex == 1) {
                NSLog(@"See answer clicked");
                
                [sself giveUpConfirmed];
                
            }
        }];
    }];
    [self.timerUpAlertView showWithAnimation:URBAlertAnimationDefault ];
    
}


#pragma mark Text & Keyboard Control Methods

- (void)dismissKeyboard {
    if (self.cardOverlayAnswerTextField) {
        [self.cardOverlayAnswerTextField resignFirstResponder];
    }
}

- (void)keyboardWillShow:(NSNotification *)notification {
    
    NSLog(@"Keyboard will show");
    
    self.isShowingKeyboard = YES;
    self.isOKForCardStackAnswerTextFieldToBlink = NO;
    
    if (!self.isShowingQuestionLabel) {
        self.cardOverlayQuestionView.alpha = 1.0;
        self.cardOverlayQuestionView.frame = [self makeCardOverlayQuestionViewFrameWithSize:self.cardOverlayQuestionView.frame.size withScreenOrientation:UIInterfaceOrientationPortrait];
        
        UIFont * font;
        if (IS_IPAD) {
            font = [UIFont fontWithName:@"HelveticaNeue" size:28];
        }
        else {
            font = [UIFont fontWithName:@"HelveticaNeue" size:18];
        }
        
        UIColor *color = [UIColor whiteColor];
        NSMutableAttributedString *attrString = [[NSMutableAttributedString alloc] initWithString:@"Hide Q&A" attributes:@{NSFontAttributeName:font,NSForegroundColorAttributeName:color}];
        [self.cardOverlayQuestionMenu.arrayOfButtons[0] setAttributedTitle:attrString forState:UIControlStateNormal];
        
        self.isShowingQuestionLabel = YES;
    }
    
    NSDictionary *userInfo = [notification userInfo];
    
    UIViewAnimationCurve animationCurve = [userInfo[UIKeyboardAnimationCurveUserInfoKey] integerValue];
    CGFloat duration = [userInfo[UIKeyboardAnimationDurationUserInfoKey] floatValue];
    
    NSValue* aValue = userInfo[UIKeyboardFrameEndUserInfoKey];
    
    CGRect keyboardRect = [aValue CGRectValue];
    keyboardRect = [self.originalContentView convertRect:keyboardRect fromView:nil];
    CGRect intersect = CGRectIntersection(self.cardOverlayView.frame, keyboardRect);
    
    CGRect keyboardRectAndBottomMenu = keyboardRect;
    keyboardRectAndBottomMenu.size.height += self.cardOverlayBottomView.frame.size.height;
    keyboardRectAndBottomMenu.origin.y -= self.cardOverlayBottomView.frame.size.height;
    
    //save current frames before keyboard appears
    
    UIInterfaceOrientation screenOrientation = [[UIApplication sharedApplication] statusBarOrientation];
    
    self.cardOverlayBottomViewDefaultFrame = [self makeCardOverlayBottomViewFrameScreenOrientation:screenOrientation];
    self.cardOverlayAnswerTextFieldDefaultFrame = [self makeCardOverlayAnswerTextFieldFrame];
    self.cardOverlayQuestionDefaultFrame = [self makeCardOverlayQuestionViewFrameWithSize:self.cardOverlayQuestionView.frame.size withScreenOrientation:screenOrientation];;
    
    CGRect nextBottomViewShape = CGRectMake(self.cardOverlayBottomViewDefaultFrame.origin.x, self.cardOverlayBottomViewDefaultFrame.origin.y - intersect.size.height, self.cardOverlayBottomViewDefaultFrame.size.width, self.cardOverlayBottomViewDefaultFrame.size.height);
    CGRect nextAnswerTextFieldShape = CGRectMake(5.0, self.cardOverlayAnswerTextFieldDefaultFrame.origin.y, self.cardOverlayBottomViewDefaultFrame.size.width - 10.0, self.cardOverlayAnswerTextFieldDefaultFrame.size.height);
    CGRect nextQuestionLabelShape = CGRectMake(self.cardOverlayQuestionDefaultFrame.origin.x, self.cardOverlayQuestionDefaultFrame.origin.y - intersect.size.height, self.cardOverlayQuestionDefaultFrame.size.width, self.cardOverlayQuestionDefaultFrame.size.height);
    
    UIViewAnimationOptions options = (animationCurve << 16);
    
    
    
    [UIView animateWithDuration:duration
                          delay:0.0
                        options:options
                     animations:^{
                         self.cardOverlayBottomView.frame = nextBottomViewShape;
                         self.cardOverlayAnswerTextField.frame = nextAnswerTextFieldShape;
                         self.cardOverlayQuestionView.frame = nextQuestionLabelShape;
                         self.cardOverlayQuestionMenu.hidden = YES;
                     }
                     completion:nil];
    
}

- (void)keyboardWillHide:(NSNotification *)notification {
    
    NSLog(@"Keyboard will hide");
    
    
    self.isOKForCardStackAnswerTextFieldToBlink = YES;
    [self animateTextFieldBlink];
    
    NSDictionary *userInfo = [notification userInfo];
    
    UIViewAnimationCurve animationCurve = [userInfo[UIKeyboardAnimationCurveUserInfoKey] integerValue];
    CGFloat duration = [userInfo[UIKeyboardAnimationDurationUserInfoKey] floatValue];
    
    UIViewAnimationOptions options = (animationCurve << 16);
    
    [UIView animateWithDuration:duration
                          delay:0.0
                        options:options
                     animations:^{
                         self.cardOverlayBottomView.frame = self.cardOverlayBottomViewDefaultFrame;
                         self.cardOverlayAnswerTextField.frame = self.cardOverlayAnswerTextFieldDefaultFrame;
                         self.cardOverlayQuestionView.frame = self.cardOverlayQuestionDefaultFrame;
                         self.cardOverlayQuestionMenu.hidden = NO;
                     }
                     completion:^(BOOL completion) {
                     }];
    
}

- (void)keyboardDidHide:(NSNotification *)notification {
    self.isShowingKeyboard = NO;
    
}

- (void)keyboardDidShow:(NSNotification *)notification {
    self.isShowingKeyboard = YES;
    
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [self dismissKeyboard];
    
    return NO;
}

- (void)textFieldDidBeginEditing:(UITextField *)textField {
    textField.placeholder = nil;
}

- (void)textFieldDidEndEditing:(UITextField *)textField {
    
    if (![textField.text  isEqual: @""] && ![self.currentGame checkAllAnswerKeywordsCorrectForCard:self.selectedCard]) {
        ARTAvatar *avatar = self.currentGame.currentPlayer.avatar;
        
        [self animatePopUpViewWithAttrTitle:@"Incorrect Word" andMessage:@"Keep Trying!" andBackgroundColor:[UIColor emergencyRedColor] andSpeechBubbleText:[avatar getWrongAnswerMessage] fadeDuration:1.00 forQuestionTimerStart:NO];
        
    }
    
    textField.text = @"";
    
    if ([[[ARTUserInfo sharedInstance] getVisualTheme] isEqual:@"white"]) {
        
        UIColor *color = [UIColor blackColor];
        textField.attributedPlaceholder = [[NSAttributedString alloc] initWithString:@"Type answer here" attributes:@{NSForegroundColorAttributeName: color}];
    } else {
        
        UIColor *color = [UIColor whiteColor];
        textField.attributedPlaceholder = [[NSAttributedString alloc] initWithString:@"Type answer here" attributes:@{NSForegroundColorAttributeName: color}];
    }
    
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    
    NSString *newString = [textField.text stringByReplacingCharactersInRange:range withString:string];
    
    if ([self keyboardInputChangedToString:newString]) {
        textField.text = @"";
        
        NSInteger hintCount = [self getAnswerHintCount];
        self.cardOverlayAnswerLabel.attributedText = [self getAnswerTextforOriginalText:self.selectedCard.answerText andHintCount:hintCount toCheckMaxLength:NO];
        
        UIFont *font = [self getFontForLabels];
        NSString *string = self.cardOverlayAnswerLabel.attributedText.string;
        CGFloat widthForALabel = self.cardOverlayQuestionView.frame.size.width - self.cardOverlayAImageView.frame.size.width - self.cardOverlayAImageView.frame.origin.x - self.cardOverlayAnswerHintButton.frame.size.width - 10.0;
        self.cardOverlayAnswerLabel.frame = [self makeCardOverlayAnswerLabelFrameWithText:string withScreenOrientation:UIInterfaceOrientationPortrait withFont:font withWidth:widthForALabel];
        
        if (![self.currentGame checkAllAnswerKeywordsCorrectForCard:self.selectedCard]) {
            [self animatePopUpViewWithAttrTitle:@"Correct Word" andMessage:@"Keep it up!" andBackgroundColor:[UIColor greenishColor] andSpeechBubbleText:nil fadeDuration:1.00 forQuestionTimerStart:NO];
        }
        
        [self animateAnswerHintBlink];
        
        return NO;
    }
    
    return YES;
}

- (void)animateTextfieldAnswerBlinkWithColor:(UIColor *)flashColor {
    
    [UIView animateWithDuration:0.0
                          delay:0.0
                        options:UIViewAnimationOptionAllowAnimatedContent|UIViewAnimationOptionAllowUserInteraction
                     animations:^{
                         self.cardOverlayAnswerTextField.backgroundColor = flashColor;
                         
                     } completion:^(BOOL finished) {
                         
                         [UIView animateWithDuration:0.4
                                               delay:0.0
                                             options:UIViewAnimationOptionAllowAnimatedContent|UIViewAnimationOptionAllowUserInteraction
                                          animations:^{
                                              UIColor *color;
                                              
                                              if ([[[ARTUserInfo sharedInstance] getVisualTheme] isEqual:@"white"]) {
                                                  color = [UIColor whiteColor];
                                              } else {
                                                  color = [UIColor blackColor];
                                              }
                                              self.cardOverlayAnswerTextField.backgroundColor = color;
                                          } completion:^(BOOL finished) {
                                              
                                          }];
                         
                     }];
}

#pragma mark Miscellaneous

- (void)showAnswer {
    self.isShowingAnswerForFirstTime = YES;
    self.isOkToShowAnswer = YES;
    self.isOKForCardStackAnswerTextFieldToBlink = NO;
    self.isOKForCountdownTimerToBlink = NO;
    self.isOKForAnimateRoundStatusViewDot = NO;
    
    [self animateCardOverlayBottomViewOnScreen:NO];
    
    [self animateCardOverlayAnswerMenuOnScreen:NO withCard:self.selectedCard];
    
    [self scrollViewSingleTapped:nil];
    
}

- (id<UIViewControllerAnimatedTransitioning>)navigationController:(UINavigationController *)navigationController animationControllerForOperation:(UINavigationControllerOperation)operation fromViewController:(UIViewController *)fromVC toViewController:(UIViewController *)toVC {
    ARTNoTransitionAnimator *animator = [ARTNoTransitionAnimator new];
    return animator;
}

- (id<UIViewControllerAnimatedTransitioning>)animationControllerForPresentedController:(UIViewController *)presented
                                                                  presentingController:(UIViewController *)presenting
                                                                      sourceController:(UIViewController *)source {
    
    ARTPopoverAnimator *animator = [ARTPopoverAnimator new];
    animator.onScreenIndicator = YES;
    animator.delegateController = self;
    animator.landscapeOKOnExit = YES;
    
    return animator;
}

- (id<UIViewControllerAnimatedTransitioning>)animationControllerForDismissedController:(UIViewController *)dismissed {
    ARTPopoverAnimator *animator = [ARTPopoverAnimator new];
    animator.onScreenIndicator = NO;
    animator.delegateController = self;
    animator.landscapeOKOnExit = YES;
    
    return animator;
}

- (void)backButtonTapped:(id)sender {
    
    self.backButton.userInteractionEnabled = NO;
    self.isOKToShowNavigationBar = NO;
    
    self.delegate.isCardBackButtonPressed = YES;
    self.delegate.isCardNextCardButtonPressed = NO;
    self.delegate.isCardContinueButtonPressed = NO;
    self.delegate.isNonCardButtonPressed = NO;
    
    self.delegate.selectedDeck = self.selectedDeck;
    self.delegate.selectedCard = self.selectedCard;
    
    [self backToDeckTapDetected:sender];
}


- (void)continueButtonTapped:(id)sender {
    
    self.continueButton.userInteractionEnabled = NO;
    self.isOKToShowNavigationBar = NO;
    
    self.delegate.isCardBackButtonPressed = NO;
    self.delegate.isCardNextCardButtonPressed = NO;
    self.delegate.isCardContinueButtonPressed = YES;
    self.delegate.isNonCardButtonPressed = NO;
    
    
    self.delegate.selectedDeck = self.selectedDeck;
    self.delegate.selectedCard = self.selectedCard;
    
    
    [self backToDeckTapDetected:sender];
}

- (void)nextCardButtonTapped:(UITapGestureRecognizer* )sender {
    
    self.cardOverlayAnswerMenu.userInteractionEnabled = NO;
    self.isOKToShowNavigationBar = NO;
    
    [((ARTButton *)sender.view) setCustomHighlighted:YES];
    
    self.delegate.isCardBackButtonPressed = NO;
    self.delegate.isCardNextCardButtonPressed = YES;
    self.delegate.isCardContinueButtonPressed = NO;
    self.delegate.isNonCardButtonPressed = NO;
    
    self.delegate.selectedDeck = self.selectedDeck;
    self.delegate.selectedCard = self.selectedCard;
    
    [self backToDeckTapDetected:sender];
}

- (void)scoreTapDetected:(UITapGestureRecognizer* )sender {
    
    NSLog(@"score tap detected");
    
    [self showScore];
    
}

- (void)topicCompletedTapped:(UITapGestureRecognizer* )sender {
    __weak ARTCardViewController *wself = self;
    
    [[iRate sharedInstance] logEvent:YES];  //the yes means the rating is deferred until the next time the app is launched
    
    NSString *title = [NSString stringWithFormat:@"%@\nCompleted!",self.selectedDeck.uniqueID];
    
    NSString *message = [NSString stringWithFormat: @"Your dedication earned you the\n\"%@\".\n\nWe hope you had fun and learned cool trivia to share with friends and family!",[self.selectedDeck getAwardName]];
    
    self.topicCompletedAlertView = [[URBAlertView alloc] initWithTitle:title message:message cancelButtonTitle:nil otherButtonTitles:@"Continue", nil];
    
    UIImage *awardImage = [self.selectedDeck getAwardImage];
    
    [self.topicCompletedAlertView addAlertImage:awardImage imageScale:0.72 backgroundColor:[UIColor darkBlueColor] captionText:nil];
    
    
    
    [self.topicCompletedAlertView setHandlerBlock:^(NSInteger buttonIndex, URBAlertView *alertView) {
        __strong ARTCardViewController *sself = wself;
        
        [sself.topicCompletedAlertView hideWithAnimation:URBAlertAnimationDefault completionBlock:^{
            
            [sself finalScoreTapDetected:sender];
            
        }];
    }];
    [self.topicCompletedAlertView showWithAnimation:URBAlertAnimationDefault ];
    
    
}


- (void)finalScoreTapDetected:(UITapGestureRecognizer* )sender {
    
    NSLog(@"final score tap detected");
    
    // [self showScore];
    self.scorePlaceholderView.alpha = 0.0;
    
    ARTButton *tappedButton = (ARTButton *)sender.view;
    
    UIFont * font;
    if (IS_IPAD) {
        font = [UIFont fontWithName:@"HelveticaNeue" size:32];
    }
    else if (IS_IPHONE_5) {
        font = [UIFont fontWithName:@"HelveticaNeue" size:18];
    }
    else {
        font = [UIFont fontWithName:@"HelveticaNeue" size:22];
    }
    
    UIColor *color = [UIColor whiteColor];
    
    NSString *string = @"More Trivia";
    
    NSMutableAttributedString *triviaTopicsString = [[NSMutableAttributedString alloc] initWithString:string attributes:@{NSFontAttributeName:font,NSForegroundColorAttributeName:color}];
    
    [tappedButton setAttributedTitle:triviaTopicsString forState:UIControlStateNormal];
    [tappedButton addImage:[UIImage imageNamed:@"forward"] rightSide:YES withXOffset:8.0];
    
    for (UIGestureRecognizer *recognizer in sender.view.gestureRecognizers) {
        [sender.view removeGestureRecognizer:recognizer];
    }
    
    UITapGestureRecognizer *continueGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(continueButtonTapped:)];
    continueGesture.numberOfTapsRequired = 1;
    tappedButton.userInteractionEnabled = YES;
    [tappedButton addGestureRecognizer:continueGesture];
    
}

- (void) showTutorial {
    
    UIStoryboard *storyboard;
    if (IS_IPAD) {
        storyboard = [UIStoryboard storyboardWithName:@"Storyboard" bundle:nil];
        
    } else {
        storyboard = [UIStoryboard storyboardWithName:@"Main_iPhone" bundle:nil];
        
    }
    ARTMessageViewController *vc = (ARTMessageViewController *)[storyboard instantiateViewControllerWithIdentifier:@"MessageViewController"];
    
    vc.topString = @"Game Tutorial";
    
    NSString *header1 = @"Trivia Question";
    NSString *body1 = [NSString stringWithFormat:@"The question is displayed after you tap the Start Button.\n\nYou have %ld SECONDS to solve the question.",(long)secondsForQuestion];
    NSMutableDictionary *dict1 = [NSMutableDictionary new];
    [dict1 setObject:header1 forKey:@"headerText"];
    [dict1 setObject:body1 forKey:@"bodyText"];
    
    NSString *header4 = @"Trivia Answer";
    NSString *body4 = @"You only need to type in the FIRST 4 LETTERS of each word.\n\nYou are NOT penalized for entering incorrect answers, so KEEP TRYING.";
    NSMutableDictionary *dict4 = [NSMutableDictionary new];
    [dict4 setObject:header4 forKey:@"headerText"];
    [dict4 setObject:body4 forKey:@"bodyText"];
    
    NSString *header2 = @"Trivia Art";
    NSString *body2 = @"The art often CONTAINS CLUES to help answer the question.\n\nZOOM IN/OUT by pinching or double tapping on the art.";
    NSMutableDictionary *dict2 = [NSMutableDictionary new];
    [dict2 setObject:header2 forKey:@"headerText"];
    [dict2 setObject:body2 forKey:@"bodyText"];
    
    NSString *header3 = @"Hints";
    NSString *body3 = @"For each question, you can get answer hints by tapping the Hint button.\n\nEach hint partially fills in letters from the answer.";
    NSMutableDictionary *dict3 = [NSMutableDictionary new];
    [dict3 setObject:header3 forKey:@"headerText"];
    [dict3 setObject:body3 forKey:@"bodyText"];
    
    NSString *header5 = @"Scoring";
    NSString *body5 = @"You get fewer points for using hints.\n\nNo hint:\t5 points\n1 hint:   \t4 points\n2 hints:  \t3 points\n3 hints:  \t2 points";
    NSMutableDictionary *dict5 = [NSMutableDictionary new];
    [dict5 setObject:header5 forKey:@"headerText"];
    [dict5 setObject:body5 forKey:@"bodyText"];
    
    
    NSMutableArray *arrayOfMessages = [NSMutableArray arrayWithObjects:dict2, dict1, dict4, dict3, dict5, nil];
    
    vc.messageDictionaries = arrayOfMessages;
    
    NSString *button1Title = @"Continue";
    
    NSMutableDictionary *buttonDict = [NSMutableDictionary new];
    [buttonDict setObject:button1Title forKey:@"buttonTitle"];
    
    NSMutableArray *arrayOfButtons = [NSMutableArray arrayWithObjects:buttonDict, nil];
    
    vc.messageDictionaries = arrayOfMessages;
    vc.menuDictionaries = arrayOfButtons;
    
    vc.delegate = self;
    
    vc.transitioningDelegate = self;
    vc.modalPresentationStyle = UIModalPresentationCustom;
    
    [self presentViewController:vc animated:YES completion:^{
        
        self.originalContentView.userInteractionEnabled = YES; //after tutorial is shown, allow user interaction
        
    }];
}

- (void)dealloc {
    
    
    
}

@end
