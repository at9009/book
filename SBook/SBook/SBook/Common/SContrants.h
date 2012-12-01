//
//  SContrants.h
//  SPhoto
//
//  Created by SunJiangting on 12-11-21.
//
//


#define kUserLocationKey @"UserLocation"

#define kHostName @"http://www.lovecard.sinaapp.com/open"

#ifdef DEBUG
#define SLog(format,...) NSLog([NSString stringWithFormat:@"\n%sLine%d:\n%@",__FUNCTION__,__LINE__,format],## __VA_ARGS__)
#define SLogRect(rect) SLog(@"%@",NSStringFromCGRect(rect));
#else
#define SLog(format,...)
#define SLogRect(rect)
#endif

#define UIColorWithRGB(rgbValue) [UIColor \
colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 \
green:((float)((rgbValue & 0x00FF00) >> 8))/255.0 \
blue:((float)(rgbValue & 0x0000FF))/255.0 \
alpha:1.0]

#define UIColorWithRGBA(rgbValue, alphaValue) [UIColor \
colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 \
green:((float)((rgbValue & 0x00FF00) >> 8))/255.0 \
blue:((float)(rgbValue & 0x0000FF))/255.0 \
alpha:alphaValue]


#define UIFontWithName(name,fontSize) [UIFont fontWithName:name size:fontSize]

#define kFontNameGothicBold     @"AppleSDGothicNeo-BoldMT"
#define kFontNameArial          @"Arial"
#define kFontNameArialBold      @"Arial-BoldMT"
#define kFontNameHelvetica      @"Helvetica"
#define kFontNameHelveticaBold  @"Helvetica-Bold"

/// 定义一种结构体，用来表示区间。表示一个 从 几到几 的概念
typedef struct _SRange{
    NSInteger start;
    NSInteger end;
} SRange;

/**
 * @brief 创建结构体 SRange，结构体中保存start，end
 * @param start 范围开始
 * @param end   范围结束
 * @return 返回 该范围
 * @note eg. SRangeMake(0,5) 则返回 0~5
 */
NS_INLINE SRange SRangeMake(NSInteger start, NSInteger end) {
    SRange range;
    range.start = start;
    range.end = end;
    return range;
}

/**
 * @brief 该int 数 是否在 SRange区间内
 * @param r 整形区间
 * @param i 要比较的数
 * @return i在区间 r内，返回YES；否则，返回NO
 */
NS_INLINE BOOL InRange(SRange r,NSInteger i) {
    return (r.start <= i) && (r.end >= i);
}
/**
 * @brief 该点是否在某一rect区间内
 * @param p 点
 * @param r 矩形
 */
NS_INLINE BOOL CGPointInRect(CGPoint p,CGRect r){
    return p.x > r.origin.x && p.x < (r.origin.x + r.size.width) && p.y > r.origin.y && p.y < (r.origin.y + r.size.height);
}


#import "SRequest.h"
#import "AppDelegate.h"
#import "SProgressHUD.h"
#import "SUIExtensions.h"