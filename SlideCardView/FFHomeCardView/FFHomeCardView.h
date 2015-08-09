//
//  FFHomeCardView.h
//  FastFood
//
//  Created by justinjing on 15/8/5.
//  Copyright (c) 2015年 WDK. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CardViewCustomMacro.h"

@class FFHomeCardView;

@protocol FFHomeCardViewDelegate <NSObject>

- (void)tagsView:(FFHomeCardView *)cardView didSelectIndex:(int)index;

@end


@interface FFHomeCardView : UIView

@property (nonatomic,strong) NSArray *imgNameArray;
@property (nonatomic,assign) id <FFHomeCardViewDelegate> delegate;

- (id)initWithFrame:(CGRect)frame img:(NSArray *)imgName;

@end



