//
//  HDBaseLayout.m
//  HDCollectionView
//
//  Created by HaoDong chen on 2019/4/4.
//  Copyright © 2019 CHD. All rights reserved.
//

#import "HDBaseLayout.h"
#import "NSObject+HDCopy.h"
@interface HDBaseLayout()
@end

@implementation HDBaseLayout
- (instancetype)init
{
    self = [super init];
    if (self) {
        self.secInset = UIEdgeInsetsZero;
        self.verticalGap = 0;
        self.horizontalGap = 0;
        self.headerSize = CGSizeZero;
        self.footerSize = CGSizeZero;
        self.cellSize = CGSizeZero;
    }
    return self;
}
- (CGSize)headerSize
{
    if (self.headerSizeCb) {
        _headerSize = self.headerSizeCb();
    }
    return _headerSize;
}
- (CGSize)footerSize
{
    if (self.footerSizeCb) {
        _footerSize = self.footerSizeCb();
    }
    return _footerSize;
}
- (id)copyWithZone:(NSZone *)zone
{
    return  [self hd_copyWithZone:zone];
}
- (NSMutableArray *)layoutWithLayout:(UICollectionViewLayout *)layout sectionModel:(HDSectionModel *)secModel currentStart:(CGPoint *)cStart
{
    return @[].mutableCopy;
}
@end
