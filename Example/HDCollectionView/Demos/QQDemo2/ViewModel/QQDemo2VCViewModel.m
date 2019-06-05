//
//  QQDemo2VCViewModel.m
//  HDCollectionView_Example
//
//  Created by HaoDong chen on 2019/5/20.
//  Copyright © 2019 donggelaile. All rights reserved.
//

#import "QQDemo2VCViewModel.h"
#import "HDCollectionView.h"
#import "QQDemoFriendCellVM.h"
#import "QQDemo2FriendVC.h"
#import "QQDemoOpenCloseSec.h"

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

#pragma mark - QQDemo2FriendVC
- (NSMutableArray*)QQDemo2FriendVCSecArr
{
    NSArray *groupName = @[@"默认",@"大学",@"中学",@"小学"];
    NSMutableArray *result = @[].mutableCopy;
    [groupName enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        [result addObject:[self oneGroupSec:obj]];
    }];
    _QQDemo2FriendVCSecArr = result;
    
    return _QQDemo2FriendVCSecArr;
}
- (HDSectionModel*)oneGroupSec:(NSString *)groupName
{
    //该段cell数据源
    NSMutableArray *cellModelArr = @[].mutableCopy;
    NSInteger cellCount = 20;
    for (int i =0; i<cellCount; i++) {
        QQDemoFriendCellVM *model = [QQDemoFriendCellVM new];
        model.orgData      = nil;
        model.vmTitle      = [self randomAttStr:17 textColor:[UIColor blackColor]];
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

- (NSMutableAttributedString*)randomAttStr:(CGFloat)fontSize textColor:(UIColor*)color
{
    
    NSString *source = @"美国、中国、安圭拉岛、安提瓜和巴布达岛、阿根廷、澳洲、奥地利、阿塞拜疆、比利时、巴西、英属维京群岛、保加利亚、布隆迪、加拿大、乍得、智利、哥伦比亚、哥斯达黎加、科特迪瓦、古巴、刚果民主共和国、丹麦、吉布提、多米尼加共和国、厄瓜多尔、萨尔瓦多、密克罗尼西亚联邦、斐济、芬兰、法国、冈比亚、格鲁吉亚、德国、西班牙、直布罗陀、希腊、格陵兰、英属格恩西、洪都拉斯、中国香港、匈牙利、印度、爱尔兰、英属马恩岛、以色列、意大利、牙买加、日本、英属泽西岛、哈萨克斯坦、韩国、拉脱维亚、莱索托、列支敦士登、立陶宛、卢森堡、马拉维、马来西亚、马耳他、毛里求斯、墨西哥、英属蒙特塞拉特岛、纳米比亚、尼泊尔、荷兰、新西兰、尼加拉瓜、诺福克岛、巴基斯坦、巴拿马、巴拉圭、秘鲁、菲律宾、英属皮特克恩岛、波兰、葡萄牙、波多黎各、刚果共和国、罗马尼亚、俄罗斯、卢旺达、圣赫勒拿岛、圣马力诺、新加坡、斯洛伐克、南非、西班牙、瑞典、瑞士、中国台湾、泰国、特立尼达和多巴哥、土耳其、乌克兰、阿拉伯联合酋长国、英国、乌拉圭、乌兹别克斯坦、新赫布里底群岛、委内瑞拉、越南、朝鲜、伊拉、东萨摩亚";
    NSArray *tempArr = [source componentsSeparatedByString:@"、"];
    NSString *randomStr = tempArr[arc4random()%tempArr.count];
    
    NSMutableAttributedString *result = [[NSMutableAttributedString alloc] initWithString:randomStr];
    [result addAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:fontSize],NSForegroundColorAttributeName:color} range:NSMakeRange(0, result.length)];
    return result;
}
@end
