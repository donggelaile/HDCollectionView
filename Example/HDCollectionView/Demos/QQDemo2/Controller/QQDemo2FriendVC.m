//
//  QQDemo2FriendVC.m
//  HDCollectionView_Example
//
//  Created by HaoDong chen on 2019/5/20.
//  Copyright © 2019 donggelaile. All rights reserved.
//

#import "QQDemo2FriendVC.h"
#import "QQDemo2VC.h"
@interface QQDemo2FriendVC ()
@end

@implementation QQDemo2FriendVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.collectionV.backgroundColor = [UIColor whiteColor];
    QQDemo2VC *mainVC = (QQDemo2VC*)self.parentViewController;
    [self.collectionV hd_setAllDataArr:[mainVC.viewModel QQDemo2FriendVCSecArr]];

}

@end
