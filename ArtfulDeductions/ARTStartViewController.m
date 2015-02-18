//
//  ARTStartViewController.m
//  Artful Deductions
//
//  Created by Kyle Rokita on 8/1/14.
//  Copyright (c) 2014 Artful Deductions LLC. All rights reserved.
//

#import "ARTStartViewController.h"
#import "ARTMenuObject.h"
#import "ARTNoTransitionAnimator.h"
#import "ARTNavigationController.h"
#import "ARTGameSaves.h"
#import "ARTGame.h"
#import "ARTImageHelper.h"
#import "ARTDeck.h"
#import "ARTCard.h"
#import "ARTUserInfo.h"
#import "ARTButton.h"
#import "UIImage+Customization.h"
#import "UIColor+Extensions.h"
#import "ARTConstants.h"
#import "ARTCategoryViewController.h"
#import "ARTNewGameViewController.h"
#import "ARTSlideTransitionAnimator.h"
#import "ARTCardHelper.h"
#import "ARTPlayer.h"
#import "ARTAvatar.h"
#import "ARTAvatarHelper.h"
#import "MTReachabilityManager.h"
#import "NSDictionary+DeepCopy.h"
#import "ARTCardHelper.h"

#import "ARTDailyViewController.h"
#import "ARTNoTransitionAnimator.h"

CGFloat const cardAnimationDelay = 4.0;

NSString *defaultLocation = @"the Milky Way Galaxy";

@interface ARTStartViewController () {
    NSMutableArray *_randomCards;
    
    
    NSInteger _randomCardIndex;
    BOOL _isOKToAnimateCardsOnScreen;
    NSInteger _animateCardCounter;
    BOOL _showFullIntro;
    BOOL _showShortIntro;
    BOOL _isFirstTimeLoading;
    BOOL _isOKToAnimateCardWiggle;
    BOOL _isOKToRefreshDailyCards;
    
    CGFloat _Scale;
    CGFloat _ratio;
    NSString *_location;
    
}




@end

@implementation ARTStartViewController


- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.automaticallyAdjustsScrollViewInsets = NO;
    
    // Do any additional setup after loading the view.
    _isFirstTimeLoading = YES;
    _showShortIntro = YES;
    _isOKToRefreshDailyCards = YES;
    self.isDailyCardJustPlayed = NO;
    
    if (IS_IPAD) {
        _ratio = 2.5;
    } else {
        _ratio = 1.7;
        
    }
    _location = defaultLocation;
    
    //still used for card fly in beginning
    [self randomizeCards];
    
    
}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    [super prepareForSegue:segue sender:sender];
    
    UIViewController *destViewController = segue.destinationViewController;
    
    if ([segue.identifier isEqualToString:@"GameSegue"]) {
        ((ARTCategoryViewController *)destViewController).gameSaves = self.gameSaves;
        
        NSDictionary *singleGameSave = [self getSaveforGameMode:@"single"];
        
        ARTGame *newGame = [[ARTGame alloc] initWithGameSave:singleGameSave];
        ((ARTCategoryViewController *)destViewController).currentGame = newGame;
    }
    else if ([segue.identifier isEqualToString:@"NewGameSegue"]) {
        //loading a new player so set BOOL
        ((ARTNewGameViewController *)destViewController).newPlayer = YES;
        
    } else if ([segue.identifier isEqual:@"DailyCardSegue"]) {
        ARTDailyViewController *dailyCardViewController = (ARTDailyViewController *)segue.destinationViewController;
        
        dailyCardViewController.gameSaves = self.gameSaves;
        
        NSDictionary *dailyGameSave = [self getSaveforGameMode:@"daily"];
        
        ARTGame *newGame = [[ARTGame alloc] initWithGameSave:dailyGameSave];
        ((ARTCategoryViewController *)destViewController).currentGame = newGame;
        
        dailyCardViewController.sortedCardsFromSortedDecks= _sortedCardsFromDailyDecks;
        dailyCardViewController.sortedDecks = _dailyDecks;
        dailyCardViewController.selectedCard = _sortedCardsFromDailyDecks[self.deckIndex][self.cardIndex];
        dailyCardViewController.selectedDeck = _dailyDecks[self.deckIndex];
        dailyCardViewController.deckIndex = self.deckIndex;
        dailyCardViewController.cardIndex = self.cardIndex;
        dailyCardViewController.delegate = self;
    }
}

/*- (void)advanceToNextDailyCard {
    
    NSInteger tempCardIndex = self.cardIndex;
    NSInteger tempDeckIndex = self.deckIndex;
    
    NSMutableArray *cardArray  = _sortedCardsFromDailyDecks[self.deckIndex];
    if (tempCardIndex + 1 == cardArray.count) {
        tempCardIndex = 0;
        
        if (tempDeckIndex + 1 == _sortedCardsFromDailyDecks.count) {
            tempDeckIndex = 0;
        } else {
            tempDeckIndex += 1;
        }
    } else {
        tempCardIndex += 1;
    }
    
    self.cardIndex = tempCardIndex;
    self.deckIndex = tempDeckIndex;
    
    
    [self animateDailyCardFromRight];
    
}

- (void)advanceToPreviousDailyCard {
    
    NSInteger tempCardIndex = self.cardIndex;
    NSInteger tempDeckIndex = self.deckIndex;
    
    if (tempCardIndex - 1 < 0) {
        
        if (tempDeckIndex - 1 < 0) {
            tempDeckIndex = _sortedCardsFromDailyDecks.count - 1;
            tempCardIndex = ((NSMutableArray *)_sortedCardsFromDailyDecks[tempDeckIndex]).count - 1;
        } else {
            tempDeckIndex -= 1;
            tempCardIndex = ((NSMutableArray *)_sortedCardsFromDailyDecks[tempDeckIndex]).count - 1;
        }
    } else {
        tempCardIndex -= 1;
    }
    
    self.cardIndex = tempCardIndex;
    self.deckIndex = tempDeckIndex;
    
    ARTCard *card = _sortedCardsFromDailyDecks[tempDeckIndex][tempCardIndex];
    
    
    
    self.cardIndex = tempCardIndex;
    self.deckIndex = tempDeckIndex;
    
    [self animateDailyCardFromRight];
    
 }*/

- (void)advanceToNextCard {
    
    
    [self animateCardFromRight];

}

- (void)advanceToPreviousCard {

    [self animateCardFromLeft];
    
}

- (NSDictionary *)getSaveforGameMode:(NSString *)gameMode {
    
    for (NSInteger i = 0; i < self.gameSaves.count; i++) {
        NSDictionary *gameSave = self.gameSaves[i];
        
        if ([gameSave[@"gameMode"] isEqualToString:gameMode]) {
            return gameSave;
        }
    }
    
    return nil;
    
}

- (void) viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    /*
    //activate for daily decks
    if (_isOKToRefreshDailyCards) {
        
        if ([[MTReachabilityManager sharedManager] isReachable]) {
            NSLog(@"reachable");
            [self downloadDailyDecks];
        } else {
            NSLog(@"unreachable");
            
            //setup daily decks
            [self setupDailyDecks];
            [self downloadDailyDeckImages];
            
        }
        
        _isOKToRefreshDailyCards = NO;
    } */
    
    self.isOKToAnimateLabel = YES;
    
    if (IS_OldIphone) {
        self.menuPlaceholderHeightConstraint.constant = 160.0;
        self.menuPlaceholderBottomConstraint.constant = 10.0;
        self.logoImageViewTopMarginConstraint.constant = 25.0;
        self.imageViewPlaceholderTopConstraint.constant = 5.0;
        self.imageViewPlaceholderBottomConstraint.constant = 5.0;
    } else if (IS_IPHONE_5){
        self.menuPlaceholderHeightConstraint.constant = 160.0;
        self.menuPlaceholderBottomConstraint.constant = 10.0;
        self.logoImageViewTopMarginConstraint.constant = 30.0;
        self.imageViewPlaceholderTopConstraint.constant = 10.0;
        self.imageViewPlaceholderBottomConstraint.constant = 10.0;
    } else if (IS_IPHONE_6){
        self.menuPlaceholderHeightConstraint.constant = 180.0;
        self.menuPlaceholderBottomConstraint.constant = 10.0;
        self.logoImageViewTopMarginConstraint.constant = 30.0;
        self.imageViewPlaceholderTopConstraint.constant = 10.0;
        self.imageViewPlaceholderBottomConstraint.constant = 10.0;
    } else if (IS_IPHONE_6Plus){
        self.menuPlaceholderHeightConstraint.constant = 200.0;
        self.menuPlaceholderBottomConstraint.constant = 30.0;
        self.logoImageViewTopMarginConstraint.constant = 30.0;
        self.imageViewPlaceholderTopConstraint.constant = 10.0;
        self.imageViewPlaceholderBottomConstraint.constant = 10.0;
    } else if (IS_IPAD) {
        self.menuPlaceholderHeightConstraint.constant = 260.0;
        self.menuPlaceholderBottomConstraint.constant = 20.0;
        self.logoImageViewTopMarginConstraint.constant = 20.0;
        self.imageViewPlaceholderTopConstraint.constant = 15.0;
        self.imageViewPlaceholderBottomConstraint.constant = 15.0;
    }
    
    
    [(ARTNavigationController*)[self navigationController] setLandscapeOK:NO];
    [self.navigationController setNavigationBarHidden:YES animated:NO];
    
    self.navigationController.delegate = self;
    
    [self setupGameSaves];
    
    if ([[[ARTUserInfo sharedInstance] getVisualTheme] isEqual:@"white"]) {
        self.view.backgroundColor = [UIColor lightBackgroundColor];
    } else {
        self.view.backgroundColor = [UIColor darkBackgroundColor];
    }
    
    [self.view layoutIfNeeded];
    
    [self setupLogoImageView];
    [self setupTaglineLabel];
    
    if ([[[ARTUserInfo sharedInstance] getShowIntro] isEqual:@"YES"]) {
        _showFullIntro = YES;
        _isFirstTimeLoading = YES;
        _showShortIntro = NO;
        
    } else {
        _showFullIntro = NO;
    }
    
    
    if (_showFullIntro) {
        
        //for intro set color to match the background color
        if ([[[ARTUserInfo sharedInstance] getVisualTheme] isEqual:@"white"]) {
            [self preferredStatusBarStyleIsBlack:NO];
        } else {
            [self preferredStatusBarStyleIsBlack:YES]; //darkmode
        }
        
        self.tagLineLabel.alpha = 0.0;
        self.menuPlaceholder.alpha = 0.0;
        self.imageViewPlaceholder.alpha = 0.0;
        
        [self setupIntroVideoForFull:YES];
        
        
    } else if (_showShortIntro){
        
        //for intro set color to match the background color
        if ([[[ARTUserInfo sharedInstance] getVisualTheme] isEqual:@"white"]) {
            [self preferredStatusBarStyleIsBlack:NO];
        } else {
            [self preferredStatusBarStyleIsBlack:YES]; //darkmode
        }
        
        self.tagLineLabel.alpha = 0.0;
        self.menuPlaceholder.alpha = 0.0;
        self.imageViewPlaceholder.alpha = 0.0;
        
        [self setupIntroVideoForFull:NO];
        
        
    }
    else{
        
        [self setupMenuPlaceholder];
        
        [self setupImageViewPlaceholder];
        [self.imageView layoutIfNeeded];
        
        //load random cards that will display on start screen
        self.imageView = [self makeImageViewForCard:_randomCards[_randomCardIndex]];
        for (UIView *subview in self.imageViewPlaceholder.subviews) {
             [subview removeFromSuperview];
        }
        [self.imageViewPlaceholder addSubview:self.imageView];
        
        
        //activate for daily decks to show on srtart screen
        //self.imageView = [self makeImageViewForCard:_sortedCardsFromDailyDecks[self.deckIndex][self.cardIndex]];
        //for (UIView *subview in self.imageViewPlaceholder.subviews) {
        //    [subview removeFromSuperview];
        //}
        //[self.imageViewPlaceholder addSubview:self.imageView];
        
        for (UIView *subview in self.menuPlaceholder.subviews) {
            [subview removeFromSuperview];
        }
        self.menu = [self makeStartMenu];
        [self.menuPlaceholder addSubview:self.menu];
        
        if (_isFirstTimeLoading) {
            
            [UIView animateWithDuration:0.8
                                  delay:0.0
                                options:UIViewAnimationOptionAllowAnimatedContent | UIViewAnimationCurveLinear
                             animations:^{
                                 self.tagLineLabel.alpha = 1.0;
                                 self.menuPlaceholder.alpha = 1.0;
                                 self.imageViewPlaceholder.alpha = 1.0;
                             } completion:^(BOOL finished) {
                                 
                             }];
            
            _isFirstTimeLoading = NO;
        }
        
        if ([[[ARTUserInfo sharedInstance] getVisualTheme] isEqual:@"white"]) {
            [self preferredStatusBarStyleIsBlack:YES];
        } else {
            [self preferredStatusBarStyleIsBlack:NO]; //darkmode
        }
        
        //  _isOKToAnimateCardsOnScreen = YES;
        // [self resetAnimateCardTimer];
        
        [self.view bringSubviewToFront:self.imageViewPlaceholder];
        
        if (self.isDailyCardJustPlayed) {
            [self animateTappedCardToPile];
            self.isDailyCardJustPlayed = NO;
        }
    }
    
}


- (void)downloadDailyDecks {
    
    __weak typeof(self) weakSelf = self;
    
    
    NSString *urlAsString = [cardInfoAddress stringByAppendingString:@"ARTCardsDaily.json"];
    NSURL *url = [[NSURL alloc] initWithString:urlAsString];
    NSLog(@"%@", urlAsString);
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0),^{
        
        NSData *myData = [NSData dataWithContentsOfURL:url];
        [weakSelf processTheData:myData];
        [weakSelf setupDailyDecks];
        [weakSelf downloadDailyDeckImages];
        
        dispatch_async(dispatch_get_main_queue(), ^{
            
            
        });
        
    });
    
    
}

- (void)downloadDailyDeckImages {
    
    for (NSInteger i = 0; i < _sortedCardsFromDailyDecks.count; i++) {
        
        NSMutableArray *cardArray = _sortedCardsFromDailyDecks[i];
        
        for (NSInteger j = 0; j < cardArray.count; j++) {
            
            ARTCard *card = cardArray[j];
            
            NSString *fileName = card.frontFilename;
            
            fileName = [fileName stringByAppendingString:@"dpi"];
            fileName = [fileName stringByAppendingString:HQpixelsforPic];
            
            NSString * filePath;
            
            filePath = [[NSBundle mainBundle]
                        pathForResource:fileName
                        ofType:@"jpg"];
            
            if(!filePath) {
                NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,  NSUserDomainMask, YES);
                NSString *documentsDirectory = [paths objectAtIndex:0];
                
                fileName = [fileName stringByAppendingString:@".jpg"];
                filePath = [documentsDirectory stringByAppendingPathComponent:fileName];
                
            }
            
            if(![UIImage imageWithContentsOfFile:filePath]) {
                __weak typeof(self) weakSelf = self;
                
                
                NSString *urlAsString = [dailyImageAddress stringByAppendingString:fileName];
                NSURL *url = [[NSURL alloc] initWithString:urlAsString];
                NSLog(@"%@", urlAsString);
                
                dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0),^{
                    
                    NSData *myData = [NSData dataWithContentsOfURL:url];
                    [weakSelf processTheImageData:myData withFileName:fileName];
                    
                    dispatch_async(dispatch_get_main_queue(), ^{
                        
                        // [self setupDailyDecks];
                    });
                    
                });
                
            }
            
            
            
            fileName = card.backFilename;
            
            fileName = [fileName stringByAppendingString:@"dpi"];
            fileName = [fileName stringByAppendingString:HQpixelsforPic];
            
            filePath = [[NSBundle mainBundle]
                        pathForResource:fileName
                        ofType:@"jpg"];
            
            if(!filePath) {
                NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,  NSUserDomainMask, YES);
                NSString *documentsDirectory = [paths objectAtIndex:0];
                
                fileName = [fileName stringByAppendingString:@".jpg"];
                filePath = [documentsDirectory stringByAppendingPathComponent:fileName];
            }
            
            if(![UIImage imageWithContentsOfFile:filePath]) {
                __weak typeof(self) weakSelf = self;
                
                
                NSString *urlAsString = [dailyImageAddress stringByAppendingString:fileName];
                NSURL *url = [[NSURL alloc] initWithString:urlAsString];
                NSLog(@"%@", urlAsString);
                
                dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0),^{
                    
                    NSData *myData = [NSData dataWithContentsOfURL:url];
                    [weakSelf processTheImageData:myData withFileName:fileName];
                    
                    
                    dispatch_async(dispatch_get_main_queue(), ^{
                        
                        // [self setupDailyDecks];
                    });
                    
                });
            }
            
        }
        
    }
    
}

- (void)processTheData:(NSData *)myData {
    
    NSError* error = nil;
    NSMutableDictionary *userInfo;
    if (myData) {
        userInfo = [[NSJSONSerialization JSONObjectWithData:myData
                                                    options:kNilOptions
                                                      error:&error] mutableDeepCopy];
        
    }
    
    [[ARTCardHelper sharedInstance] updateDailyDecks:userInfo];
    
}

- (void)processTheImageData:(NSData *)myData withFileName:(NSString*)filename {
    
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,  NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    NSString *filePath = [documentsDirectory stringByAppendingPathComponent:filename];
    
    [myData writeToFile:filePath atomically:YES];
}

- (void)setupGameSaves {
    
    self.gameSaves = nil;
    NSMutableDictionary *dict = [[ARTGameSaves sharedInstance] getGameSavesIncludingCompleted:YES];
    NSMutableArray *array = [[NSMutableArray alloc] init];
    for (id gameSave in dict) {
        [array addObject:dict[gameSave]];
    }
    NSSortDescriptor *dateDescriptor = [[NSSortDescriptor alloc] initWithKey:@"dateLastPlayed" ascending:NO];
    NSMutableArray *sortDescriptors = [NSMutableArray arrayWithObject:dateDescriptor];
    self.gameSaves = [[array sortedArrayUsingDescriptors:sortDescriptors] mutableCopy];
    
}

- (void)preferredStatusBarStyleIsBlack:(BOOL)preferBlackIndicator {
    
    if (preferBlackIndicator) {
        [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleDefault];
    } else {
        [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
    }
}

- (void) setupIntroVideoForFull:(BOOL)fullIndicator {
    
    [self setupTransformedView];
    
    
    [[ARTUserInfo sharedInstance] saveShowIntro:@"NO"];
    _showFullIntro = NO;
    _showShortIntro = NO;
    
    [self animateTransformedViewInFull:fullIndicator];
}


- (void)animateCardOnScreen {
    
    if (_isOKToAnimateCardsOnScreen) {
        
        [self animateCardFromRight];
        [self resetAnimateCardTimer];
    }
}

- (void)resetAnimateCardTimer {
    [self cancelAnimateCardTimer];
    
    self.animationTimer = [NSTimer scheduledTimerWithTimeInterval:cardAnimationDelay
                                                           target:self
                                                         selector:@selector(animateCardOnScreen)
                                                         userInfo:nil
                                                          repeats:NO];
    
    [[NSRunLoop currentRunLoop] addTimer:self.animationTimer
                                 forMode:NSRunLoopCommonModes];
}

- (void)cancelAnimateCardTimer {
    if (self.animationTimer) {
        [self.animationTimer invalidate];
        self.animationTimer = nil;
    }
    
}

- (void)animateCardToSpiral:(BOOL)growIndicator ForProgress:(CGFloat)progress {
    self.imageViewPlaceholder.userInteractionEnabled = NO;
    CGFloat thisProgress = 0.5;
    
    NSInteger directionSwitch = (growIndicator ? -1 : 1);
    
    CGAffineTransform nextTransform = self.imageView.transform;
    
    if (!growIndicator) {
        nextTransform = CGAffineTransformRotate(nextTransform, M_PI * 1.99 * thisProgress * directionSwitch);
        nextTransform = CGAffineTransformScale(nextTransform,  (progress - thisProgress * directionSwitch)/progress,  (progress - thisProgress * directionSwitch)/progress);
    }
    else {
        nextTransform = CGAffineTransformRotate(nextTransform, M_PI * 1.99 * thisProgress * directionSwitch);
        nextTransform = CGAffineTransformScale(nextTransform,  (progress - thisProgress * directionSwitch)/progress,  (progress - thisProgress * directionSwitch)/progress);
    }
    
    [UIView animateWithDuration:0.225
                          delay:0.0
                        options:UIViewAnimationOptionAllowAnimatedContent |  UIViewAnimationOptionCurveLinear
                     animations:^{
                         //self.imageView.center = CGPointMake(self.imageViewPlaceholder.bounds.size.width/2.0 + directionSwitch * _distanceFromCenter, self.imageView.center.y);
                         self.imageView.transform = nextTransform;
                     } completion:^(BOOL finished) {
                         if (!growIndicator) {
                             if ((progress - thisProgress) < 0.1) {
                                 [self increaseRandomCardIndex];
                                 UIImageView *nextImageView = [self makeImageViewForCard:_randomCards[_randomCardIndex]];
                                 nextImageView.hidden = YES;
                                 nextImageView.transform = self.imageView.transform;
                                 
                                 [UIView transitionFromView:self.imageView
                                                     toView:nextImageView
                                                   duration:0.0
                                                    options:UIViewAnimationOptionTransitionNone|UIViewAnimationOptionAllowAnimatedContent
                                                 completion:^(BOOL finished) {
                                                     if (finished) {
                                                         self.imageView = nextImageView;
                                                         self.imageView.hidden = NO;
                                                         [self animateCardToSpiral:!growIndicator ForProgress:0.01];
                                                     }
                                                 }];
                             } else {
                                 [self animateCardToSpiral:growIndicator ForProgress:progress - thisProgress];
                             }
                             
                         } else {
                             if ((progress + thisProgress) > 0.9) {
                                 self.imageView.transform = CGAffineTransformIdentity;
                                 self.imageViewPlaceholder.userInteractionEnabled = YES;
                             } else {
                                 [self animateCardToSpiral:growIndicator ForProgress:progress + thisProgress];
                             }
                             
                         }
                         
                         
                     }];
}

- (void)animateCardToSpinToImageView:(UIImageView *)nextImageView ForProgress:(CGFloat)progress {
    self.imageViewPlaceholder.userInteractionEnabled = NO;
    
    
    
    CGFloat thisProgress = 0.5;
    
    NSInteger directionSwitch = 1;
    
    CGAffineTransform nextTransform = self.imageView.transform;
    nextTransform = CGAffineTransformRotate(nextTransform, M_PI * 1.99 * thisProgress * directionSwitch);
    
    [UIView animateWithDuration:0.3
                          delay:0.0
                        options:UIViewAnimationOptionAllowAnimatedContent |  UIViewAnimationOptionCurveLinear
                     animations:^{
                         self.imageView.transform = nextTransform;
                         self.imageView.alpha = 1.0 - progress - thisProgress;
                         
                         nextImageView.transform = nextTransform;
                         nextImageView.alpha = progress + thisProgress;
                     } completion:^(BOOL finished) {
                         if ((progress + thisProgress) > 0.9) {
                             nextImageView.transform = CGAffineTransformIdentity;
                             [self.imageView removeFromSuperview];
                             self.imageView = nextImageView;
                             
                             self.imageViewPlaceholder.userInteractionEnabled = YES;
                             
                         } else {
                             [self animateCardToSpinToImageView:nextImageView ForProgress:progress + thisProgress];
                         }
                         
                         
                         
                     }];
}

- (void)animateCardToBlowUp {
    
    [self increaseRandomCardIndex];
    UIImageView *nextImageView = [self makeImageViewForCard:_randomCards[_randomCardIndex]];
    nextImageView.alpha = 0.0;
    [self.imageViewPlaceholder addSubview:nextImageView];
    [self.imageViewPlaceholder bringSubviewToFront:self.imageView];
    
    self.imageViewPlaceholder.userInteractionEnabled = NO;
    
    CGAffineTransform nextTransform = self.imageView.transform;
    
    nextTransform = CGAffineTransformScale(nextTransform, 6.0, 6.0);
    
    
    [UIView animateWithDuration:0.4
                          delay:0.0
                        options:UIViewAnimationOptionAllowAnimatedContent |  UIViewAnimationOptionCurveLinear
                     animations:^{
                         self.imageView.transform = nextTransform;
                         //self.imageView.center = self.view.center;
                         self.imageView.alpha = 0.0;
                         nextImageView.alpha = 1.0;
                     }
                     completion:^(BOOL finished) {
                         [self.imageView removeFromSuperview];
                         self.imageView = nextImageView;
                         self.imageViewPlaceholder.userInteractionEnabled = YES;
                     }];
}


-  (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
    
    self.isOKToAnimateLabel = NO;
    
    _isOKToAnimateCardWiggle = NO;
    
    _isOKToAnimateCardsOnScreen = NO;
    [self cancelAnimateCardTimer];
    
    [self.imageView removeFromSuperview];
    for (UIView *subview in self.imageViewPlaceholder.subviews) {
        [subview removeFromSuperview];
    }
    self.imageView = nil;
    
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark Start View Creation Methods

- (void)setupLogoImageView {
    
    if ([[[ARTUserInfo sharedInstance] getVisualTheme] isEqual:@"white"]) {
        self.logoImageView.image = [UIImage imageNamed:@"LogoDarkBlue"]; //darkmode
    } else {
        self.logoImageView.image = [UIImage imageNamed:@"LogoLightBlue"];
    }
    
    self.logoImageView.contentMode = UIViewContentModeScaleAspectFit;
    self.logoImageView.opaque = YES;
    
    self.logoImageView.backgroundColor = self.view.backgroundColor;
}

- (void)setupTaglineLabel {
    
    UIColor *color;
    if ([[[ARTUserInfo sharedInstance] getVisualTheme] isEqual:@"white"]) {
        color = [UIColor blackColor]; //darkmode
    } else {
        color = [UIColor whiteColor]; //darkmode
    }
    
    self.tagLineLabel.opaque = YES;
    self.tagLineLabel.backgroundColor = self.view.backgroundColor;
    
    self.tagLineLabel.textAlignment = NSTextAlignmentCenter;
    
    CGFloat fontSize;
    if (IS_IPAD) {
        fontSize = 40.0;
    } else if (IS_IPHONE_6 || IS_IPHONE_6Plus) {
        fontSize = 26.0;
    } else {
        fontSize = 22.0;
    }
    
    UIFont *font = [UIFont fontWithName:@"HelveticaNeue-LightItalic" size:fontSize];
    UIFont *fontTM = [UIFont fontWithName:@"HelveticaNeue-LightItalic" size:fontSize];
    
    NSString *string1 = tagLine;
    NSString *stringTM = @"";  //\u2122";
    
    NSMutableAttributedString *attrString = [[NSMutableAttributedString alloc] initWithString:string1 attributes:@{NSFontAttributeName:font,NSForegroundColorAttributeName:color}];
    
    NSMutableAttributedString *attrStringTM = [[NSMutableAttributedString alloc] initWithString:stringTM attributes:@{NSFontAttributeName:fontTM,NSForegroundColorAttributeName:color}];
    
    [attrString appendAttributedString:attrStringTM];
    
    self.tagLineLabel.attributedText = attrString;
}

- (void)setupImageViewPlaceholder {
    
    self.imageViewPlaceholder.backgroundColor = [UIColor clearColor];
    
      NSArray *gestureRecognizers = [self.imageViewPlaceholder gestureRecognizers];
     for (UIGestureRecognizer *recognizer in gestureRecognizers) {
     [self.imageViewPlaceholder removeGestureRecognizer:recognizer];
     }
     
     UILongPressGestureRecognizer *longPressTapRecognizer = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(longTapDetected:)];
     longPressTapRecognizer.numberOfTapsRequired = 0;
     longPressTapRecognizer.numberOfTouchesRequired = 1;
     longPressTapRecognizer.minimumPressDuration = 0.5;
     self.imageViewPlaceholder.userInteractionEnabled = YES;
     [self.imageViewPlaceholder addGestureRecognizer:longPressTapRecognizer];
    
     UISwipeGestureRecognizer *nextSwipeTapRecognizer = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(nextTapDetected:)];
     nextSwipeTapRecognizer.direction = UISwipeGestureRecognizerDirectionLeft;
     nextSwipeTapRecognizer.numberOfTouchesRequired = 1;
     self.imageViewPlaceholder.userInteractionEnabled = YES;
     [self.imageViewPlaceholder addGestureRecognizer:nextSwipeTapRecognizer];
     
     UISwipeGestureRecognizer *previousSwipeTapRecognizer = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(previousTapDetected:)];
     previousSwipeTapRecognizer.direction = UISwipeGestureRecognizerDirectionRight;
     previousSwipeTapRecognizer.numberOfTouchesRequired = 1;
     self.imageViewPlaceholder.userInteractionEnabled = YES;
     [self.imageViewPlaceholder addGestureRecognizer:previousSwipeTapRecognizer];
     
     UISwipeGestureRecognizer *upSwipeTapRecognizer = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(upTapDetected:)];
     upSwipeTapRecognizer.direction = UISwipeGestureRecognizerDirectionUp;
     upSwipeTapRecognizer.numberOfTouchesRequired = 1;
     self.imageViewPlaceholder.userInteractionEnabled = YES;
     [self.imageViewPlaceholder addGestureRecognizer:upSwipeTapRecognizer];
     
     UISwipeGestureRecognizer *downSwipeTapRecognizer = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(downTapDetected:)];
     downSwipeTapRecognizer.direction = UISwipeGestureRecognizerDirectionDown;
     downSwipeTapRecognizer.numberOfTouchesRequired = 1;
     self.imageViewPlaceholder.userInteractionEnabled = YES;
     [self.imageViewPlaceholder addGestureRecognizer:downSwipeTapRecognizer];
    
    /*
    // activate this for daily deductions to start with tap
    UITapGestureRecognizer *singleTapRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(dailyTapDetected:)];
    singleTapRecognizer.numberOfTapsRequired = 1;
    singleTapRecognizer.numberOfTouchesRequired = 1;
    self.imageViewPlaceholder.userInteractionEnabled = YES;
    [self.imageViewPlaceholder addGestureRecognizer:singleTapRecognizer]; */
}

-(void) setupMenuPlaceholder {
    self.menuPlaceholder.backgroundColor = [UIColor clearColor];
    
}

- (ARTMenuObject *)makeStartMenu {
    
    ARTMenuObject *menu = [[ARTMenuObject alloc] initWithButtonCount:3
                                                           withFrame:self.menuPlaceholder.bounds
                                               withPortraitIndicator:YES];
    

    UIFont * font;
    if (IS_OldIphone) {
        font = [UIFont fontWithName:@"HelveticaNeue" size:26];
    } else if (IS_IPHONE_5){
        font = [UIFont fontWithName:@"HelveticaNeue" size:26];
    } else if (IS_IPHONE_6){
        font = [UIFont fontWithName:@"HelveticaNeue" size:30];
    } else if (IS_IPHONE_6Plus){
        font = [UIFont fontWithName:@"HelveticaNeue" size:32];
    } else if (IS_IPAD){
        font = [UIFont fontWithName:@"HelveticaNeue" size:50];
    } else {
        font = [UIFont fontWithName:@"HelveticaNeue" size:26];
    }
    
    UIFont * largeFont = [UIFont fontWithName:font.fontName size:font.pointSize + 6.0];
    
    UIColor *color;
    
    if ([[[ARTUserInfo sharedInstance] getVisualTheme] isEqual:@"white"]) {
        color = [UIColor whiteColor];
    } else {
        color = [UIColor whiteColor];
        
    }
    
    NSInteger buttonIndex = 0;
    
    /*
    //Daily Deductions button
    UIButton *dailyDeductionsButton = menu.arrayOfButtons[buttonIndex++];
    
    NSMutableAttributedString *attrString = [[NSMutableAttributedString alloc] initWithString:@"Daily Deductions" attributes:@{NSFontAttributeName:largeFont,NSForegroundColorAttributeName:color}];
    [dailyDeductionsButton setAttributedTitle:attrString forState:UIControlStateNormal];
    
    UITapGestureRecognizer *singlePlayerTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(dailyTapDetected:)];
    singlePlayerTap.numberOfTapsRequired = 1;
    dailyDeductionsButton.userInteractionEnabled = YES;
    [dailyDeductionsButton addGestureRecognizer:singlePlayerTap];
    */
    
    //Standard Cards Button
    UIButton *standardCardsButton = menu.arrayOfButtons[buttonIndex++];
    
    NSMutableAttributedString *attrString2 = [[NSMutableAttributedString alloc] initWithString:@"Play Game!" attributes:@{NSFontAttributeName:largeFont,NSForegroundColorAttributeName:color}];
    [standardCardsButton setAttributedTitle:attrString2 forState:UIControlStateNormal];
    
    UITapGestureRecognizer *standardCardsTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(newGameTapDetected:)];
    standardCardsTap.numberOfTapsRequired = 1;
    standardCardsButton.userInteractionEnabled = YES;
    [standardCardsButton addGestureRecognizer:standardCardsTap];
    
    //Gallery Button
    UIButton *cardGalleryButton = menu.arrayOfButtons[buttonIndex++];
    
    NSMutableAttributedString *attrString5 = [[NSMutableAttributedString alloc] initWithString:@"Card Gallery" attributes:@{NSFontAttributeName:font,NSForegroundColorAttributeName:color}];
    [cardGalleryButton setAttributedTitle:attrString5 forState:UIControlStateNormal];
    
    UITapGestureRecognizer *cardGalleryTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(galleryTapDetected:)];
    cardGalleryTap.numberOfTapsRequired = 1;
    cardGalleryButton.userInteractionEnabled = YES;
    [cardGalleryButton addGestureRecognizer:cardGalleryTap];
    
    /*
    //Card Store Button
    UIButton *cardStoreButton = menu.arrayOfButtons[buttonIndex++];
    
    NSMutableAttributedString *attrString3 = [[NSMutableAttributedString alloc] initWithString:@"Store" attributes:@{NSFontAttributeName:font,NSForegroundColorAttributeName:color}];
    [cardStoreButton setAttributedTitle:attrString3 forState:UIControlStateNormal];
    
    UITapGestureRecognizer *cardStoreTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(storeTapDetected:)];
    cardStoreTap.numberOfTapsRequired = 1;
    cardStoreButton.userInteractionEnabled = YES;
    [cardStoreButton addGestureRecognizer:cardStoreTap];*/
    
    UIButton *settingsButton = menu.arrayOfButtons[buttonIndex++];
    
    NSMutableAttributedString *attrString4 = [[NSMutableAttributedString alloc] initWithString:@"Settings" attributes:@{NSFontAttributeName:font,NSForegroundColorAttributeName:color}];
    [settingsButton setAttributedTitle:attrString4 forState:UIControlStateNormal];
    
    UITapGestureRecognizer *settingsTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(settingsTapDetected:)];
    settingsTap.numberOfTapsRequired = 1;
    settingsButton.userInteractionEnabled = YES;
    [settingsButton addGestureRecognizer:settingsTap];
    
    return menu;
}



- (UIImageView *)makeImageViewForCard:(ARTCard *)card {
    
    CGFloat x = 5.0;
    CGFloat y = 5.0;
    CGFloat width = self.imageViewPlaceholder.bounds.size.width- x * 2.0;
    CGFloat height = self.imageViewPlaceholder.bounds.size.height- y * 2.0;
    
    CGRect shape = CGRectMake(x, y, width, height);
    shape = [self frameThatFitsImageFrame:shape withOrientation:card.orientation];
    
    UIImageView *imageView = [[UIImageView alloc] initWithFrame:shape];
    [imageView layoutIfNeeded];
    
    UIImage *image;
    if (IS_IPAD) {
        image= [[ARTImageHelper sharedInstance] getHQImageWithFileName:card.frontFilename ];
    } else {
        image= [[ARTImageHelper sharedInstance] getHQImageWithFileName:card.frontFilename ];
    }
    
    imageView.image = image;
    imageView.contentMode = UIViewContentModeScaleAspectFit;
    
    if ([[[ARTUserInfo sharedInstance] getVisualTheme] isEqual:@"white"]) {
        imageView.layer.shadowColor = [UIColor blackColor].CGColor;
        imageView.layer.shadowOffset = CGSizeMake(5.0, 5.0);
        imageView.layer.shadowOpacity = shadowOpacity;
        imageView.layer.shadowRadius = 3.0;
        imageView.layer.shadowPath = [UIBezierPath bezierPathWithRect:imageView.bounds].CGPath;
        
    } else {
        
    }
    
    imageView.clipsToBounds = NO;
    
    imageView.opaque = YES;
    
    return imageView;
}


- (void)newGameTapDetected:(UITapGestureRecognizer*)sender {
    NSLog(@"Tap detected");
    
    [((ARTButton *)sender.view) setCustomHighlighted:YES];
    
    if ([self getSaveforGameMode:@"single"] == nil) {
        
        
        //[self performSegueWithIdentifier:@"NewGameSegue" sender:self];
        
        NSMutableDictionary *players = [NSMutableDictionary new];
        NSMutableArray *unsortedAvatars = [[ARTAvatarHelper sharedInstance] getAvatars];
        
        ARTAvatar *thinkerAvatar;
        for (NSInteger i = 0; i < unsortedAvatars.count; i++) {
            ARTAvatar *avatar = unsortedAvatars[i];
            if ([avatar.name isEqual:kWiseGuyThinker]) {
                thinkerAvatar = avatar;
            }
        }
        
        ARTPlayer *player = [[ARTPlayer alloc] initWithNumber:@"Player1" andName:@"Player 1" andAvatar:thinkerAvatar];
        [players setValue:player forKey:@"Player1"];
        
        ARTGame *newGame = [[ARTGame alloc] initWithGameMode:@"single" andPlayers:players];
        
        [self setupGameSaves];
        
        [self performSegueWithIdentifier:@"GameSegue" sender:self];
        

        
    } else {
        
        
        [self performSegueWithIdentifier:@"GameSegue" sender:self];
        

    }
    
    
}

- (void)dailyTapDetected:(UITapGestureRecognizer*)sender {
    NSLog(@"Tap detected");
    
    if ([sender.view isMemberOfClass:[ARTButton class]]) {
    
        [((ARTButton *)sender.view) setCustomHighlighted:YES];
    }
    
    self.view.userInteractionEnabled = NO;
    
    if ([self getSaveforGameMode:@"daily"] == nil) {
        
        
        //[self performSegueWithIdentifier:@"NewGameSegue" sender:self];
        
        NSMutableDictionary *players = [NSMutableDictionary new];
        NSMutableArray *unsortedAvatars = [[ARTAvatarHelper sharedInstance] getAvatars];
        
        ARTAvatar *thinkerAvatar;
        for (NSInteger i = 0; i < unsortedAvatars.count; i++) {
            ARTAvatar *avatar = unsortedAvatars[i];
            if ([avatar.name isEqual:kWiseGuyThinker]) {
                thinkerAvatar = avatar;
            }
        }
        
        ARTPlayer *player = [[ARTPlayer alloc] initWithNumber:@"Player1" andName:@"Player 1" andAvatar:thinkerAvatar];
        [players setValue:player forKey:@"Player1"];
        
        //this is called since the game saves as soon as it is inited
        ARTGame *newGame = [[ARTGame alloc] initWithGameMode:@"daily" andPlayers:players];
        
        [self setupGameSaves];
        
        
        [self animateTappedCardToFillScreenWithCell];
        
    } else {
        
        
     
        [self animateTappedCardToFillScreenWithCell];

    }
    
    
}



- (void) storeTapDetected:(UITapGestureRecognizer*)sender {
    NSLog(@"Tap detected");
    
    [((ARTButton *)sender.view) setCustomHighlighted:YES];
    
    [self performSegueWithIdentifier:@"StoreSegue" sender:self];
    
}

- (void) galleryTapDetected:(UITapGestureRecognizer*)sender {
    NSLog(@"Tap detected");
    
    [((ARTButton *)sender.view) setCustomHighlighted:YES];
    
    [self performSegueWithIdentifier:@"GallerySegue" sender:self];
    
}

-  (void) settingsTapDetected:(UITapGestureRecognizer*)sender {
    NSLog(@"Tap detected");
    
    [((ARTButton *)sender.view) setCustomHighlighted:YES];
    
    [self performSegueWithIdentifier:@"SettingsSegue" sender:self];
    
}


- (id<UIViewControllerAnimatedTransitioning>)navigationController:(UINavigationController *)navigationController animationControllerForOperation:(UINavigationControllerOperation)operation fromViewController:(UIViewController *)fromVC toViewController:(UIViewController *)toVC {
    
    if ([toVC isMemberOfClass:[ARTNewGameViewController class]]) {
        ARTSlideTransitionAnimator *animator = [ARTSlideTransitionAnimator new];
        animator.direction = @"up";
        return animator;
    } else if ([toVC isMemberOfClass:[ARTDailyViewController class]]) {
        ARTSlideTransitionAnimator *animator = [ARTNoTransitionAnimator new];
        return animator;
    }
    
    return nil;
}

- (void)setupDailyDecks {
    NSMutableDictionary *decks = [[ARTCardHelper sharedInstance] getAllDailyDecks];
    NSArray *deckIDs = [decks allKeys];
    
    NSArray *sortedDeckIDs = [deckIDs sortedArrayUsingSelector:@selector(compare:)];
    
    NSMutableArray *reverseDeckKeys = [NSMutableArray new];
    NSInteger arrayCount = sortedDeckIDs.count;
    for( NSInteger i = arrayCount - 1; i >= 0; i--) {
        [reverseDeckKeys addObject:sortedDeckIDs[i]];
    }
    
    _dailyDecks = [NSMutableArray new];
    _sortedCardsFromDailyDecks = [NSMutableArray new];
    
    for (NSInteger i = 0; i < reverseDeckKeys.count; i++) {
        NSString *deckKey = reverseDeckKeys[i];
        ARTDeck *deck = decks[deckKey];
        [_dailyDecks addObject:deck];
        
        NSDictionary *cards = deck.cards;
        NSMutableArray *unsortedCards = [NSMutableArray new];
        
        for (NSString *cardKey in cards) {
            ARTCard *card = cards[cardKey];
            
            if (![card.category isEqualToString:finalQuestionCategoryName]) {
                [unsortedCards addObject:card];
            }
        }
        
        [_sortedCardsFromDailyDecks addObject:unsortedCards];
        
    }
    
}

- (void)randomizeCards {
    NSDictionary *decks = [[ARTCardHelper sharedInstance] getAllFreshDecks];
    NSArray *deckIDs = [decks allKeys];
    
    NSMutableArray *unsortedCards = [NSMutableArray new];
    for (NSString *deckKey in deckIDs) {
        ARTDeck *deck = decks[deckKey];
        NSDictionary *cards = deck.cards;
        
        for (NSString *cardKey in cards) {
            ARTCard *card = cards[cardKey];
            
            if (![card.category isEqualToString:finalQuestionCategoryName]) {
                [unsortedCards addObject:card];
            }
        }
        
    }
    
    _randomCards = [NSMutableArray new];
    NSMutableArray *randomCards = [NSMutableArray new];
    NSInteger cardCount = unsortedCards.count;
    for (NSInteger i = 0; i < cardCount; i++) {
        NSInteger remainingCards = unsortedCards.count;
        NSInteger randomCardIndex = arc4random() % remainingCards--;
        [randomCards addObject:unsortedCards[randomCardIndex]];
        [unsortedCards removeObject:unsortedCards[randomCardIndex]];
    }
    
    _randomCards = randomCards;
    _randomCardIndex = 0;
}


- (void)increaseRandomCardIndex {
    _randomCardIndex = (_randomCardIndex + 1) % _randomCards.count;
    
}

- (void)decreaseRandomCardIndex {
    
    if (_randomCardIndex - 1 < 0) {
        _randomCardIndex =  _randomCards.count - 1;
    }
    else {
        _randomCardIndex =  _randomCardIndex - 1;
        
    }
    
}

- (void)singleTapDetected:(UITapGestureRecognizer*)sender {
    NSLog(@"Tap Detected");
    
    [self resetAnimateCardTimer];
    
    [self increaseRandomCardIndex];
    UIImageView *nextImageView = [self makeImageViewForCard:_randomCards[_randomCardIndex]];
    
    nextImageView.alpha = 0.0;
    nextImageView.transform = self.imageView.transform;
    [self.imageViewPlaceholder insertSubview:nextImageView belowSubview:self.imageView];
    
    [self animateCardToSpinToImageView:nextImageView ForProgress:0.0];
    
    
}

- (void)doubleTapDetected:(UITapGestureRecognizer*)sender {
    NSLog(@"Double Tap Detected");
    
    [self resetAnimateCardTimer];
    
    [self animateCardToSpiral:NO ForProgress:1.01];
}

- (void)animateCardView:(UIImageView*)imageView OffScreenToRight:(BOOL)rightDirection {
    
    
    CGFloat x = imageView.frame.origin.x + self.view.frame.size.width * (rightDirection ? 1 : -1);
    CGFloat y = imageView.frame.origin.y;
    CGFloat width = imageView.frame.size.width;
    CGFloat height = imageView.frame.size.height;
    
    CGRect nextFrame = CGRectMake(x,y,width,height);
    
    [UIView animateWithDuration:0.35
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
    
    CGFloat x = imageView.frame.origin.x + self.view.frame.size.width * (rightDirection ? 1 : -1);
    CGFloat y = imageView.frame.origin.y;
    CGFloat width = imageView.frame.size.width;
    CGFloat height = imageView.frame.size.height;
    
    CGRect currentFrame = CGRectMake(x,y,width,height);
    imageView.frame = currentFrame;
    imageView.hidden = NO;
    
    [UIView animateWithDuration:0.35
                          delay:0.0
                        options:UIViewAnimationOptionCurveEaseOut | UIViewAnimationOptionAllowAnimatedContent
                     animations:^{
                         imageView.frame = nextFrame;
                         
                     } completion:^(BOOL finished) {
                         
                     }];
}

- (void)animateCardViewFlip:(UIImageView*)nextImageView FromBottom:(BOOL)bottomtDirection {
    
    nextImageView.hidden = NO;
    
    [UIView transitionFromView:self.imageView
                        toView:nextImageView
                      duration:0.4
                       options:(bottomtDirection ? UIViewAnimationOptionTransitionFlipFromTop : UIViewAnimationOptionTransitionFlipFromBottom)|UIViewAnimationOptionAllowAnimatedContent
                    completion:^(BOOL finished) {
                        if (finished) {
                            
                        }
                    }];
}

- (void)animateCardViewDissolve:(UIImageView*)nextImageView  {
    
    nextImageView.hidden = NO;
    
    [UIView transitionFromView:self.imageView
                        toView:nextImageView
                      duration:0.4
                       options:UIViewAnimationOptionTransitionCrossDissolve|UIViewAnimationOptionAllowAnimatedContent
                    completion:^(BOOL finished) {
                        if (finished) {
                            
                        }
                    }];
}



- (void)nextTapDetected:(UITapGestureRecognizer*)sender {
    NSLog(@"Tap Detected");
    
    [self resetAnimateCardTimer];
    
    [self advanceToNextCard];

}

- (void)previousTapDetected:(UITapGestureRecognizer*)sender {
    NSLog(@"Tap Detected");
    
    [self resetAnimateCardTimer];
    
    [self advanceToPreviousCard];
}

- (void)animateDailyCardFromRight {
    [self animateCardView:self.imageView OffScreenToRight:NO];
    
    [self increaseRandomCardIndex];
    UIImageView *nextImageView = [self makeImageViewForCard:_sortedCardsFromDailyDecks[self.deckIndex][self.cardIndex]];
    nextImageView.hidden = YES;
    [self.imageViewPlaceholder addSubview:nextImageView];
    
    [self animateCardView:nextImageView OnScreenFromRight:YES];
    self.imageView = nextImageView;
}

- (void)animateDailyCardFromLeft {
    [self animateCardView:self.imageView OffScreenToRight:YES];
    
    [self decreaseRandomCardIndex];
    UIImageView *nextImageView = [self makeImageViewForCard:_sortedCardsFromDailyDecks[self.deckIndex][self.cardIndex]];    nextImageView.hidden = YES;
    [self.imageViewPlaceholder addSubview:nextImageView];
    
    [self animateCardView:nextImageView OnScreenFromRight:NO];
    self.imageView = nextImageView;
}

- (void)animateCardFromRight {
    [self animateCardView:self.imageView OffScreenToRight:NO];
    
    [self increaseRandomCardIndex];
    UIImageView *nextImageView = [self makeImageViewForCard:_randomCards[_randomCardIndex]];
    nextImageView.hidden = YES;
    [self.imageViewPlaceholder addSubview:nextImageView];
    
    [self animateCardView:nextImageView OnScreenFromRight:YES];
    self.imageView = nextImageView;
}

- (void)animateCardFromLeft {
    [self animateCardView:self.imageView OffScreenToRight:YES];
    
    [self decreaseRandomCardIndex];
    UIImageView *nextImageView = [self makeImageViewForCard:_randomCards[_randomCardIndex]];
    nextImageView.hidden = YES;
    [self.imageViewPlaceholder addSubview:nextImageView];
    
    [self animateCardView:nextImageView OnScreenFromRight:NO];
    self.imageView = nextImageView;
}


- (void)upTapDetected:(UITapGestureRecognizer*)sender {
    NSLog(@"Tap Detected");
    
    [self resetAnimateCardTimer];
    
    [self decreaseRandomCardIndex];
    UIImageView *nextImageView = [self makeImageViewForCard:_randomCards[_randomCardIndex]];
    nextImageView.hidden = YES;
    
    [self animateCardViewFlip:nextImageView FromBottom:YES];
    
    self.imageView = nextImageView;
    
}

- (void)downTapDetected:(UITapGestureRecognizer*)sender {
    NSLog(@"Tap Detected");
    
    [self resetAnimateCardTimer];
    
    [self increaseRandomCardIndex];
    UIImageView *nextImageView = [self makeImageViewForCard:_randomCards[_randomCardIndex]];
    nextImageView.hidden = YES;
    
    [self animateCardViewFlip:nextImageView FromBottom:NO];
    
    self.imageView = nextImageView;
    
}

- (void)longTapDetected:(UILongPressGestureRecognizer*)sender {
    
    if (sender.state == UIGestureRecognizerStateEnded) {
        NSLog(@"UIGestureRecognizerStateEnded");
        [self resetAnimateCardTimer];
        
        //Do Whatever You want on End of Gesture
        _isOKToAnimateCardWiggle = NO;
        
    }
    else if (sender.state == UIGestureRecognizerStateBegan){
        NSLog(@"UIGestureRecognizerStateBegan.");
        [self cancelAnimateCardTimer];
        
        //Do Whatever You want on Began of Gesture
        _isOKToAnimateCardWiggle = YES;
        [self animateCardWiggleInRightDirection:YES];
        
    }
    
}

- (void)animateCardWiggleInRightDirection:(BOOL)rightIndicator {
    if (_isOKToAnimateCardWiggle) {
        
        CGAffineTransform nextTransform = self.imageView.transform;
        CGFloat directionSwitch = (rightIndicator ? 1/.96 : .96);
        nextTransform = CGAffineTransformScale(nextTransform, directionSwitch,directionSwitch);
        
        [UIView animateWithDuration:0.06
                              delay:0.0
                            options:UIViewAnimationOptionCurveLinear|UIViewAnimationOptionAllowAnimatedContent animations:^{
                                self.imageView.transform = nextTransform;
                            } completion:^(BOOL finished) {
                                [self animateCardWiggleInRightDirection:!rightIndicator];
                            }];
    } else {
        [self animateCardToBlowUp];
    }
}

- (CGRect)frameThatFitsImageFrame:(CGRect)frame withOrientation:(NSString *)orientation {
    
    CGFloat x;
    CGFloat y;
    CGFloat width;
    CGFloat height;
    
    
    if ( [orientation  isEqual: @"portrait"]) {
        if (frame.size.height / frame.size.width >= hToWRatio) {
            width = frame.size.width;
            height = width * hToWRatio;
            
        } else {
            height = frame.size.height;
            width = height / hToWRatio;
            
        }
    } else {
        if (frame.size.height / frame.size.width <= (1/hToWRatio)) {
            height = frame.size.height;
            width = height * hToWRatio;
            
        } else {
            width = frame.size.width;
            height = width / hToWRatio;
        }
    }
    
    x = frame.origin.x + (frame.size.width - width) / 2;
    y = frame.origin.y + (frame.size.height - height) / 2;
    
    CGRect newShape = CGRectMake(x, y, width, height);
    
    return newShape;
}

- (NSMutableAttributedString *)getIntroStringForSeconds:(CGFloat)seconds {
    
    UIFont * font;
    
    if (IS_OldIphone) {
        font = [UIFont fontWithName:@"HelveticaNeue-Medium" size:42];
    } else if (IS_IPHONE_5){
        font = [UIFont fontWithName:@"HelveticaNeue-Medium" size:42];
    } else if (IS_IPHONE_6){
        font = [UIFont fontWithName:@"HelveticaNeue-Medium" size:46];
    } else if (IS_IPHONE_6Plus){
        font = [UIFont fontWithName:@"HelveticaNeue-Medium" size:50];
    } else if (IS_IPAD){
        font = [UIFont fontWithName:@"HelveticaNeue-Medium" size:92];
    } else {
        font = [UIFont fontWithName:@"HelveticaNeue-Medium" size:44];
    }
    
    UIFont *largeFont = [UIFont fontWithName:@"HelveticaNeue-Bold" size:font.pointSize + 4.0];
    
    UIColor *lowlight;
    if ([[[ARTUserInfo sharedInstance] getVisualTheme] isEqual:@"white"]) {
        lowlight = [UIColor blackColor];
    } else {
        lowlight = [UIColor whiteColor];
    }
    
    UIColor *highlight;
    if ([[[ARTUserInfo sharedInstance] getVisualTheme] isEqual:@"white"]) {
        highlight = [UIColor blackColor];
    } else {
        highlight = [UIColor blueButtonColor];
    }
    
    UIColor *color;
    
    color = lowlight;
    
    NSMutableAttributedString *attrString = [[NSMutableAttributedString alloc] initWithString:@"" attributes:@{NSForegroundColorAttributeName:color,NSFontAttributeName:font}];
    
    /* NSString *text1 = [NSString stringWithFormat:@"Not so long ago in %@...\n\n\n",_location];
     
     NSMutableAttributedString *attrString2 = [[NSMutableAttributedString alloc] initWithString:text1 attributes:@{NSForegroundColorAttributeName:color,NSFontAttributeName:font}];
     
     if (seconds > 6.0) {
     color = highlight;
     } else {
     color = lowlight;
     }
     NSString *text2 = [NSString stringWithFormat:@"trivia"];
     
     NSMutableAttributedString *attrString3 = [[NSMutableAttributedString alloc] initWithString:text2 attributes:@{NSForegroundColorAttributeName:color,NSFontAttributeName:font}];
     
     color = lowlight;
     NSString *text3 = [NSString stringWithFormat:@" games were merely memory tests.\n\n\nIt's time for a\nTrivia Revolution!"];
     
     NSMutableAttributedString *attrString4 = [[NSMutableAttributedString alloc] initWithString:text3 attributes:@{NSForegroundColorAttributeName:color,NSFontAttributeName:font}];
     
     if (seconds > 10.0) {
     color = highlight;
     } else {
     color = lowlight;
     }
     NSString *text4 = [NSString stringWithFormat:@""];
     
     NSMutableAttributedString *attrString5 = [[NSMutableAttributedString alloc] initWithString:text4 attributes:@{NSForegroundColorAttributeName:color,NSFontAttributeName:font}];
     
     if (seconds > 12.0) {
     color = highlight;
     } else {
     color = lowlight;
     }    NSString *text5 = [NSString stringWithFormat:@"\n\n\n%@\nis NOT a memory test!\n\n\n",appTitle];
     
     NSMutableAttributedString *attrString6 = [[NSMutableAttributedString alloc] initWithString:text5 attributes:@{NSForegroundColorAttributeName:color,NSFontAttributeName:font}];*/
    
    color = lowlight;
    NSString *text6 = [NSString stringWithFormat:@"%@ combines\nintriguing trivia,\nbeautiful art,\nand\nclever clues.\n\n\nThe answers are common words and phrases that you can deduce.\n\n\n",appTitle];
    
    NSMutableAttributedString *attrString7 = [[NSMutableAttributedString alloc] initWithString:text6 attributes:@{NSForegroundColorAttributeName:color,NSFontAttributeName:font}];
    
    color = lowlight;
    NSString *text7 = [NSString stringWithFormat:@"Enjoy\nThe\nTrivia Trip!\n\n"];
    
    NSMutableAttributedString *attrString8 = [[NSMutableAttributedString alloc] initWithString:text7 attributes:@{NSForegroundColorAttributeName:color,NSFontAttributeName:largeFont}];
    
    
    //  [attrString appendAttributedString:attrString2];
    // [attrString appendAttributedString:attrString3];
    // [attrString appendAttributedString:attrString4];
    //  [attrString appendAttributedString:attrString5];
    //  [attrString appendAttributedString:attrString6];
    [attrString appendAttributedString:attrString7];
    [attrString appendAttributedString:attrString8];
    
    
    NSInteger strLength = attrString.length;
    NSMutableParagraphStyle *style = [[NSMutableParagraphStyle alloc] init];
    [style setLineHeightMultiple:1.05];
    [attrString addAttribute:NSParagraphStyleAttributeName
                       value:style
                       range:NSMakeRange(0, strLength)];
    
    return attrString;
}


- (void)makeIntroLabel {
    CGFloat x = 0.0;
    CGFloat y = self.tranformedView.bounds.size.height;
    CGFloat width = self.tranformedView.bounds.size.width;
    CGFloat height;
    
    NSMutableAttributedString *attrString= [self getIntroStringForSeconds:0.0];
    
    CGSize maximumLabelSize = CGSizeMake(width, CGFLOAT_MAX);
    
    NSString *string = attrString.string;
    
    CGRect textRect = [string boundingRectWithSize:maximumLabelSize
                                           options:(NSStringDrawingUsesLineFragmentOrigin|NSStringDrawingUsesFontLeading)
                                        attributes:[attrString attributesAtIndex:0 effectiveRange:nil]
                                           context:nil];
    string = nil;
    
    height = ceil(textRect.size.height);
    
    CGRect shape = CGRectMake(x, y, width, height);
    
    self.textLabel = [[UILabel alloc] initWithFrame:shape];
    
    
    
    self.textLabel.attributedText = attrString;
    self.textLabel.numberOfLines = 0;
    self.textLabel.lineBreakMode = NSLineBreakByWordWrapping;
    self.textLabel.textAlignment = NSTextAlignmentCenter;
    
    self.textLabel.backgroundColor = self.view.backgroundColor;
    self.textLabel.opaque = YES;
}


- (void)setupTransformedView {
    
    CGRect shape = CGRectMake(0.0, (self.view.bounds.size.height - self.view.bounds.size.height*_ratio)/2.0, self.view.bounds.size.width, self.view.bounds.size.height*_ratio);
    self.tranformedView = [[UIView alloc] initWithFrame:shape];
    self.tranformedView.clipsToBounds = YES;
    self.tranformedView.userInteractionEnabled = NO;
    self.tranformedView.backgroundColor = [UIColor clearColor];
    
    [self.view addSubview:self.tranformedView];
    
    [self makeIntroLabel];
    
    [self.tranformedView addSubview:self.textLabel];
    
    self.cardImageGridView = [[UIView alloc] init];
    self.cardImageGridView.backgroundColor = self.view.backgroundColor;
    self.cardImageGridView.opaque = YES;
    
    NSInteger cardColumns = 4.0;
    
    CGFloat cardSpacing = 10.0;
    
    CGFloat x = 0.0;
    CGFloat y = 0.0;
    CGFloat width = (self.tranformedView.frame.size.width - (cardColumns -1) * cardSpacing) / cardColumns;
    CGFloat height = width * hToWRatio;
    
    
    self.cardImageViews = [NSMutableArray new];
    for (NSInteger i = 0; i < 48; i++) {
        //for when cards are less than 80 ARTCard *card = _randomCards[(i % cardCount)];
        ARTCard *card = _randomCards[i];
        
        
        x = (i % cardColumns) * (width + cardSpacing);
        y = (i / cardColumns) * (height + cardSpacing) ;
        CGRect frame = CGRectMake(x, y, width, height);
        
        UIImage *portraitImage = [[ARTImageHelper sharedInstance] getLQImageWithFileName:card.frontFilename ];
        UIImageView *cardImageView = [[UIImageView alloc] initWithImage:portraitImage];
        
        if ([card.orientation  isEqual: @"landscape"]) {
            CGFloat rotation = M_PI_2;
            cardImageView.transform = CGAffineTransformRotate(cardImageView.transform, rotation);
        }
        
        cardImageView.frame = frame;
        cardImageView.contentMode = UIViewContentModeScaleAspectFit;
        cardImageView.opaque = YES;
        
        cardImageView.layer.rasterizationScale = (IS_OldIphone ? 4.0 : [UIScreen mainScreen].scale); //this makes the cards look ok on ipad mini retina which is 4x in simulator mode but it registers as retina iphone 2x
        cardImageView.layer.shouldRasterize = YES;
        
        [self.cardImageGridView addSubview:cardImageView];
        [self.cardImageViews addObject:cardImageView];
    }
    
    
    
    CGFloat totalHeight = y + height + cardSpacing;
    self.cardImageGridView.frame = CGRectMake(0.0, self.tranformedView.frame.size.height, self.tranformedView.frame.size.width, totalHeight);
    [self.tranformedView addSubview:self.cardImageGridView];
    
    
    // Start with a blank transform
    CATransform3D blankTransform = CATransform3DIdentity;
    
    // Skew the text
    blankTransform.m34 = -1.0 / 500.0;
    
    // Rotate the text
    blankTransform = CATransform3DRotate(blankTransform, 45.0 * M_PI / 180.0, 1.0, 0.0, 0.0);
    
    CGFloat scale;
    
    if (IS_OldIphone) {
        scale = 0.6;
    } else if (IS_IPHONE_5){
        scale = 0.6;
    } else if (IS_IPHONE_6){
        scale = 0.65;
    } else if (IS_IPHONE_6Plus){
        scale = 0.65;
    } else if (IS_IPAD){
        scale = 0.52;
    }
    
    blankTransform = CATransform3DScale(blankTransform, scale, scale, scale);
    
    self.tranformedView.layer.transform = blankTransform;
    
}



- (void) animateTransformedViewInFull:(BOOL)fullIndicator {
    
    
    if (fullIndicator) {
        /* self.cardImageGridView2.center = CGPointMake(self.cardImageGridView2.center.x, self.tranformedView2.bounds.size.height + self.cardImageGridView2.frame.size.height/2.0);
         
         // self.cardImageGridView2.layer.borderColor = [UIColor whiteColor].CGColor;
         //  self.cardImageGridView2.layer.borderWidth = 1.0;
         
         CGFloat moveDistance2 = self.cardImageGridView2.frame.size.height * 2.5;
         
         [UIView animateWithDuration:4.0
         delay:0.0
         options:UIViewAnimationOptionCurveEaseIn | UIViewAnimationOptionAllowAnimatedContent
         animations:^{
         
         self.cardImageGridView2.center = CGPointMake(self.cardImageGridView2.center.x, self.cardImageGridView2.center.y - moveDistance2);
         } completion:^(BOOL finished) {
         
         [self.tranformedView2 removeFromSuperview];
         self.tranformedView2 = nil;
         self.cardImageGridView2 = nil;
         self.cardImageViews2 = nil;
         }];
         
         */
        self.cardImageGridView.center = CGPointMake(self.cardImageGridView.center.x, self.textLabel.center.y+self.textLabel.frame.size.height/2.0+self.cardImageGridView.frame.size.height/2.0);
        
        CGFloat moveDistance = self.textLabel.frame.size.height + self.cardImageGridView.frame.size.height /5.0 ;
        
        CGFloat delay;
        if (IS_IPAD) {
            delay = 0.0;
        } else {
            delay = 0.0;
        }
        
        [UIView animateWithDuration:14.0
                              delay:delay
                            options:UIViewAnimationOptionCurveLinear | UIViewAnimationOptionAllowAnimatedContent
                         animations:^{
                             self.textLabel.center = CGPointMake(self.textLabel.center.x, self.textLabel.center.y - moveDistance);
                             self.cardImageGridView.center = CGPointMake(self.cardImageGridView.center.x, self.cardImageGridView.center.y - moveDistance);
                         } completion:^(BOOL finished) {
                             
                             CGFloat moveDistance = - self.cardImageGridView.frame.size.height * 1.8 ;
                             
                             [UIView animateWithDuration:2.6
                              
                                                   delay:0.0
                                                 options:UIViewAnimationOptionBeginFromCurrentState | UIViewAnimationOptionCurveEaseIn | UIViewAnimationOptionAllowAnimatedContent
                                              animations:^{
                                                  self.textLabel.center = CGPointMake(self.textLabel.center.x, self.textLabel.center.y + moveDistance);
                                                  self.cardImageGridView.center = CGPointMake(self.cardImageGridView.center.x, self.cardImageGridView.center.y + moveDistance );
                                              } completion:^(BOOL finished) {
                                                  [self.tranformedView removeFromSuperview];
                                                  self.tranformedView = nil;
                                                  self.textLabel = nil;
                                                  self.cardImageGridView = nil;
                                                  self.cardImageViews = nil;
                                                  self.isOKToAnimateLabel = NO;
                                                  [self viewWillAppear:NO];
                                              }];
                         }];
        
    } else {
        
        CGFloat moveDistance = self.cardImageGridView.frame.size.height * 2.0 ;
        
        [UIView animateWithDuration:3.0
                              delay:0.0
                            options:UIViewAnimationOptionCurveEaseIn | UIViewAnimationOptionAllowAnimatedContent
                         animations:^{
                             
                             self.cardImageGridView.center = CGPointMake(self.cardImageGridView.center.x, self.cardImageGridView.center.y - moveDistance);
                         } completion:^(BOOL finished) {
                             
                             [self.tranformedView removeFromSuperview];
                             self.tranformedView = nil;
                             self.textLabel = nil;
                             self.cardImageGridView = nil;
                             self.cardImageViews = nil;
                             
                             [self viewWillAppear:NO];
                         }];
    }
    
}

- (void)animateTappedCardToFillScreenWithCell {
    
    ARTCard *card = _sortedCardsFromDailyDecks[self.deckIndex][self.cardIndex];
    
    CGFloat cardViewWidth;
    CGFloat cardViewHeight;
    CGFloat cardViewX;
    CGFloat cardViewY;
    
    
    
    cardViewWidth = self.imageView.frame.size.width;
    cardViewHeight = self.imageView.frame.size.height;
    cardViewX = self.imageViewPlaceholder.frame.origin.x + self.imageView.frame.origin.x;
    cardViewY = self.imageViewPlaceholder.frame.origin.y + self.imageView.frame.origin.y;
    
    CGRect mainViewFrame = CGRectMake(cardViewX, cardViewY, cardViewWidth, cardViewHeight);
    
    UIImageView *imageView = [[UIImageView alloc] initWithFrame:mainViewFrame];
    imageView.image = self.imageView.image ;
    imageView.contentMode = UIViewContentModeScaleAspectFit;
    imageView.opaque = YES;
    
    if ([[[ARTUserInfo sharedInstance] getVisualTheme] isEqual:@"white"]) {
        imageView.layer.shadowColor = [UIColor blackColor].CGColor;
        imageView.layer.shadowOffset = CGSizeMake(5.0, 5.0);
        imageView.layer.shadowOpacity = shadowOpacity;
        imageView.layer.shadowRadius = 3.0;
        
    } else {
        
    }
    
    
    [self.view addSubview:imageView];
    
    cardViewWidth = self.view.bounds.size.width;
    cardViewHeight = self.view.bounds.size.height - 40.0;
    cardViewX = self.view.bounds.origin.x;
    cardViewY = 20.0;
    
    CGRect nextFrame = CGRectMake(cardViewX, cardViewY, cardViewWidth, cardViewHeight);
    
    CGAffineTransform trans = imageView.transform;
    
    CGFloat zoomRatio;
    if (IS_OldIphone && [card.orientation isEqualToString:@"portrait"]) {
        zoomRatio = cardOverlayImageZoomIphone4Ratio;
    } else if (IS_IPAD && [card.orientation isEqualToString:@"portrait"]) {
        zoomRatio = cardOverlayImageZoomIpadRatioPortrait;
    } else if (IS_IPAD && [card.orientation isEqualToString:@"landscape"]) {
        zoomRatio = cardOverlayImageZoomIpadRatioLandscape;
    } else {
        zoomRatio = cardOverlayImageZoomIphone5Ratio;
    }
    trans = CGAffineTransformScale(trans, 1.0/zoomRatio, 1.0/zoomRatio);
    
    self.imageView.alpha = 0.0;
    
    CGFloat duration;
    if (IS_IPAD) {
        duration = cardToScreenDurationIpad;
    } else {
        duration = cardToScreenDurationIphone;
    }

    
    [UIView animateWithDuration:duration
                          delay:0.0
                        options:UIViewAnimationOptionCurveEaseInOut | UIViewAnimationOptionAllowAnimatedContent
                     animations:^{
                         
                         self.logoImageView.alpha = 0.0;
                         self.menuPlaceholder.alpha = 0.0;
                         self.tagLineLabel.alpha = 0.0;
                         
                     }
                     completion:^(BOOL finished){
                         
                         
                     }];

    
    
    [UIView animateWithDuration:duration
                          delay:0.0
                        options:UIViewAnimationOptionCurveEaseInOut | UIViewAnimationOptionAllowAnimatedContent
                     animations:^{
                         
                         imageView.frame = nextFrame;
                         
                         imageView.transform = trans;
                         
                     }
                     completion:^(BOOL finished){
                         
                         [self performSegueWithIdentifier:@"DailyCardSegue" sender:self];
                         
                         [imageView removeFromSuperview];
                         self.imageView.alpha = 1.0;
                         
                         self.logoImageView.alpha = 1.0;
                         self.menuPlaceholder.alpha = 1.0;
                         self.tagLineLabel.alpha = 1.0;
                         
                         self.view.userInteractionEnabled = YES;

                     }];
    
}

- (void)animateTappedCardToPile {
    

    self.imageView.alpha = 0.0;
    
    ARTCard *card = self.sortedCardsFromDailyDecks[self.deckIndex][self.cardIndex];
    
    CGFloat cardViewWidth;
    CGFloat cardViewHeight;
    CGFloat cardViewX;
    CGFloat cardViewY;
    
    cardViewWidth = self.view.bounds.size.width;
    cardViewHeight = self.view.bounds.size.height - 40.0;
    cardViewX = self.view.bounds.origin.x;
    cardViewY = 20.0;
    
    CGRect mainViewFrame = CGRectMake(cardViewX, cardViewY, cardViewWidth, cardViewHeight);
    
    UIImageView *imageView = [[UIImageView alloc] initWithFrame:mainViewFrame];
    
    CGAffineTransform trans = imageView.transform;
    
    CGFloat zoomRatio;
    if (IS_OldIphone && [card.orientation isEqualToString:@"portrait"]) {
        zoomRatio = cardOverlayImageZoomIphone4Ratio;
    } else if (IS_IPAD && [card.orientation isEqualToString:@"portrait"]) {
        zoomRatio = cardOverlayImageZoomIpadRatioPortrait;
    } else if (IS_IPAD && [card.orientation isEqualToString:@"landscape"]) {
        zoomRatio = cardOverlayImageZoomIpadRatioLandscape;
    } else {
        zoomRatio = cardOverlayImageZoomIphone5Ratio;
    }
    trans = CGAffineTransformScale(trans, 1.0/zoomRatio, 1.0/zoomRatio);
    imageView.transform = trans;
    
    imageView.image = self.imageView.image ;
    imageView.contentMode = UIViewContentModeScaleAspectFit;
    imageView.opaque = YES;
    
    if ([[[ARTUserInfo sharedInstance] getVisualTheme] isEqual:@"white"]) {
        imageView.layer.shadowColor = [UIColor blackColor].CGColor;
        imageView.layer.shadowOffset = CGSizeMake(5.0, 5.0);
        imageView.layer.shadowOpacity = shadowOpacity;
        imageView.layer.shadowRadius = 3.0;
        
    } else {
        
    }
    
    
    [self.view addSubview:imageView];
    
    cardViewWidth = self.imageView.frame.size.width;
    cardViewHeight = self.imageView.frame.size.height;
    cardViewX = self.imageViewPlaceholder.frame.origin.x + self.imageView.frame.origin.x;
    cardViewY = self.imageViewPlaceholder.frame.origin.y + self.imageView.frame.origin.y;
    
    CGRect nextFrame = CGRectMake(cardViewX, cardViewY, cardViewWidth, cardViewHeight);
    
    trans = imageView.transform;
    if (IS_OldIphone && [card.orientation isEqualToString:@"portrait"]) {
        zoomRatio = cardOverlayImageZoomIphone4Ratio;
    } else if (IS_IPAD && [card.orientation isEqualToString:@"portrait"]) {
        zoomRatio = cardOverlayImageZoomIpadRatioPortrait;
    } else if (IS_IPAD && [card.orientation isEqualToString:@"landscape"]) {
        zoomRatio = cardOverlayImageZoomIpadRatioLandscape;
    } else {
        zoomRatio = cardOverlayImageZoomIphone5Ratio;
    }
    trans = CGAffineTransformScale(trans, zoomRatio, zoomRatio);
    
    CGFloat duration;
    if (IS_IPAD) {
        duration = cardToScreenDurationIpad;
    } else {
        duration = cardToScreenDurationIphone;
    }
    
    self.logoImageView.alpha = 0.0;
    self.menuPlaceholder.alpha = 0.0;
    self.tagLineLabel.alpha = 0.0;
    
    [UIView animateWithDuration:duration
                          delay:0.2
                        options:UIViewAnimationOptionCurveEaseInOut | UIViewAnimationOptionAllowAnimatedContent
                     animations:^{
                         
                         self.logoImageView.alpha = 1.0;
                         self.menuPlaceholder.alpha = 1.0;
                         self.tagLineLabel.alpha = 1.0;
                         
                     }
                     completion:^(BOOL finished){
                         
                         
                     }];
    
    
    // Transition using a image flip
    [UIView animateWithDuration:duration
                          delay:0.0
                        options:UIViewAnimationOptionCurveEaseInOut | UIViewAnimationOptionAllowAnimatedContent
                     animations:^{
                         
                         imageView.frame = nextFrame;
                         
                         //imageView.transform = trans;
                         
                     }
                     completion:^(BOOL finished){
                         self.imageView.alpha = 1.0;
                         [imageView removeFromSuperview];
                     }];
    
}

- (CGRect)moveFrame:(CGRect)frame offScreenInDirection:(screenDirection)direction withScreenRatio:(CGFloat)ratio {
    
    if (direction == kRight) {
        frame.origin.x += self.view.bounds.size.width * ratio;
    }
    else if (direction == kLeft) {
        frame.origin.x -= self.view.bounds.size.width * ratio;
    }
    else if (direction == kUp) {
        frame.origin.y -= self.view.bounds.size.height * ratio;
    }
    else if (direction == kDown) {
        frame.origin.y += self.view.bounds.size.height * ratio;
    }
    
    return frame;
}

@end
