//
//  HDUpdateUIProtocol.h
//  
//
//  Created by CHD on 2018/8/9.
//  Copyright © 2018年 chd. All rights reserved.
//

#ifndef HDUpdateUIProtocol_h
#define HDUpdateUIProtocol_h
//@class HDCellModel;
#import "HDCellModel.h"
#import "HDSectionModel.h"
typedef NS_ENUM(NSInteger,HDCallBackType) {
    HDSectionHeaderCallBack,
    HDSectionFooterCallBack,
    HDCellCallBack,
    HDDecorationCallBack,
    HDOtherCallBack
};
@protocol HDUpdateUIProtocol <NSObject>
@optional
- (void)cacheSubviewsFrameBySetLayoutWithCellModel:(HDCellModel*)cellModel;//cell实现该函数后,cell内部无需调用，将通过此函数布局并保存子view的frame
- (void)updateCellUI:(__kindof HDCellModel*)model;
- (void)updateSecVUI:(__kindof HDSectionModel*)model;
//对内部事件的处理
- (void)dealEventByEventKey:(NSString*)eventKey backType:(HDCallBackType)type backModel:(id)backModel self:(void(^)(void))selfDealCode;

- (CGSize)hdSizeThatFits:(CGSize)size;
- (void)superUpdateCellUI:(HDCellModel *)model callback:(void (^)(id, HDCallBackType))callback;
- (void)superUpdateSecVUI:(HDSectionModel *)model callback:(void (^)(id, HDCallBackType))callback;
- (void)superAutoLayoutDefaultSet:(HDCellModel *)cellModel;
@end

#endif /* HDUpdateUIProtocol_h */
