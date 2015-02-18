//
//  ARTNewGameViewController.m
//  Artful Deductions
//
//  Created by Kyle Rokita on 8/4/14.
//  Copyright (c) 2014 Artful Deductions LLC. All rights reserved.
//

#import "ARTNewGameViewController.h"
#import "ARTNavigationController.h"
#import "ARTButton.h"
#import "ARTGame.h"
#import "ARTFadeTransitionAnimator.h"
#import "ARTPlayer.h"
#import "ARTUserInfo.h"
#import "ARTButton.h"
#import "UIColor+Extensions.h"
#import "URBAlertView.h"
#import "ARTConstants.h"
#import "ARTCategoryViewController.h"
#import "ARTNewPlayerCollectionViewCell.h"
#import "ARTNewPlayerCollectionReusableViewHeader.h"
#import "ARTAvatarHelper.h"
#import "ARTAvatar.h"
#import "UIButton+Extensions.h"
#import "ARTGame.h"
#import "ARTSlideTransitionAnimator.h"
#import "ARTStartViewController.h"
#import "ARTTopView.h"
#import "MKStoreManager.h"
#import "ARTImageHelper.h"

static NSString * const player1DefaultName = @"Player 1";

static CGFloat const collectionCellSpacing = 10.0;
static CGFloat const collectionCellSpacingIPad = 20.0;
static CGFloat const rightLeftEdgeInsets = 10.0;
static CGFloat const topBottomEdgeInsets = 10.0;

static CGFloat const numberOfColumnsIphone = 3;

static CGFloat const cardAnimationDelay = 5.0;

@interface ARTNewGameViewController () {
    BOOL _isFirstTimeLoading;
    NSMutableArray *_avatarSections;
    ARTAvatar *_selectedAvatar;
    BOOL _isOKToAnimateImageFlips;
}

@end

@implementation ARTNewGameViewController


- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    /*if (self.newPlayer) {
        self.backButton = [[UIButton alloc] backButtonWith:@"Back" tintColor:[UIColor blueNavBarColor] target:self andAction:@selector(backButtonTapped:)];
        [self.view addSubview:self.backButton];
    
    }*/
    
    
    
    _avatarSections = [self makeAvatarSections];
    
    if (self.newPlayer) {
        self.playerNames = [NSMutableDictionary new];
        [self.playerNames setValue:player1DefaultName forKey:@"Player1"];
    }
    else {
        ARTPlayer *player = self.game.players[@"Player1"];
        self.playerNames = [NSMutableDictionary new];
        [self.playerNames setValue:player.name forKey:@"Player1"];
        _selectedAvatar = player.avatar;

    }
    
    _isFirstTimeLoading = YES;
    
}

- (void) viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    [MKStoreManager enablePurchasedProducts];
    [self updateEnabledAvatars];

    
    self.navigationController.delegate = self;
    
    [[NSNotificationCenter defaultCenter] addObserver: self
                                             selector: @selector(handleEnteredBackground)
                                                 name: UIApplicationDidEnterBackgroundNotification
                                               object: nil];
    [[NSNotificationCenter defaultCenter] addObserver: self
                                             selector: @selector(handleDidBecomeActive)
                                                 name: UIApplicationDidBecomeActiveNotification
                                               object: nil];
    
    [(ARTNavigationController*)[self navigationController] setLandscapeOK:NO];
     [self.navigationController setNavigationBarHidden:YES animated:NO];
    
    if (_isFirstTimeLoading) {
        if ([[[ARTUserInfo sharedInstance] getVisualTheme] isEqual:@"white"]) {
            self.view.backgroundColor = [UIColor lightBackgroundColor]; 
        } else {
            self.view.backgroundColor = [UIColor darkBackgroundColor]; //darkmode
        }
        
        if (IS_IPAD) {
            self.firstPlayerTextFieldHeightConstraint.constant = 60.0;

        } else if (IS_OldIphone) {
            self.firstPlayerTextFieldHeightConstraint.constant = 40.0;

        } else {
            self.firstPlayerTextFieldHeightConstraint.constant = 50.0;

        }
        
        if (IS_OldIphone) {
            self.buttonHeightConstraint.constant = gameMenusHeightOldIphone;
        } else if (IS_IPHONE_5){
            self.buttonHeightConstraint.constant = gameMenusHeightIphone5;
        } else if (IS_IPHONE_6){
            self.buttonHeightConstraint.constant = gameMenusHeightIphone6;
        } else if (IS_IPHONE_6Plus){
            self.buttonHeightConstraint.constant = gameMenusHeightIphone6Plus;
        } else if (IS_IPAD){
            self.buttonHeightConstraint.constant = gameMenusHeightIpad;
        }
        
        if (IS_OldIphone) {
            self.playersNameLabelHeightConstraint.constant = 35.0;
            self.cardDeckLabelHeightConstraint.constant = 35.0;
        } else if (IS_IPAD) {
            self.playersNameLabelHeightConstraint.constant = 65.0;
            self.cardDeckLabelHeightConstraint.constant = 65.0;
        } else {
            self.playersNameLabelHeightConstraint.constant = 45.0;
            self.cardDeckLabelHeightConstraint.constant = 45.0;
        }

        
        [self.view layoutIfNeeded];
        
        [self setupLogoImageView];
        [self setupTopLabel];
        [self setupPlayersNamePlaceholder];
        [self setupPlayerNamesLabel];
        [self setupFirstPlayerNameTextField];
        [self setupCardDeckPlaceholder];
        [self setupCardDeckLabel];

        _isFirstTimeLoading = NO;
    }
    
    [self.view layoutIfNeeded];
    
    [self setupCollectionview];
    
    [self setupStartButton];
    
    [self.view layoutIfNeeded];
    
    [self.collectionView reloadData];
    
    [self.view layoutIfNeeded];
    
    if (_selectedAvatar) {
        [self highlightCellWithAvatarName:_selectedAvatar.name];
    }

}

- (void) viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    
    [self cancelAnimateCardTimer];

    [[NSNotificationCenter defaultCenter] removeObserver:self];


}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
    

    
    _isOKToAnimateImageFlips = YES;
    [self animateImageFlip];

    [self checkIfReadyToStart];

}

- (void)updateEnabledAvatars {
    
    NSArray *avatars = _avatarSections[0];
    
    for (NSInteger i = 0; i < avatars.count; i ++) {
        ARTAvatar *avatar = avatars[i];
        avatar.isEnabled = [ARTAvatar isAvatarEnabled:avatar.name];
    }
}


-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    [super prepareForSegue:segue sender:sender];
        
    if ([segue.identifier isEqual:@"GameSegue"]) {
        
        ARTCategoryViewController *viewController = (ARTCategoryViewController *)segue.destinationViewController;
        
        if (self.newPlayer) {
            NSMutableDictionary *players = [NSMutableDictionary new];
            for (NSString *key in self.playerNames) {
                ARTPlayer *player = [[ARTPlayer alloc] initWithNumber:key andName:self.playerNames[key] andAvatar:_selectedAvatar];
                [players setValue:player forKey:key];
            }
            
            ARTGame *newGame = [[ARTGame alloc] initWithGameMode:@"single" andPlayers:players];
            viewController.currentGame = newGame;
        }
    }
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (NSMutableArray *)makeAvatarSections {
    
    //_avatarImages is an array of arrays
    
    NSMutableArray *avatarSections = [NSMutableArray new];
    NSMutableArray *avatarsInSection = [NSMutableArray new];
    
    NSMutableArray *unsortedAvatars = [NSMutableArray arrayWithArray:[[ARTAvatarHelper sharedInstance] getAvatars]];
    
    ARTAvatar *thinkerAvatar;
    for (NSInteger i = 0; i < unsortedAvatars.count; i++) {
        ARTAvatar *avatar = unsortedAvatars[i];
        if ([avatar.name isEqual:kWiseGuyThinker]) {
            thinkerAvatar = avatar;
            [unsortedAvatars removeObject:avatar];
        }
    }
    
    NSSortDescriptor *categoryNumberDescriptor = [[NSSortDescriptor alloc] initWithKey:@"year" ascending:YES];
    NSSortDescriptor *avatarEnabledDescriptor = [[NSSortDescriptor alloc] initWithKey:@"isEnabled" ascending:NO];

    NSMutableArray *sortDescriptors = [NSMutableArray arrayWithObjects:avatarEnabledDescriptor,categoryNumberDescriptor,nil];
    
    NSArray *sortedAvatars = [unsortedAvatars sortedArrayUsingDescriptors:sortDescriptors];
    
    
    for (NSInteger i = 0; i < sortedAvatars.count; i++) {
        [avatarsInSection addObject:sortedAvatars[i]];
    }
    if (thinkerAvatar) {
        [avatarsInSection insertObject:thinkerAvatar atIndex:0];
    }
        
    [avatarSections addObject:avatarsInSection];
    
    return avatarSections;
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
    label.text = @"Player Setup";
    
    if ([[[ARTUserInfo sharedInstance] getVisualTheme] isEqual:@"white"]) {
        label.textColor = [UIColor blackColor];
    } else {
        label.textColor = [UIColor lightBlueColor];
    }
    
    if (IS_IPAD) {
        label.font = [UIFont fontWithName:@"HelveticaNeue-Medium" size:30];
    }
    else {
        label.font = [UIFont fontWithName:@"HelveticaNeue-Medium" size:20];
    }

    
    [self.logoImageView addSubview:label];
    [self.view sendSubviewToBack:self.logoImageView];

    if (self.topView) {
        [self.topView removeFromSuperview];
        self.topView = nil;
    }
    
    self.topView = [[ARTTopView alloc] init];
    
    [self.view addSubview:self.topView];
    [self.view sendSubviewToBack:self.topView];
}

- (void)animateImageFlip {
    
    if (_isOKToAnimateImageFlips) {
        
        [self animateCellImageFlips];
        [self resetAnimateCardTimer];
    }
}

- (void)animateImageFlipWithDelay:(CGFloat)delay {
    
    [self cancelAnimateCardTimer];
    
    self.animationTimer = [NSTimer scheduledTimerWithTimeInterval:delay
                                                           target:self
                                                         selector:@selector(animateImageFlip)
                                                         userInfo:nil
                                                          repeats:NO];
}

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


- (void)setupTopLabel {
    self.topLabel.text = @"Game Setup";
    self.topLabel.opaque = YES;
    
    UIFont *font;
    if (IS_IPAD) {
        font = [UIFont fontWithName:@"HelveticaNeue" size:28];
    } else {
        font = [UIFont fontWithName:@"HelveticaNeue" size:18];
    }
    
    self.topLabel.font = font;
    self.topLabel.textAlignment = NSTextAlignmentCenter;
    self.topLabel.numberOfLines = 0;
}


- (void) setupCardDeckPlaceholder {
    self.cardDeckPlaceholderView.layer.cornerRadius = 15.0;
    self.cardDeckPlaceholderView.clipsToBounds = YES;
    
    if ([[[ARTUserInfo sharedInstance] getVisualTheme] isEqual:@"white"]) {
        self.cardDeckPlaceholderView.backgroundColor = [UIColor lightBackgroundColor];

        self.cardDeckPlaceholderView.layer.borderColor = [UIColor blackColor].CGColor;
        self.cardDeckPlaceholderView.layer.borderWidth = 1.0;
        
        
    } else {
        self.cardDeckPlaceholderView.backgroundColor = [UIColor darkBackgroundColor];

        self.cardDeckPlaceholderView.layer.borderColor = [UIColor blueNavBarColor].CGColor;
        self.cardDeckPlaceholderView.layer.borderWidth = 1.0;
        
    }
}

- (void)setupCardDeckLabel {
    self.cardDeckLabel.text = @"Choose A Mental Icon";
    self.cardDeckLabel.opaque = YES;
    
    UIFont *font;
    if (IS_IPAD) {
        font = [UIFont fontWithName:@"HelveticaNeue" size:36];
    } else {
        font = [UIFont fontWithName:@"HelveticaNeue" size:26];
    }
    
    self.cardDeckLabel.font = font;
    self.cardDeckLabel.textAlignment = NSTextAlignmentCenter;
    self.cardDeckLabel.layer.cornerRadius = 15.0;
    
    if ([[[ARTUserInfo sharedInstance] getVisualTheme] isEqual:@"white"]) {
        self.cardDeckLabel.backgroundColor = [UIColor lightBlueColor];
        
        self.cardDeckLabel.textColor = [UIColor blackColor];
        self.cardDeckLabel.layer.borderWidth = 1.0;
        self.cardDeckLabel.layer.borderColor = [UIColor blackColor].CGColor;
        
    } else {
        self.cardDeckLabel.backgroundColor = [UIColor detailViewBlueColor];
        
        self.cardDeckLabel.textColor = [UIColor whiteColor];
        self.cardDeckLabel.layer.borderWidth = 1.0;
        self.cardDeckLabel.layer.borderColor = [UIColor blueNavBarColor].CGColor;
        
    }
}



- (void)setupPlayerNamesLabel {
    
    self.playerNamesLabel.text = @"Type Player Name";
    self.playerNamesLabel.opaque = YES;
    
    UIFont *font;
    if (IS_IPAD) {
        font = [UIFont fontWithName:@"HelveticaNeue" size:36];
    } else {
        font = [UIFont fontWithName:@"HelveticaNeue" size:26];
    }
    
    self.playerNamesLabel.font = font;
    self.playerNamesLabel.textAlignment = NSTextAlignmentCenter;
    self.playerNamesLabel.layer.cornerRadius = 15.0;
    
    if ([[[ARTUserInfo sharedInstance] getVisualTheme] isEqual:@"white"]) {
        self.playerNamesLabel.backgroundColor = [UIColor lightBlueColor];
        
        self.playerNamesLabel.textColor = [UIColor blackColor];
        self.playerNamesLabel.layer.borderWidth = 1.0;
        self.playerNamesLabel.layer.borderColor = [UIColor blackColor].CGColor;
        
    } else {
        self.playerNamesLabel.backgroundColor = [UIColor detailViewBlueColor];
        
        self.playerNamesLabel.textColor = [UIColor whiteColor];
        self.playerNamesLabel.layer.borderWidth = 1.0;
        self.playerNamesLabel.layer.borderColor = [UIColor blueNavBarColor].CGColor;
        
    }

}

- (void) setupPlayersNamePlaceholder {
    self.playersNamePlaceholderView.layer.cornerRadius = 15.0;
    self.playersNamePlaceholderView.clipsToBounds = YES;
    self.playersNamePlaceholderView.opaque = YES;
    
    if ([[[ARTUserInfo sharedInstance] getVisualTheme] isEqual:@"white"]) {
        self.playersNamePlaceholderView.backgroundColor = [UIColor lightBackgroundColor];

        self.playersNamePlaceholderView.layer.borderColor = [UIColor blackColor].CGColor;
        self.playersNamePlaceholderView.layer.borderWidth = 1.0;
        
        
    } else {
        self.playersNamePlaceholderView.backgroundColor = [UIColor darkBackgroundColor];

        self.playersNamePlaceholderView.layer.borderColor = [UIColor blueNavBarColor].CGColor;
        self.playersNamePlaceholderView.layer.borderWidth = 1.0;
        
    }
}

- (void) setupFirstPlayerNameTextField {
    self.firstPlayerTextField.backgroundColor = self.view.backgroundColor;
    self.firstPlayerTextField.opaque = YES;
    
    self.firstPlayerTextField.clearButtonMode = UITextFieldViewModeWhileEditing;
    self.firstPlayerTextField.delegate = self;
    self.firstPlayerTextField.autocorrectionType = UITextAutocorrectionTypeNo;
    self.firstPlayerTextField.autocapitalizationType = UITextAutocapitalizationTypeWords;
    self.firstPlayerTextField.returnKeyType = UIReturnKeyDone;
    self.firstPlayerTextField.textAlignment = NSTextAlignmentCenter;
    self.firstPlayerTextField.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
    if ([[[ARTUserInfo sharedInstance] getVisualTheme] isEqual:@"white"]) {
        self.firstPlayerTextField.textColor = [UIColor orangeColor];
        
    } else {
        self.firstPlayerTextField.keyboardAppearance = UIKeyboardAppearanceDark; //darkmode
        self.firstPlayerTextField.textColor = [UIColor orangeColor];
        
        
    }
    
    UIFont *font;
    if (IS_IPAD) {
        font = [UIFont fontWithName:@"HelveticaNeue" size:36];
    } else {
        font = [UIFont fontWithName:@"HelveticaNeue" size:26];
    }
    
    UIColor *color;
    if ([[[ARTUserInfo sharedInstance] getVisualTheme] isEqual:@"white"]) {
        color = [UIColor orangeColor];
    } else {
        color = [UIColor orangeColor];
    }
    
    self.firstPlayerTextField.font = font;
    self.firstPlayerTextField.attributedPlaceholder = [[NSAttributedString alloc] initWithString:self.playerNames[@"Player1"] attributes:@{NSForegroundColorAttributeName: color,NSFontAttributeName: font}];
    
}


- (void)setupStartButton {
    [self.startButton applyStandardFormatting];
    [self.startButton makeGlossy];
    
    UIFont *font;
    if (IS_IPAD) {
        font = [UIFont fontWithName:@"HelveticaNeue" size:36];
    } else {
        font = [UIFont fontWithName:@"HelveticaNeue" size:26];
    }
    
    UIColor *color = [UIColor whiteColor];
    
    NSMutableAttributedString *attrString = [[NSMutableAttributedString alloc] initWithString:@"Continue" attributes:@{NSFontAttributeName:font,NSForegroundColorAttributeName:color}];
    [self.startButton setAttributedTitle:attrString forState:UIControlStateNormal];
    
}

- (void)setupCollectionview {
    
    self.collectionView.allowsMultipleSelection = NO;
    
    self.collectionView.backgroundColor = self.view.backgroundColor;
    self.collectionView.opaque = YES;
    
    self.collectionView.delegate = self;
    self.collectionView.dataSource = self;
    
    [self.collectionView registerClass:[ARTNewPlayerCollectionReusableViewHeader class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"HeaderView"];
    
    if ([[[ARTUserInfo sharedInstance] getVisualTheme] isEqual:@"white"]) {
        self.collectionView.indicatorStyle = UIScrollViewIndicatorStyleBlack;
        
        
    } else {
        self.collectionView.indicatorStyle = UIScrollViewIndicatorStyleWhite;
        
    }
    
}


- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    NSMutableArray *avatarsInSection = _avatarSections[section];
    
    return avatarsInSection.count;
}

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    
    return _avatarSections.count;
}


- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    
    static NSString *identifier = @"CollectionCell";
    ARTNewPlayerCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:identifier forIndexPath:indexPath];
    
    ARTAvatar *avatar= _avatarSections[indexPath.section][indexPath.row];
    
    cell.avatar = avatar;

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
            verticalAdj = 0.0;
        } else {
            verticalAdj = 24.0;
        }
    }
    else {
        if (IS_IPAD) {
            verticalAdj = -10.0;
        } else {
            verticalAdj = 20.0;
        }
    }

    
    
    return CGSizeMake(imageWidth, imageWidth+verticalAdj);
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
        return CGSizeMake(self.collectionView.bounds.size.width, 0.0);
    } else if (IS_IPHONE_5) {
        return CGSizeMake(self.collectionView.bounds.size.width, 0.0);
    } else if (IS_IPAD) {
        return CGSizeMake(self.collectionView.bounds.size.width, 0.0);
    } else if (IS_IPHONE_6) {
        return CGSizeMake(self.collectionView.bounds.size.width, 0.0);
    } else if (IS_IPHONE_6Plus) {
        return CGSizeMake(self.collectionView.bounds.size.width, 0.0);
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
        ARTNewPlayerCollectionReusableViewHeader *headerView = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"HeaderView" forIndexPath:indexPath];
        
        
        headerView.headerTitle = @"Header Title";
        
        [headerView configureView];
        
        reusableview = headerView;
    }
    
    return reusableview;
}

- (BOOL) collectionView:(UICollectionView *)collectionView shouldSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    ARTNewPlayerCollectionViewCell *tappedCell = (ARTNewPlayerCollectionViewCell *)[self.collectionView cellForItemAtIndexPath:indexPath];
    
    if (![ARTAvatar isAvatarEnabled:tappedCell.avatar.name]) {
        
        [self.collectionView deselectItemAtIndexPath:indexPath animated:YES];
        
        [self handleEnteredBackground];
        
        __weak ARTNewGameViewController *wself = self;
        
        NSString *title;
        NSString *message;
        
        title = [NSString stringWithFormat:@"%@\nLocked",tappedCell.avatar.fullName];
        
        message = [NSString stringWithFormat:@"Unlock in the Store."];
            self.avatarNotEnabledAlertView = [[URBAlertView alloc] initWithTitle:title message:message cancelButtonTitle:@"Cancel" otherButtonTitles:@"Visit Store", nil];
        
        
        [self.avatarNotEnabledAlertView addAlertImage:[[ARTImageHelper sharedInstance] getLockImage]  imageScale:1.6 backgroundColor:[UIColor darkBlueColor] captionText:nil];
        
        [self.avatarNotEnabledAlertView setHandlerBlock:^(NSInteger buttonIndex, URBAlertView *alertView) {
            __strong ARTNewGameViewController *sself = wself;
            
            [sself.avatarNotEnabledAlertView hideWithCompletionBlock:^{
                
                // sself.collectionView.userInteractionEnabled = YES;
                [sself.collectionView deselectItemAtIndexPath:indexPath animated:YES];
                if (buttonIndex == 1) {
                    
                    [sself performSegueWithIdentifier:@"StoreSegue" sender:sself];
                    
                } else if (buttonIndex == 0) {
                    [sself handleDidBecomeActive];
                }
            }];
        }];
        [self.avatarNotEnabledAlertView showWithAnimation:URBAlertAnimationDefault ];
        
        return NO;
    }

    return YES;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    
    [self dismissKeyboard:self.firstPlayerTextField];
    
    ARTNewPlayerCollectionViewCell *tappedCell = (ARTNewPlayerCollectionViewCell *)[self.collectionView cellForItemAtIndexPath:indexPath];
    
    _selectedAvatar = tappedCell.avatar;

    if (_selectedAvatar) {

        //[self showBioForAvatar:_selectedAvatar];
        
    }

    [self checkIfReadyToStart];
}


- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    //[self answerQuestionTapDetected:nil];
    [self dismissKeyboard:textField];
    
    return NO;
}

- (void)textFieldDidBeginEditing:(UITextField *)textField {
    
    textField.placeholder = nil;
}

- (void)textFieldDidEndEditing:(UITextField *)textField {

    if (textField.text == nil || [textField.text isEqualToString:@""]) {
        if (textField == self.firstPlayerTextField) {
            textField.text = player1DefaultName;
        }
        
    }
    UIFont *font;
    if (IS_IPAD) {
        font = [UIFont fontWithName:@"HelveticaNeue" size:36];
    } else {
        font = [UIFont fontWithName:@"HelveticaNeue" size:26];
    }
    
    textField.attributedPlaceholder = [[NSAttributedString alloc] initWithString:textField.text attributes:@{NSForegroundColorAttributeName: [UIColor orangeColor],NSFontAttributeName:font}];
    
    if ([[[ARTUserInfo sharedInstance] getVisualTheme] isEqual:@"white"]) {
        textField.layer.borderColor = [UIColor blackColor].CGColor;
    } else {
        textField.layer.borderColor = [UIColor blueNavBarColor].CGColor;
    }
    
    if (textField == self.firstPlayerTextField) {
        [self.playerNames setValue:textField.text forKey:@"Player1"];

    }
    

   [self checkIfReadyToStart];
}

- (void)dismissKeyboard:(UITextField *)textField {
    if (textField) {
        [textField resignFirstResponder];
    }
}


- (id<UIViewControllerAnimatedTransitioning>)navigationController:(UINavigationController *)navigationController animationControllerForOperation:(UINavigationControllerOperation)operation fromViewController:(UIViewController *)fromVC toViewController:(UIViewController *)toVC {
    
    if ([toVC isMemberOfClass:[ARTCategoryViewController class]] || [toVC isMemberOfClass:[ARTStartViewController class]]) {
            ARTSlideTransitionAnimator *animator = [ARTSlideTransitionAnimator new];
            animator.direction = @"down";
            return animator;
    }
    else {
        return nil;
    }
}

- (BOOL)checkIfReadyToStart {
    
        if (_selectedAvatar && self.playerNames[@"Player1"]) {
            self.startButton.backgroundColor = [UIColor blueButtonColor];
            self.startButton.alpha = 1.0;
            [self.startButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
            return YES;
        }
        else {
            self.startButton.backgroundColor = [UIColor grayColor];
            self.startButton.alpha = 0.6;
            [self.startButton setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
            return NO;

        }
    
}




- (IBAction)startButtonTapped:(id)sender {
    
    
    if ([self checkIfReadyToStart] ) {
        
        [((ARTButton *)sender) setCustomHighlighted:YES];
        
        if (self.newPlayer) {
            [self performSegueWithIdentifier:@"GameSegue" sender:self];
        } else {
            ARTPlayer *player = self.game.players[@"Player1"];
            player.name = self.playerNames[@"Player1"];
            player.avatar = _selectedAvatar;
            [self.game saveGame];
            [self.navigationController popViewControllerAnimated:YES];
        }
             
    } else {
        
        self.playerNotSetupAlertView = [[URBAlertView alloc] initWithTitle:@"Player Not Setup" message:@"Please select a player name and icon to continue." cancelButtonTitle:nil otherButtonTitles:@"Cancel", nil];
        
        [self.playerNotSetupAlertView showWithAnimation:URBAlertAnimationDefault];
        
    }
    
    
    
}

- (void)animateCellImageFlips {
    
    float delay = 0.0;
    
    NSArray *visibleIndexPaths = [self.collectionView indexPathsForVisibleItems];
    
    NSArray *sortedArray = [visibleIndexPaths sortedArrayUsingSelector:@selector(compare:)];
    
    for (NSInteger i = 0; i < sortedArray.count; i++) {
        
        NSIndexPath *indexPath = sortedArray[i];
        
        ARTNewPlayerCollectionViewCell *cell = (ARTNewPlayerCollectionViewCell *)[self.collectionView cellForItemAtIndexPath:indexPath];
        
        [cell performSelector:@selector(animateImageFlip) withObject:nil afterDelay:delay inModes:[NSArray arrayWithObject:NSRunLoopCommonModes]];
        delay += roundImageFlipDelay;

    }
}

- (void)resetCellImageFlips {
    
    NSArray *visibleIndexPaths = [self.collectionView indexPathsForVisibleItems];
    
    for (NSInteger i = 0; i < visibleIndexPaths.count; i++) {
        
        NSIndexPath *indexPath = visibleIndexPaths[i];
        
        ARTNewPlayerCollectionViewCell *cell = (ARTNewPlayerCollectionViewCell *)[self.collectionView cellForItemAtIndexPath:indexPath];
        
        [cell resetImageFlip];
        
    }
}

- (void)highlightCellWithAvatarName:(NSString *)avatarName {
    
    NSInteger sectionCount = [self.collectionView numberOfSections];
    
    for (NSInteger i = 0; i < sectionCount; i++) {
        
        NSInteger rowCount = [self.collectionView numberOfItemsInSection:i];
        
        for (NSInteger j = 0; j < rowCount; j++) {
            
            NSIndexPath *indexPath = [NSIndexPath indexPathForItem:j inSection:i];
            ARTAvatar *avatar = _avatarSections[i][j];
            if ([avatar.name isEqualToString:avatarName]) {
                [self.collectionView selectItemAtIndexPath:indexPath animated:YES scrollPosition:UICollectionViewScrollPositionTop];
            } else {
            }
            
        }
    }
}


- (void)showBioForAvatar:(ARTAvatar *)avatar {
    
    [self handleEnteredBackground];
    
    NSString *titleString = [NSString stringWithFormat:@"%@\nBio",avatar.fullName];
    
    NSString *messageString = [avatar getBioString];
    
    __weak ARTNewGameViewController *wself = self;

    self.bioAlertView = [[URBAlertView alloc] initWithTitle:titleString message:messageString cancelButtonTitle:nil otherButtonTitles:@"Continue", nil];
    
    NSString * filePath = [[NSBundle mainBundle] pathForResource:avatar.imageFilename ofType:@"jpg"];
    UIImage *avatarImage = [UIImage imageWithContentsOfFile:filePath];
    
    [self.bioAlertView addAlertImage:avatarImage imageScale:1.0 backgroundColor:[UIColor clearColor] captionText:avatar.name];
    [self.bioAlertView addSpeechBubbleWithSpeechText:avatar.selectionMessage];
    
    [self.bioAlertView setMessageTextAlignment:NSTextAlignmentLeft];
    
    [self.bioAlertView setHandlerBlock:^(NSInteger buttonIndex, URBAlertView *alertView) {
        __strong ARTNewGameViewController *sself = wself;
        
        [sself.bioAlertView hideWithCompletionBlock:^{
            [sself handleDidBecomeActive];
        }];
    }];


    [self.bioAlertView showWithAnimation:URBAlertAnimationDefault ];


}

- (void)backButtonTapped:(id)sender {
    
    self.backButton.userInteractionEnabled = NO;
    
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)handleEnteredBackground {
    NSLog(@"app did enter background");
    
    
    _isOKToAnimateImageFlips = NO;
    [self cancelAnimateCardTimer];
    [self resetCellImageFlips];
}

- (void)handleDidBecomeActive {
    NSLog(@"app did become active");
    
    _isOKToAnimateImageFlips = YES;
    [self animateImageFlipWithDelay:1.0];
}

- (void)dealloc {
    
}

@end
