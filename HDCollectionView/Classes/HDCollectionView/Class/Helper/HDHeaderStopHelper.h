//
//  HDHeaderStopHelper.h
//  HDCollectionView
//
//  Created by HaoDong chen on 2019/4/10.
//  Copyright © 2019 CHD. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
NS_ASSUME_NONNULL_BEGIN
@class HDSectionModel;
@interface HDHeaderStopHelper : NSObject
+ (NSMutableArray<UICollectionViewLayoutAttributes*>*)getAdjustAttArrWith:(NSMutableArray<UICollectionViewLayoutAttributes*>*)oriRectAttArr allSectionData:(NSMutableArray<HDSectionModel*>*)secDataArr layout:(UICollectionViewLayout*)layout scollDirection:(UICollectionViewScrollDirection)scorllDirection;
@end

NS_ASSUME_NONNULL_END
