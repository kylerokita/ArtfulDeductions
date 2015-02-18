//
//  ARTScoreViewController.h
//  Artful Deductions
//
//  Created by Kyle Rokita on 10/16/14.
//  Copyright (c) 2014 Artful Deductions LLC. All rights reserved.
//

#import <UIKit/UIKit.h>

@class ARTTopView;
@class ARTGame;
@class ARTDeck;

@interface ARTScoreViewController : UIViewController <UINavigationControllerDelegate,UITableViewDataSource,UITableViewDelegate>

@property (strong, nonatomic) ARTDeck *deck;
@property (strong, nonatomic) UIImage *backgroundImage;
@property (strong, nonatomic) IBOutlet UIView *popoverPlaceholderView;
@property (strong, nonatomic) IBOutlet UIView *menuPlaceholder;
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *menuHeightConstraint;

@property (strong, nonatomic) IBOutlet UIView *headersPlaceholder;
@property (strong, nonatomic) IBOutlet UILabel *imageHeader;
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *imageHeaderWidthConstraint;
@property (strong, nonatomic) IBOutlet UILabel *questionNumberHeader;
@property (strong, nonatomic) IBOutlet UILabel *possiblePointsHeader;
@property (strong, nonatomic) IBOutlet UILabel *actualPointsHeader;


@property (strong, nonatomic) IBOutlet UIView *scorePlaceholder;
@property (strong, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) IBOutlet UILabel *topLabel;
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *topLabelHeightConstraint;

@property (strong, nonatomic) UIImage *awardImage;
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *totalTotalLabelWidth;
@property (strong, nonatomic) IBOutlet UIView *totalsPlaceholder;
@property (strong, nonatomic) IBOutlet UILabel *totalTotalLabel;
@property (strong, nonatomic) IBOutlet UILabel *totalPossibleLabel;
@property (strong, nonatomic) IBOutlet UILabel *totalActualLabel;

@property (weak, nonatomic) UIViewController *delegate;

@property (strong, nonatomic) UIButton *backButton;

@end
