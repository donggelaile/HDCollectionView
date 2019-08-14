//
//  QQDemo2FriendVCVM.m
//  HDCollectionView_Example
//
//  Created by chenhaodong on 2019/8/13.
//  Copyright © 2019 donggelaile. All rights reserved.
//

#import "QQDemo2FriendVCVM.h"
#import "HDCollectionView.h"
#import "QQDemoFriendCellVM.h"
#import "QQDemoOpenCloseSec.h"

@implementation QQDemo2FriendVCVM
- (NSMutableArray*)QQDemo2FriendVCSecArr
{
    NSArray *groupName = @[@"默认",@"大学",@"中学",@"小学"];
    NSMutableArray *result = @[].mutableCopy;
    [groupName enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        [result addObject:[self oneGroupSec:obj]];
    }];
    return result;
}
- (HDSectionModel*)oneGroupSec:(NSString *)groupName
{
    //该段cell数据源
    NSMutableArray *cellModelArr = @[].mutableCopy;
    NSInteger cellCount = 20;
    for (int i =0; i<cellCount; i++) {
        QQDemoFriendCellVM *model = [QQDemoFriendCellVM new];
        model.orgData      = [QQDemoFriendModel new];
        model.cellSize     = CGSizeMake(hd_deviceWidth, 60);
        model.cellClassStr = @"QQDemoFriendCell";
        [cellModelArr addObject:model];
    }
    //该段layout
    HDYogaFlowLayout *layout = [HDYogaFlowLayout new];//isUseSystemFlowLayout为YES时只支持HDBaseLayout
    layout.justify       = YGJustifySpaceBetween;
    layout.headerSize    = CGSizeMake(hd_deviceWidth, 40);
    
    //该段的所有数据封装
    QQDemoOpenCloseSec *secModel = [QQDemoOpenCloseSec new];
    secModel.sectionHeaderClassStr    = @"QQDemoFriendGroupHeader";
    secModel.headerTopStopType        = HDHeaderStopOnTopTypeNormal;
    secModel.isNeedAutoCountCellHW    = NO;
    secModel.sectionDataCopy          = cellModelArr.mutableCopy;
    secModel.isOpen                   = NO;
    secModel.layout                   = layout;
    secModel.headerObj                = groupName;
    return secModel;
    
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
