//
//  QQDemo2VCViewModel.h
//  HDCollectionView_Example
//
//  Created by HaoDong chen on 2019/5/20.
//  Copyright © 2019 donggelaile. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface QQDemo2VCViewModel : NSObject

//QQDemo2VC
@property (nonatomic, strong) NSMutableArray *topSecArr;;
@property (nonatomic, strong) NSMutableArray *controllers;
@property (nonatomic, strong) NSMutableArray *titles;
@property (nonatomic, assign) CGSize titleSize;
@property (nonatomic, assign) BOOL headerStop;;

//QQDemo2FriendVC
@property (nonatomic, strong) NSMutableArray *QQDemo2FriendVCSecArr;

@end

NS_ASSUME_NONNULL_END
