//
//  DemoVC3CellModel.h
//  HDCollectionView
//
//  Created by HaoDong chen on 2018/12/20.
//  Copyright © 2018 CHD. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface DemoVC3CellModel : NSObject
@property (nonatomic, strong) NSMutableAttributedString *title;
@property (nonatomic, strong) NSMutableAttributedString *detail;
@property (nonatomic, strong) NSMutableAttributedString *leftText;
@property (nonatomic, strong) NSMutableAttributedString *rightText;
@property (nonatomic, strong) NSString *imageUrl;
+ (DemoVC3CellModel*)randomModel;
@end

NS_ASSUME_NONNULL_END
