# HDCollectionView

![](https://img.shields.io/badge/platform-iOS-green.svg)
![](https://img.shields.io/badge/language-objectiveC-green.svg)
![](https://img.shields.io/badge/support-iOS8+-red.svg)

## 部分demo截图
![](https://i.loli.net/2019/06/12/5d00b375c561e21723.gif)
![](https://i.loli.net/2019/06/12/5d00b3770d5df68735.gif)
![](https://i.loli.net/2019/06/12/5d00b3789d7e575580.gif)
![](https://i.loli.net/2019/06/12/5d00b37bd968d77225.gif)
![](https://i.loli.net/2019/06/12/5d00b37d98c2922733.gif)
![](https://i.loli.net/2019/06/12/5d00b37f68d3377556.gif)
![](https://i.loli.net/2019/06/12/5d00b37a42abf21786.gif)

## 简述
HDCollectionView是用于快速搭建高效灵活的滑动列表组件，基本上可以实现目前常见的各种滑动布局。

### 1、为什么创建这个库?
在日常开发及项目维护中，变更较多的一般都是UI层。因此，如何高效搭建一个滑动列表页，并且让该页面后期易于维护，是提交开发效率重要因素。而对于一些底层基础库，譬如网络层、持久化层等，一旦沉淀下来将很少变更。因此，UI层的构建速率及维护成本对开发整体的开发效率有很大的影响。

### 2、使用HDCollectionView来搭建滑动列表有哪些优势？
* 数据驱动，灵活增删，无需手动注册任何view
* 高效查找当前屏幕需要展示的属性集合，无惧超大数据
* 基于[Yoga](https://github.com/facebook/yoga)(flexbox),实现了流式布局，完全可以替代系统的flowLayout
* 可自定义每行/每列 所占比例的瀑布流布局、瀑布流加载更多数据为增量计算
* 支持指定任一 header 段内悬浮、永久悬浮/ 横向滑动左部悬浮
* 刷新界面可指定RunloopMode
* 支持cell高度自动计算/缓存,支持AutoLayout计算或hdSizeThatFits方式返回
* 轻松添加decorationView(装饰view)
* 每段可使用不同布局(比如第1段使用常规布局，第2段使用瀑布流布局，参考淘宝首页)
* 支持缓存cell所有子view的frame
* 统一cell/header/footer/decoration回调，统一UI更新
* 横纵向滑动支持
### 3、详细描述
####  3.1、数据驱动
HDCollectionView每段的信息都包含在HDSectionModel中，更改对应信息即会在UI上做出相应变更。系统的collectionView对信息的收集散落在多个delegate及dataSource的回调中，这体现了接口分离的设计原则。但是对我们来说也有很多不便之处。其一，每次使用collectionView无疑要创建N多相同的方法来实现相关代理。这并不是最难受的，最难受的是你在各个返回函数的写了一些判断逻辑或一些硬编码。当这个页面需要改动，比如在某个位置插入一个新的样式。此时的修改就会让你如履薄冰，你要到每个回调中去更改相应的逻辑，而且要保证完全对应。如果当时搞的是硬编码的话，此时的修改无疑相当蛋疼。而对于HDCollectionView来说，你只需要在相应的HDSectionModel对应位置中加入新的HDCellModel即可。HDSectionModel将散落的信息收集到了一起，一改则全改，让你在同一时间关注更少的信息，维护明显更加轻松。
#### 3.2、高效查找
为什么说HDCollectionView会高效查找当前需要显示的属性集合？首先HDCollectionView基于UICollectionViewLayout实现了HDCollectionViewLayout，而一旦基于UICollectionViewLayout就要自行重写
```- (NSArray<UICollectionViewLayoutAttributes *> *)layoutAttributesForElementsInRect:(CGRect)rect```

该函数需要返回的是当前rect内需要展示的属性数据集合,如果说此处我们直接返回所有数据的话，表面上看不会有什么问题。但是当数据量特别大的时候(大于2W，6s真机),此时滑动列表将明显卡顿。很明显系统在拿到这个数组后还要搞事情，如果这里返回的是一个会不断变大的数组，即使系统只是简单的遍历也会变的耗时。因此此处必须返回对应的集合。HDCollectionView最终通过二分查找找到了相关集合并返回，其中还包含瀑布流布局的二分查找及递归搜索，详细查找过程见HDCollectionViewLayout文件。
#### 3.3、基于[Yoga](https://github.com/facebook/yoga)的流式布局
Yoga是facebook对flexbox的C++实现。既然是继承UICollectionViewLayout重写布局，流式布局肯定要重新实现，而用flexbox来做普通流式布局最合适不过了。这里将Yoga与UICollectionView的布局相结合，可以轻松实现一些系统布局无法实现的效果。比如说元素整体左对齐、右对齐、居中对齐等。这使得HDCollectionView无论是做普通布局还是类似标签云的布局都将相当轻松。
#### 3.4、瀑布流
相比于只支持设置列数/行数的瀑布流，HDCollectionView实现了支持指定每列/行比例的瀑布流。更为重要的是，当你上拉加载更多的时候，对于瀑布流的布局计算是增量的。也就是只会计算新增的那部分数据的布局，这对加载大列表瀑布流的性能是有直接影响的。而目前我看到好多开源瀑布流都是重新计算所有数据，这在加载大量数据时无疑会带来性能问题。
#### 3.5、header悬浮
首先，实现header悬浮的原理必然是在滑动时实时计算header需要的frame新值。这样的话就要求
```- (BOOL)shouldInvalidateLayoutForBoundsChange:(CGRect)newBounds```
函数必须返回YES，而一旦此处返回YES，只要一产生滑动就会调用```- (void)prepareLayout```函数。显然在prepareLayout需要判断是否使用缓存数据，如果直接重新计算所有布局的话，那在header悬浮的情况下将产生大量无用的重复计算并且数据量大时卡顿随即产生。为了保持在支持悬浮情况下的高效滑动，HDCollectionView在此处做了缓存判断。随后会调用layoutAttributesForElementsInRect函数，基于上面提到的二分查找，使得HDCollectionView在支持悬浮且超长数据列表情况下的滑动性能依然表现👌。此外，HDCollectionView的header悬浮支持指定任意一个header悬浮或者不悬浮，悬浮的模式分为两种，一种随着该段cell及footer的滑出一起滑出，另一种则为永久悬浮在顶部。最终看起来就像2级悬浮，实现效果类似qq应用中的好友/群聊/设备..栏为永久悬浮，而下面的好友分类header则为普通悬浮。
#### 3.6、指定runloopMode来刷新页面
首先说下为什么需要这个功能。有些时候，当用户触发了上拉加载时，在某一时刻数据返回了。而此时用户手指依然没有离开屏幕，此时刷新页面的话可能会产生瞬间的卡顿。因为刷新需要计算新产生数据的cell的宽高，布局等。为了避免这种情况发生，可以将刷新行为延后执行，而延后的方式则是指定相关刷新函数在NSDefaultRunLoopMode中进行，而默认在主线程的代码是在NSRunLoopCommonModes中进行的。
#### 3.7、关于cell自动算高
当设置某段需要自动算高时，内部在刷新页面前会默认先判断cell是否实现了hdSizeThatFit，实现则以此来决定宽高。否则使用autoLayout计算需要的高度。这里没有使用系统的sizeThatFit来获取高度的原因是当支持悬浮时，滑动就会调用cell的sizeThatFit函数，可能会带来性能问题。
#### 3.8、关于添加decorationView
说实话，对于系统添加decorationView的方式一开始我是拒绝的，后来也是拒绝的。。。先来说下这个view是干啥用的吧，就是当你拿到设计图时，你发现在每一段的一组cell后面都有个整体的背景，无论是放在header/cell/footer上都不是很合适，此时你就需要这个装饰view了。HDCollectionView对装饰view的添加相当简单，你应该不会拒绝。。。
#### 3.9、每段可以使用不同的布局
如果让你实现类似淘宝首页的布局，怎么搞？我们姑且认为上面的一大段都是普通的流式布局，但是滑到下面的时候发现是很明显的瀑布流布局。对于这样的布局我们可能这样做：最底部搞一个使用flowLayout的collectionView，前面的部分照常实现。到瀑布流的时候，在cell上加一个collectionView，然后使用瀑布流layout。然后在滑动的时候在合适的时机设置两个collection的contentOffset属性。重点来了，如果使用HDCollectionView来做的话，就可以忘记前面那些骚操作了，（不过对于一些复杂样式依然得这么做。。）。因为HDCollectionView本身就支持每段使用不同的布局。而且HDCollectionView可以扩展自己的布局，具体可以参考内部实现的HDWaterFlowLayout及HDYogaFlowLayout。理论上这两种布局已经包含了大部分样式。
#### 3.10、cell子view frame缓存
这个特性可以让你使用autolayout来设置布局，但是在实际布局过程中却是用frame布局。相当于用一个tempView设置相应约束，计算后拷贝出其所有子view的frame设置到相同类的view中。最终滑动过程中实现cell的子view只是在设置新的frame，并不需要重新计算。
#### 3.11、统一回调
HDCollectionView对所有子view做了统一的回调封装，在cell/header/footer/decoration中回调到VC简单并且统一。使用协议统一所有cell UI更新函数，方便统一UI设定。
#### 3.12、横纵向滑动支持
HDCollectionView无论是普通布局还是瀑布流布局，均支持横向或纵向滑动。对于悬停，纵向滑动为顶部悬浮。横向滑动为左部悬浮。

### 4、安装
```ruby
pod 'HDCollectionView'
```
#### 并打开 use_frameworks!
找不到请先执行 ```pod repo update ```

1、首先，初始化并加到父view
```
HDCollectionView* listV = [HDCollectionView hd_makeHDCollectionView:^(HDCollectionViewMaker *maker){
    maker.hd_frame(self.view.bounds);
}];
[self.view addSubview:listV];
```
2、建议将以下代码添加到Code Snippet
```
//该段cell数据源
NSMutableArray *cellModelArr = @[].mutableCopy;
NSInteger cellCount = <#NSInteger cellCount#>;
for (int i =0; i<cellCount; i++) {
    HDCellModel *model = [HDCellModel new];
    model.orgData      = <#id someModel#>;
    model.cellSize     = CGSizeMake(<#CGFloat width#>, <#CGFloat height#>);
    model.cellClassStr = <#NSString* cellClassStr#>;
    [cellModelArr addObject:model];
}

//该段layout
HDYogaFlowLayout *layout = [HDYogaFlowLayout new];
layout.secInset      = UIEdgeInsetsMake(<#CGFloat top#>, <#CGFloat left#>, <#CGFloat bottom#>, <#CGFloat right#>);
layout.justify       = YGJustifySpaceBetween;
layout.verticalGap   = <#CGFloat verticalGap#>;
layout.horizontalGap = <#CGFloat horizontalGap#>;
layout.headerSize    = CGSizeMake(<#CGFloat width#>, <#CGFloat height#>);
layout.footerSize    = CGSizeMake(<#CGFloat width#>, <#CGFloat height#>);

//该段的所有数据封装
HDSectionModel *secModel = [HDSectionModel new];
secModel.sectionHeaderClassStr    = <#NSString* headerClassStr#>;
secModel.sectionFooterClassStr    = <#NSString* footerClassStr#>;
secModel.headerObj                = nil;
secModel.footerObj                = nil;
secModel.headerTopStopType        = HDHeaderStopOnTopTypeNone;
secModel.isNeedAutoCountCellHW    = NO;
secModel.sectionDataArr           = cellModelArr;
secModel.layout                   = layout;
```
如何添加：拷贝以上代码到Xcode任意文件中->选中以上代码->右击->选择Create Code Snippet ->填写title及completion shortCut ->重启Xcode。然后就在Xcode任意位置打刚刚的completion shortCut。

3、设置数据
```
[listV hd_setAllDataArr:@[secsecModel].mutableCopy];
```
嗯，以后搭一个普通滑动列表的架子只需要在一分钟之内搞定，剩下的事就是去实现cell了。

### 5、一些其他布局
1、前面提到了QQ联系人页面，这个页面相对来说还是比较典型的。支持横向滑动切换栏目，纵向滑动时 栏目view 会在顶部悬浮，子view的header也会悬浮。HDCollectionView借助轮子[JXCategoryView](https://github.com/pujiaxin33/JXCategoryView)实现了QQ联系人页面，并封装到了HDMultipleScrollListView中。由于依赖了JXCategoryView,所以HDMultipleScrollListView并没有放到pod库中，因此如果使用的话需要手动拖入代码并安装JXCategoryView。

2、对于淘宝首页这种页面，可以直接用一个HDCollectionView来实现，也可以用HDScrollJoinView来实现。HDScrollJoinView是一个完全独立的类，不依赖于其他任何代码。但是由于只有一个类所以直接放到了HDCollectionView库中。HDScrollJoinView主要是用来衔接多个scrollView的滑动的类。对于一些新闻详情页，往往是上面是webview(详情)，底部是原生的view(评论，跟帖)。用一个滑动列表来实现的话可能需要拉大webview的frame为其contentSize，这样会导致webview很大时内存过高。HDScrollJoinView可以衔接任意个数滑动view，任意位置插入滑动view，且内部支持两种悬浮。这里面比较关键的是HDScrollJoinView不会无限拉大子滑动view的frame。而是保持其frame最大值为最底部view frame。这在很大程度上控制了内存问题及滑动view衔接问题。

##### 其他使用详情参见源码及demo,源码API已经做了尽量多的注释

### 6、其它
Yoga计算的view坐标的时候默认对frame的x,y值进行了取整操作，且没有开放参数来设置不取整。因此，在精度计算要求较高的情况可能会出现1像素没有对齐的现象。如需要去掉取整可以找到Yoga.cpp文件，将3418行的else取整部分逻辑注释即可。

## Requirements
iOS8+

## License

HDCollectionView is available under the MIT license. See the LICENSE file for more info.
