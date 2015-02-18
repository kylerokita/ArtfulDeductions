//
//  ARTCategoryCollectionReusableViewHeader.m
//  Artful Deductions
//
//  Created by Kyle Rokita on 10/1/14.
//  Copyright (c) 2014 Artful Deductions LLC. All rights reserved.
//

#import "ARTCategoryCollectionReusableViewHeader.h"
#import "ARTConstants.h"
#import "UIColor+Extensions.h"
#import "ARTUserInfo.h"

@implementation ARTCategoryCollectionReusableViewHeader

- (void)configureView {
    
    [self layoutIfNeeded];
    
    [self setupContainerView];
    
    [self layoutIfNeeded];

    if (self.label) {
        [self.label removeFromSuperview];
    }
        self.label = [self makeLabelWithText:self.headerTitle];
        [self.containerView addSubview:self.label];
    
}

- (void)setupContainerView {
    if (!self.containerView) {

    self.containerView = [[UIView alloc] init];
    [self addSubview:self.containerView];
    
    self.containerView.opaque = YES;
    
    
    if ([[[ARTUserInfo sharedInstance] getVisualTheme] isEqual:@"white"]) {
        self.containerView.layer.borderColor = [UIColor blueButtonColor].CGColor;
        
    } else {
        self.containerView.layer.borderColor = [UIColor lightBlueColor].CGColor;
        
    }
    
    self.containerView.clipsToBounds = YES;
 //   self.containerView.layer.borderWidth = 1.0;
    
    
    self.containerView.frame = CGRectMake(15.0, 25.0, self.bounds.size.width - 30.0, self.bounds.size.height - 15.0);
    self.containerView.layer.cornerRadius = self.containerView.frame.size.height / 2.0;
        
      
    if ([[[ARTUserInfo sharedInstance] getVisualTheme] isEqual:@"white"]) {
        
        self.containerView.backgroundColor = [UIColor whiteColor]; //darkmode
        
    } else {
        self.containerView.backgroundColor = [UIColor detailViewBlueColor];
        
    }
    
    
    self.containerView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    }
}

- (UILabel *)makeLabelWithText:(NSString *)text {
    
    
        UILabel *label = [[UILabel alloc] initWithFrame:self.containerView.bounds];
        
        label.opaque = YES;
        
        label.textAlignment = NSTextAlignmentCenter;
        
        
        UIFont * font;
        if (IS_IPAD) {
            font = [UIFont fontWithName:@"HelveticaNeue-Italic" size:44];
        }
        else if (IS_IPHONE_6 || IS_IPHONE_6Plus) {
            font = [UIFont fontWithName:@"HelveticaNeue-Italic" size:32];

        } else  {
            font = [UIFont fontWithName:@"HelveticaNeue-Italic" size:26];
            
        }
        
        label.font = font;
        
        if ([[[ARTUserInfo sharedInstance] getVisualTheme] isEqual:@"white"]) {
            label.textColor = [UIColor darkGrayColor];

        } else {
            label.textColor = [UIColor whiteColor];

        }
    
    
        
        label.clipsToBounds = YES;
    
    
    label.text = text;
    
    if ([[[ARTUserInfo sharedInstance] getVisualTheme] isEqual:@"white"]) {
        label.backgroundColor = [UIColor whiteColor]; //darkmode

    } else {
        label.backgroundColor = [UIColor detailViewBlueColor];

    }
    
    label.backgroundColor = [UIColor clearColor];
    
    label.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    
    return label;
}

- (void)animateHeader {
    
//this is currently blank because there is no animation planned
    
}



@end
