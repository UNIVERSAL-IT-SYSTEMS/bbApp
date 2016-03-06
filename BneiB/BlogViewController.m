//
//  BlogViewController.m
//  KabNew
//
//  Created by Rockstar. on 10/31/14.
//  Copyright (c) 2014 Gabe Morales. All rights reserved.
//

#import "BlogViewController.h"
#import "FeedAPI.h"
#import "Blog.h"
#import "BlogCell.h"
#import "DocumentRoot.h"
#import "Element.h"
#import "UIImageView+AFNetworking.h"
#import "BlogDetailViewController.h"
#import "GMHudView.h"
#import "BBEmptyDataSetSource.h"
#import "BBLoadingErrorEmptyDataSetSource.h"


@interface BlogViewController ()<UITableViewDataSource, UITableViewDelegate, GMDPTRViewDelegate, DZNEmptyDataSetDelegate>{
    FeedAPI *_feedAPI;
    NSArray *_blogItems;
    id<DZNEmptyDataSetSource> _emptyDataSetSource;
}

@property (nonatomic) UITableView *table;
@property (nonatomic, retain) UIImageView *cellImage;
@property (nonatomic, strong) GMDPTRView *pullToRefreshView;

@end

@implementation BlogViewController

- (instancetype)init {
    if ((self = [super init])) {
        [self commonInit];
        [self.navigationController.navigationBar setBarStyle:UIBarStyleBlack];
        
    }
    return self;
}

- (instancetype)initWithCoder:(NSCoder *)aDecoder {
    if (self = [super initWithCoder:aDecoder]) {
        [self commonInit];
    }
    return self;
}

- (void)commonInit {
    _feedAPI = [FeedAPI api];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.navigationItem setTitle:[NSString stringWithFormat:@"Blog"]];
    UIBarButtonItem *backButton = [[UIBarButtonItem alloc]
                                   initWithTitle:@" "
                                   style:UIBarButtonItemStylePlain
                                   target:nil
                                   action:nil];
    self.navigationItem.backBarButtonItem=backButton;
    
    [self.view setBackgroundColor:[UIColor colorWithPatternImage:[UIImage imageNamed:@"bg_texture"]]];
    
    [self checkInternet];
    [self setTableView];
    [self loadFeed];
    
    NSDictionary *viewDict = NSDictionaryOfVariableBindings(_table);
    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-0-[_table]-0-|"
                                                                      options:kNilOptions metrics:nil
                                                                        views:viewDict]];
    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|[_table]-0-|"
                                                                      options:kNilOptions metrics:nil
                                                                        views:viewDict]];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.navigationController.navigationBar setHidden:NO];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
}

- (void)setTableView {
    _table = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
    _table.translatesAutoresizingMaskIntoConstraints = NO;
    _table.backgroundColor = [UIColor lightTextColor];
    _table.delegate = self;
    _table.dataSource = self;
    _table.emptyDataSetDelegate = self;
    _table.tableFooterView = [UIView new];
    [_table registerClass:[BlogCell class] forCellReuseIdentifier:@"Cell"];
    _table.scrollEnabled = YES;
    [_table setSeparatorInset:UIEdgeInsetsMake(0.0, 90.0, 0.0, 0.0)];
    [_table reloadData];
    [self.view addSubview:_table];
    
    self.pullToRefreshView = [[GMDPTRView alloc] initWithScrollView:self.table delegate:self];
    
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [_blogItems count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *cellIdentifier = @"Cell";
    
    Blog *blog = _blogItems[indexPath.row];
    NSString *source = blog.summary;
    DocumentRoot *document = [Element parseHTML:source];
    Element *elements = [document selectElement:@"img"];
    NSString *imageString = [elements attribute:@"src"];
    
    BlogCell *cell = (BlogCell *)[tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (!cell) {
        cell = [[BlogCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:cellIdentifier];
    }
    
    [cell.cellImageView setImageWithURL:[NSURL URLWithString:imageString]
                       placeholderImage:[UIImage imageNamed:@"placeholder"]];
    [cell.titleLabel setText:blog.title];
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateStyle:NSDateFormatterMediumStyle];
    [dateFormatter setTimeStyle:NSDateFormatterShortStyle];
    
    [cell.subtitleLabel setText:[dateFormatter stringFromDate:blog.date]];
    cell.separatorInset = UIEdgeInsetsMake(0.0, 90.0, 0.0, 0.0);
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    return (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) ? 120 : 100;
}

- (CGFloat)tableView:(UITableView *)tableView estimatedHeightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) ? 120 : 100;
}

#pragma mark - TableView delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    Blog *selected = _blogItems[indexPath.row];
    BlogDetailViewController *webView = [[BlogDetailViewController alloc] init];
    webView.item = selected;
    [webView setHidesBottomBarWhenPushed:YES];
    [self.navigationController pushViewController:webView animated:YES];
    [self.table deselectRowAtIndexPath:indexPath animated:YES];
    
}

- (void)reloadTableData {
    //    Parser *rssParser = [[Parser alloc] init];
    //    [rssParser parseRssFeed:NSLocalizedString(@"Blog", nil) withDelegate:self];
    //    [_table reloadData];
}

#pragma mark - PTR
- (BOOL)pullToRefreshViewShouldStartLoading:(GMDPTRView *)view {
    return YES;
}

- (BOOL)pullToRefreshViewDidStartLoading:(GMDPTRView *)view {
    [self refresh];
    return YES;
}

- (void)pullToRefreshViewDidFinishLoading:(GMDPTRView *)view {
    
}

- (void)refresh {
    double delayInSeconds = 2.0;
    dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, delayInSeconds *NSEC_PER_SEC);
    dispatch_queue_t backgroundQueue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    dispatch_after(popTime, backgroundQueue, ^{
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.pullToRefreshView finishLoading];
            [self reloadTableData];
            [self.table reloadData];
        });
    });
}


#pragma mark - DZNEmptyDataSetSource methods -
- (UIColor*) backgroundColorForEmptyDataSet:(UIScrollView*)scrollView
{
    return [UIColor whiteColor];
}

- (CGPoint) offsetForEmptyDataSet:(UIScrollView *)scrollView
{
    return CGPointMake(-scrollView.contentInset.left / 2.0f, 0);
}

#pragma mark - DZNEmptyDataSet delegate methods -

- (BOOL) emptyDataSetShouldShow:(UIScrollView *)scrollView
{
    return ![self.table numberOfRowsInSection:0];
}

- (BOOL) emptyDataSetShouldAllowTouch:(UIScrollView *)scrollView
{
    return NO;
}

- (void)checkInternet {
    _internetReach = [Reachability reachabilityForInternetConnection];
    [_internetReach startNotifier];
    NetworkStatus netStatus = [_internetReach currentReachabilityStatus];
    switch (netStatus) {
        case ReachableViaWWAN:
        case ReachableViaWiFi: {
            break;
        }
        case NotReachable: {
            [self showAlertWithTitle:@"Alert" andMessage:@"No internet connection detected. Some functionality will be limited until a connection is made."];
            break;
        }
    }
}

- (void)loadFeed {
    GMHudView *hud = [[GMHudView alloc] initWithTitle:@"Loading..." loading:YES];
    [hud show];
    [_feedAPI getBlogWithCompletion:^(NSArray<Blog *> *blog, NSError *error) {
        _blogItems = blog;
        if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) {
            BlogDetailViewController *detail = [[BlogDetailViewController alloc] init];
            [detail setItem:_blogItems.firstObject];
        }
        if (blog.count == 0) {
            _emptyDataSetSource = [BBEmptyDataSetSource emptyDataSetSourceWithTitle:@"No Blog Items" description:@"Sorry, we couldn't find what you're looking for. Please try again later."];
        } else if (error != nil) {
            _emptyDataSetSource = [BBLoadingErrorEmptyDataSetSource new];
        } else {
            _emptyDataSetSource = nil;
        }
        _table.emptyDataSetSource = _emptyDataSetSource;
        [self sortFeed:_blogItems];
        [hud completeAndDismissWithTitle:@"Loaded"];
    }];
}

- (void)sortFeed:(NSArray *)sorted {
    NSSortDescriptor *descriptor = [[NSSortDescriptor alloc] initWithKey:@"date" ascending:NO];
    _blogItems = [sorted sortedArrayUsingDescriptors:@[descriptor]].mutableCopy;
    [self.table reloadData];
}

- (void)showAlertWithTitle:(NSString *)title andMessage:(NSString *)message {
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:title message:message preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *cancel = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:nil];
    [alert addAction:cancel];
    [self presentViewController:alert animated:YES completion:nil];
}
@end
