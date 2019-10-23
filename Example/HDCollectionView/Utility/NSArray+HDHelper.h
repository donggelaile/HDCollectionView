//
//  NSArray+HDHelper.h
//  HDListViewDiffer_Example
//
//  Created by chenhaodong on 2019/10/18.
//  Copyright © 2019 chenhaodong. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface NSArray (HDHelper)
- (NSArray*)shuffle;
- (NSArray*)randomDeleteCount:(NSInteger)count;
@end

NS_ASSUME_NONNULL_END
