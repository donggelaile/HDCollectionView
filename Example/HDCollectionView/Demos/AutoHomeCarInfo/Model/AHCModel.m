//
//Created by ESJsonFormatForMac on 19/04/19.
//

#import "AHCModel.h"
@implementation AHCModel


@end

@implementation AHCResult

+ (NSDictionary<NSString *,id> *)modelContainerPropertyGenericClass{
    return @{@"paramitems" : [AHCParamConfigitems class], @"configitems" : [AHCParamConfigitems class]};
}


@end


@implementation AHCSpecinfo

+ (NSDictionary<NSString *,id> *)modelContainerPropertyGenericClass{
    return @{@"specitems" : [AHCSpecitems class]};
}


@end


@implementation AHCSpecitems


@end


@implementation AHCAskpriceinfo


@end


@implementation AHCParamConfigitems

+ (NSDictionary<NSString *,id> *)modelContainerPropertyGenericClass{
    return @{@"items" : [AHCItems class]};
}


@end


@implementation AHCItems

+ (NSDictionary<NSString *,id> *)modelContainerPropertyGenericClass{
    return @{@"modelexcessids" : [AHCModelexcessids class]};
}


+ (NSDictionary<NSString *,id> *)modelCustomPropertyMapper{
    return @{@"ID":@"id"};
}

@end


@implementation AHCModelexcessids


+ (NSDictionary<NSString *,id> *)modelCustomPropertyMapper{
    return @{@"ID":@"id"};
}

@end




