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

#define HDContinueFindCount 20
static NSString *const HDNormalLayoutAttsKey = @"HDNormalLayoutAttsKey";
static NSString *const HDWaterFlowSectionKey = @"HDWaterFlowSectionKey";
static NSString *const HDVisiableSecitonsKey = @"HDVisiableSecitonsKey";

typedef NS_ENUM(NSInteger,HDAttSearchType) {
    HDAttSearchFirst,
    HDAttSearchFront,
    HDAttSearchBehind,
};

@implementation HDCollectionViewLayout
{
    CGFloat contentX;
    CGFloat contentY;
    BOOL isNeedTopStop;
    NSMutableArray *cachedAttributes;//所有属性缓存(不包含装饰view)
    NSMutableDictionary *cacheDicAtts;//所有属性字典缓存
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
- (NSMutableArray<HDSectionModel*> *)allDataArr
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
        HDSectionModel *sec = [self allDataArr][i];
        
        if (sec.section == 0) {
            currentStart->x = 0;
            currentStart->y = 0;
        }

        [self addOneSection:sec isFirst:i == sectionIndex];
    }
    
    //刷新完毕后更正 currentStart (删除最后一个secModel的时候必须更新)
    HDSectionModel *lastSec = [[self allDataArr] lastObject];
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

- (void)addOneSection:(HDSectionModel*)section isFirst:(BOOL)isFirst
{
    NSArray *Atts = [section.layout getAttsWithLayout:self sectionModel:section currentStart:currentStart isFirstSec:isFirst];
    [Atts enumerateObjectsUsingBlock:^(UICollectionViewLayoutAttributes* obj, NSUInteger idx, BOOL * _Nonnull stop) {
        BOOL isDecorationAtt = [obj.representedElementKind isEqualToString:HDDecorationViewKind];
        //装饰view会破坏cachedAttributes的有序性，所以不添加
        if (!isDecorationAtt) {
            [self->cachedAttributes addObject:obj];
        }
        //字典中会缓存所有属性
        NSString *cacheKey = [self getCacheKeyByKind:obj.representedElementKind indexPath:obj.indexPath];
        if (cacheKey) {
            [self->cacheDicAtts setValue:obj forKey:cacheKey];
        }
    }];
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
    //这里使用二分查找 找到当前需要显示的atts（如果直接返回 cachedAttributes，当数据量很大时，将会产生严重卡顿）
    NSMutableArray *finalAtts = [self allVisableAttsForRect:rect];
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
- (NSMutableArray *)allVisableAttsForRect:(CGRect)rect
{
    NSDictionary *tempResult = [self normalBinarySearch:rect start:0 end:cachedAttributes.count-1];//前闭后闭
    NSMutableArray <UICollectionViewLayoutAttributes*>*result = @[].mutableCopy;
    //atts1存储的是当前可视区域所有 除瀑布流以外的 属性
    NSMutableArray *atts1 = tempResult[HDNormalLayoutAttsKey];
    [result addObjectsFromArray:atts1];
    
    //单独进行瀑布流布局的查找,因为整体上瀑布流的indexPath对应的frame并不是排好序的(但是每列/纵向 或 每行/横向 是按序的)
    //waterFlowSetions存放的是可见范围内的瀑布流有哪些段
    NSArray *waterFlowSetions = [tempResult[HDWaterFlowSectionKey] allValues];
    NSMutableArray *att2 = [self findWaterFlowAtts:waterFlowSetions rect:rect];
    [result addObjectsFromArray:att2];
    
    //进行decorationView的添加 (为了减小二分查找代码复杂度 ,decorationView的属性没有放在cachedAttributes中)
    [[tempResult[HDVisiableSecitonsKey] allKeys]enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        NSString *cacheKey = [self getCacheKeyByKind:HDDecorationViewKind indexPath:[NSIndexPath indexPathWithIndex:[obj integerValue]]];
        UICollectionViewLayoutAttributes *decAtt = (UICollectionViewLayoutAttributes*)self->cacheDicAtts[cacheKey];
        if (decAtt) {
            [result addObject:decAtt];
        }
    }];
    
    return result;
}
#pragma mark - 查找可见范围内 某些段内的瀑布流属性数组
- (NSMutableArray*)findWaterFlowAtts:(NSArray*)sections rect:(CGRect)rect
{
    NSMutableArray *result = @[].mutableCopy;
    [sections enumerateObjectsUsingBlock:^(HDSectionModel* obj, NSUInteger idx, BOOL * _Nonnull stop) {
        HDWaterFlowLayout *layout = obj.layout;
        if ([layout isKindOfClass:[HDWaterFlowLayout class]]) {
            [layout.columnAtts enumerateObjectsUsingBlock:^(NSArray<UICollectionViewLayout *> * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                [result addObjectsFromArray:[self oneColumnAtts:rect columnAtts:obj]];
            }];
        }
    }];
    return result;
}
//某列/行 内的可见属性数组
- (NSMutableArray*)oneColumnAtts:(CGRect)rect columnAtts:(NSArray*)columnAtts
{
    NSMutableArray *result = @[].mutableCopy;
    NSInteger firstFind = [self binarySearch:0 end:columnAtts.count-1 rect:rect inAtts:columnAtts];
    if (firstFind == -1) {
        return result;
    }
    //第一个
    [result addObject:columnAtts[firstFind]];
    //前
    for (NSInteger i=firstFind-1; i>=0; i--) {
        UICollectionViewLayoutAttributes *att = columnAtts[i];
        if (CGRectIntersectsRect(att.frame,rect)) {
            [result addObject:att];
        }else{
            break;
        }
    }
    //后
    for (NSInteger i=firstFind+1; i<columnAtts.count; i++) {
        UICollectionViewLayoutAttributes *att = columnAtts[i];
        if (CGRectIntersectsRect(att.frame,rect)) {
            [result addObject:att];
        }else{
            break;
        }
    }
    return result;
}

#pragma mark - 找到可视区域内所有的 非瀑布流 && 非装饰view 的属性数组 /所有的瀑布流段 /当前展示的包含哪些段
- (NSDictionary *)normalBinarySearch:(CGRect)rect start:(NSInteger)start end:(NSInteger)end
{
    NSMutableArray *finalAtts = @[].mutableCopy;//最终返回的当前区域的atts数组（不包含瀑布流的及装饰view任何一个att）
    NSMutableDictionary *waterFlowSections = @{}.mutableCopy;//当前找到的atts包含哪些段的瀑布流
    NSMutableDictionary *allSections = @{}.mutableCopy;//当前显示区域包含哪些段
    NSDictionary *result = @{HDNormalLayoutAttsKey:finalAtts,HDWaterFlowSectionKey:waterFlowSections,HDVisiableSecitonsKey:allSections};
    if (end<start) {
        return result;
    }
    
    //合并递归子结果
    void (^mergeSubResult)(NSDictionary*) = ^(NSDictionary*subResDic){
        //合并属性数组
        [finalAtts addObjectsFromArray:subResDic[HDNormalLayoutAttsKey]];
        //合并可见瀑布流
        [subResDic[HDWaterFlowSectionKey] enumerateKeysAndObjectsUsingBlock:^(id  _Nonnull key, id  _Nonnull obj, BOOL * _Nonnull stop) {
            waterFlowSections[key] = obj;
        }];
        //合并可见section
        [subResDic[HDVisiableSecitonsKey] enumerateKeysAndObjectsUsingBlock:^(id  _Nonnull key, id  _Nonnull obj, BOOL * _Nonnull stop) {
            allSections[key] = @(1);
        }];
        
    };
    
    //添加一个att
    BOOL (^addNormalAtt)(UICollectionViewLayoutAttributes*,HDAttSearchType,NSInteger) = ^(UICollectionViewLayoutAttributes* att,HDAttSearchType type,NSInteger index){
        //瀑布流不添加，因为在cachedAttributes中，它们的frame.orign不是与indexPath成正比的
        BOOL isWaterAtt = [self isWaterFlowAtt:att];
        BOOL isNeedAdd = !isWaterAtt;
        allSections[@(att.indexPath.section).stringValue] = @(1);
        if (isNeedAdd) {
            //对于 瀑布流，查找结束后单独处理
            [finalAtts addObject:att];
        }else{
            //添加过程中遇到了 瀑布流, 那么认为本次查找为无效查找，继续分段查找。
            
            //保存可见瀑布流
            if (att.indexPath.section < [self allDataArr].count) {
                HDSectionModel *secModel = [self allDataArr][att.indexPath.section];
                waterFlowSections[@(secModel.section).stringValue] = secModel;
            }
            
            //跳过该段 瀑布流可视区域内可能还有常规布局，所以继续递归搜索
            if (type == HDAttSearchFirst) {
                NSDictionary *resDic = [self normalBinarySearch:rect start:start end:index-1];
                mergeSubResult(resDic);
                
                NSDictionary *resDic2 = [self normalBinarySearch:rect start:index+1 end:end];
                mergeSubResult(resDic2);
            }
            else if (type == HDAttSearchFront) {
                NSDictionary *resDic = [self normalBinarySearch:rect start:start end:index-1];
                mergeSubResult(resDic);
            }else if(type == HDAttSearchBehind){
                NSDictionary *resDic = [self normalBinarySearch:rect start:index+1 end:end];
                mergeSubResult(resDic);
            }
        }
        return isNeedAdd;
    };
    
    
    NSInteger firstFind = [self binarySearch:start end:end rect:rect inAtts:cachedAttributes];
    if (firstFind == -1) {
        //-1代表没有找到，可能已经超出可视范围
        return result;
    }
    UICollectionViewLayoutAttributes *firstAtt = cachedAttributes[firstFind];
    
    //添加第一个找到的att
    if (!addNormalAtt(firstAtt,HDAttSearchFirst,firstFind)) {
        return result;
    }
    
    //向前查找
    BOOL isFrontStop = NO;
    for (NSInteger i=firstFind-1; i>=0; i--) {
        UICollectionViewLayoutAttributes *att = cachedAttributes[i];
        if (!CGRectIntersectsRect(att.frame, rect)) {
            //找到临界点后再向前找几个
            NSInteger continuFindCount = HDContinueFindCount;
            for (NSInteger j=i-1; j>=0; j--) {
                UICollectionViewLayoutAttributes *att2 = cachedAttributes[j];
                if (CGRectIntersectsRect(att2.frame, rect)) {
                    isFrontStop = !addNormalAtt(att2,HDAttSearchFront,j);
                }
                continuFindCount--;
                if (continuFindCount<=0 || isFrontStop) {
                    break;
                }
            }
            break;
        }else{
            //遇到了瀑布流就不需要继续了，因为addNormalAtt函数会对其后的数据重新分段查找
            isFrontStop = !addNormalAtt(att,HDAttSearchFront,i);
        }
        if (isFrontStop) {
            break;
        }
    }
    
    //向后查找
    BOOL isBehindStop = NO;
    for (NSInteger i=firstFind+1; i<cachedAttributes.count; i++) {
        UICollectionViewLayoutAttributes *att = cachedAttributes[i];
        if (!CGRectIntersectsRect(att.frame, rect)) {
            
            NSInteger continuFindCount = HDContinueFindCount;
            for (NSInteger j=i+1; j<cachedAttributes.count; j++) {
                UICollectionViewLayoutAttributes *att2 = cachedAttributes[j];
                if (CGRectIntersectsRect(att2.frame, rect)) {
                    isBehindStop = !addNormalAtt(att2,HDAttSearchBehind,j);
                }
                continuFindCount--;
                if (continuFindCount<=0 || isBehindStop) {
                    break;
                }
            }
            break;
        }else{
            isBehindStop = !addNormalAtt(att,HDAttSearchBehind,i);
        }
        if (isBehindStop) {
            break;
        }
    }
    
    return result;
}
- (BOOL)isWaterFlowAtt:(UICollectionViewLayoutAttributes*)att
{
    if (!att) {
        return NO;
    }
    if (att.indexPath.section>[self allDataArr].count) {
        return NO;
    }
    HDSectionModel *secModel = [self allDataArr][att.indexPath.section];
    BOOL isWaterFlowLayout = [secModel.layout isKindOfClass:NSClassFromString(@"HDWaterFlowLayout")];
    return isWaterFlowLayout;
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
@end
