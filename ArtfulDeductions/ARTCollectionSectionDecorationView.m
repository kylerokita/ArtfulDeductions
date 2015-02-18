//
//  ARTCollectionSectionDecorationView.m
//  Artful Deductions
//
//  Created by Kyle Rokita on 10/10/14.
//  Copyright (c) 2014 Artful Deductions LLC. All rights reserved.
//

#import "ARTCollectionSectionDecorationView.h"
#import "UIColor+Extensions.h"
#import "ARTUserInfo.h"
#import "ARTConstants.h"

@implementation ARTCollectionSectionDecorationView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        
        if ([[[ARTUserInfo sharedInstance] getVisualTheme] isEqual:@"white"]) {
            self.backgroundColor = [UIColor whiteColor];
            self.layer.borderColor = [UIColor blueNavBarColor].CGColor;
            
            if (IS_IPAD) {
                self.layer.borderWidth = 2.0;
            } else {
                self.layer.borderWidth = 1.5;
            }

        } else {
            self.backgroundColor = [UIColor detailViewBlueColor];
            self.layer.borderColor = [UIColor blueNavBarColor].CGColor;

            if (IS_IPAD) {
                self.layer.borderWidth = 2.0;
            } else {
                self.layer.borderWidth = 1.0;
            }
        }

        self.layer.cornerRadius = 20.0;
        
    }
    return self;
}


@end
