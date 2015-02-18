//
//  ARTCategoryCollectionViewCell.h
//  Artful Deductions
//
//  Created by Kyle Rokita on 10/1/14.
//  Copyright (c) 2014 Artful Deductions LLC. All rights reserved.
//

#import <UIKit/UIKit.h>

@class ARTCategoryViewController;
@class ARTDeck;
@class ARTTextShadowLabel;
@class ARTCard;

@interface ARTCategoryCollectionViewCell : UICollectionViewCell

@property (strong, nonatomic) UIView *topView;
@property (strong, nonatomic) IBOutlet UILabel *categoryNameLabel;
@property (strong, nonatomic) IBOutlet UIView *categoryNameLabelPlaceholder;
@property (strong, nonatomic) IBOutlet UIView *imageViewHolder;
@property (strong, nonatomic) UIImageView *cardImageView;
@property (strong, nonatomic) UIImageView *imageViewOverlay;

@property (strong, nonatomic) UIView *backView;


@property (strong, nonatomic) UIImageView *awardImageView;
@property (strong, nonatomic) UIImageView *logoImageView;
@property (strong, nonatomic) UILabel *topicCompleteLabel;
@property (strong, nonatomic) UILabel *scoreLabel;


@property (weak, nonatomic) ARTCategoryViewController *delegate;
@property (strong, nonatomic) ARTDeck *deck;
@property (strong, nonatomic) ARTCard *topCard;

@property (nonatomic) BOOL isOKToRotate;

- (void)configureCell;

- (void)startAnimateImageFlip;

- (void)resetImageFlip;

@end
