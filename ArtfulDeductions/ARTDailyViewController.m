//
//  ARTDailyViewController.m
//  Artful Deductions
//
//  Created by Kyle Rokita on 12/23/14.
//  Copyright (c) 2014 Artful Deductions LLC. All rights reserved.
//

#import "ARTDailyViewController.h"

#import "ARTGalleryCardViewController.h"
#import "ARTNavigationController.h"
#import "ARTCard.h"
#import "ARTImageHelper.h"
#import "ARTNoTransitionAnimator.h"
#import "ARTMenuObject.h"
#import "ARTDeck.h"
#import "ARTUserInfo.h"
#import "ARTButton.h"
#import "UIColor+Extensions.h"
#import "ARTCardScrollView.h"
#import "UIButton+Extensions.h"
#import "ARTConstants.h"
#import "ARTTopView.h"

#import "ARTCardViewController.h"
#import "ARTAvatar.h"
#import "ARTPlayer.h"
#import "ARTAvatarHelper.h"
#import "ARTGame.h"

#import "ArtDailyViewDelegate.h"

#import "ARTStartViewController.h"
#import "ARTCategoryViewController.h"

#import "MKStoreManager.h"


@interface ARTDailyViewController () {
    
}

@property (strong, nonatomic) UIImageView *cardFrontImageView;
@property (strong, nonatomic) UIImageView *cardBackImageView;


@property (nonatomic) BOOL flippingCardInProgress;
@property (nonatomic) BOOL hidingcardInProgress;
@property (nonatomic) BOOL flippingToHidecardInProgress;

@property (strong, nonatomic) ADInterstitialAd *interstitial;

@end

@implementation ARTDailyViewController


- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.automaticallyAdjustsScrollViewInsets = NO;
    
    if ([[[ARTUserInfo sharedInstance] getVisualTheme] isEqual:@"white"]) {
        self.originalContentView.backgroundColor = [UIColor lightBackgroundColor]; //darkmode
    } else {
        self.originalContentView.backgroundColor = [UIColor darkBackgroundColor]; //darkmode
    }
    
    [self initializeCardGlobalVariables];
    
    
    self.scrollViewTopHeightConstraintDefault = self.scrollViewTopHeightConstraint.constant;
    self.scrollViewBottomHeightConstraintDefault = self.scrollViewBottomHeightConstraint.constant;
    
    if (IS_OldIphone) {
        self.bottomMenuHeightConstraint.constant = gameMenusHeightOldIphone;
    } else if (IS_IPHONE_5){
        self.bottomMenuHeightConstraint.constant = gameMenusHeightIphone5;
    } else if (IS_IPHONE_6){
        self.bottomMenuHeightConstraint.constant = gameMenusHeightIphone6;
    } else if (IS_IPHONE_6Plus){
        self.bottomMenuHeightConstraint.constant = gameMenusHeightIphone6Plus;
    } else if (IS_IPAD){
        self.bottomMenuHeightConstraint.constant = gameMenusHeightIpad;
    }
    

}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void) viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    self.navigationController.delegate = self;
    
    [(ARTNavigationController*)[self navigationController] setLandscapeOK:YES];
    [self.navigationController setNavigationBarHidden:YES animated:NO];
    
    if (self.backButton) {
        [self.backButton removeFromSuperview];
        self.backButton = nil;
    }
    
    self.backButton = [[UIButton alloc] backButtonWith:@"Back" tintColor:[UIColor blueNavBarColor] target:self andAction:@selector(backToGalleryTapDetected:)];
    [self.originalContentView addSubview:self.backButton];
    [self.originalContentView sendSubviewToBack:self.backButton];
    
    [self.originalContentView layoutIfNeeded];
    
    [self setupLogoImageView];
    
    NSMutableArray *proportionArray = [[NSMutableArray alloc] initWithObjects:[NSNumber numberWithFloat:0.2],[NSNumber numberWithFloat:0.6],[NSNumber numberWithFloat:0.2],nil];

    [self.bottomMenu setupWithButtonCount:3
                    buttonWidthProportions:proportionArray
                                withFrame:self.bottomMenu.bounds
                    withPortraitIndicator:NO];
    
    [self setupBottomMenuButtons];
    
    
    NSArray *subViews = self.scrollView.subviews;
    for (NSInteger i = 0; i < subViews.count; i++) {
        [subViews[i] removeFromSuperview];
    }
    
    [self setupScrollView];
    
    [self.originalContentView layoutIfNeeded];
    
    [self centerScrollViewContents];
    
    if (self.topView) {
        [self.topView removeFromSuperview];
        self.topView = nil;
    }
    
    self.topView = [[ARTTopView alloc] init];
    
    [self.originalContentView addSubview:self.topView];
    [self.originalContentView sendSubviewToBack:self.topView];
    [self.originalContentView insertSubview:self.logoImageView belowSubview:self.scrollView];
    
    [self setupScoreView];
    
    self.isOKForStartButtonToBlink  = YES;
    [self animateStartButtonFlash];
    
    
    if ([MKStoreManager isFeaturePurchased:kProductClassicSeries] || [MKStoreManager isFeaturePurchased:kProductRemoveAds]) {
        self.canDisplayBannerAds = NO;
    } else {
        self.canDisplayBannerAds = YES;
    }
}
- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
    // [self showFullScreenAd];

    NSLog(@"logoImageView: %@",self.logoImageView);
    NSLog(@"logoImageLabel: %@",self.logoImageLabel);
}

-(void)viewWillLayoutSubviews {

    [self.scrollView setZoomScale:self.scrollView.minimumZoomScale animated:NO];
    [self centerScrollViewContents];
}

-(void)showFullScreenAd {
    //Check if already requesting ad
        self.interstitial = [[ADInterstitialAd alloc] init];
        self.interstitial.delegate = self;
        self.interstitialPresentationPolicy = ADInterstitialPresentationPolicyManual;
        [self requestInterstitialAdPresentation];
        NSLog(@"interstitialAdREQUEST");

}

-(void)interstitialAd:(ADInterstitialAd *)interstitialAd didFailWithError:(NSError *)error {
    self.interstitial = nil;
    NSLog(@"interstitialAd didFailWithERROR");
    NSLog(@"%@", error);
}

-(void)interstitialAdDidLoad:(ADInterstitialAd *)interstitialAd {
    NSLog(@"interstitialAdDidLOAD");
    if (interstitialAd != nil && self.interstitial != nil ) {
        NSLog(@"interstitialAdDidPRESENT");
    }//end if
}

-(void)interstitialAdDidUnload:(ADInterstitialAd *)interstitialAd {
    self.interstitial = nil;
    NSLog(@"interstitialAdDidUNLOAD");
}

-(void)interstitialAdActionDidFinish:(ADInterstitialAd *)interstitialAd {
    self.interstitial = nil;
    NSLog(@"interstitialAdDidFINISH");
}




- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    
    self.isOKForStartButtonToBlink  = NO;

}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    [super prepareForSegue:segue sender:sender];
    
    if ([segue.identifier isEqual:@"CardSegue"]) {
        
        ARTCardViewController *cardViewController = (ARTCardViewController *)segue.destinationViewController;

        
        cardViewController.delegate = self;
        cardViewController.selectedDeck = self.selectedDeck;
        cardViewController.selectedCard = self.selectedCard;
        cardViewController.currentGame = self.currentGame;
        
    }
    
}

- (void)setupLogoImageView {
    
    /*if ([[[ARTUserInfo sharedInstance] getVisualTheme] isEqual:@"white"]) {
     self.logoImageView.image = [UIImage imageNamed:@"LogoDarkBlue"]; //darkmode
     } else {
     self.logoImageView.image = [UIImage imageNamed:@"LogoLightBlue"];
     }
     
     self.logoImageView.contentMode = UIViewContentModeScaleAspectFit;*/
    
    self.logoImageView.image = [UIImage new];

    
    self.logoImageLabel = [[UILabel alloc] initWithFrame:self.logoImageView.bounds];
    self.logoImageLabel.textAlignment = NSTextAlignmentCenter;
    
    if ([self.currentGame.gameMode isEqual:@"single"]) {
        self.logoImageLabel.text = [self setupLogoImageviewFromString:self.selectedCard.category];
    } else {
        self.logoImageLabel.text = [self setupDateStringFromString:self.selectedCard.category];
    }
    
    if ([[[ARTUserInfo sharedInstance] getVisualTheme] isEqual:@"white"]) {
        self.logoImageLabel.textColor = [UIColor blackColor];
    } else {
        self.logoImageLabel.textColor = [UIColor lightBlueColor];
    }
    
    self.logoImageLabel.numberOfLines = 0;
    
    if (IS_IPAD) {
        self.logoImageLabel.font = [UIFont fontWithName:@"HelveticaNeue-Medium" size:30];
    }
    else {
        self.logoImageLabel.font = [UIFont fontWithName:@"HelveticaNeue-Medium" size:20];
    }
    
    NSArray *subViews = self.logoImageView.subviews;
    for (NSInteger i = 0; i < subViews.count; i++) {
        [subViews[i] removeFromSuperview];
    }

    
    [self.logoImageView addSubview:self.logoImageLabel];
    [self.originalContentView sendSubviewToBack:self.logoImageView];
    
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
    
    NSString *dateText = [NSString stringWithFormat:@"%@ %@",month,day];
    
    return dateText;
}

- (void)setupBottomMenuButtons {
    
    UIFont * font;
    if (IS_IPAD) {
        font = [UIFont fontWithName:@"HelveticaNeue" size:34];
    }
    else if (IS_IPHONE_6 || IS_IPHONE_6Plus) {
        font = [UIFont fontWithName:@"HelveticaNeue" size:24];
    }
    else {
        font = [UIFont fontWithName:@"HelveticaNeue" size:20];
    }
    
    UIColor *color = [UIColor whiteColor];
    
    UIButton *button0 = self.bottomMenu.arrayOfButtons[0];
    
    NSMutableAttributedString *attrString = [[NSMutableAttributedString alloc] initWithString:@" " attributes:@{NSFontAttributeName:font,NSForegroundColorAttributeName:color}];
    [button0 setAttributedTitle:attrString forState:UIControlStateNormal];
    
    UITapGestureRecognizer *previousCardGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(previousCardTapDetected:)];
    previousCardGesture.numberOfTapsRequired = 1;
    button0.userInteractionEnabled = YES;
    [button0 addGestureRecognizer:previousCardGesture];
    
    [button0 addImage:[UIImage imageNamed:@"back"] rightSide:NO withXOffset:0.0];
    
    UIButton *button1 = self.bottomMenu.arrayOfButtons[1];
    
    NSArray *recognizers = [button1 gestureRecognizers];
    for (NSInteger i = 0; i < recognizers.count; i ++) {
        UIGestureRecognizer *recognizer = recognizers[i];
        [button1 removeGestureRecognizer:recognizer];
    }
    
    if (!self.isCardJustPlayed) {
        attrString = [[NSMutableAttributedString alloc] initWithString:@"Tap To Play" attributes:@{NSFontAttributeName:font,NSForegroundColorAttributeName:color}];
        [button1 setAttributedTitle:attrString forState:UIControlStateNormal];
        
        UITapGestureRecognizer *flipCardGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(startCardTapped:)];
        flipCardGesture.numberOfTapsRequired = 1;
        button1.userInteractionEnabled = YES;
        [button1 addGestureRecognizer:flipCardGesture];
    } else {
        attrString = [[NSMutableAttributedString alloc] initWithString:@"Flip Question" attributes:@{NSFontAttributeName:font,NSForegroundColorAttributeName:color}];
        [button1 setAttributedTitle:attrString forState:UIControlStateNormal];
        
        UITapGestureRecognizer *flipCardGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(flipCardTapDetected:)];
        flipCardGesture.numberOfTapsRequired = 1;
        button1.userInteractionEnabled = YES;
        [button1 addGestureRecognizer:flipCardGesture];
    }
    
    
    
    UIButton *button2 = self.bottomMenu.arrayOfButtons[2];
    
    attrString = [[NSMutableAttributedString alloc] initWithString:@" " attributes:@{NSFontAttributeName:font,NSForegroundColorAttributeName:color}];
    [button2 setAttributedTitle:attrString forState:UIControlStateNormal];
    
    UITapGestureRecognizer *nextCardGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(nextCardTapDetected:)];
    nextCardGesture.numberOfTapsRequired = 1;
    button2.userInteractionEnabled = YES;
    [button2 addGestureRecognizer:nextCardGesture];
    
    [button2 addImage:[UIImage imageNamed:@"forward"] rightSide:YES withXOffset:0.0];
    
}

- (void)willRotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation duration:(NSTimeInterval)duration {
    
    if (UIDeviceOrientationIsLandscape(toInterfaceOrientation)) {
        self.backButton.hidden = YES;
        self.scrollViewTopHeightConstraint.constant = 0.0;
        self.scrollViewBottomHeightConstraint.constant = 0.0;
        [self animateBottomMenuHidden:YES];
        self.logoImageView.hidden = YES;
        self.topView.hidden = YES;
        self.bottomMenu.hidden = YES;
        self.scoreLabel.hidden = YES;
        
    }
    else {
        self.backButton.hidden = NO;
        self.scrollViewTopHeightConstraint.constant = self.scrollViewTopHeightConstraintDefault;
        self.scrollViewBottomHeightConstraint.constant = self.scrollViewBottomHeightConstraintDefault;
        [self animateBottomMenuHidden:NO];
        self.logoImageView.hidden = NO;
        self.topView.hidden = NO;
        self.bottomMenu.hidden = NO;
        self.scoreLabel.hidden = NO;
        

    }
    
}


- (void)didRotateFromInterfaceOrientation:(UIInterfaceOrientation)fromInterfaceOrientation {
    [self setZoomMinimumForView:self.scrollView withCardOrientation:self.selectedCard.orientation];
    [self.scrollView setZoomScale:self.scrollView.minimumZoomScale animated:YES];
    //[self centerScrollViewContents];
}

- (void)initializeCardGlobalVariables {
    self.isShowingImageSide = YES;
    self.isCardJustPlayed = NO;
    self.flippingCardInProgress = NO;
    self.hidingcardInProgress = NO;
    self.flippingToHidecardInProgress = NO;
}

- (void)setupScrollView {
    
    self.cardFrontImageView = [self makecardImageViewWithCard:self.selectedCard forSide:@"front"];
    self.cardBackImageView = [self makecardImageViewWithCard:self.selectedCard forSide:@"back"];
    
    self.scrollView.delegate = self;
    self.scrollView.contentSize = self.cardFrontImageView.image.size;
    
    self.scrollView.maximumZoomScale = 1.0;
    
    CGFloat minScale = [self setZoomMinimumForView:self.scrollView withCardOrientation:self.selectedCard.orientation];
    
    self.scrollView.minimumZoomScale = minScale;
    self.scrollView.zoomScale = minScale;
    
    self.scrollView.showsHorizontalScrollIndicator = NO;
    self.scrollView.showsVerticalScrollIndicator = NO;
    
    UITapGestureRecognizer *doubleTapRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(scrollViewDoubleTapped:)];
    doubleTapRecognizer.numberOfTapsRequired = 2;
    doubleTapRecognizer.numberOfTouchesRequired = 1;
    [self.scrollView addGestureRecognizer:doubleTapRecognizer];
    
    UITapGestureRecognizer *singleTapRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(scrollViewSingleTapped:)];
    singleTapRecognizer.numberOfTapsRequired = 1;
    singleTapRecognizer.numberOfTouchesRequired = 1;
    [self.scrollView addGestureRecognizer:singleTapRecognizer];
    
    [singleTapRecognizer requireGestureRecognizerToFail:doubleTapRecognizer];
    
    
    UISwipeGestureRecognizer *leftSwipeRecognizer = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(leftSwipeDetected:)];
    leftSwipeRecognizer.direction = UISwipeGestureRecognizerDirectionLeft;
    leftSwipeRecognizer.numberOfTouchesRequired = 1;
    [self.scrollView addGestureRecognizer:leftSwipeRecognizer];
    
    UISwipeGestureRecognizer *rightSwipeRecognizer = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(rightSwipeDetected:)];
    rightSwipeRecognizer.direction = UISwipeGestureRecognizerDirectionRight;
    rightSwipeRecognizer.numberOfTouchesRequired = 1;
    [self.scrollView addGestureRecognizer:rightSwipeRecognizer];
    
    
    if (self.isShowingImageSide) {
        [self.scrollView addSubview:self.cardFrontImageView];
    } else {
        [self.scrollView addSubview:self.cardBackImageView];
    }
    
}


- (UIImageView *)makecardImageViewWithCard:(ARTCard *)card forSide:(NSString *)sideString {
    
    NSString *cardFilename;
    if ([sideString  isEqual: @"front"]) {
        cardFilename = card.frontFilename;
    } else {
        cardFilename = card.backFilename;
    }
    
    UIImage *portraitImage = [[ARTImageHelper sharedInstance] getHQImageWithFileName:cardFilename ];
    
    UIImageView * imageView = [[UIImageView alloc] initWithImage:portraitImage];
    
    CGFloat imageViewWidth = imageView.image.size.width;
    CGFloat imageViewHeight = imageView.image.size.height;
    CGFloat imageViewX = 0.0;
    CGFloat imageViewY = 0.0;
    
    CGRect shape = CGRectMake(imageViewX, imageViewY, imageViewWidth, imageViewHeight);
    imageView.frame = shape;
    
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


- (CGFloat)setZoomMinimumForView:(UIScrollView *)scrollView withCardOrientation:(NSString *)cardOrientation {
    
    CGFloat scaleWidth;
    CGFloat scaleHeight;
    CGFloat minScale;
    
    
    
    scaleWidth = scrollView.bounds.size.width / self.cardFrontImageView.image.size.width;
    scaleHeight = scrollView.bounds.size.height / self.cardFrontImageView.image.size.height;
    
    
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

- (UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView {
    // Return the view that you want to zoom
    if (self.isShowingImageSide) {
        return self.cardFrontImageView;
    } else {
        return self.cardBackImageView;
    }
    
    
}

- (void)scrollViewDidZoom:(UIScrollView *)scrollView {
    // The scroll view has zoomed, so you need to re-center the contents
    [self centerScrollViewContents];
    
}

- (void)scrollViewDidEndZooming:(UIScrollView *)scrollView withView:(UIView *)view atScale:(CGFloat)scale {
    if (self.flippingCardInProgress) {
        self.flippingCardInProgress = NO;
        [self animateFlipCardViewsPart2inDirection:@"right"];
    }
    else if (self.hidingcardInProgress) {
        self.hidingcardInProgress = NO;
        
        [self animateHidecard];
    }
    
}

- (void)centerScrollViewContents {
    
    CGSize boundsSize = self.scrollView.bounds.size;
    CGRect contentsFrame;
    
    if (self.isShowingImageSide) {
        contentsFrame =  self.cardFrontImageView.frame;
    } else {
        contentsFrame =  self.cardBackImageView.frame;
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
        self.cardFrontImageView.frame = contentsFrame;
    } else {
        self.cardBackImageView.frame = contentsFrame;    }
    
}

- (void)flipCardTapDetected:(UITapGestureRecognizer*)sender {
    NSLog(@"Tap Detected");
    
    [((ARTButton *)sender.view) setCustomHighlighted:YES];
    
    
    [self animateFlipCardViewsInDirection:@"right"];
}

- (void)upSwipeDetected:(UISwipeGestureRecognizer*)sender {
    NSLog(@"Up Swipe Detected");
    
    UIInterfaceOrientation currentOrientation = [[UIApplication sharedApplication] statusBarOrientation];

    if (UIInterfaceOrientationIsPortrait(currentOrientation)) {
        [self animateFlipCardViewsInDirection:@"down"];
    }
}

- (void)rightSwipeDetected:(UISwipeGestureRecognizer*)sender {
    NSLog(@"Right Swipe Detected");
    
    UIInterfaceOrientation currentOrientation = [[UIApplication sharedApplication] statusBarOrientation];
    
    if (UIInterfaceOrientationIsPortrait(currentOrientation)) {
        [self advanceToPreviousCard];
    }
}

- (void)leftSwipeDetected:(UISwipeGestureRecognizer*)sender {
    NSLog(@"Left Swipe Detected");
    
    UIInterfaceOrientation currentOrientation = [[UIApplication sharedApplication] statusBarOrientation];
    
    if (UIInterfaceOrientationIsPortrait(currentOrientation)) {
        [self advanceToNextCard];
    }
}

- (void)downSwipeDetected:(UISwipeGestureRecognizer*)sender {
    NSLog(@"Down Swipe Detected");
    
    UIInterfaceOrientation currentOrientation = [[UIApplication sharedApplication] statusBarOrientation];
    
    if (UIInterfaceOrientationIsPortrait(currentOrientation)) {
        [self animateFlipCardViewsInDirection:@"up"];
    }
}

- (void)previousCardTapDetected:(UITapGestureRecognizer*)sender {
    
    [((ARTButton *)sender.view) setCustomHighlighted:YES];
    
    
    [self advanceToPreviousCard];
}

- (void)advanceToPreviousCard {
    
    NSInteger tempCardIndex = self.cardIndex;
    NSInteger tempDeckIndex = self.deckIndex;
    
    if (tempCardIndex - 1 < 0) {
        
        if (tempDeckIndex - 1 < 0) {
            tempDeckIndex = self.sortedCardsFromSortedDecks.count - 1;
            tempCardIndex = ((NSMutableArray *)self.sortedCardsFromSortedDecks[tempDeckIndex]).count - 1;
        } else {
            tempDeckIndex -= 1;
            tempCardIndex = ((NSMutableArray *)self.sortedCardsFromSortedDecks[tempDeckIndex]).count - 1;
        }
    } else {
        tempCardIndex -= 1;
    }
    
    self.cardIndex = tempCardIndex;
    self.deckIndex = tempDeckIndex;
    
    ARTCard *card = self.sortedCardsFromSortedDecks[tempDeckIndex][tempCardIndex];
    
        NSLog(@"Tap Detected");
        
        self.cardIndex = tempCardIndex;
        self.deckIndex = tempDeckIndex;
        
        if (self.isShowingImageSide)
            [self animateCardView:self.cardFrontImageView OffScreenToRight:YES];
        else {
            [self animateCardView:self.cardBackImageView OffScreenToRight:YES];
        }
        
        ARTCard *nextCard = self.sortedCardsFromSortedDecks[self.deckIndex][self.cardIndex];
    ARTDeck *nextDeck = self.sortedDecks[self.deckIndex];

    
        self.selectedCard = nextCard;
    self.selectedDeck = nextDeck;
        
        [self initializeCardGlobalVariables];
        [self setupScrollView];
        self.cardFrontImageView.hidden = YES;
        
        [self animateCardView:self.cardFrontImageView OnScreenFromRight:NO];
        
    if ([self.currentGame.gameMode isEqual:@"single"]) {
        self.logoImageLabel.text = [self setupLogoImageviewFromString:self.selectedCard.category];
    } else {
        self.logoImageLabel.text = [self setupDateStringFromString:self.selectedCard.category];
    }
    
    //this triggers the start button instead of flip button
    self.isCardJustPlayed = NO;
    [self setupBottomMenuButtons];
    
    [self setupScoreView];


}

- (NSString *)setupLogoImageviewFromString:(NSString *)cardString {
    
    NSString *category = cardString;
    
    NSString *questionNumber = [self.selectedCard.categoryNumber stringValue];
    
    return [NSString stringWithFormat:@"%@ #%@",category,questionNumber];
}

- (void)animateCardView:(UIImageView*)imageView OffScreenToRight:(BOOL)rightDirection {
    
    
    CGFloat x = imageView.frame.origin.x + self.scrollView.frame.size.width * (rightDirection ? 1 : -1);
    CGFloat y = imageView.frame.origin.y;
    CGFloat width = imageView.frame.size.width;
    CGFloat height = imageView.frame.size.height;
    
    CGRect nextFrame = CGRectMake(x,y,width,height);
    
    [UIView animateWithDuration:0.2
                          delay:0.0
                        options:UIViewAnimationOptionCurveEaseOut | UIViewAnimationOptionAllowAnimatedContent
                     animations:^{
                         imageView.frame = nextFrame;
                         
                     } completion:^(BOOL finished) {
                         [imageView removeFromSuperview];
                     }];
}

- (void)animateCardView:(UIImageView*)imageView OnScreenFromRight:(BOOL)rightDirection {
    
    CGRect nextFrame = imageView.frame;
    
    CGFloat x = imageView.frame.origin.x + self.scrollView.frame.size.width * (rightDirection ? 1 : -1);
    CGFloat y = imageView.frame.origin.y;
    CGFloat width = imageView.frame.size.width;
    CGFloat height = imageView.frame.size.height;
    
    CGRect currentFrame = CGRectMake(x,y,width,height);
    imageView.frame = currentFrame;
    imageView.hidden = NO;
    
    [UIView animateWithDuration:0.2
                          delay:0.0
                        options:UIViewAnimationOptionCurveEaseOut | UIViewAnimationOptionAllowAnimatedContent
                     animations:^{
                         imageView.frame = nextFrame;
                         
                     } completion:^(BOOL finished) {
                         
                     }];
}

- (void)nextCardTapDetected:(UITapGestureRecognizer*)sender {
    
    [((ARTButton *)sender.view) setCustomHighlighted:YES];
    
    [self advanceToNextCard];
}

- (void)advanceToNextCard {
    
    NSInteger tempCardIndex = self.cardIndex;
    NSInteger tempDeckIndex = self.deckIndex;
    
    NSMutableArray *cardArray  = self.sortedCardsFromSortedDecks[self.deckIndex];
    if (tempCardIndex + 1 == cardArray.count) {
        tempCardIndex = 0;
        
        if (tempDeckIndex + 1 == self.sortedCardsFromSortedDecks.count) {
            tempDeckIndex = 0;
        } else {
            tempDeckIndex += 1;
        }
    } else {
        tempCardIndex += 1;
    }
    
    self.cardIndex = tempCardIndex;
    self.deckIndex = tempDeckIndex;
    
    NSLog(@"Tap Detected");
        
        if (self.isShowingImageSide)
            [self animateCardView:self.cardFrontImageView OffScreenToRight:NO];
        else {
            [self animateCardView:self.cardBackImageView OffScreenToRight:NO];
        }
        
        ARTCard *nextCard = self.sortedCardsFromSortedDecks[self.deckIndex][self.cardIndex];
        ARTDeck *nextDeck = self.sortedDecks[self.deckIndex];

    
        self.selectedCard = nextCard;
    self.selectedDeck = nextDeck;
        
        [self initializeCardGlobalVariables];
        [self setupScrollView];
        self.cardFrontImageView.hidden = YES;
        
        [self animateCardView:self.cardFrontImageView OnScreenFromRight:YES];
        
    if ([self.currentGame.gameMode isEqual:@"single"]) {
        self.logoImageLabel.text = [self setupLogoImageviewFromString:self.selectedCard.category];
    } else {
        self.logoImageLabel.text = [self setupDateStringFromString:self.selectedCard.category];
    }
    
    //this triggers the start button instead of flip button
    self.isCardJustPlayed = NO;
    [self setupBottomMenuButtons];
    
    [self setupScoreView];
}

- (void)scrollViewSingleTapped:(UITapGestureRecognizer*)sender {
    NSLog(@"Single tap detected");
    
    /*if (self.bottomMenu.alpha == 1.0) {
     [self animateBottomMenuHidden:YES];
     self.backButton.hidden = YES;
     
     } else {
     [self animateBottomMenuHidden:NO];
     self.backButton.hidden = NO;
     }*/
    
}

- (void)scrollViewDoubleTapped:(UITapGestureRecognizer*)sender {
    NSLog(@"Double tap detected");
    
    if (self.scrollView.zoomScale == self.scrollView.minimumZoomScale) {
        // 1
        CGPoint pointInView;
        if (self.isShowingImageSide) {
            pointInView = [sender locationInView:self.cardFrontImageView];
        } else {
            pointInView = [sender locationInView:self.cardBackImageView];    }
        
        // 2
        CGFloat newZoomScale = self.scrollView.zoomScale * 1.75;
        newZoomScale = MIN(newZoomScale, self.scrollView.maximumZoomScale);
        
        // 3
        CGSize scrollViewSize = self.scrollView.bounds.size;
        
        CGFloat w = scrollViewSize.width / newZoomScale;
        CGFloat h = scrollViewSize.height / newZoomScale;
        CGFloat x = pointInView.x - (w / 2.0);
        CGFloat y = pointInView.y - (h / 2.0);
        
        CGRect rectToZoomTo = CGRectMake(x, y, w, h);
        
        // 4
        [self.scrollView zoomToRect:rectToZoomTo animated:YES];
    }
    else {
        [self.scrollView setZoomScale:self.scrollView.minimumZoomScale animated:YES];
    }
    
}

- (void)startCardTapped:(UITapGestureRecognizer *)sender {
    
    self.isCardJustPlayed = YES;
    
     [self performSegueWithIdentifier:@"CardSegue" sender:self];

}

- (void)animateFlipCardViewsInDirection:(NSString *)direction {
    
    self.flippingCardInProgress = YES;
    
    if (self.scrollView.zoomScale != self.scrollView.minimumZoomScale) {
        [self.scrollView setZoomScale:self.scrollView.minimumZoomScale animated:YES];
    }
    else {
        self.flippingCardInProgress = NO;
        [self animateFlipCardViewsPart2inDirection:direction];
    }
    
}

- (void)animateBottomMenuHidden:(BOOL)onScreenIndicator {
    
    CGFloat alpha;
    
    if (onScreenIndicator) {
        alpha = 0.0;
    } else {
        alpha = 1.0;
    }
    
    [UIView animateWithDuration:0.3
                          delay:0.0
                        options:UIViewAnimationOptionAllowAnimatedContent
                     animations:^{
                         self.bottomMenu.alpha = alpha;
                     } completion:^(BOOL finished) {
                         
                     }];
}


- (void)animateHidecard {
    
    
    self.hidingcardInProgress = YES;
    if (self.scrollView.zoomScale != self.scrollView.minimumZoomScale) {
        [self.scrollView setZoomScale:self.scrollView.minimumZoomScale animated:YES];
    }
    else {
        self.hidingcardInProgress = NO;
        if (self.isShowingImageSide == NO) {
            self.flippingToHidecardInProgress = YES;
            [self animateFlipCardViewsInDirection:@"right"];
        }
        else {
            
            if ([self.delegate isMemberOfClass:[ARTStartViewController class]]) {
            
            self.delegate.sortedCardsFromDailyDecks = self.sortedCardsFromSortedDecks;
            self.delegate.dailyDecks = self.sortedDecks;
            self.delegate.deckIndex = self.deckIndex;
            self.delegate.cardIndex = self.cardIndex;
            self.delegate.isDailyCardJustPlayed = YES;
                
            } else if ([self.delegate isMemberOfClass:[ARTCategoryViewController class]]) {
                
                self.delegate.isCardBackButtonPressed = YES;
                self.delegate.isCardNextCardButtonPressed = NO;
                self.delegate.isCardContinueButtonPressed = NO;
                self.delegate.isNonCardButtonPressed = NO;
                
                self.delegate.selectedCard = self.selectedCard;
                self.delegate.selectedDeck = self.selectedDeck;

                
            }
            
            [self.navigationController popViewControllerAnimated:YES];
        }
    }
}

- (void)animateFlipCardViewsPart2inDirection:(NSString *)flipDirection {
    UIView *currentcardView;
    UIView *nextcardView;
    
    if (self.isShowingImageSide) {
        currentcardView = self.cardFrontImageView;
        
        nextcardView = self.cardBackImageView;
        
        self.isShowingImageSide = NO;
    } else {
        currentcardView = self.cardBackImageView;
        
        nextcardView = self.cardFrontImageView;
        
        self.isShowingImageSide = YES;
    }
    
    self.scrollView.zoomScale = self.scrollView.minimumZoomScale;
    
    UIViewAnimationOptions swipe;
    if ([flipDirection isEqual:@"right"]) {
        swipe = UIViewAnimationOptionTransitionFlipFromLeft;
    }
    else if ([flipDirection isEqual:@"left"]) {
        swipe = UIViewAnimationOptionTransitionFlipFromRight;
    }
    else if ([flipDirection isEqual:@"down"]) {
        swipe = UIViewAnimationOptionTransitionFlipFromTop;
    }
    else {
        swipe = UIViewAnimationOptionTransitionFlipFromBottom;
    }
    
    [UIView transitionFromView:currentcardView
                        toView:nextcardView
                      duration:cardFlipDuration
                       options:swipe|UIViewAnimationOptionAllowAnimatedContent
                    completion:^(BOOL finished) {
                        if (finished) {
                            if (self.flippingToHidecardInProgress) {
                                self.flippingToHidecardInProgress = NO;
                                [self animateHidecard];
                            }
                            
                        }
                    }];
    
}

- (void)setupScoreView {
    
    if (self.scoreLabel) {
        [self.scoreLabel removeFromSuperview];
        self.scoreLabel = nil;
    }
    
    
    CGFloat labelHeight = self.logoImageView.frame.size.height;
    CGFloat labelY = self.logoImageView.frame.origin.y;
    
    
    
    
    
    
    NSMutableAttributedString *attrString = [self getScoreLabelText];
    
    CGSize maximumLabelSize = CGSizeMake(self.originalContentView.bounds.size.width, labelHeight);
    
    NSString *string = attrString.string;
    CGRect textRect = [string boundingRectWithSize:maximumLabelSize
                                           options:(NSStringDrawingUsesLineFragmentOrigin|NSStringDrawingUsesFontLeading)
                                        attributes:[attrString attributesAtIndex:0 effectiveRange:nil]
                                           context:nil];
    string = nil;
    
    CGFloat labelWidth = ceil(textRect.size.width)+20.0 ;
    
    CGFloat labelX = self.originalContentView.bounds.size.width - labelWidth - 5.0;
    
    CGRect labelFrame = CGRectMake(labelX,labelY, labelWidth, labelHeight);
    
    self.scoreLabel = [[UILabel alloc] initWithFrame:labelFrame];
    
    self.scoreLabel.textAlignment = NSTextAlignmentCenter;
    self.scoreLabel.numberOfLines = 0;
    
    self.scoreLabel.layer.cornerRadius = 15.0;

    if (self.selectedCard.isPlayed) {
        self.scoreLabel.backgroundColor = [UIColor greenishColor];
    } else {
        self.scoreLabel.backgroundColor = [UIColor emergencyRedColor];
    }
    
    self.scoreLabel.opaque = YES;
    
    self.scoreLabel.clipsToBounds = YES;
    
    self.scoreLabel.attributedText = attrString;
    
    [self.originalContentView addSubview:self.scoreLabel];
    [self.originalContentView insertSubview:self.scoreLabel aboveSubview:self.logoImageView];
    
    self.scoreLabel.alpha = 0.9;
    
    [UIView animateWithDuration:0.04
                          delay:0.0
                        options:UIViewAnimationOptionAllowAnimatedContent | UIViewAnimationCurveLinear
                     animations:^{
                         self.scoreLabel.transform = CGAffineTransformScale(CGAffineTransformIdentity, 1./1.2, 1./1.2);
                     } completion:^(BOOL finished) {
                         [UIView animateWithDuration:0.25
                                               delay:0.0
                                             options:UIViewAnimationOptionAllowAnimatedContent | UIViewAnimationCurveLinear
                                          animations:^{
                                              self.scoreLabel.transform = CGAffineTransformScale(CGAffineTransformIdentity, 1.0, 1.00);
                                              self.scoreLabel.alpha = 1.0;

                                          } completion:^(BOOL finished) {
                                           
                                          }];
                     }];
    
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

- (void)animateStartButtonFlash {
    CGAffineTransform currentTransform = self.bottomMenu.transform;
    
    if (self.isOKForStartButtonToBlink) {
        
        
        if (CGAffineTransformIsIdentity(currentTransform)) {
            
            [UIView animateWithDuration:0.45
                                  delay:0.0
                                options:UIViewAnimationOptionAllowAnimatedContent  | UIViewAnimationOptionAllowUserInteraction | UIViewAnimationOptionCurveLinear
                             animations:^{
                                 self.bottomMenu.transform = CGAffineTransformMakeScale(0.96, 0.96);
                                 self.bottomMenu.alpha = 1.0;
                             } completion:^(BOOL finished) {
                                 [self performSelector:@selector(animateStartButtonFlash) withObject:nil afterDelay:0.00 inModes:[NSArray arrayWithObject:NSRunLoopCommonModes]];
                                 
                             }];
        } else {
            
            [UIView animateWithDuration:0.45
                                  delay:0.0
                                options:UIViewAnimationOptionAllowAnimatedContent  | UIViewAnimationOptionAllowUserInteraction | UIViewAnimationOptionCurveLinear
                             animations:^{
                                 self.bottomMenu.transform = CGAffineTransformIdentity;
                                 self.bottomMenu.alpha = 1.0;
                             } completion:^(BOOL finished) {
                                 [self performSelector:@selector(animateStartButtonFlash) withObject:nil afterDelay:0.00 inModes:[NSArray arrayWithObject:NSRunLoopCommonModes]];
                             }];
        }
        
    } else {
        self.bottomMenu.transform = CGAffineTransformIdentity;
        self.bottomMenu.alpha = 1.0;
        
    }
    
}




- (id<UIViewControllerAnimatedTransitioning>)navigationController:(UINavigationController *)navigationController animationControllerForOperation:(UINavigationControllerOperation)operation fromViewController:(UIViewController *)fromVC toViewController:(UIViewController *)toVC {
    
    ARTNoTransitionAnimator *animator = [ARTNoTransitionAnimator new];
    return animator;
}



- (void)backToGalleryTapDetected:(id)sender {
    NSLog(@"Single tap detected");
    
    [self animateHidecard];
    
}
@end
