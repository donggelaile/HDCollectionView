//
//  HDHeaderStopHelper.m
//  HDCollectionView
//
//  Created by HaoDong chen on 2019/4/10.
//  Copyright © 2019 CHD. All rights reserved.
//

#import "HDHeaderStopHelper.h"
#import "HDSectionModel.h"
#import "HDBaseLayout.h"
#import <objc/runtime.h>
static char *HDUICollectionViewLayoutAttributesIndexKey = "HDUICollectionViewLayoutAttributesIndexKey";
@implementation HDHeaderStopHelper
//视图层级由上到下为 Indicator -> 段数靠前的header -> 段数靠后的header -> footer -> cell -> decorationView
+ (NSMutableArray *)getAdjustAttArrWith:(NSMutableArray *)oriRectAttArr allSectionData:(NSMutableArray *)secDataArr layout:(UICollectionViewLayout*)layout scollDirection:(UICollectionViewScrollDirection)scorllDirection
{
    if (!oriRectAttArr) {
        return nil;
    }
    if (!secDataArr) {
        return oriRectAttArr;
    }
    NSMutableArray *AllRectAtts = oriRectAttArr.mutableCopy;
    NSMutableDictionary *headerAtts = @{}.mutableCopy;
    NSMutableDictionary<NSNumber *,UICollectionViewLayoutAttributes *> *secLastAtt = @{}.mutableCopy;
    [AllRectAtts enumerateObjectsUsingBlock:^(UICollectionViewLayoutAttributes * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        
        BOOL isHeader = [[obj representedElementKind] isEqualToString:UICollectionElementKindSectionHeader];
        BOOL isFooter = [[obj representedElementKind] isEqualToString:UICollectionElementKindSectionFooter];
        //先恢复默认值
        if (obj.representedElementCategory == UICollectionElementCategoryCell ) {
            obj.zIndex = HDCellDefaultZindex;
        }else if (isHeader){
            obj.zIndex = HDHeaderViewDefaultZindex;
        }else if (isFooter){
            obj.zIndex = HDFooterViewDefaultZindex;
        }else if ([obj.representedElementKind isEqualToString:HDDecorationViewKind]){
            obj.zIndex = HDDecorationViewDefaultZindex;
        }
        
        
        NSIndexPath *indexPath = [obj indexPath];

        if (isHeader) {
            headerAtts[@(indexPath.section)] = obj;
            UICollectionViewLayoutAttributes *currentAttribute = secLastAtt[@(indexPath.section)];
            if (!currentAttribute) {
                [secLastAtt setObject:obj forKey:@(indexPath.section)];
            }
        } else{
            UICollectionViewLayoutAttributes *currentAttribute = secLastAtt[@(indexPath.section)];
            if ( !currentAttribute ||
                indexPath.item > currentAttribute.indexPath.item ||
                ((currentAttribute.indexPath.section == indexPath.section)&&(isFooter))||
                [currentAttribute.representedElementKind isEqualToString:UICollectionElementKindSectionHeader]) {
                [secLastAtt setObject:obj forKey:@(indexPath.section)];
            }
        }
        objc_setAssociatedObject(obj, HDUICollectionViewLayoutAttributesIndexKey, @(idx), OBJC_ASSOCIATION_RETAIN);
    }];
    
    __block NSInteger crtMaxSec = 0;//当前展示的最大的section
    [AllRectAtts enumerateObjectsUsingBlock:^(UICollectionViewLayoutAttributes * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if (obj.indexPath.section > crtMaxSec) {
            crtMaxSec = obj.indexPath.section;
        }
    }];
    
    NSMutableArray *needStopHeader = @[].mutableCopy;
    
    //找到当前滑动范围之前的所有需要悬停的header
    [secDataArr enumerateObjectsUsingBlock:^(id<HDSectionModelProtocol> obj, NSUInteger idx, BOOL * _Nonnull stop) {
        
        [(NSObject*)obj setValue:@(idx) forKey:@"section"];//需要对section手动赋值
        if (obj.headerTopStopType != HDHeaderStopOnTopTypeNone) {
            if (idx>crtMaxSec) {
                *stop = YES;
            }
            if (obj.headerTopStopType == HDHeaderStopOnTopTypeAlways ||
                (secLastAtt[@(obj.section)] && obj.headerTopStopType == HDHeaderStopOnTopTypeNormal)
                ) {
                //保证header存在 在添加
                BOOL isHaveHeader = !CGSizeEqualToSize(CGSizeZero, obj.layout.headerSize) && obj.sectionHeaderClassStr;
                if (isHaveHeader) {
                    [needStopHeader addObject:obj];
                }
            }
        }
    }];
    
    
    __block CGFloat topOffset = 0;
    //更新header的frame及topOffset
    [needStopHeader enumerateObjectsUsingBlock:^(id<HDSectionModelProtocol> obj, NSUInteger idx, BOOL * _Nonnull stop) {
        UICollectionViewLayoutAttributes *header = headerAtts[@(obj.section)];
        if (!header) {
            //对于已经不再可视范围内的，需要重新获取。重新获取的属性，其原来的frame等属性不能被改，所以必须copy一份
            header = [layout layoutAttributesForSupplementaryViewOfKind:UICollectionElementKindSectionHeader
                                                          atIndexPath:[NSIndexPath indexPathForItem:0 inSection:obj.section]];
            header = [header copy];
            [AllRectAtts addObject:header];
            [self updateHeaderAttributes:header secLastAttributes:secLastAtt[@(obj.section)] topOffset:&topOffset topStopType:obj.headerTopStopType section:obj.section layout:layout scollDirection:scorllDirection secOffset:obj.headerTopStopOffset];
        }else{
            NSInteger orgAttIndex = [objc_getAssociatedObject(header, HDUICollectionViewLayoutAttributesIndexKey) integerValue];
            header = [header copy];//必须copy，不破坏初始计算值，不copy会导致无法正确归位
            [self updateHeaderAttributes:header secLastAttributes:secLastAtt[@(obj.section)] topOffset:&topOffset topStopType:obj.headerTopStopType section:obj.section layout:layout scollDirection:scorllDirection secOffset:obj.headerTopStopOffset];
            if (orgAttIndex<AllRectAtts.count) {
                [AllRectAtts replaceObjectAtIndex:orgAttIndex withObject:header];
            }
        }

    }];
    
    return AllRectAtts;
}
+ (void)updateHeaderAttributes:(UICollectionViewLayoutAttributes *)attributes secLastAttributes:(UICollectionViewLayoutAttributes *)lastCellAttributes topOffset:(CGFloat *)offset topStopType:(HDHeaderStopOnTopType)stopType section:(NSInteger)section layout:(UICollectionViewLayout*)layout scollDirection:(UICollectionViewScrollDirection)scorllDirection secOffset:(NSInteger)secOffset
{
    if (stopType == HDHeaderStopOnTopTypeNone) {
        return;
    }
    BOOL isVertical = scorllDirection == UICollectionViewScrollDirectionVertical;
    CGRect currentBounds = layout.collectionView.bounds;
    CGPoint origin = attributes.frame.origin;
    
    CGFloat contentOffsetXY = 0;//当前横向或纵向的偏移量
    CGFloat sectionMaxXY = 0;//当前header能最大到达的偏移量（HDHeaderStopOnTopTypeAlways不受此限制）
    if (isVertical) {
        contentOffsetXY = CGRectGetMinY(currentBounds) + *offset + secOffset;
        sectionMaxXY = CGRectGetMaxY(lastCellAttributes.frame) - CGRectGetHeight(attributes.frame);
    }else{
        contentOffsetXY = CGRectGetMinX(currentBounds) + *offset + secOffset;
        sectionMaxXY = CGRectGetMaxX(lastCellAttributes.frame) - CGRectGetWidth(attributes.frame);
    }
    
    
    CGFloat originY = origin.y;
    CGFloat originX = origin.x;
    
    if (stopType == HDHeaderStopOnTopTypeAlways) {
        //总是悬停的header总与当前偏移量对齐或是其原本位置
        if (isVertical) {
            *offset = *offset + CGRectGetHeight(attributes.frame) + secOffset;
            originY = MAX(contentOffsetXY, attributes.frame.origin.y);
        }else{
            *offset = *offset + CGRectGetWidth(attributes.frame) + secOffset;
            originX = MAX(contentOffsetXY, attributes.frame.origin.x);
        }
        
    }else if(stopType == HDHeaderStopOnTopTypeNormal){
        //只有当前段在当前屏幕上存在时才展示，所以有偏移量最大值限制
        if (isVertical) {
            originY = MIN(MAX(contentOffsetXY, attributes.frame.origin.y), sectionMaxXY);
        }else{
            originX = MIN(MAX(contentOffsetXY, attributes.frame.origin.x), sectionMaxXY);
        }
        
    }
    
    attributes.zIndex =  -10 - section;//后边的逐级递减，否则后边的会在前边view的上面
    
    attributes.frame = CGRectMake(originX, originY, attributes.frame.size.width, attributes.frame.size.height);
}
@end
