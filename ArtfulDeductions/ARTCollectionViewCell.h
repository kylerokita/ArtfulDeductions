//
//  ARTCollectionViewCell.h
//  Artful Deductions
//
//  Created by Kyle Rokita on 8/10/14.
//  Copyright (c) 2014 Artful Deductions LLC. All rights reserved.
//

#import <UIKit/UIKit.h>

@class ARTCard;
@class ARTDeck;
@class ARTGalleryViewController;

@interface ARTCollectionViewCell : UICollectionViewCell

@property (strong, nonatomic) IBOutlet UIImageView *myImageView;
@property (strong, nonatomic) UILabel *imageViewOverlay;


@property (strong, nonatomic) UILabel *label;

@property (strong, nonatomic) NSIndexPath *indexPath;

@property (strong, nonatomic) ARTCard *card;
@property (strong, nonatomic) ARTDeck *deck;

@property (weak, nonatomic) ARTGalleryViewController *delegate;

- (void)configureCell;

@end
