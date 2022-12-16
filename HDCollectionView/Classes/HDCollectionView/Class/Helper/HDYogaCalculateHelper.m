//
//  HDYogaCaculateHelper.m
//  yogaKitTableViewDemo
//
//  Created by HaoDong chen on 2019/4/3.
//  Copyright © 2019 chd. All rights reserved.
//

#import "HDYogaCalculateHelper.h"
#import <yoga/Yoga.h>
#import <yoga/YGMacros.h>

@interface HDYogaNode : NSObject
@property (nonatomic, assign, readonly) YGNodeRef yogaNode;
@property (nonatomic, assign, readonly) YGConfigRef yogaConfig;

+ (instancetype)defaultNode;

@end

@implementation HDYogaNode

+ (instancetype)defaultNode {
    HDYogaNode *node = [HDYogaNode new];
    return node;
}

- (instancetype)init {
    self = [super init];
    if (self) {
        _yogaConfig = YGConfigNew();
        _yogaNode = YGNodeNewWithConfig(_yogaConfig);
    }
    return self;
}

- (void)dealloc {
    YGNodeFree(self.yogaNode);
    YGConfigFree(self.yogaConfig);
}

@end

@implementation HDYogaCalculateHelper
// Yoga 配置函数封装
YGNodeRef makeDefaultNode(void) {
    YGNodeRef Node = YGNodeNewWithConfig(YGConfigNew());
    YGNodeSetMeasureFunc(Node, NULL);
    YGNodeRemoveAllChildren(Node);
    return Node;
}

void YGSetPading(YGNodeRef node, UIEdgeInsets pading){
    YGNodeStyleSetPadding(node, YGEdgeLeft, pading.left);
    YGNodeStyleSetPadding(node, YGEdgeRight, pading.right);
    YGNodeStyleSetPadding(node, YGEdgeTop, pading.top);
    YGNodeStyleSetPadding(node, YGEdgeBottom, pading.bottom);
}

void YGSetMargain(YGNodeRef node, UIEdgeInsets margin){
    YGNodeStyleSetMargin(node, YGEdgeLeft, margin.left);
    YGNodeStyleSetMargin(node, YGEdgeRight, margin.right);
    YGNodeStyleSetMargin(node, YGEdgeTop, margin.top);
    YGNodeStyleSetMargin(node, YGEdgeBottom, margin.bottom);
}

void YGSetSize(YGNodeRef node, CGSize size){
    YGNodeStyleSetHeight(node, size.height);
    YGNodeStyleSetWidth(node, size.width);
}

+ (NSMutableDictionary *)getSubViewsFrameWithHDYogaSec:(id<HDYogaSecProtocol>)sec {
    NSMutableDictionary *finalDic = @{}.mutableCopy;
    CGRect decorationFrame = CGRectZero;
    
    UIEdgeInsets secPading = sec.secInset;
    YGJustify secJustify = sec.justify;
    YGAlign secAlign = sec.align;
    YGFlexDirection secFlexD = sec.flexDirection;

    //初始化根节点，对应collectionView的某个section
    HDYogaNode* rootNode = [HDYogaNode defaultNode];
    YGNodeStyleSetFlexDirection(rootNode.yogaNode, YGFlexDirectionRow);
    YGNodeStyleSetJustifyContent(rootNode.yogaNode, YGJustifyFlexStart);
    YGNodeStyleSetAlignItems(rootNode.yogaNode, YGAlignFlexStart);
    YGNodeStyleSetFlexWrap(rootNode.yogaNode, YGWrapWrap);
    
    id<HDYogaItemProtocol>  firstItem = [sec.itemLayoutConfigArr firstObject];
    BOOL isHaveHeader = [firstItem.itemType isEqualToString:UICollectionElementKindSectionHeader];
    
    id<HDYogaItemProtocol>  lastItem = [sec.itemLayoutConfigArr lastObject];
    BOOL isHaveFooter = [lastItem.itemType isEqualToString:UICollectionElementKindSectionFooter];
    
    //header
    HDYogaNode* headerNode = nil;
    if (isHaveHeader) {
        headerNode = [HDYogaNode defaultNode];
        YGSetSize(headerNode.yogaNode, firstItem.size);
        [sec.itemLayoutConfigArr removeObject:firstItem];
    }
    //footer
    HDYogaNode* footerNode = nil;
    if (isHaveFooter) {
        footerNode = [HDYogaNode defaultNode];
        YGSetSize(footerNode.yogaNode, lastItem.size);
        [sec.itemLayoutConfigArr removeObject:lastItem];
    }
    //cell 的父node
    HDYogaNode* helpNode = nil;
    if (sec.itemLayoutConfigArr.count > 0) {
        helpNode = [HDYogaNode defaultNode];
        YGNodeStyleSetFlexDirection(helpNode.yogaNode, secFlexD);
        YGNodeStyleSetJustifyContent(helpNode.yogaNode, secJustify);
        YGNodeStyleSetAlignItems(helpNode.yogaNode, secAlign);
        YGNodeStyleSetFlexWrap(helpNode.yogaNode, YGWrapWrap);
        YGNodeStyleSetFlexGrow(helpNode.yogaNode, 1);
        YGSetPading(helpNode.yogaNode, secPading);
        if (sec.scrollDirection == UICollectionViewScrollDirectionVertical) {
            YGNodeStyleSetWidth(helpNode.yogaNode, sec.superViewSize.width+sec.horizontalGap);
        }else{
            YGNodeStyleSetHeight(helpNode.yogaNode,sec.superViewSize.height+sec.verticalGap);
        } 
        
        /*
         因为cell间的间距是由cellNode设置margain的left及top实现的：(YGSetMargain(subNode.yogaNode, UIEdgeInsetsMake(mTop, mLeft, margin.bottom, margin.right)); 153行)
         因此需要对cell的父node设置整体偏移，否则段内左间距及顶部间距将变为secInset与verticalGap/horizontalGap之和
         */
        YGSetMargain(helpNode.yogaNode, UIEdgeInsetsMake(-sec.verticalGap, -sec.horizontalGap, 0, 0));
        
    }
    
    //添加child
    if (isHaveHeader) {
        YGNodeInsertChild(rootNode.yogaNode, headerNode.yogaNode, YGNodeGetChildCount(rootNode.yogaNode));
    }
    if (helpNode) {
        YGNodeInsertChild(rootNode.yogaNode, helpNode.yogaNode, YGNodeGetChildCount(rootNode.yogaNode));
    }
    if (isHaveFooter) {
        YGNodeInsertChild(rootNode.yogaNode, footerNode.yogaNode, YGNodeGetChildCount(rootNode.yogaNode));
    }
    
    NSMutableArray *cellNodeArr = @[].mutableCopy;
    [sec.itemLayoutConfigArr enumerateObjectsUsingBlock:^(id<HDYogaItemProtocol>  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        //设置内部子view的属性
        HDYogaNode* subNode = [HDYogaNode defaultNode];
        [cellNodeArr addObject:subNode];
        
        UIEdgeInsets margain = obj.margain;
        CGSize size = obj.size;
        
        YGSetSize(subNode.yogaNode, size);
        
        CGFloat mTop = margain.top==0 ?sec.verticalGap: margain.top;
        CGFloat mLeft = margain.left==0 ?sec.horizontalGap: margain.left;
        YGSetMargain(subNode.yogaNode, UIEdgeInsetsMake(mTop, mLeft, margain.bottom, margain.right));
        //添加子节点
        YGNodeInsertChild(helpNode.yogaNode, subNode.yogaNode, (uint32_t)idx);
    }];
    
    //计算
    UICollectionViewScrollDirection scrollD = sec.scrollDirection;
    CGSize rootSize = sec.superViewSize;

    CGSize calculateSize = rootSize;
    if (scrollD == UICollectionViewScrollDirectionVertical) {
        calculateSize = CGSizeMake(calculateSize.width, NAN);
    }else{
        calculateSize = CGSizeMake(NAN, calculateSize.height);
    }
    
    //父view大小计算
    YGNodeCalculateLayout(rootNode.yogaNode,calculateSize.width,calculateSize.height,YGNodeStyleGetDirection(rootNode.yogaNode));
    NSMutableArray *result = @[].mutableCopy;
    
    //添加heder point
    if (headerNode) {
        CGPoint headerStart = {
            YGNodeLayoutGetLeft(headerNode.yogaNode),
            YGNodeLayoutGetTop(headerNode.yogaNode),
        };
        [result addObject:@{HDYogaItemTypeKey:firstItem.itemType,HDYogaItemPointKey:[NSValue valueWithCGPoint:headerStart],HDYogaOrgSizeKey:[NSValue valueWithCGSize:firstItem.size]}];
    }
    
    CGRect allCellFrame = CGRectNull;
    if (helpNode) {
        allCellFrame = CGRectZero;
        //添加cell point
        uint32_t childCount =  YGNodeGetChildCount(helpNode.yogaNode);
        CGPoint helpStart = {
            YGNodeLayoutGetLeft(helpNode.yogaNode),
            YGNodeLayoutGetTop(helpNode.yogaNode),
        };
        
        for (uint32_t i =0; i<childCount; i++) {
            HDYogaNode* subNode = cellNodeArr[i%cellNodeArr.count];
            CGPoint topLeft = {
                YGNodeLayoutGetLeft(subNode.yogaNode),
                YGNodeLayoutGetTop(subNode.yogaNode),
            };
            topLeft = CGPointMake((topLeft.x+helpStart.x), (topLeft.y+helpStart.y));
            id<HDYogaItemProtocol> item = sec.itemLayoutConfigArr[i];
            //生成子view的frame
            NSString *type = @"itemType_error";
            if (item.itemType) {
                type = item.itemType;
            }
            [result addObject:@{HDYogaItemTypeKey:type,HDYogaItemPointKey:[NSValue valueWithCGPoint:topLeft],HDYogaOrgSizeKey:[NSValue valueWithCGSize:item.size]}];
            allCellFrame = CGRectUnion(allCellFrame, (CGRect){topLeft,item.size});
        }
    }
    
    //添加footer point
    if (footerNode) {
        CGPoint footerStart = {
            YGNodeLayoutGetLeft(footerNode.yogaNode),
            YGNodeLayoutGetTop(footerNode.yogaNode),
        };
        //当align为YGAlignSpaceBetween或YGAlignSpaceAround时，helpNode子节点的布局会超出父节点,导致footer在cell上
        //并使得后面的段的起点不再正确，这里做了修复
        if (sec.align == YGAlignSpaceBetween || sec.align == YGAlignSpaceAround) {
            if (!CGRectIsNull(allCellFrame)) {
                if (sec.scrollDirection == UICollectionViewScrollDirectionVertical) {
                    footerStart.y = MAX(CGRectGetMaxY(allCellFrame), footerStart.y);
                }else{
                    footerStart.x = MAX(CGRectGetMaxX(allCellFrame), footerStart.x);
                }
            }
        }
        [result addObject:@{HDYogaItemTypeKey:lastItem.itemType,HDYogaItemPointKey:[NSValue valueWithCGPoint:footerStart],HDYogaOrgSizeKey:[NSValue valueWithCGSize:lastItem.size]}];
    }
    
    //计算docoreationView的段内frame
    if (helpNode) {
        CGSize helpSize = {
            YGNodeLayoutGetWidth(helpNode.yogaNode),
            YGNodeLayoutGetHeight(helpNode.yogaNode),
        };
        
        decorationFrame = CGRectMake(sec.decorationInset.left, sec.decorationInset.top, helpSize.width-sec.decorationInset.left-sec.decorationInset.right-sec.horizontalGap, helpSize.height - sec.decorationInset.top - sec.decorationInset.bottom-sec.verticalGap);
    }
    
    finalDic[HDFinalOtherInfoArrKey] = result;
    finalDic[HDFinalDecorationFrmaeKey] = [NSValue valueWithCGRect:decorationFrame];
    return finalDic;
}

@end
