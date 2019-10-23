 //
//  DemoVC4.m
//  HDCollectionView
//
//  Created by HaoDong chen on 2018/11/6.
//  Copyright © 2018 CHD. All rights reserved.
//

#import "DemoVC4.h"
#import "HDCollectionView.h"
#import "MJRefresh.h"
#import "DemoVC4ViewModel.h"
#import "Masonry.h"

@interface DemoVC4 ()
{
    HDCollectionView*listV;
}
@property (nonatomic, strong) DemoVC4ViewModel *viewModel;
@end

@implementation DemoVC4
- (DemoVC4ViewModel *)viewModel
{
    if (!_viewModel) {
        _viewModel = [DemoVC4ViewModel new];
    }
    return _viewModel;
}
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
    
    [self.viewModel loadData:^(BOOL success, id  _Nonnull res) {
        if (success) {
            [listV hd_setAllDataArr:res];
        }else{
            //error
        }
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
