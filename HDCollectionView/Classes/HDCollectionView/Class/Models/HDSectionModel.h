//
//  HDSectionModel.h
//  HDCollectionView
//
//  Created by HaoDong chen on 2018/11/5.
//  Copyright © 2018年 CHD. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "HDModelProtocol.h"
static NSInteger HDHeaderViewDefaultZindex     = -1000000;
static NSInteger HDFooterViewDefaultZindex     = -1100000;
static NSInteger HDCellDefaultZindex           = -1200000;
static NSInteger HDDecorationViewDefaultZindex = -1500000;

static NSString * _Nonnull HDDecorationViewKind = @"HDDecorationViewKind";

@interface HDSectionModel: NSObject<NSCopying,HDSectionModelProtocol>

@end


