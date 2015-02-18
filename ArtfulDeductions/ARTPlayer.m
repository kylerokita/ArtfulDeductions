//
//  ARTPlayer.m
//  Artful Deductions
//
//  Created by Kyle Rokita on 8/6/14.
//  Copyright (c) 2014 Artful Deductions LLC. All rights reserved.
//

#import "ARTPlayer.h"
#import "ARTCard.h"
#import "ARTDeck.h"
#import "ARTAvatar.h"
#import "ARTAvatarHelper.h"

//#define statements go here

//static NSInteger const declarations go here

@interface ARTPlayer () {
	//global variables go here
}

//"private" properties go here

@end

@implementation ARTPlayer

- (id)initWithNumber:(NSString *)number andName:(NSString *)name andAvatar:(ARTAvatar *)avatar{
    self = [super init];
    if (self) {
        
        self.playerNumber = number;
        self.name = name;
        self.correctCards = [NSMutableDictionary new];
        self.isCurrentPlayer = NO;
        self.avatar = avatar;
        
    }
    return self;
}

- (id)initWithPlayerSave:(NSDictionary *)playerSave{
    self = [super init];
    
    NSMutableDictionary *avatarSave = playerSave[@"avatar"];
    
    NSMutableArray *avatars = [[ARTAvatarHelper sharedInstance] getAvatars];
    ARTAvatar *thisAvatar;
    for (ARTAvatar *avatar in avatars) {
        if ([avatar.name isEqualToString:[avatarSave objectForKey:@"name"]]) {
            thisAvatar = avatar;
        }
    }
    
    if (self) {
        
        NSDictionary *allCards = [NSDictionary new];
        
        self.playerNumber = playerSave[@"playerNumber"];
        self.name = playerSave[@"name"];
        self.correctCards = [self getCorrectCardsFromDeck:allCards andCorrectCardInfoDictionaries:playerSave[@"correctCards"]];
        self.isCurrentPlayer = ([playerSave[@"isCurrentPlayer"] isEqualToString:@"YES"] ? YES : NO);
        self.avatar = thisAvatar;
        
    }
    return self;
}

- (NSMutableDictionary *)makeDictionaryFromProperties {
    
    NSMutableArray *arrayOfKeys = [[NSMutableArray alloc] init];
    NSMutableArray *arrayOfValues = [[NSMutableArray alloc] init];

    
    [arrayOfKeys addObject:@"playerNumber"];
    [arrayOfValues addObject:self.playerNumber];
    
    [arrayOfKeys addObject:@"name"];
    [arrayOfValues addObject:self.name];

    
    [arrayOfKeys addObject:@"correctCards"];
    NSMutableArray *mutableArray = [[NSMutableArray alloc] init];
    for (NSString *key in self.correctCards) {
        ARTCard *card = self.correctCards[key];
        [mutableArray addObject:[card makeCardInfoSave]];
    }
    [arrayOfValues addObject:mutableArray];
    
    [arrayOfKeys addObject:@"isCurrentPlayer"];
    [arrayOfValues addObject:(self.isCurrentPlayer ? @"YES" : @"NO")];
    
    [arrayOfKeys addObject:@"array"];
    [arrayOfValues addObject:(self.isCurrentPlayer ? @"YES" : @"NO")];
    
    [arrayOfKeys addObject:@"avatar"];
    [arrayOfValues addObject:[self.avatar makeDictionaryFromProperties]];
    
    NSMutableDictionary *dictionary = [[NSMutableDictionary alloc] initWithObjects:arrayOfValues forKeys:arrayOfKeys];
    
    return dictionary;
}

- (NSMutableDictionary *)getCorrectCardsFromDeck:(NSDictionary *)cards andCorrectCardInfoDictionaries:(NSArray *)cardInfoDictionaries {
    
    NSMutableDictionary *correctCards = [NSMutableDictionary new];
    
    for (NSString *key in cards) {
        ARTCard *tempCard = cards[key];
        for (NSInteger cardInfoCounter = 0; cardInfoCounter < cardInfoDictionaries.count; cardInfoCounter++) {
            
            //find card in card deck from card info
            if ([tempCard valueForKey:@"uniqueID"] == cardInfoDictionaries[cardInfoCounter][@"uniqueID"]) {
                [correctCards setValue:tempCard forKey:key];
            }
        }

    }
    
    return correctCards;
}



@end
