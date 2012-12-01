//
//  GHRootViewController.m
//  GHSidebarNav
//
//  Created by Greg Haines on 11/20/11.
//

#import "GTViewController.h"

#pragma mark -
#pragma mark Private Interface
@interface GTViewController ()
- (void)revealSidebar;
@end


#pragma mark -
#pragma mark Implementation
@implementation GTViewController

- (id)initWithTitle:(NSString *)title
          imageName:(NSString *) imageName
        revealBlock:(RevealBlock)revealBlock {
    
    if (self = [super initWithNibName:nil bundle:nil]) {
        
		self.tabBarItem.title = title;
        self.tabBarItem.image = [UIImage imageNamed:imageName];
		_revealBlock = [revealBlock copy];
		self.navigationItem.leftBarButtonItem = 
			[[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAction 
														  target:self
														  action:@selector(revealSidebar)];
	}
	return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
	self.view.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
	self.view.backgroundColor = [UIColor lightGrayColor];
}


- (void)revealSidebar {
	_revealBlock();
}

@end
