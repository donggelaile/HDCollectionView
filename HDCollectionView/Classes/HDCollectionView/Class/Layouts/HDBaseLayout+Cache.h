//
//  HDBaseLayout+Cache.h
//  HDCollectionView
//
//  Created by HaoDong chen on 2019/4/12.
//  Copyright © 2019 CHD. All rights reserved.
//

#import "HDBaseLayout.h"

NS_ASSUME_NONNULL_BEGIN

@interface HDBaseLayout (Cache)
@property (nonatomic, assign) CGPoint cacheStart;
@property (nonatomic, assign) CGPoint cacheEnd;
@property (nonatomic, strong) NSMutableArray *cacheAtts;
@property (nonatomic, assign) BOOL needUpdate;
@property (nonatomic, assign) CGRect cacheSectionSize;
- (NSArray *)getAttsWithLayout:(HDCollectionViewLayout*)layout sectionModel:(HDSectionModel*)secModel currentStart:(CGPoint*)cStart isFirstSec:(BOOL)isFirstSec;
@end

NS_ASSUME_NONNULL_END
