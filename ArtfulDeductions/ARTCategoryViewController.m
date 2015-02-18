//
//  ARTCategoryViewController.m
//  Artful Deductions
//
//  Created by Kyle Rokita on 9/30/14.
//  Copyright (c) 2014 Artful Deductions LLC. All rights reserved.
//

#import "ARTCategoryViewController.h"
#import "ARTNavigationController.h"
#import "ARTConstants.h"
#import "ARTCardViewController.h"
#import "ARTUserInfo.h"
#import "UIColor+Extensions.h"
#import "ARTGame.h"
#import "ARTCategoryCollectionReusableViewHeader.h"
#import "ARTCategoryCollectionViewCell.h"
#import "ARTDeck.h"
#import "ARTCard.h"
#import "ARTImageHelper.h"
#import "ARTFadeTransitionAnimator.h"
#import "ARTNoTransitionAnimator.h"
#import "ARTPlayer.h"
#import "ARTAvatar.h"
#import "UIButton+Extensions.h"
#import "ARTCategoryViewFlowLayout.h"
#import "ARTCollectionSectionDecorationView.h"
#import "ARTTopView.h"
//#import "ARTIAPHelper.h"
#import "ARTNewGameViewController.h"
#import "ARTSlideTransitionAnimator.h"
#import "ARTScoreViewController.h"
#import "ARTPopoverAnimator.h"
#import "ARTMessageViewController.h"
#import "URBAlertView.h"
#import "MKStoreManager.h"
#import "UIImage+Customization.h"
#import "ARTDailyViewController.h"


//spacing between items on the same row
static CGFloat const collectionCellSpacing = 0.0;
static CGFloat const collectionCellSpacingIPad = 0.0;

//spacing between rows
static CGFloat const minLineSpacing = 5.;
static CGFloat const minLineSpacingIpad = 0.;

static CGFloat const rightLeftEdgeInsets = 10.0;

static CGFloat const topEdgeInsets = 25.0;
static CGFloat const bottomEdgeInsets = 10.0;

static CGFloat const numberOfColumnsIphone = 2.0;

static CGFloat const cardAnimationDelay = 6.0;
static CGFloat const headerAnimationDelay = 5.0;


@interface ARTCategoryViewController () {
    NSMutableArray *_deckSections;
}

@property (nonatomic) BOOL isFirstTimeShowing;


@end

@implementation ARTCategoryViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.automaticallyAdjustsScrollViewInsets = NO;
    
    [self initializeCardGlobalVariables];
    
    self.backButton = [[UIButton alloc] backButtonWith:@"Menu" tintColor:[UIColor blueNavBarColor] target:self andAction:@selector(backButtonTapped:)];
    [self.view addSubview:self.backButton];
    
    _deckSections = [self getDeckSections];
    
    [self setupCollectionview];
    
    
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
    if ([segue.identifier isEqual:@"DailyCardSegue"]) {
        
        ARTDailyViewController *dailyViewController = (ARTDailyViewController *)segue.destinationViewController;
        
        dailyViewController.delegate = self;
        dailyViewController.selectedDeck = self.selectedDeck;
        dailyViewController.selectedCard = self.selectedCard;
        dailyViewController.currentGame = self.currentGame;
        
        
        dailyViewController.sortedCardsFromSortedDecks = [NSMutableArray arrayWithObject:[self.selectedDeck getArrayOfSortedCards]];
        dailyViewController.sortedDecks = [NSMutableArray arrayWithObject:self.selectedDeck];
        dailyViewController.deckIndex = 0;
        dailyViewController.cardIndex = [self.selectedCard.categoryNumber integerValue] - 1;
        
    }
    else if ([segue.identifier isEqual:@"PlayerSetup"]) {
        
        ARTNewGameViewController *playerSetupViewController = (ARTNewGameViewController *)segue.destinationViewController;
        
        playerSetupViewController.game = self.currentGame;
        playerSetupViewController.newPlayer = NO;
        
    } else if ([segue.identifier isEqual:@"ScoreSegue"]) {
        
        ARTScoreViewController *destViewController = (ARTScoreViewController *)segue.destinationViewController;
        
        
        //self.navigationController.modalPresentationStyle = UIModalPresentationCurrentContext;
        //[self presentViewController:vc animated:NO completion:nil]
        
        UIPopoverPresentationController *popPC = destViewController.popoverPresentationController;
        popPC.delegate = self;
        
        destViewController.deck = self.selectedDeck;
        
    }
}

- (UIModalPresentationStyle)adaptivePresentationStyleForPresentationController:(UIPresentationController *)controller {
    return UIModalPresentationOverCurrentContext;
}


- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    
    
    [[NSNotificationCenter defaultCenter] addObserver: self
                                             selector: @selector(handleEnteredBackground)
                                                 name: UIApplicationDidEnterBackgroundNotification
                                               object: nil];
    [[NSNotificationCenter defaultCenter] addObserver: self
                                             selector: @selector(handleDidBecomeActive)
                                                 name: UIApplicationWillEnterForegroundNotification
                                               object: nil];
    
    self.navigationController.delegate = self;
    
    [(ARTNavigationController*)[self navigationController] setLandscapeOK:NO];
    [self.navigationController setNavigationBarHidden:YES animated:NO];
    
    [self.view layoutIfNeeded];
    
    if (self.isFirstTimeShowing || self.isNonCardButtonPressed) {
        [MKStoreManager enablePurchasedProducts];
        [self.currentGame updateEnabledDecks];
        _deckSections = [self getDeckSections];
    }
    [self.currentGame updateEnabledDecks];

    
    if (self.isFirstTimeShowing) {
        
        if ([[[ARTUserInfo sharedInstance] getVisualTheme] isEqual:@"white"]) {
            self.view.backgroundColor = [UIColor lightBackgroundColor];
        } else {
            self.view.backgroundColor = [UIColor darkBackgroundColor];
        }
        
        [self setupLogoImageView];
        [self setupCategoryPlaceholderView];
        
        [self.view sendSubviewToBack:self.collectionView];
        
    }
    
   // [self setupAvatarImageview];

    [self.view layoutIfNeeded];
    
    [self.view sendSubviewToBack:self.categoryPlaceholderView];
    
    [self.collectionView reloadData];
}


- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
    NSLog(@"view did appear");
    
    [self.view layoutIfNeeded];
    
    
    if (self.isFirstTimeShowing) {
        self.isOKToAnimateImageFlips = YES;
        [self animateImageFlipWithDelay:0.25];
        
        self.isFirstTimeShowing = NO;
    }
    else {
        
        
        if (self.isCardBackButtonPressed ) {
            self.isOKToAnimateImageFlips = YES;
            [self animateImageFlipWithDelay:1.5];
            
            [self animateTappedCardToFade];
        }
        else if (self.isCardNextCardButtonPressed) {
            
            [self animateTappedCardOffScreen];
            
        }
        else if (self.isCardContinueButtonPressed) {
            self.isOKToAnimateImageFlips = YES;
            [self animateImageFlipWithDelay:1.5];
            
            [self animateTappedCardOffScreen];
            
        }
        else if (self.isNonCardButtonPressed) {
            self.isOKToAnimateImageFlips = YES;
            [self animateImageFlipWithDelay:0.25];
            
        }
   
    }
    
    self.isOKToAnimateHeaderView = YES;
    [self animateHeaderViewWithDelay:4.0];
    
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    
   [self handleEnteredBackground];// already handling before methods that leave screen
    
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    
    [self cancelAnimateCardTimer];
    [self cancelAnimateHeaderTimer];

}

- (void)initializeCardGlobalVariables {
    self.isShowingImageSide = YES;
    self.isCardNextCardButtonPressed = NO;
    self.isCardBackButtonPressed = NO;
    self.isCardNextCardButtonPressed = NO;
    self.isNonCardButtonPressed = NO;
    self.isFirstTimeShowing = YES;
    self.isShowingHeaderSampleCount = YES;
}

- (void)animateImageFlipWithDelay:(CGFloat)delay {
    
    
    [self cancelAnimateCardTimer];
    
    self.animationTimer = [NSTimer scheduledTimerWithTimeInterval:delay
                                                           target:self
                                                         selector:@selector(animateImageFlip)
                                                         userInfo:nil
                                                          repeats:NO];
}

- (void)animateImageFlip {
    
    if (self.isOKToAnimateImageFlips) {
        
        [self animateCellImageFlips];
        [self resetAnimateCardTimer];
    }
    
}

//this is useful when more topics get added
/*-(void)scrollViewWillBeginDragging:(UIScrollView *)scrollView {
    
    self.isOKToAnimateImageFlips = NO;
    [self cancelAnimateCardTimer];

}


- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate
{
        self.isOKToAnimateImageFlips = YES;
        [self animateImageFlipWithDelay:2.0];
}*/

- (void)resetAnimateCardTimer {
    [self cancelAnimateCardTimer];
    
    self.animationTimer = [NSTimer scheduledTimerWithTimeInterval:cardAnimationDelay
                                                           target:self
                                                         selector:@selector(animateImageFlip)
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


- (void)setupLogoImageView {
    
    self.logoImageView.image = [UIImage new];
    
    NSArray *subviews = [self.logoImageView subviews];
    if (subviews.count == 0) {
        UILabel *label = [[UILabel alloc] initWithFrame:self.logoImageView.bounds];
        label.textAlignment = NSTextAlignmentCenter;
        label.text = @"Trivia\nTopics";
        
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
        
        [self.logoImageView addSubview:label];

    }
    
    if (!self.topView) {
        self.topView = [[ARTTopView alloc] init];
        [self.view addSubview:self.topView];

    }
    
    [self.view sendSubviewToBack:self.logoImageView];
    [self.view sendSubviewToBack:self.topView];
    
    
}

- (void)setupAvatarImageview {
    
    ARTPlayer *player = self.currentGame.players[@"Player1"];
    
    //only setup the views the first time it loads
    if (!self.avatarPlaceholderView) {
        CGFloat width = 200.0;
        CGFloat height = self.logoImageView.frame.size.height;
        CGFloat x = self.view.bounds.size.width - width - 2.0;
        CGFloat y = self.logoImageView.frame.origin.y;
        
        CGRect avatarPlaceholderFrame = CGRectMake(x,y, width, height);
        
        self.avatarPlaceholderView = [[UIView alloc] initWithFrame:avatarPlaceholderFrame];
        self.avatarPlaceholderView.backgroundColor = [UIColor clearColor];
        [self.view addSubview:self.avatarPlaceholderView];
        
        CGFloat imageviewHeight = self.avatarPlaceholderView.bounds.size.height;
        CGFloat imageviewX = self.avatarPlaceholderView.bounds.size.width - imageviewHeight;
        CGFloat imageviewY = self.avatarPlaceholderView.bounds.origin.y;
        
        CGRect avatarImageviewFrame = CGRectMake(imageviewX,imageviewY, imageviewHeight, imageviewHeight);
        
        self.avatarImageview = [[UIImageView alloc] initWithFrame:avatarImageviewFrame];
        
        self.avatarImageview.contentMode = UIViewContentModeScaleAspectFill;
        self.avatarImageview.layer.cornerRadius = self.avatarImageview.frame.size.height / 2.0;
        self.avatarImageview.layer.borderWidth = 0.75;
        self.avatarImageview.layer.borderColor = [UIColor lightGrayColor].CGColor;
        self.avatarImageview.clipsToBounds = YES;
        
        CGFloat labelWidth = self.avatarPlaceholderView.bounds.size.width - self.avatarImageview.frame.size.width - 4.0;
        CGFloat labelHeight = self.avatarPlaceholderView.bounds.size.height;
        
        CGFloat labelX = self.avatarPlaceholderView.bounds.origin.x;
        CGFloat labelY = self.avatarPlaceholderView.bounds.origin.y;
        
        CGRect labelFrame = CGRectMake(labelX,labelY, labelWidth, labelHeight);
        
        self.avatarLabel = [[UILabel alloc] initWithFrame:labelFrame];
        
        self.avatarLabel.textAlignment = NSTextAlignmentRight;
        
        if ([[[ARTUserInfo sharedInstance] getVisualTheme] isEqual:@"white"]) {
            self.avatarLabel.textColor = [UIColor blueNavBarColor];
        } else {
            self.avatarLabel.textColor = [UIColor blueNavBarColor];
        }
        
        if (IS_IPAD) {
            self.avatarLabel.font = [UIFont fontWithName:@"HelveticaNeue" size:29];
        } else {
            self.avatarLabel.font = [UIFont fontWithName:@"HelveticaNeue" size:19];
        }
        
        
        [self.avatarPlaceholderView addSubview:self.avatarImageview];
        [self.avatarPlaceholderView addSubview:self.avatarLabel];
        [self.view addSubview:self.avatarPlaceholderView];
        
        UITapGestureRecognizer *singleTapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(avatarTapDetected:)];
        singleTapGesture.numberOfTapsRequired = 1;
        [self.avatarPlaceholderView addGestureRecognizer:singleTapGesture];

    }
    
    NSString * filePath = [[NSBundle mainBundle] pathForResource:player.avatar.imageFilename ofType:@"jpg"];
    self.avatarImageview.image = [UIImage imageWithContentsOfFile:filePath];
    self.avatarLabel.text = player.name;

    
}

- (void) setupCategoryPlaceholderView {
    self.categoryPlaceholderView.backgroundColor = self.view.backgroundColor;
    self.categoryPlaceholderView.clipsToBounds = YES;
    
    if ([[[ARTUserInfo sharedInstance] getVisualTheme] isEqual:@"white"]) {
        self.categoryPlaceholderView.layer.borderColor = [UIColor blackColor].CGColor;
        
        
    } else {
        self.categoryPlaceholderView.layer.borderColor = [UIColor blueNavBarColor].CGColor;
        
    }
}


- (NSMutableArray *)getDeckSections {
    
    NSMutableArray *deckSections = [NSMutableArray new];
    
    NSMutableArray *unsortedDecks = self.currentGame.decks;
    NSSortDescriptor *dateDescriptor = [[NSSortDescriptor alloc] initWithKey:@"dateLastPlayed" ascending:NO];
    NSSortDescriptor *gameOverDescriptor = [[NSSortDescriptor alloc] initWithKey:@"gameOver" ascending:YES];
    NSSortDescriptor *deckEnabledDescriptor = [[NSSortDescriptor alloc] initWithKey:@"isEnabled" ascending:NO];
    
    NSMutableArray *sortDescriptors = [NSMutableArray arrayWithObjects:gameOverDescriptor, deckEnabledDescriptor, dateDescriptor,nil];
    NSMutableArray *sortedDecks = [[unsortedDecks sortedArrayUsingDescriptors:sortDescriptors] mutableCopy];
    
    for (NSInteger i = 0; i < sortedDecks.count; i++) {
        ARTDeck *deck = sortedDecks[i];
        
        NSMutableArray *deckSection = [self getDeckSectionForSeries:deck.series fromDeckSections:deckSections];
        [deckSection addObject:deck];
    }
    
    return deckSections;
}

- (NSMutableArray *) getDeckSectionForSeries:(NSString *)series fromDeckSections:(NSMutableArray *)deckSections {
    
    for (NSInteger i = 0; i < deckSections.count; i++) {
        if ([self deckSection:deckSections[i] HasSeries:series])
        {
            return deckSections[i];
        }
    }
    
    NSMutableArray *newDeckSection = [NSMutableArray new];
    [deckSections addObject:newDeckSection];
    
    return newDeckSection;
}

- (BOOL) deckSection:(NSMutableArray *)deckSection HasSeries:(NSString *)series {
    
    ARTDeck *firstDeckInSection = deckSection[0];
    if ([series isEqual:firstDeckInSection.series]) {
        return YES;
    }
    else {
        return NO;
    }
    
}


- (void)setupCollectionview {
    
    self.selectedDeck = nil;
    self.selectedCard = nil;
    
    self.collectionView.allowsMultipleSelection = NO;
    
    self.collectionView.delegate = self;
    self.collectionView.dataSource = self;
    
    [self.collectionView registerClass:[ARTCategoryCollectionReusableViewHeader class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"HeaderView"];

    
    ARTCategoryViewFlowLayout *customLayout = [[ARTCategoryViewFlowLayout alloc]init];
    [self.collectionView setCollectionViewLayout:customLayout animated:YES];
    [self.collectionView.collectionViewLayout registerClass:[ARTCollectionSectionDecorationView class] forDecorationViewOfKind:@"Section"];
    [customLayout invalidateLayout];
    
    self.collectionView.showsVerticalScrollIndicator = NO;
    if ([[[ARTUserInfo sharedInstance] getVisualTheme] isEqual:@"white"]) {
        self.collectionView.indicatorStyle = UIScrollViewIndicatorStyleBlack;
        self.collectionView.backgroundColor = [UIColor lightBackgroundColor];
        
        
    } else {
        self.collectionView.indicatorStyle = UIScrollViewIndicatorStyleWhite;
        self.collectionView.backgroundColor = [UIColor darkBackgroundColor];
        
    }
    
    self.collectionView.opaque = YES;
    
}


- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    NSMutableArray *decks = _deckSections[section];
    
    return decks.count;
}

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    
    return _deckSections.count;
}


- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    
    static NSString *identifier = @"CollectionCell";
    ARTCategoryCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:identifier forIndexPath:indexPath];
    
    ARTDeck *deck = _deckSections[indexPath.section][indexPath.row];
    
    cell.deck = deck;
    cell.topCard = deck.nextCard;
    cell.delegate = self;
    
    [cell configureCell];
    
    return cell;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    CGFloat spacing;
    if (IS_IPAD) {
        spacing = collectionCellSpacingIPad;
    }
    else {
        spacing = collectionCellSpacing;
    }
    
    // Adjust cell size for orientation
    CGFloat width = self.collectionView.bounds.size.width;
    CGFloat imageWidth = (width - ( 2 * rightLeftEdgeInsets) - (spacing * (numberOfColumnsIphone - 1))) / numberOfColumnsIphone;
    
    imageWidth = floorf(imageWidth);
    
    CGFloat verticalAdj;
    
    if (numberOfColumnsIphone == 2) {
        if (IS_IPAD) {
            verticalAdj = 10.0;
        } else {
            verticalAdj = 36.0;
        }
    }
    else {
        if (IS_IPAD) {
            verticalAdj = 64.0;
        } else {
            verticalAdj = 64.0;
        }
    }
    
    return CGSizeMake(imageWidth, imageWidth + verticalAdj);
    
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section {
    
    CGFloat spacing;
    if (IS_IPAD) {
        spacing = collectionCellSpacingIPad;
    }
    else {
        spacing = collectionCellSpacing;
    }
    
    return spacing;
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section {
    
    CGFloat spacing;
    if (IS_IPAD) {
        spacing = minLineSpacingIpad;
    }
    else {
        spacing = minLineSpacing;
    }
    
    return spacing;
}

- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout insetForSectionAtIndex:(NSInteger)section {
    
    UIEdgeInsets edges = UIEdgeInsetsMake(topEdgeInsets, rightLeftEdgeInsets, bottomEdgeInsets, rightLeftEdgeInsets);
    return edges;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section {
    
    if (IS_OldIphone) {
        return CGSizeMake(self.collectionView.bounds.size.width, categoryHeaderHeightOldIphone);
    } else if (IS_IPHONE_5) {
        return CGSizeMake(self.collectionView.bounds.size.width, categoryHeaderHeightIphone5);
    } else if (IS_IPAD) {
        return CGSizeMake(self.collectionView.bounds.size.width, categoryHeaderHeightIpad);
    } else if (IS_IPHONE_6) {
        return CGSizeMake(self.collectionView.bounds.size.width, categoryHeaderHeightIphone6);
    } else if (IS_IPHONE_6Plus) {
        return CGSizeMake(self.collectionView.bounds.size.width, categoryHeaderHeightIphone6);
    }
    
    return CGSizeMake(0.0, 0.0);
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout referenceSizeForFooterInSection:(NSInteger)section {
    return CGSizeMake(0.0, 0.0);
}

- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath
{
    UICollectionReusableView *reusableview;
    
    if (kind == UICollectionElementKindSectionHeader) {
        ARTCategoryCollectionReusableViewHeader *headerView = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"HeaderView" forIndexPath:indexPath];

        
        headerView.headerTitle = [self startingSectionHeaderStringForIndexPath:indexPath];
        
        [headerView configureView];
        
        if (!self.visibleHeaderViews) {
            self.visibleHeaderViews = [NSMutableArray new];
        }
        [self.visibleHeaderViews addObject:headerView];
        
        reusableview = headerView;
    }
    
    return reusableview;
}

- (void)collectionView:(UICollectionView *)collectionView didEndDisplayingSupplementaryView:(UICollectionReusableView *)view forElementOfKind:(NSString *)elementKind atIndexPath:(NSIndexPath *)indexPath {

    [self.visibleHeaderViews removeObject:view];

}

- (NSString *)startingSectionHeaderStringForIndexPath:(NSIndexPath *)indexPath {

        ARTDeck *firstDeckInSection = _deckSections[indexPath.section][0];
        return firstDeckInSection.series;

}


- (BOOL)collectionView:(UICollectionView *)collectionView shouldSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    
    ARTCategoryCollectionViewCell *cell = (ARTCategoryCollectionViewCell *)[self.collectionView cellForItemAtIndexPath:indexPath];
    
    if ( ([self.tappedIndexPath isEqual:indexPath] || !self.tappedIndexPath ) && cell.isOKToRotate) {
        return  YES;
    }
    
    return NO;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    
    
    self.backButton.userInteractionEnabled = NO;
     //   [self handleEnteredBackground];
        ARTCategoryCollectionViewCell *cell = (ARTCategoryCollectionViewCell *)[self.collectionView cellForItemAtIndexPath:indexPath];
    cell.isOKToRotate = NO;
        self.selectedDeck = cell.deck;
        self.selectedCard = cell.topCard;
        self.tappedIndexPath = indexPath;

        if (!self.selectedDeck.isEnabled) {
            self.backButton.userInteractionEnabled = YES;
            
            [self.collectionView deselectItemAtIndexPath:self.tappedIndexPath animated:YES];
            
            __weak ARTCategoryViewController *wself = self;
            
            NSString *title = [NSString stringWithFormat:@"%@\nFree Trivia Completed",self.selectedDeck.uniqueID];
            NSString *message = [NSString stringWithFormat:@"Fear not! More %@ trivia is available!",self.selectedDeck.uniqueID];

            
            self.deckNotEnabledAlertView = [[URBAlertView alloc] initWithTitle:title message:message cancelButtonTitle:@"Cancel" otherButtonTitles:@"More Trivia!", nil];
            
            [self.deckNotEnabledAlertView addAlertImage:[[ARTImageHelper sharedInstance] getLockImage]  imageScale:0.7 backgroundColor:[UIColor darkBlueColor] captionText:nil];
            
            [self.deckNotEnabledAlertView setHandlerBlock:^(NSInteger buttonIndex, URBAlertView *alertView) {
                __strong ARTCategoryViewController *sself = wself;
                
                [sself.deckNotEnabledAlertView hideWithCompletionBlock:^{
                    
                   // sself.collectionView.userInteractionEnabled = YES;
                    [sself.collectionView deselectItemAtIndexPath:sself.tappedIndexPath animated:YES];
                    sself.tappedIndexPath = nil;
                    cell.isOKToRotate = YES;
                    
                    if (buttonIndex == 1) {
                        
                        sself.isCardBackButtonPressed = NO;
                        sself.isCardContinueButtonPressed = NO;
                        sself.isCardNextCardButtonPressed = NO;
                        sself.isNonCardButtonPressed = YES;
                        
                        [sself performSegueWithIdentifier:@"StoreSegue" sender:sself];
                        
                    } else if (buttonIndex == 0) {
                        [sself handleDidBecomeActive];
                    }
                }];
            }];
            [self.deckNotEnabledAlertView showWithAnimation:URBAlertAnimationDefault ];
            
            
        }
        else if (self.selectedCard) {
            
            self.isOKToAnimateImageFlips = NO;
            [self cancelAnimateCardTimer];
            
            [self playNextCardInTappedCell];
        } else {
            self.backButton.userInteractionEnabled = YES;

            
            [self.collectionView deselectItemAtIndexPath:self.tappedIndexPath animated:YES];

            
            self.isOKToAnimateImageFlips = NO;
            [self cancelAnimateCardTimer];
            
            [self showScoreForTappedIndexPath];
            
            cell.isOKToRotate = YES;
        }
    

}



- (void) showScoreForTappedIndexPath {
    
    UIStoryboard *storyboard;
    if (IS_IPAD) {
        storyboard = [UIStoryboard storyboardWithName:@"Storyboard" bundle:nil];
        
    } else {
        storyboard = [UIStoryboard storyboardWithName:@"Main_iPhone" bundle:nil];
        
    }
    ARTScoreViewController *vc = (ARTScoreViewController *)[storyboard instantiateViewControllerWithIdentifier:@"ScoreViewController"];
    vc.deck = self.selectedDeck;
    //vc.backgroundImage = [self pb_takeSnapshot];
    vc.delegate = self;
    if (vc.deck.isGameOver) {
        
        ARTCategoryCollectionViewCell *cell = (ARTCategoryCollectionViewCell *)[self.collectionView cellForItemAtIndexPath:self.tappedIndexPath];

            UIGraphicsBeginImageContextWithOptions(cell.imageViewHolder.bounds.size, NO, 0.0);
            
            [cell.imageViewHolder drawViewHierarchyInRect:cell.imageViewHolder.bounds afterScreenUpdates:YES];
            
            // old style [self.layer renderInContext:UIGraphicsGetCurrentContext()];
            
            UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
            UIGraphicsEndImageContext();
        
       // CGSize newSize = CGSizeMake(400.0, 400.0);
        
        //UIImage *scaledImage = [UIImage imageWithImage:image scaledToSize:newSize];
        
        NSData *imageData = UIImageJPEGRepresentation(image, 0.0);
       // scaledImage = nil;
        UIImage *processedImage = [UIImage imageWithData:imageData];
       

        
        vc.awardImage = processedImage;
    }
    
    vc.transitioningDelegate = self;
    vc.modalPresentationStyle = UIModalPresentationCustom;
    
    
    
    [self presentViewController:vc animated:YES completion:^{
        //self.collectionView.userInteractionEnabled = YES;
        [self.collectionView deselectItemAtIndexPath:self.tappedIndexPath animated:YES];
        self.tappedIndexPath = nil;
    }];
}

- (void)animateHeaderView {
    
    if (_isOKToAnimateHeaderView) {
        
        [self animateHeaderLabel];
        [self resetAnimateHeaderTimer];
    }
}

- (void)animateHeaderViewWithDelay:(CGFloat)delay {
    
    
    [self cancelAnimateHeaderTimer];
    
    self.headerAnimationTimer = [NSTimer scheduledTimerWithTimeInterval:delay
                                                           target:self
                                                         selector:@selector(animateHeaderView)
                                                         userInfo:nil
                                                          repeats:NO];
}

- (void)resetAnimateHeaderTimer {
    [self cancelAnimateHeaderTimer];
    
    self.headerAnimationTimer = [NSTimer scheduledTimerWithTimeInterval:headerAnimationDelay
                                                           target:self
                                                         selector:@selector(animateHeaderView)
                                                         userInfo:nil
                                                          repeats:NO];
    
    [[NSRunLoop currentRunLoop] addTimer:self.headerAnimationTimer
                                 forMode:NSRunLoopCommonModes];
}

- (void)cancelAnimateHeaderTimer {
    if (self.headerAnimationTimer) {
        [self.headerAnimationTimer invalidate];
        self.headerAnimationTimer = nil;
    }
    
}


- (void)animateHeaderLabel {
    
    NSIndexPath *indexPath = [NSIndexPath indexPathForItem:0 inSection:0];
    
    if (self.visibleHeaderViews.count > 0) {
    ARTCategoryCollectionReusableViewHeader *headerView = (ARTCategoryCollectionReusableViewHeader *)self.visibleHeaderViews[0];

        [headerView animateHeader];
        
    }

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
    
    NSString *header1 = @"Trivia Topics";
    NSString *body1 = @"Each spinning icon on the this screen represents a trivia topic.\n\nThe percentages under each icon indicate your progress.\n\nNew trivia topics will be added over time so check back frequently!";
    NSMutableDictionary *dict1 = [NSMutableDictionary new];
    [dict1 setObject:header1 forKey:@"headerText"];
    [dict1 setObject:body1 forKey:@"bodyText"];
    
    NSMutableArray *arrayOfMessages = [NSMutableArray arrayWithObjects:dict1, nil];
    
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
        
        self.view.userInteractionEnabled = YES; //after tutorial is shown, allow user interaction
        
        
    }];
}

- (void)showOverlay:(BOOL)show {
    
    if (show) {
        if (!self.overlay) {
            self.overlay = [[UIView alloc] initWithFrame:self.view.bounds];
            self.overlay.opaque = YES;
            
            self.overlay.backgroundColor = [UIColor colorWithRed: 0 green: 0 blue: 0 alpha: 0.8];
            
            [self.view addSubview:self.overlay];
        }
        
        
    } else {
        
        if (self.overlay) {
            [self.overlay removeFromSuperview];
            self.overlay = nil;
        }
        
    }
}

- (UIImage *)pb_takeSnapshot {
    UIGraphicsBeginImageContextWithOptions(self.view.bounds.size, NO, [UIScreen mainScreen].scale);
    
    [self.view drawViewHierarchyInRect:self.view.bounds afterScreenUpdates:YES];
    
    // old style [self.layer renderInContext:UIGraphicsGetCurrentContext()];
    
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return image;
}

- (UIView *)pb_takeSnapshotView {
    //UIGraphicsBeginImageContextWithOptions(self.view.bounds.size, NO, [UIScreen mainScreen].scale);
    
    UIView *snapshot = [self.view snapshotViewAfterScreenUpdates:YES];
    
    // old style [self.layer renderInContext:UIGraphicsGetCurrentContext()];
    
    //UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    //UIGraphicsEndImageContext();
    return snapshot;
}

- (void)animateCellImageFlips{
    
    float delay = 0.01;
    
    NSInteger sectionCount = _deckSections.count;
    
    for (NSInteger i = 0; i < sectionCount; i ++) {
        NSMutableArray *deckSection = _deckSections[i];
        
        NSInteger deckCount = deckSection.count;
        for (NSInteger j = 0; j < deckCount; j++) {
            
            NSIndexPath *indexPath = [NSIndexPath indexPathForItem:j inSection:i];
            
            ARTCategoryCollectionViewCell *cell = (ARTCategoryCollectionViewCell *)[self.collectionView cellForItemAtIndexPath:indexPath];
            
            if (!self.tappedIndexPath && cell.isOKToRotate) {
                [cell performSelector:@selector(startAnimateImageFlip) withObject:nil afterDelay:delay inModes:[NSArray arrayWithObject:NSRunLoopCommonModes]];
            }
            
            delay += roundImageFlipDelay;
        }
        
    }

    
}


- (void)resetCellImageFlipsExceptForIndexPath:(NSIndexPath *)excludedIndexPath {
    
    NSInteger sectionCount = _deckSections.count;
    
    for (NSInteger i = 0; i < sectionCount; i ++) {
        NSMutableArray *deckSection = _deckSections[i];
        
        NSInteger deckCount = deckSection.count;
        for (NSInteger j = 0; j < deckCount; j++) {
            
            NSIndexPath *indexPath = [NSIndexPath indexPathForItem:j inSection:i];
            
            ARTCategoryCollectionViewCell *cell = (ARTCategoryCollectionViewCell *)[self.collectionView cellForItemAtIndexPath:indexPath];
            
            
            //its oke to set ok to set isoktorotate since this is only called after the device is woken up
            cell.isOKToRotate = YES;
            [cell resetImageFlip];

        }
        
    }

}

- (void)animateTappedCardCornerRadiusDissappearWithDictionary:(NSDictionary *)dict {
    
    ARTCategoryCollectionViewCell *cell = [dict objectForKey:@"cell"];
    UIView *imageViewHolder = cell.imageViewHolder;
    UIImageView *imageView = cell.cardImageView;
    ARTCard *topCard = cell.topCard;
    
    CGFloat increment = [[dict objectForKey:@"increment"] floatValue];
    CGFloat incrementRate = [[dict objectForKey:@"incrementRate"] floatValue];
    CGFloat frameIncrement = [[dict objectForKey:@"frameIncrement"] floatValue];
    NSString *selectorString = [dict objectForKey:@"selector"];
    
    if (imageViewHolder.layer.cornerRadius > 0.0) {
        imageViewHolder.layer.cornerRadius = MAX(imageViewHolder.layer.cornerRadius - increment, 0.0);
        
        CGFloat x = imageViewHolder.frame.origin.x;
        CGFloat y = imageViewHolder.frame.origin.y;
        CGFloat width = imageViewHolder.frame.size.width;
        CGFloat height = imageViewHolder.frame.size.height;
        
        if ([topCard.orientation isEqualToString:@"portrait"]) {
            imageViewHolder.frame = CGRectMake(x + frameIncrement, y, width - frameIncrement*2.0, height);
        } else {
            imageViewHolder.frame = CGRectMake(x, y + frameIncrement, width, height  - frameIncrement*2.0);
        }
        
        imageView.center = CGPointMake(imageViewHolder.bounds.size.width / 2.0, imageViewHolder.bounds.size.height / 2.0);
        
        [self performSelector:@selector(animateTappedCardCornerRadiusDissappearWithDictionary:) withObject:dict afterDelay:incrementRate inModes:[NSArray arrayWithObject:NSRunLoopCommonModes]];
        
    }
    else {
        SEL nextSelector = NSSelectorFromString(selectorString);
        [self performSelector:nextSelector withObject:cell afterDelay:0.0 inModes:[NSArray arrayWithObject:NSRunLoopCommonModes]];
    }
    
}

- (void)animateTappedCardCornerRadiusAppearWithDictionary:(NSDictionary *)dict {
    
    ARTCategoryCollectionViewCell *cell = [dict objectForKey:@"cell"];
    UIView *imageViewHolder = cell.imageViewHolder;
    UIImageView *imageView = cell.cardImageView;
    ARTCard *topCard = cell.topCard;
    
    CGFloat increment = [[dict objectForKey:@"increment"] floatValue];
    CGFloat incrementRate = [[dict objectForKey:@"incrementRate"] floatValue];
    CGFloat frameIncrement = [[dict objectForKey:@"frameIncrement"] floatValue];
    

    imageViewHolder.layer.transform = CATransform3DIdentity;
    
    if (imageViewHolder.layer.cornerRadius < MAX(imageViewHolder.frame.size.height,imageViewHolder.frame.size.width) / 2.0 - 0.01) {
        imageViewHolder.layer.cornerRadius = MIN(imageViewHolder.layer.cornerRadius + increment, MAX(imageViewHolder.frame.size.height,imageViewHolder.frame.size.width) / 2.0);
        
        CGFloat x = imageViewHolder.frame.origin.x;
        CGFloat y = imageViewHolder.frame.origin.y;
        CGFloat width = imageViewHolder.frame.size.width;
        CGFloat height = imageViewHolder.frame.size.height;
        
        if ([topCard.orientation isEqualToString:@"portrait"]) {
            imageViewHolder.frame = CGRectMake(x - frameIncrement, y, width + frameIncrement*2.0, height);
        } else {
            imageViewHolder.frame = CGRectMake(x, y - frameIncrement, width, height  + frameIncrement*2.0);
        }
        
        imageView.center = CGPointMake(imageViewHolder.bounds.size.width / 2.0, imageViewHolder.bounds.size.height / 2.0);
        
        [self performSelector:@selector(animateTappedCardCornerRadiusAppearWithDictionary:) withObject:dict afterDelay:incrementRate inModes:[NSArray arrayWithObject:NSRunLoopCommonModes]];
        
    }
    else {
        self.tappedIndexPath = nil;
    }
    
}

- (void)animateImageFlipForCell:(ARTCategoryCollectionViewCell *)cell{
    
    
    UIView *imageViewHolder = cell.imageViewHolder;
    
    [UIView animateWithDuration:roundImageFlipDuration/2.
                          delay:0
                        options:UIViewAnimationOptionCurveLinear |UIViewAnimationOptionAllowAnimatedContent
                     animations:^{
                         imageViewHolder.layer.transform = CATransform3DRotate(imageViewHolder.layer.transform,-M_PI*.995,0.0,1.0,0.0);
                     }
                     completion:^(BOOL finished) {
                         if (finished) {
                             [UIView animateWithDuration:roundImageFlipDuration/2.
                                                   delay:0
                                                 options:UIViewAnimationOptionCurveLinear |UIViewAnimationOptionAllowAnimatedContent
                                              animations:^{
                                                  imageViewHolder.layer.transform = CATransform3DRotate(imageViewHolder.layer.transform,-M_PI*.995,0.0,1.0,0.0);
                                              }
                                              completion:^(BOOL finished) {
                                                  if (finished) {
                                                      imageViewHolder.layer.transform = CATransform3DIdentity;
                                                      [self animateCardToFillScreenPart2:cell];                                                  }
                                                  
                                              }];
                         }
                         
                     }];
    
}

- (void)animateCardToFillScreenPart1:(ARTCategoryCollectionViewCell *)cell {
    
    UIView *imageViewHolder = cell.imageViewHolder;
    imageViewHolder.layer.transform = CATransform3DIdentity;
    
    [self animateImageFlipForCell:cell];

}

- (void)animateCardToFillScreenPart2:(ARTCategoryCollectionViewCell *)cell {
    
    
    UIView *imageViewHolder = cell.imageViewHolder;
    ARTCard *topCard = cell.topCard;
    
    if (imageViewHolder.layer.cornerRadius > 0.002) {
        
        CGFloat totalAniamtionDuration = 0.05;
        CGFloat incrementRate = 0.01;
        CGFloat increment = imageViewHolder.layer.cornerRadius / (totalAniamtionDuration/incrementRate);
        
        CGRect finalFrame = [self frameThatFitsImageFrame:imageViewHolder.frame withOrientation:topCard.orientation];
        CGFloat frameDifference = MAX(imageViewHolder.frame.size.width - finalFrame.size.width, imageViewHolder.frame.size.height - finalFrame.size.height)/2.0;
        CGFloat frameIncrement = frameDifference / (totalAniamtionDuration/incrementRate);
        
        NSDictionary *dict = @{@"cell":cell,@"incrementRate":[NSNumber numberWithFloat:incrementRate],@"increment":[NSNumber numberWithFloat:increment],@"frameIncrement":[NSNumber numberWithFloat:frameIncrement],@"selector":NSStringFromSelector(@selector(animateCardToFillScreenPart2:))};
        
        [self animateTappedCardCornerRadiusDissappearWithDictionary:dict];
        
    }
    
    else {
        
        [self animateCardToFillScreenPart3:cell];
        
    }
    
}


- (void)animateCardToFillScreenPart3:(ARTCategoryCollectionViewCell *)cell{
    
    //self.collectionView.userInteractionEnabled = NO;
    
    UIView *imageViewHolder = cell.imageViewHolder;
    UIImageView *imageView = cell.cardImageView;
    ARTCard *topCard = cell.topCard;
    
    
    ARTCard *card = topCard;
    
    self.screenView = [self pb_takeSnapshotView];
    
    
    CGFloat cardViewWidth;
    CGFloat cardViewHeight;
    CGFloat cardViewX;
    CGFloat cardViewY;
    
    cardViewWidth = imageView.frame.size.width;
    cardViewHeight = imageView.frame.size.height;
    cardViewX = cell.frame.origin.x + imageView.frame.origin.x + imageViewHolder.frame.origin.x + self.categoryPlaceholderView.frame.origin.x +self.collectionView.frame.origin.x - self.collectionView.bounds.origin.x;
    cardViewY = cell.frame.origin.y + imageView.frame.origin.y + imageViewHolder.frame.origin.y + self.categoryPlaceholderView.frame.origin.y + self.collectionView.frame.origin.y - self.collectionView.bounds.origin.y;
    
    CGRect mainViewFrame = CGRectMake(cardViewX, cardViewY, cardViewWidth, cardViewHeight);
    
    self.tappedImageview = [[UIImageView alloc] initWithFrame:mainViewFrame];
    self.tappedImageview.image = [[ARTImageHelper sharedInstance] getLQImageWithFileName:card.frontFilename ];
    self.tappedImageview.contentMode = UIViewContentModeScaleAspectFit;
    self.tappedImageview.opaque = YES;
    
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
    
    CGFloat cardViewXOffset = cardOverlayXOffset;
    CGFloat cardViewYOffset = cardOverlayYOffset;
    
    cardViewX = cardViewXOffset;
    cardViewY = cardViewYOffset;
    cardViewWidth = self.view.bounds.size.width - cardViewX * 2;
    cardViewHeight = self.view.bounds.size.height - cardViewY * 2 - verticalAdjustment;
    
    CGRect nextFrame = CGRectMake(cardViewX, cardViewY, cardViewWidth, cardViewHeight);
    
    CGAffineTransform trans = self.tappedImageview.transform;
    
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
    
    [self.view addSubview:self.screenView];
    self.collectionView.hidden = YES;

   // [self.view bringSubviewToFront:self.avatarPlaceholderView];
   // [self.view insertSubview:self.topView belowSubview:self.avatarPlaceholderView];
    [self.view bringSubviewToFront:self.topView];
    [self.view insertSubview:self.logoImageView aboveSubview:self.topView];
    [self.view insertSubview:self.backButton aboveSubview:self.topView];

    [self.view insertSubview:self.tappedImageview belowSubview:self.topView];
    

    
    
    UIView *blackOutView = [[UIView alloc] initWithFrame:self.tappedImageview.frame];
    blackOutView.backgroundColor = cell.backgroundColor;
    blackOutView.opaque = YES;
    [self.screenView addSubview:blackOutView];
    
    imageView.alpha = 0.0;
    imageViewHolder.alpha = 0.0;
    
    CGFloat duration;
    if (IS_IPAD) {
        duration = cardToScreenDurationIpad;
    } else {
        duration = cardToScreenDurationIphone;
    }
    
    // Transition using a image flip
    [UIView animateWithDuration:duration
                          delay:0.0
                        options:UIViewAnimationOptionCurveEaseInOut | UIViewAnimationOptionAllowAnimatedContent
                     animations:^{
                         self.tappedImageview.frame = nextFrame;
                         
                         self.tappedImageview.transform = trans;
                         
                         self.categoryPlaceholderView.alpha = 0.0;
                         self.screenView.alpha = 0.0;
                     }
                     completion:^(BOOL finished){
                         
                         self.backButton.userInteractionEnabled = YES;
                         
                         [self performSegueWithIdentifier:@"DailyCardSegue" sender:self];
                         
                         self.categoryPlaceholderView.alpha = 1.0;
                         imageView.alpha = 1.0;
                         self.collectionView.alpha = 1.0;
                         imageViewHolder.alpha = 1.0;
                         
                         
                         self.collectionView.hidden = NO;
                         [self.screenView removeFromSuperview];
                         self.screenView = nil;
                         
                         cell.isOKToRotate = YES;
                     }];
    
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

- (void)animateTappedCardOffScreen {
    
    self.view.userInteractionEnabled = NO;
    
    [self.collectionView selectItemAtIndexPath:self.tappedIndexPath animated:YES scrollPosition:UICollectionViewScrollPositionNone];


    ARTCard *lastCard = self.selectedCard;
    ARTCategoryCollectionViewCell *cell = (ARTCategoryCollectionViewCell *)[self.collectionView cellForItemAtIndexPath:self.tappedIndexPath];
    ARTDeck *deck = cell.deck;
    
    
    self.tappedImageview.clipsToBounds = NO;
    
    CGPoint nextCenter;
    CGFloat scaleRatio = 0.35;
    
    CGAffineTransform  trans;
    if (self.isShowingImageSide) {
        self.tappedImageview.image = [[ARTImageHelper sharedInstance] getLQImageWithFileName:lastCard.frontFilename ];
    }
    else {
        self.tappedImageview.image = [[ARTImageHelper sharedInstance] getLQImageWithFileName:lastCard.backFilename ];
        
    }
    
    trans = CGAffineTransformScale(self.tappedImageview.transform, scaleRatio, scaleRatio);
    nextCenter = CGPointMake(self.tappedImageview.center.x + self.view.bounds.size.width, self.tappedImageview.center.y);
    
    CGFloat duration;
    if (IS_IPAD) {
        duration = 0.55;
    } else {
        duration = 0.5;
    }
    
    [UIView animateWithDuration:duration
                          delay:0.02
     
                        options:UIViewAnimationOptionCurveEaseIn | UIViewAnimationOptionAllowAnimatedContent
                     animations:^{
                         
                         self.tappedImageview.center = nextCenter;
                         self.tappedImageview.transform = trans;
                         
                         
                     }
                     completion:^(BOOL finished){
                         
                         self.collectionView.hidden = NO;
                         [self.screenView removeFromSuperview];
                         self.screenView = nil;
                         
                         [self.tappedImageview removeFromSuperview];
                         self.tappedImageview = nil;
                         
                         
                         if (self.isCardNextCardButtonPressed) {
                             
                             if (deck.remainingCardCount > 0) {
                                 
                                 //[self playNextCardInTappedCell];
                                 [self collectionView:self.collectionView didSelectItemAtIndexPath:self.tappedIndexPath];
                                 
                             } else {
                                 [self.collectionView deselectItemAtIndexPath:self.tappedIndexPath animated:YES];
                                 self.tappedIndexPath = nil;
                                 
                             }
                         } else {
                             [self.collectionView deselectItemAtIndexPath:self.tappedIndexPath animated:YES];
                             self.tappedIndexPath = nil;
                             
                         }
                         
                         self.view.userInteractionEnabled = YES;
                         
                         
                     }];
    
    
}

- (void)animateTappedCardToPile{
    
    ARTCategoryCollectionViewCell *cell = (ARTCategoryCollectionViewCell *)[self.collectionView cellForItemAtIndexPath:self.tappedIndexPath];
    UIView *imageViewHolder = cell.imageViewHolder;
    UIImageView *imageView = cell.cardImageView;
    ARTCard *topCard = cell.topCard;
    
    imageViewHolder.alpha = 0.0;
    
    
    if (imageViewHolder.layer.cornerRadius > 0.002) {
        
        CGRect finalFrame = [self frameThatFitsImageFrame:imageViewHolder.frame withOrientation:topCard.orientation];
        CGFloat frameDifference = MAX(imageViewHolder.frame.size.width - finalFrame.size.width, imageViewHolder.frame.size.height - finalFrame.size.height)/2.0;
        CGFloat frameIncrement = frameDifference ;
        
        imageViewHolder.layer.cornerRadius = 0.;
        
        CGFloat x = imageViewHolder.frame.origin.x;
        CGFloat y = imageViewHolder.frame.origin.y;
        CGFloat width = imageViewHolder.frame.size.width;
        CGFloat height = imageViewHolder.frame.size.height;
        if ([topCard.orientation isEqualToString:@"portrait"]) {
            imageViewHolder.frame = CGRectMake(x + frameIncrement, y, width - frameIncrement*2.0, height);
        } else {
            imageViewHolder.frame = CGRectMake(x, y + frameIncrement, width, height  - frameIncrement*2.0);
        }
        
        imageView.center = CGPointMake(imageViewHolder.bounds.size.width / 2.0, imageViewHolder.bounds.size.height / 2.0);
                
        
    }
    
        self.tappedImageview.clipsToBounds = NO;
        
        
        CGFloat cardViewWidth;
        CGFloat cardViewHeight;
        CGFloat cardViewX;
        CGFloat cardViewY;
        
        cardViewWidth = imageView.frame.size.width;
        cardViewHeight = imageView.frame.size.height;
        cardViewX = cell.frame.origin.x + imageView.frame.origin.x + imageViewHolder.frame.origin.x + self.categoryPlaceholderView.frame.origin.x +self.collectionView.frame.origin.x - self.collectionView.bounds.origin.x;
        cardViewY = cell.frame.origin.y + imageView.frame.origin.y + imageViewHolder.frame.origin.y + self.categoryPlaceholderView.frame.origin.y + self.collectionView.frame.origin.y - self.collectionView.bounds.origin.y;
        
        
        CGRect nextFrame = CGRectMake(cardViewX, cardViewY, cardViewWidth, cardViewHeight);
        
        CGAffineTransform trans = CGAffineTransformIdentity;
        
        CGFloat zoomRatio;
        if (IS_OldIphone && [topCard.orientation isEqualToString:@"portrait"]) {
            zoomRatio = cardOverlayImageZoomIphone4Ratio;
        } else if (IS_IPAD && [topCard.orientation isEqualToString:@"portrait"]) {
            zoomRatio = cardOverlayImageZoomIpadRatioPortrait;
        } else if (IS_IPAD && [topCard.orientation isEqualToString:@"landscape"]) {
            zoomRatio = cardOverlayImageZoomIpadRatioLandscape;
        } else {
            zoomRatio = cardOverlayImageZoomIphone5Ratio;
        }
        
        trans = CGAffineTransformScale(trans, 1/zoomRatio, 1/zoomRatio);

        
        CGFloat duration;
        if (IS_IPAD) {
            duration = cardToScreenDurationIpad;
        } else {
            duration = cardToScreenDurationIphone;
        }
        
        // Transition using a image flip
        [UIView animateWithDuration:duration
                              delay:0.0
                            options:UIViewAnimationOptionCurveEaseInOut | UIViewAnimationOptionAllowAnimatedContent
                         animations:^{
                             
                             self.tappedImageview.frame = nextFrame;
                             
                             self.tappedImageview.transform = trans;
                             
                         }
                         completion:^(BOOL finished){
                             imageViewHolder.alpha = 1.0;
                             [self.tappedImageview removeFromSuperview];
                             self.tappedImageview = nil;
                             
                             
                             if (imageViewHolder.layer.cornerRadius < MAX(imageViewHolder.frame.size.height,imageViewHolder.frame.size.width) / 2.0) {
                                 
                                 CGFloat totalAniamtionDuration = 0.05;
                                 CGFloat incrementRate = 0.01;
                                 CGFloat increment = (MAX(imageViewHolder.frame.size.height,imageViewHolder.frame.size.width) / 2.0 - imageViewHolder.layer.cornerRadius ) / (totalAniamtionDuration/incrementRate);
                                 
                                 CGFloat frameDifference = ABS(imageViewHolder.frame.size.width -imageViewHolder.frame.size.height)/2.0;
                                 CGFloat frameIncrement = frameDifference / (totalAniamtionDuration/incrementRate);
                                 
                                 NSDictionary *dict = @{@"cell":cell,@"incrementRate":[NSNumber numberWithFloat:incrementRate],@"increment":[NSNumber numberWithFloat:increment],@"frameIncrement":[NSNumber numberWithFloat:frameIncrement]};
                                 
                                 [self animateTappedCardCornerRadiusAppearWithDictionary:dict];
                                 
                             }
                             
                             
                         }];
    

}

- (void)animateTappedCardToFade {
    
    ARTCategoryCollectionViewCell *cell = (ARTCategoryCollectionViewCell *)[self.collectionView cellForItemAtIndexPath:self.tappedIndexPath];
    UIView *imageViewHolder = cell.imageViewHolder;
    UIImageView *imageView = cell.cardImageView;
    ARTCard *topCard = cell.topCard;
    
    imageViewHolder.alpha = 1.0;
    self.collectionView.alpha = 0.0;
    
    if (self.isShowingImageSide) {
        self.tappedImageview.image = [[ARTImageHelper sharedInstance] getLQImageWithFileName:self.selectedCard.frontFilename ];
    }
    else {
        self.tappedImageview.image = [[ARTImageHelper sharedInstance] getLQImageWithFileName:self.selectedCard.backFilename ];
        
    }
    
    
    CGFloat duration;
    if (IS_IPAD) {
        duration = cardToScreenDurationIpad;
    } else {
        duration = cardToScreenDurationIphone;
    }
    
    // Transition using a image flip
    [UIView animateWithDuration:duration
                          delay:0.0
                        options:UIViewAnimationOptionCurveLinear | UIViewAnimationOptionAllowAnimatedContent
                     animations:^{
                         
                         self.tappedImageview.alpha = 0.0;
                         self.collectionView.alpha = 1.0;

                         
                     }
                     completion:^(BOOL finished){
                         [self.tappedImageview removeFromSuperview];
                         self.tappedImageview = nil;
                         
                         self.tappedIndexPath = nil;
                         
                     }];
    
    
}

- (void)playNextCardInTappedCell {
    
    ARTCategoryCollectionViewCell *cell = (ARTCategoryCollectionViewCell *)[self.collectionView cellForItemAtIndexPath:self.tappedIndexPath];
    
    if (self.isCardNextCardButtonPressed) {
        
        [self performSelector:@selector(animateCardToFillScreenPart1:) withObject:cell afterDelay:0.05 inModes:[NSArray arrayWithObject:NSRunLoopCommonModes]];
        
    } else {
        [self animateCardToFillScreenPart1:cell];
        
    }
}

- (void)backButtonTapped:(id)sender {
    
    self.backButton.userInteractionEnabled = NO;
    
    [self.navigationController popToRootViewControllerAnimated:YES];
}


- (id<UIViewControllerAnimatedTransitioning>)navigationController:(UINavigationController *)navigationController animationControllerForOperation:(UINavigationControllerOperation)operation fromViewController:(UIViewController *)fromVC toViewController:(UIViewController *)toVC {
    
    if (operation == UINavigationControllerOperationPush && [toVC isMemberOfClass:[ARTCardViewController class]]) {
        ARTNoTransitionAnimator *animator = [ARTNoTransitionAnimator new];
        return animator;
    }
    else if (operation == UINavigationControllerOperationPush && [toVC isMemberOfClass:[ARTDailyViewController class]]) {
        ARTNoTransitionAnimator *animator = [ARTNoTransitionAnimator new];
        return animator;
    }
    else if (operation == UINavigationControllerOperationPush && [toVC isMemberOfClass:[ARTNewGameViewController class]]){
        ARTSlideTransitionAnimator *animator = [ARTSlideTransitionAnimator new];
        animator.direction = @"up";
        return animator;    }
    else {
        return nil;
    }
}

- (id<UIViewControllerAnimatedTransitioning>)animationControllerForPresentedController:(UIViewController *)presented
                                                                  presentingController:(UIViewController *)presenting
                                                                      sourceController:(UIViewController *)source {
    
    ARTPopoverAnimator *animator = [ARTPopoverAnimator new];
    animator.onScreenIndicator = YES;
    animator.delegateController = self;
    animator.landscapeOKOnExit = NO;
    return animator;
}

- (id<UIViewControllerAnimatedTransitioning>)animationControllerForDismissedController:(UIViewController *)dismissed {
    ARTPopoverAnimator *animator = [ARTPopoverAnimator new];
    animator.onScreenIndicator = NO;
    animator.delegateController = self;
    animator.landscapeOKOnExit = NO;
    return animator;
}

- (void)handleEnteredBackground {
    NSLog(@"app did enter background");
    
    
    self.isOKToAnimateImageFlips = NO;
    [self cancelAnimateCardTimer];
}

- (void)handleDidBecomeActive {
    NSLog(@"app did become active");
    
    [self resetCellImageFlipsExceptForIndexPath:nil];
    
    self.isOKToAnimateImageFlips = YES;
    [self animateImageFlipWithDelay:1.5];
}

- (void)avatarTapDetected:(UIGestureRecognizer *)recognizer {
    NSLog(@"avatar tap detected");
    
    self.avatarLabel.textColor = [UIColor whiteColor];
    
    UIColor *color;
    if ([[[ARTUserInfo sharedInstance] getVisualTheme] isEqual:@"white"]) {
        color = [UIColor blueNavBarColor];
    } else {
        color = [UIColor blueNavBarColor];
    }
    
    [self.avatarLabel performSelector:@selector(setTextColor:) withObject:color afterDelay:0.1 inModes:[NSArray arrayWithObject:NSRunLoopCommonModes]];
    
    self.isCardBackButtonPressed = NO;
    self.isCardContinueButtonPressed = NO;
    self.isCardNextCardButtonPressed = NO;
    self.isNonCardButtonPressed = YES;
    
    [self performSegueWithIdentifier:@"PlayerSetup" sender:self];
    
    
}

- (void) dealloc {
    self.collectionView.delegate = nil;
    self.collectionView.dataSource = nil;
}

@end
