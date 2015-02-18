//
//  ARTAvatar.m
//  Artful Deductions
//
//  Created by Kyle Rokita on 10/5/14.
//  Copyright (c) 2014 Artful Deductions LLC. All rights reserved.
//

#import <objc/runtime.h>
#import "ARTAvatar.h"
#import "ARTAvatarHelper.h"
#import "ARTConstants.h"
#import "ARTUserInfo.h"

@implementation ARTAvatar

- (id)initWithJSONDict:(NSDictionary *)avatarDictionary {
    self = [super init];
    if (self) {
        
        NSArray *propertyList = [self allPropertyNames];
        
        for(id property in propertyList) {
            
            if ([property  isEqual: @"wrongAnswerCounter"]) {
                self.wrongAnswerCounter = 0;
            }
            else if ([property  isEqual: @"correctAnswerCounter"]) {
                self.correctAnswerCounter = 0;

            }
            else if ([property  isEqual: @"isEnabled"]) {
                self.isEnabled = [ARTAvatar isAvatarEnabled:avatarDictionary[@"name"]];

            }
            else if (avatarDictionary[property]) {
                
                if ([property  isEqual: @"year"]) {
                    self.year = [avatarDictionary[property] integerValue];
                    
                }
                else {
                    [self setValue:avatarDictionary[property] forKey:property];
                    
                }
            }
            else {
                
                [self setValue:[NSNull null] forKey:property];
            }
        }
    }
    return self;
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


- (NSMutableDictionary *)makeDictionaryFromProperties {
    
    NSMutableArray *arrayOfKeys = [[NSMutableArray alloc] init];
    NSMutableArray *arrayOfValues = [[NSMutableArray alloc] init];
    
    [arrayOfKeys addObject:@"name"];
    [arrayOfValues addObject:self.name];
    
    NSMutableDictionary *dictionary = [[NSMutableDictionary alloc] initWithObjects:arrayOfValues forKeys:arrayOfKeys];
    
    return dictionary;
}



+ (ARTAvatar *)getAvatarForAvatarName:(NSString *)name {
    
    NSMutableArray *avatars = [[ARTAvatarHelper sharedInstance] getAvatars];
    for (ARTAvatar *anAvatar in avatars) {
        if ([anAvatar.name isEqual:name]) {
            return anAvatar;
        }
    }
    
    return nil;
}


+ (BOOL)isAvatarEnabled:(NSString *)avatarID {
    
    NSMutableDictionary* avatarInfo = [[ARTUserInfo sharedInstance] getAvatarInfo];
    
    return ([avatarInfo[avatarID][@"isEnabled"] isEqualToString:@"YES"] ? YES : NO);
}

+ (void)setAvatarEnabled:(NSString *)avatarID {
    NSMutableDictionary* avatarInfo = [[ARTUserInfo sharedInstance] getAvatarInfo];
    
    if (avatarInfo[avatarID]) {
        avatarInfo[avatarID][@"isEnabled"] = @"YES";
    } else {
        NSMutableDictionary *newAvatarDict = [NSMutableDictionary new];
        [newAvatarDict setObject:@"YES" forKey:@"isEnabled"];
        [avatarInfo setObject:newAvatarDict forKey:avatarID];
    }
    
    [[ARTUserInfo sharedInstance] saveAvatarInfo:avatarInfo];
}


- (NSString *)getWrongAnswerMessage {
    
    NSInteger counter = self.wrongAnswerCounter;
    [self incrementWrongAnswerCounter];
    return self.wrongAnswerMessage[counter];
}



- (NSString *)getCorrectAnswerMessage {
    
    NSInteger counter = self.correctAnswerCounter;
    [self incremenCorrectAnswerCounter];
    return self.correctAnswerMessage[counter];
    
}


- (void)incrementWrongAnswerCounter {
    self.wrongAnswerCounter = (self.wrongAnswerCounter + 1 ) % self.wrongAnswerMessage.count;
}

- (void)incremenCorrectAnswerCounter {
    self.correctAnswerCounter = (self.correctAnswerCounter + 1 ) % self.correctAnswerMessage.count;
}

- (NSString *)getBioString {
    
    NSString *jobString = [NSString stringWithFormat:@"Profession: %@",self.jobTitle];
    NSString *accomplishmentsString = [NSString stringWithFormat:@"Accomplishments: %@",self.accomplishments];
    NSString *funFactString = [NSString stringWithFormat:@"Fun fact: %@",self.funFact];
    
    return [NSString stringWithFormat:@"%@\n\n%@\n\n%@",jobString,accomplishmentsString,funFactString];

}

@end
