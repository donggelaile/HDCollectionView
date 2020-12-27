//
//  DemoVC4ViewModel.m
//  HDCollectionView_Example
//
//  Created by HaoDong chen on 2019/5/10.
//  Copyright © 2019 donggelaile. All rights reserved.
//

#import "DemoVC4ViewModel.h"
#import "HDCollectionView.h"

@interface DemoVC4ViewModel(DemoVC4Cell2ViewModel)
- (HDSectionModel*)HXHD_YogaSec;
@end

@implementation DemoVC4ViewModel
 -(void)loadData:(void (^)(BOOL, id _Nonnull))calback
{
    //发起网络请求、处理后返回(这里省略）
    
    NSMutableArray *randomArr = @[].mutableCopy;
    for (int i=0; i<100; i++) {
        BOOL random = arc4random()%2;
        HDSectionModel *sec;
        if (i == 5 || i == 9) {
            sec = [self HXHD_YogaSec];
        }else{
            if (random) {
                sec = [self makeWaterSec];
            }else{
                sec = [self makeYogaSec];
            }
        }
        [randomArr addObject:sec];
    }
    //如果没有对callback强引用，外部可以不用weakSelf
    if (calback) {
        calback(YES,randomArr);
    }
}

//普通流式布局
- (HDSectionModel*)makeYogaSec
{
    //该段cell数据源
    NSMutableArray *cellModelArr = @[].mutableCopy;
    NSInteger cellCount = 15;
    CGFloat vhGap = 10;
    UIEdgeInsets secInset = UIEdgeInsetsMake(30, 10, 30, 10);
    
    for (int i =0; i<cellCount; i++) {
        CGFloat cellW = arc4random()%100+40;
        HDCellModel *model = HDMakeCellModelChain
        .hd_orgData(@(i).stringValue)
        .hd_cellSize(CGSizeMake(cellW, 50))
        .hd_cellClassStr(@"DemoVC4Cell")
        .hd_generateObj;//最后一定要调用hd_generateObj
        [cellModelArr addObject:model];
    }
    
    //该段layout
    HDYogaFlowLayout *layout = HDMakeYogaFlowLayoutChain
    .hd_secInset(secInset)
    .hd_justify(arc4random()%YGJustifyCount)
    .hd_verticalGap(vhGap)
    .hd_horizontalGap(vhGap)
    .hd_headerSize(CGSizeMake([UIScreen mainScreen].bounds.size.width, 50))
    .hd_footerSize(CGSizeMake([UIScreen mainScreen].bounds.size.width, 50))
    .hd_decorationMargin(UIEdgeInsetsMake(5, 5, 5, 5))
    .hd_generateObj;
    
    //该段的所有数据封装
    HDSectionModel *secModel = HDMakeSecModelChain
    .hd_sectionHeaderClassStr(@"DemoVC4Header")
    .hd_sectionFooterClassStr(@"DemoVC4Footer")
    .hd_headerTopStopType(ABS(arc4random() & 1))
    .hd_sectionDataArr(cellModelArr)
    .hd_layout(layout)
    .hd_decorationClassStr(@"DemoVC4DecorationView")
    .hd_decorationObj([UIColor colorWithRed:(arc4random()%255)/255.0 green:(arc4random()%255)/255.0 blue:(arc4random()%255)/255.0 alpha:1])
    .hd_generateObj;
    
    return secModel;
}

//瀑布流
- (HDSectionModel*)makeWaterSec
{
    //该段cell数据源
    NSMutableArray *cellModelArr = @[].mutableCopy;
    NSInteger cellCount = 10;
    for (int i =0; i<cellCount; i++) {
        
        HDCellModel *model = HDMakeCellModelChain
        .hd_orgData([NSString stringWithFormat:@"%@",@(i+1)])
        .hd_cellSize(CGSizeMake(0, arc4random()%200 + 100))
        .hd_cellClassStr(@"DemoVC4Cell")
        .hd_generateObj;
        
        [cellModelArr addObject:model];
    }
    
    //该段layout
    NSMutableArray *columnRatioArr = @[].mutableCopy;
    NSInteger columnCount = arc4random()%4+2;//2 --- 5列
    for (int i=0; i<columnCount; i++) {
        //每列宽度所占比例
        [columnRatioArr addObject:@(arc4random()%2+2)];
    }
    
    HDWaterFlowLayout *layout = HDMakeWaterFlowLayoutChain
    .hd_secInset(UIEdgeInsetsMake(20, 20, 20, 20))
    .hd_verticalGap(10)
    .hd_horizontalGap(10)
    .hd_headerSize(CGSizeMake([UIScreen mainScreen].bounds.size.width, 50))
    .hd_footerSize(CGSizeMake([UIScreen mainScreen].bounds.size.width, 50))
    .hd_columnRatioArr(columnRatioArr)
    .hd_decorationMargin(UIEdgeInsetsMake(5, 5, 5, 5))
    .hd_generateObj;
    
    //该段的所有数据封装
    HDSectionModel *secModel = HDMakeSecModelChain
    .hd_sectionHeaderClassStr(@"DemoVC4Header")
    .hd_sectionFooterClassStr(@"DemoVC4Footer")
    .hd_headerTopStopType(HDHeaderStopOnTopTypeNormal)
    .hd_sectionDataArr(cellModelArr)
    .hd_layout(layout)
    .hd_decorationClassStr(@"DemoVC4DecorationView")
    .hd_decorationObj([UIColor colorWithRed:(arc4random()%255)/255.0 green:(arc4random()%255)/255.0 blue:(arc4random()%255)/255.0 alpha:1])
    .hd_generateObj;
    
    return secModel;
}


@end


#pragma mark- 夹杂的横向滑动HDColletionView的数据源
@implementation DemoVC4ViewModel(DemoVC4Cell2ViewModel)
- (HDSectionModel*)HXHD_YogaSec
{
    //该段cell数据源
    static NSInteger idx = 0;
    NSMutableArray *cellModelArr = @[].mutableCopy;
    NSInteger cellCount = 1;
    for (int i =0; i<cellCount; i++) {
        
        HDCellModel *model = HDMakeCellModelChain
        .hd_orgData([self HXHDInner_DataArr])
        .hd_cellSize(CGSizeMake([UIScreen mainScreen].bounds.size.width, 170))
        .hd_cellClassStr(@"DemoVC4Cell2")
        //赋值一个不会重复的reuseIdentifier，让其与其他cell不会产生复用(此类cell较少时适用)
        .hd_reuseIdentifier([NSString stringWithFormat:@"DemoVC4Cell2_%@",@(idx)])
        .hd_generateObj;
        
        idx ++;
        [cellModelArr addObject:model];
    }
    
    //该段layout
    HDYogaFlowLayout *layout = HDMakeYogaFlowLayoutChain
    .hd_secInset(UIEdgeInsetsZero)
    .hd_justify(YGJustifySpaceBetween)
    .hd_headerSize(CGSizeMake([UIScreen mainScreen].bounds.size.width, 50))
    .hd_footerSize(CGSizeMake([UIScreen mainScreen].bounds.size.width, 50))
    .hd_generateObj;
    
    //该段的所有数据封装
    HDSectionModel *secModel = HDMakeSecModelChain
    .hd_sectionHeaderClassStr(@"DemoVC4Header")
    .hd_sectionFooterClassStr(@"DemoVC4Footer")
    .hd_headerTopStopType(HDHeaderStopOnTopTypeNormal)
    .hd_sectionDataArr(cellModelArr)
    .hd_layout(layout)
    .hd_generateObj;
    
    return secModel;
}

- (NSMutableArray<HDSectionModel*>*)HXHDInner_DataArr
{
    NSMutableArray *dataArr = @[].mutableCopy;
    [dataArr addObject:[self HXHDInner_YogaSec]];
    return dataArr;
    
}
- (HDSectionModel*)HXHDInner_YogaSec
{
    //该段cell数据源
    NSMutableArray *cellModelArr = @[].mutableCopy;
    NSInteger cellCount = 100;
    for (int i =0; i<cellCount; i++) {
        
        HDCellModel *model = HDMakeCellModelChain
        .hd_cellSize(CGSizeMake(150, 150))
        .hd_cellClassStr(@"DemoVC4Cell2InnerCell")
        .hd_generateObj;
        
        [cellModelArr addObject:model];
    }
    
    //该段layout
    HDYogaFlowLayout *layout = HDMakeYogaFlowLayoutChain
    .hd_secInset(UIEdgeInsetsMake(10, 10, 10, 10))
    .hd_justify(YGJustifySpaceBetween)
    .hd_horizontalGap(20)
    .hd_generateObj;
    
    //该段的所有数据封装
    HDSectionModel *secModel = HDMakeSecModelChain
    .hd_headerTopStopType(HDHeaderStopOnTopTypeNone)
    .hd_sectionDataArr(cellModelArr)
    .hd_layout(layout)
    .hd_generateObj;
    
    return secModel;
}
@end
