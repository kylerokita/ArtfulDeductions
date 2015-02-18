//
//  ARTGameSaves.h
//  Artful Deductions
//
//  Created by Kyle Rokita on 8/2/14.
//  Copyright (c) 2014 Artful Deductions LLC. All rights reserved.
//

#import <UIKit/UIKit.h>



@interface ARTGameSaves : UIButton

+ (ARTGameSaves *)sharedInstance;

- (NSMutableDictionary *)getGameSavesIncludingCompleted:(BOOL)completedIndicator;
- (void) saveGameDictionary:(NSMutableDictionary *)dictionary;
- (void) deleteGameDictionary:(NSMutableDictionary *)dictionary;
- (void) resetGameSaves;


@end
