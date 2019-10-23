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
        .hd_isNeedAdaptScreenRotaion(YES);
    }];
    [self.view addSubview:listV];
    
    if (@available(iOS 11.0, *)) {
        [listV mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(self.view.mas_safeAreaLayoutGuideLeft);
            make.right.mas_equalTo(self.view.mas_safeAreaLayoutGuideRight);
            make.bottom.mas_equalTo(self.view.mas_safeAreaLayoutGuideBottom);
            make.top.mas_equalTo(self.view.mas_safeAreaLayoutGuideTop);
        }];
        listV.collectionV.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
    }else{
        [listV mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(0);
            make.right.mas_equalTo(0);
            make.bottom.mas_equalTo(0);
            make.top.mas_equalTo(64);
        }];
        self.automaticallyAdjustsScrollViewInsets = NO;
    }
    
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
    NSArray *demoName = @[@"简单使用",@"多段随机悬浮/对齐",@"自动算高/上拉加载/横竖屏支持",@"纵向夹杂横向",@"横向滑动/悬浮",@"瀑布流/装饰view",@"瀑布流加载更多",@"汽车之家demo",@"QQ联系人demo",@"多scrollview混合滑动"];
    //该段cell数据源
    NSMutableArray *cellModelArr = @[].mutableCopy;
    NSInteger cellCount = demoName.count;
    for (int i =0; i<cellCount; i++) {
        HDCellModel *model = [HDCellModel new];
        model.orgData      = [NSString stringWithFormat:@"%@、%@",@(i+1),demoName[i%demoName.count]];
        model.cellSize     = CGSizeMake(self.view.frame.size.width/2, 50);
        model.cellClassStr = nil;
        [cellModelArr addObject:model];
    }
    
    //该段layout
    HDYogaFlowLayout *layout = [HDYogaFlowLayout new];//isUseSystemFlowLayout为YES时只支持HDBaseLayout
    layout.secInset      = UIEdgeInsetsMake(30, 10, 30, 10);
    layout.justify       = YGJustifySpaceBetween;
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

- (void)dealCellCallback:(HDCellModel*)sec
{
    NSMutableArray *vcNameArr = @[].mutableCopy;
    for (int i=1; i<8; i++) {
        [vcNameArr addObject:[NSString stringWithFormat:@"DemoVC%@",@(i)]];
    }
    [vcNameArr addObject:@"AutoHomeCarInfoVC"];
    [vcNameArr addObject:@"QQDemo2VC"];
    [vcNameArr addObject:@"NewsDetailDemoVC"];
    UIViewController *demoVC = [NSClassFromString(vcNameArr[sec.indexP.item%vcNameArr.count]) new];
    if (demoVC) {
        [self.navigationController pushViewController:demoVC animated:YES];
    }
}
@end
