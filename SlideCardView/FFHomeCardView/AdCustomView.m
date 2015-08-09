//
//  AdCustomView.m
//  FastFood
//
//  Created by justinjing on 15/7/15.
//  Copyright (c) 2015年 justinjing. All rights reserved.
//

#import "AdCustomView.h"
#import "UIViewAdditions.h"
#import "CardViewCustomMacro.h"


#define xOffsetPadding 8

@interface AdCustomView()
@property(nonatomic,strong) UIImageView *centerImageView;
@end

@implementation AdCustomView

- (instancetype)init {
    self = [super init];
    if (self) {
        [self setup];
    }
    return self;
}

- (void)setup {
    self.layer.borderColor= [UIColor lightGrayColor].CGColor;
    self.layer.borderWidth=0.5;
    self.clipsToBounds = YES;
    self.layer.cornerRadius = 6.0;
    [self attachSingleTouchActionWithtarget:self action:@selector(onselfTouch)];
}

- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self)
    {
        [self setup];
        [self initTheView];
    }
    return self;
}

- (void)initTheView {
    
    [self addSubview:({self.centerImageView=[[UIImageView alloc]init];
        self.centerImageView.layer.masksToBounds = YES;
        self.centerImageView.layer.cornerRadius = 8;
        self.centerImageView.contentMode = UIViewContentModeScaleAspectFill;
        self.centerImageView.clipsToBounds = YES;
        self.centerImageView;
    })];
}

- (void)layoutSubviews {
    [super layoutSubviews];
    float width = self.bounds.size.width;
    float height = self.bounds.size.height;
    self.centerImageView.frame = CGRectMake(xOffsetPadding,5,width-2*xOffsetPadding,height-10);
}

- (void)configureView:(NSString *)imgName{
    self.centerImageView.image = [UIImage imageNamed:imgName];
    [self setNeedsDisplay];
}


-(void)onselfTouch
{
    int index = (int)self.tag;
    if ([self.delegate respondsToSelector:@selector(tagsView:didSelectIndex:)]) {
        [self.delegate tagsView:self didSelectIndex:index];
    }
}

@end
