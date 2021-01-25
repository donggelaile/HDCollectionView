//
//  HDBaseLayout+Cache.m
//  HDCollectionView
//
//  Created by HaoDong chen on 2019/4/12.
//  Copyright © 2019 CHD. All rights reserved.
//

#import "HDBaseLayout+Cache.h"
#import "HDCollectionView.h"
#import <objc/runtime.h>
static char *HDCacheAttsKey = "HDCacheAttsKey";
static char *HDCacheStartKey = "HDCacheStartKey";
static char *HDCacheEndKey = "HDCacheEndKey";
static char *HDCacheNeedUpdateKey = "HDCacheNeedUpdateKey";
static char *HDCacheSectionSizeKey = "HDCacheSectionSizeKey";
@interface HDBaseLayout()

@end

@implementation HDBaseLayout (Cache)
- (NSArray *)getAttsWithLayout:(HDCollectionViewLayout *)layout sectionModel:(id<HDSectionModelProtocol>)secModel currentStart:(CGPoint *)cStart isFirstSec:(BOOL)isFirstSec
{
    CGPoint orgStart = self.cacheStart;
    self.cacheStart = CGPointMake(cStart->x, cStart->y);
    NSArray* result;
    
    NSArray * (^calculateLayout)(void) = ^(){
        return [self layoutWithLayout:layout sectionModel:secModel currentStart:cStart];
    };
    
    NSArray * (^updateAttXY)(void) = ^(){
        NSArray *arr;
        if (secModel.layout.needUpdate) {
            arr = calculateLayout();
        }else{
            arr = [self updateWithoffsetXY:CGPointMake(cStart->x - orgStart.x, cStart->y - orgStart.y) start:cStart secm:secModel];
        }
        return arr;
    };
    
    NSArray* (^calculateOrUpdateXYOnly) (void) = ^(){
        NSArray *arr;
        if (isFirstSec || secModel.layout.needUpdate) {
            arr = calculateLayout();
        }else{
            arr = updateAttXY();
        }
        return arr;
    };

    switch (layout.HDDataChangeType) {
        case HDDataChangeSetAll:
            result = calculateLayout();
            break;
        case HDDataChangeAppendSec:
            result = calculateOrUpdateXYOnly();
            break;
        case HDDataChangeInsertSec:
            result = calculateOrUpdateXYOnly();
            break;
        case HDDataChangeAppendCellModel:
            result = calculateOrUpdateXYOnly();
            break;
        case HDDataChangeAppendSecs:
            result = calculateOrUpdateXYOnly();
            break;
        case HDDataChangeDeleteSec:
            result = updateAttXY();
            break;
        case HDDataChangeChangeSec:
            result = calculateOrUpdateXYOnly();
            break;
        default:
            result = calculateLayout();
            break;
    }
    
    self.cacheAtts = (NSMutableArray*)result;
    self.needUpdate = NO;
    self.cacheEnd = CGPointMake(cStart->x, cStart->y);

    return result;
}

- (NSArray*)updateWithoffsetXY:(CGPoint)offsetXY start:(CGPoint*)start secm:(id<HDSectionModelProtocol>)secM
{
    [self.cacheAtts enumerateObjectsUsingBlock:^(UICollectionViewLayoutAttributes* obj, NSUInteger idx, BOOL * _Nonnull stop) {
        CGRect newFrame = CGRectMake(obj.frame.origin.x+offsetXY.x, obj.frame.origin.y+offsetXY.y, obj.frame.size.width, obj.frame.size.height);
        obj.frame = newFrame;
        if (obj.representedElementCategory == UICollectionElementCategoryCell) {
            obj.indexPath = [NSIndexPath indexPathForItem:obj.indexPath.item inSection:secM.section];
        }else{
            obj.indexPath = [NSIndexPath indexPathWithIndex:secM.section];
        }
    }];
    start->x = self.cacheEnd.x + offsetXY.x;
    start->y = self.cacheEnd.y + offsetXY.y;
    
    //更新decoration
    if ([self respondsToSelector:@selector(decorationAtt)]) {
        UICollectionViewLayoutAttributes *decorationAtt = self.decorationAtt;
        
        if (decorationAtt) {
            CGRect newFrame = CGRectMake(decorationAtt.frame.origin.x+offsetXY.x, decorationAtt.frame.origin.y+offsetXY.y, decorationAtt.frame.size.width, decorationAtt.frame.size.height);
            decorationAtt.frame = newFrame;
            decorationAtt.indexPath = [NSIndexPath indexPathWithIndex:secM.section];
        }
    }
    
    //更新secM.secProperRect
    CGRect orgSecRect = secM.secProperRect.CGRectValue;
    [(NSObject*)secM setValue:[NSValue valueWithCGRect:CGRectMake(self.cacheStart.x, self.cacheStart.y, orgSecRect.size.width, orgSecRect.size.height)] forKey:@"secProperRect"];
    return self.cacheAtts;
}

- (void)setCacheAtts:(NSMutableArray *)cacheAtts
{
    objc_setAssociatedObject(self, HDCacheAttsKey, cacheAtts, OBJC_ASSOCIATION_RETAIN);
}
- (NSMutableArray *)cacheAtts
{
    return objc_getAssociatedObject(self, HDCacheAttsKey);
}
- (void)setCacheStart:(CGPoint)cacheStart
{
    objc_setAssociatedObject(self, HDCacheStartKey, [NSValue valueWithCGPoint:cacheStart], OBJC_ASSOCIATION_RETAIN);
}
-(CGPoint)cacheStart
{
    id start = objc_getAssociatedObject(self, HDCacheStartKey);
    
    return start?[start CGPointValue]:CGPointZero;
}
- (void)setNeedUpdate:(BOOL)needUpdate
{
    objc_setAssociatedObject(self, HDCacheNeedUpdateKey, @(needUpdate), OBJC_ASSOCIATION_RETAIN);
}
- (BOOL)needUpdate
{
    id needUpdate = objc_getAssociatedObject(self, HDCacheNeedUpdateKey);
    if (!needUpdate) {
        return YES;//未初始化过则认为需要更新
    }
    return [needUpdate boolValue];
}
- (void)setCacheSectionSize:(CGRect)cacheSectionSize
{
    objc_setAssociatedObject(self, HDCacheSectionSizeKey, [NSValue valueWithCGRect:cacheSectionSize], OBJC_ASSOCIATION_RETAIN);
}
- (CGRect)cacheSectionSize
{
    id size = objc_getAssociatedObject(self, HDCacheSectionSizeKey);
    return size?[size CGRectValue]:CGRectZero;
}
 - (void)setCacheEnd:(CGPoint)cacheEnd
{
    objc_setAssociatedObject(self, HDCacheEndKey, [NSValue valueWithCGPoint:cacheEnd], OBJC_ASSOCIATION_RETAIN);
}
- (CGPoint)cacheEnd
{
    id end = objc_getAssociatedObject(self, HDCacheEndKey);
    return end?[end CGPointValue]:CGPointZero;
}
@end
