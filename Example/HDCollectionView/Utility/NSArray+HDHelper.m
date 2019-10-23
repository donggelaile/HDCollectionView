//
//  NSArray+HDHelper.m
//  HDListViewDiffer_Example
//
//  Created by chenhaodong on 2019/10/18.
//  Copyright © 2019 chenhaodong. All rights reserved.
//

#import "NSArray+HDHelper.h"


@implementation NSArray (HDHelper)
- (NSArray *)shuffle
{
    NSMutableArray * tmp = self.mutableCopy;
    NSInteger count = tmp.count;
    while (count > 0) {

        NSInteger index = arc4random_uniform((int)(count - 1));
        id value = tmp[index];
        tmp[index] = tmp[count - 1];
        tmp[count - 1] = value;
        count--;
    }
    return tmp.copy;
}
- (NSArray*)randomDeleteCount:(NSInteger)count
{
    if (count<=0) {
        return self;
    }
    NSMutableArray *tmp = self.mutableCopy;
    while (count--) {
        if (tmp.count<=0) {
            break;
        }
        [tmp removeObjectAtIndex:arc4random()%tmp.count];
    }
    return tmp;
}
@end
