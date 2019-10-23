//
//  DemoVC1.m
//  HDCollectionView
//
//  Created by HaoDong chen on 2018/11/6.
//  Copyright © 2018 CHD. All rights reserved.
//

#import "DemoVC1.h"
#import "HDCollectionView.h"
#import "YYFPSLabel.h"
#import "NSArray+HDHelper.h"
//#import "UILabel+HDChainMaker.h"
@interface DemoVC1 ()

@end

@implementation DemoVC1
{
    HDCollectionView *listV;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    [self demo1];
    // Do any additional setup after loading the view.
}
- (void)demo1
{

    self.view.backgroundColor = [UIColor whiteColor];
    listV = [HDCollectionView hd_makeHDCollectionView:^(HDCollectionViewMaker *maker){
        maker.hd_frame(self.view.bounds)
        .hd_isUseSystemFlowLayout(YES);
    }];
    
    [self.view addSubview:listV];
    
    HDSectionModel *sec1 = [self makeSecModel];
    
    [listV hd_setAllDataArr:@[sec1].mutableCopy];
    
    __weak typeof(self) weakS = self;
    [listV hd_setAllEventCallBack:^(id backModel, HDCallBackType type) {
        if (type == HDCellCallBack) {
            [weakS clickCell:backModel];
        }else if (type == HDSectionHeaderCallBack){
            [weakS clickHeader:backModel];
        }
    }];

}
- (HDSectionModel*)makeSecModel
{

    //该段cell数据源
    NSMutableArray *cellModelArr = @[].mutableCopy;
    NSInteger cellCount = 10;
    for (int i =0; i<cellCount; i++) {
        HDCellModel *model = [HDCellModel new];
        model.orgData      = @(i).stringValue;
        model.cellSize     = CGSizeMake(self.view.frame.size.width/2, 50);
        model.cellClassStr = @"DemoVC1Cell";
        [cellModelArr addObject:model];
    }
    
    //该段layout
    HDBaseLayout *layout = [HDBaseLayout new];//isUseSystemFlowLayout为YES时只支持HDBaseLayout
    layout.secInset      = UIEdgeInsetsMake(10, 0, 10, 0);
    layout.verticalGap   = 10;
    layout.horizontalGap = 0;
    layout.headerSize    = CGSizeMake(self.view.frame.size.width, 100);
    layout.footerSize    = CGSizeMake(0, 0);
    
    //该段的所有数据封装
    HDSectionModel *secModel = [HDSectionModel new];
    secModel.sectionHeaderClassStr = @"DemoVC1Header";
    secModel.sectionFooterClassStr = nil;
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
    
    [listV hd_changeSectionModelWithKey:cellM.secModel.sectionKey animated:YES changingIn:^(HDSectionModel *secModel) {
        [secModel.sectionDataArr removeObject:cellM];
//        cellM.cellSize = CGSizeMake(cellM.cellSize.height+5, cellM.cellSize.height+5);
    }];
}
- (void)clickHeader:(HDSectionModel*)secM
{
//    NSLog(@"点击了段头");
    
    [listV hd_changeSectionModelWithKey:secM.sectionKey animated:YES changingIn:^(id<HDSectionModelProtocol> secModel) {
        secM.sectionDataArr = [secM.sectionDataArr shuffle].mutableCopy;
    }];
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
