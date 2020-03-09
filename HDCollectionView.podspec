#
# Be sure to run `pod lib lint HDCollectionView.podspec' to ensure this is a
# valid spec before submitting.
#
# Any lines starting with a # are optional, but their use is encouraged
# To learn more about a Podspec see https://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |s|
  s.name             = 'HDCollectionView'
  s.version          = '0.6.0'
  s.summary          = '快速构建灵活易用滑动列表的第三方库'

# This description is used to generate tags and improve search results.
#   * Think: What does it do? Why did you write it? What is the focus?
#   * Try to keep it short, snappy and to the point.
#   * Write the description between the DESC delimiters below.
#   * Finally, don't worry about the indent, CocoaPods strips it!

  s.description      = <<-DESC
  An efficient and flexible listView (data driven). Based on Flexbox, it supports floating, waterfall, decorative view, horizontal sliding, segmented layout, and various alignments. Support diff refresh, animation update UI
  数据驱动(data driven)的高效灵活列表。基于Flexbox，支持 悬浮、瀑布流、装饰view、横向滑动、分段布局、各种对齐方式。支持链式语法初始化。支持diff刷新，动画更新UI
                       DESC

  s.homepage         = 'https://github.com/donggelaile/HDCollectionView.git'
  # s.screenshots     = 'www.example.com/screenshots_1', 'www.example.com/screenshots_2'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 'donggelaile' => '519623144@qq.com' }
  s.source           = { :git => 'https://github.com/donggelaile/HDCollectionView.git', :tag => s.version.to_s }
  # s.social_media_url = 'https://twitter.com/<TWITTER_USERNAME>'

  s.ios.deployment_target = '8.0'

  s.source_files = 'HDCollectionView/Classes/**/*'
  
  # s.resource_bundles = {
  #   'HDCollectionView' => ['HDCollectionView/Assets/*.png']
  # }

  # s.public_header_files = 'Pod/Classes/**/*.h'
  # s.frameworks = 'UIKit', 'MapKit'
  s.user_target_xcconfig = { 'CLANG_ALLOW_NON_MODULAR_INCLUDES_IN_FRAMEWORK_MODULES' => 'YES' }
  s.dependency 'Yoga', '~> 1.9.0'
  s.dependency 'HDListViewDiffer'
end
