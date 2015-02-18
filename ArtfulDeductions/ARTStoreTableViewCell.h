//
//  ARTStoreTableViewCell.h
//  Artful Deductions
//
//  Created by Kyle Rokita on 8/19/14.
//  Copyright (c) 2014 Artful Deductions LLC. All rights reserved.
//

#import <UIKit/UIKit.h>

@class ARTStoreItem;
@class ARTButton;
@class ARTStoreViewController;

@interface ARTStoreTableViewCell : UITableViewCell

@property (strong, nonatomic) IBOutlet UILabel *nameLabel;
@property (strong, nonatomic) IBOutlet UILabel *descriptionLabel;
@property (strong, nonatomic) IBOutlet UIImageView *firstImageView;
@property (strong, nonatomic) ARTStoreItem *storeItem;
@property (strong, nonatomic) IBOutlet ARTButton *buyButton;
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *buyButtonWidthConstraint;
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *imageViewWidthConstraint;
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *imageViewHeightConstraint;

@property (weak, nonatomic) ARTStoreViewController *delegate;

- (void)configureCell;

@end
