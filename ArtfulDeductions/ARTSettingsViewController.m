//
//  ARTSettingsViewController.m
//  Artful Deductions
//
//  Created by Kyle Rokita on 8/25/14.
//  Copyright (c) 2014 Artful Deductions LLC. All rights reserved.
//

#import "ARTSettingsViewController.h"
#import "ARTNavigationController.h"
#import "ARTUserInfo.h"
#import "ARTButton.h"
#import "UIColor+Extensions.h"
#import "ARTConstants.h"
#import "ARTTopView.h"
#import "UIButton+Extensions.h"
#import "URBAlertView.h"
#import "ARTGameSaves.h"
#import "ARTMessageViewController.h"
#import "ARTPopoverAnimator.h"
#import "MKStoreManager.h"
#import "ARTCardHelper.h"

@interface ARTSettingsViewController ()

@end

@implementation ARTSettingsViewController


- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.backButton = [[UIButton alloc] backButtonWith:@"Menu" tintColor:[UIColor blueNavBarColor] target:self andAction:@selector(backButtonTapped:)];
    [self.view addSubview:self.backButton];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void) viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    self.navigationController.delegate = self;
    
    [(ARTNavigationController*)[self navigationController] setLandscapeOK:NO];
    [self.navigationController setNavigationBarHidden:YES animated:NO];
    
    if (IS_OldIphone) {
        self.visualThemeLabelHeightConstraint.constant = 35.0;
        self.settingsTitleLabelHeightConstraint.constant = 35.0;
        self.aboutLabelHeightConstraint.constant = 35.0;
    } else if (IS_IPAD) {
        self.visualThemeLabelHeightConstraint.constant = 65.0;
        self.settingsTitleLabelHeightConstraint.constant = 65.0;
        self.aboutLabelHeightConstraint.constant = 65.0;
    } else {
        self.visualThemeLabelHeightConstraint.constant = 45.0;
        self.settingsTitleLabelHeightConstraint.constant = 45.0;
        self.aboutLabelHeightConstraint.constant = 45.0;
    }
    
    NSLayoutConstraint *leadingConstraint = [NSLayoutConstraint constraintWithItem:self.settingsPlaceholderView attribute:NSLayoutAttributeLeading
                                                                      relatedBy:NSLayoutRelationEqual
                                                                         toItem:self.view
                                                                      attribute:NSLayoutAttributeLeading
                                                                     multiplier:1.0 constant:15.0];
    NSLayoutConstraint *trailingConstraint = [NSLayoutConstraint constraintWithItem:self.settingsPlaceholderView attribute:NSLayoutAttributeTrailing
                                                                         relatedBy:NSLayoutRelationEqual
                                                                            toItem:self.view
                                                                         attribute:NSLayoutAttributeTrailing
                                                                        multiplier:1.0 constant:-15.0];
    [self.view addConstraint:leadingConstraint];
    [self.view addConstraint:trailingConstraint];
    
    [self.view layoutIfNeeded];
    
    [self setupScrollView];
    
    [self setupLogoImageView];
    
    [self setupSettingsPlaceholderView];
    [self setupSettingsTitleLabel];
    [self setupVisualThemeLabel];
    [self setupVisualThemeSegmentControl];
    
    [self setupOtherPlaceholderView];
    [self setupIntroVideoButton];
    [self setupIntroVideoLabel];
    [self setupOtherLabel];
    [self setupResetTutorialsButton];
    [self setupResetTutorialsLabel];
    [self setupResetButton];
    
    [self setupAboutPlaceholderView];
    [self setupAboutTitleLabel];
    [self setupAboutUsButton];
    [self setupLegalButton];
    
    if ([[[ARTUserInfo sharedInstance] getVisualTheme] isEqual:@"white"]) {
        [self preferredStatusBarStyleIsBlack:YES];
        self.view.backgroundColor = [UIColor lightBackgroundColor];

    } else {
        [self preferredStatusBarStyleIsBlack:NO]; //darkmode
        self.view.backgroundColor = [UIColor darkBackgroundColor]; //darkmode
    }
}

- (void)setupScrollView {
    self.scrollView.backgroundColor = [UIColor clearColor];
    self.scrollView.delegate = self;

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
    label.text = @"Settings";
    
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

- (void) setupSettingsPlaceholderView {
    self.settingsPlaceholderView.backgroundColor = [UIColor detailViewBlueColor];
    self.settingsPlaceholderView.layer.cornerRadius = 15.0;
    
    if ([[[ARTUserInfo sharedInstance] getVisualTheme] isEqual:@"white"]) {
        self.settingsPlaceholderView.backgroundColor = [UIColor lightBlueColor];
        self.settingsPlaceholderView.layer.borderColor = [UIColor blackColor].CGColor;
        self.settingsPlaceholderView.layer.borderWidth = 1.0;

        
    } else {
        self.settingsPlaceholderView.backgroundColor = [UIColor detailViewBlueColor];
        self.settingsPlaceholderView.layer.borderColor = [UIColor blueNavBarColor].CGColor;
        self.settingsPlaceholderView.layer.borderWidth = 1.0;

    }
}

- (void) setupOtherPlaceholderView {
    self.otherPlaceholderView.backgroundColor = [UIColor detailViewBlueColor];
    self.otherPlaceholderView.layer.cornerRadius = 15.0;
    
    if ([[[ARTUserInfo sharedInstance] getVisualTheme] isEqual:@"white"]) {
        self.otherPlaceholderView.backgroundColor = [UIColor lightBlueColor];
        self.otherPlaceholderView.layer.borderColor = [UIColor blackColor].CGColor;
        self.otherPlaceholderView.layer.borderWidth = 1.0;

        
    } else {
        self.otherPlaceholderView.backgroundColor = [UIColor detailViewBlueColor];
        self.otherPlaceholderView.layer.borderColor = [UIColor blueNavBarColor].CGColor;
        self.otherPlaceholderView.layer.borderWidth = 1.0;

    }
}

- (void) setupAboutPlaceholderView {
    self.aboutPlaceholderView.backgroundColor = [UIColor detailViewBlueColor];
    self.aboutPlaceholderView.layer.cornerRadius = 15.0;
    
    if ([[[ARTUserInfo sharedInstance] getVisualTheme] isEqual:@"white"]) {
        self.aboutPlaceholderView.backgroundColor = [UIColor lightBlueColor];
        self.aboutPlaceholderView.layer.borderColor = [UIColor blackColor].CGColor;
        self.aboutPlaceholderView.layer.borderWidth = 1.0;
        
        
    } else {
        self.aboutPlaceholderView.backgroundColor = [UIColor detailViewBlueColor];
        self.aboutPlaceholderView.layer.borderColor = [UIColor blueNavBarColor].CGColor;
        self.aboutPlaceholderView.layer.borderWidth = 1.0;
        
    }
}

- (void) setupAboutTitleLabel {
    self.aboutTitleLabel.textAlignment = NSTextAlignmentCenter;
    self.settingsTitleLabel.layer.cornerRadius = 15.0;
    
    UIFont * font;
    if (IS_IPAD) {
        font = [UIFont fontWithName:@"HelveticaNeue" size:36];
    }
    else {
        font = [UIFont fontWithName:@"HelveticaNeue" size:26];
    }
    
    UIColor *color;
    if ([[[ARTUserInfo sharedInstance] getVisualTheme] isEqual:@"white"]) {
        color = [UIColor blackColor];
        self.aboutTitleLabel.backgroundColor = [UIColor lightBlueColor];
        self.aboutTitleLabel.layer.borderWidth = 1.0;
        self.aboutTitleLabel.layer.borderColor = [UIColor clearColor].CGColor;
    } else {
        color = [UIColor whiteColor];
        self.aboutTitleLabel.backgroundColor = [UIColor detailViewBlueColor];
        self.aboutTitleLabel.layer.borderWidth = 1.0;
        self.aboutTitleLabel.layer.borderColor = [UIColor clearColor].CGColor;
    }
    
    NSMutableAttributedString *attrString = [[NSMutableAttributedString alloc] initWithString:@"About" attributes:@{NSFontAttributeName:font,NSForegroundColorAttributeName:color}];
    self.aboutTitleLabel.attributedText = attrString;
}

- (void) setupSettingsTitleLabel {
    self.settingsTitleLabel.textAlignment = NSTextAlignmentCenter;
    self.settingsTitleLabel.layer.cornerRadius = 15.0;
    
    UIFont * font;
    if (IS_IPAD) {
        font = [UIFont fontWithName:@"HelveticaNeue" size:36];
    }
    else {
        font = [UIFont fontWithName:@"HelveticaNeue" size:26];
    }
    
    UIColor *color;
    if ([[[ARTUserInfo sharedInstance] getVisualTheme] isEqual:@"white"]) {
        color = [UIColor blackColor];
        self.settingsTitleLabel.backgroundColor = [UIColor lightBlueColor];
        self.settingsTitleLabel.layer.borderWidth = 1.0;
        self.settingsTitleLabel.layer.borderColor = [UIColor clearColor].CGColor;
    } else {
        color = [UIColor whiteColor];
        self.settingsTitleLabel.backgroundColor = [UIColor detailViewBlueColor];
        self.settingsTitleLabel.layer.borderWidth = 1.0;
        self.settingsTitleLabel.layer.borderColor = [UIColor clearColor].CGColor;
    }
    
    NSMutableAttributedString *attrString = [[NSMutableAttributedString alloc] initWithString:@"Settings" attributes:@{NSFontAttributeName:font,NSForegroundColorAttributeName:color}];
    self.settingsTitleLabel.attributedText = attrString;
}

- (void) setupVisualThemeLabel {
    self.visualThemeLabel.text = @"Visual Theme:";
    
    UIFont * font;
    if (IS_IPAD) {
        font = [UIFont fontWithName:@"HelveticaNeue" size:28];
    }
    else {
        font = [UIFont fontWithName:@"HelveticaNeue" size:18];
    }
    
    self.visualThemeLabel.font = font;
    
    if ([[[ARTUserInfo sharedInstance] getVisualTheme] isEqual:@"white"]) {
        
        self.visualThemeLabel.textColor = [UIColor blackColor];

    } else {
        self.visualThemeLabel.textColor = [UIColor whiteColor];

    }
    
}

- (void) setupVisualThemeSegmentControl {
    self.visualSegmentControl.layer.borderWidth = 1.5;

    self.visualSegmentControl.layer.cornerRadius = self.visualSegmentControl.bounds.size.height / 2.0;
    self.visualSegmentControl.clipsToBounds = YES;
    
    UIFont * font;
    if (IS_IPAD) {
        font = [UIFont fontWithName:@"HelveticaNeue" size:28];
    }
    else {
        font = [UIFont fontWithName:@"HelveticaNeue" size:18];
    }
    
    NSDictionary *attributes = [NSDictionary dictionaryWithObjectsAndKeys:
                                font, NSFontAttributeName, nil];
    [self.visualSegmentControl setTitleTextAttributes:attributes forState:UIControlStateNormal];
    
    self.visualSegmentControl.layer.borderColor = [UIColor blueButtonColor].CGColor;
    self.visualSegmentControl.tintColor = [UIColor blueButtonColor];
    
    if ([[[ARTUserInfo sharedInstance] getVisualTheme] isEqual:@"white"]) {
        self.visualSegmentControl.selectedSegmentIndex = 1;
        
    } else {
        self.visualSegmentControl.selectedSegmentIndex = 2;
    }
    


}

- (void)preferredStatusBarStyleIsBlack:(BOOL)preferBlackIndicator {
    
    if (preferBlackIndicator) {
        [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleDefault];
    } else {
        [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
    }
}

- (void) setupOtherLabel {
    self.otherLabel.textAlignment = NSTextAlignmentCenter;
    self.otherLabel.layer.cornerRadius = 15.0;
    
    UIFont * font;
    if (IS_IPAD) {
        font = [UIFont fontWithName:@"HelveticaNeue" size:36];
    }
    else {
        font = [UIFont fontWithName:@"HelveticaNeue" size:26];
    }
    
    UIColor *color;
    if ([[[ARTUserInfo sharedInstance] getVisualTheme] isEqual:@"white"]) {
         color = [UIColor blackColor];
        self.otherLabel.backgroundColor = [UIColor lightBlueColor];
        self.otherLabel.layer.borderWidth = 1.0;
        self.otherLabel.layer.borderColor = [UIColor clearColor].CGColor;
    } else {
        color = [UIColor whiteColor];
        self.otherLabel.backgroundColor = [UIColor detailViewBlueColor];
        self.otherLabel.layer.borderWidth = 1.0;
        self.otherLabel.layer.borderColor = [UIColor clearColor].CGColor;
    }
    
    NSMutableAttributedString *attrString = [[NSMutableAttributedString alloc] initWithString:@"Miscellaneous" attributes:@{NSFontAttributeName:font,NSForegroundColorAttributeName:color}];
    self.otherLabel.attributedText = attrString;
    
}

- (void) setupIntroVideoLabel {
    self.introVideoLabel.text = @"Game Intro Scene:";
    
    UIFont * font;
    if (IS_IPAD) {
        font = [UIFont fontWithName:@"HelveticaNeue" size:28];
    }
    else {
        font = [UIFont fontWithName:@"HelveticaNeue" size:18];
    }
    
    self.introVideoLabel.font = font;
    
    if ([[[ARTUserInfo sharedInstance] getVisualTheme] isEqual:@"white"]) {
        
        self.introVideoLabel.textColor = [UIColor blackColor];
        
    } else {
        self.introVideoLabel.textColor = [UIColor whiteColor];
    }
    
}

- (void)setupIntroVideoButton {
    [self.introVideoButton applyStandardFormatting];
    [self.introVideoButton makeGlossy];

    
    UIFont * font;
    if (IS_IPAD) {
        font = [UIFont fontWithName:@"HelveticaNeue" size:28];
    }
    else {
        font = [UIFont fontWithName:@"HelveticaNeue" size:18];
    }
    
    UIColor *color;
    if ([[[ARTUserInfo sharedInstance] getVisualTheme] isEqual:@"white"]) {
        
        color = [UIColor whiteColor];
        
    } else {
        color = [UIColor whiteColor];
    }
    
    NSMutableAttributedString *attrString = [[NSMutableAttributedString alloc] initWithString:@"\u25B6\U0000FE0E Replay" attributes:@{NSFontAttributeName:font,NSForegroundColorAttributeName:color}];
    [self.introVideoButton setAttributedTitle:attrString forState:UIControlStateNormal];
    
}

- (void)setupAboutUsButton {
    [self.aboutUsButton applyStandardFormatting];
    [self.aboutUsButton makeGlossy];
    
    
    UIFont * font;
    if (IS_IPAD) {
        font = [UIFont fontWithName:@"HelveticaNeue" size:28];
    }
    else {
        font = [UIFont fontWithName:@"HelveticaNeue" size:18];
    }
    
    UIColor *color;
    if ([[[ARTUserInfo sharedInstance] getVisualTheme] isEqual:@"white"]) {
        
        color = [UIColor whiteColor];
        
    } else {
        color = [UIColor whiteColor];
    }
    
    NSMutableAttributedString *attrString = [[NSMutableAttributedString alloc] initWithString:@"About & Contact Info" attributes:@{NSFontAttributeName:font,NSForegroundColorAttributeName:color}];
    [self.aboutUsButton setAttributedTitle:attrString forState:UIControlStateNormal];
    
}

- (void)setupLegalButton {
    [self.patentButton applyStandardFormatting];
    [self.patentButton makeGlossy];
    
    
    UIFont * font;
    if (IS_IPAD) {
        font = [UIFont fontWithName:@"HelveticaNeue" size:28];
    }
    else {
        font = [UIFont fontWithName:@"HelveticaNeue" size:18];
    }
    
    UIColor *color;
    if ([[[ARTUserInfo sharedInstance] getVisualTheme] isEqual:@"white"]) {
        
        color = [UIColor whiteColor];
        
    } else {
        color = [UIColor whiteColor];
    }
    
    NSMutableAttributedString *attrString = [[NSMutableAttributedString alloc] initWithString:@"Legal Info" attributes:@{NSFontAttributeName:font,NSForegroundColorAttributeName:color}];
    [self.patentButton setAttributedTitle:attrString forState:UIControlStateNormal];
    
}

- (void) setupResetTutorialsLabel {
    self.resetTutorialsLabel.text = @"Game Instructions:";
    
    UIFont * font;
    if (IS_IPAD) {
        font = [UIFont fontWithName:@"HelveticaNeue" size:28];
    }
    else {
        font = [UIFont fontWithName:@"HelveticaNeue" size:18];
    }
    
    self.resetTutorialsLabel.font = font;
    
    if ([[[ARTUserInfo sharedInstance] getVisualTheme] isEqual:@"white"]) {
        
        self.resetTutorialsLabel.textColor = [UIColor blackColor];
        
    } else {
        self.resetTutorialsLabel.textColor = [UIColor whiteColor];
    }
    
}

- (void)setupResetTutorialsButton {
    [self.resetTutorialsButton applyStandardFormatting];
    [self.resetTutorialsButton makeGlossy];
    
    
    UIFont * font;
    if (IS_IPAD) {
        font = [UIFont fontWithName:@"HelveticaNeue" size:28];
    }
    else {
        font = [UIFont fontWithName:@"HelveticaNeue" size:18];
    }
    
    UIColor *color;
    if ([[[ARTUserInfo sharedInstance] getVisualTheme] isEqual:@"white"]) {
        
        color = [UIColor whiteColor];
        
    } else {
        color = [UIColor whiteColor];
    }
    
    NSMutableAttributedString *attrString = [[NSMutableAttributedString alloc] initWithString:@"Read" attributes:@{NSFontAttributeName:font,NSForegroundColorAttributeName:color}];
    [self.resetTutorialsButton setAttributedTitle:attrString forState:UIControlStateNormal];
    
}


- (void)setupResetButton {
    [self.resetButton applyStandardFormatting];
    [self.resetButton makeGlossy];
    [self.resetButton setEmergencyRed];

    
    UIFont * font;
    if (IS_IPAD) {
        font = [UIFont fontWithName:@"HelveticaNeue" size:28];
    }
    else {
        font = [UIFont fontWithName:@"HelveticaNeue" size:18];
    }
    
    UIColor *color;
    if ([[[ARTUserInfo sharedInstance] getVisualTheme] isEqual:@"white"]) {
        
        color = [UIColor whiteColor];
        
    } else {
        color = [UIColor whiteColor];
    }
    
    NSMutableAttributedString *attrString = [[NSMutableAttributedString alloc] initWithString:@"Reset Game" attributes:@{NSFontAttributeName:font,NSForegroundColorAttributeName:color}];
    [self.resetButton setAttributedTitle:attrString forState:UIControlStateNormal];
    
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (IBAction)visualSegmentControlChanged:(id)sender {
    
    if (self.visualSegmentControl.selectedSegmentIndex == 1) {
        [[ARTUserInfo sharedInstance] saveVisualTheme:@"white"];
        
        [self viewWillAppear:NO];

    } else {
        [[ARTUserInfo sharedInstance] saveVisualTheme:@"black"];
        
        [self viewWillAppear:NO];

    }
    
    [(ARTNavigationController *)self.navigationController setupAlertViewAppearance];
    
    
}

- (IBAction)introVideoButtonTouched:(id)sender {
    [((ARTButton *)sender) setCustomHighlighted:YES];
    
    [[ARTUserInfo sharedInstance] saveShowIntro:@"YES"];
    
    [self.navigationController popViewControllerAnimated:YES];
    
}

- (void)backButtonTapped:(id)sender {
    
    self.backButton.userInteractionEnabled = NO;
    
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)resetButtonTouched:(id)sender {
    
    __weak ARTSettingsViewController *wself = self;
    
    self.resetButtonAlertView = [[URBAlertView alloc] initWithTitle:@"Really Reset?" message:@"Resetting will delete all players and game progress. Downloads and purchases CAN be restored for free after reset." cancelButtonTitle:@"Cancel" otherButtonTitles:@"Reset Game", nil];
    
    self.resetButtonAlertView.backgroundColor = [[UIColor emergencyRedColor] colorWithAlphaComponent:1.0];
    self.resetButtonAlertView.buttonBackgroundColor = [[UIColor emergencyRedColor] colorWithAlphaComponent:1.0];
    
    
    [self.resetButtonAlertView setHandlerBlock:^(NSInteger buttonIndex, URBAlertView *alertView) {
        __strong ARTSettingsViewController *sself = wself;
        
        [sself.resetButtonAlertView hideWithCompletionBlock:^{

            if (buttonIndex == 1) {
                [sself resetApp];
            }
        }];
    }];
    [self.resetButtonAlertView showWithAnimation:URBAlertAnimationDefault ];
}

- (void)resetApp {
    [[ARTGameSaves sharedInstance] resetGameSaves];
    
    [[ARTCardHelper sharedInstance] resetCardDecks];

    [[ARTUserInfo sharedInstance] resetUserInfo];
    
    NSString *appDomain = [[NSBundle mainBundle] bundleIdentifier];
    [[NSUserDefaults standardUserDefaults] removePersistentDomainForName:appDomain];
    
    [[MKStoreManager sharedManager] removeAllKeychainData];
        
    [self.navigationController popToRootViewControllerAnimated:YES];
     
}
- (IBAction)resetTutorialsButtonTouched:(id)sender {
    
    /*[[ARTUserInfo sharedInstance] resetTutorials];
    
    URBAlertView *resetTutorialsAlertView = [[URBAlertView alloc] initWithTitle:@"Tutorials Reset!" message:@"Tutorials will show the next time you play." cancelButtonTitle:@"Continue" otherButtonTitles: nil];

    [resetTutorialsAlertView showWithAnimation:URBAlertAnimationDefault ];*/
    
    [self showInstructions];
}

- (void) showWhoIsArtfulMessage {
    
    UIStoryboard *storyboard;
    if (IS_IPAD) {
        storyboard = [UIStoryboard storyboardWithName:@"Storyboard" bundle:nil];
        
    } else {
        storyboard = [UIStoryboard storyboardWithName:@"Main_iPhone" bundle:nil];
        
    }
    ARTMessageViewController *vc = (ARTMessageViewController *)[storyboard instantiateViewControllerWithIdentifier:@"MessageViewController"];
    
    vc.topString = @"About & Contact Info";
    
    NSString *header1 = @"About";
    NSString *body1 = [NSString stringWithFormat:@"%@ was developed using extensive research to uncover highly interesting trivia people are unlikely to know.\n\nMore trivia is coming soon so STAY TUNED!",appTitle];
    NSMutableDictionary *dict1 = [NSMutableDictionary new];
    [dict1 setObject:header1 forKey:@"headerText"];
    [dict1 setObject:body1 forKey:@"bodyText"];
    
    NSString *header2 = @"Acknowledgements";
    NSString *body2 = [NSString stringWithFormat:@"Thanks to our Family and Friends for the support!\n\nThanks to you in advance for telling your friends about %@!",appTitle];
    NSMutableDictionary *dict2 = [NSMutableDictionary new];
    [dict2 setObject:header2 forKey:@"headerText"];
    [dict2 setObject:body2 forKey:@"bodyText"];
    
    NSString *header3 = @"Contact Info";
    NSString *body3 = [NSString stringWithFormat:@"We'd love to hear from you!\n\nPlease reach out to us at:\n\t%@",emailAddress];
    NSMutableDictionary *dict3 = [NSMutableDictionary new];
    [dict3 setObject:header3 forKey:@"headerText"];
    [dict3 setObject:body3 forKey:@"bodyText"];
    
    NSMutableArray *arrayOfMessages = [NSMutableArray arrayWithObjects:dict1, dict2, dict3, nil];
    
    vc.messageDictionaries = arrayOfMessages;
    
    NSString *button1Title = @"Continue";
    
    NSMutableDictionary *buttonDict = [NSMutableDictionary new];
    [buttonDict setObject:button1Title forKey:@"buttonTitle"];
    
    NSMutableArray *arrayOfButtons = [NSMutableArray arrayWithObjects:buttonDict, nil];
    
    vc.messageDictionaries = arrayOfMessages;
    vc.menuDictionaries = arrayOfButtons;
    
    vc.delegate = self;
    
    vc.transitioningDelegate = self;
    vc.modalPresentationStyle = UIModalPresentationCustom;
    
    [self presentViewController:vc animated:YES completion:^{
        
        self.view.userInteractionEnabled = YES;
        
        
    }];
}

- (void) showLegalInfo {
    
    UIStoryboard *storyboard;
    if (IS_IPAD) {
        storyboard = [UIStoryboard storyboardWithName:@"Storyboard" bundle:nil];
        
    } else {
        storyboard = [UIStoryboard storyboardWithName:@"Main_iPhone" bundle:nil];
        
    }
    ARTMessageViewController *vc = (ARTMessageViewController *)[storyboard instantiateViewControllerWithIdentifier:@"MessageViewController"];
    
    vc.topString = @"Legal Info";
    
    NSString *header1 = @"Legal & Patent";
    NSString *body1 = @"\u00A9 2014 Artful Deductions, a limited liability company.\n\nArtful Deductions is a registered trademark of Artful Deductions, a California limited liability company. All rights reserved.\n\nPatent Pending.";
    NSMutableDictionary *dict1 = [NSMutableDictionary new];
    [dict1 setObject:header1 forKey:@"headerText"];
    [dict1 setObject:body1 forKey:@"bodyText"];
    
    NSMutableArray *arrayOfMessages = [NSMutableArray arrayWithObjects:dict1, nil];
    
    vc.messageDictionaries = arrayOfMessages;
    
    NSString *button1Title = @"Continue";
    
    NSMutableDictionary *buttonDict = [NSMutableDictionary new];
    [buttonDict setObject:button1Title forKey:@"buttonTitle"];
    
    NSMutableArray *arrayOfButtons = [NSMutableArray arrayWithObjects:buttonDict, nil];
    
    vc.messageDictionaries = arrayOfMessages;
    vc.menuDictionaries = arrayOfButtons;
    
    vc.delegate = self;
    
    vc.transitioningDelegate = self;
    vc.modalPresentationStyle = UIModalPresentationCustom;
    
    [self presentViewController:vc animated:YES completion:^{
        
        self.view.userInteractionEnabled = YES;
        
        
    }];
}

- (void)showOverlay:(BOOL)show {
    
    if (show) {
        if (!self.overlay) {
            self.overlay = [[UIView alloc] initWithFrame:self.view.bounds];
            self.overlay.opaque = YES;
            
            self.overlay.backgroundColor = [UIColor colorWithRed: 0 green: 0 blue: 0 alpha: 0.8];
            
            [self.view addSubview:self.overlay];
        }
        
        
    } else {
        
        if (self.overlay) {
            [self.overlay removeFromSuperview];
            self.overlay = nil;
        }
        
    }
}

- (id<UIViewControllerAnimatedTransitioning>)animationControllerForPresentedController:(UIViewController *)presented
                                                                  presentingController:(UIViewController *)presenting
                                                                      sourceController:(UIViewController *)source {
    
    ARTPopoverAnimator *animator = [ARTPopoverAnimator new];
    animator.onScreenIndicator = YES;
    animator.delegateController = self;
    animator.landscapeOKOnExit = NO;
    return animator;
}

- (id<UIViewControllerAnimatedTransitioning>)animationControllerForDismissedController:(UIViewController *)dismissed {
    ARTPopoverAnimator *animator = [ARTPopoverAnimator new];
    animator.onScreenIndicator = NO;
    animator.delegateController = self;
    animator.landscapeOKOnExit = NO;
    return animator;
}
- (IBAction)aboutUsTouched:(id)sender {
    [((ARTButton *)sender) setCustomHighlighted:YES];
    
    [self showWhoIsArtfulMessage];
}
- (IBAction)legalTouched:(id)sender {
    [self showLegalInfo];

}

- (UIView *)pb_takeSnapshotView {
    //UIGraphicsBeginImageContextWithOptions(self.view.bounds.size, NO, [UIScreen mainScreen].scale);
    
    UIView *snapshot = [self.view snapshotViewAfterScreenUpdates:YES];
    
    // old style [self.layer renderInContext:UIGraphicsGetCurrentContext()];
    
    //UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    //UIGraphicsEndImageContext();
    return snapshot;
}

- (void) showInstructions {
    
    UIStoryboard *storyboard;
    if (IS_IPAD) {
        storyboard = [UIStoryboard storyboardWithName:@"Storyboard" bundle:nil];
        
    } else {
        storyboard = [UIStoryboard storyboardWithName:@"Main_iPhone" bundle:nil];
        
    }
    ARTMessageViewController *vc = (ARTMessageViewController *)[storyboard instantiateViewControllerWithIdentifier:@"MessageViewController"];
    
    vc.topString = @"Game Instructions";
    
    NSString *header1 = @"Trivia Question";
    NSString *body1 = [NSString stringWithFormat:@"The question is displayed after you tap the Start Button.\n\nYou have %ld SECONDS to solve the question.",(long)secondsForQuestion];
    NSMutableDictionary *dict1 = [NSMutableDictionary new];
    [dict1 setObject:header1 forKey:@"headerText"];
    [dict1 setObject:body1 forKey:@"bodyText"];
    
    NSString *header4 = @"Trivia Answer";
    NSString *body4 = @"You only need to type in the FIRST 4 LETTERS of each word.\n\nYou are NOT penalized for entering incorrect answers, so KEEP TRYING.";
    NSMutableDictionary *dict4 = [NSMutableDictionary new];
    [dict4 setObject:header4 forKey:@"headerText"];
    [dict4 setObject:body4 forKey:@"bodyText"];
    
    NSString *header2 = @"Trivia Art";
    NSString *body2 = @"The art often CONTAINS CLUES to help answer the question.\n\nZOOM IN/OUT by pinching or double tapping on the art.";
    NSMutableDictionary *dict2 = [NSMutableDictionary new];
    [dict2 setObject:header2 forKey:@"headerText"];
    [dict2 setObject:body2 forKey:@"bodyText"];
    
    NSString *header3 = @"Hints";
    NSString *body3 = @"For each question, you can get answer hints by tapping the Hint button.\n\nEach hint partially fills in letters from the answer.";
    NSMutableDictionary *dict3 = [NSMutableDictionary new];
    [dict3 setObject:header3 forKey:@"headerText"];
    [dict3 setObject:body3 forKey:@"bodyText"];
    
    NSString *header5 = @"Scoring";
    NSString *body5 = @"You get fewer points for using hints.\n\nNo hint:\t5 points\n1 hint:   \t4 points\n2 hints:  \t3 points\n3 hints:  \t2 points";
    NSMutableDictionary *dict5 = [NSMutableDictionary new];
    [dict5 setObject:header5 forKey:@"headerText"];
    [dict5 setObject:body5 forKey:@"bodyText"];
    
    
    NSMutableArray *arrayOfMessages = [NSMutableArray arrayWithObjects:dict2, dict1, dict4, dict3, dict5, nil];
    
    vc.messageDictionaries = arrayOfMessages;
    
    NSString *button1Title = @"Continue";
    
    NSMutableDictionary *buttonDict = [NSMutableDictionary new];
    [buttonDict setObject:button1Title forKey:@"buttonTitle"];
    
    NSMutableArray *arrayOfButtons = [NSMutableArray arrayWithObjects:buttonDict, nil];
    
    vc.messageDictionaries = arrayOfMessages;
    vc.menuDictionaries = arrayOfButtons;
    
    vc.delegate = self;
    
    vc.transitioningDelegate = self;
    vc.modalPresentationStyle = UIModalPresentationCustom;
    
    [self presentViewController:vc animated:YES completion:^{
        
        self.view.userInteractionEnabled = YES; //after tutorial is shown, allow user interaction
        
    }];
}
@end
