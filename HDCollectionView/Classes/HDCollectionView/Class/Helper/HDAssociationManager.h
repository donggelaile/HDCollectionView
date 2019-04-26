//
//  HDAssociationManager.h
//  HDCollectionView
//
//  Created by HaoDong chen on 2018/12/27.
//  Copyright © 2018 CHD. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface HDAssociationManager : NSObject
+ (void)hd_setAssociatedObject:(NSObject*)obj key:(NSString*)key value:(id)value;
+ (nullable id)hd_getAssociatedObject:(NSObject *)obj key:(NSString *)key;
+ (void)hd_removeObject:(NSObject*)obj forKey:(NSString*)key;
+ (void)hd_removeAllvaluesForObject:(NSObject*)obj;
+ (NSArray<NSDictionary *> *)HD_allAssociatedValue:(id)obj;
+ (NSMapTable*)hd_currentVaules;
@end

NS_ASSUME_NONNULL_END
