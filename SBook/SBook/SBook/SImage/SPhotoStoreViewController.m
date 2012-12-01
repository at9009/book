//
//  SPhotoStoreViewController.m
//  SBook
//
//  Created by SunJiangting on 12-11-11.
//  Copyright (c) 2012年 sun. All rights reserved.
//

#define kPhotoRoot @"Photos"

#import "SPhotoStoreViewController.h"

@interface SPhotoStoreViewController ()

@property (nonatomic, strong) iCarousel * photoView;

@property (nonatomic, strong) NSUserDefaults * userDefaults;

@property (nonatomic, strong) NSMutableArray * photoArray;


- (void) setupPhotoStores;

- (NSMutableArray *) photosFromBundle;

@end

@implementation SPhotoStoreViewController

- (id) initWithTitle:(NSString *)title imageName:(NSString *)imageName revealBlock:(RevealBlock)revealBlock {
    self = [super initWithTitle:title imageName:imageName revealBlock:revealBlock];
    if (self) {
        self.userDefaults = [NSUserDefaults standardUserDefaults];
    }
    return self;
}
- (void) loadView {
    [super loadView];
    [self setupPhotoStores];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"美女照片";
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemRefresh target:self action:@selector(refresh)];
    
    self.photoView = [[iCarousel alloc] initWithFrame:CGRectMake(0, 0, 320, 460)];
    self.photoView.autoresizingMask = UIViewAutoresizingFlexibleHeight;
    self.photoView.delegate = self;
    self.photoView.dataSource = self;
    self.photoView.type = iCarouselTypeCoverFlow;
    [self.view addSubview:self.photoView];
}

- (void) viewDidUnload {
    [super viewDidUnload];
    self.photoView = nil;
}

- (void) setupPhotoStores {
    // ["1.png,2.png,3.png"]
    if ([self.userDefaults objectForKey:kPhotoStore]) {
        self.photoArray = [self.userDefaults objectForKey:kPhotoStore];
    } else {
        self.photoArray = [self photosFromBundle];
    }
}


- (void) refresh {
    self.photoArray = [self photosFromBundle];
    [self.photoView reloadData];
}

- (NSMutableArray *) photosFromBundle {
    
    NSArray * paths = [[NSBundle mainBundle] pathsForResourcesOfType:@".jpg" inDirectory:kPhotoRoot];
    
    NSMutableArray * array = [NSMutableArray arrayWithCapacity:20];
    for (NSString * path in paths) {
        [array addObject:path];
    }
    [[NSUserDefaults standardUserDefaults] setValue:array forKey:kPhotoStore];
    [[NSUserDefaults standardUserDefaults] synchronize];
    return array;
}


/////////////////

- (void) viewLargePhoto:(UIPinchGestureRecognizer *) sender {
    UIImageView * imageView = (UIImageView *) sender.view;
    CGFloat rate = sender.scale;
    imageView.transform = CGAffineTransformMakeScale(rate, rate);
}


- (NSUInteger)numberOfItemsInCarousel:(iCarousel *)carousel {
    return self.photoArray.count;
}

- (UIView *)carousel:(iCarousel *)carousel viewForItemAtIndex:(NSUInteger)index {
    NSString * name = [self.photoArray objectAtIndex:index];
    UIImage * image = [UIImage imageWithContentsOfFile:name];
    UIImageView * photoView = [[UIImageView alloc] initWithImage:image];
    UIGestureRecognizer * gesture = [[UIPinchGestureRecognizer alloc] initWithTarget:self action:@selector(viewLargePhoto:)];
    [photoView addGestureRecognizer:gesture];
    photoView.contentMode = UIViewContentModeScaleToFill;
    photoView.frame = CGRectMake(30, 20, 240, 300);
    return photoView;
}

- (NSUInteger) numberOfPlaceholdersInCarousel:(iCarousel *)carousel {
    return 7;
}

- (NSUInteger) numberOfVisibleItemsInCarousel:(iCarousel *)carousel {
    return 5;
}

- (BOOL)carouselShouldWrap:(iCarousel *)carousel {
    return YES;
}

- (void) carousel:(iCarousel *)carousel didSelectItemAtIndex:(NSInteger)index {
    UIImageView * imageView = (UIImageView *) [carousel itemViewAtIndex:index];
    [SImageViewer viewWithImage:imageView.image];
}
@end
