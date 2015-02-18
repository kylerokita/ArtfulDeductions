//
//  ARTImageHelper.m
//  Artful Deductions
//
//  Created by Kyle Rokita on 8/11/14.
//  Copyright (c) 2014 Artful Deductions LLC. All rights reserved.
//

#import "ARTImageHelper.h"
#import "ARTDeck.h"
#import "UIImage+Customization.h"
#import "UIColor+Extensions.h"
#import "ARTConstants.h"
#import "ARTCardHelper.h"
#import "ARTCard.h"

//#define statements go here

//static NSInteger const declarations go here

@interface ARTImageHelper () {
	//global variables go here
}

@property (nonatomic, strong) NSMutableDictionary *LQImages;
@property (nonatomic, strong) NSMutableDictionary *HQImages;

@property (nonatomic, strong) UIImage *shoppingCartImage;
@property (nonatomic, strong) UIImage *backButtonImage;
@property (nonatomic, strong) UIImage *lockImage;
@property (nonatomic, strong) UIImage *clockImage;
@property (nonatomic, strong) UIImage *stopWatchImage;


@property (nonatomic, strong) UIImage *logoWhiteImage;


@end

@implementation ARTImageHelper

+ (ARTImageHelper *)sharedInstance {
    static dispatch_once_t once;
    static ARTImageHelper * sharedInstance;
    dispatch_once(&once, ^{
        NSDictionary * decks = [[ARTCardHelper sharedInstance] getAllFreshDecks];
                                     
        sharedInstance = [[self alloc] initWithDecks:decks];
    });
    return sharedInstance;
}

- (id)initWithDecks:(NSDictionary *)decks {
    
    if ((self = [super init])) {
        
        CGFloat LQWidth = [LQpixelsforPic floatValue];
        
        self.LQImages = [self setupImagesFromDecks:decks withPointWidth:LQWidth];
        //self.HQImages = [self setupImagesFromDeckDictionaries:deckDictionaries withPointWidth:HQWidth];
        

    }
    return self;
}

- (UIImage *)getLQImageWithFileName:(NSString *)filename  {
    
    if (self.LQImages[filename]) {
        return self.LQImages[filename];

    } else {
        
        CGFloat width = [LQpixelsforPic floatValue];
        return [self setupImageWithFilename:filename andPointWidth:width];
    }

}

- (UIImage *)getHQImageWithFileName:(NSString *)filename  {

    CGFloat width = [HQpixelsforPic floatValue];
    
    return [self setupImageWithFilename:filename andPointWidth:width];
    
    //return self.HQImages[filename];

}

- (UIImage *)getShoppingCartImage {
    
    return [UIImage imageNamed:@"shoppingcart"];
}

- (UIImage *)getThumbsUpImage {
    
    return [UIImage imageNamed:@"thumbsup"];
}

- (UIImage *)getThumbsDownImage {
    
    return [UIImage imageNamed:@"thumbsdown"];
}


- (UIImage *)getBackButtonImage {
    
    if (IS_IPAD) {
        return [UIImage imageNamed:@"barBackLarge.png"];
    }
    else {
        return [UIImage imageNamed:@"barBack.png"] ;
    }

    
}

- (UIImage *)getLockImage {
    
    return [UIImage imageNamed:@"lock"];
}

- (UIImage *)getLockBlackBorderImage {
    return [UIImage imageNamed:@"lockBlackBorder"];
}

- (UIImage *)getStopWatchImage {
    
    return [UIImage imageNamed:@"stopwatch"];
}

- (UIImage *)getLogoWhiteImage {
    
    return [UIImage imageNamed:@"LogoWhiteSmall"];
}


- (NSMutableDictionary *)setupImagesFromDecks:(NSDictionary *)decks withPointWidth:(CGFloat)width {
    NSMutableDictionary *imageDictionary = [NSMutableDictionary new];
    
    for (NSString *key in decks) {
        ARTDeck *deck = decks[key];
        NSDictionary *cards = deck.cards;

        for (NSString *key in cards) {
            
            ARTCard *card = cards[key];
            
            NSString *cardFrontFilename = card.frontFilename;
            UIImage *frontImage = [self setupImageWithFilename:cardFrontFilename andPointWidth:width];
            [imageDictionary setValue:frontImage forKey:cardFrontFilename];
            
            //only loading front images since back LQ images are not used often
            //NSString *cardBackFilename = card.backFilename;
            //UIImage *backImage = [self setupImageWithFilename:cardBackFilename andPointWidth:width];
          //  [imageDictionary setValue:backImage forKey:cardBackFilename];
            
            }
        
    }
    
    return  imageDictionary;
}


/*- (UIImage *)setupImageWithCategory:(NSString *)category andPageNumber:(NSInteger)pageNumber andPointWidth:(CGFloat)pointWidth andOrientation:(NSString *)orientation {
    
    CGFloat width;
    CGFloat height;
    
    if ([orientation isEqualToString:@"portrait"]) {
        height = pointWidth;
        width = pointWidth / hToWRatio;
    } else {
        height = pointWidth / hToWRatio;
        width = pointWidth ;
    }
    
    CGSize imageSize = CGSizeMake(width, height);
    
    NSString *pdfFilename = @"Science";
    
    NSString *filePath = [[NSBundle mainBundle]
                    pathForResource:pdfFilename
                    ofType:@"pdf"];
    
    NSURL *url = [NSURL fileURLWithPath:filePath];
    
    //UIImage *image = [ UIImage imageWithPDFURL:url atSize:imageSize atPage:pageNumber];
    
    return image;
}*/

- (UIImage *)setupImageWithFilename:(NSString *)filename andPointWidth:(CGFloat)width {
    
    NSString *pixelCount;
    if (width == [HQpixelsforPic doubleValue]) {
        pixelCount = HQpixelsforPic;
    } else {
        pixelCount = LQpixelsforPic;
    }
    
    filename = [filename stringByAppendingString:@"dpi"];
    filename = [filename stringByAppendingString:pixelCount];
    
    NSString * filePath;
    
    filePath = [[NSBundle mainBundle]
                               pathForResource:filename
                               ofType:@"jpg"];

    if(!filePath) {
        NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,  NSUserDomainMask, YES);
        NSString *documentsDirectory = [paths objectAtIndex:0];
        
        filename = [filename stringByAppendingString:@".jpg"];
        filePath = [documentsDirectory stringByAppendingPathComponent:filename];
    }
    
    
    UIImage *image = [UIImage imageWithContentsOfFile:filePath];
    
    return image;
}



- (CGRect)frameThatFitsImageFrame:(CGRect)frame withOrientation:(NSString *)orientation {
    
    CGFloat x;
    CGFloat y;
    CGFloat width;
    CGFloat height;
    
    
    if ( [orientation  isEqual: @"portrait"]) {
        if (frame.size.height / frame.size.width >= hToWRatio) {
            width = frame.size.width;
            height = width * hToWRatio;
            
        } else {
            height = frame.size.height;
            width = height / hToWRatio;
            
        }
    } else {
        if (frame.size.height / frame.size.width <= (1/hToWRatio)) {
            height = frame.size.height;
            width = height * hToWRatio;
            
        } else {
            width = frame.size.width;
            height = width / hToWRatio;
        }
    }
    
    x = frame.origin.x + (frame.size.width - width) / 2;
    y = frame.origin.y + (frame.size.height - height) / 2;
    
    CGRect newShape = CGRectMake(x, y, width, height);
    
    return newShape;
}



@end
