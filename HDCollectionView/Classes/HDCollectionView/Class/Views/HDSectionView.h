//
//  HDSectionView.h
//  
//
//  Created by CHD on 2018/8/9.
//  Copyright © 2018年 chd. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HDUpdateUIProtocol.h"

@interface HDSectionView : UICollectionReusableView<HDUpdateUIProtocol>
@property (nonatomic, copy) void(^callback)(id par, HDCallBackType type);
@property (nonatomic, strong) HDSectionModel *hdSecModel;
@end
