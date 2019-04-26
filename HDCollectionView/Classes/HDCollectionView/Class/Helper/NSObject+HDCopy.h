//
//  NSObject+HDCopy.h
//  HDCollectionView
//
//  Created by HaoDong chen on 2019/4/17.
//  Copyright © 2019 CHD. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface NSObject (HDCopy)
- (id)hd_copyWithZone:(NSZone*)zone;
@end

NS_ASSUME_NONNULL_END
