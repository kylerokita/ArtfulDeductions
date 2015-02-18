//
//  ARTPurchaseInfo.h
//  Artful Deductions
//
//  Created by Kyle Rokita on 8/5/14.
//  Copyright (c) 2014 Artful Deductions LLC. All rights reserved.
//

#import <Foundation/Foundation.h>

//@class goes here

@interface ARTUserInfo : NSObject


+ (ARTUserInfo *)sharedInstance;

- (NSMutableDictionary *) getDeckInfo;
- (NSMutableDictionary *) getCardInfo;
- (void) saveDeckInfo:(NSMutableDictionary *)deckInfo;
- (void) saveCardInfo:(NSMutableDictionary *)cardInfo;

- (NSMutableDictionary *) getAvatarInfo;
- (void) saveAvatarInfo:(NSMutableDictionary *)avatarInfo;


- (NSMutableDictionary *) getVisualTheme;
- (void) saveVisualTheme:(NSString *)visualTheme;

- (BOOL) showTutorialForScreen:(NSString *)tutorialName;
- (void) saveShowedTutorialForScreen:(NSString *)tutorialName;

- (NSMutableDictionary *) getShowIntro;
- (void) saveShowIntro:(NSString *)showIntro;

- (void) resetUserInfo;

- (void) resetTutorials;

@end
