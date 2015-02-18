//
//  ARTMenuObject.m
//  ArtfulDeductions
//
//  Created by Kyle Rokita on 7/2/14.
//  Copyright (c) 2014 Artful Deductions LLC. All rights reserved.
//

#import "ARTMenuObject.h"
#import "ARTButton.h"
#import "ARTUserInfo.h"
#import "ARTConstants.h"


@implementation ARTMenuObject

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

- (ARTMenuObject *)initWithButtonCount:(NSInteger)buttonCount buttonWidthProportions:(NSArray *)proportionArray withFrame:(CGRect)shape withPortraitIndicator:(BOOL)portraitIndicator {
    
    self = [super initWithFrame:shape];
    if (self) {

        self.backgroundColor = [UIColor clearColor];
        
        // border radius
        [self.layer setCornerRadius:15.0];
        self.layer.masksToBounds = YES;

        self.arrayOfButtons = [[NSMutableArray alloc] init];
        
        // setup view index that adds an extra view in between each button
        NSInteger viewIndex = (buttonCount * 2) - 1;
        NSInteger seperatorCount = buttonCount - 1;
        
        CGFloat seperatorWidth;
        if (IS_IPAD) {
            seperatorWidth = 3.0;
        } else {
            seperatorWidth = 2.0;
        }
        
        CGFloat totalMenuWidth = 0.0;
        
        for (int i = 0; i < viewIndex; i++) {
            
            int buttonIndex = floorf(( i / 2.0 )) + 1;
            int seperatorIndex = ceilf(( i / 2.0 ));
            
            CGFloat buttonWidth;
            CGFloat buttonHeight;
            
            if (portraitIndicator) {
                buttonWidth = self.bounds.size.width;
                buttonHeight = (self.bounds.size.height - seperatorWidth * seperatorCount ) * [(NSNumber *)proportionArray[buttonIndex-1] floatValue];
            } else {
                buttonWidth = (self.bounds.size.width - seperatorWidth * seperatorCount ) * [(NSNumber *)proportionArray[buttonIndex-1] floatValue];
                buttonHeight = self.bounds.size.height;
            }
            
            if (i % 2 == 0) {
                
                
                CGFloat buttonX;
                CGFloat buttonY;
            
                if (portraitIndicator) {
                    buttonX = 0.0;
                    buttonY = totalMenuWidth;
                } else {
                    buttonX = totalMenuWidth;
                    buttonY = 0.0;
                }
                
                if (portraitIndicator) {
                    totalMenuWidth = totalMenuWidth + buttonHeight;
                    
                } else {
                    totalMenuWidth = totalMenuWidth + buttonWidth;
                }
                
                CGRect buttonShape = CGRectMake(buttonX, buttonY, buttonWidth, buttonHeight);
                ARTButton *button = [[ARTButton alloc] initWithFrame:buttonShape];
                
               
                [self addSubview:button];
        
                [self.arrayOfButtons addObject:button];
            }
            
            if (i % 2 == 1) {
                CGFloat viewWidth;
                CGFloat viewHeight;
                CGFloat viewX;
                CGFloat viewY;
                
                if (portraitIndicator) {
                    viewWidth = self.bounds.size.width;
                    viewHeight = seperatorWidth;
                    viewX = 0.0;
                    viewY = totalMenuWidth;
                } else {
                    viewWidth = seperatorWidth;
                    viewHeight = self.bounds.size.height;
                    viewX = totalMenuWidth;
                    viewY = 0.0;
                }
                
                CGRect viewShape = CGRectMake(viewX, viewY, viewWidth, viewHeight);
                UIView *view = [[UIView alloc] initWithFrame:viewShape];
                
                if (portraitIndicator) {
                    totalMenuWidth = totalMenuWidth + seperatorWidth;
                    
                } else {
                    totalMenuWidth = totalMenuWidth + seperatorWidth;
                }
                
                
                if ([[[ARTUserInfo sharedInstance] getVisualTheme] isEqual:@"white"]) {
                    
                    view.backgroundColor = [UIColor whiteColor];
                    
                } else {
                    view.backgroundColor = [UIColor blackColor];
                }
                

                [self addSubview:view];
                
            }
            


        }
        self.buttonCount = buttonCount;

    }
    
    return self;
}

- (ARTMenuObject *)initWithButtonCount:(NSInteger)buttonCount withFrame:(CGRect)shape withPortraitIndicator:(BOOL)portraitIndicator {
    
    NSMutableArray *proportionArray = [NSMutableArray new];
    for (NSInteger i = 0; i < buttonCount; i++) {
        NSNumber *proportionNumber = [NSNumber numberWithFloat:1./buttonCount];
        [proportionArray addObject:proportionNumber];
    }
    
    self = [self initWithButtonCount:buttonCount buttonWidthProportions:proportionArray withFrame:shape withPortraitIndicator:portraitIndicator];
    if (self) {
        
        
    }
    
    return self;
}

- (void)setupWithButtonCount:(NSInteger)buttonCount buttonWidthProportions:(NSArray *)proportionArray withFrame:(CGRect)shape withPortraitIndicator:(BOOL)portraitIndicator {
    
    self.backgroundColor = [UIColor clearColor];
        
    // border radius
    [self.layer setCornerRadius:15.0];
    self.layer.masksToBounds = YES;
    
        self.arrayOfButtons = [[NSMutableArray alloc] init];
        
        // setup view index that adds an extra view in between each button
        NSInteger viewIndex = (buttonCount * 2) - 1;
        NSInteger seperatorCount = buttonCount - 1;
        
    CGFloat seperatorWidth;
    if (IS_IPAD) {
        seperatorWidth = 3.0;
    } else {
        seperatorWidth = 2.0;
    }
        CGFloat totalMenuWidth = 0.0;

    
        for (int i = 0; i < viewIndex; i++) {
            
            int buttonIndex = floorf(( i / 2.0 )) + 1;
            int seperatorIndex = ceilf(( i / 2.0 ));
            
            CGFloat buttonWidth;
            CGFloat buttonHeight;
            
            if (portraitIndicator) {
                buttonWidth = self.bounds.size.width;
                buttonHeight = (self.bounds.size.height - seperatorWidth * seperatorCount ) * [(NSNumber *)proportionArray[buttonIndex-1] floatValue];
;
            } else {
                buttonWidth = (self.bounds.size.width - seperatorWidth * seperatorCount ) * [(NSNumber *)proportionArray[buttonIndex-1] floatValue];
;
                buttonHeight = self.bounds.size.height;
            }

            
            if (i % 2 == 0) {
                
                
                CGFloat buttonX;
                CGFloat buttonY;
                
                if (portraitIndicator) {
                    buttonX = 0.0;
                    buttonY = totalMenuWidth;
                } else {
                    buttonX = totalMenuWidth;
                    buttonY = 0.0;
                }
                
                CGRect buttonShape = CGRectMake(buttonX, buttonY, buttonWidth, buttonHeight);
                ARTButton *button = [[ARTButton alloc] initWithFrame:buttonShape];
                
                if (portraitIndicator) {
                    totalMenuWidth = totalMenuWidth + buttonHeight;
                    
                } else {
                    totalMenuWidth = totalMenuWidth + buttonWidth;
                }
                
                [self addSubview:button];
                
                [self.arrayOfButtons addObject:button];
            }
            
            if (i % 2 == 1) {
                CGFloat viewWidth;
                CGFloat viewHeight;
                CGFloat viewX;
                CGFloat viewY;
                
                if (portraitIndicator) {
                    viewWidth = self.bounds.size.width;
                    viewHeight = seperatorWidth;
                    viewX = 0.0;
                    viewY = totalMenuWidth;
                } else {
                    viewWidth = seperatorWidth;
                    viewHeight = self.bounds.size.height;
                    viewX = totalMenuWidth;
                    viewY = 0.0;
                }
                
                CGRect viewShape = CGRectMake(viewX, viewY, viewWidth, viewHeight);
                UIView *view = [[UIView alloc] initWithFrame:viewShape];
                
                if (portraitIndicator) {
                    totalMenuWidth = totalMenuWidth + seperatorWidth;
                    
                } else {
                    totalMenuWidth = totalMenuWidth + seperatorWidth;
                }
                
                if ([[[ARTUserInfo sharedInstance] getVisualTheme] isEqual:@"white"]) {
                    
                    view.backgroundColor = [UIColor whiteColor];
                    
                } else {
                    view.backgroundColor = [UIColor blackColor];
                }
                
                [self addSubview:view];
                
            }
            
        }
    self.buttonCount = buttonCount;
        
}


- (void)setupWithButtonCount:(NSInteger)buttonCount withFrame:(CGRect)shape withPortraitIndicator:(BOOL)portraitIndicator {
    
    NSMutableArray *proportionArray = [NSMutableArray new];
    for (NSInteger i = 0; i < buttonCount; i++) {
        NSNumber *proportionNumber = [NSNumber numberWithFloat:1./buttonCount];
        [proportionArray addObject:proportionNumber];
    }

    [self setupWithButtonCount:buttonCount buttonWidthProportions:proportionArray withFrame:shape withPortraitIndicator:portraitIndicator];
    
}




@end
