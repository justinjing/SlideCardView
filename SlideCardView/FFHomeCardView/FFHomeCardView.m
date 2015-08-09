//
//  FFHomeCardView.m
//  FastFood
//
//  Created by justinjing on 15/8/5.
//  Copyright (c) 2015年 WDK. All rights reserved.
//

#import "FFHomeCardView.h"
#import "AdCustomView.h"
#import "CardViewCustomMacro.h"
#import "UIViewAdditions.h"


#define xOffsetPadding 16
#define yOffset 5
#define internalViewHeight 225
#define kStartRotation          60
#define kHorizontalEdgeOffset   190
#define kRotationFactor         0.25f


@interface FFHomeCardView ()<AdCustomViewDelegate>

@property (nonatomic,strong) NSMutableArray *viewArray;

@end

@implementation FFHomeCardView

- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self)
    {
        self.imgNameArray = [[NSArray alloc] init];
        [self initTheView];
    }
    return self;
}

- (id)initWithFrame:(CGRect)frame  img:(NSArray *)imgName{

    self = [super initWithFrame:frame];
    if (self)
    {
        self.imgNameArray = imgName;
        [self initTheView];
    }
    return self;

}

- (CGFloat)scaleAtIndex:(NSInteger)index {
    return 1 - (self.imgNameArray.count-index-1)*0.05;
}

- (CGPoint)centerAtIndex:(NSInteger)index {
    return CGPointMake(FF_SCREEN_WIDTH*0.5, internalViewHeight*0.5+index*(yOffset+8)-4);
}

- (void)initTheView
{
    self.backgroundColor = [UIColor whiteColor];
    _viewArray = [[NSMutableArray alloc] initWithCapacity:3];

    [self.imgNameArray enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        AdCustomView *tempView=[[AdCustomView alloc]initWithFrame: CGRectMake(xOffsetPadding,0,FF_SCREEN_WIDTH-xOffsetPadding,internalViewHeight)];
        tempView.backgroundColor = [UIColor whiteColor];
        tempView.tag= idx;
        CGFloat scale = [self scaleAtIndex:idx];
        [tempView scaleTo:scale];
        tempView.center = [self centerAtIndex:idx];
        tempView.delegate = self;
        [tempView attachSwipeActionWithtarget:self action:@selector(handleSwipeFrom:)];
        [self addSubview:tempView];
        [tempView configureView:self.imgNameArray[idx]];
        [_viewArray addObject:tempView];
     }];
}

- (void)handleSwipeFrom:(UISwipeGestureRecognizer *)recognizer{
    
    UIView *lastview=(UIView *)[_viewArray lastObject];//起始帧和终了帧的设定
    [UIView animateWithDuration:0.3f animations:^{
        
         if (recognizer.direction==UISwipeGestureRecognizerDirectionLeft)
         {
            CGPoint demoShift = CGPointMake(-kHorizontalEdgeOffset,lastview.center.y);
            lastview.center = demoShift;
            lastview.transform = CGAffineTransformMakeRotation(-kStartRotation * M_PI * kRotationFactor/180);
         }
         else if (recognizer.direction==UISwipeGestureRecognizerDirectionRight)
         {
             CGPoint demoShift = CGPointMake(2*FF_SCREEN_WIDTH-kHorizontalEdgeOffset, lastview.center.y);
             lastview.center = demoShift;
             lastview.transform = CGAffineTransformMakeRotation(kStartRotation * M_PI * kRotationFactor/180);
        }
    } completion: ^(BOOL finished) {
        
        lastview.transform = CGAffineTransformIdentity;
        lastview.center = [self centerAtIndex:0];
        [lastview scaleTo:[self scaleAtIndex:0]];
        
        NSMutableArray *arr = [[NSMutableArray alloc] initWithCapacity:4];
        
        [arr addObject:[_viewArray lastObject]];

        for (int i=0; i<[_viewArray count]-1; i++) {
            [arr addObject:[_viewArray objectAtIndex:i]];
        }
        
        for (UIView *tempView in _viewArray) {
            [tempView removeFromSuperview];
        }
        
        [_viewArray  removeAllObjects];
        
        [UIView animateWithDuration:0.2 animations:^{
            [self.imgNameArray enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
                AdCustomView *tempView = (AdCustomView *)[arr objectAtIndex:idx];
                [tempView scaleTo:[self scaleAtIndex:idx]];
                tempView.center = [self centerAtIndex:idx];
                [tempView attachSwipeActionWithtarget:self action:@selector(handleSwipeFrom:)];
                [self addSubview:tempView];
                [_viewArray addObject:tempView];
            }];
        }];
    }];
}

#pragma mark -
#pragma mark AdCustomViewDelegate

- (void)tagsView:(AdCustomView *)cardView didSelectIndex:(int)index{
    if ([self.delegate respondsToSelector:@selector(tagsView:didSelectIndex:)]) {
        [self.delegate tagsView:self didSelectIndex:index];
    }
}

@end
