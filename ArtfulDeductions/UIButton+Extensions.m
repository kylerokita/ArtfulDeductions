//
//  UIButton+Extensions.m
//  Artful Deductions
//
//  Created by Kyle Rokita on 9/12/14.
//  Copyright (c) 2014 Artful Deductions LLC. All rights reserved.
//

#import "UIButton+Extensions.h"
#import <QuartzCore/QuartzCore.h>
#import <objc/runtime.h>
#import "ARTConstants.h"
#import "UIColor+Extensions.h"
#import "UIImage+Customization.h"
#import "ARTImageHelper.h"
#import "ARTButton.h"


static const NSString *KEY_HIT_TEST_EDGE_INSETS = @"HitTestEdgeInsets";

@implementation UIButton (Extensions)

- (UIButton *)backButtonWith:(NSString *)title tintColor:(UIColor *)color target:(id)target andAction:(SEL)action {
    
    UIButton *backButton = [UIButton buttonWithType:UIButtonTypeCustom];
    
    UIFont *font;
    if (IS_IPAD) {
        font = [UIFont fontWithName:@"HelveticaNeue" size:29.0];
    } else {
        font = [UIFont fontWithName:@"HelveticaNeue" size:19.0];
    }
    
    NSMutableAttributedString *attrString = [[NSMutableAttributedString alloc] initWithString:title attributes:@{NSFontAttributeName:font,NSForegroundColorAttributeName:[UIColor blueNavBarColor]}];
    
    [backButton setAttributedTitle:attrString forState:UIControlStateNormal];
    
    
    CGSize maxShape;
    if (IS_IPAD) {
        maxShape= CGSizeMake(320.0, 20.5 * 2.);
    } else {
        maxShape= CGSizeMake(320.0, 20.5);

    }
    CGRect textRect = [title boundingRectWithSize:maxShape
                                                 options:(NSStringDrawingUsesLineFragmentOrigin|NSStringDrawingUsesFontLeading)
                                              attributes:[attrString attributesAtIndex:0 effectiveRange:nil]
                                                 context:nil];
    
    UIImage *backImage;
    if (IS_IPAD) {
        
        CGFloat updatedWidth = ceil(textRect.size.width) + 20.0 * 2.0;
        [backButton setFrame:CGRectMake(5., 28.0 + (44.0 - 20.5)/2.0, updatedWidth, 20.5 * 2.)];
        [backButton setTitleEdgeInsets:UIEdgeInsetsMake(0., 20. * 2., 0., 0.)];
    } else {
        
        CGFloat updatedWidth = ceil(textRect.size.width) + 20.0;
        [backButton setFrame:CGRectMake(5., 25.0 + (44.0 - 20.5)/2.0, updatedWidth, 20.5)];
        [backButton setTitleEdgeInsets:UIEdgeInsetsMake(0., 20., 0., 0.)];
    }
    
    backImage = [[[ARTImageHelper sharedInstance] getBackButtonImage] tintedWithColor:[UIColor blueNavBarColor] fraction:0.0];
    
    // setting the image for both states
    [backButton setBackgroundImage:[backImage resizableImageWithCapInsets:UIEdgeInsetsMake(backImage.size.width, backImage.size.height, backImage.size.width, backImage.size.height)] forState:UIControlStateNormal];
    [backButton setBackgroundImage:[[self image:backImage byApplyingAlpha:0.3] resizableImageWithCapInsets:UIEdgeInsetsMake(backImage.size.width, backImage.size.height, backImage.size.width, backImage.size.height)] forState:UIControlStateHighlighted];
    
    //[backButton setTitle:title forState:UIControlStateNormal];
    
    

    
    [backButton setTitleColor:color forState:UIControlStateNormal];
    const CGFloat* components = CGColorGetComponents(color.CGColor);
    [backButton setTitleColor:[UIColor colorWithRed:components[0] green:components[1] blue:components[2] alpha:0.3f] forState:UIControlStateHighlighted];
    
    [backButton addTarget:target action:action forControlEvents:UIControlEventTouchUpInside];
    //UIBarButtonItem *backButtonItem = [[UIBarButtonItem alloc] initWithCustomView:backButton];
    //[backButtonItem setTitle:title];
    
    [backButton setHitTestEdgeInsets:UIEdgeInsetsMake(-20, -20, -20, -20)];
    
    return backButton;
}

- (ARTButton *)giveUpButtonWith:(NSAttributedString *)title tintColor:(UIColor *)color target:(id)target andAction:(SEL)action {
    
    ARTButton *backButton = [ARTButton buttonWithType:UIButtonTypeCustom];
    [backButton makeGlossy];
    
    CGSize maxShape;
    if (IS_IPAD) {
        maxShape= CGSizeMake(320.0, 20.5 * 2.);
    } else {
        maxShape= CGSizeMake(320.0, 20.5);
        
    }
    NSString *tempString = title.string;
    CGRect textRect = [tempString boundingRectWithSize:maxShape
                                               options:(NSStringDrawingUsesLineFragmentOrigin|NSStringDrawingUsesFontLeading)
                                            attributes:[title attributesAtIndex:0 effectiveRange:nil]
                                               context:nil];
    tempString = nil;
    
    if (IS_IPAD) {
        CGFloat updatedWidth = ceil(textRect.size.width) + 5.0 * 2.0;
        
        [backButton setFrame:CGRectMake(5. * 2., 15.0 + (44.0 - 20.5)/2.0, updatedWidth, 34 * 2.)];
        
        [backButton setTitleEdgeInsets:UIEdgeInsetsMake(0., 0., 0., 0.)];
    } else {
        CGFloat updatedWidth = ceil(textRect.size.width) + 10.0;
        
        [backButton setFrame:CGRectMake(5., 14. + (44.0 - 20.5)/2.0, updatedWidth, 43.)];
        
        [backButton setTitleEdgeInsets:UIEdgeInsetsMake(0., 0., 0., 0.)];
    }
    
    
    [backButton setAttributedTitle:title forState:UIControlStateNormal];
    
    backButton.backgroundColor = [UIColor blueButtonColor];
    backButton.layer.cornerRadius = 15.0;
    backButton.clipsToBounds = YES;
    
    //[backButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    //const CGFloat* components = CGColorGetComponents(color.CGColor);
    //[backButton setTitleColor:[UIColor colorWithRed:components[0] green:components[1] blue:components[2] alpha:0.3f] forState:UIControlStateHighlighted];
    
    [backButton addTarget:target action:action forControlEvents:UIControlEventTouchUpInside];
    //UIBarButtonItem *backButtonItem = [[UIBarButtonItem alloc] initWithCustomView:backButton];
    //[backButtonItem setTitle:title];

    [backButton setHitTestEdgeInsets:UIEdgeInsetsMake(-20, -20, -20, -20)];
    
    
    return backButton;
}

- (UIButton *)rightButtonWith:(NSAttributedString *)title tintColor:(UIColor *)color target:(id)target andAction:(SEL)action withViewWidth:(CGFloat)viewWidth {
    
    UIButton *backButton = [UIButton buttonWithType:UIButtonTypeCustom];
    
    CGSize maxShape;
    if (IS_IPAD) {
        maxShape= CGSizeMake(320.0, 20.5 * 2.);
    } else {
        maxShape= CGSizeMake(320.0, 20.5);
        
    }
    NSString *tempString = title.string;
    CGRect textRect = [tempString boundingRectWithSize:maxShape
                                                 options:(NSStringDrawingUsesLineFragmentOrigin|NSStringDrawingUsesFontLeading)
                                              attributes:[title attributesAtIndex:0 effectiveRange:nil]
                                                 context:nil];
    tempString = nil;

    
    if (IS_IPAD) {
        CGFloat updatedWidth = ceil(textRect.size.width) + 20.0 * 2.0;
        
        [backButton setFrame:CGRectMake(viewWidth - updatedWidth - 5.0, 28.0 + (44.0 - 20.5)/2.0, updatedWidth, 20.5 * 2.)];

        
        [backButton setTitleEdgeInsets:UIEdgeInsetsMake(0., 20. * 2., 0., 0.)];
    } else {
        CGFloat updatedWidth = ceil(textRect.size.width) + 20.0;
        
        [backButton setFrame:CGRectMake(viewWidth - updatedWidth - 5.0, 25.0 + (44.0 - 20.5)/2.0, updatedWidth, 20.5)];

        [backButton setTitleEdgeInsets:UIEdgeInsetsMake(0., 20., 0., 0.)];
    }
    
    [backButton setAttributedTitle:title forState:UIControlStateNormal];
    
    [backButton setTitleColor:color forState:UIControlStateNormal];
    const CGFloat* components = CGColorGetComponents(color.CGColor);
    [backButton setTitleColor:[UIColor colorWithRed:components[0] green:components[1] blue:components[2] alpha:0.3f] forState:UIControlStateHighlighted];
    
    [backButton addTarget:target action:action forControlEvents:UIControlEventTouchUpInside];
    //UIBarButtonItem *backButtonItem = [[UIBarButtonItem alloc] initWithCustomView:backButton];
    //[backButtonItem setTitle:title];
    
    [backButton setHitTestEdgeInsets:UIEdgeInsetsMake(-20, -20, -20, -20)];
    
    
    return backButton;
}


- (UIImage *)image:(UIImage *)image byApplyingAlpha:(CGFloat) alpha {
    UIGraphicsBeginImageContextWithOptions(image.size, NO, 0.0);
    CGContextRef ctx = UIGraphicsGetCurrentContext();
    CGRect rect = CGRectMake(0, 0, image.size.width, image.size.height);
    CGContextScaleCTM(ctx, 1, -1);
    CGContextTranslateCTM(ctx, 0, -rect.size.height);
    CGContextSetBlendMode(ctx, kCGBlendModeMultiply);
    CGContextSetAlpha(ctx, alpha);
    CGContextDrawImage(ctx, rect, image.CGImage);
    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return newImage;
}

- (UIImage *)image:(UIImage *)image tintedWithColor:(UIColor *)color fraction:(CGFloat)fraction
{
    if ([UIScreen instancesRespondToSelector:@selector(scale)]) {
        UIGraphicsBeginImageContextWithOptions(image.size, NO, 0.0);
    } else {
        UIGraphicsBeginImageContext([image size]);
    }
    CGRect rect = CGRectZero;
    rect.size = image.size;
    [color set];
    UIRectFill(rect);
    [image drawInRect:rect blendMode:kCGBlendModeDestinationIn alpha:1.0];
    image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return image;
}

-(void)setHitTestEdgeInsets:(UIEdgeInsets)hitTestEdgeInsets {
    NSValue *value = [NSValue value:&hitTestEdgeInsets withObjCType:@encode(UIEdgeInsets)];
    objc_setAssociatedObject(self, &KEY_HIT_TEST_EDGE_INSETS, value, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

-(UIEdgeInsets)hitTestEdgeInsets {
    NSValue *value = objc_getAssociatedObject(self, &KEY_HIT_TEST_EDGE_INSETS);
    if(value) {
        UIEdgeInsets edgeInsets; [value getValue:&edgeInsets]; return edgeInsets;
    }else {
        return UIEdgeInsetsZero;
    }
}

- (BOOL)pointInside:(CGPoint)point withEvent:(UIEvent *)event {
    if(UIEdgeInsetsEqualToEdgeInsets(self.hitTestEdgeInsets, UIEdgeInsetsZero) ||       !self.enabled || self.hidden) {
        return [super pointInside:point withEvent:event];
    }
    
    CGRect relativeFrame = self.bounds;
    CGRect hitFrame = UIEdgeInsetsInsetRect(relativeFrame, self.hitTestEdgeInsets);
    
    return CGRectContainsPoint(hitFrame, point);
}

-(void)addImage:(UIImage *)image rightSide:(BOOL)rightIndicator withXOffset:(CGFloat)xOffset {
    
    UIImage *whiteImage = [image tintedWithColor:[UIColor whiteColor] fraction:0.0];
    
    NSString *text;
    UIFont *font;
    NSString *tempString = self.titleLabel.attributedText.string;
    if (tempString.length > 0) {
        text = tempString;
        font = [self.titleLabel.attributedText attribute:NSFontAttributeName atIndex:0 effectiveRange:nil];
    } else {
        text = self.titleLabel.text;
        font = self.titleLabel.font;
    }
    tempString  = nil;
    
    CGSize maxSize = CGSizeMake(MAXFLOAT, MAXFLOAT);
    
    CGRect textRect = [text boundingRectWithSize:maxSize
                                         options:(NSStringDrawingUsesLineFragmentOrigin|NSStringDrawingUsesFontLeading)
                                      attributes:@{NSFontAttributeName:font}
                                         context:nil];
    
    CGFloat height = ceil(textRect.size.height) * 0.9;
    CGFloat width = height;
    
    CGFloat x;
    if (rightIndicator) {
        x = (self.bounds.size.width - ceil(textRect.size.width))/2.0 + ceil(textRect.size.width) + xOffset;
    }
    else {
        x = (self.bounds.size.width - ceil(textRect.size.width))/2.0 - width - xOffset;

    }
    CGFloat y = (self.bounds.size.height - height)/2.0;
    
    UIImageView *imageView = [[UIImageView alloc]initWithImage:whiteImage];
    
    imageView.contentMode=UIViewContentModeScaleAspectFill;//or whichever mode works best for you
    [self addSubview:imageView];
    
    CGFloat xShift;
    if (rightIndicator) {
        xShift = - (width + xOffset) / 2.0;
        [self setTitleEdgeInsets:UIEdgeInsetsMake(0.0, xShift/2., 0.0, -xShift/2.)];

    }
    else {
        xShift = (width + xOffset) / 2.0;
        [self setTitleEdgeInsets:UIEdgeInsetsMake(0.0, xShift/2., 0.0, -xShift/2.)];

    }
    
    imageView.frame = CGRectMake(x + xShift, y, width, height);

    
}

@end

