//
//  HDBaseLayout.m
//  HDCollectionView
//
//  Created by HaoDong chen on 2019/4/4.
//  Copyright © 2019 CHD. All rights reserved.
//

#import "HDBaseLayout.h"
#import "NSObject+HDCopy.h"
#import "HDModelProtocol.h"
#import "HDBaseLayout+Cache.h"

@interface HDBaseLayoutChainMaker ()
@property (nonatomic, strong) NSMutableDictionary *allValues;
@end

@implementation HDBaseLayoutChainMaker
- (NSMutableDictionary *)allValues
{
    if (!_allValues) {
        _allValues = @{}.mutableCopy;
    }
    return _allValues;
}
- (Class)hd_generateLayoutClass
{
    return [HDBaseLayout class];
}
- (__kindof HDBaseLayout*)hd_generateObj
{
    HDBaseLayout* layout = [[self hd_generateLayoutClass] new];
    [self.allValues enumerateKeysAndObjectsUsingBlock:^(id  _Nonnull key, id  _Nonnull obj, BOOL * _Nonnull stop) {
        [layout setValue:obj forKey:key];
    }];
    return layout;
}
- (HDBaseLayoutChainMaker * _Nonnull (^)(CGSize))hd_headerSize
{
    return ^(CGSize headerSize){
        self.allValues[@"headerSize"] = [NSValue valueWithCGSize:headerSize];
        return self;
    };
}
- (HDBaseLayoutChainMaker * _Nonnull (^)(CGSize))hd_footerSize
{
    return ^(CGSize footerSize){
        self.allValues[@"footerSize"] = [NSValue valueWithCGSize:footerSize];
        return self;
    };
}
- (HDBaseLayoutChainMaker * _Nonnull (^)(CGSize))hd_cellSize
{
    return ^(CGSize cellSize){
        self.allValues[@"cellSize"] = [NSValue valueWithCGSize:cellSize];
        return self;
    };
}
- (HDBaseLayoutChainMaker * _Nonnull (^)(UIEdgeInsets))hd_secInset
{
    return ^(UIEdgeInsets secInset){
        self.allValues[@"secInset"] = [NSValue valueWithUIEdgeInsets:secInset];
        return self;
    };
}
- (HDBaseLayoutChainMaker * _Nonnull (^)(CGFloat))hd_verticalGap
{
    return ^(CGFloat verticalGap){
        self.allValues[@"verticalGap"] = @(verticalGap);
        return self;
    };
}
- (HDBaseLayoutChainMaker * _Nonnull (^)(CGFloat))hd_horizontalGap
{
    return ^(CGFloat horizontalGap){
        self.allValues[@"horizontalGap"] = @(horizontalGap);
        return self;
    };
}

@end

@interface HDBaseLayout()
@property (nonatomic, assign) UICollectionViewScrollDirection scrollDirection;
@end

@implementation HDBaseLayout
- (instancetype)init
{
    self = [super init];
    if (self) {
        self.secInset = UIEdgeInsetsZero;
        self.verticalGap = 0;
        self.horizontalGap = 0;
        self.headerSize = CGSizeZero;
        self.footerSize = CGSizeZero;
        self.cellSize = CGSizeZero;
        self.scrollDirection = UICollectionViewScrollDirectionVertical;
    }
    return self;
}
- (CGSize)headerSize
{
    if (self.headerSizeCb) {
        _headerSize = self.headerSizeCb();
    }
    return _headerSize;
}
- (CGSize)footerSize
{
    if (self.footerSizeCb) {
        _footerSize = self.footerSizeCb();
    }
    return _footerSize;
}
- (id)copyWithZone:(NSZone *)zone
{
    return  [self hd_copyWithZone:zone];
}
- (NSMutableArray *)layoutWithLayout:(UICollectionViewLayout *)layout sectionModel:(id<HDSectionModelProtocol>)secModel currentStart:(CGPoint *)cStart
{
    return @[].mutableCopy;
}


#pragma mark 查找当前显示att

//基类默认提供的查找为二分查找，需要保证 self.cacheAtts 基本有序(frame.orign.y/x在数组中递增)
- (NSMutableArray<UICollectionViewLayoutAttributes *> *)layoutAttributesForElementsInRect:(CGRect)rect scrollDirection:(UICollectionViewScrollDirection)scrollDirection
{
    NSMutableArray *result = @[].mutableCopy;
    NSInteger HDContinueFindCount = 40;
    NSArray *cachedAttributes = self.cacheAtts;
    self.scrollDirection = scrollDirection;
    
    NSInteger firstFind = [self binarySearch:0 end:cachedAttributes.count-1 rect:rect inAtts:cachedAttributes];
    if (firstFind == -1) {
        //-1代表没有找到，可能已经超出可视范围
        return result;
    }
    UICollectionViewLayoutAttributes *firstAtt = cachedAttributes[firstFind];
    
    //添加第一个找到的att
    [result addObject:firstAtt];
    
    //向前查找
    for (NSInteger i=firstFind-1; i>=0; i--) {
        UICollectionViewLayoutAttributes *att = cachedAttributes[i];
        UICollectionViewLayoutAttributes *nextAtt = cachedAttributes[i+1];
        if (![self _isRectIntersectsRect:att.frame rect2:rect lastOrNextAttRect:nextAtt.frame]) {
            //找到临界点后再向前找几个
            NSInteger continuFindCount = HDContinueFindCount;
            for (NSInteger j=i-1; j>=0; j--) {
                UICollectionViewLayoutAttributes *att2 = cachedAttributes[j];
                UICollectionViewLayoutAttributes *nextAtt2 = cachedAttributes[j+1];
                if ([self _isRectIntersectsRect:att2.frame rect2:rect lastOrNextAttRect:nextAtt2.frame]) {
                    [result addObject:att2];
                }
                continuFindCount--;
                if (continuFindCount<=0) {
                    break;
                }
            }
            break;
        }else{
            [result addObject:att];
        }

    }
    
    //向后查找
    for (NSInteger i=firstFind+1; i<cachedAttributes.count; i++) {
        UICollectionViewLayoutAttributes *att = cachedAttributes[i];
        UICollectionViewLayoutAttributes *lastAtt = cachedAttributes[i-1];
        if (![self _isRectIntersectsRect:att.frame rect2:rect lastOrNextAttRect:lastAtt.frame]) {
            NSInteger continuFindCount = HDContinueFindCount;
            for (NSInteger j=i+1; j<cachedAttributes.count; j++) {
                UICollectionViewLayoutAttributes *att2 = cachedAttributes[j];
                UICollectionViewLayoutAttributes *lastAtt2 = cachedAttributes[j-1];
                if ([self _isRectIntersectsRect:att2.frame rect2:rect lastOrNextAttRect:lastAtt2.frame]) {
                    [result addObject:att2];
                }
                continuFindCount--;
                if (continuFindCount<=0) {
                    break;
                }
            }
            break;
        }else{
            [result addObject:att];
        }
    }
    
    return result;
}

//找到任意一个出现在rect内的位置
- (NSInteger)binarySearch:(NSInteger)start end:(NSInteger)end rect:(CGRect)rect inAtts:(NSArray*)atts
{
    if (end<start) {
        return -1;
    }
    NSInteger first = -1;
    while (start<=end) {
        NSInteger mid = (start + end)/2;
        if (mid<atts.count) {
            UICollectionViewLayoutAttributes *att = atts[mid];
            if (self.scrollDirection == UICollectionViewScrollDirectionVertical) {
                if (CGRectGetMinY(att.frame)>CGRectGetMaxY(rect)) {
                    if (end == mid) {
                        end -= 1;
                    }else{
                        end = mid;
                    }
                }else if (CGRectGetMaxY(att.frame)<CGRectGetMinY(rect)){
                    if (start == mid) {
                        start += 1;
                    }else{
                        start = mid;
                    }
                }else{
                    first = mid;
                    break;
                }
            }else{
                if (CGRectGetMinX(att.frame)>CGRectGetMaxX(rect)) {
                    if (end == mid) {
                        end -= 1;
                    }else{
                        end = mid;
                    }
                }else if (CGRectGetMaxX(att.frame)<CGRectGetMinX(rect)){
                    if (start == mid) {
                        start += 1;
                    }else{
                        start = mid;
                    }
                }else{
                    first = mid;
                    break;
                }
            }
        }else{
            break;
        }
    }
    
    return first;
}

- (BOOL)isRectIntersectsRect:(CGRect)attRect rect2:(CGRect)visualRect
{
    return [self _isRectIntersectsRect:attRect rect2:visualRect lastOrNextAttRect:CGRectNull];
}

- (BOOL)_isRectIntersectsRect:(CGRect)attRect rect2:(CGRect)visualRect lastOrNextAttRect:(CGRect)lnRect
{
    BOOL orgResutlt = CGRectIntersectsRect(attRect,visualRect);
    
    BOOL criticalPoint = NO;
    NSInteger pointH = 1;
    //临界点，当CGRectGetMinY(rect1) == CGRectGetMaxY(rect2) 也认为是相交的。因为二分查找时，相等也认为是相交
    if ([self scrollDirection] == UICollectionViewScrollDirectionVertical) {
        criticalPoint = (ABS(CGRectGetMinY(attRect) - CGRectGetMaxY(visualRect))<pointH) || (ABS(CGRectGetMinY(visualRect) - CGRectGetMaxY(attRect))<pointH);
    }else{
        criticalPoint = (ABS(CGRectGetMinX(attRect) - CGRectGetMaxX(visualRect))<pointH) || (ABS(CGRectGetMinX(visualRect) - CGRectGetMaxX(attRect))<pointH);
    }
    
    BOOL isLastNextOneLine = NO;
    if (!CGRectIsNull(lnRect)) {
        //当传入其临近att的frame时，同一行/列 的则认为在查找范围内
        BOOL isNextInVisualRect = [self isRectIntersectsRect:lnRect rect2:visualRect];
        BOOL isSameLine = NO;
        if ([self scrollDirection] == UICollectionViewScrollDirectionVertical) {
            isSameLine = CGRectUnion(attRect, lnRect).size.height<(attRect.size.height+lnRect.size.height);
        }else{
            isSameLine = CGRectUnion(attRect, lnRect).size.width<(attRect.size.width+lnRect.size.width);
        }
        isLastNextOneLine = isSameLine && isNextInVisualRect;
    }
    
    return orgResutlt || criticalPoint || isLastNextOneLine;
}
@end
