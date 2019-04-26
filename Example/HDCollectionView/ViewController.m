//
//  ViewController.m
//  HDCollectionView
//
//  Created by HaoDong chen on 2018/11/5.
//  Copyright © 2018年 CHD. All rights reserved.
//

#import "ViewController.h"
#import "HDCollectionView.h"
#import "Masonry.h"
#import "UIView+HDSafeArea.h"

@interface ViewController ()
{
    HDCollectionView *listV;
}
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    [self simpleDemo];
}

- (void)simpleDemo
{
    self.view.backgroundColor = [UIColor whiteColor];
    
    listV = [HDCollectionView hd_makeHDCollectionView:^(HDCollectionViewMaker *maker) {
        maker
        .hd_isUseSystemFlowLayout(NO)
        .hd_isCalculateCellHOnCommonModes(YES)
        .hd_isNeedAdaptScreenRotaion(YES);
    }];
    [self.view addSubview:listV];
    
    [listV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.view.hd_mas_left);
        make.right.mas_equalTo(self.view.hd_mas_right);
        make.bottom.mas_equalTo(self.view.hd_mas_bottom);
        make.top.mas_equalTo(self.view.hd_mas_top);
    }];
    
    NSMutableArray *secArr = @[].mutableCopy;
    for (int i=0; i<1; i++) {
        HDSectionModel *sec1 = [self makeSecModel];
        [secArr addObject:sec1];
    }
    
    [listV hd_setAllDataArr:secArr];
    
    __weak typeof(self) weakS = self;

    [listV hd_setAllEventCallBack:^(id backModel, HDCallBackType type) {
        [weakS dealCellCallback:backModel];
    }];

    [self.view sendSubviewToBack:listV];
}
- (HDSectionModel*)makeSecModel
{
    //该段cell数据源
    NSMutableArray *cellModelArr = @[].mutableCopy;
    NSInteger cellCount = 13;
    for (int i =0; i<cellCount; i++) {
        HDCellModel *model = [HDCellModel new];
        model.orgData      = [NSString stringWithFormat:@"%@、%@",@(i+1),[self randomStr]];
        model.cellSize     = CGSizeMake(self.view.frame.size.width/2, 50);
        model.cellClassStr = nil;
        [cellModelArr addObject:model];
    }
    
    //该段layout
    HDYogaFlowLayout *layout = [HDYogaFlowLayout new];//isUseSystemFlowLayout为YES时只支持HDBaseLayout
    layout.secInset      = UIEdgeInsetsMake(30, 10, 30, 10);
    layout.justify       = YGJustifyFlexStart;
    layout.verticalGap   = 10;
    layout.horizontalGap = 20;
    layout.headerSize    = CGSizeZero;
    layout.footerSize    = CGSizeZero;
    
    //该段的所有数据封装
    HDSectionModel *secModel = [HDSectionModel new];
    secModel.sectionCellClassStr   = @"VCCell";
    secModel.isNeedAutoCountCellHW  = YES;
    secModel.isForceUseHdSizeThatFits = YES;
    secModel.headerTopStopType     = HDHeaderStopOnTopTypeNone;
    secModel.sectionDataArr        = cellModelArr;
    secModel.layout                = layout;
    
    return secModel;
}
- (NSString*)randomStr
{
    return @"固定长度";
    NSString *test = @"所示的 iPhone XR 64GB 机型价格是使用 iPhone 7 Plus 32GB 机型进行折抵换购的价格。上述所示机型的分期付款金额是在使用 iPhone 7 Plus 32GB 机型进行折抵后，再以招商银行、中国工商银行或花呗 24 期免息分期付款方式估算得出的整数金额 (未显示小数点以后的金额)，实际支付金额以银行或花呗账单为准。本优惠活动暂定截止日期为 2019 年 4 月 30 日，可能视情况延长。折抵金额仅可在限定时间内使用，并且要求用于购买新 iPhone，以限制条款为准。实际折抵金额取决于设备的状况、配置、制造年份，以及发售国家或地区。银行或花呗可能要求你的可用信用额度大于所购买产品的总金额，才能使用分期付款服务。有关信用卡或花呗分期服务的申请及使用问题，请与银行或花呗联系，Apple 对此不做任何承诺和保证。Apple 的折抵换购活动为 Apple 与 Apple 折抵服务合作伙伴共同推出，年满 18 周岁及以上者才能享受此项折抵换购服务。店内折抵换购需出示政府颁发并附有照片的有效身份证";
    NSInteger start = arc4random()%test.length;
    NSInteger length = arc4random()%(test.length-start)%5;
    if (length == 0) {
        length = 1;
    }
    NSString *subStr = [test substringWithRange:NSMakeRange(start, length)];
    return subStr;
}
- (void)dealCellCallback:(HDCellModel*)sec
{
    NSMutableArray *vcNameArr = @[].mutableCopy;
    for (int i=1; i<8; i++) {
        [vcNameArr addObject:[NSString stringWithFormat:@"DemoVC%@",@(i)]];
    }
    [vcNameArr addObject:@"AutoHomeCarInfoVC"];
    UIViewController *demoVC = [NSClassFromString(vcNameArr[sec.indexP.item%vcNameArr.count]) new];
    if (demoVC) {
        [self.navigationController pushViewController:demoVC animated:YES];
    }
}
@end
