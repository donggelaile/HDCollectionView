//
//  HDWeakHashMap.m
//  HDCollectionView_Example
//
//  Created by HaoDong chen on 2019/5/16.
//  Copyright © 2019 donggelaile. All rights reserved.
//

#import "HDWeakHashMap.h"
static NSMapTable *weakMap;
static dispatch_semaphore_t gcd_lock;
@implementation HDWeakHashMap
+ (instancetype)shareInstance
{
    static HDWeakHashMap *ins;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        ins = [self new];
        weakMap = [[NSMapTable alloc] initWithKeyOptions:NSPointerFunctionsWeakMemory valueOptions:NSPointerFunctionsWeakMemory capacity:0];
        gcd_lock = dispatch_semaphore_create(1);
    });
    return ins;
}
- (void)hd_saveValue:(id)value forKey:(NSString *)key
{
    dispatch_semaphore_wait(gcd_lock, DISPATCH_TIME_FOREVER);
    [weakMap setObject:value forKey:key];
    dispatch_semaphore_signal(gcd_lock);
}
- (id)hd_getValueForKey:(NSString *)key
{
    dispatch_semaphore_wait(gcd_lock, DISPATCH_TIME_FOREVER);
    id value = [weakMap objectForKey:key];
    dispatch_semaphore_signal(gcd_lock);
    return value;
}
- (void)hd_remoValueForKey:(NSString *)key
{
    dispatch_semaphore_wait(gcd_lock, DISPATCH_TIME_FOREVER);
    [weakMap removeObjectForKey:key];
    dispatch_semaphore_signal(gcd_lock);
}
- (void)hd_removeAll
{
    dispatch_semaphore_wait(gcd_lock, DISPATCH_TIME_FOREVER);
    [weakMap removeAllObjects];
    dispatch_semaphore_signal(gcd_lock);
}
- (NSDictionary *)hd_allKeysAndValues
{
    dispatch_semaphore_wait(gcd_lock, DISPATCH_TIME_FOREVER);
    NSMutableDictionary *result = @{}.mutableCopy;
    [[weakMap.keyEnumerator allObjects] enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if ([obj isKindOfClass:[NSString class]]) {
            result[(NSString*)obj] = [weakMap objectForKey:obj];
        }
    }];
    dispatch_semaphore_signal(gcd_lock);
    
    return result;
}
@end
