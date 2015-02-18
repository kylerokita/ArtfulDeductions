//
//  ARTScoreViewController.m
//  Artful Deductions
//
//  Created by Kyle Rokita on 10/16/14.
//  Copyright (c) 2014 Artful Deductions LLC. All rights reserved.
//

#import "ARTScoreViewController.h"
#import "ARTUserInfo.h"
#import "UIColor+Extensions.h"
#import "ARTConstants.h"
#import "UIButton+Extensions.h"
#import "ARTNavigationController.h"
#import "ARTTopView.h"
#import "ARTMenuObject.h"
#import "ARTScoreTableViewCell.h"
#import "ARTGame.h"
#import "ARTDeck.h"
#import "ARTCard.h"
#import "UIImage+Customization.h"


@interface ARTScoreViewController ()

@property (strong, nonatomic) NSMutableArray *cards;

@end

@implementation ARTScoreViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.view.backgroundColor = [UIColor clearColor];
    
    self.popoverPlaceholderView.backgroundColor = self.view.backgroundColor;
    
    self.popoverPlaceholderView.layer.cornerRadius = 15.0;
    self.popoverPlaceholderView.clipsToBounds = YES;
    
    if (IS_OldIphone) {
        self.menuHeightConstraint.constant = gameMenusHeightOldIphone;
    } else if (IS_IPHONE_5){
        self.menuHeightConstraint.constant = gameMenusHeightIphone5;
    } else if (IS_IPHONE_6){
        self.menuHeightConstraint.constant = gameMenusHeightIphone6;
    } else if (IS_IPHONE_6Plus){
        self.menuHeightConstraint.constant = gameMenusHeightIphone6Plus;
    } else if (IS_IPAD){
        self.menuHeightConstraint.constant = gameMenusHeightIpad;
    }
    
    if(IS_IPAD) {
        self.topLabelHeightConstraint.constant = 100.0;
    } else if (IS_IPHONE_6 && IS_IPHONE_6Plus) {
        self.topLabelHeightConstraint.constant = 70.0;
    } else {
        self.topLabelHeightConstraint.constant = 60.0;

    }
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void) viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    //self.navigationController.delegate = self;
    
    [(ARTNavigationController*)[self navigationController] setLandscapeOK:NO];
    [self.navigationController setNavigationBarHidden:YES animated:NO];
    
    [self.tableView deselectRowAtIndexPath:[self.tableView indexPathForSelectedRow] animated:NO];
    
    [self.view layoutIfNeeded];
    
    //CGFloat screenWidth = self.view.bounds.size.width;
    //CGFloat screenHeight= self.view.bounds.size.height;
    
    //CGRect darkenViewFrame = CGRectMake(screenWidth * -.25, screenHeight * -.25, screenWidth * 1.5, screenHeight * 1.5);
    //UIView *darkenView = [[UIView alloc] initWithFrame:darkenViewFrame];
    //darkenView.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.6];
    //[self.view addSubview:darkenView];
    //[self.view sendSubviewToBack:darkenView];
    
    [self setupTopLabel];
    
    [self setupMenu];
    [self setupCardScores];
    
    [self setupTableview];
    [self setupScorePlaceHolder];
    [self setupHeaderPlaceHolder];
    
    [self.headersPlaceholder layoutIfNeeded];
    
    [self setupTotalsPlaceHolder];
}

- (void)setupHeaderPlaceHolder {
    
    self.imageHeaderWidthConstraint.constant = self.tableView.rowHeight - 10.0;
    
    self.headersPlaceholder.backgroundColor = self.scorePlaceholder.backgroundColor;
    self.headersPlaceholder.opaque = YES;
    
    UIFont *font;
    if (IS_IPAD) {
        font = [UIFont fontWithName:@"HelveticaNeue" size:28];
    } else if (IS_IPHONE_6Plus ) {
        font = [UIFont fontWithName:@"HelveticaNeue" size:18];
    } else if (IS_IPHONE_6 ) {
        font = [UIFont fontWithName:@"HelveticaNeue" size:17];
    } else {
        font = [UIFont fontWithName:@"HelveticaNeue" size:14];
    }
    
    UIColor *color;
    if ([[[ARTUserInfo sharedInstance] getVisualTheme] isEqual:@"white"]) {
        color = [UIColor blackColor];
    } else {
        color = [UIColor whiteColor];
    }
    
    UIColor *possibleColor = [UIColor grayColor];
        
    NSString *imageString = @"\nArt";
    
    NSMutableAttributedString *imageAttrString = [[NSMutableAttributedString alloc] initWithString:imageString attributes:@{NSFontAttributeName:font,NSForegroundColorAttributeName:color,NSUnderlineStyleAttributeName:@(NSUnderlineStyleSingle)}];
    
    self.imageHeader.attributedText = imageAttrString;
    self.imageHeader.textAlignment = NSTextAlignmentCenter;
    self.imageHeader.numberOfLines = 0;
    self.imageHeader.backgroundColor = self.scorePlaceholder.backgroundColor;
    self.imageHeader.opaque = YES;
    
    NSString *questionNumberString = @"\nQuestion";
    
    NSMutableAttributedString *questionNumberAttrString = [[NSMutableAttributedString alloc] initWithString:questionNumberString attributes:@{NSFontAttributeName:font,NSForegroundColorAttributeName:color,NSUnderlineStyleAttributeName:@(NSUnderlineStyleSingle)}];
    
    self.questionNumberHeader.attributedText = questionNumberAttrString;
    self.questionNumberHeader.textAlignment = NSTextAlignmentCenter;
    self.questionNumberHeader.numberOfLines = 0;
    self.questionNumberHeader.backgroundColor = self.scorePlaceholder.backgroundColor;
    self.questionNumberHeader.opaque = YES;
    
    NSString *possiblePointsString = @"Possible\nPoints";
    
    NSMutableAttributedString *possiblePointsAttrString = [[NSMutableAttributedString alloc] initWithString:possiblePointsString attributes:@{NSFontAttributeName:font,NSForegroundColorAttributeName:possibleColor,NSUnderlineStyleAttributeName:@(NSUnderlineStyleSingle)}];
    
    self.possiblePointsHeader.attributedText = possiblePointsAttrString;
    self.possiblePointsHeader.numberOfLines = 0;
    self.possiblePointsHeader.textAlignment = NSTextAlignmentCenter;
    self.possiblePointsHeader.backgroundColor = self.scorePlaceholder.backgroundColor;
    self.possiblePointsHeader.opaque = YES;
    
    NSString *actualPointsString = @"Actual\nPoints";
    
    NSMutableAttributedString *actualPointsAttrString = [[NSMutableAttributedString alloc] initWithString:actualPointsString attributes:@{NSFontAttributeName:font,NSForegroundColorAttributeName:color,NSUnderlineStyleAttributeName:@(NSUnderlineStyleSingle)}];
    
    self.actualPointsHeader.attributedText = actualPointsAttrString;
    self.actualPointsHeader.numberOfLines = 0;
    self.actualPointsHeader.textAlignment = NSTextAlignmentCenter;
    self.actualPointsHeader.backgroundColor = self.scorePlaceholder.backgroundColor;
    self.actualPointsHeader.opaque = YES;
    
}



- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
    //self.view.backgroundColor = [UIColor colorWithPatternImage:self.backgroundImage];
    NSIndexPath *lastPlayedIndexPath = [self getIndexPathOfLastPlayedCard];
    [self.tableView scrollToRowAtIndexPath:lastPlayedIndexPath atScrollPosition:UITableViewScrollPositionMiddle animated:YES];
}

- (NSIndexPath *)getIndexPathOfLastPlayedCard {
    
    NSInteger latestCardPlayedRowIndex = 0;
    
    for (NSInteger i = 0; i < self.cards.count; i++) {
        ARTCard *card = self.cards[i];
        if (card.isPlayed) {
            latestCardPlayedRowIndex += 1;
        }
    }
    
    latestCardPlayedRowIndex = MAX(0, latestCardPlayedRowIndex -1);
    
    return [NSIndexPath indexPathForRow:latestCardPlayedRowIndex inSection:0];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    
    self.view.backgroundColor = [UIColor clearColor];
    
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}


-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    [super prepareForSegue:segue sender:sender];
    
    
}

- (void)setupScorePlaceHolder {
    
    self.scorePlaceholder.opaque = YES;
    
    if ([[[ARTUserInfo sharedInstance] getVisualTheme] isEqual:@"white"]) {
        self.scorePlaceholder.backgroundColor = [UIColor lightBackgroundColor]; //darkmode
        self.scorePlaceholder.layer.borderColor =[UIColor blackColor].CGColor;
        self.scorePlaceholder.layer.borderWidth = 1.0;
        
        
    } else {
        self.scorePlaceholder.backgroundColor = [UIColor darkBackgroundColor]; //darkmode
        self.scorePlaceholder.layer.borderColor = self.deck.color.CGColor;
        self.scorePlaceholder.layer.borderWidth = 2.0;
        
        
    }
    
    self.scorePlaceholder.layer.cornerRadius = 15.0;
    self.scorePlaceholder.clipsToBounds = YES;
}

- (void)setupTotalsPlaceHolder {
    
    self.totalTotalLabelWidth.constant = self.questionNumberHeader.frame.origin.x + self.questionNumberHeader.frame.size.width;
    
    self.totalsPlaceholder.backgroundColor = self.deck.color;
    self.totalsPlaceholder.opaque = YES;
    
    self.totalsPlaceholder.layer.cornerRadius = 15.0;
    self.totalsPlaceholder.clipsToBounds = YES;

    
    if ([[[ARTUserInfo sharedInstance] getVisualTheme] isEqual:@"white"]) {
        self.totalsPlaceholder.layer.borderColor =[UIColor blackColor].CGColor;
        self.totalsPlaceholder.layer.borderWidth = 1.0;
        
        
    } else {
        self.totalsPlaceholder.layer.borderWidth = 0.0;
        
    }
    
    
    UIFont *font;
    if (IS_IPAD) {
        font = [UIFont fontWithName:@"HelveticaNeue-Medium" size:38];
    } else if (IS_IPHONE_6Plus ) {
        font = [UIFont fontWithName:@"HelveticaNeue-Medium" size:24];
    } else if (IS_IPHONE_6 ) {
        font = [UIFont fontWithName:@"HelveticaNeue-Medium" size:24];
    } else {
        font = [UIFont fontWithName:@"HelveticaNeue-Medium" size:24];
    }
    
    UIColor *color;
    if ([[[ARTUserInfo sharedInstance] getVisualTheme] isEqual:@"white"]) {
        color = [UIColor whiteColor];
    } else {
        color = [UIColor whiteColor];
    }
    
    UIColor *possibleColor = [UIColor lightGrayColor];

    
    NSString *questionNumberString = @"Total";
    
    NSMutableAttributedString *questionNumberAttrString = [[NSMutableAttributedString alloc] initWithString:questionNumberString attributes:@{NSFontAttributeName:font,NSForegroundColorAttributeName:color}];
    
    self.totalTotalLabel.attributedText = questionNumberAttrString;
    self.totalTotalLabel.textAlignment = NSTextAlignmentCenter;
    self.totalTotalLabel.numberOfLines = 0;
    self.totalTotalLabel.backgroundColor = self.totalsPlaceholder.backgroundColor;
    self.totalTotalLabel.opaque = YES;
    
    NSString *possiblePointsString = [NSString stringWithFormat:@"%ld",(long)[self.deck getPossibleScore]];
    
    NSMutableAttributedString *possiblePointsAttrString = [[NSMutableAttributedString alloc] initWithString:possiblePointsString attributes:@{NSFontAttributeName:font,NSForegroundColorAttributeName:possibleColor}];
    
    self.totalPossibleLabel.attributedText = possiblePointsAttrString;
    self.totalPossibleLabel.numberOfLines = 0;
    self.totalPossibleLabel.textAlignment = NSTextAlignmentCenter;
    self.totalPossibleLabel.backgroundColor = self.totalsPlaceholder.backgroundColor;
    self.totalPossibleLabel.opaque = YES;
    
    NSString *actualPointsString = [NSString stringWithFormat:@"%ld",(long)[self.deck getScore]];
    
    NSMutableAttributedString *actualPointsAttrString = [[NSMutableAttributedString alloc] initWithString:actualPointsString attributes:@{NSFontAttributeName:font,NSForegroundColorAttributeName:color}];
    
    self.totalActualLabel.attributedText = actualPointsAttrString;
    self.totalActualLabel.numberOfLines = 0;
    self.totalActualLabel.textAlignment = NSTextAlignmentCenter;
    self.totalActualLabel.backgroundColor = self.totalsPlaceholder.backgroundColor;
    self.totalActualLabel.opaque = YES;
    
}


- (void)setupTableview {
    
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    
    self.tableView.opaque = YES;
    
    if ([[[ARTUserInfo sharedInstance] getVisualTheme] isEqual:@"white"]) {
        self.tableView.backgroundColor = [UIColor lightBackgroundColor]; //darkmode
        self.tableView.separatorColor = [UIColor blackColor];
        
    } else {
        self.tableView.backgroundColor = [UIColor darkBackgroundColor]; //darkmode
        self.tableView.separatorColor = self.deck.color;
        
    }
    
    if (IS_OldIphone) {
        self.tableView.rowHeight = 80.0;
    } else if (IS_IPHONE_5){
        self.tableView.rowHeight = 80.0;
    } else if (IS_IPHONE_6){
        self.tableView.rowHeight = 90.0;
    } else if (IS_IPHONE_6Plus){
        self.tableView.rowHeight = 95.0;
    } else if (IS_IPAD) {
        self.tableView.rowHeight = 130.0;
        
    }
    
}

- (void)setupCardScores {
    
    self.cards = nil;
    
    NSMutableArray *unsortedCards = [NSMutableArray new];
    
    for (NSString *key in self.deck.cards) {
        ARTCard *card = self.deck.cards[key];
        [unsortedCards addObject:card];
    }
    
    NSSortDescriptor *categoryNumberDescriptor = [[NSSortDescriptor alloc] initWithKey:@"categoryNumber" ascending:YES];
    NSMutableArray *sortDescriptors = [NSMutableArray arrayWithObject:categoryNumberDescriptor];
    self.cards = [[unsortedCards sortedArrayUsingDescriptors:sortDescriptors] mutableCopy];
    
    
}

- (void) setupTopLabel {
    self.topLabel.textAlignment = NSTextAlignmentCenter;
    self.topLabel.layer.cornerRadius = 15.0;
    self.topLabel.clipsToBounds = YES;
    
    UIFont * font;
    UIFont * largefont;
    
    if (IS_IPAD) {
        font = [UIFont fontWithName:@"HelveticaNeue-Medium" size:32];
        largefont = [UIFont fontWithName:@"HelveticaNeue-Medium" size:36];
    }
    else if (IS_IPHONE_6 && IS_IPHONE_6Plus) {
        font = [UIFont fontWithName:@"HelveticaNeue-Medium" size:22];
        largefont = [UIFont fontWithName:@"HelveticaNeue-Medium" size:26];
    }
    else {
        font = [UIFont fontWithName:@"HelveticaNeue-Medium" size:18];
        largefont = [UIFont fontWithName:@"HelveticaNeue-Medium" size:22];
    }
    
    self.topLabel.numberOfLines = 0;
    
    UIColor *color;
    if ([[[ARTUserInfo sharedInstance] getVisualTheme] isEqual:@"white"]) {
        color = [UIColor whiteColor];
        self.topLabel.backgroundColor =self.deck.color ;
        self.topLabel.layer.borderWidth = 1.;
        self.topLabel.layer.borderColor = [UIColor blackColor].CGColor;
    } else {
        color = [UIColor whiteColor];
        self.topLabel.backgroundColor =  self.deck.color;
        self.topLabel.layer.borderWidth = 2.0;
        self.topLabel.layer.borderColor = self.deck.color.CGColor;
    }
    
    NSString *text = [NSString stringWithFormat:@"%@\n",self.deck.uniqueID];
    
    NSString *text2;
    if (self.deck.isGameOver) {
        text2 = @"Final Score Summary";
    } else {
        text2 = @"Current Score Summary";
    }

    
    NSMutableAttributedString *attrString = [[NSMutableAttributedString alloc] initWithString:text attributes:@{NSFontAttributeName:largefont,NSForegroundColorAttributeName:color}];
    
    NSMutableAttributedString *attrString2 = [[NSMutableAttributedString alloc] initWithString:text2 attributes:@{NSFontAttributeName:font,NSForegroundColorAttributeName:color}];
    
    [attrString appendAttributedString:attrString2];
    
    self.topLabel.attributedText = attrString;
}

- (void) setupMenu {
    
    [self.menuPlaceholder layoutIfNeeded];
    self.menuPlaceholder.backgroundColor = [UIColor clearColor];
    
    for (UIView *subView in self.menuPlaceholder.subviews) {
        [subView removeFromSuperview];
    }
    
    CGRect menuShape = self.menuPlaceholder.bounds;
    
    
    UIColor *color = [UIColor whiteColor];
    
    ARTMenuObject *menu;
    
    if (self.deck.isGameOver) {
        
        menu = [[ARTMenuObject alloc] initWithButtonCount:2
                                                               withFrame:menuShape
                                                   withPortraitIndicator:NO];

        
        UIFont * font;
        if (IS_IPAD) {
            font = [UIFont fontWithName:@"HelveticaNeue" size:30];
        }
        else if (IS_IPHONE_6 || IS_IPHONE_6Plus) {
            font = [UIFont fontWithName:@"HelveticaNeue" size:20];
        }
        else {
            font = [UIFont fontWithName:@"HelveticaNeue" size:16];
        }
        
        UIButton *button2 = menu.arrayOfButtons[0];
        
        NSMutableAttributedString *attrString2 = [[NSMutableAttributedString alloc] initWithString:@"Share Score" attributes:@{NSFontAttributeName:font,NSForegroundColorAttributeName:color}];
        [button2 setAttributedTitle:attrString2 forState:UIControlStateNormal];
        
        [button2 addImage:[UIImage imageNamed:@"share"] rightSide:NO withXOffset:20.0];
        
        UITapGestureRecognizer *shareTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(shareTapDetected:)];
        shareTap.numberOfTapsRequired = 1;
        button2.userInteractionEnabled = YES;
        [button2 addGestureRecognizer:shareTap];
        
        
        UIButton *button = menu.arrayOfButtons[1];
        
        NSMutableAttributedString *attrString = [[NSMutableAttributedString alloc] initWithString:@"Continue" attributes:@{NSFontAttributeName:font,NSForegroundColorAttributeName:color}];
        [button setAttributedTitle:attrString forState:UIControlStateNormal];
                
        UITapGestureRecognizer *backTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(backButtonTapped:)];
        backTap.numberOfTapsRequired = 1;
        button.userInteractionEnabled = YES;
        [button addGestureRecognizer:backTap];
        
    }
    else {
        
        menu = [[ARTMenuObject alloc] initWithButtonCount:1
                                                               withFrame:menuShape
                                                   withPortraitIndicator:NO];

        
        UIFont * font;
        if (IS_IPAD) {
            font = [UIFont fontWithName:@"HelveticaNeue" size:36];
        }
        else {
            font = [UIFont fontWithName:@"HelveticaNeue" size:26];
        }
        
        UIButton *button = menu.arrayOfButtons[0];
        
        NSMutableAttributedString *attrString = [[NSMutableAttributedString alloc] initWithString:@"Continue" attributes:@{NSFontAttributeName:font,NSForegroundColorAttributeName:color}];
        [button setAttributedTitle:attrString forState:UIControlStateNormal];
        
        UITapGestureRecognizer *backTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(backButtonTapped:)];
        backTap.numberOfTapsRequired = 1;
        button.userInteractionEnabled = YES;
        [button addGestureRecognizer:backTap];
        
    }
    
    
    [self.menuPlaceholder addSubview:menu];
}



- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"TableCell";
    ARTScoreTableViewCell *cell = [self.tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    cell.card = self.cards[indexPath.row];
    
    [cell configureCell];
    
    return cell;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    
    return self.cards.count;
}

- (NSIndexPath *)tableView:(UITableView *)tableView willSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell* cell = [tableView cellForRowAtIndexPath:indexPath];
    if(cell.selectionStyle == UITableViewCellSelectionStyleNone){
        return nil;
    }
    return indexPath;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    NSLog(@"Tap Detected");
    
    
}

- (void)shareTapDetected:(UITapGestureRecognizer *)sender {
    NSLog(@"Single tap detected");
    
    UIImage *postImage = self.awardImage;
    
    NSInteger topicScore = [self.deck getScore];
    
    NSString *postText = [NSString stringWithFormat:@"Check out %@ app for iPhone or iPad! I scored %ld in the %@ topic.",appTitle,(long)topicScore,self.deck.uniqueID];
    
    NSArray *activityItems = @[postText,postImage];
    
    UIActivityViewController *activityController =
    [[UIActivityViewController alloc] initWithActivityItems:activityItems applicationActivities:nil];
    
    activityController.excludedActivityTypes = @[UIActivityTypeAirDrop,UIActivityTypeAssignToContact,UIActivityTypeCopyToPasteboard,UIActivityTypePostToVimeo,UIActivityTypePrint,UIActivityTypeSaveToCameraRoll,UIActivityTypeAddToReadingList];
    
    activityController.popoverPresentationController.sourceView = sender.view;
    activityController.popoverPresentationController.sourceRect = sender.view.bounds;
    activityController.popoverPresentationController.permittedArrowDirections = UIPopoverArrowDirectionDown;
    
    
    [self presentViewController:activityController
                       animated:YES completion:nil];
}


- (void)backButtonTapped:(UITapGestureRecognizer *)sender {
    NSLog(@"Single tap detected");
    
    self.backButton.userInteractionEnabled = NO;
    
    [self.delegate dismissViewControllerAnimated:YES completion:^{
        
    }];
}

- (void) dealloc {
    self.tableView.delegate = nil;
    self.tableView.dataSource = nil;
}


@end
