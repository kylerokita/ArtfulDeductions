//
//  ARTDeck.m
//  Artful Deductions
//
//  Created by Kyle Rokita on 8/5/14.
//  Copyright (c) 2014 Artful Deductions LLC. All rights reserved.
//

#import "ARTDeck.h"
#import "ARTGameSaves.h"
#import "ARTUserInfo.h"
#import "ARTCard.h"
#import "UIColor+Extensions.h"
#import "ARTConstants.h"
#import "ARTGame.h"
#import "ARTAvatar.h"
#import "ARTImageHelper.h"
#import "ARTCardHelper.h"

//#define statements go here

//static NSInteger const declarations go here

@interface ARTDeck () {
    //global variables go here
}

//"private" properties go here

@end

@implementation ARTDeck

- (id)initWithID:(NSString *)uniqueID andDeckDictionaries:(NSDictionary *)deckDictionaries {
    
    //get cards
    NSDictionary *deckDict = deckDictionaries[uniqueID];
    NSDictionary *cards = [self getCardsFromDeckDictionary:deckDict withID:uniqueID];
    
    //if deck cards do not exist, then return nil
    if (cards.count == 0) {
        return nil;
    }
    
    self = [super init];
    if (self) {
        
        self.uniqueID = uniqueID; //ID format is "Deck 1"
        self.series = [self getSeriesForDeckWithID:uniqueID];
        self.cards = cards;
        self.color = [self getColorForDeckWithID:uniqueID];
        self.playedCardCount = 0;
        self.remainingCardCount = self.cards.count; //initially this is all the cards
        self.totalCardCount = self.cards.count;
        self.dateLastPlayed = [ARTGame dateInStringFormat];
        self.isGameOver = NO;
        self.isEnabled = [ARTDeck isDeckEnabled:self.uniqueID];
        self.nextCard = [self getNextCard];
    }
    
    return self;
}


- (void)updateWithDeckSaveDictionary:(NSDictionary *)deckSave {
    
    //get cards
    NSDictionary *cards = self.cards;
    
    NSMutableDictionary *cardInfoDictionaries = [NSMutableDictionary dictionaryWithDictionary:[deckSave objectForKey:@"cardInfoDictionary"]];
    
        self.cards = [self updateCards:cards forCardInfoDictionaries:cardInfoDictionaries];
        self.playedCardCount = [self countOfCardsPlayedForCards:self.cards];
        self.totalCardCount = self.cards.count;
        self.remainingCardCount = self.totalCardCount - self.playedCardCount;
        self.dateLastPlayed = [deckSave objectForKey:@"dateLastPlayed"];
        self.isGameOver = [self isAllCardsPlayed];
        self.isEnabled = [ARTDeck isDeckEnabled:self.uniqueID];

    //this updates self.nextcard
    self.nextCard = [self getNextCard];

}

- (NSDictionary *) getCardsFromDeckDictionary:(NSDictionary *)deckDict withID:(NSString *)uniqueID {

    NSDictionary *cardDicts = deckDict[@"Cards"];
    
    NSMutableDictionary *cards = [NSMutableDictionary new];
    for (NSString *cardKey in cardDicts) {
        ARTCard *card = [[ARTCard alloc] initWithJSONDict:cardDicts[cardKey] andDeckID:uniqueID];
        [cards setObject:card forKey:cardKey];
    }
    
    return cards;
}

- (NSString *) getSeriesForDeckWithID:(NSString *)uniqueID {
    
    
    if ([uniqueID isEqual:kCategoryDailyLife] ||
        [uniqueID isEqual:kCategoryGovernmentReligion] ||
        [uniqueID isEqual:kCategoryScience] ||
        [uniqueID isEqual:kCategoryLanguage] ||
        [uniqueID isEqual:kCategoryMilitary] ||
        [uniqueID isEqual:kCategorySampler]

        ) {
        
        return @"Tap A Topic To Play";
    }
    
    
    else if ([uniqueID isEqual:kCategoryMilitary]) {
        return @"Cool Cities";
    }
    
    return @"";
}

- (UIColor *) getColorForDeckWithID:(NSString *)uniqueID {

    UIColor *color;
    if ([uniqueID isEqualToString:kCategoryDailyLife]) {
        color = [UIColor categoryDailyLifeColor];
    } else if ([uniqueID isEqualToString:kCategoryGovernmentReligion] ) {
        color = [UIColor categoryGovernmentColor];
    } else if ([uniqueID isEqualToString:kCategoryScience] ) {
        color = [UIColor categoryScienceColor];
    } else if ([uniqueID isEqualToString:kCategoryMilitary]) {
        color = [UIColor categoryMilitaryColor];
    } else if ([uniqueID isEqualToString:kCategoryLanguage] ) {
        color = [UIColor categoryLanguageColor];
    } else if ([uniqueID isEqualToString:kCategorySampler]) {
        color = [UIColor categorySamplerColor];
    } else if ([uniqueID isEqualToString:finalQuestionCategoryName]) {
        color = [UIColor categoryFinalQuestionColor];
    } else {
        color = [UIColor purpleColor];
    }
    
    return color;
}

- (NSArray *) getStoreImagesFromDeckWithID:(NSString *)uniqueID {
    
    //we are not storing images in the deck dictionaries anymore
    return [NSArray new];
}



- (NSMutableDictionary *)makeDictionaryFromProperties {
    
    NSMutableArray *arrayOfKeys = [[NSMutableArray alloc] init];
    NSMutableArray *arrayOfValues = [[NSMutableArray alloc] init];
    
    [arrayOfKeys addObject:@"uniqueID"];
    [arrayOfValues addObject:self.uniqueID];
    
    [arrayOfKeys addObject:@"cardInfoDictionary"];
    NSMutableDictionary *mutableDict = [NSMutableDictionary new];
    for (NSString *key in self.cards) {
        ARTCard *card = self.cards[key];
        [mutableDict setValue:[card makeCardInfoSave] forKeyPath:key];
    }
    [arrayOfValues addObject:mutableDict];
    
    [arrayOfKeys addObject:@"dateLastPlayed"];
    [arrayOfValues addObject:self.dateLastPlayed];
    
    NSMutableDictionary *dictionary = [[NSMutableDictionary alloc] initWithObjects:arrayOfValues forKeys:arrayOfKeys];
    
    return dictionary;
}

- (NSMutableDictionary *)updateCards:(NSDictionary *)cards forCardInfoDictionaries:(NSMutableDictionary *)cardInfoDictionaries {
    
    
    for (NSString *cardKey in cards) {
        ARTCard *tempCard = cards[cardKey];
        for (NSString *cardInfoKey in cardInfoDictionaries) {
            
            //find card in card deck from card info
            if ([cardKey isEqualToString: cardInfoKey]) {
                [tempCard updateWithCardInfoSave:cardInfoDictionaries[cardInfoKey]];
            }
        }
    }
    
    return [NSMutableDictionary dictionaryWithDictionary:cards];
}

- (NSInteger)countOfCardsPlayedForCards:(NSDictionary *)cardsDict {
    
    NSInteger cardsPlayedCount = 0;
    
    for (NSString *key in cardsDict) {
        ARTCard *card = cardsDict[key];
        if (card.isPlayed) {
            cardsPlayedCount++;
        }
    }
    
    return cardsPlayedCount;
}

- (void)playCard:(ARTCard *)card {
        
    card.isPlayed = YES;
    [ARTCard setCardPlayed:card.uniqueID];
    
    self.dateLastPlayed = [ARTGame dateInStringFormat];
    self.playedCardCount = [self countOfCardsPlayedForCards:self.cards];
    self.totalCardCount = self.cards.count;
    self.remainingCardCount = self.totalCardCount - self.playedCardCount;
    
    self.nextCard = [self getNextCard];
    
    self.isGameOver = [self isAllCardsPlayed];
    if (self.isGameOver) {
        [ARTDeck setDeckCompleted:self.uniqueID];
    }
}

- (NSMutableArray *)getArrayOfSortedCards {
    NSMutableArray *unsortedCards = [NSMutableArray new];
    for (NSString *key in self.cards) {
        [unsortedCards addObject:self.cards[key]];
    }
    
    NSSortDescriptor *categoryNumberDescriptor = [[NSSortDescriptor alloc] initWithKey:@"categoryNumber" ascending:YES];
    NSMutableArray *sortDescriptors = [NSMutableArray arrayWithObject:categoryNumberDescriptor];
    
   return [NSMutableArray arrayWithArray:[unsortedCards sortedArrayUsingDescriptors:sortDescriptors]];
}


- (ARTCard *)getNextCard {
        
    NSMutableArray *sortedCards = [self getArrayOfSortedCards];
    
        ARTCard *nextCard;
        for (NSInteger i = 0; i < sortedCards.count; i++) {
            nextCard = sortedCards[i];
            if (nextCard.isPlayed) {
                //do nothing
            }
            else {
                
                //return first unplayed card
                return nextCard;
            }
        }

    //return nil if no unplayed card
    return nil;
}



- (BOOL)isAllCardsPlayed {
    
    for (NSString *key in self.cards) {
        ARTCard *card = self.cards[key];
        if (!card.isPlayed) {
            return NO;
        }
    }
    
    return YES;
}

+ (BOOL)isDeckPlayed:(NSString *)deckID {
    
    NSMutableDictionary* deckInfo = [[ARTUserInfo sharedInstance] getDeckInfo];
    
    return ([deckInfo[deckID][@"isPlayed"] isEqualToString:@"YES"] ? YES : NO);
    
}

+ (BOOL)isDeckCompleted:(NSString *)deckID {
    
    NSMutableDictionary* deckInfo = [[ARTUserInfo sharedInstance] getDeckInfo];
    
    return ([deckInfo[deckID][@"isCompleted"] isEqualToString:@"YES"] ? YES : NO);
    
}

+ (BOOL)isDeckEnabled:(NSString *)deckID {
    
    NSMutableDictionary* deckInfo = [[ARTUserInfo sharedInstance] getDeckInfo];
    
    
    return ([deckInfo[deckID][@"isEnabled"] isEqualToString:@"YES"] ? YES : NO);
}

+ (void)setDeckPlayed:(NSString *)deckID {
    
    NSMutableDictionary* deckInfo = [[ARTUserInfo sharedInstance] getDeckInfo];
    
    if (deckInfo[deckID]) {
        deckInfo[deckID][@"isPlayed"] = @"YES";
    } else {
        NSMutableDictionary *newDeckDict = [NSMutableDictionary new];
        [newDeckDict setObject:@"YES" forKey:@"isPlayed"];
        [deckInfo setObject:newDeckDict forKey:deckID];
    }
    
    [[ARTUserInfo sharedInstance] saveDeckInfo:deckInfo];
}

+ (void)setDeckCompleted:(NSString *)deckID {
    
    NSMutableDictionary* deckInfo = [[ARTUserInfo sharedInstance] getDeckInfo];
    
    if (deckInfo[deckID]) {
        deckInfo[deckID][@"isCompleted"] = @"YES";
    } else {
        NSMutableDictionary *newDeckDict = [NSMutableDictionary new];
        [newDeckDict setObject:@"YES" forKey:@"isCompleted"];
        [deckInfo setObject:newDeckDict forKey:deckID];
    }
    
    [[ARTUserInfo sharedInstance] saveDeckInfo:deckInfo];
}

+ (void)setDeckEnabled:(NSString *)deckID {
    
    NSMutableDictionary* deckInfo = [[ARTUserInfo sharedInstance] getDeckInfo];

    if (deckInfo[deckID]) {
        deckInfo[deckID][@"isEnabled"] = @"YES";
    } else {
        NSMutableDictionary *newDeckDict = [NSMutableDictionary new];
        [newDeckDict setObject:@"YES" forKey:@"isEnabled"];
        [deckInfo setObject:newDeckDict forKey:deckID];
    }
    
    [[ARTUserInfo sharedInstance] saveDeckInfo:deckInfo];
}

- (NSInteger)getScore {
    NSInteger totalScore = 0;
    for (NSString *key in self.cards) {
        ARTCard *card = self.cards[key];
        if (card.isPlayed) {
            totalScore += card.points;
        }
    }
    
    return totalScore;
}

- (NSInteger)getPossibleScore {
    NSInteger totalPossibleScore = 0;
    for (NSString *key in self.cards) {
        ARTCard *card = self.cards[key];
       // if (card.isPlayed) {
            totalPossibleScore += card.possiblePoints;
      //  }
    }
    
    return totalPossibleScore;
}

- (NSString *)getAwardName  {
    NSString *string;
    
    if ([self.uniqueID isEqualToString:kCategoryDailyLife] ) {
        string = @"Badge of Brilliance";
    } else if ([self.uniqueID isEqualToString:kCategoryGovernmentReligion] ) {
        string = @"Wreath of Wisdom";
    } else if ([self.uniqueID isEqualToString:kCategoryScience] ) {
        string =  @"Science Certificate";
    } else if ([self.uniqueID isEqualToString:kCategoryMilitary] ) {
        string = @"Shield of Smarts";
    } else if ([self.uniqueID isEqualToString:kCategoryLanguage] ) {
        string = @"Mental Medal";
    } else if ([self.uniqueID isEqualToString:kCategorySampler]) {
        string = @"Trivia Trophy";
    }
    
    return string;
    
}

- (UIImage *)getAwardImage {
        UIImage *image;
        
        if ([self.uniqueID isEqualToString:kCategoryDailyLife] ) {
            image = [UIImage imageNamed:@"badge"];
        } else if ([self.uniqueID isEqualToString:kCategoryGovernmentReligion] ) {
            image = [UIImage imageNamed:@"wreath"];
        } else if ([self.uniqueID isEqualToString:kCategoryScience] ) {
            image = [UIImage imageNamed:@"certificate"];
        } else if ([self.uniqueID isEqualToString:kCategoryMilitary] ) {
            image = [UIImage imageNamed:@"shield"];
        } else if ([self.uniqueID isEqualToString:kCategoryLanguage] ) {
            image = [UIImage imageNamed:@"medal"];
        } else if ([self.uniqueID isEqualToString:kCategorySampler]) {
            image = [UIImage imageNamed:@"trophy"];
        }
        
        return image;
    
}


- (NSString *)getIntroMessage{
    
    
    NSString *subjectString;
    
    if ([self.uniqueID isEqualToString:kCategoryDailyLife] ) {
        subjectString =  @"includes questions regarding: sports and leisure activity, clothing, education, and ordinary objects. ";
    } else if ([self.uniqueID isEqualToString:kCategoryGovernmentReligion]) {
        subjectString =  @"includes questions regarding: religous beliefs and customs, national emblems, law, and taxes. ";
    } else if ([self.uniqueID isEqualToString:kCategoryScience] ) {
        subjectString =  @"includes questions regarding accepted science in past centuries that may have since been disproven. ";
    } else if ([self.uniqueID isEqualToString:kCategoryMilitary] ) {
        subjectString =  @"includes questions regarding: military equipment and strategy, military regulations and practices, and notable battles. ";
    } else if ([self.uniqueID isEqualToString:kCategoryLanguage] ) {
        subjectString =  @"includes questions pertaining to word and expression origins. ";
    } else if ([self.uniqueID isEqualToString:kCategorySampler]) {
        subjectString =  [NSString stringWithFormat:@"Here's a gift of 10 free deductions. Happy Holidays!"];
    }
    
    return subjectString;
    
}


@end
