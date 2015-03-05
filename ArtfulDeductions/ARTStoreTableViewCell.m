//
//  ARTStoreTableViewCell.m
//  Artful Deductions
//
//  Created by Kyle Rokita on 8/19/14.
//  Copyright (c) 2014 Artful Deductions LLC. All rights reserved.
//

#import "ARTStoreTableViewCell.h"
#import "ARTStoreItem.h"
#import "ARTImageHelper.h"
#import "ARTButton.h"
#import "ARTDeck.h"
#import "ARTUserInfo.h"
//#import "ARTIAPHelper.h"
#import "UIColor+Extensions.h"
#import "ARTConstants.h"
#import "MKSKProduct.h"
#import "MKStoreManager.h"
#import "ARTStoreViewController.h"
#import "URBAlertView.h"

@interface ARTStoreTableViewCell () {
    NSNumberFormatter * _priceFormatter;

}

@end

@implementation ARTStoreTableViewCell

- (void)configureCell {
    
    self.opaque = YES;
    
    self.backgroundColor = [UIColor clearColor]; //darkmode
    
    UIView *selectionColor = [[UIView alloc] init];
    selectionColor.backgroundColor = [UIColor blueButtonColor];
    self.selectedBackgroundView = selectionColor;
    
    [self.contentView layoutIfNeeded];
    [self setupNameLabel];
    [self setupDescriptionLabel];
    [self setupFirstImageView];
    [self setupBuyButton];
}

- (void)setupNameLabel {
    self.nameLabel.text = self.storeItem.name;
    self.nameLabel.numberOfLines = 0;

    UIFont * font;
    if (IS_IPAD) {
        font = [UIFont fontWithName:@"HelveticaNeue" size:36];
    }
    else if (IS_IPHONE_6 || IS_IPHONE_6Plus) {
        font = [UIFont fontWithName:@"HelveticaNeue" size:22];
    }
    else {
        font = [UIFont fontWithName:@"HelveticaNeue" size:18];
    }
    
    self.nameLabel.font = font;
    self.nameLabel.textAlignment = NSTextAlignmentLeft;

    if ([[[ARTUserInfo sharedInstance] getVisualTheme] isEqual:@"white"]) {
    } else {
        self.nameLabel.textColor = [UIColor whiteColor]; //darkmode
    }
}

- (void)setupDescriptionLabel {
    self.descriptionLabel.text = self.storeItem.itemDescription;
    self.descriptionLabel.numberOfLines = 0;
    
    UIFont * font;
    if (IS_IPAD) {
        font = [UIFont fontWithName:@"HelveticaNeue" size:24];
    }
    else if (IS_IPHONE_6 || IS_IPHONE_6Plus) {
        font = [UIFont fontWithName:@"HelveticaNeue" size:14];
    }
    else {
        font = [UIFont fontWithName:@"HelveticaNeue" size:12];
    }
    
    self.descriptionLabel.font = font;
    self.descriptionLabel.textAlignment = NSTextAlignmentLeft;
    
    if ([[[ARTUserInfo sharedInstance] getVisualTheme] isEqual:@"white"]) {
    } else {
        self.descriptionLabel.textColor = [UIColor lightTextColor]; //darkmode
    }

}

- (void)setupFirstImageView {
    
    if (self.storeItem.imageFilenames.count > 0) {
    
        self.firstImageView.image = [[ARTImageHelper sharedInstance] getLQImageWithFileName:self.storeItem.imageFilenames[0] ];
        self.firstImageView.contentMode = UIViewContentModeScaleAspectFit;
        self.firstImageView.opaque = YES;
    }
}

- (void)setupBuyButton {
    
    [self.buyButton applyStandardFormatting];
    
    UIFont * font;
    if (IS_IPAD) {
        font = [UIFont fontWithName:@"HelveticaNeue" size:28];
    }
    else {
        font = [UIFont fontWithName:@"HelveticaNeue" size:18];
    }
    
    UIColor *color = [UIColor whiteColor];

    if (self.storeItem.product && ![MKStoreManager isFeaturePurchased:self.storeItem.product.productIdentifier]) {
        
        //there is a product and product purchased
        
        self.selectionStyle = UITableViewCellSelectionStyleDefault;
        
        self.buyButton.hidden = NO;
        
        if (IS_IPAD) {
            self.buyButtonWidthConstraint.constant = 100.0;
            
            self.imageViewWidthConstraint.constant = 135.0;
            self.imageViewHeightConstraint.constant = 135.0;
            
        } else {
            self.buyButtonWidthConstraint.constant = 60.0;
            
            self.imageViewWidthConstraint.constant = 80.0;
            self.imageViewHeightConstraint.constant = 80.0;
        }
        
        
        _priceFormatter = [[NSNumberFormatter alloc] init];
        [_priceFormatter setFormatterBehavior:NSNumberFormatterBehavior10_4];
        [_priceFormatter setNumberStyle:NSNumberFormatterCurrencyStyle];
       // [_priceFormatter setLocale:self.storeItem.product.priceLocale];
                
        NSString *string = [_priceFormatter stringFromNumber:self.storeItem.price];
        
        NSMutableAttributedString *attrString = [[NSMutableAttributedString alloc] initWithString:string attributes:@{NSFontAttributeName:font,NSForegroundColorAttributeName:color}];
        [self.buyButton setAttributedTitle:attrString forState:UIControlStateNormal];
        
        UITapGestureRecognizer *buyTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(buyTapDetected:)];
        buyTap.numberOfTapsRequired = 1;
        self.buyButton.userInteractionEnabled = YES;
        [self.buyButton addGestureRecognizer:buyTap];
        
    }
    else if (self.storeItem.product) {
        
        //there is a product and product not purchased
        
        self.selectionStyle = UITableViewCellSelectionStyleDefault;
        
        self.buyButton.hidden = YES;
        
        if (IS_IPAD) {
            self.buyButtonWidthConstraint.constant = 0.0;
            
            self.imageViewWidthConstraint.constant = 135.0;
            self.imageViewHeightConstraint.constant = 135.0;
            
        } else {
            self.buyButtonWidthConstraint.constant = 0.0;
            
            self.imageViewWidthConstraint.constant = 80.0;
            self.imageViewHeightConstraint.constant = 80.0;
        }


    }
    else {
        //there is no product
        
        self.buyButton.hidden = YES;
        self.buyButtonWidthConstraint.constant = 0.0;
        self.imageViewWidthConstraint.constant = 0.0;
        self.imageViewHeightConstraint.constant = 0.0;


        self.selectionStyle = UITableViewCellSelectionStyleNone;

    }

}

- (void)buyTapDetected:(UITapGestureRecognizer*)sender {
    NSLog(@"Tap detected");
    
    [((ARTButton *)sender.view) setCustomHighlighted:YES];
    
    SKProduct *product = self.storeItem.product;
    
    //__weak ARTStoreTableViewCell *wself = self;
    
    NSLog(@"Buying %@...", product.productIdentifier);
    [[MKStoreManager sharedManager] buyFeature:product.productIdentifier
                                    onComplete:^(NSString *purchasedFeature, NSData *purchasedReceipt, NSArray *availableDownloads) {
                                       // __strong ARTStoreTableViewCell *sself = wself;

                                        [self.delegate setupStoreItems];
                                    
                                    } onCancelled:^{
                                        
                      
                                    }
     ];
}
@end
