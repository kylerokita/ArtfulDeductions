//
//  ARTSpeechBubleView.m
//  Artful Deductions
//
//  Created by Kyle Rokita on 10/22/14.
//  Copyright (c) 2014 Artful Deductions LLC. All rights reserved.
//

#import "ARTSpeechBubleView.h"
#import "ARTAvatar.h"
#import "ARTLabel.h"
#import "UIColor+Extensions.h"
#import "ARTSpeechLabel.h"
#import "ARTConstants.h"

@implementation ARTSpeechBubleView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

- (id)initWithFrame:(CGRect)frame andSpeechText:(NSString *)speechText {
    self = [super initWithFrame:frame];
    if (self) {
        self.speechText = speechText;
        
        self.speechLabel = [[ARTSpeechLabel alloc] initWithFrame:self.bounds];
        self.speechLabel.text = speechText;
        
        CGFloat fontSize;
        if (IS_IPAD) {
            fontSize = 28.0;
        } else if (IS_IPHONE_6Plus) {
            fontSize = 20.0;
        } else if (IS_IPHONE_6) {
            fontSize = 18.0;
        } else if (IS_IPHONE_5) {
            fontSize = 16.0;
        } else {
            fontSize = 16.0;
        }
        
        self.speechLabel.font = [UIFont fontWithName:@"HelveticaNeue-Italic" size:fontSize];
        self.speechLabel.textAlignment = NSTextAlignmentCenter;
        self.speechLabel.numberOfLines = 0;

        
        [self addSubview:self.speechLabel];

        self.backgroundColor = [UIColor clearColor];
        
        //self.layer.borderWidth = 1.0;
        //self.layer.borderColor = [UIColor redColor].CGColor;


        
    }
    return self;
}

- (void)drawRect:(CGRect)rect {
    
            CGContextRef ctx = UIGraphicsGetCurrentContext();
        CGRect aRect = CGRectMake((self.bounds.size.width * 0.02f), (self.bounds.size.height * 0.02f), (self.bounds.size.width * 0.96f), (self.bounds.size.height * 0.96f)); // set the rect with inset.
    
        CGContextSetFillColorWithColor( ctx, [UIColor whiteColor].CGColor );

        CGContextSetRGBStrokeColor(ctx, 0.0, 0.0, 0.0, 1.0); //black stroke
        CGContextSetLineWidth(ctx, 1.5);
        
        
        CGContextFillEllipseInRect(ctx, aRect);
        CGContextStrokeEllipseInRect(ctx, aRect);
    
    //x radius
    CGFloat a = aRect.size.width / 2.0;
    CGFloat b = aRect.size.height / 2.0;
    
    CGFloat h = aRect.origin.x + aRect.size.width / 2.0 + 2.;
    CGFloat k = aRect.origin.y + aRect.size.height / 2.0 + 0.;
    
    CGFloat x1 = self.bounds.size.width * 0.11;
    CGFloat y1 = sqrtf(((1 - ( (x1 - h) * (x1 - h)) / (a * a)) * (b * b))) + k;
    
    h = aRect.origin.x + aRect.size.width / 2.0 + 3.;
    k = aRect.origin.y + aRect.size.height / 2.0 + 0.;
    
    CGFloat x2 = self.bounds.size.width * 0.23;
    CGFloat y2 = sqrtf(((1 - ( (x2 - h) * (x2 - h)) / (a * a)) * (b * b))) + k;
    
        CGContextBeginPath(ctx);
    
    
    CGContextMoveToPoint(ctx, x1, y1);
    CGContextAddLineToPoint(ctx, (self.bounds.size.width * 0.09), (self.bounds.size.height *0.93f));
    CGContextAddLineToPoint(ctx, x2, y2);
    
    CGContextClosePath(ctx);
        CGContextFillPath(ctx);
        
        CGContextBeginPath(ctx);
    
    
    CGContextMoveToPoint(ctx, x1, y1);
    CGContextAddLineToPoint(ctx, (self.bounds.size.width * 0.09), (self.bounds.size.height *0.93f));
        CGContextStrokePath(ctx);
        
        CGContextBeginPath(ctx);
    
    
    CGContextMoveToPoint(ctx, (self.bounds.size.width * 0.09), (self.bounds.size.height *0.93f));
    CGContextAddLineToPoint(ctx, x2,y2);
        CGContextStrokePath(ctx);
    
}

@end
