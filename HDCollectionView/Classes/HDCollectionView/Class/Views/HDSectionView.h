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
@property (nonatomic, weak, readonly) HDCollectionView *superCollectionV;
@property (nonatomic, copy, readonly) void(^callback)(id par);
@property (nonatomic, strong, readonly) __kindof id<HDSectionModelProtocol> hdSecModel;
@property (nonatomic, strong, readonly) NSString *currentElementKind;
@end
