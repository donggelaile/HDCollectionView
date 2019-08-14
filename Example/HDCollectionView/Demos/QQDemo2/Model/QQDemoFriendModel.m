//
//  QQDemoFriendModel.m
//  HDCollectionView_Example
//
//  Created by chenhaodong on 2019/8/9.
//  Copyright © 2019 donggelaile. All rights reserved.
//

#import "QQDemoFriendModel.h"
#import "QQDemoFriendCellVM.h"

@interface QQDemoFriendModel()<QQDemoFriendCellVMProtocol>

@end

@implementation QQDemoFriendModel

- (NSURL *)vmHeadUrl
{
    return [NSURL URLWithString:self.headUrl];
}
- (NSAttributedString *)vmTitle
{
    NSAttributedString *att = [[NSAttributedString alloc] initWithString:self.title attributes:@{}];
    return att;
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.title = [self randomTitle];
        self.headUrl = [self randomHeaderUrl];
    }
    return self;
}

- (NSString*)randomTitle
{
    NSString *source = @"美国、中国、安圭拉岛、安提瓜和巴布达岛、阿根廷、澳洲、奥地利、阿塞拜疆、比利时、巴西、英属维京群岛、保加利亚、布隆迪、加拿大、乍得、智利、哥伦比亚、哥斯达黎加、科特迪瓦、古巴、刚果民主共和国、丹麦、吉布提、多米尼加共和国、厄瓜多尔、萨尔瓦多、密克罗尼西亚联邦、斐济、芬兰、法国、冈比亚、格鲁吉亚、德国、西班牙、直布罗陀、希腊、格陵兰、英属格恩西、洪都拉斯、中国香港、匈牙利、印度、爱尔兰、英属马恩岛、以色列、意大利、牙买加、日本、英属泽西岛、哈萨克斯坦、韩国、拉脱维亚、莱索托、列支敦士登、立陶宛、卢森堡、马拉维、马来西亚、马耳他、毛里求斯、墨西哥、英属蒙特塞拉特岛、纳米比亚、尼泊尔、荷兰、新西兰、尼加拉瓜、诺福克岛、巴基斯坦、巴拿马、巴拉圭、秘鲁、菲律宾、英属皮特克恩岛、波兰、葡萄牙、波多黎各、刚果共和国、罗马尼亚、俄罗斯、卢旺达、圣赫勒拿岛、圣马力诺、新加坡、斯洛伐克、南非、西班牙、瑞典、瑞士、中国台湾、泰国、特立尼达和多巴哥、土耳其、乌克兰、阿拉伯联合酋长国、英国、乌拉圭、乌兹别克斯坦、新赫布里底群岛、委内瑞拉、越南、朝鲜、伊拉、东萨摩亚";
    NSArray *tempArr = [source componentsSeparatedByString:@"、"];
    NSString *randomStr = tempArr[arc4random()%tempArr.count];
    return randomStr;
}
- (NSString*)randomHeaderUrl
{
    NSArray *allUrl = @[@"http://img3.imgtn.bdimg.com/it/u=3626841386,3218161343&fm=15&gp=0.jpg"
                        ,@"http://image.baidu.com/search/detail?ct=503316480&z=0&tn=baiduimagedetail&ipn=d&word=头像%20卡通动漫%20海贼王&step_word=&ie=utf-8&in=&cl=2&lm=-1&st=-1&hd=undefined&latest=undefined&copyright=undefined&cs=2416657003,2256113980&os=2175433645,1012165619&simid=3229779261,3744406098&pn=14&rn=1&di=129140&ln=3294&fr=&fmq=1461834053046_R&fm=&ic=0&s=0&se=&sme=&tab=0&width=&height=&face=undefined&is=0,0&istype=2&ist=&jit=&bdtype=0&spn=0&pi=0&gsm=3c&objurl=http%3A%2F%2Ft-1.tuzhan.com%2F88d7d4848c0f%2Fc-2%2Fl%2F2014%2F01%2F28%2F18%2F00a95a9eec46427ca4a4a9ab5f66e73e.jpg&rpstart=0&rpnum=0&adpicid=0&force=undefined",
                        @"http://image.baidu.com/search/detail?ct=503316480&z=0&tn=baiduimagedetail&ipn=d&word=头像%20卡通动漫%20海贼王&step_word=&ie=utf-8&in=&cl=2&lm=-1&st=-1&hd=undefined&latest=undefined&copyright=undefined&cs=1442339304,635122765&os=2984111611,31849197&simid=3529918299,448541378&pn=81&rn=1&di=21130&ln=3294&fr=&fmq=1461834053046_R&fm=&ic=0&s=0&se=&sme=&tab=0&width=&height=&face=undefined&is=0,0&istype=2&ist=&jit=&bdtype=15&spn=0&pi=0&gsm=1e&objurl=http%3A%2F%2Fn.sinaimg.cn%2Fsinacn17%2F417%2Fw589h628%2F20181011%2Fc9f2-hktxqai5677478.jpg&rpstart=0&rpnum=0&adpicid=0&force=undefined",
                        @"http://image.baidu.com/search/detail?ct=503316480&z=0&tn=baiduimagedetail&ipn=d&word=头像%20卡通动漫%20海贼王&step_word=&ie=utf-8&in=&cl=2&lm=-1&st=-1&hd=undefined&latest=undefined&copyright=undefined&cs=2748298755,624453822&os=1423097315,3501750061&simid=0,0&pn=84&rn=1&di=4950&ln=3294&fr=&fmq=1461834053046_R&fm=&ic=0&s=0&se=&sme=&tab=0&width=&height=&face=undefined&is=0,0&istype=2&ist=&jit=&bdtype=0&spn=0&pi=0&gsm=1e&objurl=http%3A%2F%2Fb-ssl.duitang.com%2Fuploads%2Fitem%2F201507%2F16%2F20150716111311_xGKse.thumb.700_0.jpeg&rpstart=0&rpnum=0&adpicid=0&force=undefined"];
    return allUrl[arc4random()%allUrl.count];
}
@end



