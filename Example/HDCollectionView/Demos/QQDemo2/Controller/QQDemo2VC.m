//
//  QQDemo2VC.m
//  HDCollectionView_Example
//
//  Created by HaoDong chen on 2019/5/20.
//  Copyright © 2019 donggelaile. All rights reserved.
//

#import "QQDemo2VC.h"
#import "Masonry.h"
#import "UIView+HDSafeArea.h"
@interface QQDemo2VC ()
@end

@implementation QQDemo2VC
- (QQDemo2VCViewModel *)viewModel
{
    if (!_viewModel) {
        _viewModel = [QQDemo2VCViewModel new];
    }
    return _viewModel;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    
    __hd_WeakSelf
    [self.multipleSc configWithConfiger:^(HDMultipleScrollListConfiger * _Nonnull configer) {
        [weakSelf setWith:configer];
    }];
    [self.multipleSc mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.view.hd_mas_left);
        make.right.mas_equalTo(self.view.hd_mas_right);
        make.bottom.mas_equalTo(self.view.hd_mas_bottom);
        make.top.mas_equalTo(self.view.hd_mas_top);
    }];
    
    UIView *line = [UIView new];
    line.backgroundColor = [UIColor colorWithRed:0.871 green:0.875 blue:0.878 alpha:1.000];
    [self.multipleSc.jxTitle addSubview:line];
    
    [line mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.mas_equalTo(0);
        make.height.mas_equalTo(0.5);
    }];
    
    // Do any additional setup after loading the view.
}
- (void)setWith:(HDMultipleScrollListConfiger*)configer
{
    configer.topSecArr = self.viewModel.topSecArr;
    configer.controllers = self.viewModel.controllers;
    configer.titles = self.viewModel.titles;
    configer.titleContentSize = self.viewModel.titleSize;
//    configer.contentSize = self.viewModel.contentSize;
    configer.isHeaderNeedStop = self.viewModel.headerStop;

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
