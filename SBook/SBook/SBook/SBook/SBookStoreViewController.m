//
//  SBookStoreViewController.m
//  SBook
//
//  Created by SunJiangting on 12-11-10.
//  Copyright (c) 2012年 sun. All rights reserved.
//

#define kBookRoot @"Books"

#import "SBookStoreViewController.h"

@interface SBookStoreViewController ()

@property (nonatomic, strong) UITableView * tableView;

@property (nonatomic, strong) NSUserDefaults * userDefaults;

/// bookarray @[@{@"type":@"类型1",@"path":@"",@"books":@[@"book1",@"book2"]}]
@property (nonatomic, strong) NSArray * bookArrays;

- (void) setupBookStores;

- (NSMutableArray *) booksFromBundle;

@end

@implementation SBookStoreViewController


- (id) initWithTitle:(NSString *)title
           imageName:(NSString *)imageName
         revealBlock:(RevealBlock)revealBlock {
    
    self = [super initWithTitle:title imageName:imageName revealBlock:revealBlock];
    if (self) {
        self.userDefaults = [NSUserDefaults standardUserDefaults];
    }
    return self;
}
- (void) loadView {
    [super loadView];
    [self setupBookStores];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"我的书架";
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemRefresh target:self action:@selector(refresh)];
    
    self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, 320, self.view.frame.size.height) style:UITableViewStylePlain];
    self.tableView.autoresizingMask = UIViewAutoresizingFlexibleHeight;
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    [self.view addSubview:self.tableView];
    
}

- (void) viewDidUnload {
    [super viewDidUnload];
    self.tableView = nil;
}

- (void) setupBookStores {
    //// [{title:'aaa','books':[book1,book2,book3....]}]
    if ([self.userDefaults objectForKey:kBookStore]) {
        self.bookArrays = [self.userDefaults objectForKey:kBookStore];
    } else {
        self.bookArrays = [self booksFromBundle];
    }
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    // Return the number of sections.
    return [self.bookArrays count];
}


- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    NSDictionary * dict = [self.bookArrays objectAtIndex:section];
    return [dict objectForKey:@"type"];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    NSDictionary * dict = [self.bookArrays objectAtIndex:section];
    NSArray * books = [dict valueForKey:@"books"];
    return [books count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView
         cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    NSDictionary * dict = [self.bookArrays objectAtIndex:indexPath.section];
    NSArray * books = [dict valueForKey:@"books"];
    static NSString * CELLNAME = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CELLNAME];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CELLNAME];
    }
    if (books.count < indexPath.row) {
        return nil;
    } else {
        cell.textLabel.text = [books objectAtIndex:indexPath.row];
    }
    
    return cell;
}

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    NSDictionary * dict = [self.bookArrays objectAtIndex:indexPath.section];
    NSString * path = [dict objectForKey:@"path"];
    NSString * name = [[dict objectForKey:@"books"] objectAtIndex:indexPath.row];
    SBookViewController * controller = [[SBookViewController alloc] initWithTitle:name path:path];
    [self.navigationController pushViewController:controller animated:YES];
    
}

- (void) clearData {
    [self.userDefaults removeObjectForKey:kBookStore];
    self.bookArrays = nil;
    [self.tableView reloadData];
}

- (void) refresh {
    self.bookArrays = [self booksFromBundle];
    [self.tableView reloadData];
}

- (NSMutableArray *) booksFromBundle {
    
    NSArray * types = [[NSBundle mainBundle] pathsForResourcesOfType:nil inDirectory:kBookRoot];
    
    NSMutableArray * array = [NSMutableArray arrayWithCapacity:20];
    for (NSString * type in types) {
        /// 如果没有/ 则说明是目录
        NSMutableArray * books = [NSMutableArray arrayWithCapacity:20];
        
        NSRange range = [type rangeOfString:[NSString stringWithFormat:@"%@/",kBookRoot]];
        NSString * typeTitle = [type substringFromIndex:range.location + range.length];
        NSMutableDictionary * dict = [NSMutableDictionary dictionaryWithCapacity:2];
        [dict setValue:typeTitle forKey:@"type"];
        [dict setValue:type forKey:@"path"];
        NSArray * temp = [[NSBundle mainBundle] pathsForResourcesOfType:@".txt" inDirectory:[NSString stringWithFormat:@"%@/%@",kBookRoot,typeTitle]];
        NSString * prefix = [NSString stringWithFormat:@"%@/",type];
        for (NSString * title in temp) {
            NSString * bookTitle = [[title stringByReplacingOccurrencesOfString:prefix withString:@""] stringByReplacingOccurrencesOfString:@".txt" withString:@""];
            [books addObject:bookTitle];
        }
        [dict setValue:books forKey:@"books"];
        [array addObject:dict];
        
    }
    
    [[NSUserDefaults standardUserDefaults] setValue:array forKey:kBookStore];
    [[NSUserDefaults standardUserDefaults] synchronize];
    return array;
}

@end
