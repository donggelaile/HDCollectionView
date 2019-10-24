//
//  HDDefines.h
//
//  Created by HaoDong chen on 2019/1/11.
//  Copyright © 2018年 chd. All rights reserved.
//

#ifndef HDDefines_h
#define HDDefines_h

#define __hd_WeakSelf __weak typeof(self) weakSelf = self;

#define hd_deviceWidth [UIScreen mainScreen].bounds.size.width
#define hd_deviceHeight [UIScreen mainScreen].bounds.size.height


//默认回调相关--------------------------------------------------------begin
#define HDGetBackModelContext(backModel) (([backModel conformsToProtocol:@protocol(HDCellModelProtocol)] || [backModel conformsToProtocol:@protocol(HDSectionModelProtocol)] || [backModel isKindOfClass:[NSDictionary class]])?[backModel valueForKey:@"context"]:nil)

//默认的eventKey和context 为 类型#方法名

#define HDDefaultCellEventDeal(cellDealCode) \
NSString *defalutEventKeyAndContext = [NSString stringWithFormat:@"%@#%@",NSStringFromClass([self class]),NSStringFromSelector(_cmd)];\
self.hdModel.context = defalutEventKeyAndContext; \
[self dealEventByEventKey:defalutEventKeyAndContext backType:HDCellCallBack backModel:self.hdModel self:cellDealCode];

#define HDDefaultSecHeaderEventDeal(secDealCode) \
NSString *defalutEventKeyAndContext = [NSString stringWithFormat:@"%@#%@",NSStringFromClass([self class]),NSStringFromSelector(_cmd)];\
self.hdSecModel.context = defalutEventKeyAndContext; \
[self dealEventByEventKey:defalutEventKeyAndContext backType:HDSectionHeaderCallBack backModel:self.hdSecModel self:secDealCode];

#define HDDefaultSecFooterEventDeal(secDealCode) \
NSString *defalutEventKeyAndContext = [NSString stringWithFormat:@"%@#%@",NSStringFromClass([self class]),NSStringFromSelector(_cmd)];\
self.hdSecModel.context = defalutEventKeyAndContext; \
[self dealEventByEventKey:defalutEventKeyAndContext backType:HDSectionFooterCallBack backModel:self.hdSecModel self:secDealCode];

#define HDDefaultSecDecEventDeal(secDealCode) \
NSString *defalutEventKeyAndContext = [NSString stringWithFormat:@"%@#%@",NSStringFromClass([self class]),NSStringFromSelector(_cmd)];\
self.hdSecModel.context = defalutEventKeyAndContext; \
[self dealEventByEventKey:defalutEventKeyAndContext backType:HDDecorationCallBack backModel:self.hdSecModel self:secDealCode];
//默认回调相关--------------------------------------------------------end


#endif /* HDDefines_h */
