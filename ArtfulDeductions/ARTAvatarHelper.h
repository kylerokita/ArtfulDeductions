//
//  ARTAvatarHelper.h
//  Artful Deductions
//
//  Created by Kyle Rokita on 10/5/14.
//  Copyright (c) 2014 Artful Deductions LLC. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ARTAvatarHelper : NSObject

+ (ARTAvatarHelper *)sharedInstance;

- (NSMutableArray *)getAvatars;

@end
