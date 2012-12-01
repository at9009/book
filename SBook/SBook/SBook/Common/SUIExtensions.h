//
//  SUIExtensions.h
//  SPhoto
//
//  Created by SunJiangting on 12-11-22.
//
//

@interface UIView (Extension)
/**
 * Shortcut for frame.size.witdth*0.5
 */
@property (nonatomic,readonly) CGFloat inCenterX;
/**
 * Shortcut for frame.size.height*0.5
 */
@property (nonatomic,readonly) CGFloat inCenterY;

/**
 * Shortcut for CGPointMake(self.inCenterX,self.inCenterY)
 */
@property (nonatomic,readonly) CGPoint inCenter;
/**
 * Shortcut for frame.origin.x.
 *
 * Sets frame.origin.x = left
 */
@property (nonatomic) CGFloat left;

/**
 * Shortcut for frame.origin.y
 *
 * Sets frame.origin.y = top
 */
@property (nonatomic) CGFloat top;

/**
 * Shortcut for frame.origin.x + frame.size.width
 *
 * Sets frame.origin.x = right - frame.size.width
 */
@property (nonatomic) CGFloat right;

/**
 * Shortcut for frame.origin.y + frame.size.height
 *
 * Sets frame.origin.y = bottom - frame.size.height
 */
@property (nonatomic) CGFloat bottom;

/**
 * Shortcut for frame.size.width
 *
 * Sets frame.size.width = width
 */
@property (nonatomic) CGFloat width;

/**
 * Shortcut for frame.size.height
 *
 * Sets frame.size.height = height
 */
@property (nonatomic) CGFloat height;

/**
 * Shortcut for bounds.size.width
 *
 * Sets bounds.size.width = width
 */
@property (nonatomic,readonly) CGFloat b_width;

/**
 * Shortcut for bounds.size.height
 *
 * Sets bounds.size.height = height
 */
@property (nonatomic,readonly) CGFloat b_height;
/**
 * Shortcut for center.x
 *
 * Sets center.x = centerX
 */
@property (nonatomic) CGFloat centerX;

/**
 * Shortcut for center.y
 *
 * Sets center.y = centerY
 */
@property (nonatomic) CGFloat centerY;

/**
 * Return the x coordinate on the screen.
 */
@property (nonatomic, readonly) CGFloat ttScreenX;

/**
 * Return the y coordinate on the screen.
 */
@property (nonatomic, readonly) CGFloat ttScreenY;

/**
 * Return the x coordinate on the screen, taking into account scroll views.
 */
@property (nonatomic, readonly) CGFloat screenViewX;

/**
 * Return the y coordinate on the screen, taking into account scroll views.
 */
@property (nonatomic, readonly) CGFloat screenViewY;

/**
 * Return the view frame on the screen, taking into account scroll views.
 */
@property (nonatomic, readonly) CGRect screenFrame;

/**
 * Shortcut for frame.origin
 */
@property (nonatomic) CGPoint origin;

/**
 * Shortcut for frame.size
 */
@property (nonatomic) CGSize size;

/**
 * Return the width in portrait or the height in landscape.
 */
@property (nonatomic, readonly) CGFloat orientationWidth;

/**
 * Return the height in portrait or the width in landscape.
 */
@property (nonatomic, readonly) CGFloat orientationHeight;


/**
 * Removes all subviews.
 */
- (void)removeAllSubviews;
/**
 * Calculates the offset of this view from another view in screen coordinates.
 *
 * otherView should be a parent view of this view.
 */
- (CGPoint)offsetFromView:(UIView*)otherView;

/**
 * Get the UIViewController for the view.
 *
 */
- (UIViewController*)viewController;

- (void)addTargetForTouch:(id)target action:(SEL)action;

@end


//  Created by Sun Jiangting on 12-10-12.
//  Copyright (c) 2012年 Appsurdity, Inc. All rights reserved.

@interface UIScrollView (Rect)

- (CGRect) visibleRect;

@end


//  Created by Sun Jiangting on 12-10-12.
//  Copyright (c) 2012年 Appsurdity, Inc. All rights reserved.
//
#pragma mark-
#pragma mark UIButton 创建back/Done按钮

/// 圆角按钮（Navigation右上方功能按钮的宽度）
#define kRoundBtnWidth 41.0f

/**
 * NavigationBar 上的按钮类型。Back表示左尖角按钮，Round为圆角普通按钮，next未完善，为右尖角按钮
 */
typedef enum SButtonType : NSInteger {
    SButtonTypeBack    = 1,
    SButtonTypeMore    = 2,
    SButtonTypeRefresh = 3,
    SButtonTypeSetting = 4,
    SButtonTypeSearch  = 5,
    SButtonTypeDone    = 6,
    SButtonTypeCancle  = 7
} SButtonType;

@interface UIButton (RVNavButton)

/**
 * @brief 根据type和title的不同类型，创建按钮, 无文字
 *
 * @param type    需要创建的按钮类型 @see RVButtonType
 * @param target  需要响应事件的target
 * @param action  需要相应的事件
 */
+ (UIButton *) buttonWithType:(SButtonType)type target:(id)target action:(SEL)selector;

@end


//  Created by Sun Jiangting on 12-10-12.
//  Copyright (c) 2012年 Appsurdity, Inc. All rights reserved.
//
#pragma mark-
#pragma mark UIBarButtonItem 创建back/Done按钮

@interface UIBarButtonItem (RVNavBarButtonItem)

/**
 * @brief 创建Nav默认的返回按钮，文本内容为Back。
 *
 * @param target  需要响应事件的target
 * @param action  需要响应事件的方法
 */
- (UIBarButtonItem *) initWithBackTarget:(id) target action:(SEL) selector;

/**
 * @brief 根据type和title的不同类型，创建navigation上的按钮,无文字
 *
 * @param type    需要创建的按钮类型 @see RVButtonType
 * @param target  需要响应事件的target
 * @param action  需要响应事件的方法
 */
- (UIBarButtonItem *) initWithType:(SButtonType) type target:(id)target action:(SEL)selector;

@end