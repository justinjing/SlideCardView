# SlideCardView
左右滑动卡片

### 本代码主要引入了对CABasicAnimation扩展，block回调
``` Object-c
    #import "CAAnimation+Blocks.h"
```
### CABasicAnimation block回调
CABasicAnimation代码块block回调代码，例如：
``` Object-c
 CABasicAnimation *anotherAnimation = [CABasicAnimation animationWithKeyPath:@"position.x"];
    anotherAnimation.fromValue = @(self.anotherImageView.layer.position.x);
    anotherAnimation.toValue = @(FF_SCREEN_WIDTH);
    anotherAnimation.duration = 1;
    anotherAnimation.autoreverses = NO;
    [anotherAnimation setCompletion:^(BOOL finished) {
        [self animationRepeat];
    }];
    [self.anotherImageView.layer addAnimation:anotherAnimation forKey:@"1"];
```
### 示例图片
![demo](https://github.com/justinjing/SlideCardView/blob/master/Screenshot/demo.gif)
