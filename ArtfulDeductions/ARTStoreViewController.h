//
//  ARTStoreViewController.h
//  Artful Deductions
//
//  Created by Kyle Rokita on 8/19/14.
//  Copyright (c) 2014 Artful Deductions LLC. All rights reserved.
//

#import <UIKit/UIKit.h>

@class  ARTStoreItem;
@class URBAlertView;
@class ARTTopView;

@interface ARTStoreViewController : UIViewController <UITableViewDataSource,UITableViewDelegate,UINavigationControllerDelegate>

@property (strong, nonatomic) IBOutlet UIImageView *logoImageView;
@property (strong, nonatomic) IBOutlet UITableView *tableView;

@property (strong, nonatomic) NSArray *storeItems;
@property (strong, nonatomic) NSMutableArray *storeItemsToShow;
@property (strong, nonatomic) ARTStoreItem *selectedStoreItem;

@property (strong, nonatomic) UIButton *backButton;
@property (strong, nonatomic) UIButton *restoreButton;

@property (strong, nonatomic) ARTTopView *topView;


@property (strong, nonatomic) URBAlertView *restoreAlertView;

@property (strong, nonatomic) IBOutlet UISegmentedControl *purchaseSegmentControl;

@property (strong, nonatomic) NSTimer *storeRefreshTimer;

- (IBAction)purchaseSegmentControlChanged:(id)sender;


- (void)setupStoreItems ;

@end
