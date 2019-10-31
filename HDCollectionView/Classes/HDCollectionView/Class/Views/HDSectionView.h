//
//  HDSectionView.h
//  
//
//  Created by CHD on 2018/8/9.
//  Copyright © 2018年 chd. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HDUpdateUIProtocol.h"
@class HDCollectionView;
@interface HDSectionView : UICollectionReusableView<HDUpdateUIProtocol>
@property (nonatomic, weak, readonly, nullable) HDCollectionView *superCollectionV;
@property (nonatomic, copy, readonly, nonnull) void(^callback)(id _Nullable par);
@property (nonatomic, strong, readonly, nullable) __kindof id<HDSectionModelProtocol> hdSecModel;
@property (nonatomic, strong, readonly, nullable) NSString *currentElementKind;
@end
