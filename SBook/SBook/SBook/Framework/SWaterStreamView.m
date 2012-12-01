//
//  SWaterStreamView.m
//  SPhoto
//
//  Created by SunJiangting on 12-11-21.
//
//

#import "SWaterStreamView.h"

#define kDefaultWaterCount 3
#define kMaxWaterCount 5

@interface SWaterStreamView ()
@property (nonatomic, strong) UIScrollView * scrollView;
//// 总共有多少个元素
@property (nonatomic, assign) NSUInteger elementCount;
///// @{index,view}
@property (nonatomic, strong) NSMutableDictionary * visibleViewDictionary;
//// 可见区域的index区间
@property (nonatomic, assign) SRange visibleRange;

@property (nonatomic, strong) NSMutableArray * columnElementArray;
@property (nonatomic, strong) NSMutableDictionary * elementRectDicitionary;
//////// 复用 的字典。@{key:cells,key1:cells}
@property (nonatomic, strong) NSMutableDictionary * reuseDictionary;

- (void) relayoutSubViews;

@end

@implementation SWaterStreamView

- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        
        self.columnCount = 3;
        self.columnElementArray = [NSMutableArray arrayWithCapacity:3];
        self.elementRectDicitionary = [NSMutableDictionary dictionaryWithCapacity:10];
        self.visibleViewDictionary = [NSMutableDictionary dictionaryWithCapacity:10];
        
        self.reuseDictionary = [NSMutableDictionary dictionaryWithCapacity:5];
        CGSize size = frame.size;
        _height = size.height;
        
        self.scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, size.width, size.height)];
        self.scrollView.contentOffset = CGPointZero;
        self.scrollView.delegate = self;
        
        UITapGestureRecognizer * tapGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(scrollViewDidTap:)];
        tapGestureRecognizer.numberOfTapsRequired = 1;
        tapGestureRecognizer.numberOfTouchesRequired = 1;
        [self.scrollView addGestureRecognizer:tapGestureRecognizer];
        
        [self addSubview:self.scrollView];
        
        _selectedIndex = -1;
        _separatorColor = [UIColor grayColor];
    }
    return self;
}

- (void) setDataSource:(id<SWaterStreamViewDataSource>)dataSource {
    _dataSource = dataSource;
}

- (void) setStreamHeaderView:(UIView *)streamHeaderView {
    [_streamHeaderView removeFromSuperview];
    _streamHeaderView = streamHeaderView;
}

- (void) setStreamFooterView:(UIView *)streamFooterView {
    [_streamFooterView removeFromSuperview];
    _streamFooterView = streamFooterView;
}

- (void) reloadData {
    //////// reloadData 之前先清空所有数据。将所有数据进入复用池
    [self.visibleViewDictionary enumerateKeysAndObjectsUsingBlock:^(id key, id obj, BOOL *stop) {
        SWaterStreamViewCell * streamCell = (SWaterStreamViewCell *)obj;
        [self inqueueReusableWithView:streamCell];
    }];
    
    [self.visibleViewDictionary removeAllObjects];
    [self.elementRectDicitionary removeAllObjects];
    
    //////// 得到总共有多少条数据
    self.elementCount = [self.dataSource numberOfElementsInStreamView:self];
    if (self.elementCount <= 0) {
        return;
    }
    //////// 得到有几个瀑布
    if ([self.dataSource respondsToSelector:@selector(numberOfWatersInStreamView:)]) {
        self.columnCount = [self.dataSource numberOfWatersInStreamView:self];
    }
    
    CGFloat top = 0.0f;
    
    if (self.streamHeaderView) {
        self.streamHeaderView.frame = CGRectMake(0, top, 320, self.streamHeaderView.height);
        [self.scrollView addSubview:self.streamHeaderView];
        top += self.streamHeaderView.height;
    }
    
    //////// 计算出ScrollView的ContentSize,并计算出每一个Element的frame。保存起来
    
    ////////// 用来保存每一个瀑布最下面的位置
    NSMutableArray * bottomOffset = [NSMutableArray arrayWithCapacity:self.columnCount];
    
    for (int i = 0; i < self.columnCount; i++) {
        [bottomOffset addObject:@(top)];
        // 每个瀑布的元素
        NSMutableArray * array = [NSMutableArray arrayWithCapacity:5];
        [self.columnElementArray addObject:array];
    }
    /// 每个瀑布的宽度
    CGFloat streamWidth = self.width / self.columnCount;
    for (int elementIndex = 0; elementIndex < self.elementCount; elementIndex ++) {
        // 首先得到最短的一个。然后将新的Cell添加在最短的上
        // 得到最短的一列
        NSInteger column = 0;
        CGFloat minBottom = [[bottomOffset objectAtIndex:0] floatValue];
        for (int i = 1; i < bottomOffset.count; i++) {
            CGFloat bottom = [[bottomOffset objectAtIndex:i] floatValue];
            if (bottom < minBottom) {
                minBottom = bottom;
                column = i;
            }
        }
        
        CGFloat x = column * streamWidth;
        CGFloat y = minBottom;
        CGFloat width = streamWidth;
        CGFloat height;
        if ([self.dataSource respondsToSelector:@selector(streamView:heightForRowAtIndex:basedWidth:)]) {
            height = [self.dataSource streamView:self heightForRowAtIndex:elementIndex basedWidth:streamWidth];
        } else {
            height = streamWidth;
        }
        CGRect rect = CGRectMake(x, y, width, height);
        [self.elementRectDicitionary setValue:NSStringFromCGRect(rect) forKey:[NSString stringWithFormat:@"%d",elementIndex]];
        /// 将数组中当列的最底部值置换为添加之后的高度
        [bottomOffset replaceObjectAtIndex:column withObject:@(y + height)];
    }
    
    /// 总高度(N个瀑布中最高的一列)，为ScrollView的ContentSize
    for (NSNumber * columnHeight in bottomOffset) {
        top = (top < [columnHeight floatValue]) ? [columnHeight floatValue] : top;
    }
    
    if (self.streamFooterView) {
        self.streamFooterView.frame = CGRectMake(0, top, 320, self.streamFooterView.height);
        [self.scrollView addSubview:self.streamFooterView];
        top += self.streamFooterView.height;

    }
    self.scrollView.contentSize = CGSizeMake(self.scrollView.width, top);
    
    [self relayoutSubViews];
}


- (void) relayoutSubViews {
    
    if (self.elementCount == 0) return;
    
    // Find out what rows are visible
    CGRect visibleRect = CGRectMake(self.scrollView.contentOffset.x, self.scrollView.contentOffset.y, self.scrollView.width, self.scrollView.height);
    
    /////// 得到在这个区间内需要显示的Cell
    NSMutableArray * unUsedArray = [NSMutableArray arrayWithCapacity:5];
    [self.visibleViewDictionary enumerateKeysAndObjectsUsingBlock:^(id key, id obj, BOOL *stop) {
        SWaterStreamViewCell * streamCell = (SWaterStreamViewCell *) obj;
        CGRect rect = streamCell.frame;
        if (!CGRectIntersectsRect(visibleRect, rect)) {
            // 如果不再可见区域，则移除.放入复用池中
            [self inqueueReusableWithView:streamCell];
            [unUsedArray addObject:key];
        }
    }];
    
    [self.visibleViewDictionary removeObjectsForKeys:unUsedArray];
    
    if (self.visibleViewDictionary.count == 0) {
        self.visibleRange = SRangeMake(0, self.elementCount);
    } else {
        NSArray * tempArray = [[self.visibleViewDictionary allKeys] sortedArrayUsingComparator:^NSComparisonResult(id obj1, id obj2) {
            //// key 为 index 。
            if ([obj1 integerValue] < [obj2 integerValue]) {
                return NSOrderedAscending;
            } else if ([obj1 integerValue] > [obj2 integerValue]) {
                return NSOrderedDescending;
            } else {
                return NSOrderedSame;
            }
        }];
        int start = [[tempArray objectAtIndex:0] intValue], end = [[tempArray lastObject] intValue];
        start = MAX(start - 5, 0);
        end = MIN(end + 5, self.elementCount);
        self.visibleRange = SRangeMake(start, end);
    }
    
    for (int index = self.visibleRange.start; index < self.visibleRange.end; index ++) {
        NSString * indexKey = [NSString stringWithFormat:@"%d", index];
        CGRect rect = CGRectFromString([self.elementRectDicitionary objectForKey:indexKey]);
        SWaterStreamViewCell * streamCell = [self.visibleViewDictionary objectForKey:indexKey];
        if (!streamCell && CGRectIntersectsRect(visibleRect, rect)) {
            // Only add views if not visible
            streamCell = [self.dataSource streamView:self cellForCellAtIndex:index];
            streamCell.frame = rect;
            
            [self.scrollView addSubview:streamCell];
            [self.visibleViewDictionary setValue:streamCell forKey:indexKey];
        } 
    }
}

- (id)dequeueReusableCellWithIdentifier:(NSString *)identifier {
    SWaterStreamViewCell * cell = nil;
    NSMutableSet * reuseCells = [self.reuseDictionary objectForKey:identifier];
    if (reuseCells.count > 0) {
        cell = [reuseCells anyObject];
        [reuseCells removeObject:cell];
    }
    return cell;
}


- (void) inqueueReusableWithView:(SWaterStreamViewCell *) reuseView {
    NSString * identifier = reuseView.reuseIdentifier;
    if (!self.reuseDictionary) {
        self.reuseDictionary = [NSMutableDictionary dictionaryWithCapacity:5];
    }
    NSMutableSet * cells = [self.reuseDictionary valueForKey:identifier];
    if (!cells) {
        cells  = [NSMutableSet setWithCapacity:5];
        [self.reuseDictionary setValue:cells forKey:identifier];
    }
    reuseView.selected = NO;
    [cells addObject:reuseView];
    [reuseView removeFromSuperview];
}

- (void) scrollViewDidScroll:(UIScrollView *)scrollView {
    [self relayoutSubViews];
}


- (void) scrollViewDidTap:(UITapGestureRecognizer *) sender {
    // 得到点击的区域
    CGPoint touchPoint = [sender locationInView:self.scrollView];
    // 根据点击区域的坐标，算出当前所在的列
    // 遍历所有 可见区域的 Cell
    [self.visibleViewDictionary enumerateKeysAndObjectsUsingBlock:^(id key, id obj, BOOL *stop) {
        SWaterStreamViewCell * streamCell = (SWaterStreamViewCell *) obj;
        CGRect frame = streamCell.frame;
        
        if (CGPointInRect(touchPoint, frame)) {
            [self didSelectedStreamCell:streamCell index:[key intValue]];
            *stop = YES;
        }
    }];
}

- (void) didSelectedStreamCell:(SWaterStreamViewCell *) streamCell index:(NSInteger) index {
    streamCell.selected = YES;
    if ([_delegate respondsToSelector:@selector(streamView:didSelectStreamCell:atIndex:)]) {
        [_delegate streamView:self didSelectStreamCell:streamCell atIndex:index];
    }
    // 如果 前一个选中的cell在可视区域内，则取消选中
    if (InRange(_visibleRange, _selectedIndex)) {
        int i = _selectedIndex - _visibleRange.start;
        SWaterStreamViewCell * cell1 = [self.visibleViewDictionary objectForKey:[NSString stringWithFormat:@"%d",i]];
        cell1.selected = NO;
    }
    _selectedIndex = index;
}




- (UITableViewCell *) cellAtIndex:(NSUInteger) index {
    return nil;
}

- (UITableViewCell *) cellAtIndexPath:(NSUInteger) indexPath {
    return nil;
}




@end
