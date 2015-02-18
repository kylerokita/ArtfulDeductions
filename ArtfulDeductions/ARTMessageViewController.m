//
//  ARTMessageViewController.m
//  Artful Deductions
//
//  Created by Kyle Rokita on 10/17/14.
//  Copyright (c) 2014 Artful Deductions LLC. All rights reserved.
//

#import "ARTMessageViewController.h"
#import "ARTUserInfo.h"
#import "UIColor+Extensions.h"
#import "ARTConstants.h"
#import "UIButton+Extensions.h"
#import "ARTNavigationController.h"
#import "ARTTopView.h"
#import "ARTMenuObject.h"
#import "ARTGame.h"
#import "ARTDeck.h"
#import "ARTCard.h"
#import "ARTButton.h"


@interface ARTMessageViewController () {
    BOOL _pageControlBeingUsed;

}

@end

@implementation ARTMessageViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.view.backgroundColor = [UIColor clearColor];
    self.popoverPlaceholderView.backgroundColor = [UIColor clearColor];
    
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
    
    _pageControlBeingUsed = NO;
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
    
    [self.view layoutIfNeeded];

    [self setupMessagePlaceHolder];

    
    [self setupTopLabel];
    [self setupMenu];
    [self setupPageControl];
    [self setupScrollview];
}


- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    
    [self.delegate performSelector:@selector(viewWillAppear:) withObject:nil afterDelay:0.5 inModes:[NSArray arrayWithObject:NSRunLoopCommonModes] ];
    
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}


-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    [super prepareForSegue:segue sender:sender];
    
    
}

- (void)setupMessagePlaceHolder {
    
    self.messagePlaceholder.opaque = YES;
    
    if ([[[ARTUserInfo sharedInstance] getVisualTheme] isEqual:@"white"]) {
        self.messagePlaceholder.backgroundColor = [UIColor lightBackgroundColor]; //darkmode
        self.messagePlaceholder.layer.borderColor =[UIColor blackColor].CGColor;
        self.messagePlaceholder.layer.borderWidth = 1.0;
        
        
    } else {
        self.messagePlaceholder.backgroundColor = [UIColor detailViewBlueColor]; //darkmode
        self.messagePlaceholder.layer.borderColor = [UIColor darkBlueColor].CGColor;
        self.messagePlaceholder.layer.borderWidth = 2.0;
        
        
    }

    self.messagePlaceholder.layer.cornerRadius = 15.0;
    self.messagePlaceholder.clipsToBounds = YES;
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    if (!_pageControlBeingUsed) {

        CGFloat pageWidth = self.messageScrollview.frame.size.width;
        float fractionalPage = self.messageScrollview.contentOffset.x / pageWidth;
        NSInteger page = lround(fractionalPage);
        self.pageControl.currentPage = page;
        
        if (fractionalPage + 1 > self.pageControl.numberOfPages + 0.1) {
            [self.delegate dismissViewControllerAnimated:YES completion:^{
                
            }];
        }

    }
}

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView {
    _pageControlBeingUsed = NO;
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    _pageControlBeingUsed = NO;
}

- (void)setupScrollview {
    
    [self.messageScrollview layoutIfNeeded];
    
    self.automaticallyAdjustsScrollViewInsets = NO;
    
    NSArray *subviews = [self.messageScrollview subviews];
    for (UIView *subview in subviews) {
        [subview removeFromSuperview];
    }
    
    CGFloat verticalHeaderSpacing = 20.0;
   // CGFloat verticalBodySpacing = 15.0;

    CGFloat xInset = 15.0;
    
    CGFloat headerX = xInset;
    CGFloat headerY = 0.0;
    CGFloat headerWidth = (self.messageScrollview.bounds.size.width - headerX * 2.0) ;
    CGFloat headerHeight = 0.0;
    
    CGFloat bodyX = xInset;
    CGFloat bodyY = 0.0;
    CGFloat bodyWidth = (self.messageScrollview.bounds.size.width - bodyX * 2.0) ;
    CGFloat bodyHeight = 0.0;
    
    UIFont *headerFont;
    UIFont *messageFont;

    if (IS_IPAD) {
        headerFont = [UIFont fontWithName:@"HelveticaNeue" size:38.0];
        messageFont = [UIFont fontWithName:@"HelveticaNeue" size:32.0];
        
    } else if (IS_IPHONE_6 || IS_IPHONE_6Plus) {
        headerFont = [UIFont fontWithName:@"HelveticaNeue" size:26.0];
        messageFont = [UIFont fontWithName:@"HelveticaNeue" size:20.0];
    }
    else {
        headerFont = [UIFont fontWithName:@"HelveticaNeue" size:22.0];
        messageFont = [UIFont fontWithName:@"HelveticaNeue" size:16.0];
    }
    
    UIColor *color;
    if ([[[ARTUserInfo sharedInstance] getVisualTheme] isEqual:@"white"]) {

        color = [UIColor blackColor];
    } else {

        color = [UIColor whiteColor];
    }

    //NSMutableArray *arrayOfLabels = [NSMutableArray new];
    
    for (NSInteger i = 0; i < self.messageDictionaries.count; i++) {
        
        NSMutableDictionary *messageDict = self.messageDictionaries[i];
        NSString *headerText = messageDict[@"headerText"];
        NSMutableAttributedString *headerAttrString = [[NSMutableAttributedString alloc] initWithString:headerText attributes:@{NSFontAttributeName:headerFont,NSForegroundColorAttributeName:color,NSUnderlineStyleAttributeName:@(NSUnderlineStyleSingle)}];
        
        headerY = verticalHeaderSpacing;
        headerX = xInset * (1 + i) + (headerWidth + xInset) * i;
        
        CGSize maxHeaderSize = CGSizeMake(headerWidth, MAXFLOAT);
        
        CGRect headerTextRect = [headerText boundingRectWithSize:maxHeaderSize
                                              options:(NSStringDrawingUsesLineFragmentOrigin|NSStringDrawingUsesFontLeading)
                                           attributes:[headerAttrString attributesAtIndex:0 effectiveRange:nil]
                                              context:nil];
        
        headerHeight = ceil(headerTextRect.size.height);
        
        CGRect headerFrame = CGRectMake(headerX, headerY, headerWidth, headerHeight);
        UILabel *headerLabel = [[UILabel alloc] initWithFrame:headerFrame];
        headerLabel.numberOfLines = 0;
        headerLabel.textAlignment = NSTextAlignmentCenter;
        headerLabel.attributedText = headerAttrString;
        headerLabel.backgroundColor = self.messagePlaceholder.backgroundColor;
        headerLabel.opaque = YES;
        
        [self.messageScrollview addSubview:headerLabel];
        
        NSString *bodyText = messageDict[@"bodyText"];
        NSMutableAttributedString *bodyAttrString = [[NSMutableAttributedString alloc] initWithString:bodyText attributes:@{NSFontAttributeName:messageFont,NSForegroundColorAttributeName:color}];
        
        bodyY = headerY + headerHeight + verticalHeaderSpacing;
        bodyX = headerX;
        
        CGSize maxBodySize = CGSizeMake(bodyWidth, MAXFLOAT);
        
        CGRect bodyTextRect = [bodyText boundingRectWithSize:maxBodySize
                                                   options:(NSStringDrawingUsesLineFragmentOrigin|NSStringDrawingUsesFontLeading)
                                                attributes:[bodyAttrString attributesAtIndex:0 effectiveRange:nil]
                                                   context:nil];
        
        bodyHeight = ceil(bodyTextRect.size.height);
        
        CGRect bodyFrame = CGRectMake(bodyX, bodyY, bodyWidth, bodyHeight);
        UILabel *bodyLabel = [[UILabel alloc] initWithFrame:bodyFrame];
        bodyLabel.numberOfLines = 0;
        bodyLabel.textAlignment = NSTextAlignmentLeft;
        bodyLabel.attributedText = bodyAttrString;
        bodyLabel.backgroundColor = self.messagePlaceholder.backgroundColor;
        bodyLabel.opaque = YES;
        
        [self.messageScrollview addSubview:bodyLabel];
    }
    
    CGFloat totalHeight = bodyY + bodyHeight ;
    CGFloat totalWidth = bodyX + bodyWidth + xInset;

    
    self.messageScrollview.contentSize = CGSizeMake(totalWidth, totalHeight);
    
    self.messageScrollview.delegate= self;
    self.messageScrollview.clipsToBounds = YES;
    self.messageScrollview.showsVerticalScrollIndicator = NO;
    self.messageScrollview.showsHorizontalScrollIndicator = NO;
    self.messageScrollview.backgroundColor = self.messagePlaceholder.backgroundColor;
    self.messageScrollview.opaque = YES;
    self.messageScrollview.pagingEnabled = YES;
    
    self.pageControl.numberOfPages = floor(self.messageScrollview.contentSize.width / self.messageScrollview.bounds.size.width);

}

- (void)setupPageControl {
    self.pageControl.hidesForSinglePage = YES;
    
    if ([[[ARTUserInfo sharedInstance] getVisualTheme] isEqual:@"white"]) {
        self.pageControl.pageIndicatorTintColor = [UIColor lightGrayColor];
        self.pageControl.currentPageIndicatorTintColor = [UIColor blackColor];

    } else {

    }
    
}


- (void) setupTopLabel {
    self.topLabel.textAlignment = NSTextAlignmentCenter;
    self.topLabel.layer.cornerRadius = 15.0;
    self.topLabel.clipsToBounds = YES;
    
    UIFont * font;
    
    if (IS_IPAD) {
        font = [UIFont fontWithName:@"HelveticaNeue-Medium" size:36.];
    }
    else if (IS_IPHONE_6 || IS_IPHONE_6Plus) {
        font = [UIFont fontWithName:@"HelveticaNeue-Medium" size:26.];
    }
    else {
        font = [UIFont fontWithName:@"HelveticaNeue-Medium" size:22.];
    }
    
    self.topLabel.numberOfLines = 0;
    
    UIColor *color;
    if ([[[ARTUserInfo sharedInstance] getVisualTheme] isEqual:@"white"]) {
        color = [UIColor blackColor];
        self.topLabel.backgroundColor =[ UIColor lightBlueColor ];
        self.topLabel.layer.borderWidth = 1.;
        self.topLabel.layer.borderColor = [UIColor blackColor].CGColor;
    } else {
        color = [UIColor whiteColor];
        self.topLabel.backgroundColor =  [UIColor darkBlueColor];
        self.topLabel.layer.borderWidth = 2.0;
        self.topLabel.layer.borderColor = [UIColor darkBlueColor].CGColor;
    }
    self.topLabel.opaque = YES;
    
    NSMutableAttributedString *attrString = [[NSMutableAttributedString alloc] initWithString:self.topString attributes:@{NSFontAttributeName:font,NSForegroundColorAttributeName:color}];
    
    self.topLabel.attributedText = attrString;
}

- (void) setupMenu {
    
    [self.menuPlaceholder layoutIfNeeded];
    self.menuPlaceholder.backgroundColor = [UIColor clearColor];
    
    for (UIView *subView in self.menuPlaceholder.subviews) {
        [subView removeFromSuperview];
    }
    
    CGRect menuShape = self.menuPlaceholder.bounds;
    
    //use menuDictionary
    
    ARTMenuObject *menu = [[ARTMenuObject alloc] initWithButtonCount:self.menuDictionaries.count
                                                           withFrame:menuShape
                                               withPortraitIndicator:NO];
    
    UIFont * font;
    if (IS_IPAD) {
        font = [UIFont fontWithName:@"HelveticaNeue" size:36];
    }
    else if (IS_IPHONE_6 || IS_IPHONE_6Plus) {
        font = [UIFont fontWithName:@"HelveticaNeue" size:26];
    }
    else {
        font = [UIFont fontWithName:@"HelveticaNeue" size:22];
    }
    
    UIColor *color = [UIColor whiteColor];
    
    for (NSInteger i = 0; i < self.menuDictionaries.count; i++) {
        
        NSMutableDictionary *menuDict = self.menuDictionaries[i];
        
        NSString *buttonTitle = menuDict[@"buttonTitle"];

        UIButton *button = menu.arrayOfButtons[i];
        
        NSMutableAttributedString *attrString = [[NSMutableAttributedString alloc] initWithString:buttonTitle attributes:@{NSFontAttributeName:font,NSForegroundColorAttributeName:color}];
        [button setAttributedTitle:attrString forState:UIControlStateNormal];
        
        [button addImage:[UIImage imageNamed:@"forward"] rightSide:YES withXOffset:10.0];
        
        UITapGestureRecognizer *tapRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(continueTapped:)];
        tapRecognizer.numberOfTapsRequired = 1;
        button.userInteractionEnabled = YES;
        [button addGestureRecognizer:tapRecognizer];
        
    }
    
    [self.menuPlaceholder addSubview:menu];
}

- (void)advancePage {
    
    CGFloat pageWidth = self.messageScrollview.frame.size.width;
    float fractionalPage = self.messageScrollview.contentOffset.x / pageWidth;
    NSInteger page = lround(fractionalPage);
    
    CGRect nextRect = CGRectMake((page + 1) * (self.messageScrollview.frame.size.width), self.messageScrollview.frame.origin.y, self.messageScrollview.frame.size.width, self.messageScrollview.frame.size.height);
   // self.pageControl.currentPage = page;
    
    [self.messageScrollview scrollRectToVisible:nextRect animated:YES];
    
}


- (void)continueTapped:(UIGestureRecognizer *)sender {
    NSLog(@"Single tap detected");
    
    ARTButton *button = (ARTButton *)sender.view;
    [button setCustomHighlighted:YES];

    
    self.backButton.userInteractionEnabled = NO;
    
    if (self.pageControl.currentPage != self.pageControl.numberOfPages - 1) {
        _pageControlBeingUsed = NO;

        [self advancePage];
    }
    else {
    
        [self.delegate dismissViewControllerAnimated:YES completion:^{
        
        }];
    }
}


- (IBAction)pageValueChanged:(id)sender {
    
    // update the scroll view to the appropriate page
    CGRect frame;
    frame.origin.x = self.messageScrollview.frame.size.width * self.pageControl.currentPage;
    frame.origin.y = 0;
    frame.size = self.messageScrollview.frame.size;
    [self.messageScrollview scrollRectToVisible:frame animated:YES];
    
    _pageControlBeingUsed = YES;

}
@end
