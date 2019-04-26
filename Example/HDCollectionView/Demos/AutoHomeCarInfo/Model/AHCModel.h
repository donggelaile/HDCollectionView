//
//Created by ESJsonFormatForMac on 19/04/19.
//

#import <Foundation/Foundation.h>

@class AHCResult,AHCSpecinfo,AHCSpecitems,AHCAskpriceinfo,AHCParamConfigitems,AHCItems,AHCModelexcessids;
@interface AHCModel : NSObject

@property (nonatomic, copy) NSString *message;

@property (nonatomic, strong) AHCResult *result;

@property (nonatomic, assign) NSInteger returncode;

@end
@interface AHCResult : NSObject

@property (nonatomic, copy) NSString *bigpicprefix;

@property (nonatomic, strong) AHCSpecinfo *specinfo;

@property (nonatomic, strong) NSArray<AHCParamConfigitems*> *configitems;

@property (nonatomic, strong) NSArray<AHCParamConfigitems*> *paramitems;

@property (nonatomic, copy) NSString *smallpicprefix;

@end

@interface AHCSpecinfo : NSObject

@property (nonatomic, strong) NSArray<AHCSpecitems*> *specitems;

@end

@interface AHCSpecitems : NSObject

@property (nonatomic, assign) NSInteger noshowprice;

@property (nonatomic, assign) NSInteger paramisshow;

@property (nonatomic, strong) NSArray *picitems;

@property (nonatomic, copy) NSString *minprice;

@property (nonatomic, assign) NSInteger canaskprice;

@property (nonatomic, assign) NSInteger count;

@property (nonatomic, assign) NSInteger seriesid;

@property (nonatomic, strong) AHCAskpriceinfo *askpriceinfo;

@property (nonatomic, assign) NSInteger presell;

@property (nonatomic, copy) NSString *seriesname;

@property (nonatomic, copy) NSString *specname;

@property (nonatomic, assign) NSInteger specid;

@property (nonatomic, copy) NSString *dealerprice;

@property (nonatomic, copy) NSString *downprice;

@end

@interface AHCAskpriceinfo : NSObject

@property (nonatomic, copy) NSString *askpricesubtitle;

@property (nonatomic, copy) NSString *askpriceurl;

@property (nonatomic, assign) NSInteger canaskprice;

@property (nonatomic, copy) NSString *copa;

@property (nonatomic, assign) NSInteger type;

@property (nonatomic, copy) NSString *askpricetitle;

@end

@interface AHCParamConfigitems : NSObject

@property (nonatomic, strong) NSArray<AHCItems*> *items;

@property (nonatomic, copy) NSString *itemtype;

@end



@interface AHCItems : NSObject

@property (nonatomic, copy) NSString *ID;

@property (nonatomic, strong) NSArray<AHCModelexcessids*> *modelexcessids;

@property (nonatomic, copy) NSString *videoid;

@property (nonatomic, copy) NSString *name;

@end

@interface AHCModelexcessids : NSObject

@property (nonatomic, assign) NSInteger ID;

@property (nonatomic, copy) NSString *value;

@property (nonatomic, copy) NSString *priceinfo;

@property (nonatomic, assign) BOOL isConfigSame;

@end

