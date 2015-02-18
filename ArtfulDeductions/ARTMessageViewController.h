//
//  ARTMessageViewController.h
//  Artful Deductions
//
//  Created by Kyle Rokita on 10/17/14.
//  Copyright (c) 2014 Artful Deductions LLC. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ARTMessageViewController : UIViewController <UIScrollViewDelegate, UINavigationControllerDelegate, UIViewControllerTransitioningDelegate>

@property (strong, nonatomic) UIImage *backgroundImage;
@property (strong, nonatomic) IBOutlet UIView *popoverPlaceholderView;
@property (strong, nonatomic) IBOutlet UIView *menuPlaceholder;
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *menuHeightConstraint;
@property (strong, nonatomic) NSMutableArray *menuDictionaries;

@property (strong, nonatomic) IBOutlet UIView *messagePlaceholder;
@property (strong, nonatomic) IBOutlet UIScrollView *messageScrollview;
@property (strong, nonatomic) IBOutlet UIPageControl *pageControl;
- (IBAction)pageValueChanged:(id)sender;
@property (strong, nonatomic) NSMutableArray *messageDictionaries;

@property (strong, nonatomic) IBOutlet UILabel *topLabel;
@property (strong, nonatomic) NSString *topString;

@property (weak, nonatomic) UIViewController *delegate;

@property (strong, nonatomic) UIButton *backButton;


@end
