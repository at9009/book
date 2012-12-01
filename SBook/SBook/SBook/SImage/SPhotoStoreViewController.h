//
//  SPhotoStoreViewController.h
//  SBook
//
//  Created by SunJiangting on 12-11-11.
//  Copyright (c) 2012年 sun. All rights reserved.
//


#define kPhotoStore @"PhotoStore"

#import "iCarousel.h"
#import "SImageViewer.h"
#import "GTViewController.h"

@interface SPhotoStoreViewController : GTViewController <iCarouselDataSource,iCarouselDelegate>

@end
