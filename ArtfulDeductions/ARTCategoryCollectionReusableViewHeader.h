//
//  ARTCategoryCollectionReusableViewHeader.h
//  Artful Deductions
//
//  Created by Kyle Rokita on 10/1/14.
//  Copyright (c) 2014 Artful Deductions LLC. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ARTCategoryCollectionReusableViewHeader : UICollectionReusableView

@property (strong, nonatomic) UIView *containerView;
@property (strong, nonatomic) UILabel *label;
@property (strong, nonatomic) UIView *backView;
@property (strong, nonatomic) NSString *headerTitle;

- (void)configureView;

- (void)animateHeader;

@end
