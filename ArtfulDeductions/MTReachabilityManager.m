//
//  MTReachabilityManager.m
//  Artful Deductions
//
//  Created by Kyle Rokita on 12/21/14.
//  Copyright (c) 2014 Artful Deductions LLC. All rights reserved.
//

#import "MTReachabilityManager.h"

#import "Reachability.h"
#import "ARTConstants.h"

@implementation MTReachabilityManager

#pragma mark -
#pragma mark Default Manager
+ (MTReachabilityManager *)sharedManager {
    static MTReachabilityManager *_sharedManager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _sharedManager = [[self alloc] init];
    });
    
    return _sharedManager;
}

#pragma mark -
#pragma mark Memory Management
- (void)dealloc {
    // Stop Notifier
    if (_reachability) {
        [_reachability stopNotifier];
    }
}

#pragma mark -
#pragma mark Class Methods
- (BOOL)isReachable {
    return [[self reachability] isReachable];
}

- (BOOL)isUnreachable {
    return ![[self reachability] isReachable];
}

- (BOOL)isReachableViaWWAN {
    return [[self reachability] isReachableViaWWAN];
}

- (BOOL)isReachableViaWiFi {
    return [[self reachability] isReachableViaWiFi];
}

#pragma mark -
#pragma mark Private Initialization
- (id)init {
    self = [super init];
    
    if (self) {
        // Initialize Reachability
        self.reachability = [Reachability reachabilityWithHostname:hostAddress];
        
        // Start Monitoring
        [self.reachability startNotifier];
    }
    
    return self;
}

@end

