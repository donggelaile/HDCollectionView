//
//  HDCollectionViewFlowLayout.m
//
//  Created by HaoDong chen on 2019/1/2.
//  Copyright © 2018年 chd. All rights reserved.

#import "HDCollectionViewFlowLayout.h"
#import "HDSectionModel.h"
#import "HDCellModel.h"
#import "HDHeaderStopHelper.h"
@interface HDCollectionViewFlowLayout()
{
    BOOL isVertical;//是否是纵向滑动
    BOOL isNeedTopStop;
}
@property (nonatomic, strong) NSMutableArray *IndicatorArr;
@end

@implementation HDCollectionViewFlowLayout

-(NSMutableArray *)IndicatorArr {
    if (!_IndicatorArr) {
        _IndicatorArr = @[].mutableCopy;
    }
    return _IndicatorArr;
}

- (NSMutableArray *)allDataArr {
    return [self.collectionView.superview valueForKey:@"allDataArr"];
}

- (NSArray *)layoutAttributesForElementsInRect:(CGRect)rect {
    isNeedTopStop = [[self.collectionView.superview valueForKey:@"isNeedTopStop"] boolValue];
    isVertical =  (self.scrollDirection == UICollectionViewScrollDirectionVertical);
    if (@available(iOS 10.0, *)) {
        self.collectionView.prefetchingEnabled = false;
    } else {
        // Fallback on earlier versions
    }
    
    NSMutableArray<UICollectionViewLayoutAttributes *> *AllRectAtts = [super layoutAttributesForElementsInRect:rect].mutableCopy;
    if (isNeedTopStop) {
        AllRectAtts = [HDHeaderStopHelper getAdjustAttArrWith:AllRectAtts allSectionData:[self allDataArr] layout:self scollDirection:self.scrollDirection];
    }
    [self updateInIndicator];
    return AllRectAtts;
    
}

- (void)updateInIndicator {
    //解决Indicator在heder下面的问题
    if (!self.collectionView.showsVerticalScrollIndicator && !self.collectionView.showsHorizontalScrollIndicator) {
        return;
    }
    if (self.IndicatorArr.count) {
        [self.IndicatorArr enumerateObjectsUsingBlock:^(UIView* obj, NSUInteger idx, BOOL * _Nonnull stop) {
            obj.layer.zPosition = 100000;
        }];
        return;
    }
    [self.collectionView.subviews enumerateObjectsUsingBlock:^(__kindof UIView * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if ([obj isKindOfClass:[UIImageView class]] &&
            (floor(obj.frame.size.height) == 2|| floor((obj.frame.size.width)) == 2)) {
            [self.IndicatorArr addObject:obj];
        }
    }];
    [self.IndicatorArr enumerateObjectsUsingBlock:^(UIView* obj, NSUInteger idx, BOOL * _Nonnull stop) {
        obj.layer.zPosition = 100000;
    }];
    
}

- (BOOL)shouldInvalidateLayoutForBoundsChange:(CGRect)newBounds {
    BOOL result = !CGSizeEqualToSize(newBounds.size, self.collectionView.bounds.size);
    if (isNeedTopStop) {
        result = YES;
    }
    return result;
}

@end
