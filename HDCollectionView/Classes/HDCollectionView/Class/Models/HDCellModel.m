//
//  HDCellModel.m
//  
//
//  Created by CHD on 2018/8/9.
//  Copyright © 2018年 chd. All rights reserved.
//

#import "HDCellModel.h"

@implementation HDCellModel
- (instancetype)init
{
    self = [super init];
    if (self) {
        self.cellSize = CGSizeZero;
        self.margin = UIEdgeInsetsZero;
    }
    return self;
}

- (void)setValue:(id)value forUndefinedKey:(NSString *)key
{
    
}
- (id)valueForUndefinedKey:(NSString *)key
{
    return nil;
}
@end



