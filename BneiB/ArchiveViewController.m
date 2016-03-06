//
//  ArchiveViewController.m
//  KabNew
//
//  Created by Gabriel Morales on 12/20/15.
//  Copyright © 2015 Gabe Morales. All rights reserved.
//

#import "ArchiveViewController.h"
#import "GMHudView.h"
#import "CustomCell.h"
#import "UIImageView+AFNetworking.h"
#import "BBEmptyDataSetSource.h"
#import "BBLoadingErrorEmptyDataSetSource.h"
#import "FeedAPI.h"
#import "Archive.h"
#import "BlogDetailViewController.h"

@interface ArchiveViewController () <DZNEmptyDataSetDelegate>

@end

@implementation ArchiveViewController
{
    FeedAPI *_feedAPI;
    NSArray *_archiveItems;
    id<DZNEmptyDataSetSource> _emptyDataSetSource;
}

- (instancetype)init {
    if (self = [super init]) {
        [self commonInit];
        [self.navigationController.navigationBar setBarStyle:UIBarStyleBlack];
        //        [self.view addSubview:self.avatarImageView];
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

#pragma mark - NSObject
- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

#pragma mark - UIViewController
- (void)viewDidLoad {
    [super viewDidLoad];
    UIBarButtonItem *backButton = [[UIBarButtonItem alloc]
                                   initWithTitle:@" "
                                   style:UIBarButtonItemStylePlain
                                   target:nil
                                   action:nil];
    self.navigationItem.backBarButtonItem=backButton;
    [self.navigationItem setTitle:[NSString stringWithFormat:@"Kabbalah Media"]];
    [self loadTableView];
    [self loadData];
    
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.navigationController.navigationBar setHidden:NO];
}


#pragma mark - UITableView
- (void)loadTableView {
    _table = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
    _table.translatesAutoresizingMaskIntoConstraints = NO;
    _table.backgroundColor = [UIColor kabStaticColor];
    _table.delegate = self;
    _table.dataSource = self;
    _table.emptyDataSetDelegate = self;
    _table.tableFooterView = [UIView new];
    [_table registerClass:[UITableViewCell class] forCellReuseIdentifier:@"Cell"];
    _table.scrollEnabled = YES;
    [_table reloadData];
    _table.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
    _table.separatorColor = [UIColor kabLightTextColor];
    [self.view addSubview:_table];
    
    NSDictionary *viewDict = @{@"table": _table};
    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|[table]|"
                                                                      options:kNilOptions metrics:nil
                                                                        views:viewDict]];
    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|[table]|"
                                                                      options:kNilOptions metrics:nil
                                                                        views:viewDict]];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _archiveItems.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *cellIdentifier = @"Cell";
    
    Archive *feed = _archiveItems[indexPath.row];
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:cellIdentifier];
    
    cell.textLabel.text = feed.title;
    cell.textLabel.font = [UIFont boldKabInterfaceFontOfSize:16];
    cell.textLabel.textColor = [UIColor kabBlueColor];
    cell.textLabel.numberOfLines = 0;
    
    NSString *date = [[self sharedDateFormatter] stringFromDate:feed.date];
    cell.detailTextLabel.text = date;
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateStyle:NSDateFormatterMediumStyle];
    [dateFormatter setTimeStyle:NSDateFormatterShortStyle];
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    return (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) ? 120 : UITableViewAutomaticDimension;
}

- (CGFloat)tableView:(UITableView *)tableView estimatedHeightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) ? 120 : 100;
}

#pragma mark - TableView delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    BlogDetailViewController *webView = [[BlogDetailViewController alloc] init];
    webView.item = _archiveItems[indexPath.row];
    [webView setHidesBottomBarWhenPushed:YES];
    [self.navigationController pushViewController:webView animated:YES];
    [self.table deselectRowAtIndexPath:indexPath animated:YES];
    
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
            //            [self.pullToRefreshView finishLoading];
            
            [self.table reloadData];
        });
    });
}

#pragma mark - Data
- (void)loadData {
    GMHudView *hud = [[GMHudView alloc] initWithTitle:@"Loading..." loading:YES];
    [hud show];
    [_feedAPI getFeedWithCompletion:^(NSArray<Archive *> *feed, NSError *error) {
        _archiveItems = feed;
        
        if (feed.count == 0) {
            _emptyDataSetSource = [BBEmptyDataSetSource emptyDataSetSourceWithTitle:@"Empty Archive" description:@"Sorry, we couldn't find what you're looking for. Please try again."];
        }
        else if (error != nil) {
            _emptyDataSetSource = [BBLoadingErrorEmptyDataSetSource new];
        } else {
            _emptyDataSetSource = nil;
        }
        _table.emptyDataSetSource = _emptyDataSetSource;
        [self sortFeed:_archiveItems];
        [hud completeAndDismissWithTitle:@"Loaded"];
    }];
}

- (void)sortFeed:(NSArray *)sorted {
    NSSortDescriptor *descriptor = [[NSSortDescriptor alloc] initWithKey:@"date" ascending:NO];
    _archiveItems = [sorted sortedArrayUsingDescriptors:@[descriptor]].mutableCopy;
    [self.table reloadData];
}

#pragma mark - Private Methods
- (NSDateFormatter *)sharedDateFormatter
{
    static NSDateFormatter *dateFormatter = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        dateFormatter = [NSDateFormatter new];
        dateFormatter.dateFormat = @"MMM d, yyyy";
    });
    return dateFormatter;
}

@end
