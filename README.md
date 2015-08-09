# SlideCardView
左右滑动卡片

### 代码块
代码块语法遵循标准markdown代码，例如：
``` CABasicAnimation block回调
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

###脚注
