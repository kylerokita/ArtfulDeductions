//
//  NSDictionary+DeepCopy.h
//  Artful Deductions
//
//  Created by Kyle Rokita on 8/7/14.
//  Copyright (c) 2014 Artful Deductions LLC. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSDictionary (DeepCopy)

- (NSMutableDictionary *) mutableDeepCopy;

@end
