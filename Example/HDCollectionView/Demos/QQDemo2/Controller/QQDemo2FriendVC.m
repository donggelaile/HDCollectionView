//
//  QQDemo2FriendVC.m
//  HDCollectionView_Example
//
//  Created by HaoDong chen on 2019/5/20.
//  Copyright © 2019 donggelaile. All rights reserved.
//

#import "QQDemo2FriendVC.h"

@interface QQDemo2FriendVC ()
@end

@implementation QQDemo2FriendVC
- (QQDemo2FriendVCVM *)viewModel
{
    if (!_viewModel) {
        _viewModel = [QQDemo2FriendVCVM new];
    }
    return _viewModel;
}
//重写父类的配置方法
- (void (^)(HDCollectionViewMaker * _Nonnull))hd_collectionViewConfiger
{
    return ^(HDCollectionViewMaker*maker){
        maker.hd_isNeedTopStop(YES);
    };
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.collectionV.backgroundColor = [UIColor whiteColor];
    [self.collectionV hd_setAllDataArr:[self.viewModel QQDemo2FriendVCSecArr]];

}

@end
