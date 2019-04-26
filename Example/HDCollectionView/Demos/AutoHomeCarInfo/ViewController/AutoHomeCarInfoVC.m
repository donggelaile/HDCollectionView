//
//  DemoVC2.m
//  HDCollectionView
//
//  Created by HaoDong chen on 2018/11/6.
//  Copyright © 2018 CHD. All rights reserved.
//

#import "AutoHomeCarInfoVC.h"
#import "HDCollectionView.h"
#import "AHCVCViewModel.h"
#import "HDDefines.h"
#import "AHCModel.h"
#import "HDSCVOffsetBinder.h"
#import "AHCBaseCollectionView.h"

@interface AutoHomeCarInfoVC ()
{
    CGFloat collecitonViewH;
    HDCollectionView *listV;
}
@property (nonatomic, strong) AHCVCViewModel *viewModel;
@end

@implementation AutoHomeCarInfoVC

-(AHCVCViewModel *)viewModel
{
    if (!_viewModel) {
        _viewModel = [AHCVCViewModel new];
    }
    return _viewModel;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setUI];
    [self loadData];
}

- (void)setUI
{
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.view.backgroundColor = [UIColor whiteColor];

    collecitonViewH = self.view.frame.size.height-64;
    listV = [HDCollectionView hd_makeHDCollectionView:^(HDCollectionViewMaker *maker) {
        maker
        .hd_frame(CGRectMake(0, 64, self.view.frame.size.width, self->collecitonViewH))
        .hd_isNeedTopStop(YES)
        .hd_scrollDirection(UICollectionViewScrollDirectionVertical)
        .hd_isCalculateCellHOnCommonModes(NO);
    }];
    listV.collectionV.showsVerticalScrollIndicator = NO;
    
    [listV hd_setShouldRecognizeSimultaneouslyWithGestureRecognizer:^BOOL(UIGestureRecognizer *selfGestture, UIGestureRecognizer *otherGesture) {
        return NO;
    }];
    [self.view addSubview:listV];
    
    __weak typeof(self) weakS = self;
    [listV hd_setAllEventCallBack:^(id backModel, HDCallBackType type) {
        if (type == HDCellCallBack) {
            [weakS clickCell:backModel];
        }else if (type == HDSectionHeaderCallBack){
            [weakS clickHeader:backModel];
        }
    }];
}
- (void)loadData
{
    __hd_WeakSelf
    [self.viewModel loadData:^(NSMutableArray *secArr, NSError *error) {
        if (!error) {
            [weakSelf updateUI:secArr];
        }else{
            NSLog(@"%@",error);
        }
    }];
}
- (void)updateUI:(NSMutableArray*)secArr
{
    [listV hd_setAllDataArr:secArr];
}
- (void)clickCell:(HDCellModel*)cellM
{
    if ([cellM.context isEqualToString:@"delteBtnClick"]) {
        AHCSpecitems *item = cellM.orgData;
        if ([self.viewModel currentColumn]>2) {
            NSLog(@"删除一列");
            NSMutableArray *newSecArr =  [self.viewModel deleteColumnWithID:item.specid];
            if (newSecArr) {
                [listV hd_setAllDataArr:newSecArr];
            }
        }else{
            NSLog(@"最少得有2列");
        }
    }
}
- (void)clickHeader:(HDSectionModel*)secM
{
    if ([secM.context isEqualToString:@"showOrHideSameLine"]) {
        NSMutableArray *newSecArr = [self.viewModel changeShowSameOrAllState];
        [listV hd_setAllDataArr:newSecArr];
    }
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
