//
//  ARTPurchaseInfo.m
//  Artful Deductions
//
//  Created by Kyle Rokita on 8/5/14.
//  Copyright (c) 2014 Artful Deductions LLC. All rights reserved.
//

#import "ARTUserInfo.h"
#import "NSDictionary+DeepCopy.h"

//#define statements go here

//static NSInteger const declarations go here

@interface ARTUserInfo () {
	//global variables go here
}

//"private" properties go here
@property (nonatomic, strong) NSMutableDictionary *userInfo;

@end

@implementation ARTUserInfo

+ (ARTUserInfo *)sharedInstance {
    static dispatch_once_t once;
    static ARTUserInfo * sharedInstance;
    dispatch_once(&once, ^{
        NSMutableDictionary *userInfo = [ARTUserInfo readUserInfo];
        
        sharedInstance = [[self alloc] initWithUserInfo:userInfo];
    });
    return sharedInstance;
}

- (id)initWithUserInfo:(NSMutableDictionary *)userInfo {
    
    
    
    self = [super init];
    if (self) {
        
        self.userInfo = userInfo;
        
    }
    return self;
}

- (NSMutableDictionary *) getDeckInfo {
    
    NSMutableDictionary *decks = self.userInfo[@"decks"];
    
    return self.userInfo[@"decks"];
}

- (NSMutableDictionary *) getAvatarInfo {
    return self.userInfo[@"avatars"];
}

- (NSMutableDictionary *) getCardInfo {
    return self.userInfo[@"cards"];
}


+ (NSMutableDictionary *)readUserInfo {
    // Read in and store
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,  NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    NSString *filePath = [documentsDirectory stringByAppendingPathComponent:@"ARTUserInfo.json"];
    
    NSData *myData = [NSData dataWithContentsOfFile:filePath];
    
    NSError* error = nil;
    NSMutableDictionary *userInfo;
    if (myData) {
        userInfo = [[NSJSONSerialization JSONObjectWithData:myData
                                                        options:kNilOptions
                                                          error:&error] mutableDeepCopy];
    }
    else {
        
        userInfo = [ARTUserInfo readUserDefaultInfo];
    }
    
    return userInfo;
}

+ (NSMutableDictionary *)readUserDefaultInfo {
    // Read in and store
    NSString *filePath = [[NSBundle mainBundle] pathForResource:@"ARTUserDefaultInfo" ofType:@"json"];
    NSData *myData = [NSData dataWithContentsOfFile:filePath];
    
    NSError* error = nil;
    NSMutableDictionary *purchaseInfo = [[NSMutableDictionary alloc] init];
    if (myData) {
        purchaseInfo = [[NSJSONSerialization JSONObjectWithData:myData
                                                        options:kNilOptions
                                                          error:&error] mutableDeepCopy];
        
    }
    else {
        
    }
    
    return purchaseInfo;
}

- (void) saveDeckInfo:(NSMutableDictionary *)deckInfo {
    
    
    NSMutableDictionary *userInfo = self.userInfo;
    
    if (![NSJSONSerialization isValidJSONObject:deckInfo]) {
        NSLog(@"object is not JSONable");
    } else {
        
        userInfo[@"decks"] = deckInfo;
    }
    
    [self saveUserInfo];
    
    
}

- (void) saveAvatarInfo:(NSMutableDictionary *)avatarInfo {
    
    
    NSMutableDictionary *userInfo = self.userInfo;
    
    if (![NSJSONSerialization isValidJSONObject:avatarInfo]) {
        NSLog(@"object is not JSONable");
    } else {
        
        userInfo[@"avatars"] = avatarInfo;
    }
    
    [self saveUserInfo];
    
    
}

- (void) saveCardInfo:(NSMutableDictionary *)cardInfo {
    
    
    NSMutableDictionary *userInfo = self.userInfo;
    
    if (![NSJSONSerialization isValidJSONObject:cardInfo]) {
        NSLog(@"object is not JSONable");
    } else {
        
        userInfo[@"cards"] = cardInfo;
    }
    
    [self saveUserInfo];
    
}

- (NSMutableDictionary *) getVisualTheme {
    
    return self.userInfo[@"settings"][@"visualTheme"];
    
}

- (void) resetUserInfo {
    
    self.userInfo = nil;
    self.userInfo = [ARTUserInfo readUserDefaultInfo];
    
    [ARTUserInfo deleteAllUserInfo];
    
}



- (void) saveVisualTheme:(NSString *)visualTheme {
    
    
    NSMutableDictionary *userInfo = self.userInfo;
    
    if (![NSJSONSerialization isValidJSONObject:userInfo]) {
        NSLog(@"object is not JSONable");
    } else {
        
        userInfo[@"settings"][@"visualTheme"] = visualTheme;
    }
    
    [self saveUserInfo];

    
    
}

- (void) resetTutorials {
    
    NSMutableDictionary *tutorialScreens = self.userInfo[@"tutorials"];
    NSArray *keys = tutorialScreens.allKeys;
    for (NSInteger i = 0; i < keys.count; i++) {
        NSString *key = keys[i];
        [self.userInfo[@"tutorials"] setValue:@"YES" forKey:key];
    }
    
    [self saveUserInfo];

    
}

- (void) saveUserInfo {
    NSMutableDictionary *userInfo = self.userInfo;
    
    NSError* error = nil;
    NSData *userInfoData = [NSJSONSerialization dataWithJSONObject:userInfo
                                                           options:NSJSONWritingPrettyPrinted
                                                             error:&error];
    NSString *testString;
    testString = [[NSString alloc] initWithData:userInfoData encoding:NSUTF8StringEncoding];
    
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,  NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    NSString *filePath = [documentsDirectory stringByAppendingPathComponent:@"ARTUserInfo.json"];
    NSData *myData = [testString dataUsingEncoding:NSUTF8StringEncoding];
    
    [myData writeToFile:filePath atomically:YES];

}


- (BOOL) showTutorialForScreen:(NSString *)tutorialName {
    if ([self.userInfo[@"tutorials"][tutorialName] isEqualToString:@"YES"]) {
        return  YES;
    }
    
    return NO;
}


- (void) saveShowedTutorialForScreen:(NSString *)tutorialName {
    self.userInfo[@"tutorials"][tutorialName] = @"NO";
    
    [self saveUserInfo];
}

- (NSMutableDictionary *) getShowIntro {
    
    return self.userInfo[@"settings"][@"showIntro"];
}

- (void) saveShowIntro:(NSString *)showIntro {
    
    
    NSMutableDictionary *userInfo = self.userInfo;
    
    if (![NSJSONSerialization isValidJSONObject:userInfo]) {
        NSLog(@"object is not JSONable");
    } else {
        
        userInfo[@"settings"][@"showIntro"] = showIntro;
    }
    
    [self saveUserInfo];

    
    
}

+ (void)deleteAllUserInfo {
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSError *error;
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,  NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    NSString *filePath = [documentsDirectory stringByAppendingPathComponent:@"ARTUserInfo.json"];
    BOOL fileExists = [fileManager fileExistsAtPath:filePath];
    NSLog(@"Path to file: %@", filePath);
    NSLog(@"File exists: %d", fileExists);
    NSLog(@"Is deletable file at path: %d", [fileManager isDeletableFileAtPath:filePath]);
    if (fileExists)
    {
        BOOL success = [fileManager removeItemAtPath:filePath error:&error];
        if (!success) NSLog(@"Error: %@", [error localizedDescription]);
    }
}


@end
