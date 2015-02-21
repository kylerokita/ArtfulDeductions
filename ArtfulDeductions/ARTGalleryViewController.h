//
//  ARTGalleryViewController.h
//  Artful Deductions
//
//  Created by Kyle Rokita on 8/9/14.
//  Copyright (c) 2014 Artful Deductions LLC. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <iAd/iAd.h>

@class URBAlertView;
@class ARTTopView;

@interface ARTGalleryViewController : UIViewController <UICollectionViewDataSource,UICollectionViewDelegate,UICollectionViewDelegateFlowLayout,UINavigationControllerDelegate>

@property (strong, nonatomic) IBOutlet UIImageView *logoImageView;
@property (strong, nonatomic) IBOutlet UICollectionView *collectionView;
@property (strong, nonatomic) IBOutlet UISegmentedControl *numberColumnsSegmentControl;
@property (strong, nonatomic) IBOutlet UILabel *numberColumnsLabel;
@property (nonatomic) NSInteger numberOfColumns;

@property (strong, nonatomic) UIButton *optionButton;
@property (strong, nonatomic) UIButton *doneButton;

@property (strong, nonatomic) IBOutlet NSLayoutConstraint *detailHeightConstraint;
@property (nonatomic) CGFloat detailHeightConstraintDefault;
@property (strong, nonatomic) IBOutlet UIView *detailView;

@property (strong, nonatomic) IBOutlet NSLayoutConstraint *toolbarHeightConstraint;
@property (nonatomic) CGFloat toolbarHeightConstraintDefault;

@property (nonatomic, strong) NSOperationQueue *imageQueue;

@property (nonatomic, strong) URBAlertView *cardNotPlayedAlertView;
@property (nonatomic, strong) URBAlertView *deckNotEnabledAlertView;

@property (strong, nonatomic) ARTTopView *topView;

@property (strong, nonatomic) UIButton *backButton;

@property (nonatomic, strong) NSIndexPath *indexPathShowsNoImage;

- (IBAction)numberColumnsSegmentChanged:(id)sender;
- (IBAction)detailBarButtonClicked:(id)sender;

- (void)animateTappedCardToPileWithIndexPath:(NSIndexPath *)indexPath;


@end
