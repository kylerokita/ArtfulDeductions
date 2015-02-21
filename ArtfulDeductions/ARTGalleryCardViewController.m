//
//  ARTGalleryCardViewController.m
//  Artful Deductions
//
//  Created by Kyle Rokita on 8/11/14.
//  Copyright (c) 2014 Artful Deductions LLC. All rights reserved.
//

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
#import "MKStoreManager.h"

@interface ARTGalleryCardViewController () {
    
}

@property (strong, nonatomic) UIImageView *cardFrontImageView;
@property (strong, nonatomic) UIImageView *cardBackImageView;

@property (nonatomic) BOOL isShowingImageSide;
@property (nonatomic) BOOL isShowingQuestionLabel;
@property (nonatomic) BOOL isShowingAnswerLabel;
@property (nonatomic) BOOL isShowingAnswer;


@property (nonatomic) BOOL flippingCardInProgress;
@property (nonatomic) BOOL hidingcardInProgress;
@property (nonatomic) BOOL flippingToHidecardInProgress;

@end

@implementation ARTGalleryCardViewController


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
    
    
    if (![MKStoreManager isFeaturePurchased:kProductClassicSeries]) {
        self.canDisplayBannerAds = YES;
    } else {
        self.canDisplayBannerAds = NO;
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
    
    self.backButton = [[UIButton alloc] backButtonWith:@"Gallery" tintColor:[UIColor blueNavBarColor] target:self andAction:@selector(backToGalleryTapDetected:)];
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
    
    [self setupScrollView];
    
    [self.originalContentView layoutIfNeeded];
    
    [self centerScrollViewContents];
    
    self.topView = [[ARTTopView alloc] init];
    
    [self.originalContentView addSubview:self.topView];
    [self.originalContentView sendSubviewToBack:self.topView];
}



- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
    
    
}

-(void)viewWillLayoutSubviews {
    
    [self.scrollView setZoomScale:self.scrollView.minimumZoomScale animated:NO];
    [self centerScrollViewContents];
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
    
    NSString *questionNumber = [self.cardInView.categoryNumber stringValue];
    self.logoImageLabel.text = [NSString stringWithFormat:@"%@ #%@",self.cardInView.category,questionNumber];
    
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

    [self.logoImageView addSubview:self.logoImageLabel];
    [self.originalContentView sendSubviewToBack:self.logoImageView];
    
}

- (void)setupBottomMenuButtons {
    
    UIFont * font;
    if (IS_IPAD) {
        font = [UIFont fontWithName:@"HelveticaNeue" size:32];
    }
    else if (IS_IPHONE_6 || IS_IPHONE_6Plus) {
        font = [UIFont fontWithName:@"HelveticaNeue" size:22];
    }
    else {
        font = [UIFont fontWithName:@"HelveticaNeue" size:19];
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
    
    attrString = [[NSMutableAttributedString alloc] initWithString:@"Flip Question" attributes:@{NSFontAttributeName:font,NSForegroundColorAttributeName:color}];
    [button1 setAttributedTitle:attrString forState:UIControlStateNormal];
    
    UITapGestureRecognizer *flipCardGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(flipCardTapDetected:)];
    flipCardGesture.numberOfTapsRequired = 1;
    button1.userInteractionEnabled = YES;
    [button1 addGestureRecognizer:flipCardGesture];
    
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
    }
    else {
        self.backButton.hidden = NO;
        self.scrollViewTopHeightConstraint.constant = self.scrollViewTopHeightConstraintDefault;
        self.scrollViewBottomHeightConstraint.constant = self.scrollViewBottomHeightConstraintDefault;
        [self animateBottomMenuHidden:NO];
        self.logoImageView.hidden = NO;
        self.topView.hidden = NO;
    }
    
}


- (void)didRotateFromInterfaceOrientation:(UIInterfaceOrientation)fromInterfaceOrientation {
    [self setZoomMinimumForView:self.scrollView withCardOrientation:self.cardInView.orientation];
    [self.scrollView setZoomScale:self.scrollView.minimumZoomScale animated:YES];
    //[self centerScrollViewContents];
}

- (void)initializeCardGlobalVariables {
    self.isShowingImageSide = YES;
    self.isShowingAnswerLabel = NO;
    self.isShowingQuestionLabel = NO;
    self.flippingCardInProgress = NO;
    self.hidingcardInProgress = NO;
    self.flippingToHidecardInProgress = NO;
}

- (void)setupScrollView {
    
    self.cardFrontImageView = [self makecardImageViewWithCard:self.cardInView forSide:@"front"];
    self.cardBackImageView = [self makecardImageViewWithCard:self.cardInView forSide:@"back"];
    
    self.scrollView.delegate = self;
    self.scrollView.contentSize = self.cardFrontImageView.image.size;
    
    self.scrollView.maximumZoomScale = 1.0;
    
    CGFloat minScale = [self setZoomMinimumForView:self.scrollView withCardOrientation:self.cardInView.orientation];
 
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
    
    UISwipeGestureRecognizer *upSwipeRecognizer = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(upSwipeDetected:)];
    upSwipeRecognizer.direction = UISwipeGestureRecognizerDirectionUp;
    upSwipeRecognizer.numberOfTouchesRequired = 1;
    [self.scrollView addGestureRecognizer:upSwipeRecognizer];
    
    UISwipeGestureRecognizer *downSwipeRecognizer = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(downSwipeDetected:)];
    downSwipeRecognizer.direction = UISwipeGestureRecognizerDirectionDown;
    downSwipeRecognizer.numberOfTouchesRequired = 1;
    [self.scrollView addGestureRecognizer:downSwipeRecognizer];
    
    UISwipeGestureRecognizer *leftSwipeRecognizer = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(advanceToNextCard)];
    leftSwipeRecognizer.direction = UISwipeGestureRecognizerDirectionLeft;
    leftSwipeRecognizer.numberOfTouchesRequired = 1;
    [self.scrollView addGestureRecognizer:leftSwipeRecognizer];
    
    UISwipeGestureRecognizer *rightSwipeRecognizer = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(advanceToPreviousCard)];
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
    } else if (IS_IPHONE_5 && [cardOrientation isEqualToString:@"portrait"]) {
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
    
    [self animateFlipCardViewsInDirection:@"down"];
}

- (void)downSwipeDetected:(UISwipeGestureRecognizer*)sender {
    NSLog(@"Down Swipe Detected");
    
    [self animateFlipCardViewsInDirection:@"up"];
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
    
    if ([ARTCard isCardPlayed:card.uniqueID]) {
        NSLog(@"Tap Detected");
        
        self.cardIndex = tempCardIndex;
        self.deckIndex = tempDeckIndex;
        
        if (self.isShowingImageSide)
            [self animateCardView:self.cardFrontImageView OffScreenToRight:YES];
        else {
            [self animateCardView:self.cardBackImageView OffScreenToRight:YES];
        }
        
        ARTCard *nextCard = self.sortedCardsFromSortedDecks[self.deckIndex][self.cardIndex];
        
        self.cardInView = nextCard;
        
        [self initializeCardGlobalVariables];
        [self setupScrollView];
        self.cardFrontImageView.hidden = YES;
        
        [self animateCardView:self.cardFrontImageView OnScreenFromRight:NO];
        
        NSString *questionNumber = [self.cardInView.categoryNumber stringValue];
        self.logoImageLabel.text = [NSString stringWithFormat:@"%@ #%@",self.cardInView.category,questionNumber];
        
    } else {
        
        [self advanceToPreviousCard];
    }
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
    
    ARTCard *card = self.sortedCardsFromSortedDecks[tempDeckIndex][tempCardIndex];
    if ([ARTCard isCardPlayed:card.uniqueID]) {
        NSLog(@"Tap Detected");
        
        if (self.isShowingImageSide)
            [self animateCardView:self.cardFrontImageView OffScreenToRight:NO];
        else {
            [self animateCardView:self.cardBackImageView OffScreenToRight:NO];
        }
        
        ARTCard *nextCard = self.sortedCardsFromSortedDecks[self.deckIndex][self.cardIndex];
        
        self.cardInView = nextCard;
        
        [self initializeCardGlobalVariables];
        [self setupScrollView];
        self.cardFrontImageView.hidden = YES;
        
        [self animateCardView:self.cardFrontImageView OnScreenFromRight:YES];
        
        NSString *questionNumber = [self.cardInView.categoryNumber stringValue];
        self.logoImageLabel.text = [NSString stringWithFormat:@"%@ #%@",self.cardInView.category,questionNumber];
        
    } else {
        
        [self advanceToNextCard];
    }
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




- (id<UIViewControllerAnimatedTransitioning>)navigationController:(UINavigationController *)navigationController animationControllerForOperation:(UINavigationControllerOperation)operation fromViewController:(UIViewController *)fromVC toViewController:(UIViewController *)toVC {
    
    ARTNoTransitionAnimator *animator = [ARTNoTransitionAnimator new];
    return animator;
}



- (void)backToGalleryTapDetected:(id)sender {
    NSLog(@"Single tap detected");
    
    [self animateHidecard];

}
@end
