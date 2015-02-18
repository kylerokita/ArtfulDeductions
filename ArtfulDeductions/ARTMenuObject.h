//
//  ARTMenuObject.h
//  ArtfulDeductions
//
//  Created by Kyle Rokita on 7/2/14.
//  Copyright (c) 2014 Artful Deductions LLC. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ARTMenuObject : UIView

@property (strong, nonatomic) NSMutableArray *arrayOfButtons;
@property (nonatomic) NSInteger buttonCount;

- (ARTMenuObject *)initWithButtonCount:(NSInteger)buttonCount withFrame:(CGRect)shape withPortraitIndicator:(BOOL)portraitIndicator;

- (ARTMenuObject *)initWithButtonCount:(NSInteger)buttonCount buttonWidthProportions:(NSArray *)proportionArray withFrame:(CGRect)shape withPortraitIndicator:(BOOL)portraitIndicator;

- (void)setupWithButtonCount:(NSInteger)buttonCount withFrame:(CGRect)shape withPortraitIndicator:(BOOL)portraitIndicator;

- (void)setupWithButtonCount:(NSInteger)buttonCount buttonWidthProportions:(NSArray *)proportionArray withFrame:(CGRect)shape withPortraitIndicator:(BOOL)portraitIndicator;

@end
