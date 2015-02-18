//
//  ArtDailyViewDelegate.h
//  Artful Deductions
//
//  Created by Kyle Rokita on 12/29/14.
//  Copyright (c) 2014 Artful Deductions LLC. All rights reserved.
//

#import <Foundation/Foundation.h>

@class ARTCard;
@class ARTGame;
@class ARTDeck;

@protocol ARTDailyViewDelegate <NSObject>

@property (strong,nonatomic) ARTCard *selectedCard;
@property (strong, nonatomic) ARTGame *currentGame;
@property (strong, nonatomic) ARTDeck *selectedDeck;

@optional

// from daily card controller
@property (strong, nonatomic) NSMutableArray *sortedCardsFromDailyDecks;
@property (strong, nonatomic) NSMutableArray *dailyDecks;
@property ( nonatomic) NSInteger deckIndex;
@property ( nonatomic) NSInteger cardIndex;
@property (nonatomic) BOOL isDailyCardJustPlayed;


// from normal card controller
@property (nonatomic) BOOL isCardNextCardButtonPressed;
@property (nonatomic) BOOL isCardBackButtonPressed;
@property (nonatomic) BOOL isCardContinueButtonPressed;
@property (nonatomic) BOOL isNonCardButtonPressed;

@end
