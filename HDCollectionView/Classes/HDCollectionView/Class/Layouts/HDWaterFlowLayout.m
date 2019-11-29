//
//  HDWaterFlowLayout.m
//  HDCollectionView
//
//  Created by HaoDong chen on 2019/4/13.
//  Copyright © 2019 CHD. All rights reserved.
//

#import "HDWaterFlowLayout.h"
#import "HDSectionModel.h"
#import "HDCellModel.h"
#import <objc/runtime.h>
#import "HDBaseLayout+Cache.h"

@interface HDWaterFlowLayout()
{
    NSMutableArray *columnHeightArr;
    NSMutableArray *columAttsArr;
}
@end

@implementation HDWaterFlowLayout

- (NSArray *)layoutWithLayout:(HDCollectionViewLayout *)layout sectionModel:(id<HDSectionModelProtocol>)secModel currentStart:(CGPoint *)cStart
{
    BOOL isNeedUpdateAll = self.needUpdate || self.cacheAtts.count == 0;
    
    __block CGRect sectionSize = CGRectZero;
    if (isNeedUpdateAll) {
        [self resetColumnHeightAndColumAtts];
        sectionSize = CGRectMake(cStart->x, cStart->y, 0, 0);
    }else{
        sectionSize = self.cacheSectionSize;
    }
    
    NSInteger column = self.columnRatioArr.count;
    NSAssert(column>0, @"列数必须大于0");
    
    NSInteger gapCount = (column-1)>0?(column-1):0;
    NSMutableArray *atts = @[].mutableCopy;
    CGSize cvSize = layout.collectionView.frame.size;
    
    CGPoint decorationXY = CGPointMake(cStart->x, cStart->y);
    BOOL isVertical = layout.scrollDirection == UICollectionViewScrollDirectionVertical;
    BOOL isHaveHeader = !CGSizeEqualToSize(CGSizeZero, self.headerSize) && secModel.sectionHeaderClassStr;
    BOOL isHaveCell = secModel.sectionDataArr.count>0;
    BOOL isHaveDecoration = [HDClassFromString(secModel.decorationClassStr) isKindOfClass:object_getClass([UICollectionReusableView class])];
    BOOL isHaveFooter = !CGSizeEqualToSize(CGSizeZero, self.footerSize) && secModel.sectionFooterClassStr;
    
    //header
    if (isHaveHeader && isNeedUpdateAll) {
        
        UICollectionViewLayoutAttributes *header = [UICollectionViewLayoutAttributes layoutAttributesForSupplementaryViewOfKind:UICollectionElementKindSectionHeader withIndexPath:[NSIndexPath indexPathWithIndex:secModel.section]];
        header.frame = CGRectMake(cStart->x, cStart->y, secModel.layout.headerSize.width, secModel.layout.headerSize.height);
        header.zIndex = HDHeaderViewDefaultZindex;
        sectionSize = CGRectUnion(sectionSize, header.frame);
        [atts addObject:header];
        
        [self->columAttsArr[0] addObject:header];//将header挂在第0列
        if (isVertical) {
            decorationXY.y += self.headerSize.height;
        }else{
            decorationXY.x += self.headerSize.width;
        }
    }else{
        UICollectionViewLayoutAttributes *firstAtt = [self->columAttsArr[0] firstObject];
        if ([firstAtt.representedElementKind isEqualToString:UICollectionElementKindSectionHeader]) {
            if (isVertical) {
                decorationXY.y += self.headerSize.height;
            }else{
                decorationXY.x += self.headerSize.width;
            }
            sectionSize = CGRectUnion(sectionSize, firstAtt.frame);
        }
    }

    
    //cells
    NSMutableDictionary *RowOrColumnXYDic = @{}.mutableCopy;//每行或每列起始的x或y坐标
    NSMutableDictionary *WHRatiDic = @{}.mutableCopy;//每行或每列占比系数,总和为1
    
    __block CGFloat sum = 0;
    [self.columnRatioArr enumerateObjectsUsingBlock:^(NSNumber * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        sum += obj.floatValue;
    }];
    __block CGFloat ratioWidth = 0;
    [self.columnRatioArr enumerateObjectsUsingBlock:^(NSNumber * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        ratioWidth = obj.floatValue/sum;
        WHRatiDic[@(idx).stringValue] = @(ratioWidth);
    }];
    __block CGFloat xy = 0;
    [self.columnRatioArr enumerateObjectsUsingBlock:^(NSNumber * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if (isVertical) {
            if (idx == 0) {
                xy = self.secInset.left;
            }else{
                CGFloat widthOffset = (cvSize.width - self.secInset.left - self.secInset.right - self.horizontalGap *gapCount)*[WHRatiDic[@(idx-1).stringValue] floatValue];
                xy = xy + self.horizontalGap + widthOffset;
            }
        }else{
            if (idx == 0) {
                xy = self.secInset.top;
            }else{
                CGFloat widthOffset = (cvSize.height - self.secInset.top - self.secInset.bottom - self.verticalGap *gapCount)*[WHRatiDic[@(idx-1).stringValue] floatValue];
                xy = xy + self.verticalGap + widthOffset;
            }
        }
        RowOrColumnXYDic[@(idx).stringValue] = @(round(xy));
    }];

    self.cacheSectionSize = sectionSize;//这里需要缓存的是header及以上的大小
    
    CGFloat currentY = CGRectGetMaxY(sectionSize);
    CGFloat currentX = CGRectGetMaxX(sectionSize);
    
    NSInteger cellStartIndex = 0;
    if (!isNeedUpdateAll) {
        //不需要更新缓存时将decorationView及footerView的att移除（后面会重新添加）
        if (isHaveDecoration) {
            [self.cacheAtts removeLastObject];
        }
        if (isHaveFooter) {
            [self.cacheAtts removeLastObject];
            UICollectionViewLayoutAttributes *footer = [self->columAttsArr[0] lastObject];
            if ([footer.representedElementKind isEqualToString:UICollectionElementKindSectionFooter]) {
                [self->columAttsArr[0] removeLastObject];
            }
        }
        cellStartIndex = self.cacheAtts.count;
        if (isHaveHeader && self.cacheAtts.count>=1) {
            cellStartIndex -= 1;
        }
    }
    
    for (NSInteger idx = cellStartIndex; idx<secModel.sectionDataArr.count; idx++) {
        id<HDCellModelProtocol>obj = secModel.sectionDataArr[idx];
        CGRect cellFrame = CGRectZero;
        if (!secModel.isNeedAutoCountCellHW) {
            if (obj.cellSizeCb) {
                obj.cellSize = obj.cellSizeCb();
            }
        }
        if (CGSizeEqualToSize(obj.cellSize, CGSizeZero)) {
            obj.cellSize = self.cellSize;
        }
        
        UIEdgeInsets secInset = self.secInset;
        CGFloat x = 0,y = 0,w =0 ,h = 0;
        NSInteger minColumnOrRow = 0;
        if (isVertical) {
            NSInteger minHColume = [self minColumnHeightIndex];
            CGFloat minH = [self minColumnHeight];
            CGFloat topOffset = secInset.top + currentY;
            w = ((cvSize.width -secInset.left - secInset.right)-gapCount*self.horizontalGap)*[WHRatiDic[@(minHColume).stringValue] floatValue];
            x = [RowOrColumnXYDic[@(minHColume).stringValue] floatValue];
            y = topOffset + minH;
            h = obj.cellSize.height;
            cellFrame = CGRectMake(x, y, w, h);
            self->columnHeightArr[minHColume] = @(CGRectGetMaxY(cellFrame)+self.verticalGap-topOffset);
            minColumnOrRow = minHColume;
        }else{
            NSInteger minWRow = [self minColumnHeightIndex];
            CGFloat minW = [self minColumnHeight];
            CGFloat leftOffset = secInset.left + currentX;
            h = ((cvSize.height -secInset.top - secInset.bottom)-gapCount*self.verticalGap)*[WHRatiDic[@(minWRow).stringValue] floatValue];
            y = [RowOrColumnXYDic[@(minWRow).stringValue] floatValue];
            x = leftOffset + minW;
            w = obj.cellSize.width;
            cellFrame = CGRectMake(x, y, w, h);
            self->columnHeightArr[minWRow] = @(CGRectGetMaxX(cellFrame)+self.horizontalGap-leftOffset);
            minColumnOrRow = minWRow;
        }
        UICollectionViewLayoutAttributes *cellAtt = [UICollectionViewLayoutAttributes layoutAttributesForCellWithIndexPath:[NSIndexPath indexPathForItem:idx inSection:secModel.section]];
        cellAtt.frame = cellFrame;
        cellAtt.zIndex = HDCellDefaultZindex;
        [atts addObject:cellAtt];
        obj.cellSize = CGSizeMake(w, h);
        sectionSize = CGRectUnion(sectionSize, cellFrame);
        
        //存储每列(行)所对应的属性(内部二分查找使用)
        NSMutableArray *someColumnAtts = self->columAttsArr[minColumnOrRow];
        [someColumnAtts addObject:cellAtt];
        
        [(NSObject*)obj setValue:[NSIndexPath indexPathForItem:idx inSection:secModel.section] forKey:@"indexP"];
        [(NSObject*)obj setValue:secModel forKey:@"secModel"];
    }

    //判断是否有无cell,没有cell时不再考虑内边距（即让heder与footer紧邻）
    CGFloat offsetY = isHaveCell?self.secInset.bottom:0;
    CGFloat offsetX = isHaveCell?self.secInset.right:0;
    
    //footer
    if (isHaveFooter) {
        UICollectionViewLayoutAttributes *footer = [UICollectionViewLayoutAttributes layoutAttributesForSupplementaryViewOfKind:UICollectionElementKindSectionFooter withIndexPath:[NSIndexPath indexPathWithIndex:secModel.section]];
        footer.zIndex = HDFooterViewDefaultZindex;
        if (isVertical) {
            footer.frame = CGRectMake(0, CGRectGetMaxY(sectionSize)+offsetY, self.footerSize.width, self.footerSize.height);
        }else{
            footer.frame = CGRectMake(CGRectGetMaxX(sectionSize)+offsetX, 0, self.footerSize.width, self.footerSize.height);
        }
        sectionSize = CGRectUnion(sectionSize, footer.frame);
        [atts addObject:footer];
        [self->columAttsArr[0] addObject:footer];//将footer挂在第0列
    }
    
    if (isVertical) {
        if (isHaveFooter) {
            cStart->y = CGRectGetMaxY(sectionSize);
        }else{
            cStart->y = CGRectGetMaxY(sectionSize) + offsetY;
        }
    }else{
        if (isHaveFooter) {
            cStart->x = CGRectGetMaxX(sectionSize);
        }else{
            cStart->x = CGRectGetMaxX(sectionSize) + offsetX;
        }
    }

    //decoration
    if (isHaveDecoration) {
        CGSize cellBgSize = CGSizeZero;
        UICollectionViewLayoutAttributes *decorationAtt = [UICollectionViewLayoutAttributes layoutAttributesForSupplementaryViewOfKind:HDDecorationViewKind withIndexPath:[NSIndexPath indexPathWithIndex:secModel.section]];
        if (isVertical) {
            CGFloat headerH = isHaveHeader?self.headerSize.height:0;
            CGFloat footerH = isHaveFooter?self.footerSize.height:0;
            CGFloat bgOffset = isHaveFooter?0:self.secInset.bottom;
            CGFloat cellBgH = sectionSize.size.height - headerH - footerH + bgOffset;
            cellBgSize = CGSizeMake(cvSize.width, cellBgH);
        }else{
            CGFloat headerW = isHaveHeader?self.headerSize.width:0;
            CGFloat footerW = isHaveFooter?self.footerSize.width:0;
            CGFloat bgOffset = isHaveFooter?0:self.secInset.right;
            CGFloat cellBgW = sectionSize.size.width - headerW - footerW + bgOffset;
            cellBgSize = CGSizeMake(cellBgW, cvSize.height);
        }
        decorationAtt.frame = CGRectMake(decorationXY.x+self.decorationMargin.left, decorationXY.y+self.decorationMargin.top, cellBgSize.width-self.decorationMargin.left-self.decorationMargin.right, cellBgSize.height-self.decorationMargin.top-self.decorationMargin.bottom);
        decorationAtt.zIndex = HDDecorationViewDefaultZindex;
        [atts addObject:decorationAtt];

        if (!isHaveCell) {
            decorationAtt.frame = CGRectZero;
        }
    }
    if (isNeedUpdateAll) {
        self.cacheAtts = atts;
        self.needUpdate = NO;
    }else{
        [self.cacheAtts addObjectsFromArray:atts];

    }
    [(NSObject*)secModel setValue:[NSValue valueWithCGRect:sectionSize] forKey:@"secProperRect"];
    return self.cacheAtts;
}

- (void)setColumnRatioArr:(NSArray<NSNumber *> *)columnRatioArr
{
    _columnRatioArr = columnRatioArr;
    [self resetColumnHeightAndColumAtts];
}
- (void)resetColumnHeightAndColumAtts
{
    columnHeightArr = @[].mutableCopy;
    columAttsArr = @[].mutableCopy;
    [_columnRatioArr enumerateObjectsUsingBlock:^(NSNumber * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        [self->columnHeightArr addObject:@(0)];
        [self->columAttsArr addObject:@[].mutableCopy];
    }];

}

//这里在横向滑动时是最小宽度的位置
- (NSInteger)minColumnHeightIndex
{
    NSInteger minIndex = 0;
    CGFloat nowMinH = CGFLOAT_MAX;
    if (self.isFirstAddAtRightOrBottom) {
        minIndex = self.columnRatioArr.count-1;
    }
    
    if (self.isFirstAddAtRightOrBottom) {
        for (int i=(int)(self.columnRatioArr.count-1);i>=0;i--) {
            NSNumber*columH = columnHeightArr[i];
            if ([columH floatValue]<nowMinH) {
                minIndex = i;
                nowMinH = [columH floatValue];
            }
        }
    }else{
        for (int i=0;i<columnHeightArr.count;i++) {
            NSNumber*columH = columnHeightArr[i];
            if ([columH floatValue]<nowMinH) {
                minIndex = i;
                nowMinH = [columH floatValue];
            }
        }
    }
    
    return minIndex;
}
- (CGFloat)minColumnHeight
{
    CGFloat minH = CGFLOAT_MAX;
    for (int i=0;i<columnHeightArr.count;i++) {
        NSNumber*columH = columnHeightArr[i];
        if ([columH floatValue]<minH) {
            minH = [columH floatValue];
        }
    }
    return minH;
}
- (NSArray<NSArray<UICollectionViewLayoutAttributes *> *> *)columnAtts
{
    return columAttsArr;
}
@end
