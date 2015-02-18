//
//  ARTCardHelper.h
//  Artful Deductions
//
//  Created by Kyle Rokita on 12/6/14.
//  Copyright (c) 2014 Artful Deductions LLC. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ARTCardHelper : NSObject

+ (ARTCardHelper *)sharedInstance;

- (NSMutableDictionary*)getAllFreshDecks;
- (NSMutableDictionary*)getAllDailyDecks;

- (void) resetCardDecks;

- (void) updateDailyDecks:(NSMutableDictionary *)dailyDeckDictionaries;


@end
