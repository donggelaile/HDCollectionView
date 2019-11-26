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
//此处用来 转换原始模型到视图模型,该操作发生在cell UI更新之前
- (void)convertOrgModelToViewModel
{
    //方式1
    /*
     这种方式需要 QQDemoFriendCellVM 定义一些协议，所有需要适配的原始model去实现这些协议
     这样做 QQDemoFriendCellVM 的实现不会变大，因为这些转换逻辑都放到了各个原始model中，有点像胖model
     */
    [self superDefaultConvertOrgModelToViewModel];
    
    //方式2
    /*
     如果要适配的服务器原始model不是很多，可以直接在这里写转换代码
     这样做不需要 QQDemoFriendCellVM 定义协议，直接在这里转换就行。原始数据model除了定义属性几乎没别的代码，是瘦model
     但是随着需要适配原始model类型的增多，QQDemoFriendCellVM中的代码会越来越多
     一般情况下，个人建议5个原始模型类型以下用这种模式。5个以上用协议模式，将代码分散到各个model中
     */
    /*
    //伪代码示例
     if([self.orgData isKindOfClass:A.class]){
        [self convert_A];
     }else if([self.orgData isKindOfClass:B.class]){
        [self convert_B];
     }
        
     */
}
/*
 - (void)convert_A
 {
    A *obj = self.orgData;
    self.vmHeadUrl = [NSURL URLWithSting:obj.url];
    self.vmTitle = ...
    ...
 }
 - (void)convert_B
 {
    B *obj = self.orgDta;
    self.vmHeadUrl = [NSURL URLWithSting:B.headurl];
    self.vmTitle = ...
    ...
 }
 */
@end
