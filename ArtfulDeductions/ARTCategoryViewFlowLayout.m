//
//  ARTCategoryViewFlowLayout.m
//  Artful Deductions
//
//  Created by Kyle Rokita on 10/10/14.
//  Copyright (c) 2014 Artful Deductions LLC. All rights reserved.
//

#import "ARTCategoryViewFlowLayout.h"
#import "ARTCollectionSectionDecorationView.h"
#import "ARTCategoryCollectionReusableViewHeader.h"
#import "ARTConstants.h"

@implementation ARTCategoryViewFlowLayout


- (UICollectionViewLayoutAttributes*)layoutAttributesForDecorationViewOfKind:(NSString*)decorationViewKind atIndexPath:(NSIndexPath*)indexPath
{
    UICollectionViewLayoutAttributes *layoutAttributes = [UICollectionViewLayoutAttributes layoutAttributesForDecorationViewOfKind:decorationViewKind withIndexPath:indexPath];
    
        layoutAttributes.frame = [self rectForSectionAtIndexPath:indexPath];
        
        layoutAttributes.zIndex = -1;
    
    return layoutAttributes;
}

- (NSArray*)layoutAttributesForElementsInRect:(CGRect)rect
{
    NSArray *array = [super layoutAttributesForElementsInRect:rect];
    
    //[self invalidateLayout];
    
    for(UICollectionViewLayoutAttributes *attributes in array) {
        attributes.zIndex = 1;
    }
    
    NSMutableArray *newArray = [array mutableCopy];
    
   /* for(NSInteger i = 0; i < [self.collectionView numberOfSections]; i++) {

        [newArray addObject:[self layoutAttributesForDecorationViewOfKind:@"Section" atIndexPath:[NSIndexPath indexPathForItem:0 inSection:i]]];
    }*/

    for (NSInteger i = 0; i < [self.collectionView numberOfSections]; i++) {
        [newArray addObject:[self layoutAttributesForDecorationViewOfKind:@"Section" atIndexPath:[NSIndexPath indexPathForItem:0 inSection:i]]];
    }

    
    /*for(NSInteger i = 0; i < [self.collectionView numberOfItemsInSection:0]; i++) {
        NSIndexPath *indexPath = [NSIndexPath indexPathForItem:i inSection:0];
        UICollectionViewLayoutAttributes *layoutAttributes = [self layoutAttributesForItemAtIndexPath:indexPath];
        [newArray addObject:layoutAttributes];
    }*/
    
    array = [NSArray arrayWithArray:newArray];
    
    return array;
}

-(CGRect) rectForSectionAtIndexPath:(NSIndexPath *) indexPath
{

    //ARTCategoryCollectionReusableViewHeader *headerView =  (ARTCategoryCollectionReusableViewHeader *)[self.collectionView.dataSource collectionView:self.collectionView viewForSupplementaryElementOfKind:UICollectionElementKindSectionHeader atIndexPath:indexPath];
    
    UICollectionViewLayoutAttributes *first = [self.collectionView layoutAttributesForItemAtIndexPath:[NSIndexPath indexPathForItem:0 inSection:indexPath.section]];
    CGFloat firstY = first.frame.origin.y;
    
    //NSInteger sectionCount = [self.collectionView numberOfSections];
    NSInteger count = [self.collectionView.dataSource collectionView:self.collectionView numberOfItemsInSection:indexPath.section];
    
    UICollectionViewLayoutAttributes *last = [self.collectionView layoutAttributesForItemAtIndexPath:[NSIndexPath indexPathForItem:(count-1) inSection:indexPath.section]];
    CGFloat endY = last.frame.origin.y + last.frame.size.height;
    
    CGFloat topSpacing = 0.0;
    
    if (IS_OldIphone) {
        topSpacing =  - categoryHeaderHeightOldIphone - 10;
    } else if (IS_IPHONE_5) {
        topSpacing =  - categoryHeaderHeightIphone5 - 10;
    } else if (IS_IPAD) {
        topSpacing =  - categoryHeaderHeightIpad - 10;
    } else if (IS_IPHONE_6) {
        topSpacing =  - categoryHeaderHeightIphone6 - 10;
    } else if (IS_IPHONE_6Plus) {
        topSpacing =  - categoryHeaderHeightIphone6 - 10;
    }
    
    CGFloat bottomSpacing = 10.0;
    
    return CGRectMake(0, firstY + topSpacing, self.collectionViewContentSize.width, (endY + bottomSpacing) - (firstY + topSpacing));
    
}



- (BOOL) shouldInvalidateLayoutForBoundsChange:(CGRect)newBound {
    
    return YES;
    
}



@end
