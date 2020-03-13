# SJAttributesFactory

### Objc
```ruby
pod 'SJAttributesFactory'
```
___

### Swift
```ruby
pod 'SJAttributesStringMaker'
```
___


use in swift:

```Swift
    let text = NSAttributedString.sj.makeText { (make) in
        make.font(.boldSystemFont(ofSize: 20)).textColor(.black).lineSpacing(8)
        make.append("Hello world!")
    }
    
    // It's equivalent to below code.
    
    let paragraphStyle = NSParagraphStyle.default.mutableCopy() as! NSMutableParagraphStyle
    paragraphStyle.lineSpacing = 8
    let attributes = [NSAttributedString.Key.font:UIFont.boldSystemFont(ofSize: 20),
                      NSAttributedString.Key.foregroundColor:UIColor.black,
                      NSAttributedString.Key.paragraphStyle:paragraphStyle]
    let text1 = NSAttributedString.init(string: "Hello world!", attributes: attributes)
```

___

use in Objc:

```Objective-C
    NSAttributedString *text = [NSAttributedString sj_UIKitText:^(id<SJUIKitTextMakerProtocol>  _Nonnull make) {
    make.font([UIFont boldSystemFontOfSize:20]).textColor(UIColor.blackColor).lineSpacing(8);
    
    make.append(@":Image -");
    make.appendImage(^(id<SJUTImageAttachment>  _Nonnull make) {
        make.image = [UIImage imageNamed:@"sample2"];
        make.bounds = CGRectMake(0, 0, 30, 30);
    });
    
    make.append(@"\n");
    make.append(@":UnderLine").underLine(^(id<SJUTDecoration>  _Nonnull make) {
        make.style = NSUnderlineStyleSingle;
        make.color = UIColor.greenColor;
    });
    
    make.append(@"\n");
    make.append(@":Strikethrough").strikethrough(^(id<SJUTDecoration>  _Nonnull make) {
        make.style = NSUnderlineStyleSingle;
        make.color = UIColor.greenColor;
    });
    
    make.append(@"\n");
    make.append(@":BackgroundColor").backgroundColor(UIColor.greenColor);
    
    make.append(@"\n");
    make.append(@":Kern").kern(6);
    
    make.append(@"\n");
    make.append(@":Shadow").shadow(^(NSShadow * _Nonnull make) {
        make.shadowColor = [UIColor redColor];
        make.shadowOffset = CGSizeMake(0, 1);
        make.shadowBlurRadius = 5;
    });
    
    make.append(@"\n");
    make.append(@":Stroke").stroke(^(id<SJUTStroke>  _Nonnull make) {
        make.color = [UIColor greenColor];
        make.width = 1;
    });
    
    make.append(@"\n");
    make.append(@"oOo").font([UIFont boldSystemFontOfSize:25]).alignment(NSTextAlignmentCenter);
    
    make.append(@"\n");
    make.append(@"Regular Expression").backgroundColor([UIColor greenColor]);
    make.regex(@"Regular").update(^(id<SJUTAttributesProtocol>  _Nonnull make) {
        make.font([UIFont boldSystemFontOfSize:25]).textColor(UIColor.purpleColor);
    });
    
    make.regex(@"ss").replaceWithString(@"SS").backgroundColor([UIColor greenColor]);
    make.regex(@"on").replaceWithText(^(id<SJUIKitTextMakerProtocol>  _Nonnull make) {
        make.append(@"ON😆").textColor([UIColor redColor]).backgroundColor([UIColor greenColor]).font([UIFont boldSystemFontOfSize:30]);
    });
 }];

```

## Contact
* Email: changsanjiang@gmail.com
* QQ: 1779609779
* QQGroup: 719616775 
<img src="https://github.com/changsanjiang/SJVideoPlayer/blob/master/SJVideoPlayerProject/SJVideoPlayerProject/Group.jpeg" width="200"  />
