//
//  ARTSettingsViewController.h
//  Artful Deductions
//
//  Created by Kyle Rokita on 8/25/14.
//  Copyright (c) 2014 Artful Deductions LLC. All rights reserved.
//

#import <UIKit/UIKit.h>

@class ARTButton;
@class ARTTopView;
@class URBAlertView;

@interface ARTSettingsViewController : UIViewController <UINavigationControllerDelegate,UIViewControllerTransitioningDelegate,UIScrollViewDelegate>

@property (strong, nonatomic) IBOutlet UIScrollView *scrollView;
@property (strong, nonatomic) IBOutlet UIImageView *logoImageView;
@property (strong, nonatomic) ARTTopView *topView;
@property (strong, nonatomic) IBOutlet UIView *settingsPlaceholderView;
@property (strong, nonatomic) IBOutlet UILabel *settingsTitleLabel;
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *settingsTitleLabelHeightConstraint;

@property (strong, nonatomic) IBOutlet UILabel *visualThemeLabel;
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *visualThemeLabelHeightConstraint;
@property (strong, nonatomic) IBOutlet UISegmentedControl *visualSegmentControl;

@property (strong, nonatomic) IBOutlet UIView *otherPlaceholderView;
@property (strong, nonatomic) IBOutlet UILabel *otherLabel;
@property (strong, nonatomic) IBOutlet UILabel *introVideoLabel;
@property (strong, nonatomic) IBOutlet ARTButton *introVideoButton;
@property (strong, nonatomic) IBOutlet ARTButton *resetTutorialsButton;
- (IBAction)resetTutorialsButtonTouched:(id)sender;
@property (strong, nonatomic) IBOutlet UILabel *resetTutorialsLabel;
@property (strong, nonatomic) IBOutlet ARTButton *resetButton;
@property (strong, nonatomic) IBOutlet UIView *aboutPlaceholderView;
@property (strong, nonatomic) IBOutlet ARTButton *aboutUsButton;
- (IBAction)aboutUsTouched:(id)sender;
@property (strong, nonatomic) IBOutlet UILabel *aboutTitleLabel;
@property (strong, nonatomic) IBOutlet ARTButton *patentButton;
- (IBAction)legalTouched:(id)sender;
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *aboutLabelHeightConstraint;

@property (strong, nonatomic) UIView  *overlay;


@property (strong, nonatomic) UIButton *backButton;

- (IBAction)visualSegmentControlChanged:(id)sender;
- (IBAction)introVideoButtonTouched:(id)sender;

@property (nonatomic, strong) URBAlertView *resetButtonAlertView;

- (IBAction)resetButtonTouched:(id)sender;

- (UIView *)pb_takeSnapshotView;


@end
