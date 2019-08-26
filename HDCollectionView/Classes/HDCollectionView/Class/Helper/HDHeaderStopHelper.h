//
//  HDHeaderStopHelper.h
//  HDCollectionView
//
//  Created by HaoDong chen on 2019/4/10.
//  Copyright © 2019 CHD. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "HDModelProtocol.h"
#import <UIKit/UIKit.h>
NS_ASSUME_NONNULL_BEGIN
@interface HDHeaderStopHelper : NSObject
+ (NSMutableArray<UICollectionViewLayoutAttributes*>*)getAdjustAttArrWith:(NSMutableArray<UICollectionViewLayoutAttributes*>*)oriRectAttArr allSectionData:(NSMutableArray<id<HDSectionModelProtocol>>*)secDataArr layout:(UICollectionViewLayout*)layout scollDirection:(UICollectionViewScrollDirection)scorllDirection;
@end

NS_ASSUME_NONNULL_END
