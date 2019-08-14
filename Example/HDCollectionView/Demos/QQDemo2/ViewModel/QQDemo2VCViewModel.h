//
//  QQDemo2VCViewModel.h
//  HDCollectionView_Example
//
//  Created by HaoDong chen on 2019/5/20.
//  Copyright © 2019 donggelaile. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

//实际中这个可以继承一个基类VC的ViewModel或者遵循一个基类协议
@interface QQDemo2VCViewModel : NSObject
@property (nonatomic, strong) NSMutableArray *topSecArr;;
@property (nonatomic, strong) NSMutableArray *controllers;
@property (nonatomic, strong) NSMutableArray *titles;
@property (nonatomic, assign) CGSize titleSize;
@property (nonatomic, assign) BOOL headerStop;;
@end

NS_ASSUME_NONNULL_END
