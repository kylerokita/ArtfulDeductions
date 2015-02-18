//
//  UIButton+Extensions.h
//  Artful Deductions
//
//  Created by Kyle Rokita on 9/12/14.
//  Copyright (c) 2014 Artful Deductions LLC. All rights reserved.
//

#import <UIKit/UIKit.h>

@class ARTButton;

@interface UIButton (Extensions)

- (UIButton *)backButtonWith:(NSString *)title tintColor:(UIColor *)color target:(id)target andAction:(SEL)action ;

- (ARTButton *)giveUpButtonWith:(NSAttributedString *)title tintColor:(UIColor *)color target:(id)target andAction:(SEL)action;

- (UIButton *)rightButtonWith:(NSAttributedString *)title tintColor:(UIColor *)color target:(id)target andAction:(SEL)action withViewWidth:(CGFloat)viewWidth;

-(void)addImage:(UIImage *)image rightSide:(BOOL)rightIndicator withXOffset:(CGFloat)xOffset;

@property(nonatomic, assign) UIEdgeInsets hitTestEdgeInsets;


@end
