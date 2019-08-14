//
//  QQDemoFriendCellVM.m
//  HDCollectionView_Example
//
//  Created by HaoDong chen on 2019/5/16.
//  Copyright © 2019 donggelaile. All rights reserved.
//

#import "QQDemoFriendCellVM.h"
#import "QQDemoFriendModel.h"
#import <objc/runtime.h>

@implementation QQDemoFriendCellVM
- (instancetype)init
{
    self = [super init];
    if (self) {
        self.cellClassStr = @"QQDemoFriendCell";
    }
    return self;
}
//此处用来 装换原始模型到视图模型
- (void)convertOrgModelToViewModel
{
    [self superDefaultConvertOrgModelToViewModel];
}
@end
