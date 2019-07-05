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
//子类如果设置了collectionV hd_setScrollViewDidScrollCallback，需要在回调中先调[super scDicScroll:sc]
- (void)scDicScroll:(UIScrollView*)sc;
@end

NS_ASSUME_NONNULL_END
