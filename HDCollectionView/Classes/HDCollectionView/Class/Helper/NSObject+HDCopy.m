//
//  NSObject+HDCopy.m
//  HDCollectionView
//
//  Created by HaoDong chen on 2019/4/17.
//  Copyright © 2019 CHD. All rights reserved.
//

#import "NSObject+HDCopy.h"
#import <objc/runtime.h>
@implementation NSObject (HDCopy)
- (id)hd_copyWithZone:(NSZone *)zone
{
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

@end
