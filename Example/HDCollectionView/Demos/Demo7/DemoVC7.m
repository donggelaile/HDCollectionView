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
#import "Masonry.h"

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
        .hd_scrollDirection(UICollectionViewScrollDirectionVertical);
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
    
    __weak typeof(listV) weakListV = listV;
    [listV hd_dataChangeFinishedCallBack:^(HDDataChangeType changeType) {
//        [weakListV hd_reloadData];
        [weakListV.collectionV.mj_footer endRefreshing];
    }];
    
//    __weak typeof(self) weakS = self;
    [listV hd_setAllEventCallBack:^(id backModel, HDCallBackType type) {
        
    }];
    listV.collectionV.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(loadRandomSec)];
    [listV.collectionV.mj_footer beginRefreshing];

}
- (void)loadRandomSec
{
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        if (![self->listV hd_sectionModelExist:@"0"]) {
            HDSectionModel* sec = [self makeWaterSecModel];
            [self->listV hd_appendDataWithSecModel:sec animated:YES];
        }else{
            [self->listV hd_appendDataWithCellModelArr:[self waterCellModelArr] sectionKey:@"0" animated:YES];
        }
        
    });
}

- (NSMutableArray*)waterCellModelArr
{
    //该段cell数据源
    NSMutableArray *cellModelArr = @[].mutableCopy;
    NSInteger cellCount = 14;
    for (int i =0; i<cellCount; i++) {
        HDCellModel *model = [HDCellModel new];
        model.orgData      = [NSString stringWithFormat:@"%@",@(i+1)];
        model.cellSize     = CGSizeMake(0, arc4random()%100+50);
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
    layout.columnRatioArr = @[@1,@1,@1,@1];
    
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

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
