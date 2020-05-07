//
//  HDCollectionViewLayout.m
//  HDCollectionView
//
//  Created by HaoDong chen on 2019/3/13.
//  Copyright © 2019 CHD. All rights reserved.
//

#import "HDCollectionViewLayout.h"
#import "HDSectionModel.h"
#import "HDHeaderStopHelper.h"
#import "HDWaterFlowLayout.h"
#import "HDBaseLayout+Cache.h"
#import "HDDefines.h"

#define HDContinueFindCount 200
static NSString *const HDNormalLayoutAttsKey = @"HDNormalLayoutAttsKey";
static NSString *const HDWaterFlowSectionKey = @"HDWaterFlowSectionKey";
static NSString *const HDVisiableSecitonsKey = @"HDVisiableSecitonsKey";

@implementation HDCollectionViewLayout
{
    CGFloat contentX;
    CGFloat contentY;
    BOOL isNeedTopStop;
    NSMutableArray *cachedAttributes;//所有属性缓存(不包含装饰view)
    NSMutableDictionary *cacheDicAtts;//所有属性字典缓存, 与cachedAttributes中的obj是同一个obj
    CGPoint *currentStart;
    CGPoint realCurrentStart;
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.scrollDirection = UICollectionViewScrollDirectionVertical;
    }
    [self resetData];
    return self;
}
- (void)resetData
{
    cachedAttributes = @[].mutableCopy;
    cacheDicAtts = @{}.mutableCopy;
    realCurrentStart = CGPointZero;
    currentStart = &realCurrentStart;

}
- (NSMutableArray<id<HDSectionModelProtocol>> *)allDataArr
{
    NSMutableArray *arr = [self.collectionView.superview valueForKey:@"allDataArr"];
    return arr;
}
- (void)updateCurrentXY:(CGPoint)newStart
{
    currentStart->x = newStart.x;
    currentStart->y = newStart.y;
}
- (void)prepareLayout
{
    isNeedTopStop = [[self.collectionView.superview valueForKey:@"isNeedTopStop"] boolValue];
    [super prepareLayout];
    [self invalidateLayout];
    
    if (cachedAttributes.count == 0) {
        [self reloadAll];
    }
}
- (void)setAllNeedUpdate
{
    [self resetData];
}
- (void)reloadAll
{
    [self resetData];
    [self reloadSetionAfter:0];
}
- (void)reloadSetionAfter:(NSInteger)sectionIndex
{
    //前一段布局改变后，会影响其后的所有布局，该段后面的都要刷新
    if (sectionIndex == 0) {
        [cachedAttributes removeAllObjects];
    }else{
        NSInteger firstAttIndex = [self findFirstSetionAttIndex:sectionIndex];
        cachedAttributes = [cachedAttributes subarrayWithRange:NSMakeRange(0, firstAttIndex)].mutableCopy;
        
        if (firstAttIndex == 0 || cachedAttributes.count == 0) {
            sectionIndex = 0;
        }
    }
    //刷新重新添加
    for (NSInteger i=sectionIndex; i<[self allDataArr].count; i++) {
        id<HDSectionModelProtocol> sec = [self allDataArr][i];
        
        if (sec.section == 0) {
            currentStart->x = 0;
            currentStart->y = 0;
        }

        [self addOneSection:sec isFirst:i == sectionIndex];
    }
    
    //刷新完毕后更正 currentStart (删除最后一个secModel的时候必须更新)
    id<HDSectionModelProtocol> lastSec = [[self allDataArr] lastObject];
    currentStart->x = lastSec.layout.cacheEnd.x;
    currentStart->y = lastSec.layout.cacheEnd.y;
    
    
}
//找到某段内第一个att在cachedAttributes数组中的位置
- (NSInteger)findFirstSetionAttIndex:(NSInteger)section
{
    NSInteger start = 0;
    NSInteger end = cachedAttributes.count-1;
    NSInteger result = cachedAttributes.count;//未找到（返回需要删除的起始位置，未找到返回末尾位置）

    BOOL isStop = NO;
    while (start<=end) {
        if (isStop) {
            break;
        }
        NSInteger mid = (start+end)/2;
        UICollectionViewLayoutAttributes *att = cachedAttributes[mid];
        if (att.indexPath.section == section) {
            result = mid;
            for (NSInteger j=mid-1; j>=0; j--) {
                UICollectionViewLayoutAttributes *frontAtt = cachedAttributes[j];
                if (frontAtt.indexPath.section == section) {
                    result = j;
                    if (result <= 0) {
                        isStop = YES;
                        break;
                    }
                }else{
                    isStop = YES;
                    break;
                }
            }
            break;
        }else if (att.indexPath.section>section){
            if (end == mid) {
                end -= 1;
            }else{
                end = mid;
            }
        }else if (att.indexPath.section<section){
            if (start == mid) {
                start += 1;
            }else{
                start = mid;
            }
        }
    
    }
    return result;
}

- (void)addOneSection:(id<HDSectionModelProtocol>)section isFirst:(BOOL)isFirst
{
    NSArray *Atts = [section.layout getAttsWithLayout:self sectionModel:section currentStart:currentStart isFirstSec:isFirst];
    [Atts enumerateObjectsUsingBlock:^(UICollectionViewLayoutAttributes* obj, NSUInteger idx, BOOL * _Nonnull stop) {
        [self->cachedAttributes addObject:obj];
        
        NSString *cacheKey = [self getCacheKeyByKind:obj.representedElementKind indexPath:obj.indexPath];
        if (cacheKey) {
            [self->cacheDicAtts setValue:obj forKey:cacheKey];
        }
    }];
    
    HDBaseLayout *layout = section.layout;
    if ([layout respondsToSelector:@selector(decorationAtt)]) {
        UICollectionViewLayoutAttributes *decorationAtt = layout.decorationAtt;
        NSString *cacheKey = [self getCacheKeyByKind:decorationAtt.representedElementKind indexPath:decorationAtt.indexPath];
        if (decorationAtt) {
            [cacheDicAtts setValue:decorationAtt forKey:cacheKey];
        }
    }
}

- (NSArray<UICollectionViewLayoutAttributes *> *)layoutAttributesForElementsInRect:(CGRect)rect
{
    if (@available(iOS 10.0, *)) {
        self.collectionView.prefetchingEnabled = false;
    } else {
        // Fallback on earlier versions
    }
    if (rect.size.width <= 1) {
        rect = CGRectMake(rect.origin.x, rect.origin.y, self.collectionView.frame.size.width, rect.size.height);
    }
    if (rect.size.height <= 1) {
        rect = CGRectMake(rect.origin.x, rect.origin.y, rect.size.width, self.collectionView.frame.size.height);
    }

    if (cachedAttributes.count<=0) {
        return @[];
    }
    
    //基类layout(指HDCollectionViewLayout)只负责查找当前有哪些段(section),在当前rect显示。
    //具体每段内需要显示哪些LayoutAttributes由对应段的layout(HDBaseLayout或其子类)自己负责
    NSArray *secModelArr = [self allDataArr];
    NSMutableArray *finalAtts = @[].mutableCopy;
    NSArray *allVisibleSections = [self _findAllVisibleSectionsInRect:rect secModelArr:secModelArr];
    for (NSInteger i=0; i<allVisibleSections.count; i++) {
        NSInteger section = [allVisibleSections[i] integerValue];
        if (section<secModelArr.count) {
            id<HDSectionModelProtocol>secModel = secModelArr[section];
            if ([secModel.layout respondsToSelector:@selector(layoutAttributesForElementsInRect: scrollDirection:)]) {
                [finalAtts addObjectsFromArray:[secModel.layout layoutAttributesForElementsInRect:rect scrollDirection:self.scrollDirection]];
            }
        }
    }
    
    //对需要悬停的header进行拷贝、修改、替换
    if (isNeedTopStop) {
        finalAtts = [HDHeaderStopHelper getAdjustAttArrWith:finalAtts allSectionData:[self allDataArr] layout:self scollDirection:self.scrollDirection];
    }
    
    return finalAtts;
}


- (UICollectionViewLayoutAttributes *)layoutAttributesForItemAtIndexPath:(NSIndexPath *)indexPath
{
    return self->cacheDicAtts[[self getCacheKeyByKind:nil indexPath:indexPath]];
}
- (UICollectionViewLayoutAttributes *)layoutAttributesForSupplementaryViewOfKind:(NSString *)elementKind atIndexPath:(NSIndexPath *)indexPath
{
    return self->cacheDicAtts[[self getCacheKeyByKind:elementKind indexPath:indexPath]];
}
- (CGSize)collectionViewContentSize
{
    return CGSizeMake(MAX(currentStart->x, self.collectionView.frame.size.width), MAX(currentStart->y, self.collectionView.frame.size.height));
}

- (BOOL)shouldInvalidateLayoutForBoundsChange:(CGRect)newBounds
{
    BOOL result = !CGSizeEqualToSize(newBounds.size, self.collectionView.bounds.size);
    if (isNeedTopStop) {
        result = YES;//返回YES后,滑动就会调用prepareLayout
    }
    return result;
}
- (NSString*)getCacheKeyByKind:(NSString*)kind indexPath:(NSIndexPath*)indexPath
{
    NSString *cacheKey;
    if ([kind isEqualToString:UICollectionElementKindSectionHeader]) {
        cacheKey = [NSString stringWithFormat:@"HDHeader_%zd",indexPath.section];
    }else if ([kind isEqualToString:UICollectionElementKindSectionFooter]){
        cacheKey = [NSString stringWithFormat:@"HDFooter_%zd",indexPath.section];
    }else if ([kind isEqualToString:HDDecorationViewKind]){
        cacheKey = [NSString stringWithFormat:@"HDDecoration%zd",indexPath.section];
    }else{
        cacheKey = [NSString stringWithFormat:@"HDCell_%zd_%zd",indexPath.section,indexPath.item];
    }
    return cacheKey;
}

- (NSArray*)_findAllVisibleSectionsInRect:(CGRect)rect secModelArr:(NSArray*)secModelArr
{
    NSMutableArray *result = @[].mutableCopy;
    NSInteger firstFindSection = [self _binarySearchFirstVisibleSection:0 end:secModelArr.count-1 secModelArr:secModelArr inRect:rect];
    if (firstFindSection != -1) {
        [result addObject:@(firstFindSection)];
        
        //向前边的section查找
        for (NSInteger i=firstFindSection-1; i>=0; i--) {
            id<HDSectionModelProtocol>secModel = secModelArr[i];
            if (CGRectIntersectsRect(secModel.secProperRect.CGRectValue,rect)) {
                [result insertObject:@(i) atIndex:0];
            }
        }
        
        //向后边的section查找
        for (NSInteger i=firstFindSection+1; i<secModelArr.count; i++) {
            id<HDSectionModelProtocol>secModel = secModelArr[i];
            if (CGRectIntersectsRect(secModel.secProperRect.CGRectValue,rect)) {
                [result addObject:@(i)];
            }
        }
    }
    return result;
}
- (NSInteger)_binarySearchFirstVisibleSection:(NSInteger)start end:(NSInteger)end secModelArr:(NSArray*)secModelArr inRect:(CGRect)rect
{
    if (end<start) {
        return -1;
    }
    NSInteger firstFind = -1;
    while (start<=end) {
        NSInteger mid = (start + end)/2;
        if (mid<secModelArr.count) {
            id<HDSectionModelProtocol>secModel = secModelArr[mid];
            CGRect currentSectionRect = secModel.secProperRect.CGRectValue;
            if (self.scrollDirection == UICollectionViewScrollDirectionVertical) {
                if (CGRectGetMinY(currentSectionRect)>CGRectGetMaxY(rect)) {
                    if (end == mid) {
                        end -= 1;
                    }else{
                        end = mid;
                    }
                }else if (CGRectGetMaxY(currentSectionRect)<CGRectGetMinY(rect)){
                    if (start == mid) {
                        start += 1;
                    }else{
                        start = mid;
                    }
                }else{
                    firstFind = mid;
                    break;
                }
            }else{
                if (CGRectGetMinX(currentSectionRect)>CGRectGetMaxX(rect)) {
                    if (end == mid) {
                        end -= 1;
                    }else{
                        end = mid;
                    }
                }else if (CGRectGetMaxX(currentSectionRect)<CGRectGetMinX(rect)){
                    if (start == mid) {
                        start += 1;
                    }else{
                        start = mid;
                    }
                }else{
                    firstFind = mid;
                    break;
                }
            }
        }else{
            break;
        }
    }
    
    return firstFind;
}
@end
