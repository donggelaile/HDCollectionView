//
//  NSObject+HDCopy.m
//  HDCollectionView
//
//  Created by HaoDong chen on 2019/4/17.
//  Copyright © 2019 CHD. All rights reserved.
//

#import "NSObject+HDCopy.h"
#include <CommonCrypto/CommonCrypto.h>
#import <objc/runtime.h>

@implementation HDObjectProperty

- (instancetype)initWithProperty:(objc_property_t)property_t obj:(nonnull NSObject *)obj {
    if (!property_t) {
        return nil;
    }

    if (property_t) {
        self = [super init];
        _name = [NSString stringWithUTF8String:property_getName(property_t)];
        @try {
            //这里获取getter及ivarName的方法参考了YYModel
            SEL getter;
            NSString *ivarName;
            unsigned int attrCount;
            objc_property_attribute_t *attrs = property_copyAttributeList(property_t, &attrCount);
            for (unsigned int i=0; i<attrCount; i++) {
                if (attrs[i].name[0] == 'G') {
                    getter =  NSSelectorFromString([NSString stringWithUTF8String:attrs[i].value]);
                }else if (attrs[i].name[0] == 'V'){
                    ivarName = [NSString stringWithUTF8String:attrs[i].value];
                }
            }
            if (getter && [obj respondsToSelector:getter]) {
                #pragma clang diagnostic push
                #pragma clang diagnostic ignored "-Warc-performSelector-leaks"
                    _value = [obj performSelector:getter];
                #pragma clang diagnostic pop
            }else{
                if (ivarName) {
                    _value = [obj valueForKey:ivarName];
                }
            }
            if (attrs) {
                free(attrs);
                attrs = NULL;
            }
            
        } @catch (NSException *exception) {
            
        } @finally {
            
        }
    }
    return self;
}

@end

@implementation NSObject (HDCopy)

- (id)hd_copyWithZone:(NSZone *)zone {
    id copyIns = [[[self class] allocWithZone:zone] init];
    unsigned int count = 0 ;
    Ivar *ivars = class_copyIvarList([self class], &count);
    for (int i = 0; i < count; i++) {
        Ivar ivar = ivars[i];
        const char *name = ivar_getName(ivar);

        NSString *key = [NSString stringWithUTF8String:name];
        @try {
            id value = [self valueForKeyPath:key];
            if (value) {
                [copyIns setValue:value forKey:key];
            }
        } @catch (NSException *exception) {
            
        } @finally {
            
        }
    }
    
    free(ivars);
    return copyIns;
}

- (NSDictionary*)hdDefaultIgnorePropertys {
    return @{
             @"hash":@(YES),
             @"superclass":@(YES),
             @"description":@(YES),
             @"debugDescription":@(YES),
             };
}

- (NSArray<HDObjectProperty *> *)hdAllPropertys {
    return [self _hdAllPropertysWithClass:[self class] needSuper:YES];
}

- (NSArray<HDObjectProperty *> *)_hdAllPropertysWithClass:(Class)cls needSuper:(BOOL)isNeedSuperProperty {
    NSMutableArray *res = @[].mutableCopy;
    
    NSMutableDictionary *ignorePropertys = [self hdDefaultIgnorePropertys].mutableCopy;
    if ([self respondsToSelector:@selector(hdDiffIdentifierIgnorePropertys)]) {
        NSDictionary *otherData = [(id<hdDiffIdentifierIgnorePropertysProtocol>)self hdDiffIdentifierIgnorePropertys];
        if ([otherData isKindOfClass:[NSDictionary class]]) {
            [ignorePropertys addEntriesFromDictionary:otherData];
        }
    }
    unsigned int propertyCount = 0;
    objc_property_t *properties = class_copyPropertyList(cls, &propertyCount);
    if (properties) {
        for (unsigned int i = 0; i < propertyCount; i++) {
            HDObjectProperty *info = [[HDObjectProperty alloc] initWithProperty:properties[i] obj:self];
            if (info && !ignorePropertys[info.name]) {
                [res addObject:info];
            }
        }
        free(properties);
    }
    
    if (isNeedSuperProperty) {
        if ([cls.superclass isKindOfClass:object_getClass(NSObject.class)] && cls.superclass != NSObject.class) {
            [res addObjectsFromArray:[self _hdAllPropertysWithClass:cls.superclass needSuper:YES]];
        }
    }
    
    return res;
}

- (NSString *)hdObjectIDByPropertys {
    NSMapTable *countedObjMap = [NSMapTable mapTableWithKeyOptions:NSPointerFunctionsWeakMemory valueOptions:NSPointerFunctionsStrongMemory];
    NSString *finalID = [self _innerHdObjectIDByPropertys:countedObjMap];
    //copy from NSData+YYAdd
    NSData *data = [finalID dataUsingEncoding:NSUTF8StringEncoding];
    unsigned char result[CC_MD5_DIGEST_LENGTH];
    CC_MD5(data.bytes, (CC_LONG)data.length, result);
    finalID = [NSString stringWithFormat:
            @"%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x",
            result[0], result[1], result[2], result[3],
            result[4], result[5], result[6], result[7],
            result[8], result[9], result[10], result[11],
            result[12], result[13], result[14], result[15]
            ].mutableCopy;
    
    return finalID;
}

- (NSString *)_innerHdObjectIDByPropertys:(NSMapTable*)countedObjMap {
    //countedObjMap用来记录计算过了哪些对象
    if ([countedObjMap objectForKey:self]) {
        return [countedObjMap objectForKey:self];
    }
    
    NSMutableString *finalID = @"".mutableCopy;
    
    BOOL isNeedAddSelfHash = NO;
    if ([self respondsToSelector:@selector(hdDiffIdentifierIsNeedAddModelHash)]) {
        isNeedAddSelfHash = [(id<hdDiffIdentifierIgnorePropertysProtocol>)self hdDiffIdentifierIsNeedAddModelHash];
    }
    if (isNeedAddSelfHash) {
        [finalID appendFormat:@"$%@_hash:%@$",self.class,@(self.hash)];
    }
    NSMutableArray *queueArr = self.hdAllPropertys.mutableCopy;
    while (queueArr.count) {
        
        HDObjectProperty *firstObj = [queueArr firstObject];
        id firstObjValue = firstObj.value;
        //只是对HDCellModel的属性及其orgData的属性进行遍历
        if ([firstObj.name isEqualToString:@"orgData"]) {
            if ([firstObjValue isKindOfClass:NSObject.class]) {
                [finalID appendFormat:@"{%@:%@}",firstObj.name,[firstObjValue _innerHdObjectIDByPropertys:countedObjMap]];
            }else{
#ifdef DEBUG
                NSLog(@"%@",@"当前 orgData 对象是 swift 中不继承 NSObject 的 class, 建议继承 HDCellModel 并重写 - (NSString *)hdDiffIdentifier");
#endif
            }
        }else{
            [finalID appendFormat:@"(%@:%@)",firstObj.name,firstObjValue];
        }
        
        [queueArr removeObjectAtIndex:0];
    }
    [countedObjMap setObject:finalID forKey:self];
    
    return finalID;
}

@end
