//
//  ARTCard.h
//  ArtfulDeductions
//
//  Created by Kyle Rokita on 7/3/14.
//  Copyright (c) 2014 Artful Deductions LLC. All rights reserved.
//

#import <Foundation/Foundation.h>

@class ARTAnswer;

@interface ARTCard : NSObject

@property (strong, nonatomic) NSString *uniqueID;
@property (strong, nonatomic) NSString *pictureName;
@property (nonatomic) BOOL isPlayed;
@property (strong, nonatomic) NSString *category;
@property (strong, nonatomic) NSNumber *categoryNumber;
@property (strong, nonatomic) NSString *deckID;
@property (strong, nonatomic) NSString *questionText;
@property (strong, nonatomic) NSString *answerText;
@property (strong, nonatomic) ARTAnswer *answerObject;
@property (strong, nonatomic) NSString *orientation;
@property (strong, nonatomic) NSString *frontFilename;
@property (strong, nonatomic) NSString *backFilename;
@property (strong, nonatomic) UIColor *color;
@property ( nonatomic) NSInteger points;
@property ( nonatomic) NSInteger possiblePoints;


- (NSDictionary *)makeCardInfoSave;

- (id)initWithJSONDict:(NSDictionary *)cardDictionary andDeckID:(NSString *)deckID;

- (id)updateWithCardInfoSave:(NSDictionary *)dictionary;

+ (BOOL)isCardPlayed:(NSString *)deckID;
+ (void)setCardPlayed:(NSString *)deckID;

- (void)resetCard;

@end
