//
//  ViewController.m
//  SlideCardView
//
//  Created by justinjing on 15/8/7.
//  Copyright (c) 2015年 justinjing. All rights reserved.
//

#import "ViewController.h"
#import "FFHomeCardView.h"
#import "CAAnimation+Blocks.h"

@interface ViewController ()<FFHomeCardViewDelegate>

@property (nonatomic, strong) NSArray *imgNameArray;
@property (nonatomic, strong) UIImageView *testImageView;
@property (nonatomic, strong) UIImageView *anotherImageView;
@property (nonatomic, assign) BOOL directIsRight;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    self.imgNameArray = @[@"card_banner0",@"card_banner1",@"card_banner2"];
    
    [self.view addSubview:({FFHomeCardView *cardView = [[FFHomeCardView alloc]initWithFrame:CGRectMake(0,20,FF_SCREEN_WIDTH,258) img:self.imgNameArray];
        cardView.delegate = self;
        cardView;
    })];
    
    
    [self.view addSubview:({FFHomeCardView *cardView = [[FFHomeCardView alloc]initWithFrame:CGRectMake(0,20,FF_SCREEN_WIDTH,258) img:self.imgNameArray];
        cardView.delegate = self;
        cardView;
    })];
    
    
    
    [self.view addSubview:({self.testImageView = [[UIImageView alloc]initWithFrame:CGRectMake(20,320,100,88)];
        self.testImageView.image = [UIImage imageNamed:@"attention"];
        self.testImageView;
    })];
    
    
    [self.view addSubview:({self.anotherImageView = [[UIImageView alloc]initWithFrame:CGRectMake(0,CGRectGetMaxY(self.testImageView.frame)+20,100,67)];
        self.anotherImageView.image = [UIImage imageNamed:@"car"];
        self.anotherImageView.layer.cornerRadius = 7;
        self.anotherImageView.layer.masksToBounds = YES;
        self.anotherImageView;
    })];
}


- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    [self performSelector:@selector(runAnimation:) withObject:nil afterDelay:1.0];
}


#pragma mark -
#pragma mark FFHomeCardViewDelegate

- (void)tagsView:(FFHomeCardView *)cardView didSelectIndex:(int)index
{
    NSLog(@"点击了第%d页",index);
}



- (void)runAnimation:(id)unused
{
    // Create a shaking animation that rotates a bit counter clockwisely and then rotates another
    // bit clockwisely and repeats. Basically, add a new rotation animation in the opposite
    // direction at the completion of each rotation animation.
    const CGFloat duration = 0.1f;
    const CGFloat angle = 0.03f;
    NSNumber *angleR = @(angle);
    NSNumber *angleL = @(-angle);
    
    CABasicAnimation *animationL = [CABasicAnimation animationWithKeyPath:@"transform.rotation.z"];
    CABasicAnimation *animationR = [CABasicAnimation animationWithKeyPath:@"transform.rotation.z"];
    
    void (^completionR)(BOOL) = ^(BOOL finished) {
        [self.testImageView.layer setValue:angleL forKey:@"transform.rotation.z"];
        [self.testImageView.layer addAnimation:animationL forKey:@"L"]; // Add rotation animation in the opposite direction.
    };
    
    void (^completionL)(BOOL) = ^(BOOL finished) {
        [self.testImageView.layer setValue:angleR forKey:@"transform.rotation.z"];
        [self.testImageView.layer addAnimation:animationR forKey:@"R"];
    };
    
    animationL.fromValue = angleR;
    animationL.toValue = angleL;
    animationL.duration = duration;
    animationL.completion = completionL; // Set completion to perform rotation in opposite direction upon completion.
    
    animationR.fromValue = angleL;
    animationR.toValue = angleR;
    animationR.duration = duration;
    animationR.completion = completionR;
    
    // First animation performs half rotation and then proceeds to enter the loop by playing animationL in its completion block
    CABasicAnimation *animation = [CABasicAnimation animationWithKeyPath:@"transform.rotation.z"];
    animation.fromValue = @0.f;
    animation.toValue = angleR;
    animation.duration = duration/2;
    animation.completion = completionR;
    
    [self.testImageView.layer setValue:angleR forKey:@"transform.rotation.z"];
    [self.testImageView.layer addAnimation:animation forKey:@"0"];
    
    // Setup another animation just to show a different coding style
    self.directIsRight = YES;
    CABasicAnimation *anotherAnimation = [CABasicAnimation animationWithKeyPath:@"position.x"];
    anotherAnimation.fromValue = @(self.anotherImageView.layer.position.x);
    anotherAnimation.toValue = @(FF_SCREEN_WIDTH);
    anotherAnimation.duration = 1;
    [anotherAnimation setCompletion:^(BOOL finished) {
        [self animationRepeat];
    }];
    [self.anotherImageView.layer addAnimation:anotherAnimation forKey:@"1"];
}

-(void)animationRepeat
{
    self.directIsRight = !self.directIsRight;
    CABasicAnimation *oneMoreAnimation = [CABasicAnimation animationWithKeyPath:@"position.x"];
    if (!self.directIsRight) {
        oneMoreAnimation.fromValue = @(FF_SCREEN_WIDTH);
        oneMoreAnimation.toValue = @(self.anotherImageView.layer.position.x);
    }
    else
    {
        oneMoreAnimation.fromValue = @(self.anotherImageView.layer.position.x);
        oneMoreAnimation.toValue = @(FF_SCREEN_WIDTH);
    }
 
    oneMoreAnimation.duration = 1;
    oneMoreAnimation.autoreverses = NO;
    [oneMoreAnimation setCompletion:^(BOOL finished) {
        [self animationRepeat];
    }];
    [self.anotherImageView.layer addAnimation:oneMoreAnimation forKey:@"1"];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
