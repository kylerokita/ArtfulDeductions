//
//  ARTAvatarImageView.h
//  Artful Deductions
//
//  Created by Kyle Rokita on 10/19/14.
//  Copyright (c) 2014 Artful Deductions LLC. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ARTAlertImageView : UIView

@property (strong, nonatomic) UIView *subRoundView;
@property (strong, nonatomic) UIImageView *subImageView;
@property (strong, nonatomic) UILabel *subCaptionLabel;

- (id)initWithFrame:(CGRect)frame Image:(UIImage *)image imageScale:(CGFloat)imageScale backgroundColor:(UIColor *)backgroundColor  captionText:(NSString *)captionText;

@end
