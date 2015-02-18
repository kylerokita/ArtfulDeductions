//
//  ARTConstants.m
//  Artful Deductions
//
//  Created by Kyle Rokita on 9/30/14.
//  Copyright (c) 2014 Artful Deductions LLC. All rights reserved.
//

#import "ARTConstants.h"

CGFloat const screenHeightIpad = 1024.0;
CGFloat const screenHeightIphone6Plus = 736.0;
CGFloat const screenHeightIphone6 = 667.0;
CGFloat const screenHeightIphone5 = 568.0;
CGFloat const screenHeightOldIphone = 480.0;

CGFloat const gameMenusHeightIpad = 65.0;
CGFloat const gameMenusHeightIphone6Plus = 50.0;
CGFloat const gameMenusHeightIphone6 = 50.0;
CGFloat const gameMenusHeightIphone5 = 45.0;
CGFloat const gameMenusHeightOldIphone = 40.0;

CGFloat const scrollViewVerticalAdjustmentIpad = 0.0;//40.0; //going above 40 screws up the animate to fill screen on ipad, probably because scrollview gets so wide
CGFloat const scrollViewVerticalAdjustmentIphone6Plus = 0.0;//20.0;
CGFloat const scrollViewVerticalAdjustmentIphone6 = 0.0;//20.0;
CGFloat const scrollViewVerticalAdjustmentIphone5 = 0.0;//20.0;
CGFloat const scrollViewVerticalAdjustmentOldIphone = 0.0;//20.0;

CGFloat const cardOverlayXOffset = 0.0;
CGFloat const cardOverlayYOffset = 20.0;

CGFloat const cardOverlayImageZoomIphone5Ratio = 1.05;
CGFloat const cardOverlayImageZoomIpadRatioPortrait = 1.2;
CGFloat const cardOverlayImageZoomIpadRatioLandscape = 1.05;
CGFloat const cardOverlayImageZoomIphone4Ratio = 1.25;


CGFloat const gameStatusCardOverlayXOffset = 40.0;
CGFloat const gameStatusCardOverlayYOffset = 30.0;

CGFloat const hToWRatio = 1.3/1.1;
NSString * const HQpixelsforPic = @"240";
NSString * const LQpixelsforPic = @"90";
CGFloat const pixelsToTrimForDPI150 = 46.0;

CGFloat const shadowOffsetForDPI150 = 10.0;
CGFloat const shadowRadiusForDPI150 = 4.0;
CGFloat const shadowOpacity = 0.45;

CGFloat const cardToScreenDurationIphone = 0.4;
CGFloat const cardToScreenDurationIpad = 0.45;
CGFloat const cardFlipDuration = 0.4;

NSInteger const cardsInStackView = 6;

NSInteger const maxHintCount = 3;

NSString * const appTitle = @"Artful Deductions";
NSString * const tagLine = @"Intriguing Trivia";
NSString * const emailAddress = @"ArtfulDeductions@gmail.com";

NSString * const cardInfoAddress = @"https://s3.amazonaws.com/deductions.info/";
NSString * const dailyImageAddress = @"https://s3.amazonaws.com/deductions.images.out/";

NSString * const hostAddress = @"s3.amazonaws.com";


NSString * const tapCardLabelText = @"Tap Any Card To Play";

NSString * const finalQuestionCategoryName = @"Final Question";

CGFloat const roundImageFlipDuration = 0.48;
CGFloat const roundImageFlipDelay = roundImageFlipDuration / 5.0;

CGFloat const categoryHeaderHeightIphone6 = 60.0;
CGFloat const categoryHeaderHeightIphone5 = 55.0;
CGFloat const categoryHeaderHeightOldIphone = 50.0;
CGFloat const categoryHeaderHeightIpad = 75.0;

/*CGFloat const categoryHeaderHeightIphone6 = 0.0;
 CGFloat const categoryHeaderHeightIphone5 = 0.0;
 CGFloat const categoryHeaderHeightOldIphone = 0.0;
 CGFloat const categoryHeaderHeightIpad = 0.0;*/

CGFloat const avatarDiameterIphone = 65.0;
CGFloat const avatarDiameterIphone6 = 70.0;
CGFloat const avatarDiameterIpad = 104.0;
CGFloat const avatarOverlapIphone = 5.0;
CGFloat const avatarOverlapIpad = 10.0;

NSInteger const secondsForQuestion = 90;
NSInteger const secondsUntilLettersAppear = 30;

NSInteger const playableQuestionsTrial = 0;


@implementation ARTConstants

@end
