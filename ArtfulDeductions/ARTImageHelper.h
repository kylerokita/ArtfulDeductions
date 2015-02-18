//
//  ARTImageHelper.h
//  Artful Deductions
//
//  Created by Kyle Rokita on 8/11/14.
//  Copyright (c) 2014 Artful Deductions LLC. All rights reserved.
//

#import <Foundation/Foundation.h>

//@class goes here

@interface ARTImageHelper : NSObject

+ (ARTImageHelper *)sharedInstance;

- (UIImage *)getLQImageWithFileName:(NSString *)filename ;
- (UIImage *)getHQImageWithFileName:(NSString *)filename;


- (UIImage *)getShoppingCartImage;
- (UIImage *)getBackButtonImage ;
- (UIImage *)getLockImage;
- (UIImage *)getLockBlackBorderImage;

- (UIImage *)getStopWatchImage;

- (UIImage *)getLogoWhiteImage;

- (UIImage *)getThumbsUpImage;
- (UIImage *)getThumbsDownImage;


@end
