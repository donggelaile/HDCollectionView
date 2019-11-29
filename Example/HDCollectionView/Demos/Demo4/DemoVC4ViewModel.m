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
    NSInteger columCount = arc4random()%4+3;
    CGFloat cellW = (hd_deviceWidth-secInset.left-secInset.right - vhGap*(columCount-1))/columCount;
    
    for (int i =0; i<cellCount; i++) {
        HDCellModel *model = [HDCellModel new];
        model.orgData      = @(i).stringValue;
        model.cellSize     = CGSizeMake(cellW, 50);
        model.cellClassStr = @"DemoVC4Cell";
        [cellModelArr addObject:model];
    }
    
    //该段layout
    HDYogaFlowLayout *layout = [HDYogaFlowLayout new];//isUseSystemFlowLayout为YES时只支持HDBaseLayout
    layout.secInset      = secInset;
    layout.justify       = arc4random()%YGJustifyCount;
    layout.verticalGap   = vhGap;
    layout.horizontalGap = vhGap;
    layout.headerSize    = CGSizeMake([UIScreen mainScreen].bounds.size.width, 50);
    layout.footerSize    = CGSizeMake([UIScreen mainScreen].bounds.size.width, 50);
    layout.decorationMargin = UIEdgeInsetsMake(5, 5, 5, 5);
    
    //该段的所有数据封装
    HDSectionModel *secModel = [HDSectionModel new];
    secModel.sectionHeaderClassStr = @"DemoVC4Header";
    secModel.sectionFooterClassStr = @"DemoVC4Footer";
    secModel.headerObj             = nil;
    secModel.footerObj             = nil;
    secModel.headerTopStopType     = ABS(arc4random() & 1);
    secModel.sectionDataArr        = cellModelArr;
    secModel.layout                = layout;
    secModel.decorationClassStr    = @"DemoVC4DecorationView";
    secModel.decorationObj = [UIColor colorWithRed:(arc4random()%255)/255.0 green:(arc4random()%255)/255.0 blue:(arc4random()%255)/255.0 alpha:1];
    
    return secModel;
}

//瀑布流
- (HDSectionModel*)makeWaterSec
{
    //该段cell数据源
    NSMutableArray *cellModelArr = @[].mutableCopy;
    NSInteger cellCount = 10;
    for (int i =0; i<cellCount; i++) {
        HDCellModel *model = [HDCellModel new];
        model.orgData      = [NSString stringWithFormat:@"%@",@(i+1)];
        model.cellSize     = CGSizeMake(0, arc4random()%200 + 100);
        model.cellClassStr = @"DemoVC4Cell";
        //        model.whRatio = ((arc4random() & 1024)+50)/1024.0f+1;
        [cellModelArr addObject:model];
    }
    
    //该段layout
    HDWaterFlowLayout *layout = [HDWaterFlowLayout new];//isUseSystemFlowLayout为YES时只支持HDBaseLayout
    layout.secInset      = UIEdgeInsetsMake(20, 20, 20, 20);
    layout.verticalGap   = 10;
    layout.horizontalGap = 10;
    layout.headerSize    = CGSizeMake([UIScreen mainScreen].bounds.size.width, 50);//CGSizeMake(50, collecitonViewH);//CGSizeMake(self.view.frame.size.width, 50)
    layout.footerSize    = CGSizeMake([UIScreen mainScreen].bounds.size.width, 50);
    
    NSMutableArray *columnRatioArr = @[].mutableCopy;
    NSInteger columnCount = arc4random()%4+2;//2 --- 5列
    for (int i=0; i<columnCount; i++) {
        //每列宽度所占比例
        [columnRatioArr addObject:@(arc4random()%2+2)];
    }
    
    layout.columnRatioArr = columnRatioArr;
    layout.decorationMargin = UIEdgeInsetsMake(5, 5, 5, 5);
    
    //该段的所有数据封装
    HDSectionModel *secModel = [HDSectionModel new];
    secModel.sectionHeaderClassStr = @"DemoVC4Header";
    secModel.sectionFooterClassStr = @"DemoVC4Footer";
    secModel.headerObj             = nil;
    secModel.footerObj             = nil;
    secModel.headerTopStopType     = HDHeaderStopOnTopTypeNormal;
    secModel.sectionDataArr        = cellModelArr;
    secModel.layout                = layout;
    secModel.decorationClassStr    = @"DemoVC4DecorationView";
    secModel.decorationObj = [UIColor colorWithRed:(arc4random()%255)/255.0 green:(arc4random()%255)/255.0 blue:(arc4random()%255)/255.0 alpha:1];
    
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
        HDCellModel *model = [HDCellModel new];
        model.orgData      = [self HXHDInner_DataArr];
        model.cellSize     = CGSizeMake([UIScreen mainScreen].bounds.size.width, 170);
        model.cellClassStr = @"DemoVC4Cell2";
        //赋值一个不会重复的reuseIdentifier，让其与其他cell不会产生复用(此类cell较少时适用)
        model.reuseIdentifier = [NSString stringWithFormat:@"DemoVC4Cell2_%@",@(idx)];
        idx ++;
        [cellModelArr addObject:model];
    }
    
    //该段layout
    HDYogaFlowLayout *layout = [HDYogaFlowLayout new];//isUseSystemFlowLayout为YES时只支持HDBaseLayout
    layout.secInset      = UIEdgeInsetsMake(0, 0, 0, 0);
    layout.justify       = YGJustifySpaceBetween;
    layout.verticalGap   = 0;
    layout.horizontalGap = 0;
    layout.headerSize    = CGSizeMake([UIScreen mainScreen].bounds.size.width, 50);
    layout.footerSize    = CGSizeMake([UIScreen mainScreen].bounds.size.width, 50);
    
    //该段的所有数据封装
    HDSectionModel *secModel = [HDSectionModel new];
    secModel.sectionHeaderClassStr = @"DemoVC4Header";
    secModel.sectionFooterClassStr = @"DemoVC4Footer";
    secModel.headerTopStopType        = HDHeaderStopOnTopTypeNormal;
    secModel.isNeedAutoCountCellHW    = NO;
    secModel.sectionDataArr           = cellModelArr;
    secModel.layout                   = layout;
    
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
        HDCellModel *model = [HDCellModel new];
        model.orgData      = nil;
        model.cellSize     = CGSizeMake(150, 150);
        model.cellClassStr = @"DemoVC4Cell2InnerCell";
        [cellModelArr addObject:model];
    }
    
    //该段layout
    HDYogaFlowLayout *layout = [HDYogaFlowLayout new];//isUseSystemFlowLayout为YES时只支持HDBaseLayout
    layout.secInset      = UIEdgeInsetsMake(10, 10, 10, 10);
    layout.justify       = YGJustifySpaceBetween;
    layout.verticalGap   = 0;
    layout.horizontalGap = 20;
    
    //该段的所有数据封装
    HDSectionModel *secModel = [HDSectionModel new];
    secModel.headerTopStopType        = HDHeaderStopOnTopTypeNone;
    secModel.isNeedAutoCountCellHW    = NO;
    secModel.sectionDataArr           = cellModelArr;
    secModel.layout                   = layout;
    
    return secModel;
}
@end
