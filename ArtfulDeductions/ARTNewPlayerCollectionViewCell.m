//
//  ARTNewPlayerCollectionViewCell.m
//  Artful Deductions
//
//  Created by Kyle Rokita on 10/1/14.
//  Copyright (c) 2014 Artful Deductions LLC. All rights reserved.
//

#import "ARTNewPlayerCollectionViewCell.h"
#import "ARTNewGameViewController.h"
#import "ARTConstants.h"
#import "UIColor+Extensions.h"
#import "ARTUserInfo.h"
#import "ARTAvatar.h"
#import "ARTImageHelper.h"

@implementation ARTNewPlayerCollectionViewCell

- (void)configureCell {
    
    self.opaque = YES;
    self.userInteractionEnabled = YES;
    
    [self layoutIfNeeded];
    
    [self setupImageView];
    [self setupAvatarLabel];
    
    if ([[[ARTUserInfo sharedInstance] getVisualTheme] isEqual:@"white"]) {
        
        self.backgroundColor = [UIColor lightBackgroundColor];
    } else {
        
        self.backgroundColor = [UIColor darkBackgroundColor];
        
    }
    
    [self resetImageFlip];

}

- (void)setupAvatarLabel {
    
    self.avatarLabel.text = self.avatar.name;
    
    UIFont * font;
    if (IS_IPAD) {
        font = [UIFont fontWithName:@"HelveticaNeue" size:30];
    } else if (IS_IPHONE_5) {
        font = [UIFont fontWithName:@"HelveticaNeue" size:16];
    } else if (IS_IPHONE_6) {
        font = [UIFont fontWithName:@"HelveticaNeue" size:18];
    } else {
        font = [UIFont fontWithName:@"HelveticaNeue" size:20];
    }
    
    self.avatarLabel.font = font;
    self.avatarLabel.textAlignment = NSTextAlignmentCenter;
    self.avatarLabel.backgroundColor = self.backgroundColor;
    self.avatarLabel.opaque = YES;

    
    if ([[[ARTUserInfo sharedInstance] getVisualTheme] isEqual:@"white"]) {
        
        self.avatarLabel.textColor = [UIColor blackColor];
        self.avatarLabel.backgroundColor = [UIColor lightBackgroundColor];
    } else {
        
        self.avatarLabel.textColor = [UIColor whiteColor];
        self.avatarLabel.backgroundColor = [UIColor darkBackgroundColor];

    }
}

- (void)setupImageView {
    
    NSString * filePath = [[NSBundle mainBundle] pathForResource:self.avatar.imageFilename ofType:@"jpg"];
    UIImage *image = [UIImage imageWithContentsOfFile:filePath];
    self.imageView.image = image;
    
    self.imageView.contentMode = UIViewContentModeScaleAspectFill;
    self.imageView.opaque = YES;
    self.imageView.backgroundColor = self.backgroundColor;
    
    self.imageView.layer.cornerRadius = self.imageView.frame.size.height/2.0;
    self.imageView.clipsToBounds = YES;
    
   // self.imageView.layer.rasterizationScale = [UIScreen mainScreen].scale;
    //self.imageView.layer.shouldRasterize = YES;
    
    NSArray *array = self.imageView.subviews;
    for (NSInteger i = 0; i < array.count; i ++) {
        UIView *subview = array[i];
        [subview removeFromSuperview];
    }
    
    if (![ARTAvatar isAvatarEnabled:self.avatar.name]) {
        
        UILabel  *imageViewOverlay = [[UILabel alloc] initWithFrame:self.imageView.bounds];
        
        if ([[[ARTUserInfo sharedInstance] getVisualTheme] isEqual:@"white"]) {
            imageViewOverlay.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.4];
            imageViewOverlay.textColor = [UIColor whiteColor];
        } else {
            imageViewOverlay.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.5];
            imageViewOverlay.textColor = [UIColor whiteColor];
        }
        
        imageViewOverlay.text = @"";
        
        if (IS_IPAD) {
            imageViewOverlay.font = [UIFont fontWithName:@"HelveticaNeue" size:120.0];
        }
        else {
            imageViewOverlay.font = [UIFont fontWithName:@"HelveticaNeue" size:80.0];
        }
        
        imageViewOverlay.textAlignment = NSTextAlignmentCenter;
        
        
        UIImageView *shoppingCartImageView = [[UIImageView alloc] initWithFrame:self.imageView.bounds];
        shoppingCartImageView.image = [[ARTImageHelper sharedInstance] getLockBlackBorderImage];
        shoppingCartImageView.contentMode = UIViewContentModeScaleAspectFit;
        shoppingCartImageView.transform = CGAffineTransformMakeScale(1.2, 1.2);
        
        [imageViewOverlay addSubview: shoppingCartImageView];
        
        
        [self.imageView addSubview:imageViewOverlay];
    }

}

- (void)animateImageFlip {
    
    [UIView animateWithDuration:roundImageFlipDuration/4.0
                          delay:0
                        options:UIViewAnimationOptionCurveLinear | UIViewAnimationOptionAllowUserInteraction
                     animations:^{
        self.imageView.layer.transform = CATransform3DRotate(self.imageView.layer.transform,-M_PI_2,0.0,1.0,0.0);
                     }
                     completion:^(BOOL finished) {
                         if (finished && !CATransform3DIsIdentity(self.imageView.layer.transform)) {
                             [self animateImageFlip];
                         }
                     }];
}

- (void)resetImageFlip {
    
    self.imageView.layer.transform = CATransform3DIdentity;
    
    [self.imageView setNeedsDisplay];
}


- (void)setSelected:(BOOL)selected {
    
    if (selected) {
        
        if (IS_IPAD) {
            self.imageView.layer.borderWidth = 6.0;
        } else {
            self.imageView.layer.borderWidth = 3.0;
        }
        
        self.imageView.layer.borderColor = [UIColor orangeColor].CGColor;
        self.avatarLabel.textColor = [UIColor orangeColor];
    }
    else {
        
        if (IS_IPAD) {
            self.imageView.layer.borderWidth = 2.0;
        } else {
            self.imageView.layer.borderWidth = 1.0;
        }
        
        self.imageView.layer.borderColor = [UIColor lightGrayColor].CGColor;

        
        if ([[[ARTUserInfo sharedInstance] getVisualTheme] isEqual:@"white"]) {
            self.avatarLabel.textColor = [UIColor blackColor];
            self.imageView.layer.borderColor = [UIColor blackColor].CGColor;

        } else {
            self.avatarLabel.textColor = [UIColor whiteColor];
            self.imageView.layer.borderColor = [UIColor lightGrayColor].CGColor;

            
        }    }
}

@end
