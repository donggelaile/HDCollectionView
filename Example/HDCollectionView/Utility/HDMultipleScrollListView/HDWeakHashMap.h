//
//  HDWeakHashMap.h
//  HDCollectionView_Example
//
//  Created by HaoDong chen on 2019/5/16.
//  Copyright © 2019 donggelaile. All rights reserved.

//  1、对value的引用均为若引用，无需手动移除(但是也提供了移除方法)
//  2、如果value没有其他强引用，value会立即释放(届时也就无法通过key来获取value)
//  3、个人一般会对view做个弱引用，方便多个类之间访问同一view

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface HDWeakHashMap : NSObject

+ (instancetype)shareInstance;

- (void)hd_saveValue:(id)value forKey:(NSString*)key;
- (void)hd_remoValueForKey:(NSString*)key;
- (nullable id)hd_getValueForKey:(NSString*)key;
- (void)hd_removeAll;
- (nullable NSDictionary*)hd_allKeysAndValues;

- (instancetype)init NS_UNAVAILABLE;
- (instancetype)new NS_UNAVAILABLE;
- (instancetype)copy NS_UNAVAILABLE;
- (instancetype)mutableCopy NS_UNAVAILABLE;
@end

NS_ASSUME_NONNULL_END
