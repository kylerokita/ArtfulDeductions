//
//  ARTGalleryViewController.m
//  Artful Deductions
//
//  Created by Kyle Rokita on 8/9/14.
//  Copyright (c) 2014 Artful Deductions LLC. All rights reserved.
//

#import "ARTGalleryViewController.h"
#import "ARTDeck.h"
#import "ARTCard.h"
#import "UIImage+Customization.h"
#import "ARTNavigationController.h"
#import "ARTCollectionViewCell.h"
#import "ARTCollectionReusableViewHeader.h"
#import "ARTImageHelper.h"
#import "ARTGalleryCardViewController.h"
#import "ARTNoTransitionAnimator.h"
#import "ARTCollectionViewFlowLayout.h"
#import "ARTImageHelper.h"
#import "ARTAppDelegate.h"
#import "ARTUserInfo.h"
//#import "ARTIAPHelper.h"
#import "UIColor+Extensions.h"
#import "URBAlertView.h"
#import "ARTConstants.h"
#import "ARTTopView.h"
#import "UIButton+Extensions.h"
#import "MKStoreManager.h"
#import "ARTCardHelper.h"

CGFloat const collectionCellSpacing = 15.0;
CGFloat const collectionCellSpacingIPad = 20.0;
CGFloat const rightLeftEdgeInsets = 10.0;
CGFloat const topBottomEdgeInsets = 10.0;

@interface ARTGalleryViewController () {
    NSMutableArray *_sortedCardsFromSortedDecks;
    NSMutableArray *_sortedDecks;
    
    NSInteger _tappedSection;
    NSInteger _tappedRow;
    
}

@end

@implementation ARTGalleryViewController


- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.originalContentView.opaque = YES;
    
    self.numberOfColumns = 3;
    self.numberColumnsSegmentControl.selectedSegmentIndex = 1;
    
    self.automaticallyAdjustsScrollViewInsets = NO;
    
    self.backButton = [[UIButton alloc] backButtonWith:@"Menu" tintColor:[UIColor blueNavBarColor] target:self andAction:@selector(backButtonTapped:)];
    [self.originalContentView addSubview:self.backButton];
    
    if ([[[ARTUserInfo sharedInstance] getVisualTheme] isEqual:@"white"]) {
        self.originalContentView.backgroundColor = [UIColor lightBackgroundColor];//darkmode
    } else {
        self.originalContentView.backgroundColor = [UIColor darkBackgroundColor];//darkmode
    }

    
    [self sortDecks];
    
    [self setupCollectionview];
    
    self.imageQueue = [[NSOperationQueue alloc] init];
    self.imageQueue.maxConcurrentOperationCount = 3;
    
    [self setupLogoImageView];
    [self setupDetailView];

    self.detailHeightConstraintDefault = self.detailHeightConstraint.constant;
    self.detailHeightConstraint.constant = 0.0;
    self.detailView.hidden = YES;
    
    [self.originalContentView layoutIfNeeded];
    
    self.toolbarHeightConstraintDefault = self.toolbarHeightConstraint.constant;
    
    UIFont *font;
    if (IS_IPAD) {
        font = [UIFont fontWithName:@"HelveticaNeue" size:29.0];
    } else if (IS_IPHONE_5) {
        font = [UIFont fontWithName:@"HelveticaNeue" size:16.0];
    } else {
        font = [UIFont fontWithName:@"HelveticaNeue" size:19.0];
    }
    
    NSMutableAttributedString *attrString = [[NSMutableAttributedString alloc] initWithString:@"Options" attributes:@{NSFontAttributeName:font,NSForegroundColorAttributeName:[UIColor blueNavBarColor]}];
    
    self.optionButton = [[UIButton alloc] rightButtonWith:attrString tintColor:[UIColor blueNavBarColor] target:self andAction:@selector(detailBarButtonClicked:) withViewWidth:self.originalContentView.bounds.size.width ];

    [self.originalContentView addSubview:self.optionButton];
    
    NSMutableAttributedString *attrString2 = [[NSMutableAttributedString alloc] initWithString:@"Done" attributes:@{NSFontAttributeName:font,NSForegroundColorAttributeName:[UIColor blueNavBarColor]}];
    
    self.doneButton = [[UIButton alloc] rightButtonWith:attrString2 tintColor:[UIColor blueNavBarColor] target:self andAction:@selector(detailBarButtonClicked:) withViewWidth:self.originalContentView.bounds.size.width ];
    
    [self.originalContentView addSubview:self.doneButton];
    self.doneButton.alpha = 0.0;
    
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    self.navigationController.delegate = self;
    
    [(ARTNavigationController*)[self navigationController] setLandscapeOK:NO];
    [self.navigationController setNavigationBarHidden:YES animated:NO];
    
    [MKStoreManager enablePurchasedProducts];

    
    [self.collectionView reloadData];
    
    if ([MKStoreManager isFeaturePurchased:kProductClassicSeries] || [MKStoreManager isFeaturePurchased:kProductRemoveAds]) {
        self.canDisplayBannerAds = NO;
    } else {
        self.canDisplayBannerAds = YES;
    }
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];

    
}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    [super prepareForSegue:segue sender:sender];
    
    if ([segue.identifier isEqual:@"GalleryCardSegue"]) {
        ARTGalleryCardViewController *galleryCardViewController = (ARTGalleryCardViewController *)segue.destinationViewController;
        
        galleryCardViewController.sortedCardsFromSortedDecks= _sortedCardsFromSortedDecks;
        galleryCardViewController.sortedDecks = _sortedDecks;
        galleryCardViewController.cardInView = _sortedCardsFromSortedDecks[_tappedSection][_tappedRow];
        galleryCardViewController.deckIndex = _tappedSection;
        galleryCardViewController.cardIndex = _tappedRow;
    }
}

- (void)sortDecks {
    NSDictionary *decks = [[ARTCardHelper sharedInstance] getAllFreshDecks];
    NSArray *deckIDs = [decks allKeys];
    
    NSArray *sortedDeckIDs = [deckIDs sortedArrayUsingSelector:@selector(compare:)];
    
    NSMutableArray *deckIDsCopy = [NSMutableArray arrayWithArray:sortedDeckIDs];
    for (NSInteger i = 0; i < deckIDsCopy.count; i++) {
        NSString *deckKey = deckIDsCopy[i];
        if ([deckKey isEqual:kCategorySampler]) {
            [deckIDsCopy removeObject:deckKey];
        }
    }
    
    [deckIDsCopy insertObject:kCategorySampler atIndex:0];
    
    
    _sortedDecks = [NSMutableArray new];
    _sortedCardsFromSortedDecks = [NSMutableArray new];
    for (NSString *deckKey in deckIDsCopy) {
        ARTDeck *deck = decks[deckKey];
        [_sortedDecks addObject:deck];
        
        NSDictionary *cards = deck.cards;
        
        NSMutableArray *unsortedCards = [NSMutableArray new];
        ARTCard *finalCard;
        NSString *finalQuestionCategory = finalQuestionCategoryName;
        
        for (NSString *cardKey in cards) {
            ARTCard *card = cards[cardKey];
            
            if (![card.category isEqualToString:finalQuestionCategory]){
                [unsortedCards addObject:card];
            } else {
                finalCard = card;
            }
        }
        
        NSSortDescriptor *categoryDescriptor = [[NSSortDescriptor alloc] initWithKey:@"category" ascending:YES];
        NSSortDescriptor *categoryNumberDescriptor = [[NSSortDescriptor alloc] initWithKey:@"categoryNumber" ascending:YES];
        NSMutableArray *sortDescriptors = [NSMutableArray arrayWithObject:categoryDescriptor];
        [sortDescriptors addObject:categoryNumberDescriptor];
        
        NSMutableArray *sortedCards = [[unsortedCards sortedArrayUsingDescriptors:sortDescriptors] mutableCopy];
        
        if ([ARTCard isCardPlayed:finalCard.uniqueID]) { //only include final cards in gallery if played as they are a surprise
            [sortedCards addObject:finalCard];
        }

        [_sortedCardsFromSortedDecks addObject:sortedCards];
    }
    
}


- (void)willRotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation duration:(NSTimeInterval)duration {
    
    if (UIDeviceOrientationIsLandscape(toInterfaceOrientation)) {
        [self.navigationController setNavigationBarHidden:YES animated:NO];
        self.toolbarHeightConstraint.constant = 20.0;
        [self showDetailView:NO];
        self.doneButton.hidden = YES;
        self.optionButton.hidden = YES;
        self.logoImageView.hidden = YES;

    }
    else {
        [self.navigationController setNavigationBarHidden:NO animated:NO];
        self.toolbarHeightConstraint.constant = self.toolbarHeightConstraintDefault;
        self.logoImageView.hidden = NO;

    }
    
    
}

- (void)didRotateFromInterfaceOrientation:(UIInterfaceOrientation)fromInterfaceOrientation {
    [self numberColumnsSegmentChanged:nil];
}




- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)setupCollectionview {
    
    self.collectionView.backgroundColor = [UIColor clearColor];

    self.collectionView.delegate = self;
    self.collectionView.dataSource = self;
    [self.collectionView registerClass:[ARTCollectionReusableViewHeader class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"HeaderView"];
    
    //ARTCollectionViewFlowLayout *customLayout = [[ARTCollectionViewFlowLayout alloc]init];
    //[self.collectionView setCollectionViewLayout:customLayout animated:YES];
    
    if ([[[ARTUserInfo sharedInstance] getVisualTheme] isEqual:@"white"]) {
        self.collectionView.indicatorStyle = UIScrollViewIndicatorStyleBlack;
        
        
    } else {
        self.collectionView.indicatorStyle = UIScrollViewIndicatorStyleWhite;
        
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
    
    UILabel *label = [[UILabel alloc] initWithFrame:self.logoImageView.bounds];
    label.textAlignment = NSTextAlignmentCenter;
    label.text = @"Trivia Gallery";
    
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
    [self.originalContentView sendSubviewToBack:self.logoImageView];
    
    if (self.topView) {
        [self.topView removeFromSuperview];
        self.topView = nil;
    }
    
    self.topView = [[ARTTopView alloc] init];
    
    [self.originalContentView addSubview:self.topView];
    [self.originalContentView sendSubviewToBack:self.topView];

}

- (void)setupDetailView {
    self.detailView.backgroundColor = [UIColor clearColor];
    
    UIFont * font;
    if (IS_IPAD) {
        font = [UIFont fontWithName:@"HelveticaNeue" size:27];
    }
    else {
        font = [UIFont fontWithName:@"HelveticaNeue" size:17];
    }
    
    self.numberColumnsLabel.font = font;
    
    NSDictionary *attributes = [NSDictionary dictionaryWithObjectsAndKeys:
                                font, NSFontAttributeName, nil];
    [self.numberColumnsSegmentControl setTitleTextAttributes:attributes forState:UIControlStateNormal];

    
    self.numberColumnsSegmentControl.layer.cornerRadius = self.numberColumnsSegmentControl.bounds.size.height / 2.0;
    self.numberColumnsSegmentControl.clipsToBounds = YES;
    self.numberColumnsSegmentControl.layer.borderWidth = 1.0;
    
    if ([[[ARTUserInfo sharedInstance] getVisualTheme] isEqual:@"white"]) {
        self.numberColumnsLabel.textColor = [UIColor blackColor]; //lightmode
        self.numberColumnsSegmentControl.layer.borderColor = [UIColor blueButtonColor].CGColor;
        self.numberColumnsSegmentControl.tintColor = [UIColor blueButtonColor];
    } else {
        self.numberColumnsLabel.textColor = [UIColor blueNavBarColor]; //darkmode
        self.numberColumnsSegmentControl.layer.borderColor = [UIColor blueNavBarColor].CGColor;
        self.numberColumnsSegmentControl.tintColor = [UIColor blueNavBarColor];
    }
    
}


- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    NSArray *cardsInDeck = _sortedCardsFromSortedDecks[section];
    return cardsInDeck.count;
}

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    
    return _sortedCardsFromSortedDecks.count;
}


- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    
    static NSString *identifier = @"CollectionCell";
    ARTCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:identifier forIndexPath:indexPath];
    
    ARTCard *card = _sortedCardsFromSortedDecks[indexPath.section][indexPath.row];
    ARTDeck *deck = _sortedDecks[indexPath.section];

    cell.delegate = self;
    cell.card = card;
    cell.deck = deck;
    cell.indexPath = indexPath;
    
    [cell configureCell];
    
    /*__weak ARTGalleryViewController *weakSelf = self;
    NSBlockOperation *operation = [NSBlockOperation blockOperationWithBlock:^{
                                   
                                   dispatch_async(dispatch_get_main_queue(), ^{
        // then set them via the main queue if the cell is still visible.
        if ([weakSelf.collectionView.indexPathsForVisibleItems containsObject:indexPath]) {
            
            ARTCollectionViewCell *cell = (ARTCollectionViewCell *)[weakSelf.collectionView cellForItemAtIndexPath:indexPath];
            cell.delegate = self;
            cell.card = card;
            cell.deck = deck;
            cell.indexPath = indexPath;
        
            [cell configureCell];
        }
    });
                                   }];
    
    [self.imageQueue addOperation:operation];*/
    
    return cell;
}


- (id<UIViewControllerAnimatedTransitioning>)navigationController:(UINavigationController *)navigationController animationControllerForOperation:(UINavigationControllerOperation)operation fromViewController:(UIViewController *)fromVC toViewController:(UIViewController *)toVC {
    
    if ([toVC isMemberOfClass:[ARTGalleryCardViewController class]]) {
        ARTNoTransitionAnimator *animator = [ARTNoTransitionAnimator new];
        return animator;
    }
    else {
        return nil;
    }

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
    CGFloat imageWidth = (width - ( 2 * rightLeftEdgeInsets) - (spacing * (self.numberOfColumns - 1))) / self.numberOfColumns;
    
    imageWidth = floorf(imageWidth);

    return CGSizeMake(imageWidth, imageWidth);
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
        spacing = collectionCellSpacingIPad;
    }
    else {
        spacing = collectionCellSpacing;
    }
    
    return spacing;
}

- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout insetForSectionAtIndex:(NSInteger)section {
    
    UIEdgeInsets edges = UIEdgeInsetsMake(topBottomEdgeInsets, rightLeftEdgeInsets, topBottomEdgeInsets, rightLeftEdgeInsets);
    return edges;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section {
    
    if (IS_OldIphone) {
        return CGSizeMake(self.collectionView.bounds.size.width, 55.0);
    } else if (IS_IPHONE_5) {
        return CGSizeMake(self.collectionView.bounds.size.width, 60.0);
    } else if (IS_IPAD) {
        return CGSizeMake(self.collectionView.bounds.size.width, 80.0);
    } else if (IS_IPHONE_6) {
        return CGSizeMake(self.collectionView.bounds.size.width, 65.0);
    } else if (IS_IPHONE_6Plus) {
        return CGSizeMake(self.collectionView.bounds.size.width, 65.0);
    }
    
    return CGSizeMake(self.collectionView.bounds.size.width, 5.0);
    
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout referenceSizeForFooterInSection:(NSInteger)section {
    return CGSizeMake(0.0, 0.0);
}

- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath
{
    UICollectionReusableView *reusableview;
    
    if (kind == UICollectionElementKindSectionHeader) {
        ARTCollectionReusableViewHeader *headerView = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"HeaderView" forIndexPath:indexPath];
        
        
        
        NSInteger deckNumber = indexPath.section;
        ARTDeck *deck = (ARTDeck *)_sortedDecks[deckNumber];
        
        headerView.deck = deck;
        
        [headerView configureView];
        
        reusableview = headerView;
    }
    
    return reusableview;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    
    ARTCollectionViewCell *tappedCell = (ARTCollectionViewCell *)[self.collectionView cellForItemAtIndexPath:indexPath];
    
    _tappedSection = tappedCell.indexPath.section;
    _tappedRow = tappedCell.indexPath.item;
    
    
    ARTDeck *card = _sortedCardsFromSortedDecks[_tappedSection][_tappedRow];
    
    if (![ARTCard isCardPlayed:card.uniqueID]) {
        
        __weak ARTGalleryViewController *wself = self;
        
        self.cardNotPlayedAlertView = [[URBAlertView alloc] initWithTitle:@"Trivia Not Played" message:@"Trivia must be played in game before showing in the gallery.\n\nWe wouldn't want to ruin the surprise." cancelButtonTitle:@"Cancel" otherButtonTitles: nil];
        //self.deckNotEnabledAlertView.blurBackground = YES;
        
        [self.cardNotPlayedAlertView setHandlerBlock:^(NSInteger buttonIndex, URBAlertView *alertView) {
            __strong ARTGalleryViewController *sself = wself;
            
            [sself.cardNotPlayedAlertView hideWithCompletionBlock:^{
                NSLog(@"Cancel clicked");
                
            }];
        }];
        [self.cardNotPlayedAlertView showWithAnimation:URBAlertAnimationDefault];
        
    }
    else {
        [self animateTappedCardToFillScreenWithCell:tappedCell];
        
    }
}


- (IBAction)numberColumnsSegmentChanged:(id)sender {
    
    if (self.numberColumnsSegmentControl.selectedSegmentIndex == 0) {
        self.numberOfColumns = 2;
    } else if (self.numberColumnsSegmentControl.selectedSegmentIndex == 1) {
        self.numberOfColumns = 3;
    } else if (self.numberColumnsSegmentControl.selectedSegmentIndex == 2) {
        self.numberOfColumns = 4;
    }
    
    UIInterfaceOrientation screenOrientation = [[UIApplication sharedApplication] statusBarOrientation];
    NSInteger additionLandscapeCells = (UIDeviceOrientationIsLandscape(screenOrientation) ? self.numberOfColumns - 1 : 0);
    self.numberOfColumns = self.numberOfColumns + additionLandscapeCells;
    
    
    [self.collectionView performBatchUpdates:^(){
        [self.collectionView layoutIfNeeded];
                            }
                                  completion:^(BOOL finished){
                                      [self.collectionView reloadData];
                                  }];
    

}

- (IBAction)detailBarButtonClicked:(id)sender {
    BOOL startEdit = (sender == self.optionButton);
    
    [self showDetailView:startEdit];
    
    if (startEdit) {
        self.optionButton.alpha = 0.0;
        self.doneButton.alpha = 1.0;
    } else {
        self.doneButton.alpha = 0.0;
        self.optionButton.alpha = 1.0;
    }

}

- (void)showDetailView:(BOOL)indicator {
    
    if (indicator) self.detailView.hidden = NO;

    [self.originalContentView layoutIfNeeded];
    [UIView animateWithDuration:0.2
                          delay:0.0
                        options:UIViewAnimationOptionAllowAnimatedContent
                     animations:^{
                         self.detailHeightConstraint.constant = (indicator) ? self.detailHeightConstraintDefault : 0.0;
                         [self.originalContentView layoutIfNeeded]; // Called on parent view
                     } completion:^(BOOL finished) {
                         if (!indicator) self.detailView.hidden = YES;
                     }];
    

}


- (void)animateTappedCardToFillScreenWithCell:(ARTCollectionViewCell*)tappedCell {
    
    ARTCard *card = tappedCell.card;
    
    
    CGFloat cardViewWidth;
    CGFloat cardViewHeight;
    CGFloat cardViewX;
    CGFloat cardViewY;
    
        cardViewWidth = tappedCell.frame.size.width;
        cardViewHeight = tappedCell.frame.size.height;
        cardViewX = tappedCell.frame.origin.x + self.collectionView.frame.origin.x - self.collectionView.bounds.origin.x;
        cardViewY = tappedCell.frame.origin.y + self.collectionView.frame.origin.y - self.collectionView.bounds.origin.y;

    CGRect mainViewFrame = CGRectMake(cardViewX, cardViewY, cardViewWidth, cardViewHeight);

    UIImageView *imageView = [[UIImageView alloc] initWithFrame:mainViewFrame];
    imageView.image = [[ARTImageHelper sharedInstance] getLQImageWithFileName:card.frontFilename ];
    imageView.contentMode = UIViewContentModeScaleAspectFit;
    imageView.opaque = YES;
    

    [self.originalContentView addSubview:imageView];

    cardViewWidth = self.originalContentView.bounds.size.width;
    cardViewHeight = self.originalContentView.bounds.size.height - cardOverlayYOffset;
    cardViewX = self.originalContentView.bounds.origin.x;
    cardViewY = cardOverlayYOffset;
   
    CGRect nextFrame = CGRectMake(cardViewX, cardViewY, cardViewWidth, cardViewHeight);
    
    CGAffineTransform trans = imageView.transform;
    
    CGFloat zoomRatio;
    if (IS_OldIphone && [card.orientation isEqualToString:@"portrait"]) {
        zoomRatio = cardOverlayImageZoomIphone4Ratio;
    } else if (IS_IPHONE_5 && [card.orientation isEqualToString:@"portrait"]) {
        zoomRatio = cardOverlayImageZoomIphone5RatioPortrait;
    } else if (IS_IPAD && [card.orientation isEqualToString:@"portrait"]) {
        zoomRatio = cardOverlayImageZoomIpadRatioPortrait;
    } else if (IS_IPAD && [card.orientation isEqualToString:@"landscape"]) {
        zoomRatio = cardOverlayImageZoomIpadRatioLandscape;
    } else {
        zoomRatio = cardOverlayImageZoomIphoneDefaultRatio;
    }
    trans = CGAffineTransformScale(trans, 1.0/zoomRatio, 1.0/zoomRatio);
    
    [self showDetailView:NO];
    self.optionButton.alpha = 1.0;
    self.doneButton.alpha = 0.0;
    
    self.indexPathShowsNoImage = tappedCell.indexPath;
    tappedCell.alpha = 0.0;
    
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
                         
                         imageView.frame = nextFrame;
                         
                         imageView.transform = trans;
                         
                         self.collectionView.alpha = 0.0;
                     }
                     completion:^(BOOL finished){
                         
                         [self performSegueWithIdentifier:@"GalleryCardSegue" sender:self];
                         [imageView removeFromSuperview];
                         self.indexPathShowsNoImage = nil;
                         tappedCell.alpha = 1.0;
                         self.collectionView.alpha = 1.0;
                     }];
    
}

- (void)animateTappedCardToPileWithIndexPath:(NSIndexPath *)indexPath {
    
    [self.collectionView reloadData];
    [self.originalContentView layoutIfNeeded];
    
    NSArray *visibleCells = [self.collectionView indexPathsForVisibleItems];
    
    if (![visibleCells containsObject:indexPath]) {
        [self.collectionView scrollToItemAtIndexPath:indexPath atScrollPosition:UICollectionViewScrollPositionCenteredVertically animated:NO];
            [self.collectionView reloadData];
            [self.originalContentView layoutIfNeeded];
    }
    
    ARTCollectionViewCell *tappedCell = (ARTCollectionViewCell *)[self.collectionView cellForItemAtIndexPath:indexPath];
    [self.collectionView cellForItemAtIndexPath:indexPath].alpha = 0.0;
    self.indexPathShowsNoImage = indexPath;
    
    ARTCard *card = tappedCell.card;
    
    CGFloat cardViewWidth;
    CGFloat cardViewHeight;
    CGFloat cardViewX;
    CGFloat cardViewY;
    
    cardViewWidth = self.originalContentView.bounds.size.width;
    cardViewHeight = self.originalContentView.bounds.size.height - cardOverlayYOffset;
    cardViewX = self.originalContentView.bounds.origin.x;
    cardViewY = cardOverlayYOffset;
    
    CGRect mainViewFrame = CGRectMake(cardViewX, cardViewY, cardViewWidth, cardViewHeight);
    
    UIImageView *imageView = [[UIImageView alloc] initWithFrame:mainViewFrame];
    
    CGAffineTransform trans = imageView.transform;
    
    CGFloat zoomRatio;
    if (IS_OldIphone && [card.orientation isEqualToString:@"portrait"]) {
        zoomRatio = cardOverlayImageZoomIphone4Ratio;
    } else if (IS_IPHONE_5 && [card.orientation isEqualToString:@"portrait"]) {
        zoomRatio = cardOverlayImageZoomIphone5RatioPortrait;
    } else if (IS_IPAD && [card.orientation isEqualToString:@"portrait"]) {
        zoomRatio = cardOverlayImageZoomIpadRatioPortrait;
    } else if (IS_IPAD && [card.orientation isEqualToString:@"landscape"]) {
        zoomRatio = cardOverlayImageZoomIpadRatioLandscape;
    } else {
        zoomRatio = cardOverlayImageZoomIphoneDefaultRatio;
    }
    trans = CGAffineTransformScale(trans, 1.0/zoomRatio, 1.0/zoomRatio);
    imageView.transform = trans;
    
    imageView.image = [[ARTImageHelper sharedInstance] getLQImageWithFileName:card.frontFilename ];
    imageView.contentMode = UIViewContentModeScaleAspectFit;
    imageView.opaque = YES;
    
    
    [self.originalContentView addSubview:imageView];
    
    cardViewWidth = tappedCell.frame.size.width;
    cardViewHeight = tappedCell.frame.size.height;
    cardViewX = tappedCell.frame.origin.x + self.collectionView.frame.origin.x - self.collectionView.bounds.origin.x;
    cardViewY = tappedCell.frame.origin.y + self.collectionView.frame.origin.y - self.collectionView.bounds.origin.y;
    
    CGRect nextFrame = CGRectMake(cardViewX, cardViewY, cardViewWidth, cardViewHeight);
    
    trans = imageView.transform;
    if (IS_OldIphone && [card.orientation isEqualToString:@"portrait"]) {
        zoomRatio = cardOverlayImageZoomIphone4Ratio;
    } else if (IS_IPHONE_5 && [card.orientation isEqualToString:@"portrait"]) {
        zoomRatio = cardOverlayImageZoomIphone5RatioPortrait;
    } else if (IS_IPAD && [card.orientation isEqualToString:@"portrait"]) {
        zoomRatio = cardOverlayImageZoomIpadRatioPortrait;
    } else if (IS_IPAD && [card.orientation isEqualToString:@"landscape"]) {
        zoomRatio = cardOverlayImageZoomIpadRatioLandscape;
    } else {
        zoomRatio = cardOverlayImageZoomIphoneDefaultRatio;
    }
    
    trans = CGAffineTransformScale(trans, zoomRatio, zoomRatio);
    
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
                         
                         imageView.frame = nextFrame;
                         
                         //imageView.transform = trans;
                         
                     }
                     completion:^(BOOL finished){
                         self.indexPathShowsNoImage = nil;
                         [self.collectionView cellForItemAtIndexPath:indexPath].alpha = 1.0;
                         [imageView removeFromSuperview];
                     }];
    
}

- (void)backButtonTapped:(id)sender {
    
    self.backButton.userInteractionEnabled = NO;
    
    [self.navigationController popViewControllerAnimated:YES];
}

- (void) dealloc {
    self.collectionView.delegate = nil;
    self.collectionView.dataSource = nil;
}

@end
