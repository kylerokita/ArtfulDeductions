//
//  ARTGameViewControllerDelegate.h
//  ArtfulDeductions
//
//  Created by Kyle Rokita on 7/6/14.
//  Copyright (c) 2014 Artful Deductions LLC. All rights reserved.
//

#import <Foundation/Foundation.h>

@class ARTGame;

@protocol ARTGameDelegate <NSObject>

- (void)questionTimerExpired;
- (void)updateCardOverlayStatusViews;

@end
