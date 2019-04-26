//
//  DemoVC2.m
//  HDCollectionView
//
//  Created by HaoDong chen on 2018/11/6.
//  Copyright © 2018 CHD. All rights reserved.
//

#import "DemoVC2.h"
#import "HDCollectionView.h"
#import "Masonry.h"
#import "UIView+HDSafeArea.h"
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
    
    [listV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.view.hd_mas_left);
        make.right.mas_equalTo(self.view.hd_mas_right);
        make.bottom.mas_equalTo(self.view.hd_mas_bottom);
        make.top.mas_equalTo(self.view.hd_mas_top);
    }];
    
    
    NSMutableArray *randomArr = @[].mutableCopy;
    for (int i=0; i<3; i++) {
        HDSectionModel *sec = [self makeSecModel];
        sec.headerTopStopType = HDHeaderStopOnTopTypeNormal;
        [randomArr addObject:sec];
    }    
    
    [listV hd_setAllDataArr:randomArr];
    
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
- (HDSectionModel*)makeSecModel
{
    CGFloat minItemCap = 15;
    NSInteger columnCount = arc4random()%3+3;
    NSInteger leftRightCap = arc4random()%70+10;
    UIEdgeInsets secInsect = UIEdgeInsetsMake(20, leftRightCap, 10, leftRightCap);
    
    //该段cell数据源
    NSMutableArray *cellModelArr = @[].mutableCopy;
    NSInteger cellCount = 50;
    for (int i =0; i<cellCount; i++) {
        HDCellModel *model = [HDCellModel new];
        model.orgData      = [NSString stringWithFormat:@"%@",@(i+1)];
        model.cellSize     = CGSizeMake((self.view.frame.size.width-secInsect.left-secInsect.right-(columnCount-1)*minItemCap)/columnCount, 150);
        model.cellClassStr = @"DemoVC2Cell";
        [cellModelArr addObject:model];
    }
    
    //该段layout
    HDYogaFlowLayout *layout = [HDYogaFlowLayout new];
    layout.secInset = UIEdgeInsetsMake(10, 10, 10, 10);
    layout.justify = arc4random()%6;
    layout.verticalGap = 10;
    layout.horizontalGap = minItemCap;
    layout.headerSize = CGSizeMake(self.view.frame.size.width, 50);
    layout.footerSize = CGSizeMake(self.view.frame.size.width, 50);
    
    //该段的所有数据封装
    HDSectionModel *secModel = [HDSectionModel new];
    secModel.sectionHeaderClassStr = @"DemoVC2Header";
    secModel.sectionFooterClassStr = @"DemoVC2Footer";
    secModel.headerObj             = nil;
    secModel.footerObj             = nil;
    secModel.headerTopStopType     = HDHeaderStopOnTopTypeNone;
    secModel.sectionDataArr        = cellModelArr;
    secModel.layout                = layout;
    secModel.layout = layout;
    
    return secModel;
    

}
- (void)clickCell:(HDCellModel*)cellM
{
    NSLog(@"点击了%zd--%zd cell",cellM.indexP.section,cellM.indexP.item);
    [listV hd_changeSectionModelWithKey:@(cellM.indexP.section).stringValue changingIn:^(HDSectionModel *secModel) {
        [secModel.sectionDataArr removeLastObject];
    }];
}
- (void)clickHeader:(HDSectionModel*)secM
{
    [listV hd_deleteSectionWithKey:secM.sectionKey];
    NSLog(@"点击了段头_%zd",secM.section);
}
- (void)clickFooter:(HDSectionModel*)secM
{
    NSLog(@"点击了段尾_%zd",secM.section);
    [listV hd_appendDataWithSecModel:[self makeSecModel]];
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
