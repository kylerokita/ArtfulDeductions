//
//  ARTCard.m
//  ArtfulDeductions
//
//  Created by Kyle Rokita on 7/3/14.
//  Copyright (c) 2014 Artful Deductions LLC. All rights reserved.
//

#import <objc/runtime.h>
#import "ARTCard.h"
#import "ARTAnswer.h"
#import "ARTUserInfo.h"
#import "UIColor+Extensions.h"
#import "ARTConstants.h"

@implementation ARTCard

- (id)initWithJSONDict:(NSDictionary *)cardDictionary andDeckID:(NSString *)deckID {
    self = [super init];
    if (self) {
        
        NSArray *propertyList = [self allPropertyNames];
        
        for(id property in propertyList) {
            
            if ([property isEqual: @"deckID"]) {
                self.deckID = deckID;
            }
            else if ([property isEqual: @"points"]){
                self.points = 0;
            }
            else if ([property isEqual: @"possiblePoints"]){
                self.possiblePoints = 5;
            }
            else if (cardDictionary[property]) {
                
                if ([property  isEqual: @"answerObject"]) {
                    self.answerObject = [[ARTAnswer alloc] initWithAnswerArray:cardDictionary[property]];
                    
                } else if ( [property  isEqual: @"isPlayed"]) {
                    self.isPlayed = ([cardDictionary[property] isEqual: @"YES"] ? YES : NO);
                    
                } else if ( [property  isEqual: @"categoryNumber"]) {
                    NSNumberFormatter * f = [[NSNumberFormatter alloc] init];
                    [f setNumberStyle:NSNumberFormatterNoStyle];
                    self.categoryNumber = [f numberFromString:cardDictionary[property]];
                    
                }
                else {
                    [self setValue:cardDictionary[property] forKey:property];
                    
                }
            }
            else {
                
                [self setValue:[NSNull null] forKey:property];
            }
        }
        
        self.color = [self getColorForDeckWithID:self.category];

    }
    return self;
}

- (id)updateWithCardInfoSave:(NSDictionary *)dictionary {
        
        NSArray *propertyList = [self allPropertyNames];
        
        for(id property in propertyList) {
            
            if ( [property  isEqual: @"isPlayed"]) {
                self.isPlayed = ([dictionary[property] isEqual: @"YES"] ? YES : NO);
            }
            else if ( [property  isEqual: @"points"]) {
                self.points = ([dictionary[property] integerValue]);
            }
            else  if (dictionary[property]) {
                
                [self setValue:dictionary[property] forKey:property];
            }

        }
    
    return self;
}

- (NSDictionary *)makeCardInfoSave {
    NSMutableArray *arrayOfKeys = [[NSMutableArray alloc] init];
    NSMutableArray *arrayOfValues = [[NSMutableArray alloc] init];
    
    [arrayOfKeys addObject:@"uniqueID"];
    [arrayOfValues addObject:self.uniqueID];
    
    [arrayOfKeys addObject:@"isPlayed"];
    [arrayOfValues addObject:(self.isPlayed ? @"YES" : @"NO")];
    
    [arrayOfKeys addObject:@"points"];
    [arrayOfValues addObject:[NSNumber numberWithInteger:self.points]];
    
    NSDictionary *dictionary = [[NSDictionary alloc] initWithObjects:arrayOfValues forKeys:arrayOfKeys];
    
    return dictionary;
}

- (NSArray *)allPropertyNames {
    unsigned count;
    objc_property_t *properties = class_copyPropertyList([self class], &count);
    
    NSMutableArray *rv = [NSMutableArray array];
    
    unsigned i;
    for (i = 0; i < count; i++)
    {
        objc_property_t property = properties[i];
        NSString *name = [NSString stringWithUTF8String:property_getName(property)];
        [rv addObject:name];
    }
    
    free(properties);
    
    return rv;
}

+ (BOOL)isCardPlayed:(NSString *)cardID {
    
    NSMutableDictionary* cardInfo = [[ARTUserInfo sharedInstance] getCardInfo];
    
    return ([cardInfo[cardID][@"isPlayed"] isEqualToString:@"YES"] ? YES : NO);
}

+ (void)setCardPlayed:(NSString *)cardID {
    
    NSMutableDictionary* cardInfo = [[ARTUserInfo sharedInstance] getCardInfo];
    
    if (cardInfo[cardID]) {
        cardInfo[cardID][@"isPlayed"] = @"YES";
    } else {
        NSMutableDictionary *newCardDict = [NSMutableDictionary new];
        [newCardDict setObject:@"YES" forKey:@"isPlayed"];
        [cardInfo setObject:newCardDict forKey:cardID];
    }
    [[ARTUserInfo sharedInstance] saveCardInfo:cardInfo];
    
}

- (UIColor *) getColorForDeckWithID:(NSString *)uniqueID {
    
    UIColor *color;
    if ([uniqueID isEqualToString:kCategoryDailyLife]) {
        color = [UIColor categoryDailyLifeColor];
    } else if ([uniqueID isEqualToString:kCategoryGovernmentReligion]) {
        color = [UIColor categoryGovernmentColor];
    } else if ([uniqueID isEqualToString:kCategoryScience]) {
        color = [UIColor categoryScienceColor];
    } else if ([uniqueID isEqualToString:kCategoryMilitary]) {
        color = [UIColor categoryMilitaryColor];
    } else if ([uniqueID isEqualToString:kCategoryLanguage]) {
        color = [UIColor categoryLanguageColor];
    } else if ([uniqueID isEqualToString:kCategorySampler]){
        color = [UIColor categorySamplerColor];
    } else if ([uniqueID isEqualToString:finalQuestionCategoryName]) {
        color = [UIColor categoryFinalQuestionColor];
    } else {
        color = [UIColor purpleColor];
    }
    
    return color;
}

- (void)resetCard {
    [self.answerObject resetAnswer];
}


@end
