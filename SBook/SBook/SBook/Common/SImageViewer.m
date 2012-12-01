//
//  SImageViewer.m
//  SBook
//
//  Created by SunJiangting on 12-11-11.
//  Copyright (c) 2012年 sun. All rights reserved.
//

#import "SImageViewer.h"

@interface SImageViewer ()

- (CGSize) preferredSize:(UIImage *)image;

@end

@implementation SImageViewer

- (id) initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        
        self.backgroundColor = [UIColor clearColor];
        
        _contentView=[[UIScrollView alloc] initWithFrame:frame];
        _contentView.backgroundColor = [UIColor blackColor];
        _contentView.delegate=self;
        _contentView.bouncesZoom=YES;
        
        _contentView.minimumZoomScale = 0.5;
        _contentView.maximumZoomScale = 5.0;
        
        _contentView.showsHorizontalScrollIndicator=NO;
        _contentView.showsVerticalScrollIndicator=NO;
        [self addSubview:_contentView];
        
        
        _imageView = [[UIImageView alloc] initWithFrame:CGRectZero];
        _imageView.userInteractionEnabled = YES;
        [_contentView addSubview:_imageView];
        
        UITapGestureRecognizer * tapGesture = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(hide)];
        tapGesture.numberOfTapsRequired = 1;
        tapGesture.enabled = YES;
        [tapGesture delaysTouchesBegan];
        [tapGesture cancelsTouchesInView];
        [_imageView addGestureRecognizer:tapGesture];
    }
    return self;
}

- (void) setImage:(UIImage *) image {
    CGSize size = [self preferredSize:image];
    _imageView.frame = CGRectMake(0, 0, size.width, size.height);
    _contentView.contentSize=size;
    _imageView.center =self.center;
    _imageView.image = image;
}

- (CGSize) preferredSize:(UIImage *) image {
    
    CGFloat width = 0.0, height = 0.0;
    CGFloat rat0 = image.size.width / image.size.height;
    CGFloat rat1 = self.frame.size.width / self.frame.size.height;
    if (rat0 > rat1) {
        width = self.frame.size.width;
        height = width / rat0;
    } else {
        height = self.frame.size.height;
        width = height * rat0;
    }
    
    return CGSizeMake(width, height);
}

- (UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView {
    return _imageView;
}

-(void) scrollViewDidZoom:(UIScrollView *)scrollView{
    CGFloat x = scrollView.center.x,y = scrollView.center.y;
    x = scrollView.contentSize.width > scrollView.frame.size.width?scrollView.contentSize.width/2 :x;
    y = scrollView.contentSize.height > scrollView.frame.size.height ?scrollView.contentSize.height/2 : y;
    _imageView.center = CGPointMake(x, y);
}

- (void) show {
    
    _contentView.transform = CGAffineTransformMakeScale(0.1, 0.1);
    _contentView.alpha = 0;
    
    [UIView animateWithDuration:0.5 animations:^{
        _contentView.alpha =1;
        _contentView.transform = CGAffineTransformMakeScale(1, 1);
        _contentView.center=self.center;
    }];
    
}

-  (void) hide {
    [UIView animateWithDuration:0.25 animations:^{
        _contentView.transform = CGAffineTransformMakeScale(0.1, 0.1);
        _contentView.alpha = 0;
    } completion:^(BOOL finished) {
        if (finished) {
            _contentView.alpha=1;
            [_contentView removeFromSuperview];
            [_imageView removeFromSuperview];
            [self removeFromSuperview];
        }
    }];
}

+ (void) viewWithImage:(UIImage *) image {
    AppDelegate * delegate = ((AppDelegate *)[UIApplication sharedApplication].delegate);
    UIWindow * window = delegate.window;
    SImageViewer * imageViewer = [[SImageViewer alloc] initWithFrame:window.frame];
    [imageViewer setImage:image];
    
    [window addSubview:imageViewer];
    [imageViewer show];
}
@end
