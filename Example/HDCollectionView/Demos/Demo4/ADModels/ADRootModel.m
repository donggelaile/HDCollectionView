//
//Created by ESJsonFormatForMac on 18/12/18.
//

#import "ADRootModel.h"
@implementation ADRootModel

+ (NSDictionary *)objectClassInArray{
    return @{@"ads" : [adModel class]};
}

@end

@implementation adModel

+ (NSDictionary *)objectClassInArray{
    return @{@"visibility" : [Visibility class], @"monitor" : [Monitor class], @"resources" : [Resources class]};
}

@end


@implementation Ext_Param

@end


@implementation Visibility

@end


@implementation Monitor

@end


@implementation Resources

@end


