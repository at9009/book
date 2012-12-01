//
//  SWaterStreamViewCell.h
//  SPhoto
//
//  Created by SunJiangting on 12-11-22.
//
//

#import "UIImageView+WebCache.h"

@interface SWaterStreamViewCell : UITableViewCell

@property (nonatomic, copy) NSString * reuseIdentifier;

@property (nonatomic, strong) NSDictionary * photoDictionary;

- (id)initWithReuseIdentifier:(NSString *) reuseIdentifier;

@end
