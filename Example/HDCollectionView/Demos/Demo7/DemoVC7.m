//
//  DemoVC2.m
//  HDCollectionView
//
//  Created by HaoDong chen on 2018/11/6.
//  Copyright © 2018 CHD. All rights reserved.
//

#import "DemoVC7.h"
#import "HDCollectionView.h"
#import <MJRefresh/MJRefresh.h>
#import "UIView+HDSafeArea.h"

@interface DemoVC7 ()
{
    CGFloat collecitonViewH;
    HDCollectionView *listV;
}
@end

@implementation DemoVC7

- (void)viewDidLoad {
    [super viewDidLoad];
    [self demo];

    // Do any additional setup after loading the view.
}
- (void)change
{
    
}
- (void)demo
{
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.view.backgroundColor = [UIColor whiteColor];

    listV = [HDCollectionView hd_makeHDCollectionView:^(HDCollectionViewMaker *maker) {
        maker
        .hd_isNeedTopStop(YES)
        .hd_isCalculateCellHOnCommonModes(YES)
        .hd_scrollDirection(UICollectionViewScrollDirectionVertical);
    }];
    [self.view addSubview:listV];
    
    [listV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.view.hd_mas_left);
        make.right.mas_equalTo(self.view.hd_mas_right);
        make.bottom.mas_equalTo(self.view.hd_mas_bottom);
        make.top.mas_equalTo(self.view.hd_mas_top);
    }];
    
    __weak typeof(listV) weakListV = listV;
    [listV hd_dataChangeFinishedCallBack:^(HDDataChangeType changeType) {
        [weakListV hd_reloadData];
        [weakListV.collectionV.mj_footer endRefreshing];
    }];
    
    __weak typeof(self) weakS = self;
    [listV hd_setAllEventCallBack:^(id backModel, HDCallBackType type) {
        
    }];
    listV.collectionV.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(loadRandomSec)];
    [listV.collectionV.mj_footer beginRefreshing];

}
- (void)loadRandomSec
{
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        if (![self->listV hd_sectionModelExist:@"0"]) {
            NSInteger randomSec = 1;
            HDSectionModel *sec;
            switch (randomSec) {
                case 0:
                    sec = [self makeNormalSec];
                    break;
                case 1:
                    sec = [self makeWaterSecModel];
                    break;
                case 2:
                    sec = [self makeBQY];
                    break;
                    
                default:
                    break;
            }
            [self->listV hd_appendDataWithSecModel:sec];
        }else{
            [self->listV hd_appendDataWithCellModelArr:[self waterCellModelArr] sectionKey:@"0"];
        }
    });
}
- (HDSectionModel*)makeBQY
{
    //标签云
    //该段cell数据源
    NSMutableArray *cellModelArr = @[].mutableCopy;
    NSInteger cellCount = 45;
    for (int i =0; i<cellCount; i++) {
        HDCellModel *model = [HDCellModel new];
        model.orgData      = [NSString stringWithFormat:@"%@、%@",@(i+1),[self randomStr]];
        model.cellSize     = CGSizeMake(self.view.frame.size.width/2, 50);
        model.cellClassStr = nil;
        [cellModelArr addObject:model];
    }
    
    //该段layout
    HDYogaFlowLayout *layout = [HDYogaFlowLayout new];//isUseSystemFlowLayout为YES时只支持HDBaseLayout
    layout.secInset      = UIEdgeInsetsMake(0, 10, 10, 10);
    layout.justify       = arc4random()%YGJustifyCount;
    layout.verticalGap   = 10;
    layout.horizontalGap = 20;
    layout.headerSize    = CGSizeZero;
    layout.footerSize    = CGSizeZero;
    
    //该段的所有数据封装
    HDSectionModel *secModel = [HDSectionModel new];
    secModel.sectionCellClassStr   = @"VCCell";
    secModel.isNeedAutoCountCellHW  = YES;
    secModel.headerTopStopType     = HDHeaderStopOnTopTypeNone;
    secModel.sectionDataArr        = cellModelArr;
    secModel.layout                = layout;
    
    return secModel;
}
- (NSString*)randomStr
{
    NSString *test = @"所示的 iPhone XR 64GB 机型价格是使用 iPhone 7 Plus 32GB 机型进行折抵换购的价格。上述所示机型的分期付款金额是在使用 iPhone 7 Plus 32GB 机型进行折抵后，再以招商银行、中国工商银行或花呗 24 期免息分期付款方式估算得出的整数金额 (未显示小数点以后的金额)，实际支付金额以银行或花呗账单为准。本优惠活动暂定截止日期为 2019 年 4 月 30 日，可能视情况延长。折抵金额仅可在限定时间内使用，并且要求用于购买新 iPhone，以限制条款为准。实际折抵金额取决于设备的状况、配置、制造年份，以及发售国家或地区。银行或花呗可能要求你的可用信用额度大于所购买产品的总金额，才能使用分期付款服务。有关信用卡或花呗分期服务的申请及使用问题，请与银行或花呗联系，Apple 对此不做任何承诺和保证。Apple 的折抵换购活动为 Apple 与 Apple 折抵服务合作伙伴共同推出，年满 18 周岁及以上者才能享受此项折抵换购服务。店内折抵换购需出示政府颁发并附有照片的有效身份证";
    NSInteger start = arc4random()%test.length;
    NSInteger length = arc4random()%(test.length-start)%5;
    if (length == 0) {
        length = 1;
    }
    NSString *subStr = [test substringWithRange:NSMakeRange(start, length)];
    return subStr;
}

- (HDSectionModel*)makeNormalSec
{
    //该段cell数据源
    NSMutableArray *cellModelArr = @[].mutableCopy;
    NSInteger cellCount = 35;
    for (int i =0; i<cellCount; i++) {
        HDCellModel *model = [HDCellModel new];
        model.orgData      = @(i).stringValue;
        model.cellSize     = CGSizeMake(100, 50);
        model.cellClassStr = @"DemoVC7Cell";
        [cellModelArr addObject:model];
    }
    //该段layout
    HDYogaFlowLayout *layout = [HDYogaFlowLayout new];//isUseSystemFlowLayout为YES时只支持HDBaseLayout
    layout.secInset      = UIEdgeInsetsMake(10, 10, 10, 10);
    layout.justify       = arc4random()%YGJustifyCount;
    layout.verticalGap   = 10;
    layout.horizontalGap = 10;
    layout.headerSize    = CGSizeMake(self.view.frame.size.width, 50);
    layout.footerSize    = CGSizeMake(self.view.frame.size.width, 50);
    
    //该段的所有数据封装
    HDSectionModel *secModel = [HDSectionModel new];
    secModel.sectionHeaderClassStr = @"DemoVC7Header";
    secModel.sectionFooterClassStr = @"DemoVC7Footer";
    secModel.headerObj             = nil;
    secModel.footerObj             = nil;
    secModel.headerTopStopType     = HDHeaderStopOnTopTypeNone;
    secModel.sectionDataArr        = cellModelArr;
    secModel.layout                = layout;
    
    return secModel;
}

- (NSMutableArray*)waterCellModelArr
{
    //该段cell数据源
    NSMutableArray *cellModelArr = @[].mutableCopy;
    NSInteger cellCount = 14;
    for (int i =0; i<cellCount; i++) {
        HDCellModel *model = [HDCellModel new];
        model.orgData      = [NSString stringWithFormat:@"%@",@(i+1)];
        model.cellSize     = CGSizeMake(100, arc4random()%100+50);
        model.cellClassStr = @"DemoVC7Cell";
        //        model.whRatio = ((arc4random() & 1024)+50)/1024.0f+1;
        [cellModelArr addObject:model];
    }
    return cellModelArr;
}
- (HDSectionModel*)makeWaterSecModel
{

    NSMutableArray *cellModelArr = [self waterCellModelArr];
    //该段layout
    HDWaterFlowLayout *layout = [HDWaterFlowLayout new];//isUseSystemFlowLayout为YES时只支持HDBaseLayout
    layout.secInset      = UIEdgeInsetsMake(10, 10, 10, 10);
    layout.verticalGap   = 10;
    layout.horizontalGap = 20;
    layout.headerSize    = CGSizeMake(self.view.frame.size.width, 50);//CGSizeMake(50, collecitonViewH);//CGSizeMake(self.view.frame.size.width, 50)
    layout.footerSize    = CGSizeMake(self.view.frame.size.width, 50);
    layout.columnRatioArr = @[@1,@2,@1,@2];
    
    //该段的所有数据封装
    HDSectionModel *secModel = [HDSectionModel new];
    secModel.sectionHeaderClassStr = @"DemoVC7Header";
//    secModel.sectionFooterClassStr = @"DemoVC7Footer";
    secModel.headerObj             = nil;
    secModel.footerObj             = nil;
    secModel.sectionDataArr        = cellModelArr;
    secModel.layout                = layout;
    secModel.headerTopStopType = arc4random() & 1;
    return secModel;
}

- (void)clickCell:(HDCellModel*)cellM
{
    NSLog(@"点击了%zd--%zd cell",cellM.indexP.section,cellM.indexP.item);
}
- (void)clickHeader:(HDSectionModel*)secM
{
    NSLog(@"点击了段头_%zd",secM.section);
}
- (void)clickFooter:(HDSectionModel*)secM
{
    NSLog(@"点击了段尾_%zd",secM.section);
}
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
