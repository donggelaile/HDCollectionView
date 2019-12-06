//
//  DemoVC3.m
//  HDCollectionView
//
//  Created by HaoDong chen on 2018/11/6.
//  Copyright © 2018 CHD. All rights reserved.
//

#import "DemoVC3.h"
#import "HDCollectionView.h"
#import "DemoVC3CellModel.h"
#import <MJRefresh/MJRefresh.h>
#import "Masonry.h"
extern BOOL isDemo3OpenSubviewFrameCache;
@interface DemoVC3 ()
{
    HDCollectionView *listV;
    HDSectionModel *secm;
}
@end

@implementation DemoVC3

- (void)viewDidLoad {
    [super viewDidLoad];
    [self demo];
    // Do any additional setup after loading the view.
}
- (void)demo
{
    self.view.backgroundColor = [UIColor whiteColor];
//    listV = [[HDCollectionView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height) isUseAbsoluteLayout:NO isNeedTopStop:YES];
    listV = [HDCollectionView hd_makeHDCollectionView:^(HDCollectionViewMaker *maker) {
        maker
        .hd_isNeedTopStop(YES)
        .hd_isUseSystemFlowLayout(NO)
        .hd_isNeedAdaptScreenRotaion(YES);
    }];
    listV.collectionV.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(loadData)];
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
    
    [listV.collectionV.mj_footer beginRefreshing];
    
    [listV hd_setAllEventCallBack:^(id backModel, HDCallBackType type) {
        
    }];
}

- (void)loadData
{
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        /*
         可以将 hd_appendDataWithSecModel 放到 NSDefaultRunLoopMode中。因为hd_appendDataWithSecModel中包含该段cell的布局计算,是耗时操作
         此时如果列表在滑动(即在 UITrackingRunLoopMode时), HDDoSomeThingInMode中的代码将暂时不会执行，直至滑动结束
         也就是说，手指一直拖着屏幕不离开。那么就一直不会刷新。
         这么做的原因是: 如果数据回来立即刷新(直接调用append函数)，此时列表正在滑动的话将出现短暂的卡顿
        */
        
        //比如直接这样, 代码默认是在 NSRunLoopCommonModes 中运行
//        [self->listV hd_appendDataWithSecModel:[self makeSecModel] animated:YES];
//        [listV.collectionV.mj_footer endRefreshing];
        
        HDDoSomeThingInMode(NSDefaultRunLoopMode, ^{
            //其实里面的代码最终还是在主线程执行，只是此时已经不再滑动列表了。
            [self->listV hd_appendDataWithSecModel:[self makeSecModel] animated:NO];
            [listV.collectionV.mj_footer endRefreshing];//注意结束刷新也要放到里面
        });
        

    });
}

- (HDSectionModel*)makeSecModel
{
    //该段cell数据源
    NSMutableArray *cellModelArr = @[].mutableCopy;
    NSInteger cellCount = 10;
    for (int i =0; i<cellCount; i++) {
        HDCellModel *model = [HDCellModel new];
        model.orgData      = [DemoVC3CellModel randomModel];
        model.cellClassStr = @"DemoVC3Cell";
        __weak typeof(listV) weakV = listV;
        [model setCellSizeCb:^CGSize{
            //1、此方式跟 model.cellSize = CGSizeMake(self.view.frame.size.width-20, 0); 的区别是 cellSize是只获取一次，内部记录后不再变更。
            //2、而cellSizeCb再次获取时会重新调用 CGSizeMake(weakS.view.frame.size.width-20, 50),此时weakS.view.frame.size.width可能已经改变，比如屏幕发生旋转。
            //3、所以不适配横竖屏建议直接使用model.cellSize即可
            //4、此处必须使用__weak
            //5、自动算高，高设为0。自动算宽，宽设为0 (前提是该cellmodel所在的secModel.isNeedAutoCountCellHW  = YES;)
            return CGSizeMake(weakV.frame.size.width-20, 0);
        }];
        [cellModelArr addObject:model];
    }
    
    //该段layout
    HDYogaFlowLayout *layout = [HDYogaFlowLayout new];//isUseSystemFlowLayout为YES时只支持HDBaseLayout
    layout.secInset      = UIEdgeInsetsMake(0, 10, 0, 10);
    layout.justify       = YGJustifyFlexStart;
    layout.verticalGap   = 0;
    layout.horizontalGap = 0;
    layout.headerSize    = CGSizeMake(0, 0);
    layout.footerSize    = CGSizeMake(0, 0);
    
    //该段的所有数据封装
    HDSectionModel *secModel = [HDSectionModel new];
    secModel.sectionHeaderClassStr = nil;
    secModel.sectionFooterClassStr = nil;
    secModel.headerObj             = nil;
    secModel.footerObj             = nil;
    secModel.headerTopStopType     = HDHeaderStopOnTopTypeNone;
    secModel.sectionDataArr        = cellModelArr;
    secModel.layout                = layout;
    secModel.isNeedAutoCountCellHW  = YES;
    secModel.isNeedCacheSubviewsFrame = isDemoVC3OpenCellSubviewFrameCache;
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
- (void)dealloc
{
    
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
