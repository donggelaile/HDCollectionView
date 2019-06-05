//
//  QQDemo2VC.h
//  HDCollectionView_Example
//
//  Created by HaoDong chen on 2019/5/20.
//  Copyright © 2019 donggelaile. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HDMultipleScrollListMainVC.h"
#import "QQDemo2VCViewModel.h"
NS_ASSUME_NONNULL_BEGIN

@interface QQDemo2VC : HDMultipleScrollListMainVC
@property (nonatomic, strong) QQDemo2VCViewModel *viewModel;
@end

NS_ASSUME_NONNULL_END
