//
//  ARTGameStatus.h
//  ArtfulDeductions
//
//  Created by Kyle Rokita on 7/5/14.
//  Copyright (c) 2014 Artful Deductions LLC. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ARTGameDelegate.h"

@class ARTCard;
@class ARTAnswer;
@class ARTCategory;
@class ARTDeck;
@class ARTPlayer;

@interface ARTGame : NSObject

@property (strong, nonatomic, readonly) NSString* uniqueID;

@property (strong, nonatomic) NSMutableDictionary *players;
@property (strong, nonatomic) ARTPlayer *currentPlayer;

@property (nonatomic, readonly) BOOL cardIsInProgress;

@property (strong, nonatomic) NSMutableArray *decks;

@property (strong, nonatomic, readonly) NSString *gameMode;

@property (nonatomic, readonly) float questionRemainingTime;

@property (nonatomic, strong, readonly) NSString *dateLastPlayed;

@property (nonatomic, weak) id <ARTGameDelegate> delegate;

@property (nonatomic, strong) NSDate *timerEndDate;


- (id)initWithGameMode:(NSString *)gameMode andPlayers:(NSMutableDictionary *)players;
- (id)initWithGameSave:(NSDictionary*)game;

- (void)playCard:(ARTCard *)card;

- (void)startQuestionTimer;
- (void)cancelQuestionTimer;

- (NSMutableDictionary *)makeDictionaryFromProperties;

+ (NSString *)dateInStringFormat;

- (BOOL)checkCorrectAnswerInString:(NSString *)string forCard:(ARTCard *)card wholeWord:(BOOL)wholeWord;
- (BOOL)checkAllAnswerKeywordsCorrectForCard:(ARTCard *)card;

- (NSInteger)finishedWithCorrectAnswer:(BOOL)correctIndicator forCard:(ARTCard *)card andHintCount:(NSInteger)hintCount andIsRepeatPlay:(BOOL)repeatPlay ;

- (void)saveGame;

- (void)updateEnabledDecks;

@end
