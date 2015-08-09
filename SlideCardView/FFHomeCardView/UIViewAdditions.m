//
//  UIViewAdditions.m
//  DOIT
//
//  Created by justinjing on 15/3/15.
//  Copyright (c) 2015年 流岚. All rights reserved.
//

#import "UIViewAdditions.h"

@implementation UIView (TTCategory)

- (CGFloat)left {
    return self.frame.origin.x;
}

- (void)setLeft:(CGFloat)x {
    CGRect frame = self.frame;
    frame.origin.x = x;
    self.frame = frame;
}

- (CGFloat)top {
    return self.frame.origin.y;
}

- (void)setTop:(CGFloat)y {
    CGRect frame = self.frame;
    frame.origin.y = y;
    self.frame = frame;
}

- (CGFloat)right {
    return self.frame.origin.x + self.frame.size.width;
}

- (void)setRight:(CGFloat)right {
    CGRect frame = self.frame;
    frame.origin.x = right - frame.size.width;
    self.frame = frame;
}

- (CGFloat)bottom {
    return self.frame.origin.y + self.frame.size.height;
}

- (void)setBottom:(CGFloat)bottom {
    CGRect frame = self.frame;
    frame.origin.y = bottom - frame.size.height;
    self.frame = frame;
}

- (CGFloat)centerX {
    return self.center.x;
}

- (void)setCenterX:(CGFloat)centerX {
    self.center = CGPointMake(centerX, self.center.y);
}

- (CGFloat)centerY {
    return self.center.y;
}

- (void)setCenterY:(CGFloat)centerY {
    self.center = CGPointMake(self.center.x, centerY);
}

- (CGFloat)width {
    return self.frame.size.width;
}

- (void)setWidth:(CGFloat)width {
    CGRect frame = self.frame;
    frame.size.width = width;
    self.frame = frame;
}

- (CGFloat)height {
    return self.frame.size.height;
}

- (void)setHeight:(CGFloat)height {
    CGRect frame = self.frame;
    frame.size.height = height;
    self.frame = frame;
}

/**
 * Return the x coordinate on the screen.
 */
- (CGFloat)ttScreenX {
    CGFloat x = 0;
    for (UIView* view = self; view; view = view.superview) {
        x += view.left;
    }
    return x;
}

/**
 * Return the y coordinate on the screen.
 */
- (CGFloat)ttScreenY {
    CGFloat y = 0;
    for (UIView* view = self; view; view = view.superview) {
        y += view.top;
    }
    return y;
}

#ifdef DEBUG

/**
 * Return the x coordinate on the screen.
 *
 * This method is being rejected by Apple due to false-positive private api static analysis.
 *
 * @deprecated
 */
- (CGFloat)screenX {
    return [self ttScreenX];
}

/**
 * Return the y coordinate on the screen.
 *
 * This method is being rejected by Apple due to false-positive private api static analysis.
 *
 * @deprecated
 */
- (CGFloat)screenY {
    return [self ttScreenY];
}

#endif

- (CGFloat)screenViewX {
    CGFloat x = 0;
    for (UIView* view = self; view; view = view.superview) {
        x += view.left;
        
        if ([view isKindOfClass:[UIScrollView class]]) {
            UIScrollView* scrollView = (UIScrollView*)view;
            x -= scrollView.contentOffset.x;
        }
    }
    
    return x;
}

- (CGFloat)screenViewY {
    CGFloat y = 0;
    for (UIView* view = self; view; view = view.superview) {
        y += view.top;
        
        if ([view isKindOfClass:[UIScrollView class]]) {
            UIScrollView* scrollView = (UIScrollView*)view;
            y -= scrollView.contentOffset.y;
        }
    }
    return y;
}

- (CGRect)screenFrame {
    return CGRectMake(self.screenViewX, self.screenViewY, self.width, self.height);
}

- (CGPoint)origin {
    return self.frame.origin;
}

- (void)setOrigin:(CGPoint)origin {
    CGRect frame = self.frame;
    frame.origin = origin;
    self.frame = frame;
}

- (CGSize)size {
    return self.frame.size;
}

- (void)setSize:(CGSize)size {
    CGRect frame = self.frame;
    frame.size = size;
    self.frame = frame;
}

- (CGFloat)orientationWidth {
    return  self.height  ;
}

- (CGFloat)orientationHeight {
    return   self.width ;
}

- (UIView*)descendantOrSelfWithClass:(Class)cls {
    if ([self isKindOfClass:cls])
        return self;
    
    for (UIView* child in self.subviews) {
        UIView* it = [child descendantOrSelfWithClass:cls];
        if (it)
            return it;
    }
    
    return nil;
}

- (UIView*)ancestorOrSelfWithClass:(Class)cls {
    if ([self isKindOfClass:cls]) {
        return self;
    } else if (self.superview) {
        return [self.superview ancestorOrSelfWithClass:cls];
    } else {
        return nil;
    }
}

- (void)removeAllSubviews {
    while (self.subviews.count) {
        UIView* child = self.subviews.lastObject;
        [child removeFromSuperview];
    }
}



- (CGPoint)offsetFromView:(UIView*)otherView {
    CGFloat x = 0, y = 0;
    for (UIView* view = self; view && view != otherView; view = view.superview) {
        x += view.left;
        y += view.top;
    }
    return CGPointMake(x, y);
}

- (CGRect)frameWithKeyboardSubtracted:(CGFloat)plusHeight {
    CGRect frame = self.frame;
    //  if (TTIsKeyboardVisible()) {
    //    CGRect screenFrame = TTScreenBounds();
    //    CGFloat keyboardTop = (screenFrame.size.height - (TTKeyboardHeight() + plusHeight));
    //    CGFloat screenBottom = self.ttScreenY + frame.size.height;
    //    CGFloat diff = screenBottom - keyboardTop;
    //    if (diff > 0) {
    //      frame.size.height -= diff;
    //    }
    //  }
    return frame;
}

- (void)presentAsKeyboardAnimationDidStop {
    CGRect screenFrame = self.frame;//TTScreenBounds();
    CGRect bounds = CGRectMake(0, 0, screenFrame.size.width, self.height);
    CGPoint centerBegin = CGPointMake(floor(screenFrame.size.width/2 - self.width/2),
                                      screenFrame.size.height + floor(self.height/2));
    CGPoint centerEnd = CGPointMake(floor(screenFrame.size.width/2 - self.width/2),
                                    screenFrame.size.height - floor(self.height/2));
    
    NSDictionary* userInfo = [NSDictionary dictionaryWithObjectsAndKeys:
                              [NSValue valueWithCGRect:bounds], UIKeyboardBoundsUserInfoKey,
                              [NSValue valueWithCGPoint:centerBegin], UIKeyboardCenterBeginUserInfoKey,
                              [NSValue valueWithCGPoint:centerEnd], UIKeyboardCenterEndUserInfoKey,
                              nil];
    
    [[NSNotificationCenter defaultCenter] postNotificationName:@"UIKeyboardWillShowNotification"
                                                        object:self userInfo:userInfo];
}

- (void)dismissAsKeyboardAnimationDidStop {
    [self removeFromSuperview];
}

- (void)presentAsKeyboardInView:(UIView*)containingView {
    self.top = containingView.height;
    [containingView addSubview:self];
    
    [UIView beginAnimations:nil context:nil];
    //  [UIView setAnimationDuration:TT_TRANSITION_DURATION];
    [UIView setAnimationDelegate:self];
    [UIView setAnimationDidStopSelector:@selector(presentAsKeyboardAnimationDidStop)];
    self.top -= self.height;
    [UIView commitAnimations];
}

- (void)dismissAsKeyboard:(BOOL)animated {
    CGRect screenFrame =self.frame;// TTScreenBounds();
    CGRect bounds = CGRectMake(0, 0, screenFrame.size.width, self.height);
    CGPoint centerBegin = CGPointMake(floor(screenFrame.size.width/2 - self.width/2),
                                      screenFrame.size.height - floor(self.height/2));
    CGPoint centerEnd = CGPointMake(floor(screenFrame.size.width/2 - self.width/2),
                                    screenFrame.size.height + floor(self.height/2));
    
    NSDictionary* userInfo = [NSDictionary dictionaryWithObjectsAndKeys:
                              [NSValue valueWithCGRect:bounds], UIKeyboardBoundsUserInfoKey,
                              [NSValue valueWithCGPoint:centerBegin], UIKeyboardCenterBeginUserInfoKey,
                              [NSValue valueWithCGPoint:centerEnd], UIKeyboardCenterEndUserInfoKey,
                              nil];
    
    [[NSNotificationCenter defaultCenter] postNotificationName:@"UIKeyboardWillHideNotification"
                                                        object:self userInfo:userInfo];
    
    if (animated) {
        [UIView beginAnimations:nil context:nil];
        //    [UIView setAnimationDuration:TT_TRANSITION_DURATION];
        [UIView setAnimationDelegate:self];
        [UIView setAnimationDidStopSelector:@selector(dismissAsKeyboardAnimationDidStop)];
    }
    
    self.top += self.height;
    
    if (animated) {
        [UIView commitAnimations];
    } else {
        [self dismissAsKeyboardAnimationDidStop];
    }
}

- (UIViewController*)viewController {
    for (UIView* next = [self superview]; next; next = next.superview) {
        UIResponder* nextResponder = [next nextResponder];
        if ([nextResponder isKindOfClass:[UIViewController class]]) {
            return (UIViewController*)nextResponder;
        }
    }
    return nil;
}

- (void)simulateTapAtPoint:(CGPoint)location {
    
}

- (instancetype)initWithSize:(CGSize)size {
    CGRect rect = {
        .size = size
    };
    if (self = [self initWithFrame:rect]) {
        [self setX:0 y:0];
    }
    return self;
}

- (instancetype)initWithSize:(CGSize)size center:(CGPoint)center {
    CGRect rect = {
        .origin.x = center.x - size.width/2,
        .origin.y = center.y - size.height/2,
        .size = size
    };
    if (self = [self initWithFrame:rect]) {
    }
    return self;
}

- (void)setX:(CGFloat)x y:(CGFloat)y {
    CGRect frame = { x, y, self.width, self.height };
    self.frame = frame;
}

- (void)setSize:(CGSize)size center:(CGPoint)center {
    self.frame = CGRectMake(center.x-size.width/2, center.y-size.height/2, size.width, size.height);
}

- (void)moveToLeftTop {
    [self setX:0 y:0];
}

- (void)moveToLeftBottom {
    [self setX:0 y:self.superview.height-self.height];
}

- (void)moveToRightTop {
    [self setX:self.superview.width-self.width y:0];
}

- (void)moveToRightBottom {
    [self setX:self.superview.width-self.width y:self.superview.height-self.height];
}

+ (UIView *)viewWithFrame:(CGRect)frame color:(UIColor *)color {
    UIView *view = [[UIView alloc] initWithFrame:frame];
    view.backgroundColor = color;
    return view;
}

- (void)scaleTo:(CGFloat)scale {
    self.transform = CGAffineTransformScale(CGAffineTransformIdentity, scale, scale);
}

- (void)clipToCircle {
    self.clipsToBounds = YES;
    self.layer.cornerRadius = MIN(self.width, self.height)/2;
}

- (CGFloat)cornerRadius {
    return self.layer.cornerRadius;
}

- (void)setCornerRadius:(CGFloat)cornerRadius {
    self.layer.cornerRadius = cornerRadius;
    self.clipsToBounds = YES;
}

- (void)attachSingleTouchActionWithtarget:(id)target action:(SEL)action
{
    UITapGestureRecognizer *singleTap = [[UITapGestureRecognizer alloc]initWithTarget:target action:action];
    
    self.userInteractionEnabled = YES;
    singleTap.numberOfTouchesRequired = 1;
    singleTap.numberOfTapsRequired = 1;
    singleTap.cancelsTouchesInView = NO;
    [self addGestureRecognizer:singleTap];
}


-(void)attachSwipeActionWithtarget:(id)target action:(SEL)action{
    
    UISwipeGestureRecognizer *recognizer;
    recognizer = [[UISwipeGestureRecognizer alloc] initWithTarget:target action:action];
    [recognizer setDirection:(UISwipeGestureRecognizerDirectionRight)];
    [self addGestureRecognizer:recognizer];
    
    recognizer = [[UISwipeGestureRecognizer alloc] initWithTarget:target action:action];
    [recognizer setDirection:(UISwipeGestureRecognizerDirectionLeft)];
    [self addGestureRecognizer:recognizer];

    
    recognizer = [[UISwipeGestureRecognizer alloc] initWithTarget:target action:action];
    [recognizer setDirection:(UISwipeGestureRecognizerDirectionUp)];
    [self addGestureRecognizer:recognizer];

    
    recognizer = [[UISwipeGestureRecognizer alloc] initWithTarget:target action:action];
    [recognizer setDirection:(UISwipeGestureRecognizerDirectionDown)];
    [self addGestureRecognizer:recognizer];
}

@end
