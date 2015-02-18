//
//  ARTNewPlayerCollectionViewCell.h
//  Artful Deductions
//
//  Created by Kyle Rokita on 10/1/14.
//  Copyright (c) 2014 Artful Deductions LLC. All rights reserved.
//

#import <UIKit/UIKit.h>

@class ARTNewGameViewController;
@class ARTAvatar;

@interface ARTNewPlayerCollectionViewCell : UICollectionViewCell

@property (strong, nonatomic) IBOutlet UIImageView *imageView;

@property (strong, nonatomic) ARTAvatar *avatar;

@property (strong, nonatomic) IBOutlet UILabel *avatarLabel;


- (void)configureCell;

- (void)animateImageFlip;

- (void)resetImageFlip;

@end
