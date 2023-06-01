# HDListViewDiffer

![](https://img.shields.io/badge/platform-iOS-green.svg)
![](https://img.shields.io/badge/language-objectiveC-green.svg)
![](https://img.shields.io/badge/support-iOS8+-red.svg)

## [相关文章](http://www.cocoachina.com/articles/94615)

## 前言
目前开源的列表diff大多数为swift的,OC版本的很少。IGList通过Objective-C++实现了diff。HDListViewDiffer参考了其思想，简化了diff函数。实现了一个轻量的，简化版本的纯OC diff库。

## 1、什么是 ListViewDiff ?
简单来说，就是查找一个滑动列表(这里指UITableView和UICollectionView)在更新数据后与更新数据之前的变化，如同git/svn提交新版本时通过diff来查看改变了哪些数据
## 2、为什么要做ListViewDiff ？
1、平时我们想动画 删除/移动/新增 某个cell时，往往需要自己计算变更前后的数据，进而得出相关的indexPath，最终拼凑 deleteRowsAtIndexPaths，insertRowsAtIndexPaths等方法实现。这里的问题在于一旦计算错误将会崩溃。且每次均需要自己计算并维护。通过HDListViewDiffer来变更数据则基本不必担心以上问题，你仅仅需要告知变化前后的数据源即可，内部会自动计算变更内容并拼凑动画函数。

2、通过diff算法计算后，可以获得你增删改了哪些数据，然后可以通过 performBatchUpdates 来进行UI的更新，进而替代reloadData方法。好处就是diff后的更新是有针对性的更新，并且自带动画。而reloadData为全量更新，无动画。

## 3、使用效果
|说明 | 示例 | 说明 | 示例|
|:----:|:------:|:----:|:------:|
| UICollectionView |  <img src="https://tva1.sinaimg.cn/large/006y8mN6gy1g889a3uvkeg307u0hlhdt.gif" > | UITableView |  <img src="https://tva1.sinaimg.cn/large/006y8mN6gy1g889gv2fj3g307u0hln6z.gif" > |

## 4、安装使用
```ruby
pod 'HDListViewDiffer'
```
包含类别头文件,调用类别提供的方法即可，详见DEMO

## 5、全面支持[HDCollectionView](https://github.com/donggelaile/HDCollectionView) （当然也支持任意UICollectionView及UITableView）
在HDCollectionView中使用diff时，你仅仅需要指定是否需要动画变更数据即可，接口将更加简单。
### 顺便放上部分HDCollectionView中的效果
|说明 | 示例 | 说明 | 示例|
|:----:|:------:|:----:|:------:|
| 中间对齐删除 |  <img src="https://tva1.sinaimg.cn/large/006y8mN6gy1g88a47y18qg307u0hljy8.gif" > | 瀑布流删除/交换 |  <img src="https://tva1.sinaimg.cn/large/006y8mN6gy1g88a8whe12g307u0hlduo.gif" > |
| HDYogaFlowLayout删除/交换 |  <img src="https://tva1.sinaimg.cn/large/006y8mN6gy1g88ab9hha9g307u0hlk43.gif" > | 横向滚动diff |  <img src="https://tva1.sinaimg.cn/large/006y8mN6gy1g88ah0qgdjg307u0hlnij.gif" > |

## 其他
理论支持iOS7+ ,个人真机有限，请自行测试


## License

HDListViewDiffer is available under the MIT license. See the LICENSE file for more info.
