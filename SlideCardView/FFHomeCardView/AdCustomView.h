//
//  AdCustomView.h
//  FastFood
//
//  Created by justinjing on 15/7/15.
//  Copyright (c) 2015年 justinjing. All rights reserved.
//

#import <UIKit/UIKit.h>

@class AdCustomView;

@protocol AdCustomViewDelegate <NSObject>

- (void)tagsView:(AdCustomView *)cardView didSelectIndex:(int)index;

@end

@interface AdCustomView : UIView

@property (nonatomic,assign) id <AdCustomViewDelegate> delegate;

- (void)configureView:(NSString *)imgName;

@end
