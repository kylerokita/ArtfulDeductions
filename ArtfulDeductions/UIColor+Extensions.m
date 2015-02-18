//
//  UIColor+Extensions.m
//  Artful Deductions
//
//  Created by Kyle Rokita on 9/5/14.
//  Copyright (c) 2014 Artful Deductions LLC. All rights reserved.
//

#import "UIColor+Extensions.h"
#import "UIImage+Customization.h"
#import "ARTImageHelper.h"
#import "ARTUserInfo.h"

@implementation UIColor (Extensions)

+ (UIColor *)greenishColor {
    return [UIColor colorWithRed:.208*1.0 green:.459*1.0 blue:.184*1.0 alpha:1.0];
}

+ (UIColor *)darkQuestionColor {
    return [UIColor colorWithRed:.3/4.5 green:.484/4.5 blue:.75/4.5 alpha:1.0];
    
}

+ (UIColor *)darkBlueColor {
    CGFloat darkModeAdj;
    if ([[[ARTUserInfo sharedInstance] getVisualTheme] isEqual:@"white"]) {
        darkModeAdj = 0.85;
    } else {
        darkModeAdj = 0.72;
    }
    return [UIColor colorWithRed:.288*1.0*darkModeAdj green:.484*1.0*darkModeAdj blue:.75*1.0*darkModeAdj alpha:1.0];
}

+ (UIColor *)detailViewBlueColor {
    return [UIColor colorWithRed:.288/5.5 green:.484/5.5 blue:.75/5.5 alpha:1.0];
}

+ (UIColor *)logoBlueColor {
    return [UIColor colorWithRed:.288/2.0 green:.484/2.0 blue:.75/1.5 alpha:1.0];
}

+ (UIColor *)darkerGrayColor {
   // return [UIColor colorWithWhite:0.15 alpha:1.0];
    
CGFloat darkModeAdj = 1./2.2;
    
    return [UIColor colorWithRed:.288*1.0*darkModeAdj green:.484*1.0*darkModeAdj blue:.75*1.0*darkModeAdj alpha:1.0];
}

+ (UIColor *)darkerestGrayColor {
    // return [UIColor colorWithWhite:0.15 alpha:1.0];
    
    CGFloat darkModeAdj = 1./4.;
    
    return [UIColor colorWithRed:.288*1.0*darkModeAdj green:.484*1.0*darkModeAdj blue:.75*1.0*darkModeAdj alpha:1.0];
}

+ (UIColor *)darkestGrayColor {
   // return [UIColor colorWithWhite:0.08f alpha:1.0];
    
    CGFloat darkModeAdj = 1./8.0;
    
    return [UIColor colorWithRed:.288*1.0*darkModeAdj green:.484*1.0*darkModeAdj blue:.75*1.0*darkModeAdj alpha:1.0];
}

+ (UIColor *)offWhiteColor {
    return [UIColor colorWithRed:0.97 green:0.97 blue:0.99 alpha:1.0];
}


+ (UIColor *)emergencyRedColor {
    if ([[[ARTUserInfo sharedInstance] getVisualTheme] isEqual:@"white"]) {
        return [UIColor colorWithRed:.7 green:.0 blue:.0 alpha:1.0];
    } else {
        return [UIColor colorWithRed:.6 green:.0 blue:.0 alpha:1.0];
    }
}

+ (UIColor *)tanColor {
    return [UIColor colorWithRed:0.867 green:0.788 blue:0.678 alpha:1.0];
}

+ (UIColor *)lightBackgroundColor {
    return [UIColor colorWithWhite:0.95 alpha:1.0];

}

+ (UIColor *)darkBackgroundColor {
    return [UIColor colorWithWhite:0.07 alpha:1.0];//colorWithPatternImage:[[ARTImageHelper sharedInstance] getBackgroundImageDark] ];
      //            colorWithPatternImage:[[[ARTImageHelper sharedInstance] getBackgroundImageDark] colorizeWithColor:[[UIColor blackColor] colorWithAlphaComponent:0.75]]];
}

+ (UIColor *)blueButtonColor {
    
    CGFloat darkModeAdj;
    if ([[[ARTUserInfo sharedInstance] getVisualTheme] isEqual:@"white"]) {
        darkModeAdj = 1.02;
    } else {
        darkModeAdj = 0.9;
    }
    return [UIColor colorWithRed:.288*1.0*darkModeAdj green:.484*1.0*darkModeAdj blue:.75*1.0*darkModeAdj alpha:1.0];
}


+ (UIColor *)lightBlueColor {
    return [UIColor colorWithRed:0.9 green:.92 blue:0.95 alpha:1.0];
}

+ (UIColor *)blueNavBarColor {
    return [UIColor colorWithRed:0.0/255.0 green:122.0/255.0 blue:255.0/255.0 alpha:1.0];
}

+ (UIColor *)categoryDailyLifeColor {
    
   // return [UIColor colorWithRed:.384 green:.482 blue:.404 alpha:1.0];

    return [UIColor colorWithRed:93./255. green:122./255. blue:93./255. alpha:1.0];
}

+ (UIColor *)categoryGovernmentColor {
    
   //return [UIColor colorWithRed:.431 green:.490 blue:.486 alpha:1.0];

    return [UIColor colorWithRed:116./255. green:134./255. blue:138./255. alpha:1.0];
}

+ (UIColor *)categoryLanguageColor {
    
  //  return [UIColor colorWithRed:.537 green:.490 blue:.408 alpha:1.0];
    
    return [UIColor colorWithRed:147./255. green:125./255. blue:108./255. alpha:1.0];


}

+ (UIColor *)categoryScienceColor {
    
    //return [UIColor colorWithRed:.694 green:.663 blue:.459 alpha:1.0];

    
    return [UIColor colorWithRed:189./255. green:178./255. blue:121./255. alpha:1.0];

}

+ (UIColor *)categoryMilitaryColor {
    
   // return [UIColor colorWithRed:.549 green:.545 blue:.400 alpha:1.0];

    return [UIColor colorWithRed:149./255. green:149./255. blue:108./255. alpha:1.0];
}

+ (UIColor *)categorySamplerColor {
    
//    return [UIColor colorWithRed:.337 green:.475 blue:.592 alpha:1.0];

    
    return [UIColor colorWithRed:91./255. green:122./255. blue:164./255. alpha:1.0];

}

+ (UIColor *)categoryFinalQuestionColor {
    return [UIColor colorWithRed:.255 green:.435 blue:.561 alpha:1.0];
}

@end
