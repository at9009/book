//
//  SBookViewController.m
//  SBook
//
//  Created by SunJiangting on 12-11-11.
//  Copyright (c) 2012年 sun. All rights reserved.
//

#define kFontSizeId @"FontSizeId"
#define kAutoReadId @"AutoRead"
#define kAutoSpeedId @"AutoSpeed"

#import "SBookViewController.h"


@interface SBookViewController ()

@property (nonatomic, copy) NSString * title;
@property (nonatomic, copy) NSString * path;
@property (nonatomic, copy) NSString * content;
@property (nonatomic, strong) NSUserDefaults * userDefault;

@property (nonatomic, strong) UITextView * textView;

@property (nonatomic, assign) BOOL autoPage;
@property (nonatomic, strong) NSTimer * pageTimer;

@property (nonatomic, assign) BOOL visible;  //判断是隐藏还是出现

@property (nonatomic, assign) CGFloat fontSize;
@property (nonatomic, assign) CGFloat autoSpeed;

@property (nonatomic, strong) UIBarButtonItem * configBarButton;
@property (nonatomic, strong) SNPopupView * popupView;
@property (nonatomic, assign) BOOL popupVisible;
@property (nonatomic, strong) UIView * configView;
@property (nonatomic, strong) UILabel * fontLabel;
@property (nonatomic, strong) UISwitch * autoPageSwitch;
@property (nonatomic, strong) UISlider * fontSizeSlider;
@property (nonatomic, strong) UILabel * speedLabel;
@property (nonatomic, strong) UISlider * speedSlider;

- (void) prevPage;
- (void) nextPage;


@end

@implementation SBookViewController

- (void) dealloc {
    [self.pageTimer invalidate];
    self.pageTimer = nil;
}


- (id) initWithTitle:(NSString *) title path:(NSString *) path {
    self = [super initWithNibName:nil bundle:nil];
    if (self) {
        self.title = title;
        self.path = path;
        self.fontSize = 14.0f;
        self.autoPage = NO;
        self.popupVisible = NO;
        
        
        self.userDefault = [NSUserDefaults standardUserDefaults];
        if ([self.userDefault objectForKey:kFontSizeId]) {
            self.fontSize = [[self.userDefault objectForKey:kFontSizeId] floatValue];
        }
        
        if ([self.userDefault objectForKey:kAutoSpeedId]) {
            self.autoSpeed = [[self.userDefault objectForKey:kAutoSpeedId] floatValue];
        } else {
            self.autoSpeed = 1.0f;
        }
        
           }
    return self;
}

- (void) loadView {
    [super loadView];
    
    NSString *bookPath = [NSString stringWithFormat:@"%@/%@.txt",self.path,self.title];
    self.content = [[NSString alloc]initWithContentsOfFile:bookPath encoding:NSUTF8StringEncoding error:NULL];
    if (!self.content) {
        self.content = [NSString stringWithContentsOfFile:bookPath encoding:NSASCIIStringEncoding error:NULL];
    }
    if (!self.content) {
        self.content = [NSString stringWithContentsOfFile:bookPath encoding:NSUTF16StringEncoding error:NULL];
    }
    if (!(self.content.length > 0)) {
        return;
    }
    //解析
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = self.title;
    self.view.backgroundColor = [UIColor whiteColor];
    
    self.configView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 200, 140)];
    self.fontLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 10, 80, 30)];
    self.fontLabel.text = @"字体大小";
    self.fontLabel.backgroundColor = [UIColor clearColor];
    [self.configView addSubview:self.fontLabel];
    
    self.fontSizeSlider = [[UISlider alloc] initWithFrame:CGRectMake(80, 10, 120, 30)];
    self.fontSizeSlider.minimumValue = 12.0f;
    self.fontSizeSlider.maximumValue = 50.0f;
    self.fontSizeSlider.value = self.fontSize;
    [self.configView addSubview:self.fontSizeSlider];
    
    UILabel * autoPageLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 50, 80, 30)];
    autoPageLabel.text = @"自动翻页";
    autoPageLabel.backgroundColor = [UIColor clearColor];
    [self.configView addSubview:autoPageLabel];
    
    self.autoPageSwitch = [[UISwitch alloc] initWithFrame:CGRectMake(80, 50, 60, 30)];
    [self.autoPageSwitch addTarget:self action:@selector(autoPageChanged:) forControlEvents:UIControlEventValueChanged];
    self.autoPageSwitch.on = NO;
    [self.configView addSubview:self.autoPageSwitch];
    
    self.speedLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 90, 80, 30)];
    self.speedLabel.text = @"滚动速度";
    self.speedLabel.backgroundColor = [UIColor clearColor];
    [self.configView addSubview:self.speedLabel];
    
    self.speedSlider = [[UISlider alloc] initWithFrame:CGRectMake(80, 90, 120, 30)];
    self.speedSlider.minimumValue = 1.0f;
    self.speedSlider.maximumValue = 10.0f;
    [self.configView addSubview:self.speedSlider];
    self.speedSlider.enabled = NO;
    
    self.popupView = [[SNPopupView alloc] initWithContentView:self.configView contentSize:CGSizeMake(200, 140)];

    
    
    self.configBarButton = [[UIBarButtonItem alloc] initWithTitle:@"Config" style:UIBarButtonSystemItemEdit target:self action:@selector(configReadState:)];
    self.navigationItem.rightBarButtonItem = self.configBarButton;
    
    UITapGestureRecognizer * tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(singleTapAction:)];
    tapGesture.numberOfTapsRequired = 1;
    //左右滑动的手势
    
    UISwipeGestureRecognizer * swipeLeftGesture = [[UISwipeGestureRecognizer alloc]initWithTarget:self action:@selector(swipeGestureAction:)];
    swipeLeftGesture.direction = UISwipeGestureRecognizerDirectionLeft;
    
    UISwipeGestureRecognizer * swipeRightGesture = [[UISwipeGestureRecognizer alloc]initWithTarget:self action:@selector(swipeGestureAction:)];
    swipeRightGesture.direction = UISwipeGestureRecognizerDirectionRight;
    
    self.textView = [[UITextView alloc] initWithFrame:CGRectMake(0, 0, 320, self.view.frame.size.height)];
    self.textView.editable = NO;
    self.textView.text = self.content;
    self.textView.font = [UIFont systemFontOfSize:self.fontSize];
    [self.textView addGestureRecognizer:tapGesture];
    [self.textView addGestureRecognizer:swipeLeftGesture];
    [self.textView addGestureRecognizer:swipeRightGesture];
    self.textView.autoresizingMask = UIViewAutoresizingFlexibleHeight;
    [self.view addSubview:self.textView];
    
}

- (void) viewDidUnload {
    [super viewDidUnload];
    // 懒得写了..self.xxview = nil;
    self.textView = nil;
    self.configBarButton = nil;
}

- (void) viewWillAppear:(BOOL)animated {
    [super viewWillAppear:NO];
    CATransition * animation = [CATransition animation];
    animation.type = @"oglFlip";
    animation.subtype = kCATransitionFromLeft;
    animation.duration = 0.45;
    animation.removedOnCompletion = YES;
    [self.navigationController.view.layer addAnimation:animation forKey:nil];
}

- (void) viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:NO];
    [self.pageTimer invalidate];
    self.pageTimer = nil;
    CATransition * animation = [CATransition animation];
    animation.type = @"oglFlip";
    animation.subtype = kCATransitionFromRight;
    animation.duration = 0.45;
    animation.removedOnCompletion = YES;
    [self.navigationController.view.layer addAnimation:animation forKey:nil];
    
}

- (void) autoPageChanged:(id) sender {
    UISwitch * s = (UISwitch *) sender;
    self.speedSlider.enabled = s.on;
}

- (void) configReadState:(id) sender {
    if (self.popupVisible) {
        [self.popupView dismiss];
        self.configBarButton.title = @"Config";
        [self configFinished];
        self.popupVisible = NO;
    } else {
        [self.popupView showFromBarButtonItem:self.configBarButton inView:self.view];
        self.configBarButton.title = @"Done";
        self.popupVisible = YES;
    }
    
}


- (void) configFinished {
    self.fontSize = (int) self.fontSizeSlider.value;
    self.textView.font = [UIFont systemFontOfSize:self.fontSize];
    
    [self.userDefault setValue:@(self.fontSize) forKey:kFontSizeId];
    self.autoPage = self.autoPageSwitch.on;
    self.autoSpeed = self.speedSlider.value;
    [self.userDefault setValue:@(self.autoSpeed) forKey:kAutoSpeedId];
    [self.userDefault synchronize];
    
    if (self.autoPage) {
        self.pageTimer = [NSTimer scheduledTimerWithTimeInterval:self.autoSpeed target:self selector:@selector(nextPage) userInfo:nil repeats:YES];
    } else {
        [self.pageTimer invalidate];
        self.pageTimer = nil;
    }
}


- (void) prevPage {
    
    CGContextRef context = UIGraphicsGetCurrentContext();
    [UIView beginAnimations:nil context:context];
    [UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];
    [UIView setAnimationDuration:0.75];
    CGPoint offset = self.textView.contentOffset;
    CGSize viewSize = self.textView.frame.size;
    
    offset.y -= viewSize.height - self.fontSize;
    if (offset.y < 0) {
        offset.y = 0;
    } else {
        [UIView setAnimationTransition:UIViewAnimationTransitionCurlDown forView:self.textView cache:YES];
    }
    [UIView commitAnimations];
    
    self.textView.contentOffset = offset;
}
- (void) nextPage {
    CGContextRef context = UIGraphicsGetCurrentContext();
    [UIView beginAnimations:nil context:context];
    [UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];
    [UIView setAnimationDuration:0.75];
    CGPoint offset = self.textView.contentOffset;
    CGSize viewSize = self.textView.frame.size;
    CGSize contentSize = self.textView.contentSize;
    offset.y += viewSize.height - self.fontSize;
    if (offset.y > (contentSize.height - viewSize.height)) {
        offset.y = contentSize.height - viewSize.height;
    } else {
        [UIView setAnimationTransition:UIViewAnimationTransitionCurlUp forView:self.textView cache:YES];
    }
    
    [UIView commitAnimations];
    
    self.textView.contentOffset = offset;
}
- (void) singleTapAction:(id)sender {
    //判断导航栏和toolbar是隐藏还是显示
    if(!self.visible) {
        self.visible = YES;
        [self.navigationController setNavigationBarHidden:self.visible animated:YES];
    } else {
        self.visible = NO;
        [self.navigationController setNavigationBarHidden:self.visible animated:YES];
        
    }
}

- (void) swipeGestureAction:(UISwipeGestureRecognizer *)recognizer {
    if (recognizer.direction==UISwipeGestureRecognizerDirectionLeft) {
        [self nextPage];
    }
    else if (recognizer.direction == UISwipeGestureRecognizerDirectionRight){
        
        [self prevPage];
    }
}

@end
