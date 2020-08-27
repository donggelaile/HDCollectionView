//
//  DemoVC2.m
//  HDCollectionView
//
//  Created by HaoDong chen on 2018/11/6.
//  Copyright © 2018 CHD. All rights reserved.
//

#import "DemoVC2.h"
#import "Masonry.h"
#import <HDCollectionView/HDCollectionView.h>
#import <HDCollectionView/HDCollectionView+HDHelper.h>

@interface DemoVC2 ()
{
    HDCollectionView *listV;
}
@end

@implementation DemoVC2

- (void)viewDidLoad {
    [super viewDidLoad];
    [self demo];
    
    // Do any additional setup after loading the view.
}
- (void)demo
{
    self.view.backgroundColor = [UIColor whiteColor];

    listV = [HDCollectionView hd_makeHDCollectionView:^(HDCollectionViewMaker *maker) {
        maker
        .hd_isNeedTopStop(YES).hd_isUseSystemFlowLayout(NO);
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
    CGFloat scWidth = [UIScreen mainScreen].bounds.size.width;
    //大量数据测试
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        NSMutableArray *randomArr = @[].mutableCopy;
        for (int i=0; i<5000; i++) {
            if (arc4random()%2) {
                HDSectionModel *sec = [self makeCellSizeRandomSecModel:scWidth];
                sec.headerObj = @(i).stringValue;
                sec.footerObj = @(i).stringValue;
                sec.headerTopStopType = arc4random()%2;
                [randomArr addObject:sec];
            }else{
                HDSectionModel *sec = [self makeSecModel:scWidth];
                sec.headerObj = @(i).stringValue;
                sec.footerObj = @(i).stringValue;
                sec.headerTopStopType = arc4random()%2;
                [randomArr addObject:sec];
            }
        }
        dispatch_async(dispatch_get_main_queue(), ^{
                [listV hd_setAllDataArrSlowly:randomArr preloadOffset:3000 currentCalculateSectionFinishCallback:^(NSInteger curSection) {
                        NSLog(@"第%zd段布局计算完毕",curSection);
                }];
            //  [listV hd_setAllDataArr:randomArr];//对比一次计算所有数据
        });
    });
    


        
    __weak typeof(self) weakS = self;
    [listV hd_setAllEventCallBack:^(id backModel, HDCallBackType type) {
        if (type == HDCellCallBack) {
            [weakS clickCell:backModel];
        }else if (type == HDSectionHeaderCallBack){
            [weakS clickHeader:backModel];
        }else if (type == HDSectionFooterCallBack){
            [weakS clickFooter:backModel];
        }
    }];

}
- (HDSectionModel*)makeSecModel:(CGFloat)screenWidth
{
    CGFloat minItemCap = 15;
    NSInteger columnCount = arc4random()%3+3;
    NSInteger leftRightCap = arc4random()%70+10;
    UIEdgeInsets secInsect = UIEdgeInsetsMake(20, leftRightCap, 10, leftRightCap);
    
    //该段cell数据源
    NSMutableArray *cellModelArr = @[].mutableCopy;
    NSInteger cellCount = 30;
    for (int i =0; i<cellCount; i++) {
        HDCellModel *model = [HDCellModel new];
        model.orgData      = [NSString stringWithFormat:@"%@",@(i+1)];
        model.cellSize     = CGSizeMake((screenWidth-secInsect.left-secInsect.right-(columnCount-1)*minItemCap)/columnCount, 20);
        model.cellClassStr = @"DemoVC2Cell";
        [cellModelArr addObject:model];
    }
    
    //该段layout
    HDYogaFlowLayout *layout = [HDYogaFlowLayout new];
    layout.secInset = UIEdgeInsetsMake(10, 10, 10, 10);
    layout.justify = YGJustifySpaceBetween;
    layout.verticalGap = 10;
    layout.horizontalGap = minItemCap;
    layout.headerSize = CGSizeMake(screenWidth, 50);
    layout.footerSize = CGSizeMake(screenWidth, 50);
    
    //该段的所有数据封装
    HDSectionModel *secModel = [HDSectionModel new];
    secModel.sectionHeaderClassStr = @"DemoVC2Header";
    secModel.sectionFooterClassStr = @"DemoVC2Footer";
    secModel.headerObj             = nil;
    secModel.footerObj             = nil;
    secModel.headerTopStopType     = HDHeaderStopOnTopTypeNone;
    secModel.sectionDataArr        = cellModelArr;
    secModel.layout                = layout;
    
    return secModel;
}

- (HDSectionModel*)makeCellSizeRandomSecModel:(CGFloat)scWidth
{
    CGFloat minItemCap = 15;
    
    //该段cell数据源
    NSMutableArray *cellModelArr = @[].mutableCopy;
    NSInteger cellCount = 30;
    for (int i =0; i<cellCount; i++) {
        
        CGFloat randomW = arc4random()%200+40;
        CGFloat cellH = 30;
        
        HDCellModel *model = [HDCellModel new];
        model.orgData      = [NSString stringWithFormat:@"%@",@(i+1)];
        model.cellSize     = CGSizeMake(randomW,cellH);
        model.cellClassStr = @"DemoVC2Cell";
        [cellModelArr addObject:model];
    }
    
    //该段layout
    HDYogaFlowLayout *layout = [HDYogaFlowLayout new];
    layout.secInset = UIEdgeInsetsMake(10, 10, 10, 10);
    layout.justify = arc4random()%6;
    layout.verticalGap = 10;
    layout.horizontalGap = minItemCap;
    layout.headerSize = CGSizeMake(scWidth, 50);
    layout.footerSize = CGSizeMake(scWidth, 50);
    
    //该段的所有数据封装
    HDSectionModel *secModel = [HDSectionModel new];
    secModel.sectionHeaderClassStr = @"DemoVC2Header";
    secModel.sectionFooterClassStr = @"DemoVC2Footer";
    secModel.headerObj             = nil;
    secModel.footerObj             = nil;
    secModel.headerTopStopType     = HDHeaderStopOnTopTypeNone;
    secModel.sectionDataArr        = cellModelArr;
    secModel.layout                = layout;
    
    return secModel;
}
- (void)clickCell:(HDCellModel*)cellM
{
    NSLog(@"点击了%zd--%zd cell",cellM.indexP.section,cellM.indexP.item);
    [listV hd_changeSectionModelWithKey:@(cellM.indexP.section).stringValue animated:YES changingIn:^(HDSectionModel *secModel) {
        [secModel.sectionDataArr removeLastObject];
    }];
}
- (void)clickHeader:(HDSectionModel*)secM
{
    [listV hd_deleteSectionWithKey:secM.sectionKey animated:YES];
//    NSLog(@"点击了段头_%zd",secM.section);
}
- (void)clickFooter:(HDSectionModel*)secM
{
    NSLog(@"点击了段尾_%zd",secM.section);
    CGFloat scWidth = [UIScreen mainScreen].bounds.size.width;
    [listV hd_appendSecSlowly:[self makeSecModel:scWidth]];
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
