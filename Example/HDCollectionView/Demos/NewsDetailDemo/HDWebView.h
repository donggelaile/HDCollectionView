//
//  HDWebView.h
//  HDCollectionView_Example
//
//  Created by HaoDong chen on 2019/5/29.
//  Copyright © 2019 donggelaile. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <WebKit/WebKit.h>
#import <HDCollectionView/HDScrollJoinView.h>
NS_ASSUME_NONNULL_BEGIN

@interface HDWebView : WKWebView<HDScrollJoinViewRealScroll>

@end

NS_ASSUME_NONNULL_END
