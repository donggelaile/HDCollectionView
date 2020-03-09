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
#import "HDCellModel.h"
#import "HDYogaCalculateHelper.h"
#import <objc/runtime.h>
#import "HDBaseLayout+Cache.h"

@implementation HDYogaFlowLayoutChainMaker
@dynamic hd_headerSize,hd_footerSize,hd_cellSize,hd_secInset,hd_verticalGap,hd_horizontalGap;

- (Class)hd_generateLayoutClass
{
    return [HDYogaFlowLayout class];
}

- (HDYogaFlowLayoutChainMaker * _Nonnull (^)(YGJustify))hd_justify
{
    return ^(YGJustify justify){
        self.allValues[@"justify"] = @(justify);
        return self;
    };
}
- (HDYogaFlowLayoutChainMaker * _Nonnull (^)(YGAlign))hd_align
{
    return ^(YGAlign align){
        self.allValues[@"align"] = @(align);
        return self;
    };
}
- (HDYogaFlowLayoutChainMaker * _Nonnull (^)(UIEdgeInsets))hd_decorationMargin
{
    return ^(UIEdgeInsets decorationMargin){
        self.allValues[@"decorationMargin"] = [NSValue valueWithUIEdgeInsets:decorationMargin];
        return self;
    };
}

@end


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
@synthesize margain;
@synthesize size;
@synthesize itemType;

@end


@interface HDYogaFlowLayout()
@property (nonatomic, strong) UICollectionViewLayoutAttributes *decorationAtt;
@end

@implementation HDYogaFlowLayout

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.secInset = UIEdgeInsetsZero;
        self.justify = YGJustifySpaceBetween;//默认与系统类似(系统flowLayout的最后一行会左对齐，YGJustifySpaceBetween每行都两端对齐)
        self.align = YGAlignFlexStart;
        self.cellSize = CGSizeZero;
        self.headerSize = CGSizeZero;
        self.footerSize = CGSizeZero;
        self.verticalGap = 0;
        self.horizontalGap = 0;

    }
    return self;
}

- (NSArray *)layoutWithLayout:(HDCollectionViewLayout *)layout sectionModel:(id<HDSectionModelProtocol>)secModel currentStart:(CGPoint *)cStart
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
        headerItem.margain = UIEdgeInsetsZero;
        headerItem.size = self.headerSize;
        headerItem.itemType = UICollectionElementKindSectionHeader;
        [secM.itemLayoutConfigArr addObject:headerItem];
        
        UICollectionViewLayoutAttributes *header = [UICollectionViewLayoutAttributes layoutAttributesForSupplementaryViewOfKind:UICollectionElementKindSectionHeader withIndexPath:[NSIndexPath indexPathWithIndex:secModel.section]];
        header.zIndex = HDHeaderViewDefaultZindex;
        [atts addObject:header];
        if (layout.scrollDirection == UICollectionViewScrollDirectionVertical) {
            decorationXY.y += self.headerSize.height;
        }else{
            decorationXY.x += self.headerSize.width;
        }
    }
    
    //cells
    BOOL isHaveCell = secModel.sectionDataArr.count>0;
    [secModel.sectionDataArr enumerateObjectsUsingBlock:^(id<HDCellModelProtocol> _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if (!secModel.isNeedAutoCountCellHW) {
            if (obj.cellSizeCb) {
                obj.cellSize = obj.cellSizeCb();
            }
        }
        if (CGSizeEqualToSize(obj.cellSize, CGSizeZero)) {
            obj.cellSize = self.cellSize;
        }
        HDFlowLayoutItemModel *cellItem = [HDFlowLayoutItemModel new];
        cellItem.margain = obj.margain;
        cellItem.size = obj.cellSize;
        cellItem.itemType = @"UICollectionElementCategoryCell";
        [secM.itemLayoutConfigArr addObject:cellItem];
        UICollectionViewLayoutAttributes *cellAtt = [UICollectionViewLayoutAttributes layoutAttributesForCellWithIndexPath:[NSIndexPath indexPathForItem:idx inSection:secModel.section]];
        cellAtt.zIndex = HDCellDefaultZindex;
        [atts addObject:cellAtt];

        [(NSObject*)obj setValue:[NSIndexPath indexPathForItem:idx inSection:secModel.section] forKey:@"indexP"];
        [(NSObject*)obj setValue:secModel forKey:@"secModel"];
    }];
    
    //footer
    BOOL isHaveFooter = !CGSizeEqualToSize(CGSizeZero, self.footerSize) && secModel.sectionFooterClassStr;
    if (isHaveFooter) {
        HDFlowLayoutItemModel *footerItem = [HDFlowLayoutItemModel new];
        footerItem.margain = UIEdgeInsetsZero;
        footerItem.size = self.footerSize;
        footerItem.itemType = UICollectionElementKindSectionFooter;
        [secM.itemLayoutConfigArr addObject:footerItem];
        
        UICollectionViewLayoutAttributes *footer = [UICollectionViewLayoutAttributes layoutAttributesForSupplementaryViewOfKind:UICollectionElementKindSectionFooter withIndexPath:[NSIndexPath indexPathWithIndex:secModel.section]];
        footer.zIndex = HDFooterViewDefaultZindex;
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
    BOOL isHaveDecoration = [HDClassFromString(secModel.decorationClassStr) isKindOfClass:object_getClass([UICollectionReusableView class])];
    if (isHaveDecoration) {

        UICollectionViewLayoutAttributes *decorationAtt = [UICollectionViewLayoutAttributes layoutAttributesForSupplementaryViewOfKind:HDDecorationViewKind withIndexPath:[NSIndexPath indexPathWithIndex:secModel.section]];
        CGRect orgFrame = [finalCountDic[HDFinalDecorationFrmaeKey] CGRectValue];
        decorationAtt.frame = CGRectMake(orgFrame.origin.x+decorationXY.x, orgFrame.origin.y+decorationXY.y, orgFrame.size.width, orgFrame.size.height);
        decorationAtt.zIndex = HDDecorationViewDefaultZindex;
        
        if (!isHaveCell) {
            decorationAtt.frame = CGRectZero;
        }
        //        [atts addObject:decorationAtt];
        self.decorationAtt = decorationAtt;
    }
    
    [(NSObject*)secModel setValue:[NSValue valueWithCGRect:sectionSize] forKey:@"secProperRect"];
    self.cacheAtts = atts;
    return atts;
}
- (id)valueForUndefinedKey:(NSString *)key
{
    return nil;
}

#pragma mark 查找当前显示att
- (NSMutableArray<UICollectionViewLayoutAttributes *> *)layoutAttributesForElementsInRect:(CGRect)rect scrollDirection:(UICollectionViewScrollDirection)scrollDirection
{
    NSMutableArray *arr = [super layoutAttributesForElementsInRect:rect scrollDirection:scrollDirection];
    if (self.decorationAtt) {
        [arr addObject:self.decorationAtt];
    }
    return arr;
}
@end
