//
//  ARTGameSaves.m
//  Artful Deductions
//
//  Created by Kyle Rokita on 8/2/14.
//  Copyright (c) 2014 Artful Deductions LLC. All rights reserved.
//

#import "ARTGameSaves.h"
#import "NSDictionary+DeepCopy.h"

@interface ARTGameSaves () {
	//global variables go here
}

@property (nonatomic, strong) NSMutableDictionary *gameSaves;

@end

@implementation ARTGameSaves

+ (ARTGameSaves *)sharedInstance {
    static dispatch_once_t once;
    static ARTGameSaves * sharedInstance;
    dispatch_once(&once, ^{
        NSMutableDictionary * gameDictionaries = [ARTGameSaves readGameSaves];
        
        sharedInstance = [[self alloc] initWithGameSaves:gameDictionaries];
    });
    return sharedInstance;
}

- (id)initWithGameSaves:(NSMutableDictionary *)gameSaves {
    
    if ((self = [super init])) {
        
        self.gameSaves = gameSaves;
        
    }
    return self;
}

- (NSMutableDictionary *)getGameSavesIncludingCompleted:(BOOL)completedIndicator {
    
    if (completedIndicator) {
        return self.gameSaves;
    }
    else {
        NSMutableDictionary *incompleteGameSaves = [NSMutableDictionary new];
        for (NSString *key in self.gameSaves) {
            NSDictionary *gameSave = self.gameSaves[key];
            NSInteger remainingCards = [gameSave[@"remainingCardCount"] integerValue];
            if (remainingCards > 0) {
                [incompleteGameSaves setObject:self.gameSaves[key] forKey:key];
            }
        }
        
        return incompleteGameSaves;
    }
    
}


- (void) saveGameDictionary:(NSMutableDictionary *)dictionary {
    
    
    
    if (![NSJSONSerialization isValidJSONObject:dictionary]) {
        NSLog(@"object is not JSONable");
    } else {
        
        NSString *key = dictionary[@"uniqueID"];
        self.gameSaves[key] = dictionary;
        
        [ARTGameSaves writeGameSavesFromDictionary:self.gameSaves];
    }
    
    
    

}

- (void) deleteGameDictionary:(NSMutableDictionary *)dictionary {
    
    
    if (![NSJSONSerialization isValidJSONObject:dictionary]) {
        NSLog(@"object is not JSONable");
        
    } else {
        
        NSString *key = dictionary[@"uniqueID"];
        [self.gameSaves removeObjectForKey:key];
        [ARTGameSaves writeGameSavesFromDictionary:self.gameSaves];
    }
}

- (void) resetGameSaves {
    
    self.gameSaves = nil;
    self.gameSaves = [NSMutableDictionary new];

    [ARTGameSaves deleteAllGameSaves];
    
}

+ (NSMutableDictionary *)readGameSaves {
    // Read in and store
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,  NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    NSString *filePath = [documentsDirectory stringByAppendingPathComponent:@"ARTGameSaves.json"];
    
    NSData *myData = [NSData dataWithContentsOfFile:filePath];
    
    NSError* error = nil;
    NSMutableDictionary *gameSaves = [[NSMutableDictionary alloc] init];
    if (myData) {
        gameSaves = [NSMutableDictionary dictionaryWithDictionary:[NSJSONSerialization JSONObjectWithData:myData
                                                                                                  options:kNilOptions
                                                                                                    error:&error]];
        
    }
    
    return gameSaves;
}

+ (void)writeGameSavesFromDictionary:(NSMutableDictionary *)dictionary {
    
    NSError* error = nil;
    NSData *gameSavesData = [NSJSONSerialization dataWithJSONObject:dictionary
                                                            options:NSJSONWritingPrettyPrinted
                                                              error:&error];
    NSString *testString;
    testString = [[NSString alloc] initWithData:gameSavesData encoding:NSUTF8StringEncoding];
    
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,  NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    NSString *filePath = [documentsDirectory stringByAppendingPathComponent:@"ARTGameSaves.json"];
    NSData *myData = [testString dataUsingEncoding:NSUTF8StringEncoding];
    
    [myData writeToFile:filePath atomically:YES];
}

+ (void)deleteAllGameSaves {
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSError *error;
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,  NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    NSString *filePath = [documentsDirectory stringByAppendingPathComponent:@"ARTGameSaves.json"];
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
