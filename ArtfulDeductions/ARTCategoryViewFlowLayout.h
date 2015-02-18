//
//  ARTCategoryViewFlowLayout.h
//  Artful Deductions
//
//  Created by Kyle Rokita on 10/10/14.
//  Copyright (c) 2014 Artful Deductions LLC. All rights reserved.
//

#import <UIKit/UIKit.h>

@class ARTCategoryViewController;

@interface ARTCategoryViewFlowLayout : UICollectionViewFlowLayout

@property (weak, nonatomic) ARTCategoryViewController *delegate;

@end
