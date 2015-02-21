//
//  ARTTopView.m
//  Artful Deductions
//
//  Created by Kyle Rokita on 10/13/14.
//  Copyright (c) 2014 Artful Deductions LLC. All rights reserved.
//

#import "ARTTopView.h"
#import "UIColor+Extensions.h"
#import "ARTUserInfo.h"
#import "ARTConstants.h"

@implementation ARTTopView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        
        [self myInitializer];

        
    }
    return self;
}

- (id)initWithCoder:(NSCoder *)aDecoder{
    self = [super initWithCoder:aDecoder];
    if (self) {
        // Initialization code
        
        [self myInitializer];
        
    }
    return self;
}

- (id)init {
    UIScreen *screen = [UIScreen mainScreen];
    
    CGFloat height;
    if (IS_IPAD) {
        height = 97.0;
    } else {
        height = 72.0;
    }
    
    CGRect frame = CGRectMake(screen.bounds.origin.x, screen.bounds.origin.y, screen.bounds.size.width, height);
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        
        [self myInitializer];
        
    }
    return self;
}

- (void) myInitializer {
    self.backgroundColor = [UIColor clearColor];
    
    //this shadow is important on the white topview
    self.layer.shadowOffset = CGSizeMake(0.0, 0.0);
    self.layer.shadowOpacity = 1.0;
    self.layer.shadowPath = [UIBezierPath bezierPathWithRect:self.bounds].CGPath;
    
    CAGradientLayer *gradient = [CAGradientLayer layer];
    gradient.frame = self.bounds;
    
    UIColor *topColor;
    UIColor *middleColor;
    UIColor *bottomColor;
    if ([[[ARTUserInfo sharedInstance] getVisualTheme] isEqual:@"white"]) {
        
        topColor = [UIColor colorWithWhite:1.0 alpha:1.0];
        middleColor = [UIColor colorWithWhite:1.0 alpha:1.0];
        bottomColor = [UIColor colorWithWhite:1.0 alpha:1.0];
        self.layer.shadowColor = [UIColor lightGrayColor].CGColor;
        self.layer.shadowRadius = 1.0;

        
    } else {
        topColor = [UIColor darkerGrayColor];
        middleColor = [UIColor darkerestGrayColor];
        bottomColor = [UIColor darkerestGrayColor];
        self.layer.shadowColor = [UIColor grayColor].CGColor;
        self.layer.shadowRadius = 0.0;

    }
    
    gradient.colors = [NSArray arrayWithObjects:(id)topColor.CGColor, (id)middleColor.CGColor, (id)bottomColor.CGColor, nil];
    gradient.locations = [NSArray arrayWithObjects:[NSNumber numberWithFloat:0.0] ,[NSNumber numberWithFloat:0.94],[NSNumber numberWithFloat:1.0], nil];;
    [self.layer insertSublayer:gradient atIndex:0];

}


@end
