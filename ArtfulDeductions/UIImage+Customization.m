//
//  UIImage+Customization.m
//  Artful Deductions
//
//  Created by Kyle Rokita on 7/28/14.
//  Copyright (c) 2014 Artful Deductions LLC. All rights reserved.
//

#import "UIImage+Customization.h"
#import "ARTConstants.h"

@implementation UIImage (Customization)

- (UIImage*)cropWithPixelCount:(CGFloat)edgeToTrim {
    
    UIImage *ret = nil;
    
    // This calculates the crop area.
    
    float originalWidth  = self.size.width;
    float originalHeight = self.size.height;
    
    float posX;
    float posY;
    float edgeWidth;
    float edgeHeight;
    
    if (originalHeight > originalWidth) {
        posX = edgeToTrim;
        posY = edgeToTrim * hToWRatio;
        edgeWidth = (originalWidth - posX * 2);
        edgeHeight = (originalHeight - posY * 2);
    } else {
        posX = edgeToTrim / hToWRatio;
        posY = edgeToTrim;
        edgeWidth = (originalWidth - posY * 2);
        edgeHeight = (originalHeight - posX * 2);
    }
    
    CGRect cropSquare = CGRectMake(posX, posY, edgeWidth, edgeHeight);
    
    
    
    // This performs the image cropping.
    
    CGImageRef imageRef = CGImageCreateWithImageInRect([self CGImage], cropSquare);
    
    ret = [UIImage imageWithCGImage:imageRef
                              scale:self.scale
                        orientation:self.imageOrientation];
    
    CGImageRelease(imageRef);
    
    return ret;
}

+ (UIImage *)imageWithImage:(UIImage *)image scaledToSize:(CGSize)newSize {
    //UIGraphicsBeginImageContext(newSize);
    // In next line, pass 0.0 to use the current device's pixel scaling factor (and thus account for Retina resolution).
    // Pass 1.0 to force exact pixel size.
    UIGraphicsBeginImageContextWithOptions(newSize, NO, 0.0);
    [image drawInRect:CGRectMake(0, 0, newSize.width, newSize.height)];
    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return newImage;
}

- (UIImage *)imageByApplyingAlpha:(CGFloat) alpha {
    UIGraphicsBeginImageContextWithOptions(self.size, NO, 0.0f);
    
    CGContextRef ctx = UIGraphicsGetCurrentContext();
    CGRect area = CGRectMake(0, 0, self.size.width, self.size.height);
    
    CGContextScaleCTM(ctx, 1, -1);
    CGContextTranslateCTM(ctx, 0, -area.size.height);
    
    CGContextSetBlendMode(ctx, kCGBlendModeMultiply);
    
    CGContextSetAlpha(ctx, alpha);
    
    CGContextDrawImage(ctx, area, self.CGImage);
    
    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
    
    UIGraphicsEndImageContext();
    
    return newImage;
}

+ (UIImage *)getBackgroundImageDark {
    CGRect viewBounds = [UIScreen mainScreen].bounds;
    CGSize screenSize = viewBounds.size;

    
    UIGraphicsBeginImageContext(screenSize);
    //NSString * filePath = [[NSBundle mainBundle] pathForResource:@"Diagonal39" ofType:@"png"];
    
    //UIImage *origImage = [UIImage imageWithContentsOfFile:filePath];
    UIImage *origImage = [UIImage imageNamed:@"StripeBlack"];
    [origImage drawInRect:viewBounds];
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return image;
}

+ (UIImage *)getBackgroundImageLight {
    CGRect viewBounds = [UIScreen mainScreen].bounds;
    CGSize screenSize = viewBounds.size;
    
    
    UIGraphicsBeginImageContext(screenSize);
    //NSString * filePath = [[NSBundle mainBundle]
                           //pathForResource:@"stripes4"
                           //ofType:@"jpg"];
    
    //UIImage *origImage = [UIImage imageWithContentsOfFile:filePath];
    UIImage *origImage = [UIImage imageNamed:@"StripeWhite"];

    [origImage drawInRect:viewBounds];
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return image;
}

- (UIImage *)colorizeWithColor:(UIColor *)color {
    UIGraphicsBeginImageContext(self.size);
    
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGRect area = CGRectMake(0, 0, self.size.width, self.size.height);
    
    CGContextScaleCTM(context, 1, -1);
    CGContextTranslateCTM(context, 0, -area.size.height);
    
    CGContextSaveGState(context);
    CGContextClipToMask(context, area, self.CGImage);
    
    [color set];
    CGContextFillRect(context, area);
    
    CGContextRestoreGState(context);
    
    CGContextSetBlendMode(context, kCGBlendModeMultiply);
    
    CGContextDrawImage(context, area, self.CGImage);
    
    UIImage *colorizedImage = UIGraphicsGetImageFromCurrentImageContext();
    
    UIGraphicsEndImageContext();
    
    return colorizedImage;
}

- (UIImage *)tintedWithColor:(UIColor *)color fraction:(CGFloat)fraction
{
    if ([UIScreen instancesRespondToSelector:@selector(scale)]) {
        UIGraphicsBeginImageContextWithOptions(self.size, NO, 0.0f);
    } else {
        UIGraphicsBeginImageContext([self size]);
    }
    CGRect rect = CGRectZero;
    rect.size = self.size;
    [color set];
    UIRectFill(rect);
    [self drawInRect:rect blendMode:kCGBlendModeDestinationIn alpha:1.0];
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return image;
}

@end
