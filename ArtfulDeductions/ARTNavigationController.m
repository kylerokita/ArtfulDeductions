//
//  ARTNavigationController.m
//  Artful Deductions
//
//  Created by Kyle Rokita on 8/4/14.
//  Copyright (c) 2014 Artful Deductions LLC. All rights reserved.
//

#import "ARTNavigationController.h"
#import "URBAlertView.h"
#import "UIColor+Extensions.h"
#import "ARTConstants.h"


const CGFloat alertTitleFontSizeIphone5 = 21.0;
const CGFloat alertTitleFontSizeIphone6 = 24.0;
const CGFloat alertTitleFontSizeIpad = 34.0;

const CGFloat alertMessageFontSizeIphone5 = 15.0;
const CGFloat alertMessageFontSizeIphone6 = 18.0;
const CGFloat alertMessageFontSizeIpad = 26.0;

@interface ARTNavigationController ()

@end

@implementation ARTNavigationController


- (void)viewDidLoad {
    [super viewDidLoad];
    
    //[self.navigationBar setBackgroundImage:[UIImage imageNamed:@"ARTLogoBW"] forBarMetrics:UIBarMetricsDefault];
    [self.navigationBar setBackgroundImage:[UIImage new]forBarMetrics:UIBarMetricsDefault];
    self.navigationBar.shadowImage = [UIImage new];
    self.navigationBar.translucent = YES;
    
    [self setupAlertViewAppearance];

}

- (void) setupAlertViewAppearance {
    [URBAlertView appearance].buttonStrokeColor = [UIColor whiteColor]; //this is the border color
    [URBAlertView appearance].buttonStrokeWidth = 1.0; //this is the border width
    
    [URBAlertView appearance].strokeColor = [UIColor clearColor]; //this is the border color
    [URBAlertView appearance].strokeWidth = 1.0; //this is the border width
    
    [URBAlertView appearance].backgroundColor = [[UIColor darkBlueColor] colorWithAlphaComponent:1.0];
    [URBAlertView appearance].buttonBackgroundColor = [[UIColor darkBlueColor] colorWithAlphaComponent:1.0];
    [URBAlertView appearance].cancelButtonBackgroundColor = [[UIColor darkBlueColor] colorWithAlphaComponent:1.0];

    
    [URBAlertView appearance].titleShadowOffset = CGSizeMake(0.0, 0.0);
    [URBAlertView appearance].titleShadowColor = [UIColor clearColor];
    
    [URBAlertView appearance].messageShadowOffset = CGSizeMake(0.0, 0.0);
    [URBAlertView appearance].messageShadowColor = [UIColor clearColor];
    
    [URBAlertView appearance].cornerRadius = 15.0;
    
    
    
    UIFont *titleFont;
    if (IS_IPAD) {
        titleFont = [UIFont fontWithName:@"HelveticaNeue-Medium" size:alertTitleFontSizeIpad];
    }
    else if (IS_IPHONE_6 || IS_IPHONE_6Plus) {
        titleFont = [UIFont fontWithName:@"HelveticaNeue-Medium" size:alertTitleFontSizeIphone6];
    }
    else {
        titleFont = [UIFont fontWithName:@"HelveticaNeue-Medium" size:alertTitleFontSizeIphone5];
    }
    [[URBAlertView appearance] setTitleTextAttributes:@{NSFontAttributeName:titleFont}];
    
    UIFont *messageFont;
    if (IS_IPAD) {
        messageFont = [UIFont fontWithName:@"HelveticaNeue" size:alertMessageFontSizeIpad];
    }
    else if (IS_IPHONE_6 || IS_IPHONE_6Plus) {
        messageFont = [UIFont fontWithName:@"HelveticaNeue" size:alertMessageFontSizeIphone6];
    }
    else{
        messageFont = [UIFont fontWithName:@"HelveticaNeue" size:alertMessageFontSizeIphone5];
    }
    [[URBAlertView appearance] setMessageTextAttributes:@{NSFontAttributeName:messageFont}];
    
    UIFont *defaultButtonFont;
    if (IS_IPAD) {
        defaultButtonFont = [UIFont fontWithName:@"HelveticaNeue-Medium" size:24.0];
    }
    else if (IS_IPHONE_6Plus || IS_IPHONE_6) {
        defaultButtonFont = [UIFont fontWithName:@"HelveticaNeue-Medium" size:18.0];
    }
    else {
        defaultButtonFont = [UIFont fontWithName:@"HelveticaNeue-Medium" size:16.0];
    }
    [[URBAlertView appearance] setButtonTextAttributes:@{NSFontAttributeName:defaultButtonFont} forState:UIControlStateNormal];
    [[URBAlertView appearance] setButtonTextAttributes:@{NSFontAttributeName:defaultButtonFont} forState:UIControlStateHighlighted];
    
    UIFont *cancelButtonFont;
    if (IS_IPAD) {
        cancelButtonFont = [UIFont fontWithName:@"HelveticaNeue" size:24.0];
    }
    else if (IS_IPHONE_6Plus || IS_IPHONE_6) {
        cancelButtonFont = [UIFont fontWithName:@"HelveticaNeue" size:18.0];
    }
    else {
        cancelButtonFont = [UIFont fontWithName:@"HelveticaNeue" size:16.0];
    }
    [[URBAlertView appearance] setCancelButtonTextAttributes:@{NSFontAttributeName:cancelButtonFont} forState:UIControlStateNormal];
    [[URBAlertView appearance] setCancelButtonTextAttributes:@{NSFontAttributeName:cancelButtonFont} forState:UIControlStateHighlighted];

}

- (BOOL)shouldAutorotate
{
    return YES;
}

- (NSUInteger)supportedInterfaceOrientations
{
    if (self.landscapeOK) {
        // for iPhone, you could also return UIInterfaceOrientationMaskAllButUpsideDown
        return UIInterfaceOrientationMaskAll;
    }
    return UIInterfaceOrientationMaskPortrait;
}

- (UIModalPresentationStyle)adaptivePresentationStyleForPresentationController:(UIPresentationController *)controller {
    return UIModalPresentationOverCurrentContext;
}



@end
