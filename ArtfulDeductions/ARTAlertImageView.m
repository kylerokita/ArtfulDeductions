//
//  ARTAvatarImageView.m
//  Artful Deductions
//
//  Created by Kyle Rokita on 10/19/14.
//  Copyright (c) 2014 Artful Deductions LLC. All rights reserved.
//

#import "ARTAlertImageView.h"
#import "ARTAvatar.h"
#import "UIColor+Extensions.h"
#import "ARTConstants.h"

@implementation ARTAlertImageView


- (id)initWithFrame:(CGRect)frame Image:(UIImage *)image imageScale:(CGFloat)imageScale backgroundColor:(UIColor *)backgroundColor  captionText:(NSString *)captionText{
    
    self = [super initWithFrame:frame];
    if (self) {
                
        //self.layer.cornerRadius = self.bounds.size.height / 2.0;
        self.clipsToBounds = NO;
        self.backgroundColor = [UIColor clearColor];
        
        self.subRoundView = [[UIView alloc] initWithFrame:self.bounds];
        self.subRoundView.backgroundColor = backgroundColor;
        self.subRoundView.layer.borderColor = [UIColor whiteColor].CGColor;
        self.subRoundView.layer.borderWidth = 1.5;
        self.subRoundView.clipsToBounds = YES;
        self.subRoundView.opaque = YES;
        self.subRoundView.layer.cornerRadius = self.subRoundView.frame.size.height / 2.0;
        [self addSubview:self.subRoundView];

        
        self.subImageView = [[UIImageView alloc] initWithFrame:self.bounds];
        self.subImageView.contentMode = UIViewContentModeScaleAspectFill;
        self.subImageView.transform = CGAffineTransformMakeScale(imageScale, imageScale);
        
        self.subImageView.image = image;
        self.subImageView.backgroundColor = self.backgroundColor;
        self.subImageView.opaque = YES;
        
        [self.subRoundView addSubview:self.subImageView];
        
        if (captionText) {
            UIFont *font;
            if (IS_IPAD) {
                font = [UIFont fontWithName:@"HelveticaNeue-Light" size:18.0];
            } else {
                font = [UIFont fontWithName:@"HelveticaNeue-Light" size:13.0];
            }
            
            CGSize maximumLabelSize = CGSizeMake(MAXFLOAT, MAXFLOAT);

            CGRect textRect = [captionText boundingRectWithSize:maximumLabelSize
                                                       options:(NSStringDrawingUsesLineFragmentOrigin|NSStringDrawingUsesFontLeading)
                                                    attributes:@{NSFontAttributeName:font}
                                                       context:nil];
            
            CGFloat height = ceil(textRect.size.height) + 5.0;
            CGFloat width = ceil(textRect.size.width) + 14.0;
            CGRect captionRect = CGRectMake(0.0, 0.0, width, height);

            self.subCaptionLabel = [[UILabel alloc] initWithFrame:captionRect];
            
            CGFloat yOffset;
            if (IS_IPAD) {
                yOffset = 8.0;
            } else {
                yOffset = 8.0;
            }
            
            CGPoint captionCenter = CGPointMake(self.bounds.size.width/2.0, self.bounds.size.height-yOffset);
            self.subCaptionLabel.center = captionCenter;

            self.subCaptionLabel.text = captionText;
            self.subCaptionLabel.font = font;
            self.subCaptionLabel.textColor = [UIColor whiteColor];
            self.subCaptionLabel.textAlignment = NSTextAlignmentCenter;
            self.subCaptionLabel.layer.cornerRadius = 5.0;
            self.subCaptionLabel.backgroundColor = [UIColor darkGrayColor];
            self.subCaptionLabel.layer.borderColor = [UIColor whiteColor].CGColor;
            self.subCaptionLabel.layer.borderWidth = 1.0;
            self.subCaptionLabel.clipsToBounds = YES;
            [self addSubview:self.subCaptionLabel];
        }
        

    }
    return self;
}


@end
