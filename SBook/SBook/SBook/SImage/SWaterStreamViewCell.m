//
//  SWaterStreamViewCell.m
//  SPhoto
//
//  Created by SunJiangting on 12-11-22.
//
//

#import "SWaterStreamViewCell.h"

#define kMinCellRect CGRectMake(0,0,50,50)

static NSString * kUnIdentifier = @"UnIdentifier";

@interface SWaterStreamViewCell ()


@property (nonatomic, strong) UIImageView * photoImageView;

@property (nonatomic, strong) UIView * separatorView;

@end

@implementation SWaterStreamViewCell

@synthesize separatorView = _separatorView1;

- (id)initWithReuseIdentifier:(NSString *)reuseIdentifier {
    self = [super init];
    if (self) {
        if (!reuseIdentifier) {
            reuseIdentifier = kUnIdentifier;
        }
        self.reuseIdentifier = reuseIdentifier;
        self.frame = kMinCellRect;
//        self.separatorView = [[UIView alloc] initWithFrame:CGRectMake(0, 49, 50, 1)];
//        self.separatorView.autoresizingMask = UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleWidth;
//        self.separatorView.backgroundColor = [UIColor darkGrayColor];
//        [self addSubview:self.separatorView];
        
        self.photoImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 50, 50)];
        self.photoImageView.contentMode = UIViewContentModeScaleAspectFit;
        self.photoImageView.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
        [self addSubview:self.photoImageView];
    }
    return self;
}

- (void) setPhotoDictionary:(NSDictionary *)photoDictionary {
    _photoDictionary = photoDictionary;
    
    NSString * imageString = [photoDictionary objectForKey:@"thumb"];
    
    [self.photoImageView setImageWithURL:[NSURL URLWithString:imageString]];
}

@end
