//
//  DemoVC2.m
//  HDCollectionView
//
//  Created by HaoDong chen on 2018/11/6.
//  Copyright © 2018 CHD. All rights reserved.
//

#import "DemoVC5.h"
#import "HDCollectionView.h"
#import "Masonry.h"

@interface DemoVC5 ()
{
    CGFloat collecitonViewH;
    HDCollectionView *listV;
}
@end

@implementation DemoVC5

- (void)viewDidLoad {
    [super viewDidLoad];
    [self demo];
    // Do any additional setup after loading the view.
}
- (void)demo
{
//    self.navigationController.navigationBarHidden = YES;
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.view.backgroundColor = [UIColor whiteColor];

    collecitonViewH = 350;
    listV = [HDCollectionView hd_makeHDCollectionView:^(HDCollectionViewMaker *maker) {
        maker
        .hd_isNeedTopStop(YES)
        .hd_isUseSystemFlowLayout(NO)
        .hd_scrollDirection(UICollectionViewScrollDirectionHorizontal);
    }];
    [self.view addSubview:listV];
    
    if (@available(iOS 11.0, *)) {
        [listV mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(self.view.mas_safeAreaLayoutGuideLeft);
            make.right.mas_equalTo(self.view.mas_safeAreaLayoutGuideRight);
            make.height.mas_equalTo(collecitonViewH);
            make.top.mas_equalTo(self.view.mas_safeAreaLayoutGuideTop);
        }];
        listV.collectionV.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
    }else{
        [listV mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(0);
            make.right.mas_equalTo(0);
            make.height.mas_equalTo(collecitonViewH);
            make.top.mas_equalTo(64);
        }];
        self.automaticallyAdjustsScrollViewInsets = NO;
    }
    
    NSMutableArray *randomArr = @[].mutableCopy;
    for (int i=0; i<10; i++) {
        HDSectionModel *sec;
        if (arc4random()%2) {
            sec = [self makeSecModel];
        }else{
            sec = [self makeWaterSecModel];
        }
        [randomArr addObject:sec];
    }    
    
    [listV hd_setAllDataArr:randomArr];
    
//    __weak typeof(self) weakS = self;
    [listV hd_setAllEventCallBack:^(id backModel, HDCallBackType type) {

    }];

}
- (HDSectionModel*)makeSecModel
{
    //该段cell数据源
    NSMutableArray *cellModelArr = @[].mutableCopy;
    NSInteger cellCount = 9;
    CGFloat secInset = 15;
    CGFloat vhGap = 10;
    NSInteger rowsCount = 3;
    
    for (int i =0; i<cellCount; i++) {
        HDCellModel *model = [HDCellModel new];
        model.orgData      = [NSString stringWithFormat:@"%@",@(i+1)];
        model.cellSize     = CGSizeMake(100, (collecitonViewH-secInset*2-vhGap*(rowsCount-1))/rowsCount);
        model.cellClassStr = @"DemoVC5Cell";
        [cellModelArr addObject:model];
    }
    
    //该段layout
    HDYogaFlowLayout *layout = [HDYogaFlowLayout new];//isUseSystemFlowLayout为YES时只支持HDBaseLayout
    layout.secInset      = UIEdgeInsetsMake(secInset, secInset, secInset, secInset);
    layout.justify       = YGJustifyFlexStart;
    layout.verticalGap   = vhGap;
    layout.horizontalGap = vhGap;
    layout.headerSize    = CGSizeMake(50, collecitonViewH);
    layout.footerSize    = CGSizeMake(50, collecitonViewH);
    layout.decorationMargin = UIEdgeInsetsMake(10, 10, 10, 10);
    
    //该段的所有数据封装
    HDSectionModel *secModel = [HDSectionModel new];
    secModel.sectionHeaderClassStr = @"DemoVC5Header";
    secModel.sectionFooterClassStr = @"DemoVC5Footer";
    secModel.decorationClassStr    = @"DemoVC5DecorationView";
    secModel.headerObj             = nil;
    secModel.footerObj             = nil;
    secModel.headerTopStopType     = HDHeaderStopOnTopTypeNone;
    secModel.sectionDataArr        = cellModelArr;
    secModel.layout                = layout;
    
    return secModel;
}

- (HDSectionModel*)makeWaterSecModel
{
    //该段cell数据源
    NSMutableArray *cellModelArr = @[].mutableCopy;
    NSInteger cellCount = 20;
    for (int i =0; i<cellCount; i++) {
        HDCellModel *model = [HDCellModel new];
        model.orgData      = [NSString stringWithFormat:@"%@",@(i+1)];
        model.cellSize     = CGSizeMake(arc4random()%200 + 100, 0);
        model.cellClassStr = @"DemoVC5Cell";
        //        model.whRatio = ((arc4random() & 1024)+50)/1024.0f+1;
        [cellModelArr addObject:model];
    }
    
    //该段layout
    HDWaterFlowLayout *layout = [HDWaterFlowLayout new];//isUseSystemFlowLayout为YES时只支持HDBaseLayout
    layout.secInset      = UIEdgeInsetsMake(30, 30, 30, 30);
    layout.verticalGap   = 10;
    layout.horizontalGap = 10;
    layout.headerSize    = CGSizeMake(40, collecitonViewH);
    layout.footerSize    = CGSizeMake(40, collecitonViewH);
    layout.columnRatioArr = @[@1,@1,@1,@1];
    layout.decorationMargin = UIEdgeInsetsMake(10, 10, 10, 10);
    layout.isFirstAddAtRightOrBottom = arc4random()%2;
    
    //该段的所有数据封装
    HDSectionModel *secModel = [HDSectionModel new];
    secModel.sectionHeaderClassStr = @"DemoVC5Header";
    secModel.sectionFooterClassStr = @"DemoVC5Footer";
    secModel.headerObj             = nil;
    secModel.footerObj             = nil;
    secModel.headerTopStopType     = HDHeaderStopOnTopTypeNormal;
    secModel.sectionDataArr        = cellModelArr;
    secModel.layout                = layout;
    secModel.decorationClassStr    = @"DemoVC5DecorationView";
    secModel.decorationObj = [UIColor colorWithRed:(arc4random()%255)/255.0 green:(arc4random()%255)/255.0 blue:(arc4random()%255)/255.0 alpha:1];
    
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
