//
//  QQDemoVCViewModel.h
//  HDCollectionView_Example
//
//  Created by HaoDong chen on 2019/5/9.
//  Copyright © 2019 donggelaile. All rights reserved.
//  真实项目中，VCViewModel一般继承与某个基类，此处简化

#import <Foundation/Foundation.h>
static NSString *QQDemoVCMainCollecitonKey = @"QQDemoVCMainCollecitonKey";
static NSString *QQDemoMainBarHeaderKey = @"QQDemoMainBarHeaderKey";
static NSInteger QQDemoMainBarHeaderHeight = 45;

@interface QQDemoVCViewModel : NSObject
- (void)loadData:(void(^)(NSMutableArray*secArr,NSError *error))callBack;
@end


