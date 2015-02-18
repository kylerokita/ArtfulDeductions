//
//  ARTCardDelegate.h
//  Artful Deductions
//
//  Created by Kyle Rokita on 12/24/14.
//  Copyright (c) 2014 Artful Deductions LLC. All rights reserved.
//

#import <Foundation/Foundation.h>

@class ARTCard;
@class ARTGame;
@class ARTDeck;

@protocol ARTCardDelegate <NSObject>

@property (nonatomic) BOOL isShowingImageSide;

@property (nonatomic) BOOL isCardNextCardButtonPressed;
@property (nonatomic) BOOL isCardBackButtonPressed;
@property (nonatomic) BOOL isCardContinueButtonPressed;
@property (nonatomic) BOOL isNonCardButtonPressed;

@property (strong,nonatomic) ARTCard *selectedCard;
@property (strong, nonatomic) ARTGame *currentGame;
@property (strong, nonatomic) ARTDeck *selectedDeck;

@end