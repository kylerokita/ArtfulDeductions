//
//  ARTNewPlayerCollectionReusableViewHeader.m
//  Artful Deductions
//
//  Created by Kyle Rokita on 10/1/14.
//  Copyright (c) 2014 Artful Deductions LLC. All rights reserved.
//

#import "ARTNewPlayerCollectionReusableViewHeader.h"
#import "ARTConstants.h"
#import "ARTUserInfo.h"
#import "UIColor+Extensions.h"

@implementation ARTNewPlayerCollectionReusableViewHeader

- (void)configureView {
    //self.opaque = YES;
    
    [self setupLabel];
}

- (void)setupLabel {
    
    
    if (self.label == nil) {
        self.label = [[UILabel alloc] init];
        [self addSubview:self.label];
        
        self.label.opaque = YES;
        
        self.label.textAlignment = NSTextAlignmentCenter;
        
        
        UIFont * font;
        if (IS_IPAD) {
            font = [UIFont fontWithName:@"HelveticaNeue" size:40];
        }
        else {
            font = [UIFont fontWithName:@"HelveticaNeue" size:28];
        }
        
        self.label.font = font;
        
        if ([[[ARTUserInfo sharedInstance] getVisualTheme] isEqual:@"white"]) {
            self.label.textColor = [UIColor blackColor];
        } else {
            self.label.textColor = [UIColor whiteColor];
        }
        
    }
    
    if (self.backView == nil) {
        
        self.backView = [[UIView alloc] init];
        [self insertSubview:self.backView belowSubview:self.label];
        self.backView.opaque = YES;
        
    }
    
    self.label.frame = CGRectMake(5.0, 0.0, self.bounds.size.width - 10.0, self.bounds.size.height - 20.0);
    self.label.layer.cornerRadius = self.label.frame.size.height / 2.0;
    self.label.clipsToBounds = YES;
    
    self.label.text = self.headerTitle;
    
    if ([[[ARTUserInfo sharedInstance] getVisualTheme] isEqual:@"white"]) {
        self.label.backgroundColor = [UIColor lightBlueColor]; //darkmode
        self.label.layer.borderColor = [UIColor blackColor].CGColor; //darkmode
        self.label.layer.borderWidth = 1.0; //darkmode
    } else {
        self.label.backgroundColor = [UIColor darkBlueColor];
        self.label.layer.borderColor = [UIColor blueNavBarColor].CGColor;
        self.label.layer.borderWidth = 1.5; //darkmode
    }
    
    
    self.label.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    
    self.backView.frame = CGRectMake(0.0,0.0,self.bounds.size.width,self.label.bounds.size.height / 2.0);
    if ([[[ARTUserInfo sharedInstance] getVisualTheme] isEqual:@"white"]) {
        self.backView.backgroundColor = [UIColor lightBackgroundColor]; //lightmode - white for non-dark
    } else {
        self.backView.backgroundColor = [UIColor darkBackgroundColor]; //darkmode
    }
    self.backView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    
}


@end
