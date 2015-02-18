//
//  ARTCardHelper.m
//  Artful Deductions
//
//  Created by Kyle Rokita on 12/6/14.
//  Copyright (c) 2014 Artful Deductions LLC. All rights reserved.
//

#import "ARTCardHelper.h"
#import "ARTDeck.h"
#import "NSDictionary+DeepCopy.h"
#import "ARTConstants.h"

@interface ARTCardHelper () {
    //global variables go here
}

@property (nonatomic, strong) NSMutableDictionary *freshDecks;
@property (nonatomic, strong) NSMutableDictionary *dailyDecks;


@end

@implementation ARTCardHelper

+ (ARTCardHelper *)sharedInstance {
    static dispatch_once_t once;
    static ARTCardHelper * sharedInstance;
    dispatch_once(&once, ^{
        
        sharedInstance = [[self alloc] init];
    });
    return sharedInstance;
}

- (id)init{
    
    if ((self = [super init])) {
        
        
        self.freshDecks = [self setupDeckDictionaries];
        self.dailyDecks = [self setupDailyDeckDictionaries];
        
        
    }
    return self;
}

- (NSMutableDictionary*)getAllFreshDecks {
    
    return self.freshDecks;
    
}

- (NSMutableDictionary*)getAllDailyDecks {
    
    return self.dailyDecks;
    
}

+ (NSDictionary *) readDeckDictionaries {
    // Read in and store as string
    NSString *string = [[NSBundle mainBundle] pathForResource:@"ARTCards" ofType:@"json"];
    NSData *myData = [NSData dataWithContentsOfFile:string];
    
    NSError* error = nil;
    NSDictionary* decks = [NSJSONSerialization JSONObjectWithData:myData
                                                          options:kNilOptions
                                                            error:&error];
    
    return decks;
}

+ (NSMutableDictionary *)readDailyDeckDictionaries {
    // Read in and store
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,  NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    NSString *filePath = [documentsDirectory stringByAppendingPathComponent:@"ARTDailyCards.json"];
    
    NSData *myData = [NSData dataWithContentsOfFile:filePath];
    
    NSError* error = nil;
    NSMutableDictionary *userInfo;
    if (myData) {
        userInfo = [[NSJSONSerialization JSONObjectWithData:myData
                                                    options:kNilOptions
                                                      error:&error] mutableDeepCopy];
    }
    
    
    return userInfo;
}

- (NSMutableDictionary *)setupDeckDictionaries {
    
    NSDictionary * deckDictionaries = [ARTCardHelper readDeckDictionaries];
    
    NSArray *deckIDs = [deckDictionaries allKeys];
    
    NSMutableDictionary *decks = [NSMutableDictionary new];
    for (NSString *deckKey in deckIDs) {
        
        //don't initate sampler deck because we are doing that last
        if (![deckKey isEqualToString:kCategorySampler]) {
            ARTDeck *deck = [[ARTDeck alloc] initWithID:deckKey andDeckDictionaries:deckDictionaries];
            [decks setObject:deck forKey:deckKey];
        }
    }
    
    if ([deckIDs containsObject:kCategorySampler]) {
        ARTDeck *deck = [[ARTDeck alloc] initWithID:kCategorySampler andDeckDictionaries:deckDictionaries];
        [decks setObject:deck forKey:kCategorySampler];
    }
    
    
    return decks;
    
}

- (NSMutableDictionary *)setupDailyDeckDictionaries {
    
    NSDictionary * deckDictionaries = [ARTCardHelper readDailyDeckDictionaries];
    
    NSArray *deckIDs = [deckDictionaries allKeys];
    
    NSMutableDictionary *decks = [NSMutableDictionary new];
    for (NSString *deckKey in deckIDs) {
        
        ARTDeck *deck = [[ARTDeck alloc] initWithID:deckKey andDeckDictionaries:deckDictionaries];
        [decks setObject:deck forKey:deckKey];
    }
    
    
    return decks;
    
}

- (void) updateDailyDecks:(NSMutableDictionary *)dailyDeckDictionaries {
    
    [self saveDailyDecks:dailyDeckDictionaries];
    
    NSArray *deckIDs = [dailyDeckDictionaries allKeys];
    
    NSMutableDictionary *decks = [NSMutableDictionary new];
    for (NSString *deckKey in deckIDs) {
        
        ARTDeck *deck = [[ARTDeck alloc] initWithID:deckKey andDeckDictionaries:dailyDeckDictionaries];
        [decks setObject:deck forKey:deckKey];
    }
    
    
    self.dailyDecks = decks;
    
}

- (void) saveDailyDecks:(NSMutableDictionary *)dictionary {
    NSMutableDictionary *userInfo = dictionary;
    
    NSError* error = nil;
    if (userInfo) {
        NSData *userInfoData = [NSJSONSerialization dataWithJSONObject:userInfo
                                                               options:NSJSONWritingPrettyPrinted
                                                                 error:&error];
        NSString *testString;
        testString = [[NSString alloc] initWithData:userInfoData encoding:NSUTF8StringEncoding];
        
        NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,  NSUserDomainMask, YES);
        NSString *documentsDirectory = [paths objectAtIndex:0];
        NSString *filePath = [documentsDirectory stringByAppendingPathComponent:@"ARTDailyCards.json"];
        NSData *myData = [testString dataUsingEncoding:NSUTF8StringEncoding];
        
        [myData writeToFile:filePath atomically:YES];
    }
}

- (void) resetCardDecks{
    
    self.freshDecks = [self setupDeckDictionaries];
}


@end
