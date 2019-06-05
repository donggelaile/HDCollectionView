//
//  HDWebView.m
//  HDCollectionView_Example
//
//  Created by HaoDong chen on 2019/5/29.
//  Copyright © 2019 donggelaile. All rights reserved.
//

#import "HDWebView.h"

@implementation HDWebView
- (UIScrollView *)hd_ScrollJoinViewRealScroll
{
    return self.scrollView;
}
//- (void)hd_properContentSize:(void (^)(CGSize))callback
//{
//    NSLog(@"刷新高度");
//    [self evaluateJavaScript:@"document.body.clientHeight" completionHandler:^(id _Nullable res, NSError * _Nullable error) {
//        CGFloat fitH = [res floatValue];
//        if (callback) {
//            callback(CGSizeMake(self.frame.size.width, fitH));
//        }
//    }];
//}

@end
