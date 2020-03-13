//
//  DemoVC3CellModel.m
//  HDCollectionView
//
//  Created by HaoDong chen on 2018/12/20.
//  Copyright © 2018 CHD. All rights reserved.
//

#import "DemoVC3CellModel.h"

@implementation DemoVC3CellModel
+(DemoVC3CellModel *)randomModel
{
    @autoreleasepool {
        NSString *title = @"科学家在海底发现了倒置的湖泊和瀑布";
        NSString *detail = @"科学家在加利福尼亚湾的深处发现了一个新奇的海洋生物的仙境。最近，来自美国和墨西哥的科学家探索了这别具一格的生态系统。他们的探险主要集中在巴哈半岛附近的佩斯卡德罗盆地一个此前未知的热液喷口区，该地区的海底火山活动加热了海水。在这里，研究小组在海底找到了“涌出高温流体”和储藏着冒着热气的沉积物的洞穴，洞穴里还有橙色的油和臭鸡蛋味儿硫化物。研究人员还拍摄到了倒置的湖泊和瀑布，这些湖泊和瀑布是因为高温的流体从喷口流出并在水下洞穴的下方汇集而形成的。“深海仍然是太阳系中探索最少的地方之一，” 来自加州大学戴维斯分校的主要研究员和荣誉教授Robert Zierenberg说道Robert Zierenberg表示：“地球的地图不像水星、金星、火星或月球那样详细，因为很难在水下绘图。这是一个先锋领域。”该团队将新的命名为热液喷口区命名为Jaich Maa，意为巴哈半岛土著语言中的“液态金属”。作为探险队的成员，施密特海洋研究所的科学家们说，Jaich Maa的一个突出特点是这里存在着一个名为Tay Ujaa的巨大方解石洞穴。洞穴里有一个因高温热液流体而形成的发出金属光芒的水池，最终，水池里的水流过边缘并进入倒置的瀑布。";
        
        NSString *left = @"蝌蚪五线谱编译自vice，译者晴空飞燕，转载须授权";
        NSString *right = @"关键词:瀑布,海底,湖泊,热液,洞穴";
        
        DemoVC3CellModel *model = [DemoVC3CellModel new];
        {
            NSInteger randomStart = arc4random()%title.length;
            NSString *random = [NSString stringWithFormat:@"%@",[title substringWithRange:NSMakeRange(randomStart, title.length-randomStart)]];
            model.title = random;
        }
        {
            NSInteger randomStart = arc4random()%detail.length;
            NSString *random = [NSString stringWithFormat:@"%@",[detail substringWithRange:NSMakeRange(randomStart, detail.length-randomStart)]];
            model.detail = random;
        }
        {
            NSInteger randomStart = arc4random()%left.length;
            NSString *random = [NSString stringWithFormat:@"%@",[left substringWithRange:NSMakeRange(randomStart, left.length-randomStart)]];
            model.leftText = random;
        }
        
        {
            NSInteger randomStart = arc4random()%right.length;
            NSString *random = [NSString stringWithFormat:@"%@",[right substringWithRange:NSMakeRange(randomStart, right.length-randomStart)]];
            model.rightText = random;
        }
        
        {
            if (arc4random()%2 == 0) {
                model.imageUrl = @"http://c.hiphotos.baidu.com/image/pic/item/2e2eb9389b504fc22f9b0558eedde71191ef6da3.jpg";
            }
        }
        
        return model;
    }
}
@end
