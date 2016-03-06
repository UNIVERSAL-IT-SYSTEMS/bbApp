//
//  KabbalahViewController.m
//  KabNew
//
//  Created by Rockstar. on 10/31/14.
//  Copyright (c) 2014 Gabe Morales. All rights reserved.
//

#import "KabbalahViewController.h"
#import "CustomCell.h"
#import "KabbalahDetailViewController.h"
#import "FeedAPI.h"
#import "FeedModel.h"
#import <AFNetworking/UIImageView+AFNetworking.h>
#import "GMHUDView.h"
#import "BBEmptyDataSetSource.h"
#import "BBLoadingErrorEmptyDataSetSource.h"

@interface KabbalahViewController ()<UITableViewDataSource, UITableViewDelegate, DZNEmptyDataSetDelegate> {
    FeedAPI *_feedAPI;
    NSArray *_channelItems;
    id<DZNEmptyDataSetSource> _emptyDataSetSource;
}
@property (nonatomic) UITableView *table;
//@property (nonatomic) NSMutableArray *feedArray;

@end

@implementation KabbalahViewController

static NSString *const reuseIdentifier = @"Cell";

- (void)awakeFromNib {
    [super awakeFromNib];
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
    [self.navigationItem setTitle:[NSString stringWithFormat:@"Kabbalah"]];
    UIBarButtonItem *backButton = [[UIBarButtonItem alloc]
                                   initWithTitle:@" "
                                   style:UIBarButtonItemStylePlain
                                   target:nil
                                   action:nil];
    self.navigationItem.backBarButtonItem=backButton;
    [self setTableView];
    [self checkInternet];
    [self loadFeed];
}

- (void)setTableView {
    _table = [[UITableView alloc] init];
    _table.translatesAutoresizingMaskIntoConstraints = NO;
    _table.backgroundColor = [UIColor lightTextColor];
    _table.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
    _table.delegate = self;
    _table.dataSource = self;
    _table.emptyDataSetDelegate = self;
    _table.tableFooterView = [UIView new];
    [_table registerClass:[CustomCell class] forCellReuseIdentifier:@"Cell"];
    _table.scrollEnabled = YES;
    [self.view addSubview:_table];
    [_table reloadData];
    
    NSDictionary *views = NSDictionaryOfVariableBindings(_table);
    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-0-[_table]-0-|" options:kNilOptions metrics:nil views:views]];
    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-0-[_table]-0-|" options:kNilOptions metrics:nil views:views]];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.navigationController.navigationBar setHidden:NO];
    [self.tabBarController.tabBar setHidden:NO];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    [_table reloadData];
    
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
    
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [_channelItems count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *cellIdentifier = @"Cell";
    CustomCell *cell = (CustomCell *)[tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (!cell) {
        cell = [[CustomCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:cellIdentifier];
    }
    //    FeedModel *model = [self.feedArray objectAtIndex:indexPath.row];
    FeedModel *model = _channelItems[indexPath.row];
    cell.backgroundColor = [UIColor lightTextColor];
    [cell.titleLabel setText:model.title];
    [cell.subtitleLabel setText:model.detail];
    dispatch_async(dispatch_get_main_queue(), ^{
        [cell.cellImageView setImageWithURL:model.cellImageURL placeholderImage:[UIImage imageNamed:@"placeholder"]];
    });
    cell.separatorInset = UIEdgeInsetsMake(0.0, 100, 0.0, 0.0);
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    return (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) ? 120 : 100;
}

- (CGFloat)tableView:(UITableView *)tableView estimatedHeightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) ? 120 : 100;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    NSIndexPath *index = [_table indexPathForSelectedRow];
    FeedModel *selected = _channelItems[indexPath.row];
    KabbalahDetailViewController *detail = [[KabbalahDetailViewController alloc] init];
    [detail setDetailItem:selected];
    [detail setHidesBottomBarWhenPushed:YES];
    //    self.navigationController.modalTransitionStyle = UIModalTransitionStyleCoverVertical;
    [self.navigationController pushViewController:detail animated:YES];
    [_table deselectRowAtIndexPath:index animated:YES];
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

#pragma mark - Helper Methods

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
    [[FeedAPI api] getChannelWithCompletion:^(NSArray<FeedModel *> *channel, NSError *error) {
        _channelItems = channel;
        if (channel.count == 0) {
            _emptyDataSetSource = [BBEmptyDataSetSource emptyDataSetSourceWithTitle:@"No Channel Items" description:@"Sorry, we couldn't find what you're looking for. Please try again later."];
        } else if (error != nil) {
            _emptyDataSetSource = [BBLoadingErrorEmptyDataSetSource new];
            [self showAlertWithTitle:@"Loading Error." andMessage:error.localizedDescription];
        } else {
            _emptyDataSetSource = nil;
        }
        _table.emptyDataSetSource = _emptyDataSetSource;
        [self sortFeed:_channelItems];
        [hud completeAndDismissWithTitle:@"Loaded"];
    }];
}

- (void)sortFeed:(NSArray *)sorted {
    NSSortDescriptor *descriptor = [[NSSortDescriptor alloc] initWithKey:@"title" ascending:YES];
    _channelItems = [sorted sortedArrayUsingDescriptors:@[descriptor]].mutableCopy;
    [self.table reloadData];
}

- (void)showAlertWithTitle:(NSString *)title andMessage:(NSString *)message {
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:title message:message preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *cancel = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:nil];
    [alert addAction:cancel];
    [self presentViewController:alert animated:YES completion:nil];
}

@end
