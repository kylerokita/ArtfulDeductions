//
//  ARTGameStatus.m
//  ArtfulDeductions
//
//  Created by Kyle Rokita on 7/5/14.
//  Copyright (c) 2014 Artful Deductions LLC. All rights reserved.
//

#import "ARTGame.h"
#import "ARTCard.h"
#import "ARTAnswer.h"
#import "ARTGameSaves.h"
#import "ARTDeck.h"
#import "ARTPlayer.h"
#import "ARTAvatar.h"
#import "ARTCardHelper.h"

#import "ARTConstants.h"


@interface ARTGame () {
   
}
@property (strong, nonatomic) NSString *uniqueID;

@property (nonatomic) BOOL cardIsInProgress;

@property (strong, nonatomic) NSString *gameMode;

@property (nonatomic) float questionRemainingTime;
@property (nonatomic, strong) NSTimer *questionTimer;

@property (nonatomic, strong) NSString *dateLastPlayed;

@end

@implementation ARTGame

- (id)initWithGameMode:(NSString *)gameMode andPlayers:(NSMutableDictionary *)players {
    self = [super init];
    
    NSMutableArray *newDecks = [self getArrayOfNewDecksForMode:gameMode];
    
    NSMutableDictionary *gameSaves = [[ARTGameSaves sharedInstance] getGameSavesIncludingCompleted:YES];
    NSArray *keys = [gameSaves allKeys];
    NSString *lastkey;
    if (keys.count >0) {
        keys = [keys sortedArrayUsingSelector:@selector(compare:)];
        lastkey = keys[keys.count - 1];
    } else {
        lastkey = @"0";
    }
    NSString *newGameID = [NSString stringWithFormat:@"%lld",[lastkey longLongValue] + 1];
    NSLog(@"new game id: %@",newGameID);
    
    if (self) {
        self.uniqueID = newGameID;
        self.decks = newDecks;
        self.cardIsInProgress = NO;
        self.gameMode = gameMode;
        self.questionRemainingTime = (float)secondsForQuestion;
        self.dateLastPlayed = [ARTGame dateInStringFormat];
        self.players = players;
        self.currentPlayer = players[@"Player1"];
        
        self.currentPlayer.isCurrentPlayer = YES;
        
        
        [self saveGame];
    }
    

    return self;
}

- (id)initWithGameSave:(NSDictionary*)gameSave {
    
    NSLog(@"loading game id: %@",[gameSave objectForKey:@"uniqueID"]);

    self = [super init];
    if (self) {
        
        //begin initializing the properties from the saved game dictionary
        self.uniqueID = [gameSave objectForKey:@"uniqueID"];
        self.cardIsInProgress = ([[gameSave objectForKey:@"cardIsInProgress"]  isEqualToString:@"YES"] ? YES : NO);
        self.gameMode = [gameSave objectForKey:@"gameMode"];
        self.questionRemainingTime = [[gameSave objectForKey:@"questionRemainingTime"] floatValue];
        
        self.players = [self getPlayersFromGameSave:gameSave];
        self.currentPlayer = [self getCurrentPlayer];
        
        self.decks = [self getDecksFromGameSave:gameSave];
        
        self.dateLastPlayed = [gameSave objectForKey:@"dateLastPlayed"];
        
        [self saveGame];
    }
    
    
    
    return self;
}
                               
+ (NSString *)dateInStringFormat {
   
   NSDate *date = [NSDate date];
   NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
   [dateFormat setDateFormat:@"yyyy-MM-dd'T'HH:mm:ss.SSS"];
   return [dateFormat stringFromDate:date];
}

- (NSMutableDictionary *)getPlayersFromGameSave:(NSDictionary *)game {
    
    NSMutableDictionary *playersInSaveForm = game[@"players"];
    
    NSMutableDictionary *players = [NSMutableDictionary new];
    for (NSString *key in playersInSaveForm) {
        
        NSMutableDictionary *playerInSaveForm = game[@"players"][key];
        
        ARTPlayer *player = [[ARTPlayer alloc] initWithPlayerSave:playerInSaveForm];
        [players setValue:player forKey:key];
    }
    
    return players;
}


- (NSMutableArray *)getDecksFromGameSave:(NSDictionary *)gameSave {
    
    NSMutableArray *decks = [NSMutableArray new];
    
    NSMutableDictionary *decksInSaveForm = gameSave[@"decks"];
    
    NSMutableArray *allFreshDecks = [self getArrayOfNewDecksForMode:gameSave[@"gameMode"]];
    for (NSInteger i = 0; i < allFreshDecks.count; i++) {
        ARTDeck *deck = allFreshDecks[i];
        
        for (NSString *saveKey in decksInSaveForm) {
            NSDictionary *deckSaveDictionary = decksInSaveForm[saveKey];
            if ([deck.uniqueID isEqual:deckSaveDictionary[@"uniqueID"]]) {
                [deck updateWithDeckSaveDictionary:deckSaveDictionary];
            }
        }
        
        [decks addObject:deck];

        
    }
    
    return decks;
}

- (ARTPlayer *)getCurrentPlayer {
    
    for (NSString *key in self.players) {
        ARTPlayer *player = self.players[key];
        if (player.isCurrentPlayer) {
            NSLog(@"current player:%@",key);
            return player;
        }
    }
    
    return nil;
}

- (NSDictionary *)categoriesFromDeck:(NSDictionary *)deck {
    
    NSMutableArray *categories = [[NSMutableArray alloc] init];
    NSMutableArray *keys = [[NSMutableArray alloc] init];
    
    for (NSString *key in deck) {
        ARTCard *card = deck[key];
        NSString *cardCategory = card.category;
        
        if(categories.count == 0) {
            [categories addObject:cardCategory];
            [keys addObject:cardCategory];
        }
        else {
            BOOL categoryExists = NO;
            for (NSInteger j = 0; j < categories.count; j++) {
                NSString *stackCategory = categories[j];
                
                if ([cardCategory isEqual:stackCategory]) {
                    categoryExists = YES;
                }
            }
            if (!categoryExists) {
                [categories addObject:cardCategory];
                [keys addObject:cardCategory];
            }
        }
    }
    
    return [[NSDictionary alloc] initWithObjects:categories forKeys:keys];
}

- (NSDictionary *)updatedeck:(NSDictionary *)deck forCardInfoDictionaries:(NSArray *)cardInfoDictionaries {
    
    
    for (NSString *key in deck) {
        ARTCard *tempCard = deck[key];
        for (NSInteger cardInfoCounter = 0; cardInfoCounter < cardInfoDictionaries.count; cardInfoCounter++) {
            
            //find card in card deck from card info
            if ([tempCard valueForKey:@"uniqueID"] == cardInfoDictionaries[cardInfoCounter][@"uniqueID"]) {
                [tempCard updateWithCardInfoSave:cardInfoDictionaries[cardInfoCounter]];
            }
        }
        //[newCardArray addObject:tempCard];
    }
    
    return [NSDictionary dictionaryWithDictionary:deck];
}

- (ARTDeck *) getDeckWithID:(NSString *)deckID {
    
    for (NSInteger i = 0; i < self.decks.count; i++) {
        ARTDeck *deck = self.decks[i];
        if ([deck.uniqueID isEqualToString:deckID]) {
            return deck;
        }
    }
    
    return nil;
}

- (void)updateEnabledDecks {
    
    for (NSInteger i = 0; i < self.decks.count; i ++) {
        ARTDeck *deck = self.decks[i];
        
        //enabled means deck is purchased OR card cound is less than trial
        deck.isEnabled = ([ARTDeck isDeckEnabled:deck.uniqueID] || deck.playedCardCount < playableQuestionsTrial);
    }
    
}



- (void)playCard:(ARTCard *)card {

    [[UIApplication sharedApplication] setIdleTimerDisabled:YES];
    
    ARTDeck *deckForCard = [self getDeckWithID:card.deckID];
    [deckForCard playCard:card];
    
    self.dateLastPlayed = [ARTGame dateInStringFormat];
    self.cardIsInProgress = YES;
    self.questionRemainingTime = (float)secondsForQuestion;
    
    [self startQuestionTimer];
    
    //[self.delegate updateCardOverlayStatusViews];
}

- (BOOL)checkCorrectAnswerInString:(NSString *)string forCard:(ARTCard *)card wholeWord:(BOOL)wholeWord {
    
    return [card.answerObject checkAnswerInString:string wholeWord:wholeWord];
}

- (BOOL)checkAllAnswerKeywordsCorrectForCard:(ARTCard *)card {
    
    return [card.answerObject checkAllAnswerKeywordsCorrect];
}

- (NSInteger)getScoreForCard:(ARTCard *) card forCorrectAnswer:(BOOL)correctIndicator andHintCount:(NSInteger)hintCount {
    NSInteger pointsForCard = 0;
    
    if (correctIndicator) {
        
        //ARTPlayer *player = self.currentPlayer;
        
        //NSString *category = card.category;
        //NSInteger multiplier = [player getScoreMultiplierForCardCategory:category];
        
        if (hintCount == 0) {
            pointsForCard = 5;
        }
        else if (hintCount == 1) {
            pointsForCard = 4;
        }
        else if (hintCount == 2) {
            pointsForCard = 3;
        }
        else if (hintCount > 2) {
            pointsForCard = 2;
        }
    }
    
    return pointsForCard;
}


- (NSInteger)finishedWithCorrectAnswer:(BOOL)correctIndicator forCard:(ARTCard *)card andHintCount:(NSInteger)hintCount andIsRepeatPlay:(BOOL)repeatPlay {
    
    //only update if card hasnt already ended, such as if timer ended but player is still guessing
    
    NSInteger pointsForCard = [self getScoreForCard:card forCorrectAnswer:correctIndicator andHintCount:hintCount];
    
    ARTPlayer *player = self.currentPlayer;
    
    //only update points if card if card points were currently 0
    if (pointsForCard >0 && !repeatPlay) {
        [player.correctCards setValue:card forKey:card.uniqueID];
        card.points = pointsForCard;
    }
    
    self.cardIsInProgress = NO;
    [self cancelQuestionTimer];
    
    [self advanceToNextPlayer];
    [self.delegate updateCardOverlayStatusViews];
    [self saveGame];
    
    [[UIApplication sharedApplication] setIdleTimerDisabled:NO];

    
    return pointsForCard;
}

- (void)advanceToNextPlayer {
    ARTPlayer *currentPlayer = self.currentPlayer;
    self.currentPlayer.isCurrentPlayer = NO;
    
    NSMutableArray *arrayOfKeys = [NSMutableArray new];
    for (NSString *key in self.players) {
        [arrayOfKeys addObject:key];
    }
    NSArray *sortedArrayOfKeys = [arrayOfKeys sortedArrayUsingSelector:@selector(compare:)];
    
    NSInteger currentIndex = [sortedArrayOfKeys indexOfObject:currentPlayer.playerNumber];
    NSInteger nextIndex = (currentIndex + 1) % sortedArrayOfKeys.count;
    NSString *nextPlayerKey = sortedArrayOfKeys[nextIndex];
    
    self.currentPlayer = self.players[nextPlayerKey];
    self.currentPlayer.isCurrentPlayer = YES;
    [self getCurrentPlayer];
}

- (void)startQuestionTimer {
    
    [self cancelQuestionTimer];
    
    self.questionRemainingTime = (float)secondsForQuestion;
    [self.delegate updateCardOverlayStatusViews];
    
    self.timerEndDate = [NSDate dateWithTimeInterval:secondsForQuestion sinceDate:[NSDate date]];
    
    float secondsInInterval = 0.2;
    self.questionTimer = [NSTimer scheduledTimerWithTimeInterval:secondsInInterval
                                                      target:self
                                                    selector:@selector(updateQuestionTimer)
                                                    userInfo:nil
                                                     repeats:YES];
    
    [[NSRunLoop currentRunLoop] addTimer:self.questionTimer
                                 forMode:NSRunLoopCommonModes];
}

- (void)updateQuestionTimer {
    
    NSDate *currentDate = [NSDate date];
    float remainingTime =  [self.timerEndDate timeIntervalSinceDate:currentDate] ;
    
    if (remainingTime  > 0) {
        self.questionRemainingTime = remainingTime;
    }
    else {
        self.questionRemainingTime = 0.0;
        [self.delegate questionTimerExpired];
        [self cancelQuestionTimer];
    }
    
    [self.delegate updateCardOverlayStatusViews];
}

- (void)cancelQuestionTimer {
    if (self.questionTimer) [self.questionTimer invalidate];
    self.questionTimer = nil;
    
    self.questionRemainingTime = 0.0;
    self.timerEndDate = nil;
    
}

- (NSMutableDictionary *) makeDeckSavesDictionary {
    
    NSMutableDictionary *deckSaves = [NSMutableDictionary new];
    for (ARTDeck *deck in self.decks) {
        NSMutableDictionary *deckSave = [deck makeDictionaryFromProperties];
        [deckSaves setObject:deckSave forKey:deck.uniqueID];
    }
    return deckSaves;
}

- (NSMutableDictionary *)makeDictionaryFromProperties {
    
    NSMutableArray *arrayOfKeys = [[NSMutableArray alloc] init];
    NSMutableArray *arrayOfValues = [[NSMutableArray alloc] init];
    
    [arrayOfKeys addObject:@"uniqueID"];
    [arrayOfValues addObject:self.uniqueID];
    
    [arrayOfKeys addObject:@"decks"];
    NSDictionary *deckSavesDictionary = [self makeDeckSavesDictionary];
    [arrayOfValues addObject:deckSavesDictionary];
    
    [arrayOfKeys addObject:@"cardIsInProgress"];
    [arrayOfValues addObject:(self.cardIsInProgress ? @"YES" : @"NO")];
    
    [arrayOfKeys addObject:@"gameMode"];
    [arrayOfValues addObject:self.gameMode];
    
    [arrayOfKeys addObject:@"questionRemainingTime"];
    [arrayOfValues addObject:[NSNumber numberWithLong: self.questionRemainingTime]];
    
    [arrayOfKeys addObject:@"players"];
    NSMutableDictionary *playerDictionary = [[NSMutableDictionary alloc] init];
    for (NSString *key in self.players) {
        NSDictionary *categoryDictionary = [self.players[key] makeDictionaryFromProperties];
        [playerDictionary setValue:categoryDictionary forKey:key];
    }
    [arrayOfValues addObject:playerDictionary];
    
    [arrayOfKeys addObject:@"dateLastPlayed"];
    [arrayOfValues addObject:self.dateLastPlayed];
    
    NSMutableDictionary *dictionary = [[NSMutableDictionary alloc] initWithObjects:arrayOfValues forKeys:arrayOfKeys];
    
    return dictionary;
}

- (void) saveGame {
    
    NSMutableDictionary *objectDictionary = [self makeDictionaryFromProperties];
    
    [[ARTGameSaves sharedInstance] saveGameDictionary:objectDictionary];
    
}

- (NSMutableArray *)getArrayOfNewDecksForMode:(NSString *)gameMode {
    
    NSDictionary *allDecks;
    if ([gameMode isEqual:@"single"]) {
        allDecks = [[ARTCardHelper sharedInstance] getAllFreshDecks] ;
    } else {
        allDecks = [[ARTCardHelper sharedInstance] getAllDailyDecks] ;
    }
    
    
    NSArray *deckKeys = [allDecks allKeys];
    NSArray *sortedDeckKeys = [deckKeys sortedArrayUsingSelector:@selector(compare:)];
    
    NSMutableArray *reverseDeckKeys = [NSMutableArray new];
    NSInteger arrayCount = sortedDeckKeys.count;
    for( NSInteger i = arrayCount - 1; i >= 0; i--) {
        [reverseDeckKeys addObject:sortedDeckKeys[i]];
    }
    
    NSMutableArray *sortedDecks = [[NSMutableArray alloc] init];
    for (NSString *deckKey in reverseDeckKeys) {
        
        ARTDeck *selectedDeck = allDecks[deckKey];
        
        [sortedDecks addObject:selectedDeck];
    }
    return sortedDecks;
}


- (ARTCard *)getNextUnplayedCardInDeck:(ARTDeck *)deck {
    
    NSMutableArray *unsortedCards = [NSMutableArray new];
    for (NSString *key in deck.cards) {
        [unsortedCards addObject:deck.cards[key]];
    }
    
    NSSortDescriptor *categoryNumberDescriptor = [[NSSortDescriptor alloc] initWithKey:@"categoryNumber" ascending:YES];
    NSMutableArray *sortDescriptors = [NSMutableArray arrayWithObject:categoryNumberDescriptor];
    
    NSArray *sortedCards = [unsortedCards sortedArrayUsingDescriptors:sortDescriptors];

    ARTCard *nextCard;
    for (NSInteger i = 0; i < sortedCards.count; i++) {
        nextCard = sortedCards[i];
        if (nextCard.isPlayed) {
            //do nothing
        }
        else {
            return nextCard;
        }
    }
    
    //return nil if all cards in deck are played
    return nil;
}

- (void)dealloc {
    [self cancelQuestionTimer];
}



@end
