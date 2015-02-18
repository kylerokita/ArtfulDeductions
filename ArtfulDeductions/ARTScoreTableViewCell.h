//
//  ARTScoreTableViewCell.h
//  Artful Deductions
//
//  Created by Kyle Rokita on 10/16/14.
//  Copyright (c) 2014 Artful Deductions LLC. All rights reserved.
//

#import <UIKit/UIKit.h>

@class ARTCard;

@interface ARTScoreTableViewCell : UITableViewCell

@property (strong, nonatomic) ARTCard *card;
@property (strong, nonatomic) IBOutlet UIImageView *cardImageView;
@property (strong, nonatomic) IBOutlet UILabel *questionNumberLabel;
@property (strong, nonatomic) IBOutlet UILabel *possiblePointsLabel;
@property (strong, nonatomic) IBOutlet UILabel *actualPointsLabel;

- (void)configureCell;

@end
