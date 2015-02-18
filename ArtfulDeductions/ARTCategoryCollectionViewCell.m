//
//  ARTCategoryCollectionViewCell.m
//  Artful Deductions
//
//  Created by Kyle Rokita on 10/1/14.
//  Copyright (c) 2014 Artful Deductions LLC. All rights reserved.
//

#import "ARTCategoryCollectionViewCell.h"
#import "ARTDeck.h"
#import "ARTCategoryViewController.h"
#import "ARTImageHelper.h"
#import "ARTConstants.h"
#import "ARTTextShadowLabel.h"
#import "ARTCard.h"
#import "ARTUserInfo.h"
#import "UIColor+Extensions.h"
#import "UIImage+Customization.h"
#import "ARTLabel.h"
#import "ARTGame.h"
#import "ARTPlayer.h"

@implementation ARTCategoryCollectionViewCell

- (void)configureCell {
    
    self.opaque = YES;
    self.userInteractionEnabled = YES;
    
    if ([[[ARTUserInfo sharedInstance] getVisualTheme] isEqual:@"white"]) {
        self.backgroundColor = [UIColor whiteColor];
        self.contentView.backgroundColor = [UIColor whiteColor];

    } else {
        self.backgroundColor = [UIColor detailViewBlueColor];
        self.contentView.backgroundColor = [UIColor detailViewBlueColor];

    }
    
    
    [self layoutIfNeeded];
    [self setupCategoryNameLabel];
    [self setupImageViewPlaceholder];
    [self setupCategoryNameLabelPlaceholder];
    
    self.imageViewHolder.layer.transform = CATransform3DIdentity;
    
    [self setNeedsDisplay];
    
    self.isOKToRotate = YES;
    
}

- (UIView *)pb_takeSnapshotView {
    //UIGraphicsBeginImageContextWithOptions(self.view.bounds.size, NO, [UIScreen mainScreen].scale);
    
    UIView *snapshot = [self.imageViewHolder snapshotViewAfterScreenUpdates:YES];
    
    // old style [self.layer renderInContext:UIGraphicsGetCurrentContext()];
    
    //UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    //UIGraphicsEndImageContext();
    return snapshot;
}

- (void)setupCategoryNameLabelPlaceholder {
    self.categoryNameLabelPlaceholder.opaque = YES;
    
    self.categoryNameLabelPlaceholder.backgroundColor = self.backgroundColor ;
    
}

- (void)setupCategoryNameLabel {
    NSString *text = self.deck.uniqueID;
    
    // float progressPercent = (float)self.deck.playedCardCount / (float)self.deck.totalCardCount * 100.;
    
 /*   NSInteger remainingCardCount = self.deck.remainingCardCount;
    
    NSString *progressString;
    if (remainingCardCount > 0) {
        progressString= [NSString stringWithFormat:@"\n%ld Q's",(long)remainingCardCount];
    } else {
        progressString= [NSString stringWithFormat:@"\n"];
    }
    
    text = [text stringByAppendingString:progressString];*/
    
    self.categoryNameLabel.textAlignment = NSTextAlignmentCenter;
    self.categoryNameLabel.numberOfLines = 0;
    self.categoryNameLabel.opaque = YES;
    
    
    self.categoryNameLabel.backgroundColor = self.backgroundColor ;
    
    UIFont *font;
    if (IS_IPAD) {
        font = [UIFont fontWithName:@"HelveticaNeue-Medium" size:28];
    } else {
        font = [UIFont fontWithName:@"HelveticaNeue-Medium" size:19];
    }
    
    
    
    UIColor *color;
    if ([[[ARTUserInfo sharedInstance] getVisualTheme] isEqual:@"white"]) {
        color = [UIColor blackColor];
    } else {
        color =[UIColor whiteColor];
    }
    
    
    // NSMutableAttributedString *attrString = [[NSMutableAttributedString alloc] initWithString:text attributes:@{NSFontAttributeName:font, NSForegroundColorAttributeName:color}];
    
    //   self.categoryNameLabel.attributedText = attrString;
    self.categoryNameLabel.font = font;
    self.categoryNameLabel.textColor = color;
    self.categoryNameLabel.text = text;
    
}


- (void)setupImageViewPlaceholder {
    
    [self.imageViewHolder layoutIfNeeded];
    
    self.imageViewHolder.backgroundColor = self.deck.color;
    self.imageViewHolder.layer.cornerRadius = self.imageViewHolder.frame.size.height / 2.0;
    
    if (IS_IPAD) {
        self.imageViewHolder.layer.borderWidth = 6.0;
    }
    else {
        self.imageViewHolder.layer.borderWidth = 4.0;
    }
    
    self.imageViewHolder.layer.borderColor = self.deck.color.CGColor;
    self.imageViewHolder.clipsToBounds = YES;
    self.imageViewHolder.opaque = YES;
    
    if (self.topCard) {
        
        if (self.awardImageView) {
            self.awardImageView.hidden = YES;
            self.logoImageView.hidden = YES;
            self.topicCompleteLabel.hidden = YES;
            self.scoreLabel.hidden = YES;
        }
        
        if (!self.cardImageView) {
            
            self.cardImageView = [[UIImageView alloc] initWithFrame:self.imageViewHolder.bounds];
            self.cardImageView.contentMode = UIViewContentModeScaleAspectFit;
            self.cardImageView.opaque = YES;
            
            [self.imageViewHolder addSubview:self.cardImageView];
            
        }
        
        //still need to redo frame definition since cards change from portrait to landscape and the animations change the frame
        self.cardImageView.frame = self.imageViewHolder.bounds;
        UIImage *image = [[ARTImageHelper sharedInstance] getLQImageWithFileName:self.topCard.frontFilename ];
        self.cardImageView.backgroundColor = self.deck.color;
        self.cardImageView.image = image;
        
        self.cardImageView.hidden = NO;
        
        
        if (self.deck.isEnabled) {
            
            if (self.imageViewOverlay) {
                
                self.imageViewOverlay.hidden = YES;
                
            }
            
        } else {
            
            if (!self.imageViewOverlay) {
                
                UIImage *image = [[ARTImageHelper sharedInstance] getLockBlackBorderImage];
                
               // UIImage *image = [UIImage imageNamed:@"99c"];
                
                self.imageViewOverlay = [[UIImageView alloc] initWithFrame:self.imageViewHolder.bounds];
                self.imageViewOverlay.contentMode = UIViewContentModeScaleAspectFit;
                self.imageViewOverlay.transform = CGAffineTransformMakeScale(0.5, 0.5);
                
                self.imageViewOverlay.image = image;
                
                NSString *text = @"99\u00A2";
                
                UIFont *font;
                if (IS_IPAD) {
                    font = [UIFont fontWithName:@"HelveticaNeue-Bold" size:38];
                } else if (IS_IPHONE_6Plus ) {
                    font = [UIFont fontWithName:@"HelveticaNeue-Bold" size:50.];
                } else if (IS_IPHONE_6) {
                    font = [UIFont fontWithName:@"HelveticaNeue-Bold" size:20];
                } else {
                    font = [UIFont fontWithName:@"HelveticaNeue-Bold" size:16];
                }
                
                UIColor *color = [UIColor whiteColor];
                
               // self.imageViewOverlay.textAlignment = NSTextAlignmentCenter;
              //  self.imageViewOverlay.numberOfLines = 0;
                
               // NSMutableAttributedString *attrString = [[NSMutableAttributedString alloc] initWithString:text attributes:@{NSFontAttributeName:font, NSForegroundColorAttributeName:color,NSStrokeWidthAttributeName: [NSNumber numberWithFloat:-2.5],NSStrokeColorAttributeName:[UIColor blackColor],}];
                
                //self.imageViewOverlay.attributedText = attrString;
                
                [self.imageViewHolder addSubview:self.imageViewOverlay];
                
                
                
            }
            
           // self.imageViewOverlay.backgroundColor = [self.deck.color colorWithAlphaComponent:0.2];
            self.imageViewOverlay.hidden = NO;
            
        }
        
    }
    else {
        
        if (self.cardImageView) {
            self.cardImageView.hidden = YES;
            self.imageViewOverlay.hidden = YES;
            
        }
        
        
        if (!self.awardImageView) {
            
            CGRect awardRect = CGRectMake(self.imageViewHolder.bounds.origin.x, self.imageViewHolder.bounds.origin.y, self.imageViewHolder.bounds.size.width, self.imageViewHolder.bounds.size.height);
            self.awardImageView = [[UIImageView alloc] initWithFrame:awardRect];
            self.awardImageView.backgroundColor = [UIColor clearColor];
            self.awardImageView.contentMode = UIViewContentModeScaleAspectFit;
            self.awardImageView.transform = CGAffineTransformMakeScale(0.72, 0.72);
            self.awardImageView.alpha = 0.16;
            
            
            
            CGFloat logoRatio = 0.4;
            
            CGFloat yInsetRatio = 0.12;
            CGFloat xInsetRatio = 0.1;
            
            CGRect logoRect = CGRectMake(ceil(self.imageViewHolder.bounds.size.width * xInsetRatio), ceil(self.imageViewHolder.bounds.size.height * (yInsetRatio+0.0
                                                                                                                                                     )), ceil(self.imageViewHolder.bounds.size.width * (1 - xInsetRatio * 2.)),ceil( self.imageViewHolder.bounds.size.height * (logoRatio - yInsetRatio)));
            
            self.logoImageView = [[UIImageView alloc] initWithFrame:logoRect];
            self.logoImageView.contentMode = UIViewContentModeScaleAspectFit;
            self.logoImageView.opaque = YES;
            self.logoImageView.transform = CGAffineTransformMakeScale(1.1, 1.1);
            [self.imageViewHolder addSubview:self.logoImageView];
            
            
            
            yInsetRatio = 0.15;
            xInsetRatio = 0.15;
            
            CGRect topicRect = CGRectMake(ceil(self.imageViewHolder.bounds.size.width * xInsetRatio), ceil(self.imageViewHolder.bounds.size.height * .6),ceil( self.imageViewHolder.bounds.size.width * (1 - xInsetRatio * 2.)), ceil(self.imageViewHolder.bounds.size.height * .28));
            
            
            UIFont *font;
            UIFont *smallFont;
            if (IS_IPAD) {
                font = [UIFont fontWithName:@"HelveticaNeue-Bold" size:38];
                smallFont = [UIFont fontWithName:@"HelveticaNeue-Medium" size:30];
            } else if (IS_IPHONE_6Plus ) {
                font = [UIFont fontWithName:@"HelveticaNeue-Bold" size:22];
                smallFont = [UIFont fontWithName:@"HelveticaNeue-Medium" size:18];
            } else if (IS_IPHONE_6) {
                font = [UIFont fontWithName:@"HelveticaNeue-Bold" size:20];
                smallFont = [UIFont fontWithName:@"HelveticaNeue-Medium" size:15];
            } else {
                font = [UIFont fontWithName:@"HelveticaNeue-Bold" size:16];
                smallFont = [UIFont fontWithName:@"HelveticaNeue-Medium" size:12];
            }
            
            
            self.topicCompleteLabel = [[UILabel alloc] initWithFrame:topicRect];
            self.topicCompleteLabel.textAlignment = NSTextAlignmentCenter;
            self.topicCompleteLabel.numberOfLines = 0;
            self.topicCompleteLabel.textColor = [UIColor whiteColor];
            self.topicCompleteLabel.font = smallFont;
            
            
            CGRect scoreRect = CGRectMake(ceil(self.imageViewHolder.bounds.origin.x), ceil(self.imageViewHolder.bounds.size.height * .45),ceil( self.imageViewHolder.bounds.size.width),ceil( self.imageViewHolder.bounds.size.height * .14));
            
            self.scoreLabel = [[UILabel alloc] initWithFrame:scoreRect];
            self.scoreLabel.textAlignment = NSTextAlignmentCenter;
            self.scoreLabel.numberOfLines = 0;
            self.scoreLabel.textColor = [UIColor whiteColor];
            self.scoreLabel.font = font;
            
            
            [self.imageViewHolder insertSubview:self.topicCompleteLabel belowSubview:self.logoImageView];
            [self.imageViewHolder insertSubview:self.scoreLabel aboveSubview:self.logoImageView];
            
            //add last
            [self.imageViewHolder addSubview:self.awardImageView];
            
        }
        
        self.awardImageView.hidden = NO;
        self.logoImageView.hidden = NO;
        self.topicCompleteLabel.hidden = NO;
        self.scoreLabel.hidden = NO;
        
        self.awardImageView.image = [self.deck getAwardImage];
        
        
        if ([[[ARTUserInfo sharedInstance] getVisualTheme] isEqual:@"white"]) {
            self.imageViewHolder.layer.borderWidth = 0.0;
        } else {
            self.imageViewHolder.layer.borderWidth = 1.0;
            self.imageViewHolder.layer.borderColor = [UIColor whiteColor].CGColor;
        }
        
        self.logoImageView.image = [[ARTImageHelper sharedInstance] getLogoWhiteImage];
        self.logoImageView.backgroundColor = self.imageViewHolder.backgroundColor;
        
        self.topicCompleteLabel.backgroundColor = self.imageViewHolder.backgroundColor;
        
        self.scoreLabel.backgroundColor = self.imageViewHolder.backgroundColor;
        
        
        NSString *scoreText = [NSString stringWithFormat:@"Score - %ld",(long)[self.deck getScore]];
        
        NSString *topicText = [NSString stringWithFormat:@"%@",self.deck.uniqueID];
        
        
        self.topicCompleteLabel.text = topicText;
        self.scoreLabel.text = scoreText;
        
        
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

- (void)startAnimateImageFlip {
    self.isOKToRotate = YES;
    [self animateImageFlip];
}

- (void)animateImageFlip {
    
    if (self.isOKToRotate) {
        self.isOKToRotate = NO;
        self.userInteractionEnabled = NO;
        [UIView animateWithDuration:roundImageFlipDuration/2.
                              delay:0
                            options:UIViewAnimationOptionCurveLinear |UIViewAnimationOptionAllowAnimatedContent
                         animations:^{
                             self.imageViewHolder.layer.transform = CATransform3DRotate(self.imageViewHolder.layer.transform,-M_PI*.995,0.0,1.0,0.0);
                         }
                         completion:^(BOOL finished) {
                             if (finished) {
                                 [UIView animateWithDuration:roundImageFlipDuration/2.
                                                       delay:0
                                                     options:UIViewAnimationOptionCurveLinear |UIViewAnimationOptionAllowAnimatedContent
                                                  animations:^{
                                                      self.imageViewHolder.layer.transform = CATransform3DRotate(self.imageViewHolder.layer.transform,-M_PI*.995,0.0,1.0,0.0);
                                                  }
                                                  completion:^(BOOL finished) {
                                                      if (finished) {
                                                          self.imageViewHolder.layer.transform = CATransform3DIdentity;
                                                          
                                                          self.userInteractionEnabled = YES;
                                                          self.isOKToRotate = YES;                                                      }
                                                      
                                                  }];
                             }
                             
                         }];
    }
    else {
        
        NSLog(@"Not ok to rotate");
    }
}

- (void)resetImageFlip {
    
    self.imageViewHolder.layer.transform = CATransform3DIdentity;
    
}

- (void)setSelected:(BOOL)selected {
    
    if (selected) {
        
        self.categoryNameLabel.textColor = self.deck.color;
    }
    else {
        
        if ([[[ARTUserInfo sharedInstance] getVisualTheme] isEqual:@"white"]) {
            self.categoryNameLabel.textColor = [UIColor blackColor];
            
        } else {
            self.categoryNameLabel.textColor = [UIColor whiteColor];
            
            
        }    }
}



@end
