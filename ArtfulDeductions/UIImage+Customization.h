//
//  UIImage+Customization.h
//  Artful Deductions
//
//  Created by Kyle Rokita on 7/28/14.
//  Copyright (c) 2014 Artful Deductions LLC. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIImage (Customization)

- (UIImage*)cropWithPixelCount:(CGFloat)edgeToTrim;

+ (UIImage *)imageWithImage:(UIImage *)image scaledToSize:(CGSize)newSize;

- (UIImage *)imageByApplyingAlpha:(CGFloat) alpha;

+ (UIImage *)getBackgroundImageLight;

+ (UIImage *)getBackgroundImageDark;

- (UIImage *)colorizeWithColor:(UIColor *)color;

- (UIImage *)tintedWithColor:(UIColor *)color fraction:(CGFloat)fraction;

@end
