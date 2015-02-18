//
//  ARTStoreItemViewController.h
//  Artful Deductions
//
//  Created by Kyle Rokita on 8/20/14.
//  Copyright (c) 2014 Artful Deductions LLC. All rights reserved.
//

#import <UIKit/UIKit.h>

@class ARTStoreItem;
@class ARTButton;
@class ARTTopView;

@interface ARTStoreItemViewController : UIViewController <UINavigationControllerDelegate,UIScrollViewDelegate>

@property (strong, nonatomic) IBOutlet UIImageView *logoImageView;
@property (strong, nonatomic) ARTStoreItem *storeItem;

@property (strong, nonatomic) IBOutlet UILabel *nameLabel;
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *nameLabelHeightConstraint;
@property (strong, nonatomic) UILabel *descriptionTitleLabel;
@property (strong, nonatomic) UILabel *descriptionLabel;
@property (strong, nonatomic) IBOutlet UIScrollView *scrollView;
@property (strong, nonatomic) IBOutlet ARTButton *buyButton;
@property (strong, nonatomic) UILabel *sampleImagesTitleLabel;

@property (strong, nonatomic) ARTTopView *topView;
@property (strong, nonatomic) UIButton *backButton;



@property (strong, nonatomic) IBOutlet NSLayoutConstraint *buyButtonHeightConstraint;

@end
