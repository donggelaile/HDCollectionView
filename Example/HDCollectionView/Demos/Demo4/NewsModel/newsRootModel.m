//
//Created by ESJsonFormatForMac on 18/12/19.
//

#import "newsRootModel.h"
#import "SJAttributeWorker.h"
@implementation newsRootModel

+ (NSDictionary *)objectClassInArray{
    return @{@"tid" : [Tid class]};
}

@end

@implementation Tid

+ (NSDictionary *)objectClassInArray{
    return @{@"images" : [Images class], @"imgnewextra" : [Imgnewextra class], @"recommendSources" : [Recommendsources class]};
}
- (void)mj_keyValuesDidFinishConvertingToObject
{
    self.showTitle = sj_makeAttributesString(^(SJAttributeWorker * _Nonnull make) {
        if (self.title) {
            make.append(self.title).font([UIFont systemFontOfSize:15]).textColor([UIColor blackColor]).lineSpacing(4);
        }
    });
    self.showBottom = sj_makeAttributesString(^(SJAttributeWorker * _Nonnull make) {
        
        if ([self.interest isEqualToString:@"S"]) {
            NSString *interest = @"置顶 ";
            make.append(interest).textColor([UIColor redColor]).font([UIFont systemFontOfSize:14]);
        }
        
        if (self.source) {
            make.append(self.source).textColor([UIColor lightGrayColor]).font([UIFont systemFontOfSize:13]);
            make.append(@"  ");
        }
        if (self.replyCount>0) {
            make.append(@"跟贴  ");
            make.append(@(self.replyCount).stringValue).textColor([UIColor lightGrayColor]).font([UIFont systemFontOfSize:13]);
        };
    });
}

@end


@implementation Recinfo

@end


@implementation Readagent

+ (NSDictionary *)objectClassInArray{
    return @{@"incentiveInfoList" : [Incentiveinfolist class]};
}

@end


@implementation Dyuserinfo

@end


@implementation Incentiveinfolist

@end


@implementation Videoinfo
+(NSDictionary*)mj_replacedKeyFromPropertyName{
    //
    return @{@"ViedeoDescription":@"description"};
}

@end


@implementation Videotopic

@end


@implementation Motif

@end


@implementation Images

@end


@implementation Imgnewextra

@end


@implementation Recommendsources

@end


