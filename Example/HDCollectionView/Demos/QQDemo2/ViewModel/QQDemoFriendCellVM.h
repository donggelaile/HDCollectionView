//
//  QQDemoFriendCellVM.h
//  HDCollectionView_Example
//
//  Created by HaoDong chen on 2019/5/16.
//  Copyright © 2019 donggelaile. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HDCellModel.h"
#import "QQDemoFriendModel.h"
NS_ASSUME_NONNULL_BEGIN

@protocol QQDemoFriendCellVMProtocol <NSObject>
@required
- (NSAttributedString*)vmTitle;
- (NSURL*)vmHeadUrl;
@optional
- (NSAttributedString*)vmOnlineState;
@end
//实际中可以先做一个基类YourCellModel并继承HDCellModel,然后让QQDemoFriendCellVM继承YourCellModel。方便后期统一定制你的cellModel，而无需改动HDCellModel
//也可以让你的model实现HDCellModelProtocol，但是目前大多数方法都是required。后期可能会分离出一些optional方法
@interface QQDemoFriendCellVM : HDCellModel
@property (nonatomic, strong) NSURL *vmHeadUrl;
@property (nonatomic, strong) NSAttributedString *vmTitle;
@property (nonatomic, strong) NSAttributedString *vmOnlineState;
@end

NS_ASSUME_NONNULL_END
