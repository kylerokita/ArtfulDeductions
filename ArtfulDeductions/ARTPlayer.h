//
//  ARTPlayer.h
//  Artful Deductions
//
//  Created by Kyle Rokita on 8/6/14.
//  Copyright (c) 2014 Artful Deductions LLC. All rights reserved.
//

#import <Foundation/Foundation.h>

//@class goes here
@class ARTCard;
@class ARTAvatar;

@interface ARTPlayer : NSObject

@property (nonatomic, strong) NSString *playerNumber; //format will be "Player1"
@property (nonatomic, strong) NSString *name;
@property (nonatomic, strong) NSMutableDictionary *correctCards;
@property (nonatomic) BOOL isCurrentPlayer;
@property (nonatomic, strong) ARTAvatar *avatar;

- (id)initWithNumber:(NSString *)number andName:(NSString *)name andAvatar:(ARTAvatar *)avatar;
- (id)initWithPlayerSave:(NSDictionary *)playerSave;

- (NSMutableDictionary *)makeDictionaryFromProperties;

@end
