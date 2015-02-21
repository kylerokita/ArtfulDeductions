//
//  ARTCollectionViewCell.m
//  Artful Deductions
//
//  Created by Kyle Rokita on 8/10/14.
//  Copyright (c) 2014 Artful Deductions LLC. All rights reserved.
//

#import "ARTCollectionViewCell.h"
#import "ARTCard.h"
#import "ARTDeck.h"
#import "ARTImageHelper.h"
#import "ARTGalleryViewController.h"
#import "UIColor+Extensions.h"
#import "UIImage+Customization.h"
#import "ARTConstants.h"
#import "ARTUserInfo.h"

@interface ARTCollectionViewCell () {
}

@end

@implementation ARTCollectionViewCell


- (void)configureCell {
    
    if ([((ARTGalleryViewController *)self.delegate).indexPathShowsNoImage isEqual:self.indexPath]) {
        self.hidden = YES;
    } else {
        self.hidden = NO;
    }
    
    /** Xcode 6 on iOS 7 hot fix **/
    //self.contentView.frame = self.bounds;
    //self.contentView.autoresizingMask = UIViewAutoresizingFlexibleBottomMargin | UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleRightMargin;
    //self.contentView.translatesAutoresizingMaskIntoConstraints = YES;
    /** End of Xcode 6 on iOS 7 hot fix **/
    
    self.opaque = YES;
    self.userInteractionEnabled = YES;
    self.clipsToBounds = NO;
    
    [self layoutIfNeeded];
    [self setupImageView];
    
    
}

- (void)setupImageView {
    
    self.myImageView.contentMode = UIViewContentModeScaleAspectFit;
    self.myImageView.opaque = YES;
    
    self.myImageView.image = [[ARTImageHelper sharedInstance] getLQImageWithFileName:self.card.frontFilename];
    
    if (!self.imageViewOverlay) {
        
        self.imageViewOverlay = [[UILabel alloc] initWithFrame:self.bounds];
        
        UIFont *font;
        if (IS_IPAD) {
            font = [UIFont fontWithName:@"HelveticaNeue-Medium" size:96.0];
        }
        else {
            font = [UIFont fontWithName:@"HelveticaNeue-Medium" size:58.0];
        }
        
        self.imageViewOverlay.textAlignment = NSTextAlignmentCenter;
        
        self.imageViewOverlay.text = @"?";
        self.imageViewOverlay.font = font;
        self.imageViewOverlay.textColor = [UIColor whiteColor];
        
        [self addSubview:self.imageViewOverlay];
        
    }
    
    self.imageViewOverlay.backgroundColor = [self.deck.color colorWithAlphaComponent:0.8];

    
    if ([ARTCard isCardPlayed:self.card.uniqueID]) {
        self.imageViewOverlay.hidden = YES;
        
    } else {
        
        self.imageViewOverlay.hidden = NO;
        //self.imageViewOverlay.backgroundColor = [self.deck.color colorWithAlphaComponent:0.4];

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

- (void)layoutSubviews {
    
    [super layoutSubviews];
    
    if (self.imageViewOverlay) {
        self.imageViewOverlay.frame = [self frameThatFitsImageFrame:self.bounds withOrientation:self.card.orientation];

    }
}



@end
