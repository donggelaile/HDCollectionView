//
//  HDStopView.h
//  HDCollectionView_Example
//
//  Created by HaoDong chen on 2019/5/30.
//  Copyright © 2019 donggelaile. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HDScrollJoinView.h"
NS_ASSUME_NONNULL_BEGIN

@interface HDStopView : UIView<HDScrollJoinViewRealScroll>
- (void)setStopType:(HDScrollJoinViewStopType)stopType title:(NSString*)title;
@end

NS_ASSUME_NONNULL_END
