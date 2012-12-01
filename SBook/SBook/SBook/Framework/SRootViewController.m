//
//  SRootViewController.m
//  SBook
//
//  Created by SunJiangting on 12-11-11.
//  Copyright (c) 2012年 sun. All rights reserved.
//

#import "SRootViewController.h"

@interface SRootViewController () <GHSidebarSearchViewControllerDelegate>

@property (nonatomic, strong) GHSidebarSearchViewController *searchController;
@property (nonatomic, strong) UISearchBar * searchBar;
@property (nonatomic, strong) GHMenuViewController *menuController;
@property (nonatomic, copy) RevealBlock revealBlock;

@property (nonatomic, strong) NSMutableArray * controllers;

@property (nonatomic, strong) NSArray * headers;
//@property (nonatomic, strong) NSArray * controllers;
@property (nonatomic, strong) NSArray * cellInfos;

- (void) setupControllers;

@end

@implementation SRootViewController

- (id) init {
    self = [super initWithNibName:nil bundle:nil];
    if (self) {
        RevealBlock revealBlock = ^(){
            [self toggleSidebar:!self.sidebarShowing
                                        duration:kGHRevealSidebarDefaultAnimationDuration];
        };
        
        
        self.controllers = [NSMutableArray arrayWithCapacity:20];
        
        SBookStoreViewController * bookStoreController = [[SBookStoreViewController alloc] initWithTitle:@"精品小说" imageName:@"user.png" revealBlock:revealBlock];
        
        SPhotoStoreViewController * photoStoreController = [[SPhotoStoreViewController alloc] initWithTitle:@"精品图片" imageName:@"user.png" revealBlock:revealBlock];
        
        NSDictionary * local = @{
        @"header":@"本地阅读",
        @"controllers":@[
        [[UINavigationController alloc] initWithRootViewController:bookStoreController],
        [[UINavigationController alloc] initWithRootViewController:photoStoreController],
        ]
        };
        [self.controllers addObject:local];
        
        
        SPhotoRemoteViewController * photoRemoteController = [[SPhotoRemoteViewController alloc] initWithTitle:@"在线图片" imageName:@"user.png" revealBlock:revealBlock];
        NSDictionary * remote = @{
        @"header":@"在线阅读",
        @"controllers":@[
        [[UINavigationController alloc] initWithRootViewController:photoRemoteController],\
        ]
        };
        [self.controllers addObject:remote];
        
        
        [self setupControllers];
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"我的书屋";
    
    UIColor *bgColor = [UIColor colorWithRed:(50.0f/255.0f) green:(57.0f/255.0f) blue:(74.0f/255.0f) alpha:1.0f];
	self.view.backgroundColor = bgColor;
    
   
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark GHSidebarSearchViewControllerDelegate

- (void) setupControllers {
    [self.controllers enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop){
        NSDictionary * dict = (NSDictionary *)obj;
        NSArray * controllers = [dict objectForKey:@"controllers"];
        [controllers enumerateObjectsUsingBlock:^(id obj2, NSUInteger idx2, BOOL *stop2) {
            /// 添加左滑手势
            UIPanGestureRecognizer *panGesture = [[UIPanGestureRecognizer alloc] initWithTarget:self
                                                                                         action:@selector(dragContentView:)];
            panGesture.cancelsTouchesInView = YES;
            [((UINavigationController *)obj2).navigationBar addGestureRecognizer:panGesture];
 
        }];
    }];
    self.searchController = [[GHSidebarSearchViewController alloc] initWithSidebarViewController:self];
    self.searchController.searchDelegate = self;
    
    self.menuController = [[GHMenuViewController alloc] initWithRootViewController:self subViewControllers:self.controllers   searchBar:self.searchController.searchBar];
    
    
    
}

- (void)searchResultsForText:(NSString *)text withScope:(NSString *)scope callback:(SearchResultsBlock)callback {
    
}

- (void)searchResult:(id)result selectedAtIndexPath:(NSIndexPath *)indexPath {
	NSLog(@"Selected Search Result - result: %@ indexPath: %@", result, indexPath);
}

- (UITableViewCell *)searchResultCellForEntry:(id)entry atIndexPath:(NSIndexPath *)indexPath inTableView:(UITableView *)tableView {
	static NSString* identifier = @"GHSearchMenuCell";
	GHMenuCell* cell = [tableView dequeueReusableCellWithIdentifier:identifier];
	if (!cell) {
		cell = [[GHMenuCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
	}
	cell.textLabel.text = (NSString *)entry;
	cell.imageView.image = [UIImage imageNamed:@"user"];
	return cell;
}

@end
