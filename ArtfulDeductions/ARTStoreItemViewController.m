//
//  ARTStoreItemViewController.m
//  Artful Deductions
//
//  Created by Kyle Rokita on 8/20/14.
//  Copyright (c) 2014 Artful Deductions LLC. All rights reserved.
//

#import "ARTStoreItemViewController.h"
#import "ARTNavigationController.h"
#import "ARTStoreItem.h"
#import "ARTButton.h"
#import "ARTImageHelper.h"
#import "ARTDeck.h"
#import "ARTUserInfo.h"
//#import "ARTIAPHelper.h"
#import "UIColor+Extensions.h"
#import "ARTConstants.h"
#import "ARTTopView.h"
#import "UIButton+Extensions.h"
#import "MKStoreManager.h"
#import "MKSKProduct.h"
#import "URBAlertView.h"
#import "ARTCard.h"

@interface ARTStoreItemViewController () {
    NSNumberFormatter *_priceFormatter;
}

@end

@implementation ARTStoreItemViewController


- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    if ([[[ARTUserInfo sharedInstance] getVisualTheme] isEqual:@"white"]) {
        self.view.backgroundColor = [UIColor lightBackgroundColor]; //darkmode
    } else {
        self.view.backgroundColor = [UIColor darkBackgroundColor]; //darkmode
    }
    
    if (IS_OldIphone) {
        self.buyButtonHeightConstraint.constant = gameMenusHeightOldIphone;
    } else if (IS_IPHONE_5){
        self.buyButtonHeightConstraint.constant = gameMenusHeightIphone5;
    } else if (IS_IPHONE_6){
        self.buyButtonHeightConstraint.constant = gameMenusHeightIphone6;
    } else if (IS_IPHONE_6Plus){
        self.buyButtonHeightConstraint.constant = gameMenusHeightIphone6Plus;
    } else if (IS_IPAD){
        self.buyButtonHeightConstraint.constant = gameMenusHeightIpad;
    }
    
    self.backButton = [[UIButton alloc] backButtonWith:@"Store" tintColor:[UIColor blueNavBarColor] target:self andAction:@selector(backButtonTapped:)];
    [self.view addSubview:self.backButton];

}



- (void) viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.navigationController.delegate = self;
    
    [(ARTNavigationController*)[self navigationController] setLandscapeOK:NO];
    [self.navigationController setNavigationBarHidden:YES animated:NO];
    
    if (IS_OldIphone) {
        self.nameLabelHeightConstraint.constant = 35.0;
    } else if (IS_IPAD) {
        self.nameLabelHeightConstraint.constant = 65.0;
    } else {
        self.nameLabelHeightConstraint.constant = 45.0;
    }
    
    [self.view layoutIfNeeded];
    
    [self setupLogoImageView];
    [self setupNameLabel];
    
    [self.view layoutIfNeeded]; //handles changes in description label that impact the size of scrollview
    
    [self setupBuyButton];
    [self.view layoutIfNeeded]; //height constraint of buy button is variable
    
    [self setupScrollContent];
    [self setupScrollView];
    
    //[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(productPurchased:) name:IAPHelperProductPurchasedNotification object:nil];
    
}

- (void) viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)productPurchased:(NSNotification *)notification {
    
    //NSString * productIdentifier = notification.object;
    
    [self viewWillAppear:NO];
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
    label.text = @"Store";
    
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
    [self.view sendSubviewToBack:self.logoImageView];
    
    if (self.topView) {
        [self.topView removeFromSuperview];
        self.topView = nil;
    }
    
    self.topView = [[ARTTopView alloc] init];
    
    [self.view addSubview:self.topView];
    [self.view sendSubviewToBack:self.topView];

}

- (void)setupNameLabel {
    self.nameLabel.text = self.storeItem.name;
    self.nameLabel.numberOfLines = 0;
    
    UIFont * font;
    if (IS_IPAD) {
        font = [UIFont fontWithName:@"HelveticaNeue" size:42];
    }
    else {
        font = [UIFont fontWithName:@"HelveticaNeue" size:28];
    }
    
    self.nameLabel.font = font;
    self.nameLabel.textAlignment = NSTextAlignmentCenter;
    
    self.nameLabel.textColor = [UIColor whiteColor];
    self.nameLabel.layer.cornerRadius = self.nameLabel.frame.size.height / 2.0;
    self.nameLabel.clipsToBounds = YES;
    
    /*CGFloat red = [self.storeItem.deck.color[@"Red"] floatValue];
    CGFloat green = [self.storeItem.deck.color[@"Green"] floatValue];
    CGFloat blue = [self.storeItem.deck.color[@"Blue"] floatValue];

    self.nameLabel.backgroundColor = [UIColor colorWithRed:red/255.0 green:green/255.0 blue:blue/255.0 alpha:1.0];*/
    
    if ([[[ARTUserInfo sharedInstance] getVisualTheme] isEqual:@"white"]) {
        self.nameLabel.backgroundColor = [UIColor lightBlueColor]; //darkmode
        self.nameLabel.layer.borderColor = [UIColor blackColor].CGColor; //darkmode
        self.nameLabel.layer.borderWidth = 1.0; //darkmode
        self.nameLabel.textColor = [UIColor blackColor];

    } else {
        self.nameLabel.backgroundColor = [UIColor detailViewBlueColor];
        self.nameLabel.layer.borderColor = [UIColor blueNavBarColor].CGColor;
        self.nameLabel.layer.borderWidth = 1.0; //darkmode
        self.nameLabel.textColor = [UIColor whiteColor];
    }

    
    if ([[[ARTUserInfo sharedInstance] getVisualTheme] isEqual:@"white"]) {
    } else {
        self.nameLabel.textColor = [UIColor whiteColor]; //darkmode
    }
}

- (UILabel *)makeDescriptionTitleLabelWithFrame:(CGRect)frame {
    
    UILabel *label = [[UILabel alloc] initWithFrame:frame];
    label.numberOfLines = 1;
    
    UIFont * font;
    if (IS_IPAD) {
        font = [UIFont fontWithName:@"HelveticaNeue" size:36];
    }
    else if (IS_IPHONE_6Plus) {
        font = [UIFont fontWithName:@"HelveticaNeue" size:26];
    }
    else {
        font = [UIFont fontWithName:@"HelveticaNeue" size:22];
    }
    
    UIColor *color;
    if ([[[ARTUserInfo sharedInstance] getVisualTheme] isEqual:@"white"]) {
        color = [UIColor blackColor];
    } else {
        color = [UIColor whiteColor];
    }
    
    label.font = font;
    label.textAlignment = NSTextAlignmentCenter;
    
    NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:@"Description" attributes:@{NSFontAttributeName:font,NSUnderlineStyleAttributeName:@(NSUnderlineStyleSingle),NSForegroundColorAttributeName:color}];
    
    label.attributedText = attributedString;


    return label;
}

- (UILabel *)makeDescriptionLabelWithFrame:(CGRect)frame font:(UIFont *)font {
    
    UILabel *label = [[UILabel alloc] initWithFrame:frame];
    label.text = self.storeItem.itemDescription;
    label.numberOfLines = 0;
    
    label.font = font;
    label.textAlignment = NSTextAlignmentLeft;
    
    if ([[[ARTUserInfo sharedInstance] getVisualTheme] isEqual:@"white"]) {
    } else {
        label.textColor = [UIColor lightGrayColor]; //darkmode
    }

    return label;
}

- (void)setupBuyButton {
    NSLog(@"final buybutton width: %f",self.buyButton.frame.size.width);

    [self.buyButton applyStandardFormatting];
    [self.buyButton makeGlossy];
    
    //if (![[ARTIAPHelper sharedInstance] productPurchased:self.storeItem.product.productIdentifier]) {
    if (![MKStoreManager isFeaturePurchased:self.storeItem.product.productIdentifier]) {

        self.buyButton.hidden = NO;
        
        _priceFormatter = [[NSNumberFormatter alloc] init];
        [_priceFormatter setFormatterBehavior:NSNumberFormatterBehavior10_4];
        [_priceFormatter setNumberStyle:NSNumberFormatterCurrencyStyle];
       // [_priceFormatter setLocale:self.storeItem.product.priceLocale];
        NSString *priceString = [_priceFormatter stringFromNumber:self.storeItem.price];
        NSString *string = [@"Purchase for " stringByAppendingString:priceString];
        
        UIFont * font;
        if (IS_IPAD) {
            font = [UIFont fontWithName:@"HelveticaNeue" size:34];
        }
        else {
            font = [UIFont fontWithName:@"HelveticaNeue" size:24];
        }
        
        
        UIColor *color = [UIColor whiteColor];
        
        NSMutableAttributedString *attrString = [[NSMutableAttributedString alloc] initWithString:string attributes:@{NSFontAttributeName:font,NSForegroundColorAttributeName:color}];
        [self.buyButton setAttributedTitle:attrString forState:UIControlStateNormal];
        
        UITapGestureRecognizer *buyTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(buyTapDetected:)];
        buyTap.numberOfTapsRequired = 1;
        self.buyButton.userInteractionEnabled = YES;
        [self.buyButton addGestureRecognizer:buyTap];
    }
    else {
        self.buyButton.hidden = YES;
        self.buyButtonHeightConstraint.constant = 0.0;
    }
    
}

- (UILabel *)makeSampleImagesTitleLabelWithFrame:(CGRect)frame  {

    UILabel  *label = [[UILabel alloc] initWithFrame:frame];
    label.numberOfLines = 1;

    UIFont * font;
    if (IS_IPAD) {
        font = [UIFont fontWithName:@"HelveticaNeue" size:36];
    }
    else if (IS_IPHONE_6Plus) {
        font = [UIFont fontWithName:@"HelveticaNeue" size:26];
    }
    else {
        font = [UIFont fontWithName:@"HelveticaNeue" size:22];
    }
    
    UIColor *color;
    if ([[[ARTUserInfo sharedInstance] getVisualTheme] isEqual:@"white"]) {
        color = [UIColor blackColor];
    } else {
        color = [UIColor whiteColor];
    }

    label.textAlignment = NSTextAlignmentCenter;

    NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:@"Trivia Art Samples" attributes:@{NSFontAttributeName:font,NSUnderlineStyleAttributeName:@(NSUnderlineStyleSingle),NSForegroundColorAttributeName:color}];

    label.attributedText = attributedString;


    return label;
}

- (void)setupScrollView {
    
    
    self.scrollView.delegate= self;
    self.scrollView.clipsToBounds = YES;
    self.scrollView.showsVerticalScrollIndicator = NO;
    self.scrollView.showsHorizontalScrollIndicator = YES;

    self.scrollView.pagingEnabled = NO;
    
}

- (void)setupScrollContent {
    
    CGFloat titleHeight;
    if (IS_IPAD) {
        titleHeight = 40.0;
    } else {
        titleHeight = 30.0;
    }
    
    CGFloat sectionSpacing;
    if (IS_IPAD) {
        sectionSpacing = 30.0;
    } else {
        sectionSpacing = 15.0;
    }
    
    CGRect descriptionTitleFrame = CGRectMake(5.0, sectionSpacing - 5.0, self.scrollView.bounds.size.width - 10.0, titleHeight);
    self.descriptionTitleLabel = [self makeDescriptionTitleLabelWithFrame:descriptionTitleFrame];
    [self.scrollView addSubview:self.descriptionTitleLabel];
     
    UIFont * font;
    if (IS_IPAD) {
        font = [UIFont fontWithName:@"HelveticaNeue" size:32];
    }
    else if (IS_IPHONE_6Plus) {
        font = [UIFont fontWithName:@"HelveticaNeue" size:22];
    }
    else {
        font = [UIFont fontWithName:@"HelveticaNeue" size:18];
    }
    
    CGSize maximumLabelSize = CGSizeMake(self.scrollView.bounds.size.width - 10.0, MAXFLOAT);
    
    CGRect textRect = [self.storeItem.itemDescription boundingRectWithSize:maximumLabelSize
                                           options:(NSStringDrawingUsesLineFragmentOrigin|NSStringDrawingUsesFontLeading)
                                                                attributes:@{NSFontAttributeName:font}
                                           context:nil];

    
    CGFloat labelHeight = ceil(textRect.size.height) ;
    CGRect descriptionFrame = CGRectMake(5.0, self.descriptionTitleLabel.frame.origin.y + self.descriptionTitleLabel.frame.size.height + sectionSpacing, self.scrollView.bounds.size.width - 10.0, labelHeight);
    self.descriptionLabel = [self makeDescriptionLabelWithFrame:descriptionFrame font:font];
     [self.scrollView addSubview:self.descriptionLabel];

    CGRect sampleImagesTitleFrame = CGRectMake(5.0, self.descriptionLabel.frame.origin.y + self.descriptionLabel.frame.size.height + sectionSpacing, self.scrollView.bounds.size.width - 10.0, titleHeight);
    self.sampleImagesTitleLabel = [self makeSampleImagesTitleLabelWithFrame:sampleImagesTitleFrame];
    [self.scrollView addSubview:self.sampleImagesTitleLabel];
    
    NSArray *storeImages = self.storeItem.imageFilenames;
    NSInteger imageCount = storeImages.count;
    
    CGFloat xOffset = 5.0;
    CGFloat y = self.sampleImagesTitleLabel.frame.origin.y + self.sampleImagesTitleLabel.frame.size.height ;
    CGFloat width = self.scrollView.frame.size.width  - 2 * xOffset; //floor((self.scrollView.frame.size.width - 2 * xOffset - 10.0)/2.0);
    CGFloat height = width;
    
    CGFloat x;
    
    for (NSInteger i = 0; i < imageCount; i++) {
        
        UIImage *image = [[ARTImageHelper sharedInstance]getHQImageWithFileName:storeImages[i] ];
        
        NSInteger ySpacing;
        if (IS_IPAD) {
            ySpacing = 30.0;
        } else {
            ySpacing = 20.0;
        }
        
        y = y + ySpacing + (i > 0 ? height : 0.);
        x = xOffset;
        
        if (image.size.width > image.size.height) {
            height = width / hToWRatio;
        } else {
            height = width;
        }
        
        CGRect frame = CGRectMake(x, y, width, height);
        UIImageView *imageView = [[UIImageView alloc] initWithFrame:frame];
        
        imageView.image = image;
        imageView.contentMode = UIViewContentModeScaleAspectFit;
        
        imageView.opaque = YES;
        
        [self.scrollView addSubview:imageView];
    }
    
    CGFloat totalHeight = y + height + 10.0;
    self.scrollView.contentSize = CGSizeMake(self.scrollView.frame.size.width, totalHeight);


    
}


- (void)buyTapDetected:(UITapGestureRecognizer*)sender {
    NSLog(@"Tap detected");
    
    [((ARTButton *)sender.view) setCustomHighlighted:YES];
    
    SKProduct *product = self.storeItem.product;
    
    
    NSLog(@"Buying %@...", product.productIdentifier);
    [[MKStoreManager sharedManager] buyFeature:product.productIdentifier
                                    onComplete:^(NSString *purchasedFeature, NSData *purchasedReceipt, NSArray *availableDownloads) {
                                        [self setupBuyButton];
                                    } onCancelled:^{
                                        
                           
                                    }];

}

- (void)backButtonTapped:(id)sender {
    
    self.backButton.userInteractionEnabled = NO;
    
    [self.navigationController popViewControllerAnimated:YES];
}

@end
