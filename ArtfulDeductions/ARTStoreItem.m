//
//  ARTStoreItem.m
//  Artful Deductions
//
//  Created by Kyle Rokita on 8/19/14.
//  Copyright (c) 2014 Artful Deductions LLC. All rights reserved.
//

#import "ARTStoreItem.h"
#import "ARTDeck.h"
//#import "ARTIAPHelper.h"
#import "ARTImageHelper.h"
#import "MKStoreManager.h"

//#define statements go here

//static NSInteger const declarations go here

@interface ARTStoreItem () {
	//global variables go here
}

//"private" properties go here

@end

@implementation ARTStoreItem

- (id)initWithSKProduct:(SKProduct *)product{
    
    if ((self = [super init])) {
        
        self.name = product.localizedTitle;
        
        self.price = product.price;
        self.itemDescription = product.localizedDescription;
        self.imageFilenames = [self getStoreImagesForProduct:product];
        self.isPurchased = [MKStoreManager isFeaturePurchased:product.productIdentifier];
        self.product = product;
        
    }
    return self;
}

- (id)initWithNoProduct {
    
    if ((self = [super init])) {
        
        self.name = @"You have it all!";

        self.price = [NSNumber numberWithInt:0];
        self.itemDescription = @"Keep checking back as we update periodically!";
        self.imageFilenames = nil;
        self.isPurchased = nil;
        self.product = nil;
        
    }
    return self;
}


- (id)initWithLoadingProduct {
    
    if ((self = [super init])) {
        
        self.name = @"Loading store content...";
        
        self.price = [NSNumber numberWithInt:0];
        self.itemDescription = @"Make sure you are connected to the internet";
        self.imageFilenames = nil;
        self.isPurchased = nil;
        self.product = nil;
        
    }
    return self;
}

- (id)initWithNoPurchases {
    
    if ((self = [super init])) {
        
        self.name = @"";
        
        self.price = [NSNumber numberWithInt:0];
        self.itemDescription = @"";
        self.imageFilenames = nil;
        self.isPurchased = nil;
        self.product = nil;
        
    }
    return self;
}

- (NSMutableArray *)getStoreImagesForProduct:(SKProduct *)product {
    
    NSMutableArray *storeImageFilenames = [NSMutableArray new];
    
    if ([product.productIdentifier isEqual:kProductClassicSeries]) {
        
        NSMutableArray *triviaPack1ImageFileNames = [NSMutableArray arrayWithObjects:												@"DailyLife9",	@"DailyLife11",												@"DailyLife35",	@"DailyLife37",	@"DailyLife39",	@"Government1",			@"Government7",				@"Government15",				@"Government23",			@"Government29",						@"Language1",	@"Language3",													@"Language29",				@"Language37",	@"Language39",	@"Military1",			@"Military7",			@"Military13",			@"Military19",		@"Military23",																			@"Science1",	@"Science3",						@"Science15",				@"Science23",			@"Science29",																						nil];

        for (NSString *filename in triviaPack1ImageFileNames) {
                [storeImageFilenames addObject:filename];
            }
    }
        
   /* else if ([product.productIdentifier isEqual:kProductClassicWiseGuys]) {
        
        NSMutableArray *triviaPack1ImageFileNames = [NSMutableArray arrayWithObjects:@"deck1card21front",@"deck1card21front",nil];
        
        for (NSString *filename in triviaPack1ImageFileNames) {
            [storeImageFilenames addObject:filename];
        }
    }*/

    return storeImageFilenames;
}


@end
