//
//  ARTDeck.h
//  Artful Deductions
//
//  Created by Kyle Rokita on 8/5/14.
//  Copyright (c) 2014 Artful Deductions LLC. All rights reserved.
//

#import <Foundation/Foundation.h>

//@class goes here
@class ARTCard;

@interface ARTDeck : NSObject

@property (strong, nonatomic) NSString *uniqueID;
@property (strong, nonatomic) NSString *series;
@property (strong, nonatomic) NSDictionary *cards;
@property (strong, nonatomic) UIColor *color;
@property (strong, nonatomic) NSString *dateLastPlayed;
@property (strong, nonatomic) ARTCard *nextCard;

@property (nonatomic) NSInteger playedCardCount;
@property (nonatomic) NSInteger remainingCardCount;
@property (nonatomic) NSInteger totalCardCount;

@property (nonatomic) BOOL isEnabled;
@property (nonatomic) BOOL isGameOver;


- (id)initWithID:(NSString *)uniqueID andDeckDictionaries:(NSDictionary *)deckDictionaries;

- (void)updateWithDeckSaveDictionary:(NSDictionary *)deckSave ;

- (void)playCard:(ARTCard *)card;

- (NSMutableArray *)getArrayOfSortedCards;

- (NSMutableDictionary *)makeDictionaryFromProperties;

- (NSString *)getIntroMessage;
- (NSString *)getAwardName;
- (UIImage *)getAwardImage;


+ (BOOL)isDeckPlayed:(NSString *)deckID;
+ (BOOL)isDeckCompleted:(NSString *)deckID;
+ (BOOL)isDeckEnabled:(NSString *)deckID;


+ (void)setDeckPlayed:(NSString *)deckID;
+ (void)setDeckCompleted:(NSString *)deckID;
+ (void)setDeckEnabled:(NSString *)deckID;

- (NSInteger)getScore;
- (NSInteger)getPossibleScore;


@end
