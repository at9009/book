//
//  SUIExtensions.m
//  SPhoto
//
//  Created by SunJiangting on 12-11-22.
//
//

#import "SUIExtensions.h"


@implementation UIView (Extension)

///////////////////////////////////////////////////////////////////////////////////////////////////
-(CGFloat)inCenterX{
    return self.frame.size.width*0.5;
}

///////////////////////////////////////////////////////////////////////////////////////////////////
-(CGFloat)inCenterY{
    return self.frame.size.height*0.5;
}

///////////////////////////////////////////////////////////////////////////////////////////////////
-(CGPoint)inCenter{
    return CGPointMake(self.inCenterX, self.inCenterY);
}

///////////////////////////////////////////////////////////////////////////////////////////////////
- (CGFloat)left {
    return self.frame.origin.x;
}


///////////////////////////////////////////////////////////////////////////////////////////////////
- (void)setLeft:(CGFloat)x {
    CGRect frame = self.frame;
    frame.origin.x = x;
    self.frame = frame;
}


///////////////////////////////////////////////////////////////////////////////////////////////////
- (CGFloat)top {
    return self.frame.origin.y;
}


///////////////////////////////////////////////////////////////////////////////////////////////////
- (void)setTop:(CGFloat)y {
    CGRect frame = self.frame;
    frame.origin.y = y;
    self.frame = frame;
}


///////////////////////////////////////////////////////////////////////////////////////////////////
- (CGFloat)right {
    return self.frame.origin.x + self.frame.size.width;
}


///////////////////////////////////////////////////////////////////////////////////////////////////
- (void)setRight:(CGFloat)right {
    CGRect frame = self.frame;
    frame.origin.x = right - frame.size.width;
    self.frame = frame;
}


///////////////////////////////////////////////////////////////////////////////////////////////////
- (CGFloat)bottom {
    return self.frame.origin.y + self.frame.size.height;
}


///////////////////////////////////////////////////////////////////////////////////////////////////
- (void)setBottom:(CGFloat)bottom {
    CGRect frame = self.frame;
    frame.origin.y = bottom - frame.size.height;
    self.frame = frame;
}


///////////////////////////////////////////////////////////////////////////////////////////////////
- (CGFloat)centerX {
    return self.center.x;
}


///////////////////////////////////////////////////////////////////////////////////////////////////
- (void)setCenterX:(CGFloat)centerX {
    self.center = CGPointMake(centerX, self.center.y);
}


///////////////////////////////////////////////////////////////////////////////////////////////////
- (CGFloat)centerY {
    return self.center.y;
}


///////////////////////////////////////////////////////////////////////////////////////////////////
- (void)setCenterY:(CGFloat)centerY {
    self.center = CGPointMake(self.center.x, centerY);
}


///////////////////////////////////////////////////////////////////////////////////////////////////
- (CGFloat)width {
    return self.frame.size.width;
}


///////////////////////////////////////////////////////////////////////////////////////////////////
- (void)setWidth:(CGFloat)width {
    CGRect frame = self.frame;
    frame.size.width = width;
    self.frame = frame;
}


///////////////////////////////////////////////////////////////////////////////////////////////////
- (CGFloat)height {
    return self.frame.size.height;
}


///////////////////////////////////////////////////////////////////////////////////////////////////
- (void)setHeight:(CGFloat)height {
    CGRect frame = self.frame;
    frame.size.height = height;
    self.frame = frame;
}

- (CGFloat)b_width{
    return self.bounds.size.width;
}


- (CGFloat)b_height{
    return self.bounds.size.height;
}

///////////////////////////////////////////////////////////////////////////////////////////////////
- (CGFloat)ttScreenX {
    CGFloat x = 0;
    for (UIView* view = self; view; view = view.superview) {
        x += view.left;
    }
    return x;
}


///////////////////////////////////////////////////////////////////////////////////////////////////
- (CGFloat)ttScreenY {
    CGFloat y = 0;
    for (UIView* view = self; view; view = view.superview) {
        y += view.top;
    }
    return y;
}


///////////////////////////////////////////////////////////////////////////////////////////////////
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


///////////////////////////////////////////////////////////////////////////////////////////////////
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


///////////////////////////////////////////////////////////////////////////////////////////////////
- (CGRect)screenFrame {
    return CGRectMake(self.screenViewX, self.screenViewY, self.width, self.height);
}


///////////////////////////////////////////////////////////////////////////////////////////////////
- (CGPoint)origin {
    return self.frame.origin;
}


///////////////////////////////////////////////////////////////////////////////////////////////////
- (void)setOrigin:(CGPoint)origin {
    CGRect frame = self.frame;
    frame.origin = origin;
    self.frame = frame;
}


///////////////////////////////////////////////////////////////////////////////////////////////////
- (CGSize)size {
    return self.frame.size;
}


///////////////////////////////////////////////////////////////////////////////////////////////////
- (void)setSize:(CGSize)size {
    CGRect frame = self.frame;
    frame.size = size;
    self.frame = frame;
}
///////////////////////////////////////////////////////////////////////////////////////////////////
- (CGFloat)orientationWidth {
    return UIInterfaceOrientationIsLandscape([UIApplication sharedApplication].statusBarOrientation)
    ? self.height : self.width;
}


///////////////////////////////////////////////////////////////////////////////////////////////////
- (CGFloat)orientationHeight {
    return UIInterfaceOrientationIsLandscape([UIApplication sharedApplication].statusBarOrientation)
    ? self.width : self.height;
}
///////////////////////////////////////////////////////////////////////////////////////////////////
- (void)removeAllSubviews {
    while (self.subviews.count) {
        UIView* child = self.subviews.lastObject;
        [child removeFromSuperview];
    }
}
///////////////////////////////////////////////////////////////////////////////////////////////////
- (CGPoint)offsetFromView:(UIView*)otherView {
    CGFloat x = 0, y = 0;
    for (UIView* view = self; view && view != otherView; view = view.superview) {
        x += view.left;
        y += view.top;
    }
    return CGPointMake(x, y);
}

///////////////////////////////////////////////////////////////////////////////////////////////////
- (UIViewController*)viewController {
    for (UIView* next = self; next; next = next.superview) {
        UIResponder* nextResponder = [next nextResponder];
        if ([nextResponder isKindOfClass:[UIViewController class]]) {
            return (UIViewController*)nextResponder;
        }
    }
    return nil;
}

- (void)addTargetForTouch:(id)target action:(SEL)action
{
    UITapGestureRecognizer *singleTap = [[UITapGestureRecognizer alloc]
                                         initWithTarget:target action:action];
    [self addGestureRecognizer:singleTap];
    
}

@end


//  Created by Sun Jiangting on 12-10-12.
//  Copyright (c) 2012年 Appsurdity, Inc. All rights reserved.

@implementation UIScrollView (Rect)

- (CGRect) visibleRect {
    CGRect rect;
    rect.origin = self.contentOffset;
    rect.size = self.bounds.size;
	return rect;
}

@end

//  Created by Sun Jiangting on 12-10-12.
//  Copyright (c) 2012年 Appsurdity, Inc. All rights reserved.
//
#pragma mark-
#pragma mark UIButton 创建back/Done按钮

@implementation UIButton (RVNavButton)

/**
 * @brief 根据type和title的不同类型，创建按钮, 无文字
 *
 * @param type    需要创建的按钮类型 @see RVButtonType
 * @param target  需要响应事件的target
 * @param action  需要相应的事件
 */
+ (UIButton *) buttonWithType:(SButtonType)type target:(id)target action:(SEL)selector {
    
    UIButton * button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.exclusiveTouch = YES;
    
    UIImage * normalImage;
    UIImage * highlightImage;
    
    switch (type) {
        case SButtonTypeBack:
            normalImage = [[UIImage imageNamed:@"nav_back_normal.png"] stretchableImageWithLeftCapWidth:20 topCapHeight:20];
            highlightImage = [[UIImage imageNamed:@"nav_back_highlight.png"] stretchableImageWithLeftCapWidth:20 topCapHeight:15];
            break;
        case SButtonTypeMore:
            normalImage = [[UIImage imageNamed:@"nav_more_normal.png"] stretchableImageWithLeftCapWidth:20 topCapHeight:15];
            highlightImage = [[UIImage imageNamed:@"nav_more_highlight.png"] stretchableImageWithLeftCapWidth:20 topCapHeight:15];
            break;
        case SButtonTypeRefresh:
            normalImage = [[UIImage imageNamed:@"nav_refresh_normal.png"] stretchableImageWithLeftCapWidth:20 topCapHeight:15];
            highlightImage = [[UIImage imageNamed:@"nav_refresh_highlight.png"] stretchableImageWithLeftCapWidth:20 topCapHeight:15];
            break;
        case SButtonTypeSearch:
            normalImage = [[UIImage imageNamed:@"nav_search_normal.png"] stretchableImageWithLeftCapWidth:20 topCapHeight:15];
            highlightImage = [[UIImage imageNamed:@"nav_search_highlight.png"] stretchableImageWithLeftCapWidth:20 topCapHeight:15];
            break;
        case SButtonTypeSetting:
            normalImage = [[UIImage imageNamed:@"nav_setting_normal.png"] stretchableImageWithLeftCapWidth:20 topCapHeight:15];
            highlightImage = [[UIImage imageNamed:@"nav_setting_highlight.png"] stretchableImageWithLeftCapWidth:31 topCapHeight:15];
            break;
        case SButtonTypeDone:
            normalImage = [[UIImage imageNamed:@"nav_done_normal.png"] stretchableImageWithLeftCapWidth:20 topCapHeight:15];
            highlightImage = [[UIImage imageNamed:@"nav_done_highlight.png"] stretchableImageWithLeftCapWidth:31 topCapHeight:15];
            break;
        case SButtonTypeCancle:
            normalImage = [[UIImage imageNamed:@"nav_cancel_normal.png"] stretchableImageWithLeftCapWidth:20 topCapHeight:15];
            highlightImage = [[UIImage imageNamed:@"nav_cancel_highlight.png"] stretchableImageWithLeftCapWidth:31 topCapHeight:15];
            break;
        default:
            break;
    }
    [button setBackgroundImage:normalImage forState:UIControlStateNormal];
    [button setBackgroundImage:highlightImage forState:UIControlStateHighlighted];
    [button setBackgroundImage:highlightImage forState:UIControlStateSelected];
    
    [button addTarget:target action:selector forControlEvents:UIControlEventTouchUpInside];
    
    button.frame = CGRectMake(0, 0, 40, 40);
    return button;
}

@end

@implementation UIBarButtonItem (RVNavBarButtonItem)

/**
 * @brief 创建Nav默认的返回按钮，文本内容为Back。
 *
 * @param target  需要响应事件的target
 * @param action  需要响应事件的方法
 */
- (UIBarButtonItem *) initWithBackTarget:(id) target action:(SEL) selector {
    // 创建 back按钮 默认文字为back
    //    NSString * backTitle = RVLocalizedString(@"BackTitle", @"Back");
    
    return [self initWithType:SButtonTypeBack target:target action:selector];
}

/**
 * @brief 根据type和title的不同类型，创建navigation上的按钮,无文字
 *
 * @param type    需要创建的按钮类型 @see RVButtonType
 * @param target  需要响应事件的target
 * @param action  需要响应事件的方法
 */
- (UIBarButtonItem *) initWithType:(SButtonType) type target:(id)target action:(SEL)selector {
    UIButton * button = [UIButton buttonWithType:type target:target action:selector];
    return [[UIBarButtonItem alloc] initWithCustomView:button];
}
@end

