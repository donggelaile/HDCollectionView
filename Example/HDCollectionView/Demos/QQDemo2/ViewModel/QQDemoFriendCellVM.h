//
//  QQDemoFriendCellVM.h
//  HDCollectionView_Example
//
//  Created by HaoDong chen on 2019/5/16.
//  Copyright © 2019 donggelaile. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HDCellModel.h"
NS_ASSUME_NONNULL_BEGIN

@interface QQDemoFriendCellVM : HDCellModel
@property (nonatomic, strong) NSString *headUrl;
@property (nonatomic, strong) NSAttributedString *vmTitle;
@property (nonatomic, strong) NSAttributedString *vmOnlineState;
@end

NS_ASSUME_NONNULL_END
