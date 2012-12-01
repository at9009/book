//
//  SImageViewer.h
//  SBook
//
//  Created by SunJiangting on 12-11-11.
//  Copyright (c) 2012年 sun. All rights reserved.
//

#import "AppDelegate.h"

@interface SImageViewer : UIView <UIScrollViewDelegate>{
    UIImageView * _imageView;
    UIScrollView * _contentView;
}

- (void) show;

- (void) hide;

- (void) setImage:(UIImage *) image;

+ (void) viewWithImage:(UIImage *) image;

@end
