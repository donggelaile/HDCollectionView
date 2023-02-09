//
//  HDDemoCellViewModel.m
//  HDCollectionView_Example
//
//  Created by chenhaodong on 2023/2/9.
//  Copyright © 2023 donggelaile. All rights reserved.
//

#import "HDDemoCellViewModel.h"

@interface HDDemoCellViewModel ()
@property (nonatomic, strong) UIColor *bgColor;
@end

@implementation HDDemoCellViewModel

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.bgColor = [UIColor colorWithRed:(arc4random()%255)/255.0 green:(arc4random()%255)/255.0 blue:(arc4random()%255)/255.0 alpha:1];
    }
    return self;
}

@end
