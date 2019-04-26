//
//Created by ESJsonFormatForMac on 18/12/18.
//

#import <Foundation/Foundation.h>

@class adModel,Ext_Param,Visibility,Monitor,Resources;
@interface ADRootModel : NSObject

@property (nonatomic, assign) NSInteger result;

@property (nonatomic, strong) NSArray *ads;

@end
@interface adModel : NSObject

@property (nonatomic, copy) NSString *sdkad_id;

@property (nonatomic, copy) NSString *location;

@property (nonatomic, assign) NSInteger style;

@property (nonatomic, strong) NSArray *relatedActionLinks;

@property (nonatomic, assign) NSInteger position;

@property (nonatomic, copy) NSString *title;

@property (nonatomic, assign) NSInteger is_backup;

@property (nonatomic, assign) long long expire;

@property (nonatomic, strong) NSArray *visibility;

@property (nonatomic, copy) NSString *category;

@property (nonatomic, strong) NSArray *constraint;

@property (nonatomic, strong) NSArray *monitor;

@property (nonatomic, copy) NSString *live_status;

@property (nonatomic, copy) NSString *sub_title;

@property (nonatomic, assign) NSInteger norm_style;

@property (nonatomic, strong) NSArray *resources;

@property (nonatomic, assign) long long requestTime;

@property (nonatomic, assign) NSInteger from;

@property (nonatomic, strong) Ext_Param *ext_param;

@property (nonatomic, assign) NSInteger live_user;

@property (nonatomic, assign) NSInteger usr_protect_time;

@property (nonatomic, copy) NSString *adid;

@property (nonatomic, assign) NSInteger st;

@property (nonatomic, assign) NSInteger is_sense;

@property (nonatomic, copy) NSString *content;

@end

@interface Ext_Param : NSObject

@property (nonatomic, copy) NSString *ext_info;

@property (nonatomic, copy) NSString *ID;

@property (nonatomic, copy) NSString *isfixed;

@property (nonatomic, assign) NSInteger flight_id;

@property (nonatomic, assign) long long refresh_time;

@property (nonatomic, copy) NSString *clip;

@property (nonatomic, assign) BOOL needFilter;

@end

@interface Visibility : NSObject

@property (nonatomic, copy) NSString *type;

@property (nonatomic, copy) NSString *rate_height;

@end

@interface Monitor : NSObject

@property (nonatomic, copy) NSString *url;

@property (nonatomic, assign) NSInteger action;

@property (nonatomic, copy) NSString *type;

@end

@interface Resources : NSObject

@property (nonatomic, assign) NSInteger type;

@property (nonatomic, strong) NSArray *urls;

@end

