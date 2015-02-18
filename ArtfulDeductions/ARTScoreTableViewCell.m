//
//  ARTScoreTableViewCell.m
//  Artful Deductions
//
//  Created by Kyle Rokita on 10/16/14.
//  Copyright (c) 2014 Artful Deductions LLC. All rights reserved.
//

#import "ARTScoreTableViewCell.h"
#import "ARTConstants.h"
#import "ARTUserInfo.h"
#import "UIColor+Extensions.h"
#import "ARTCard.h"
#import "ARTImageHelper.h"

@implementation ARTScoreTableViewCell

- (void)configureCell {
    self.opaque = YES;
    
    if ([[[ARTUserInfo sharedInstance] getVisualTheme] isEqual:@"white"]) {
        self.backgroundColor = [UIColor lightBackgroundColor]; //darkmode
    } else {
        self.backgroundColor = [UIColor darkBackgroundColor]; //darkmode
    }
    UIView *selectionColor = [[UIView alloc] init];
    selectionColor.backgroundColor = [UIColor blueButtonColor];
    self.selectedBackgroundView = selectionColor;
    
    [self.contentView layoutIfNeeded];

    self.selectionStyle = UITableViewCellSelectionStyleNone;
    
    [self setupLabels];
    
    [self setupImageView];
}

- (void)setupLabels {
    
    UIFont *font;
    if (IS_IPAD) {
        font = [UIFont fontWithName:@"HelveticaNeue" size:38];
    } else {
        font = [UIFont fontWithName:@"HelveticaNeue" size:24];
    }
    
    UIColor *color;
    UIColor *possibleColor;

    if ([[[ARTUserInfo sharedInstance] getVisualTheme] isEqual:@"white"]) {
        if (self.card.isPlayed) {
            color = [UIColor blackColor];

        } else {
            color = [UIColor grayColor];
        }
        possibleColor = [UIColor grayColor];
    } else {
        if (self.card.isPlayed) {
            color = [UIColor whiteColor];
            
        } else {
            color = [UIColor grayColor];
        }
        possibleColor = [UIColor grayColor];
}
    
    NSString *questionNumberString = [NSString stringWithFormat:@"%@", self.card.categoryNumber];;
    
    NSMutableAttributedString *questionNumberAttrString = [[NSMutableAttributedString alloc] initWithString:questionNumberString attributes:@{NSFontAttributeName:font,NSForegroundColorAttributeName:color}];
    
    self.questionNumberLabel.attributedText = questionNumberAttrString;
    self.questionNumberLabel.textAlignment = NSTextAlignmentCenter;
    self.questionNumberLabel.backgroundColor = self.backgroundColor;
    self.questionNumberLabel.opaque = YES;
    
    NSString *possiblePointsString = [NSString stringWithFormat:@"%ld", (long)self.card.possiblePoints];
    
    NSMutableAttributedString *possiblePointsAttrString = [[NSMutableAttributedString alloc] initWithString:possiblePointsString attributes:@{NSFontAttributeName:font,NSForegroundColorAttributeName:possibleColor}];
    
    self.possiblePointsLabel.attributedText = possiblePointsAttrString;
    self.possiblePointsLabel.numberOfLines = 0;
    self.possiblePointsLabel.textAlignment = NSTextAlignmentCenter;
    self.possiblePointsLabel.backgroundColor = self.backgroundColor;
    self.possiblePointsLabel.opaque = YES;
    
    NSString *actualPointsString;
    if (self.card.isPlayed) {
        actualPointsString = [NSString stringWithFormat:@"%ld",(long)self.card.points];
    } else {
        actualPointsString = @"-";
    }
    
    NSMutableAttributedString *actualPointsAttrString = [[NSMutableAttributedString alloc] initWithString:actualPointsString attributes:@{NSFontAttributeName:font,NSForegroundColorAttributeName:color}];
    
    self.actualPointsLabel.attributedText = actualPointsAttrString;
    self.actualPointsLabel.numberOfLines = 0;
    self.actualPointsLabel.textAlignment = NSTextAlignmentCenter;
    self.actualPointsLabel.backgroundColor = self.backgroundColor;
    self.actualPointsLabel.opaque = YES;
}


- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    
}


- (void)setupImageView {
    
    NSString *cardImageName = self.card.frontFilename;
    
    UIImage *image = [[ARTImageHelper sharedInstance] getLQImageWithFileName:cardImageName ];
    
    
    self.cardImageView.image = image;
    
    self.cardImageView.opaque = YES;
    self.cardImageView.contentMode = UIViewContentModeScaleAspectFit;
    
    
}



@end
