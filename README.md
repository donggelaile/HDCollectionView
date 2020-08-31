# HDCollectionView

![](https://img.shields.io/badge/platform-iOS-green.svg)
![](https://img.shields.io/badge/language-objectiveC-green.svg)
![](https://img.shields.io/badge/support-iOS8+-red.svg)

* [HDCollectionView](#hdcollectionview)
   * [Brief](#brief)
      * [1. features](#1-what-are-the-advantages-of-using-hdcollectionview-to-build-a-sliding-list)
      * [2. installation](#2-installation)
      * [3. how to use](#3-how-to-use)
   * [Requirements](#requirements)
   * [License](#license)
   
TOC Created by [gh-md-toc](https://github.com/ekalinin/github-markdown-toc)

[中文详细说明](https://github.com/donggelaile/HDCollectionView/blob/master/README_CN.md)

[相关文章](https://juejin.im/post/5d50c664f265da03e71ae6a6)

如果图片挂了，搬个梯子就好了。(或者看[这里](https://juejin.im/post/5d50c664f265da03e71ae6a6))

## now supports diff operation
## Compatible with Swift, demo at [here](https://github.com/donggelaile/HDCVSwiftTest)

See separate components for [HDListViewDiffer](https://github.com/donggelaile/HDListViewDiffer). The effect is as follows:

|Description | Examples | Description | Examples |
|:----:|:------:|:----:|:------:|
System flowLayout | <img src="https://tva1.sinaimg.cn/large/006y8mN6gy1g88cxmv9vpg307u0hldm3.gif" > | Waterfall stream loading more | <img src="https://tva1.sinaimg.cn/large/006y8mN6gy1g88ctadvmig307u0hl7wh.gif" > |
| Alignment delete | <img src="https://tva1.sinaimg.cn/large/006y8mN6gy1g88a47y18qg307u0hljy8.gif" > | Waterfall Stream Delete/Exchange | <img src="https://tva1.sinaimg.cn/large/006y8mN6gy1g88a8whe12g307u0hlduo.gif" > |
HDYogaFlowLayout Delete/Exchange | <img src="https://tva1.sinaimg.cn/large/006y8mN6gy1g88ab9hha9g307u0hlk43.gif" > | Horizontal scroll diff | <img src="https://tva1.sinaimg.cn/large/006y8mN6gy1g88ah0qgdjg307u0hlnij.gif" > |


For more results, please download demo to test yourself.


## Partial static page screenshot
|Description | Examples | Description | Examples |
|:----:|:------:|:----:|:------:|
| Overview | <img src="https://i.loli.net/2019/06/12/5d00b375c561e21723.gif" width="375" height="auto"> | Simple to use | <img src="https://i.loli.net/2019/06/12/5d00b3770d5df68735.gif" width="375" height="auto"> |
|cell center alignment| <img src="https://tva1.sinaimg.cn/large/006y8mN6gy1g6gnv5cv8oj30ku0byglp.jpg" width="375" height="auto"> | cell left aligned | <img src="https://tva1.sinaimg.cn/large/006y8mN6gy1g6gnw0784sj30ku0bydfy.jpg" width="375" height="auto"> |
|cell justification | <img src="https://tva1.sinaimg.cn/large/006y8mN6gy1g6gnwfghwqj30ku0bydfz.jpg" width="375" height="auto"> | cell right alignment | <img src="https://tva1.sinaimg.cn/large/006y8mN6gy1g6gnwtjl14j30km0c23ym.jpg" width="375" height="auto"> |
| Vertical inclusion horizontal | <img src="https://i.loli.net/2019/06/12/5d00b3789d7e575580.gif" width="375" height="auto"> | Horizontal suspension | <img src="https://i.loli.net/2019/06/12/5d00b37bd968d77225.gif" width="375" height="auto"> |
| one - N | <img src="https://tva1.sinaimg.cn/large/006y8mN6ly1g9enkcob6ug30850f7u0x.gif" width="375" height="auto"> | Car Home | <img src="https://i.loli.net/2019/06/12/5d00b37f68d3377556.gif" width="375" height="auto"> |
| QQ Contact | <img src= "https://i.loli.net/2019/06/12/5d00b37a42abf21786.gif" width="375" height="auto"> |  |

## Brief
HDCollectionView is used to quickly build an efficient and flexible listView component, which basically realizes various layouts that are common at present.

### 1. What are the advantages of using HDCollectionView to build a sliding list?
* Data driven, flexible additions and deletions, no need to manually register any views
* Efficiently find the set of attributes that the current screen needs to display, without fear of oversized data
* Based on [Yoga](https://github.com/facebook/yoga)(flexbox), it implements streaming layout and can completely replace the system's flowLayout
* chain makers support
* Customizable waterfall flow layout for each row/column, waterfall stream loading more data for incremental calculation
* Support for specifying any of the header segments to float, permanently float / laterally slide the left suspension
* Support cell height automatic calculation / cache, support AutoLayout calculation or hdSizeThatFits way to return
* Easily add decorationView (decorative view)
* Different layouts can be used for each segment (for example, the first segment uses the regular layout, the second segment uses the waterfall flow layout, refer to the Taobao homepage)
* Supports caching the frame of all child views of the cell
* Unified cell/header/footer/decoration callback, unified UI update
* Horizontal and vertical sliding support

### 2, installation
```ruby
Pod 'HDCollectionView'
```
Can't find, please execute ```pod repo update ``` first.

### 3, how to use

1, first, initialize and add to the parent view
```
HDCollectionView* listV = [HDCollectionView hd_makeHDCollectionView:^(HDCollectionViewMaker *maker){
    Maker.hd_frame(self.view.bounds);
}];
[self.view addSubview:listV];
```
2. It is recommended to add the following code to Code Snippet
```
/ / The segment cell data source
NSMutableArray *cellModelArr = @[].mutableCopy;
NSInteger cellCount = <#NSInteger cellCount#>;
For (int i =0; i<cellCount; i++) {
    HDCellModel *model = [HDCellModel new];
    model.orgData = <#id someModel#>;
    model.cellSize = CGSizeMake(<#CGFloat width#>, <#CGFloat height#>);
    model.cellClassStr = <#NSString* cellClassStr#>;
    [cellModelArr addObject:model];
}

/ / The layout of the paragraph
HDYogaFlowLayout *layout = [HDYogaFlowLayout new];
layout.secInset = UIEdgeInsetsMake(<#CGFloat top#>, <#CGFloat left#>, <#CGFloat bottom#>, <#CGFloat right#>);
Layout.justify = YGJustifySpaceBetween;
layout.verticalGap = <#CGFloat verticalGap#>;
layout.horizontalGap = <#CGFloat horizontalGap#>;
layout.headerSize = CGSizeMake(<#CGFloat width#>, <#CGFloat height#>);
layout.footerSize = CGSizeMake(<#CGFloat width#>, <#CGFloat height#>);

/ / All data encapsulation of the segment
HDSectionModel *secModel = [HDSectionModel new];
secModel.sectionHeaderClassStr = <#NSString* headerClassStr#>;
secModel.sectionFooterClassStr = <#NSString* footerClassStr#>;
secModel.headerObj = nil;
secModel.footerObj = nil;
secModel.headerTopStopType = HDHeaderStopOnTopTypeNone;
secModel.isNeedAutoCountCellHW = YES;
secModel.sectionDataArr = cellModelArr;
secModel.layout = layout;
```
How to add: Copy the above code to any Xcode file -> select the above code -> right click -> select Create Code Snippet -> fill in title and completion shortCut -> restart Xcode. Then just hit the completion stubCut anywhere in Xcode.

When you create obj, you can also use chain makers, just like
```
HDCellModel *model = HDMakeCellModelChain
.hd_orgData(@(i).stringValue)
.hd_cellSize(CGSizeMake(self.view.frame.size.width/2, 50))
.hd_cellClassStr(@"DemoVC1Cell")
.hd_generateObj;

HDYogaFlowLayout *layout = HDMakeYogaFlowLayoutChain
.hd_secInset(UIEdgeInsetsZero)
.hd_justify(YGJustifySpaceBetween)
.hd_headerSize(CGSizeMake([UIScreen mainScreen].bounds.size.width, 50))
.hd_footerSize(CGSizeMake([UIScreen mainScreen].bounds.size.width, 50))
.hd_generateObj;

HDSectionModel *secModel = HDMakeSecModelChain
.hd_sectionHeaderClassStr(@"DemoVC1Header")
.hd_headerTopStopType(HDHeaderStopOnTopTypeNone)
.hd_sectionDataArr(cellModelArr)
.hd_layout(layout)
.hd_generateObj;

```
see more info in DemoVC4

3, set the data
```
[listV hd_setAllDataArr:@[secModel]];
```

Well, the shelf that takes a normal sliding list in the future only needs to be done in one minute, and the rest is to implement the cell.

## Requirements
iOS8+

## License

HDCollectionView is available under the MIT license. See the LICENSE file for more info.
