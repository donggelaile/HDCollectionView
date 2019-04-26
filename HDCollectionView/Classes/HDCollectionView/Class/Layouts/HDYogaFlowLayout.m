//
//  HDFlowLayout.m
//  HDCollectionView
//
//  Created by HaoDong chen on 2019/3/14.
//  Copyright © 2019 CHD. All rights reserved.
//

#import "HDYogaFlowLayout.h"
#import "HDDefines.h"
#import "HDSectionModel.h"
#import "HDYogaCalculateHelper.h"
#import <objc/runtime.h>

@interface HDFlowLayoutSecModel : NSObject<HDYogaSecProtocol>

@end

@implementation HDFlowLayoutSecModel
@synthesize align;
@synthesize flexDirection;
@synthesize itemLayoutConfigArr;
@synthesize justify;
@synthesize scrollDirection;
@synthesize secInset;
@synthesize superViewSize;
@synthesize horizontalGap;
@synthesize verticalGap;
@synthesize decorationInset;

@end

@interface HDFlowLayoutItemModel : NSObject<HDYogaItemProtocol>
@end

@implementation HDFlowLayoutItemModel
@synthesize alignSelf;
@synthesize margin;
@synthesize size;
@synthesize itemType;

@end


@interface HDYogaFlowLayout()

@end

@implementation HDYogaFlowLayout

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.secInset = UIEdgeInsetsZero;
        self.justify = YGJustifyFlexStart;
        self.align = YGAlignFlexStart;
        self.cellSize = CGSizeZero;
        self.headerSize = CGSizeZero;
        self.footerSize = CGSizeZero;
        self.verticalGap = 0;
        self.horizontalGap = 0;

    }
    return self;
}

- (NSArray *)layoutWithLayout:(HDCollectionViewLayout *)layout sectionModel:(HDSectionModel *)secModel currentStart:(CGPoint *)cStart
{
    __block CGRect sectionSize = CGRectMake(cStart->x, cStart->y, 0, 0);
    
    HDFlowLayoutSecModel *secM = [HDFlowLayoutSecModel new];
    YGFlexDirection fd = YGFlexDirectionRow;
    if (layout.scrollDirection == UICollectionViewScrollDirectionHorizontal) {
        fd = YGFlexDirectionColumn;
    }

    secM.superViewSize = layout.collectionView.superview.frame.size;
    secM.secInset = self.secInset;
    secM.justify = self.justify;
    secM.flexDirection = fd;
    secM.align = self.align;
    secM.verticalGap = self.verticalGap;
    secM.horizontalGap = self.horizontalGap;
    secM.scrollDirection = layout.scrollDirection;
    secM.itemLayoutConfigArr = @[].mutableCopy;
    secM.decorationInset = self.decorationMargin;
    
    NSMutableArray *atts = @[].mutableCopy;
    CGPoint decorationXY = CGPointMake(cStart->x, cStart->y);
    //header
    BOOL isHaveHeader = !CGSizeEqualToSize(CGSizeZero, self.headerSize) && secModel.sectionHeaderClassStr;
    if (isHaveHeader) {
        HDFlowLayoutItemModel *headerItem = [HDFlowLayoutItemModel new];
        headerItem.margin = UIEdgeInsetsZero;
        headerItem.size = self.headerSize;
        headerItem.itemType = UICollectionElementKindSectionHeader;
        [secM.itemLayoutConfigArr addObject:headerItem];
        
        UICollectionViewLayoutAttributes *header = [UICollectionViewLayoutAttributes layoutAttributesForSupplementaryViewOfKind:UICollectionElementKindSectionHeader withIndexPath:[NSIndexPath indexPathWithIndex:secModel.section]];
        [atts addObject:header];
        if (layout.scrollDirection == UICollectionViewScrollDirectionVertical) {
            decorationXY.y += self.headerSize.height;
        }else{
            decorationXY.x += self.headerSize.width;
        }
    }
    
    //cells
    BOOL isHaveCell = secModel.sectionDataArr.count>0;
    [secModel.sectionDataArr enumerateObjectsUsingBlock:^(HDCellModel * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if (!secModel.isNeedAutoCountCellHW) {
            if (obj.cellSizeCb) {
                obj.cellSize = obj.cellSizeCb();
            }
        }
        if (CGSizeEqualToSize(obj.cellSize, CGSizeZero)) {
            obj.cellSize = self.cellSize;
        }
        HDFlowLayoutItemModel *cellItem = [HDFlowLayoutItemModel new];
        cellItem.margin = obj.margin;
        cellItem.size = obj.cellSize;
        cellItem.itemType = @"UICollectionElementCategoryCell";
        [secM.itemLayoutConfigArr addObject:cellItem];
        UICollectionViewLayoutAttributes *cellAtt = [UICollectionViewLayoutAttributes layoutAttributesForCellWithIndexPath:[NSIndexPath indexPathForItem:idx inSection:secModel.section]];
        [atts addObject:cellAtt];
    }];
    
    //footer
    BOOL isHaveFooter = !CGSizeEqualToSize(CGSizeZero, self.footerSize) && secModel.sectionFooterClassStr;
    if (isHaveFooter) {
        HDFlowLayoutItemModel *footerItem = [HDFlowLayoutItemModel new];
        footerItem.margin = UIEdgeInsetsZero;
        footerItem.size = self.footerSize;
        footerItem.itemType = UICollectionElementKindSectionFooter;
        [secM.itemLayoutConfigArr addObject:footerItem];
        
        UICollectionViewLayoutAttributes *footer = [UICollectionViewLayoutAttributes layoutAttributesForSupplementaryViewOfKind:UICollectionElementKindSectionFooter withIndexPath:[NSIndexPath indexPathWithIndex:secModel.section]];
        [atts addObject:footer];        
    }
    
    NSDictionary *finalCountDic = [HDYogaCalculateHelper getSubViewsFrameWithHDYogaSec:secM];
    NSMutableArray*pointArr = finalCountDic[HDFinalOtherInfoArrKey];
    if (pointArr.count == atts.count) {
        [pointArr enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            UICollectionViewLayoutAttributes *att = atts[idx];
            CGSize size = [obj[HDYogaOrgSizeKey] CGSizeValue];
            CGPoint origin = [obj[HDYogaItemPointKey] CGPointValue];
            att.frame = CGRectMake(cStart->x+origin.x, cStart->y+origin.y, size.width, size.height);
            sectionSize = CGRectUnion(sectionSize, att.frame);

        }];
    }

    //判断是否有无cell,没有cell时不再考虑内边距（即让heder与footer紧邻）
    CGFloat offsetY = isHaveCell?self.secInset.bottom:0;
    CGFloat offsetX = isHaveCell?self.secInset.right:0;
    
    if (layout.scrollDirection == UICollectionViewScrollDirectionVertical) {
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
    BOOL isHaveDecoration = [NSClassFromString(secModel.decorationClassStr) isKindOfClass:object_getClass([UICollectionReusableView class])];
    if (isHaveDecoration) {

        UICollectionViewLayoutAttributes *decorationAtt = [UICollectionViewLayoutAttributes layoutAttributesForSupplementaryViewOfKind:HDDecorationViewKind withIndexPath:[NSIndexPath indexPathWithIndex:secModel.section]];
        CGRect orgFrame = [finalCountDic[HDFinalDecorationFrmaeKey] CGRectValue];
        decorationAtt.frame = CGRectMake(orgFrame.origin.x+decorationXY.x, orgFrame.origin.y+decorationXY.y, orgFrame.size.width, orgFrame.size.height);
        decorationAtt.zIndex = -10000000;
        [atts addObject:decorationAtt];
    }
    
    return atts;
}
- (id)valueForUndefinedKey:(NSString *)key
{
    return nil;
}
@end
