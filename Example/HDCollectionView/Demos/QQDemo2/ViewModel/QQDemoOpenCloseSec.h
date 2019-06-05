//
//  QQDemoOpenCloseSec.h
//  HDCollectionView_Example
//
//  Created by HaoDong chen on 2019/5/16.
//  Copyright © 2019 donggelaile. All rights reserved.
//

#import <HDCollectionView/HDCollectionView.h>

NS_ASSUME_NONNULL_BEGIN

@interface QQDemoOpenCloseSec : HDSectionModel
@property (nonatomic, assign) BOOL isOpen;
@property (nonatomic, strong) NSMutableArray *sectionDataCopy;
@end

NS_ASSUME_NONNULL_END
