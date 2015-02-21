//
//  ARTConstants.h
//  Artful Deductions
//
//  Created by Kyle Rokita on 9/30/14.
//  Copyright (c) 2014 Artful Deductions LLC. All rights reserved.
//

#import <Foundation/Foundation.h>

#define IS_IPAD (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)
#define IS_IPHONE (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone)
#define IS_OldIphone (!IS_IPHONE_5 && !IS_IPHONE_6 && !IS_IPHONE_6Plus && !IS_IPAD)
#define IS_IPHONE_5 (IS_IPHONE && ([[UIScreen mainScreen] bounds].size.height == 568.0 || [[UIScreen mainScreen] bounds].size.width == 568.0))
#define IS_IPHONE_6 (IS_IPHONE && ([[UIScreen mainScreen] bounds].size.height == 667.0 || [[UIScreen mainScreen] bounds].size.width == 667.0))
#define IS_IPHONE_6Plus (IS_IPHONE && ([[UIScreen mainScreen] bounds].size.height == 736.0 || [[UIScreen mainScreen] bounds].size.width == 736.0))
#define IS_RETINA2 ([[UIScreen mainScreen] scale] == 2.0)
#define IS_RETINA3 ([[UIScreen mainScreen] scale] == 3.0)

#define kCategoryGovernmentReligion @"Government & Religion"
#define kCategoryDailyLife @"Daily Life"
#define kCategoryScience @"Science & Technology"
#define kCategoryMilitary @"Military"
#define kCategoryLanguage @"Language"
#define kCategorySampler @"Sampler"

#define kWiseGuyBeethoven @"Beethoven"
#define kWiseGuyTesla @"Tesla"
#define kWiseGuyFranklin @"Franklin"
#define kWiseGuyDaVinci @"da Vinci"

#define kWiseGuyThinker @"Thinker"




extern CGFloat const screenHeightIpad;
extern CGFloat const screenHeightIphone6Plus;
extern CGFloat const screenHeightIphone6;
extern CGFloat const screenHeightIphone5;
extern CGFloat const screenHeightOldIphone;

extern CGFloat const gameMenusHeightIpad ;
extern CGFloat const gameMenusHeightIphone6Plus;
extern CGFloat const gameMenusHeightIphone6;
extern CGFloat const gameMenusHeightIphone5;
extern CGFloat const gameMenusHeightOldIphone;

extern CGFloat const scrollViewVerticalAdjustmentIpad; //going above 40 screws up the animate to fill screen on ipad, probably because scrollview gets so wide
extern CGFloat const scrollViewVerticalAdjustmentIphone6Plus;
extern CGFloat const scrollViewVerticalAdjustmentIphone6;
extern CGFloat const scrollViewVerticalAdjustmentIphone5;
extern CGFloat const scrollViewVerticalAdjustmentOldIphone;

extern CGFloat const cardOverlayXOffset;
extern CGFloat const cardOverlayYOffset;

extern CGFloat const cardOverlayImageZoomIphoneDefaultRatio;
extern CGFloat const cardOverlayImageZoomIphone5RatioPortrait;
extern CGFloat const cardOverlayImageZoomIpadRatioPortrait;
extern CGFloat const cardOverlayImageZoomIpadRatioLandscape;
extern CGFloat const cardOverlayImageZoomIphone4Ratio;


extern CGFloat const gameStatusCardOverlayXOffset;
extern CGFloat const gameStatusCardOverlayYOffset;



extern CGFloat const hToWRatio ;
extern NSString * const HQpixelsforPic ;
extern NSString * const LQpixelsforPic ;
extern CGFloat const pixelsToTrimForDPI150 ;

extern CGFloat const shadowOffsetForDPI150 ;
extern CGFloat const shadowRadiusForDPI150;
extern CGFloat const shadowOpacity ;

extern CGFloat const cardToScreenDurationIphone ;
extern CGFloat const cardToScreenDurationIpad ;
extern CGFloat const cardFlipDuration ;

extern NSInteger const cardsInStackView ;

extern NSInteger const maxHintCount;

extern NSString * const appTitle;
extern NSString * const tagLine;
extern NSString * const emailAddress;

extern NSString * const cardInfoAddress;
extern NSString * const dailyImageAddress;

extern NSString * const hostAddress;


extern NSString * const tapCardLabelText;

extern NSString * const finalQuestionCategoryName ;

extern CGFloat const roundImageFlipDuration;
extern CGFloat const roundImageFlipDelay;

extern CGFloat const categoryHeaderHeightIphone6;
extern CGFloat const categoryHeaderHeightIphone5;
extern CGFloat const categoryHeaderHeightOldIphone;
extern CGFloat const categoryHeaderHeightIpad;

extern CGFloat const avatarDiameterIphone;
extern CGFloat const avatarDiameterIphone6;
extern CGFloat const avatarDiameterIpad;
extern CGFloat const avatarOverlapIphone;
extern CGFloat const avatarOverlapIpad;

extern NSInteger const secondsForQuestion;
extern NSInteger const secondsUntilLettersAppear;

extern NSInteger const playableQuestionsTrial;


typedef enum screenDirection : NSUInteger {
    kUp,
    kDown,
    kRight,
    kLeft
} screenDirection;


@interface ARTConstants : NSObject

@end
