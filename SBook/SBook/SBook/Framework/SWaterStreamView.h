//
//  SWaterStreamView.h
//  SPhoto
//
//  Created by SunJiangting on 12-11-21.
//
//

#import "SWaterStreamViewCell.h"


@class SWaterStreamView;
@protocol SWaterStreamViewDelegate <NSObject, UIScrollViewDelegate>

/**
 * @brief 当前列 被选中的事件
 * @param index  当前所在列
 */
- (void) streamView:(SWaterStreamView *) streamView
didSelectStreamCell:(SWaterStreamViewCell *) streamCell
            atIndex:(NSInteger) index;

@end

@protocol SWaterStreamViewDataSource <NSObject>

@required

/**
 * @brief 共有多少个元素
 *
 * @param streamView 当前所在的streamView
 */
- (NSInteger) numberOfElementsInStreamView:(SWaterStreamView *) streamView;

@optional

/**
 * @brief 共有多少个瀑布
 *
 * @param streamView 当前所在的streamView
 */
- (NSInteger) numberOfWatersInStreamView:(SWaterStreamView *) streamView;


/**
 * @brief 某一行有多高
 *
 * @param indexPath  当前所在行，列
 */
- (CGFloat) streamView:(SWaterStreamView *) streamView
   heightForRowAtIndex:(NSInteger) index
            basedWidth:(CGFloat) width;

/**
 * @brief 每列 显示什么
 * @param listView 当前所在的ListView
 * @param index  当前所在列
 * @return  当前所要展示的页
 */
- (SWaterStreamViewCell *) streamView:(SWaterStreamView *) streamView cellForCellAtIndex:(int) index;

@end


@interface SWaterStreamView : UIView <NSCoding, UIScrollViewDelegate> {
    /// 瀑布 个数
    NSInteger _columns;
    /// scrollView
    UIScrollView * _scrollView;
    /// 每个SListViewCell 的高度
    CGFloat _height;
    /// 所有的SListViewCell 的frame
    NSMutableArray * _columnRects;
    /// 可见的column范围
    SRange _visibleRange;
    /// scrollView 的可见区域
    CGRect _visibleRect;
    /// 可见的SListViewCell;
    NSMutableArray * _visibleListCells;
    /// 可重用的ListCells {identifier:[cell1,cell2]}
    NSMutableDictionary * _reusableListCells;
    
    // 选中的列
    NSInteger _selectedIndex;
}

@property (nonatomic, strong) UIView * streamHeaderView;
@property (nonatomic, strong) UIView * streamFooterView;

@property (nonatomic, assign) NSUInteger columnCount;

@property(nonatomic, retain) UIColor * separatorColor;

@property (nonatomic, assign) id<SWaterStreamViewDelegate> delegate;
@property (nonatomic,assign) id<SWaterStreamViewDataSource> dataSource;

- (void) reloadData;

- (id)dequeueReusableCellWithIdentifier:(NSString *)identifier;

- (UITableViewCell *) cellAtIndex:(NSUInteger) index;
- (UITableViewCell *) cellAtIndexPath:(NSUInteger) indexPath;

@end
