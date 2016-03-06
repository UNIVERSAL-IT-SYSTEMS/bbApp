//
//  BookStoreViewController.m
//  KabNew
//
//  Created by Gabriel Morales on 12/22/15.
//  Copyright © 2015 Gabe Morales. All rights reserved.
//

#import "BookStoreViewController.h"
#import "FeedAPI.h"
#import "Book.h"
#import "BBEmptyDataSetSource.h"
#import "BBLoadingErrorEmptyDataSetSource.h"
#import "BookCell.h"
#import <AFNetworking/UIImageView+AFNetworking.h>
#import "GMHUDView.h"
#import "BookStoreDetailViewController.h"

@interface BookStoreViewController () <UITableViewDataSource, UITableViewDelegate, DZNEmptyDataSetDelegate>{
    FeedAPI *_feedAPI;
    NSArray *_bookItems;
    id<DZNEmptyDataSetSource> _emptyDataSetSource;
}

@property (nonatomic) UITableView *table;
@property (nonatomic, retain) UIImageView *cellImage;

@end

@implementation BookStoreViewController

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
    [self.view setBackgroundColor:[UIColor whiteColor]];
    //    [self.view setBackgroundColor:[UIColor colorWithPatternImage:[UIImage imageNamed:@"bg_texture"]]];
    [self.navigationItem setTitle:[NSString stringWithFormat:@"Library"]];
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

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
    [_table registerClass:[BookCell class] forCellReuseIdentifier:@"Cell"];
    _table.scrollEnabled = YES;
    [self.view addSubview:_table];
    [_table reloadData];
    
    NSDictionary *views = NSDictionaryOfVariableBindings(_table);
    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|[_table]|" options:kNilOptions metrics:nil views:views]];
    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|[_table]|" options:kNilOptions metrics:nil views:views]];
}

#pragma mark - UITableViewDelegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
    
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [_bookItems count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *cellIdentifier = @"Cell";
    BookCell *cell = (BookCell *)[tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (!cell) {
        cell = [[BookCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:cellIdentifier];
    }
    //    FeedModel *model = [self.feedArray objectAtIndex:indexPath.row];
    Book *model = _bookItems[indexPath.row];
    cell.backgroundColor = [UIColor lightTextColor];
    [cell.titleLabel setText:model.title];
    [cell.subtitleLabel setText:[NSString stringWithFormat:@"Author: %@", model.author]];
    dispatch_async(dispatch_get_main_queue(), ^{
        [cell.cellImageView setImageWithURL:[NSURL URLWithString:model.picLarge] placeholderImage:[UIImage imageNamed:@"placeholder"]];
    });
    cell.separatorInset = UIEdgeInsetsMake(0.0, 90, 0.0, 0.0);
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    return (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) ? 120 : 110;
}

- (CGFloat)tableView:(UITableView *)tableView estimatedHeightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) ? 120 : 110;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    //    NSIndexPath *index = [_table indexPathForSelectedRow];
    //    Book *selected = _channelItems[indexPath.row];
    //    KabbalahDetailViewController *detail = [[KabbalahDetailViewController alloc] init];
    //    [detail setDetailItem:selected];
    //    [detail setHidesBottomBarWhenPushed:YES];
    //    //    self.navigationController.modalTransitionStyle = UIModalTransitionStyleCoverVertical;
    //    [self.navigationController pushViewController:detail animated:YES];
    //    [_table deselectRowAtIndexPath:index animated:YES];
    
    Book *selected = _bookItems[indexPath.row];
    BookStoreDetailViewController *detail = [[BookStoreDetailViewController alloc] init];
    [detail setDetailItem:selected];
    [self.navigationController pushViewController:detail animated:YES];
    [_table deselectRowAtIndexPath:[_table indexPathForSelectedRow] animated:YES];
    
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
    [[FeedAPI api] getBooksWithCompletion:^(NSArray<Book *> *books, NSError *error) {
        _bookItems = books;
        if (books.count == 0) {
            _emptyDataSetSource = [BBEmptyDataSetSource emptyDataSetSourceWithTitle:@"No Books Available" description:@"Sorry, we couldn't find what you're looking for. Please try again later."];
        } else if (error != nil) {
            _emptyDataSetSource = [BBLoadingErrorEmptyDataSetSource new];
            [self showAlertWithTitle:@"Loading Error." andMessage:error.localizedDescription];
        } else {
            _emptyDataSetSource = nil;
        }
        _table.emptyDataSetSource = _emptyDataSetSource;
        [self sortFeed:_bookItems];
        [hud completeAndDismissWithTitle:@"Loaded"];
    }];
}

- (void)sortFeed:(NSArray *)sorted {
    NSSortDescriptor *descriptor = [[NSSortDescriptor alloc] initWithKey:@"title" ascending:YES];
    _bookItems = [sorted sortedArrayUsingDescriptors:@[descriptor]].mutableCopy;
    [self.table reloadData];
}

- (void)showAlertWithTitle:(NSString *)title andMessage:(NSString *)message {
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:title message:message preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *cancel = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:nil];
    [alert addAction:cancel];
    [self presentViewController:alert animated:YES completion:nil];
}
@end
