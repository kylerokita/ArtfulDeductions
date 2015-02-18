//
//  ARTSpeechBubleView.h
//  Artful Deductions
//
//  Created by Kyle Rokita on 10/22/14.
//  Copyright (c) 2014 Artful Deductions LLC. All rights reserved.
//

#import <UIKit/UIKit.h>

@class ARTAvatar;
@class ARTAvatarImageView;
@class ARTSpeechLabel;

@interface ARTSpeechBubleView : UIView

@property (strong, nonatomic) NSString *speechText;
@property (strong, nonatomic) ARTSpeechLabel *speechLabel;


- (id)initWithFrame:(CGRect)frame andSpeechText:(NSString *)speechText;

@end
