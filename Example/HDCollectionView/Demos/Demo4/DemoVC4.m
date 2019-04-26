 //
//  DemoVC4.m
//  HDCollectionView
//
//  Created by HaoDong chen on 2018/11/6.
//  Copyright © 2018 CHD. All rights reserved.
//

#import "DemoVC4.h"
#import "HDCollectionView.h"
#import "newsRootModel.h"
#import "YYModel.h"
#import "MJRefresh.h"
@interface DemoVC4 ()
{
    HDCollectionView*hdListV;
}
@end

@implementation DemoVC4

- (void)viewDidLoad {
    [super viewDidLoad];
    [self demo];
    // Do any additional setup after loading the view.
}
- (void)demo
{
    self.view.backgroundColor = [UIColor whiteColor];
    HDCollectionView *listV = [HDCollectionView hd_makeHDCollectionView:^(HDCollectionViewMaker *maker) {
        maker.hd_frame(CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height));
        maker.hd_isCalculateCellHOnCommonModes(NO);
    }];
    listV.collectionV.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(footerRefreshBegin)];
    [self.view addSubview:listV];
    [listV.collectionV.mj_footer beginRefreshing];
    hdListV = listV;
    
    __weak typeof(self)weakS = self;
    [hdListV hd_dataChangeFinishedCallBack:^(HDDataChangeType changeType) {
        [weakS reloadData];
    }];
    
    
//    [listV hd_setAllEventCallBack:^(HDSectionModel *secModel, HDCellModel *cellModel, HDCallBackType type) {
//        if (type == HDCellCallBack) {
//            [weakS clickCell:cellModel];
//        }else if (type == HDSectionHeaderCallBack){
//            [weakS clickHeader:secModel];
//        }
//    }];

    
}
- (HDSectionModel*)makeSecModel
{
    NSString *path = [[NSBundle mainBundle] pathForResource:@"news" ofType:@"geojson"];

    newsRootModel *rootM = [newsRootModel yy_modelWithJSON:[NSData dataWithContentsOfFile:path]];

    //该段cell数据源
    NSMutableArray *cellModelArr = @[].mutableCopy;
    NSInteger cellCount = rootM.tid.count;
    for (int i =0; i<cellCount; i++) {
        HDCellModel *model = [HDCellModel new];
        model.orgData      = rootM.tid[i];
        model.cellSize     = CGSizeMake(self.view.frame.size.width, 0);
        model.cellClassStr = @"NormalNewsCell";
        [cellModelArr addObject:model];
    }
    
    //该段layout
    HDYogaFlowLayout *layout = [HDYogaFlowLayout new];//isUseSystemFlowLayout为YES时只支持HDBaseLayout
    layout.secInset      = UIEdgeInsetsMake(0, 0, 0, 0);
    layout.justify       = YGJustifyFlexStart;
    layout.verticalGap   = 0;
    layout.horizontalGap = 0;
    layout.headerSize    = CGSizeMake(0, 0);
    layout.footerSize    = CGSizeMake(0, 0);
    
    //该段的所有数据封装
    HDSectionModel *secModel = [HDSectionModel new];
    secModel.isNeedAutoCountCellHW = YES;
    secModel.isNeedCacheSubviewsFrame = YES;
    secModel.headerTopStopType     = HDHeaderStopOnTopTypeNone;
    secModel.sectionDataArr        = cellModelArr;
    secModel.layout                = layout;
    return secModel;
}
- (void)footerRefreshBegin
{
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self->hdListV hd_appendDataWithSecModel:[self makeSecModel]];
    });
}
- (void)reloadData
{
    [self->hdListV hd_reloadData];
    [self->hdListV.collectionV.mj_footer endRefreshing];
}
- (void)clickCell:(HDCellModel*)cellM
{
    NSLog(@"点击了%zd--%zd cell",cellM.indexP.section,cellM.indexP.item);
}
- (void)clickHeader:(HDSectionModel*)secM
{
    NSLog(@"点击了段头");
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
