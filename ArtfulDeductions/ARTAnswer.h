//
//  ARTAnswer.h
//  ArtfulDeductions
//
//  Created by Kyle Rokita on 7/22/14.
//  Copyright (c) 2014 Artful Deductions LLC. All rights reserved.
//

#import <Foundation/Foundation.h>

//@class goes here

@interface ARTAnswer : NSObject

@property (nonatomic, strong) NSArray *answerKeywordObjects;
@property (nonatomic, strong) NSMutableArray *answerKeywordsCorrect;

- (id)initWithAnswerArray:(NSArray *)answerArray;

- (BOOL)checkAnswerInString:(NSString *)userString wholeWord:(BOOL)wholeWordIndicator;
- (BOOL)checkAnswerInString:(NSString *)userString forAnswerKeywordInteger:(NSInteger)keywordInteger wholeWord:(BOOL)wholeWordIndicator;
- (BOOL)checkAllAnswerKeywordsCorrect;

- (NSString *)getKeywordForAnswerObjectAtIndex:(NSInteger)index;
- (NSString *)getHintForAnswerObjectAtIndex:(NSInteger)index withHintCount:(NSInteger)hintCount ;

- (void)resetAnswer;

@end
