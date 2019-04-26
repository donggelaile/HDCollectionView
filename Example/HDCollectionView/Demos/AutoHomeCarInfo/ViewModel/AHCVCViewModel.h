//
//  DemoVC2Footer.h
//  HDCollectionView
//
//  Created by HaoDong chen on 2018/12/18.
//  Copyright © 2018 CHD. All rights reserved.
//

#import "HDSectionModel.h"

@interface AHCVCViewModel : NSObject
- (void)loadData:(void(^)(NSMutableArray*secArr,NSError *error))callBack;
- (NSMutableArray *)deleteColumnWithID:(NSInteger)columnID;
- (NSMutableArray *)changeShowSameOrAllState;
- (NSInteger)currentColumn;
@end

