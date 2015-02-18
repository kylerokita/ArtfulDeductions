//
//  ARTAvatar.h
//  Artful Deductions
//
//  Created by Kyle Rokita on 10/5/14.
//  Copyright (c) 2014 Artful Deductions LLC. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ARTAvatar : NSObject

@property (strong, nonatomic) NSString *name;
@property (nonatomic) NSInteger year;
@property (strong, nonatomic) NSString *imageFilename;
@property (strong, nonatomic) NSString *jobTitle;
@property (strong, nonatomic) NSString *accomplishments;
@property (strong, nonatomic) NSString *selectionMessage;
@property (strong, nonatomic) NSString *giveUpMessage;
@property (strong, nonatomic) NSString *funFact;


@property (strong, nonatomic) NSString *fullName;
@property (strong, nonatomic) NSMutableArray *correctAnswerMessage;
@property (strong, nonatomic) NSMutableArray *wrongAnswerMessage;

@property (nonatomic) NSInteger correctAnswerCounter;
@property (nonatomic) NSInteger wrongAnswerCounter;

@property (nonatomic) BOOL isEnabled;


- (id)initWithJSONDict:(NSDictionary *)avatarDictionary;

- (NSMutableDictionary *)makeDictionaryFromProperties;

- (NSString *)getWrongAnswerMessage;
- (NSString *)getCorrectAnswerMessage;

+ (BOOL)isAvatarEnabled:(NSString *)avatarID ;
+ (void)setAvatarEnabled:(NSString *)avatarID;

+ (ARTAvatar *)getAvatarForAvatarName:(NSString *)name;

- (NSString *)getBioString;

@end
