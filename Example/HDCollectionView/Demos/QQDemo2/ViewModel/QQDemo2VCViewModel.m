//
//  QQDemo2VCViewModel.m
//  HDCollectionView_Example
//
//  Created by HaoDong chen on 2019/5/20.
//  Copyright © 2019 donggelaile. All rights reserved.
//

#import "QQDemo2VCViewModel.h"
#import "HDCollectionView.h"
#import "QQDemo2FriendVC.h"

@implementation QQDemo2VCViewModel
- (NSMutableArray *)topSecArr
{
    if (!_topSecArr) {
        _topSecArr = @[[self topSec]].mutableCopy;
    }
    return _topSecArr;
}
#pragma mark - 顶部内容
- (HDSectionModel*)topSec
{
    //该段cell数据源
    NSArray *cellClsArr = @[@"QQDemoSearchCell",@"QQDemoCreateCell",@"QQDemoCreateCell",@"QQDemoGapCell"];
    NSArray *orgData = @[@"搜索",@"新朋友",@"创建群聊",@""];
    NSMutableArray *cellModelArr = @[].mutableCopy;
    NSInteger cellCount = cellClsArr.count;
    for (int i =0; i<cellCount; i++) {
        HDCellModel *model = [HDCellModel new];
        model.orgData      = orgData[i%orgData.count];
        model.cellClassStr = cellClsArr[i];
        model.cellSize     = CGSizeMake(hd_deviceWidth, 0);
        [cellModelArr addObject:model];
    }
    return [self normalSecWithCellModelArr:cellModelArr headerSize:CGSizeZero headerClsStr:nil autoCountCellH:YES];
}
- (NSMutableArray *)controllers
{
    if (!_controllers) {
        NSMutableArray *result = @[].mutableCopy;
        //仅测试，所以放入同一类型VC
        for (int i=0; i<5; i++) {
            QQDemo2FriendVC *vc1 = [QQDemo2FriendVC new];
            [result addObject:vc1];
        }
        _controllers = result;
    }
    return _controllers;
}
- (NSMutableArray *)titles
{
    return @[@"好友",@"群聊",@"设备",@"通讯录",@"公众号"].mutableCopy;
}
- (CGSize)titleSize
{
    return CGSizeMake(hd_deviceWidth, 45);
}

- (BOOL)headerStop
{
    return YES;
}
- (HDSectionModel*)normalSecWithCellModelArr:(NSArray*)cellModelArr headerSize:(CGSize)headerSize headerClsStr:(NSString*)headerClsStr autoCountCellH:(BOOL)autoCountCellH
{
    //该段layout
    HDYogaFlowLayout *layout = [HDYogaFlowLayout new];//isUseSystemFlowLayout为YES时只支持HDBaseLayout
    layout.justify       = YGJustifySpaceBetween;
    layout.headerSize    = headerSize;
    
    //该段的所有数据封装
    HDSectionModel *secModel = [HDSectionModel new];
    secModel.sectionHeaderClassStr    = headerClsStr;
    secModel.isNeedAutoCountCellHW    = autoCountCellH;
    secModel.sectionDataArr           = cellModelArr.mutableCopy;
    secModel.layout                   = layout;
    return secModel;
}
@end
