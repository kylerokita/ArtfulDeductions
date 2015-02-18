//
//  ARTGalleryCardViewController.h
//  Artful Deductions
//
//  Created by Kyle Rokita on 8/11/14.
//  Copyright (c) 2014 Artful Deductions LLC. All rights reserved.
//

#import <UIKit/UIKit.h>

@class ARTCard;
@class ARTMenuObject;
@class ARTCardScrollView;
@class ARTTopView;

@interface ARTGalleryCardViewController : UIViewController <UINavigationControllerDelegate,UIScrollViewDelegate>

@property (strong, nonatomic) ARTTopView *topView;

@property (strong, nonatomic) IBOutlet UIImageView *logoImageView;
@property (strong, nonatomic) UILabel *logoImageLabel;

@property (strong, nonatomic) IBOutlet ARTCardScrollView *scrollView;
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *scrollViewTopHeightConstraint;
@property (nonatomic) CGFloat scrollViewTopHeightConstraintDefault;

@property (strong, nonatomic) IBOutlet NSLayoutConstraint *scrollViewBottomHeightConstraint;
@property (nonatomic) CGFloat scrollViewBottomHeightConstraintDefault;

@property (strong, nonatomic) IBOutlet ARTMenuObject *bottomMenu;
@property (strong, nonatomic) UIButton *backButton;

@property (strong, nonatomic) ARTCard *cardInView;
@property (strong, nonatomic) NSMutableArray *sortedCardsFromSortedDecks;
@property (strong, nonatomic) NSMutableArray *sortedDecks;
@property ( nonatomic) NSInteger deckIndex;
@property ( nonatomic) NSInteger cardIndex;
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *bottomMenuHeightConstraint;

- (void)backToGalleryTapDetected:(id)sender;


@end
