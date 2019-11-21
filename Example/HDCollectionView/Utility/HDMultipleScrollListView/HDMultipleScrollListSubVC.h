//
//  HDMultipleScrollListSubVC.h
//  HDCollectionView_Example
//
//  Created by HaoDong chen on 2019/5/21.
//  Copyright © 2019 donggelaile. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HDCollectionView.h"
NS_ASSUME_NONNULL_BEGIN

@interface HDMultipleScrollListSubVC : UIViewController
@property (nonatomic, strong, readonly) HDCollectionView *collectionV;
@property (nonatomic, assign) BOOL isNeedBottomGap;//默认NO
@property (nonatomic, assign) NSInteger gapOfBottomWhenSmallData;//子vc数据较少时底部间距，isNeedBottomGap为YES时生效

@end

NS_ASSUME_NONNULL_END
