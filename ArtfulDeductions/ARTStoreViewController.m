//
//  ARTStoreViewController.m
//  Artful Deductions
//
//  Created by Kyle Rokita on 8/19/14.
//  Copyright (c) 2014 Artful Deductions LLC. All rights reserved.
//

#import "ARTStoreViewController.h"
#import "ARTNavigationController.h"
#import "ARTStoreTableViewCell.h"
#import "ARTStoreItem.h"
#import "ARTDeck.h"
#import "ARTStoreItemViewController.h"
//#import "ARTIAPHelper.h"
#import "ARTUserInfo.h"
#import "UIColor+Extensions.h"
#import "URBAlertView.h"
#import "ARTConstants.h"
#import "ARTTopView.h"
#import "UIButton+Extensions.h"
#import "MKStoreManager.h"
#import "ARTImageHelper.h"

@interface ARTStoreViewController () {
}

@end

@implementation ARTStoreViewController


- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    if ([[[ARTUserInfo sharedInstance] getVisualTheme] isEqual:@"white"]) {
        self.view.backgroundColor = [UIColor lightBackgroundColor]; //darkmode
    } else {
        self.view.backgroundColor = [UIColor darkBackgroundColor]; //darkmode
    }
    
    self.purchaseSegmentControl.selectedSegmentIndex = 0;
    
    [self setupLogoImageView];
    
    self.backButton = [[UIButton alloc] backButtonWith:@"Menu" tintColor:[UIColor blueNavBarColor] target:self andAction:@selector(backButtonTapped:)];
    [self.view addSubview:self.backButton];
    
    UIFont *font;
    if (IS_IPAD) {
        font = [UIFont fontWithName:@"HelveticaNeue" size:29.0];
    } else if (IS_IPHONE_5) {
        font = [UIFont fontWithName:@"HelveticaNeue" size:16.0];
    } else {
        font = [UIFont fontWithName:@"HelveticaNeue" size:19.0];
    }
    
    NSMutableAttributedString *attrString = [[NSMutableAttributedString alloc] initWithString:@"Restore" attributes:@{NSFontAttributeName:font,NSForegroundColorAttributeName:[UIColor blueNavBarColor]}];
    
    self.restoreButton = [[UIButton alloc] rightButtonWith:attrString tintColor:[UIColor blueNavBarColor] target:self andAction:@selector(restoreButtonTouched:) withViewWidth:self.view.bounds.size.width ];
    
    [self.view addSubview:self.restoreButton];

}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void) viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.navigationController.delegate = self;
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                           selector:@selector(setupStoreItems)
                               name:kProductFetchedNotification
                             object:nil];
    
    
    [(ARTNavigationController*)[self navigationController] setLandscapeOK:NO];
    [self.navigationController setNavigationBarHidden:YES animated:NO];
    
    [self.tableView deselectRowAtIndexPath:[self.tableView indexPathForSelectedRow] animated:NO];
    
  /*  if (self.purchaseSegmentControl.selectedSegmentIndex == 0) {
        [self setupStoreItemsShowingPurchased:NO];
    } else {
        [self setupStoreItemsShowingPurchased:YES];
    }*/
    [self setupStoreItems];
    
    [self setupTableview];
    [self setupSegmentControl];
}

- (void)checkForProducts {
    [[MKStoreManager sharedManager] reloadProducts];
    
    NSLog(@"timer: %@:",self.storeRefreshTimer);

    
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    
    if (self.storeRefreshTimer) {
        [self.storeRefreshTimer invalidate];
        self.storeRefreshTimer = nil;
    }
}


-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    [super prepareForSegue:segue sender:sender];
    
    if ([segue.identifier isEqual:@"StoreItemSegue"]) {
        
        ARTStoreItemViewController *storeViewController = (ARTStoreItemViewController *)segue.destinationViewController;
        
        storeViewController.storeItem = self.selectedStoreItem;
    }
    
}

- (void)setupLogoImageView {
    
    /*if ([[[ARTUserInfo sharedInstance] getVisualTheme] isEqual:@"white"]) {
     self.logoImageView.image = [UIImage imageNamed:@"LogoDarkBlue"]; //darkmode
     } else {
     self.logoImageView.image = [UIImage imageNamed:@"LogoLightBlue"];
     }
     
     self.logoImageView.contentMode = UIViewContentModeScaleAspectFit;*/
    
    self.logoImageView.image = [UIImage new];
    
    UILabel *label = [[UILabel alloc] initWithFrame:self.logoImageView.bounds];
    label.textAlignment = NSTextAlignmentCenter;
    label.text = @"Store";
    
    if ([[[ARTUserInfo sharedInstance] getVisualTheme] isEqual:@"white"]) {
        label.textColor = [UIColor blackColor];
    } else {
        label.textColor = [UIColor lightBlueColor];
    }
    
    label.numberOfLines = 0;

    if (IS_IPAD) {
        label.font = [UIFont fontWithName:@"HelveticaNeue-Medium" size:30];
    }
    else {
        label.font = [UIFont fontWithName:@"HelveticaNeue-Medium" size:20];
    }

    [self.logoImageView addSubview:label];
    [self.view sendSubviewToBack:self.logoImageView];
    
    if (self.topView) {
        [self.topView removeFromSuperview];
        self.topView = nil;
    }
    
    self.topView = [[ARTTopView alloc] init];
    
    [self.view addSubview:self.topView];
    [self.view sendSubviewToBack:self.topView];
}

- (void)setupSegmentControl {
    UIFont * font;
    if (IS_IPAD) {
        font = [UIFont fontWithName:@"HelveticaNeue" size:28];
    }
    else {
        font = [UIFont fontWithName:@"HelveticaNeue" size:18];
    }
    
    NSDictionary *attributes = [NSDictionary dictionaryWithObjectsAndKeys:
                                font, NSFontAttributeName, nil];
    [self.purchaseSegmentControl setTitleTextAttributes:attributes forState:UIControlStateNormal];
    
    //self.purchaseSegmentControl.layer.borderWidth = 1.5;
    if ([[[ARTUserInfo sharedInstance] getVisualTheme] isEqual:@"white"]) {
        self.purchaseSegmentControl.layer.borderColor = [UIColor blueButtonColor].CGColor;
        self.purchaseSegmentControl.tintColor = [UIColor blueButtonColor];
    } else {
        self.purchaseSegmentControl.layer.borderColor = [UIColor blueButtonColor].CGColor;
        self.purchaseSegmentControl.tintColor = [UIColor blueButtonColor];    }
    
    self.purchaseSegmentControl.layer.cornerRadius = 0.0;
    self.purchaseSegmentControl.clipsToBounds = YES;
}

- (void)setupTableview {
    

    
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    
    
    if ([[[ARTUserInfo sharedInstance] getVisualTheme] isEqual:@"white"]) {
        self.tableView.separatorColor = [UIColor blackColor];
        self.tableView.backgroundColor = [UIColor clearColor]; //darkmode


    } else {
        self.tableView.separatorColor = [UIColor blueNavBarColor];
        self.tableView.backgroundColor = [UIColor clearColor]; //darkmode


    }
    
    if (IS_OldIphone) {
        self.tableView.rowHeight = 100.0;
    } else if (IS_IPHONE_5){
        self.tableView.rowHeight = 105.0;
    } else if (IS_IPHONE_6){
        self.tableView.rowHeight = 115.0;
    } else if (IS_IPHONE_6Plus){
        self.tableView.rowHeight = 115.0;
    } else if (IS_IPAD) {
        self.tableView.rowHeight = 170.0;

    }
    
}

- (void)setupStoreItems {
    
    self.storeItems = nil;
    
    //[[ARTIAPHelper sharedInstance] requestProductsWithCompletionHandler:^(BOOL success, NSArray *products) {
       // if (success) {
            self.storeItems = [self makeStoreItemsWithProducts:[MKStoreManager sharedManager].purchasableObjects] ;
    
    if (self.storeItems.count == 0) {
        if (self.storeRefreshTimer) {
            [self.storeRefreshTimer invalidate];
            self.storeRefreshTimer = nil;
        }
        self.storeRefreshTimer = [NSTimer scheduledTimerWithTimeInterval:2.0 target:self selector:@selector(checkForProducts) userInfo:nil repeats:NO];
    } else {
        if (self.storeRefreshTimer) {
            [self.storeRefreshTimer invalidate];
            self.storeRefreshTimer = nil;
        }
    }
    
            if (self.purchaseSegmentControl.selectedSegmentIndex == 0) {
                [self setupStoreItemsShowingPurchased:NO];
            } else {
                [self setupStoreItemsShowingPurchased:YES];
            }
            [self.tableView reloadData];
        //}
       // else {
             /*ARTAlertView *cannotConnectAlert = [[ARTAlertView alloc] initWithTitle:@"Having trouble connecting to Apple's servers" message:@"Please ensure you have an active internet connection and try re-entering the card shop." delegate:self cancelButtonTitle:nil otherButtonTitles:@"Cancel", nil];
            cannotConnectAlert.cancelButtonIndex = 0;
            // optional - add more buttons:
            [cannotConnectAlert show];*/

       // }
    //}];
}

- (NSMutableArray *) makeStoreItemsWithProducts:(NSArray *)products {
    NSMutableArray *storeItems = [NSMutableArray new];
    
    for (id product in products) {
        ARTStoreItem *storeItem = [[ARTStoreItem alloc] initWithSKProduct:product];
        [storeItems addObject:storeItem];
    }
    
    return  storeItems;
}


- (void)setupStoreItemsShowingPurchased:(BOOL)purchasedIndicator {
    
    self.storeItemsToShow = [NSMutableArray new];
    
    for (ARTStoreItem *storeItem in self.storeItems) {
        if ((storeItem.isPurchased && purchasedIndicator) || (!storeItem.isPurchased && !purchasedIndicator)) {
            [self.storeItemsToShow addObject:storeItem];
            
        }
    }
    
    if (self.storeItems.count == 0 && self.storeItemsToShow.count == 0) {
        
        //store content is still loading
        
        ARTStoreItem *loadingStoreItem = [[ARTStoreItem alloc] initWithLoadingProduct];
        [self.storeItemsToShow addObject:loadingStoreItem];
        
    } else if (self.storeItems.count > 0 && self.storeItemsToShow.count == 0 && !purchasedIndicator) {
        
        //store content is loaded and there are no available purchases
        
        ARTStoreItem *emptyStoreItem = [[ARTStoreItem alloc] initWithNoProduct];
        [self.storeItemsToShow addObject:emptyStoreItem];
    } else if (self.storeItems.count > 0 && self.storeItemsToShow.count == 0 && purchasedIndicator) {
        
        //store content is loaded and there have been no purchases
        
        ARTStoreItem *emptyStoreItem = [[ARTStoreItem alloc] initWithNoPurchases];
        [self.storeItemsToShow addObject:emptyStoreItem];
    }
    
    [self.tableView reloadData];
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"TableCell";
    ARTStoreTableViewCell *cell = [self.tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    cell.storeItem = self.storeItemsToShow[indexPath.row];
    cell.delegate = self;
    
    [cell configureCell];
    
    return cell;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    
    return self.storeItemsToShow.count;
}

- (NSIndexPath *)tableView:(UITableView *)tableView willSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell* cell = [tableView cellForRowAtIndexPath:indexPath];
    if(cell.selectionStyle == UITableViewCellSelectionStyleNone){
        return nil;
    }
    return indexPath;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    NSLog(@"Tap Detected");
    
    NSUInteger index = indexPath.row;
    
    self.selectedStoreItem = self.storeItemsToShow[index];

    [self performSegueWithIdentifier:@"StoreItemSegue" sender:self];
}



- (IBAction)purchaseSegmentControlChanged:(id)sender {
    
    if (self.purchaseSegmentControl.selectedSegmentIndex == 0) {
        [self setupStoreItemsShowingPurchased:NO];
    } else if (self.purchaseSegmentControl.selectedSegmentIndex == 1) {
        [self setupStoreItemsShowingPurchased:YES];
    }
    
    [self.tableView reloadData];
}

- (IBAction)restoreButtonTouched:(id)sender {
    
    __weak ARTStoreViewController *wself = self;
    
    self.restoreAlertView = [[URBAlertView alloc] initWithTitle:@"Restore Purchases" message:@"Would you like to restore all previous store purchases?" cancelButtonTitle:@"Cancel" otherButtonTitles: @"Restore", nil];
    [self.restoreAlertView addAlertImage:[[ARTImageHelper sharedInstance] getShoppingCartImage] imageScale:0.6 backgroundColor:[UIColor darkBlueColor] captionText:nil];
    [self.restoreAlertView setHandlerBlock:^(NSInteger buttonIndex, URBAlertView *alertView) {
        __strong ARTStoreViewController *sself = wself;
        
        
        [sself.restoreAlertView hideWithCompletionBlock:^{
            if (buttonIndex == 0) {
                NSLog(@"Cancel clicked");
                
            }
            else if (buttonIndex == 1) {
                NSLog(@"Restore purchases clicked");

                [[MKStoreManager sharedManager] restorePreviousTransactionsOnComplete:^()
                {
                    
                    NSLog(@"Restore completed");

                    //[MKStoreManager setObject:[NSNumber numberWithBool:YES] forKey:@"featureID"];
                    [sself setupStoreItems];
                    
                    URBAlertView *restoreSuccessAlert = [[URBAlertView alloc] initWithTitle:@"Restore Successful" message:@"Your previous purchases have been restored." cancelButtonTitle:@"Continue" otherButtonTitles: nil];
                    [restoreSuccessAlert addAlertImage:[[ARTImageHelper sharedInstance] getShoppingCartImage] imageScale:0.6 backgroundColor:[UIColor darkBlueColor] captionText:nil ];
                    [restoreSuccessAlert showWithAnimation:URBAlertAnimationDefault ];
                }
                 
                    onError:^(NSError* error)
                {
                    
                    NSLog(@"Restore failed");

                    URBAlertView *restoreFailureAlert = [[URBAlertView alloc] initWithTitle:@"Restore Failed" message:@"There was a problem restoring your previous purchases. Please make sure you have an internet connection." cancelButtonTitle:@"Continue" otherButtonTitles: nil];
                    [restoreFailureAlert addAlertImage:[[ARTImageHelper sharedInstance] getShoppingCartImage] imageScale:0.6 backgroundColor:[UIColor darkBlueColor] captionText:nil];
                    [restoreFailureAlert showWithAnimation:URBAlertAnimationDefault];
                }];
            }
        }];
    }];
    [self.restoreAlertView showWithAnimation:URBAlertAnimationDefault ];
    
}

- (void)backButtonTapped:(id)sender {
    
    self.backButton.userInteractionEnabled = NO;
    
    [self.navigationController popViewControllerAnimated:YES];
}

- (void) dealloc {
    self.tableView.delegate = nil;
    self.tableView.dataSource = nil;
}

@end
