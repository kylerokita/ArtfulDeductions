//
//  ARTCollectionReusableViewHeader.h
//  Artful Deductions
//
//  Created by Kyle Rokita on 8/10/14.
//  Copyright (c) 2014 Artful Deductions LLC. All rights reserved.
//

#import <UIKit/UIKit.h>

@class ARTDeck;

@interface ARTCollectionReusableViewHeader : UICollectionReusableView
@property (strong, nonatomic) UILabel *label;
@property (strong, nonatomic) UIView *backView;
@property (strong, nonatomic) ARTDeck *deck;

- (void)configureView;

@end
