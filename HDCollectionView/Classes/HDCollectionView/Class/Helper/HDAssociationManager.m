//
//  HDAssociationManager.m
//  HDCollectionView
//
//  Created by HaoDong chen on 2018/12/27.
//  Copyright © 2018 CHD. All rights reserved.
//

#import "HDAssociationManager.h"
#import <pthread.h>


static NSMapTable *hd_big_map;
static pthread_rwlock_t rwLock;//静态全局变量，所以不考虑释放（pthread_rwlock_destroy(&rwLock)）
@implementation HDAssociationManager

+ (void)load {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        hd_big_map = [NSMapTable mapTableWithKeyOptions:NSPointerFunctionsWeakMemory valueOptions:NSPointerFunctionsStrongMemory];
        pthread_rwlock_init(&rwLock, NULL);
        
    });
}
// 内部对value的引用为弱引用，若value没有其他强引用会马上释放 (若改为强引用会内存泄漏)
+ (void)hd_setAssociatedObject:(NSObject *)obj key:(NSString *)key value:(id)value {
    pthread_rwlock_wrlock(&rwLock);
    NSMapTable *objMap = [hd_big_map objectForKey:obj];
    if (!objMap) {
        objMap = [NSMapTable mapTableWithKeyOptions:NSPointerFunctionsStrongMemory valueOptions:NSPointerFunctionsWeakMemory];
        [objMap setObject:value forKey:key];
        [hd_big_map setObject:objMap forKey:obj];
                
    }else{
        [objMap setObject:value forKey:key];
    }
    pthread_rwlock_unlock(&rwLock);
}

+ (nullable id)hd_getAssociatedObject:(NSObject *)obj key:(NSString *)key {
    pthread_rwlock_rdlock(&rwLock);
    id result = [[hd_big_map objectForKey:obj] objectForKey:key];
    pthread_rwlock_unlock(&rwLock);
    return result;
}

+ (void)hd_removeObject:(NSObject *)obj forKey:(NSString *)key {
    pthread_rwlock_wrlock(&rwLock);
    NSMapTable *objMap = [hd_big_map objectForKey:obj];
    if (objMap) {
        [objMap removeObjectForKey:key];
    }
    pthread_rwlock_unlock(&rwLock);
    
}

+(void)hd_removeAllvaluesForObject:(NSObject *)obj {
    pthread_rwlock_wrlock(&rwLock);
    [hd_big_map removeObjectForKey:obj];
    pthread_rwlock_unlock(&rwLock);
}

+ (NSArray<NSDictionary *> *)HD_allAssociatedValue:(id)obj {
    pthread_rwlock_rdlock(&rwLock);
    NSMapTable *objMap = [hd_big_map objectForKey:obj];
    NSMutableArray *result = @[].mutableCopy;
    [[objMap.keyEnumerator allObjects] enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        [result addObject:@{obj:[objMap objectForKey:obj]}];
    }];
    pthread_rwlock_unlock(&rwLock);
    return result;
}

+(NSMapTable *)hd_currentVaules {
    return hd_big_map;
}

@end
