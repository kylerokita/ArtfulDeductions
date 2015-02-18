//
//  ARTStoreItem.h
//  Artful Deductions
//
//  Created by Kyle Rokita on 8/19/14.
//  Copyright (c) 2014 Artful Deductions LLC. All rights reserved.
//

#import <Foundation/Foundation.h>

@class ARTDeck;
@class SKProduct;

@interface ARTStoreItem : NSObject

@property (strong, nonatomic) NSString *name;
@property (strong, nonatomic) NSMutableArray *imageFilenames;
@property (strong, nonatomic) NSString *itemDescription;
@property (strong, nonatomic) NSNumber *price;
@property ( nonatomic) BOOL isPurchased;
@property (strong, nonatomic) SKProduct *product;

- (id)initWithSKProduct:(SKProduct *)product;
- (id)initWithNoProduct;
- (id)initWithLoadingProduct;
- (id)initWithNoPurchases;


@end
