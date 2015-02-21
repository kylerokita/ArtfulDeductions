//
//  ARTCardOverlayView.h
//  Artful Deductions
//
//  Created by Kyle Rokita on 2/19/15.
//  Copyright (c) 2015 Artful Deductions LLC. All rights reserved.
//

#import <UIKit/UIKit.h>

@class ARTCardViewController;

@interface ARTCardOverlayView : UIView

@property (nonatomic,weak) ARTCardViewController *delegateController;

@end
