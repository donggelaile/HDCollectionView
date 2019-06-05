//
//  DemoVC4ViewModel.h
//  HDCollectionView_Example
//
//  Created by HaoDong chen on 2019/5/10.
//  Copyright © 2019 donggelaile. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface DemoVC4ViewModel : NSObject
- (void)loadData:(void (^)(BOOL success,id res))calback;
@end

NS_ASSUME_NONNULL_END
