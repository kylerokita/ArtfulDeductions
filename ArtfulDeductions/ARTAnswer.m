//
//  ARTAnswer.m
//  ArtfulDeductions
//
//  Created by Kyle Rokita on 7/22/14.
//  Copyright (c) 2014 Artful Deductions LLC. All rights reserved.
//

#import "ARTAnswer.h"

//#define statements go here

//static NSInteger const declarations go here

@interface ARTAnswer () {
	//global variables go here
}

//"private" properties go here

@end

@implementation ARTAnswer

- (id)initWithAnswerArray:(NSArray *)answerArray {
    self = [super init];
    if (self) {
        // Initialization code
        
        NSMutableArray *correctKeywords = [self setupAnswerKeywordsCorrectWithAnswerKeywordsAllNO:answerArray];
        
        self.answerKeywordObjects= answerArray;
        self.answerKeywordsCorrect = correctKeywords;
        
    }
    return self;
}

- (void)resetAnswer {
    NSMutableArray *correctKeywords = [self setupAnswerKeywordsCorrectWithAnswerKeywordsAllNO:self.answerKeywordObjects];

    self.answerKeywordsCorrect = correctKeywords;
}

- (BOOL)checkAnswerInString:(NSString *)userString wholeWord:(BOOL)wholeWordIndicator {
    
    for (NSInteger i = 0; i < self.answerKeywordObjects.count; i++) {
        
        if ([self checkAnswerInString:userString forAnswerKeywordInteger:i wholeWord:wholeWordIndicator]) {
            return YES;
        }
    }
    
    return NO;
}

- (BOOL)checkAnswerInString:(NSString *)userString forAnswerKeywordInteger:(NSInteger)keywordInteger wholeWord:(BOOL)wholeWordIndicator {
    
    NSString *lowerCaseUserString = [userString lowercaseString];
    
    NSString *keyword = [[self getKeywordForAnswerObjectAtIndex:keywordInteger] lowercaseString];
    
    NSInteger abbrevLength;
    if (wholeWordIndicator) {
        abbrevLength = keyword.length;
    } else {
        abbrevLength = MIN(4,keyword.length);
    }
    
    NSString *abbrevKeyword = [keyword substringToIndex:abbrevLength];
    
    BOOL keywordCorrect = [self.answerKeywordsCorrect[keywordInteger] boolValue];
    if (!keywordCorrect) {
        if ([self searchForSubString:abbrevKeyword inString:lowerCaseUserString]) {
            self.answerKeywordsCorrect[keywordInteger] = [NSNumber numberWithBool:YES];
            
            return YES;
        }
    }

    return NO;
}


- (BOOL)checkAllAnswerKeywordsCorrect {
    
    for (NSInteger i = 0; i < self.answerKeywordsCorrect.count; i++) {

        NSNumber *keywordCorrectNumber = self.answerKeywordsCorrect[i];
        BOOL keywordCorrectBool = [keywordCorrectNumber boolValue];
        
        if (!keywordCorrectBool) {
            return NO;
        }
    }
    
    return YES;
}

- (NSString *)getKeywordForAnswerObjectAtIndex:(NSInteger)index {
    NSDictionary *keywordObject = self.answerKeywordObjects[index];
    return [keywordObject objectForKey:@"keyword"];
}

- (NSString *)getHintForAnswerObjectAtIndex:(NSInteger)index withHintCount:(NSInteger)hintCount {
    NSDictionary *keywordObject = self.answerKeywordObjects[index];
    NSArray *hintArray = [keywordObject objectForKey:@"hint"];
    return hintArray[hintCount-1];
}

- (BOOL)searchForSubString:(NSString *)substring inString:(NSString *)userString {
    
    NSRange substringRange = [userString rangeOfString:substring];
    
        if (substringRange.location != NSNotFound) {
            //answer found in string
            if (substringRange.location == 0 || ([userString characterAtIndex:(substringRange.location - 1)] == ' ') ) {
                //check that there is a blank space or nothing in front of answer string
                
                return YES;

            }
            
            return NO;
        } else {
            //answer NOT found in string
            return NO;
        }
}

- (NSMutableArray *)setupAnswerKeywordsCorrectWithAnswerKeywordsAllNO:(NSArray *)array {
    NSMutableArray *mutableArray  = [NSMutableArray new];
    
    for (NSInteger i = 0; i < array.count; i++) {
        NSNumber *boolNumber = [NSNumber numberWithBool:NO];
        [mutableArray addObject:boolNumber];
    }
    
    return mutableArray;
}

@end
