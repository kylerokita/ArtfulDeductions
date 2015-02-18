//
//  ARTAvatarHelper.m
//  Artful Deductions
//
//  Created by Kyle Rokita on 10/5/14.
//  Copyright (c) 2014 Artful Deductions LLC. All rights reserved.
//

#import "ARTAvatarHelper.h"
#import "ARTAvatar.h"

@interface ARTAvatarHelper () {
    //global variables go here
}

@property (nonatomic, strong) NSMutableArray *avatars;

@end

@implementation ARTAvatarHelper

+ (ARTAvatarHelper *)sharedInstance {
    static dispatch_once_t once;
    static ARTAvatarHelper * sharedInstance;
    dispatch_once(&once, ^{
        NSMutableArray * avatarDicts = [ARTAvatarHelper readAvatars];
        
        sharedInstance = [[self alloc] initWithAvatarDicts:avatarDicts];
    });
    return sharedInstance;
}

- (id)initWithAvatarDicts:(NSMutableArray *)avatarDicts {
    
    if ((self = [super init])) {
        
        NSMutableArray *avatars = [NSMutableArray new];
        for (NSInteger i = 0; i < avatarDicts.count; i++) {
            ARTAvatar *avatar = [[ARTAvatar alloc] initWithJSONDict:avatarDicts[i]];
            [avatars addObject:avatar];
        }
        
        self.avatars = avatars;
        
    }
    return self;
}

+ (NSMutableArray *)readAvatars {
    // Read in and store

    NSString *filePath = [[NSBundle mainBundle] pathForResource:@"ARTAvatars" ofType:@"json"];
    
    NSData *myData = [NSData dataWithContentsOfFile:filePath];
    
    NSError* error = nil;
    NSMutableArray *gameSaves = [[NSMutableArray alloc] init];
    if (myData) {
        gameSaves = [NSMutableArray arrayWithArray:[NSJSONSerialization JSONObjectWithData:myData
                                                                                                  options:kNilOptions
                                                                                                    error:&error]];
        
    }
    
    return gameSaves;
}

- (NSMutableArray *)getAvatars {
    return self.avatars;
}


@end
