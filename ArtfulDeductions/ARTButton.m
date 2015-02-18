//
//  ARTButton.m
//  Artful Deductions
//
//  Created by Kyle Rokita on 8/2/14.
//  Copyright (c) 2014 Artful Deductions LLC. All rights reserved.
//

#import "ARTButton.h"
#import "ARTMenuObject.h"
#import "ARTUserInfo.h"
#import "UIColor+Extensions.h"

CGFloat const highGradientMultiplier = 1.0/1.0;
CGFloat const lowGradientMultiplier = 1.0/1.3;

CGFloat const buttonPressDelay = 0.15;

@implementation ARTButton

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {

        [self makeGlossy];
        
    }
    return self;
}

- (id)init
{
    self = [super init];
    if (self) {
        
        [self makeGlossy];
        
    }
    return self;
}

- (id)initWithCoder:(NSCoder *)aDecoder //used with interfacebuilder
{
    self = [super initWithCoder:aDecoder];
    if (self) {
        
        [self makeGlossy];
        
    }
    return self;
}


- (id)applyStandardFormatting {
    
    self.layer.cornerRadius = 15.0;
    self.clipsToBounds = YES;
    
    return self;
}



- (void)setHighlighted:(BOOL)highlighted {
//do nothing
    
}

- (void)setCustomHighlighted:(BOOL)highlighted {
    
    if (highlighted) {
        ((CALayer *)self.layer.sublayers[0]).backgroundColor = [ARTButton getButtonColorForHighlighted:YES].CGColor;
    
     
    } else {
        ((CALayer *)self.layer.sublayers[0]).backgroundColor = [ARTButton getButtonColorForHighlighted:NO].CGColor;
        
     }
    
    if (highlighted) {
        NSNumber *boolNumber = [NSNumber numberWithBool:NO];
        [self performSelector:@selector(setCustomHighlighted:) withObject:boolNumber afterDelay:buttonPressDelay inModes:[NSArray arrayWithObject:NSRunLoopCommonModes]];
    }
    
}

- (void)setCustomEnabled:(BOOL)enabled {

    UIColor *color;
    
    if (!enabled) {
        ((CALayer *)self.layer.sublayers[0]).backgroundColor = [ARTButton getButtonColorForHighlighted:YES].CGColor;
        
        color = [UIColor lightGrayColor];
        
        self.enabled = NO;
        
    } else {
        ((CALayer *)self.layer.sublayers[0]).backgroundColor = [ARTButton getButtonColorForHighlighted:NO].CGColor;
        
        color = [UIColor whiteColor];
        
        self.enabled = YES;

    }
    
    NSMutableAttributedString *mutableString = [[NSMutableAttributedString alloc] initWithAttributedString:self.titleLabel.attributedText];
    
    NSRange range = NSMakeRange(0, [mutableString length]);
    [mutableString removeAttribute:NSForegroundColorAttributeName range:range];
    [mutableString addAttribute:NSForegroundColorAttributeName value:color range:range];
    
    self.titleLabel.attributedText = mutableString;

    
}

- (void)setEmergencyRed {
    
    ((CALayer *)self.layer.sublayers[0]).backgroundColor = [UIColor emergencyRedColor].CGColor;
    

    
}

- (void)makeGlossy
{
    
    self.backgroundColor = [ARTButton getButtonColorForHighlighted:NO];
    
    CALayer *thisLayer = self.layer;
    
    //remove other gloss layers if already added
    if ([thisLayer sublayers] > 0) {
        CALayer *backgroundLayer = [thisLayer sublayers][0];
        [backgroundLayer removeFromSuperlayer];
    }
    
    [self layoutIfNeeded];
    
    // Add backgorund color layer and make original background clear
    CALayer *backgroundLayer = [CALayer layer];
    backgroundLayer.frame = thisLayer.bounds;

    backgroundLayer.backgroundColor=self.backgroundColor.CGColor;
    [thisLayer insertSublayer:backgroundLayer atIndex:0];
	
    

    thisLayer.backgroundColor=[UIColor colorWithWhite:0.0 alpha:0.0].CGColor;
	
    // Add gloss to the background layer
    CAGradientLayer *glossLayer = [CAGradientLayer layer];
    glossLayer.frame = thisLayer.bounds;
    
    if ([[[ARTUserInfo sharedInstance] getVisualTheme] isEqual:@"white"]) {
        glossLayer.colors = [NSArray arrayWithObjects:
                             (id)[UIColor colorWithWhite:1.0 alpha:0.35].CGColor,
                             (id)[UIColor colorWithWhite:1.0 alpha:0.0].CGColor,
                             
                             
                             nil];
        glossLayer.locations = [NSArray arrayWithObjects:
                                [NSNumber numberWithFloat:0.0],
                                [NSNumber numberWithFloat:1.0],
                                nil];
        
    } else {
        glossLayer.colors = [NSArray arrayWithObjects:
                             (id)[UIColor colorWithWhite:1.0 alpha:0.35].CGColor,
                             (id)[UIColor colorWithWhite:1.0 alpha:0.0].CGColor,
                             
                             
                             nil];
        glossLayer.locations = [NSArray arrayWithObjects:
                                [NSNumber numberWithFloat:0.0],
                                [NSNumber numberWithFloat:1.0],
                                nil];
    }
    
    [backgroundLayer addSublayer:glossLayer];


}

+ (UIColor *) getButtonColorForHighlighted:(BOOL)isHighlighted {
    
    UIColor *color;
    
    if ([[[ARTUserInfo sharedInstance] getVisualTheme] isEqual:@"white"]) {
        
        color = [UIColor colorWithRed:.288*highGradientMultiplier green:.484*highGradientMultiplier blue:.8*highGradientMultiplier alpha:1.0];
        
    } else {
        color = [UIColor colorWithRed:.288*lowGradientMultiplier green:.484*lowGradientMultiplier blue:.8*lowGradientMultiplier alpha:1.0];
    }
    
    if (isHighlighted) {
        const CGFloat* colors = CGColorGetComponents( color.CGColor );
        CGFloat red = colors[0] * 0.5;
        CGFloat green = colors[1] * 0.5;
        CGFloat blue = colors[2] * 0.5;
        CGFloat alpha = colors[3];

        color = [UIColor colorWithRed:red green:green blue:blue alpha:alpha];
    
    }
    
    return color;
}

+ (UIColor *) getButtonColorForBlinked:(BOOL)isBlinked {
    
    UIColor *color;
    
    if ([[[ARTUserInfo sharedInstance] getVisualTheme] isEqual:@"white"]) {
        
        color = [UIColor colorWithRed:.288*highGradientMultiplier green:.484*highGradientMultiplier blue:.8*highGradientMultiplier alpha:1.0];
        
    } else {
        color = [UIColor colorWithRed:.288*lowGradientMultiplier green:.484*lowGradientMultiplier blue:.8*lowGradientMultiplier alpha:1.0];
    }
    
    if (isBlinked) {
        const CGFloat* colors = CGColorGetComponents( color.CGColor );
        CGFloat red = colors[0] * 1.4;
        CGFloat green = colors[1] * 1.4;
        CGFloat blue = colors[2] * 1.4;
        CGFloat alpha = colors[3];
        
        color = [UIColor colorWithRed:red green:green blue:blue alpha:alpha];
        
    }
    
    return color;
}

@end
