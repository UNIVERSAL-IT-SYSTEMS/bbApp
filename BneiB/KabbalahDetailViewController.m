//
//  KabbalahDetailViewController.m
//  KabNew
//
//  Created by Rockstar. on 11/8/14.
//  Copyright (c) 2014 Gabe Morales. All rights reserved.
//

#import "KabbalahDetailViewController.h"
#import "UIColor+kabIOSAdditions.h"
#import "UIFont+kabiOSAdditions.h"
#import "UIButton+kabiOSAdditions.h"
#import <AFNetworking/UIImageView+AFNetworking.h>
#import "KabbalahTVDetailViewController.h"
#import "BBEmptyDataSetSource.h"
#import "BBLoadingErrorEmptyDataSetSource.h"

@interface KabbalahDetailViewController () <UITableViewDataSource, UITableViewDelegate, DZNEmptyDataSetDelegate>
@property (nonatomic) UIImageView *mainTitle;
@property (nonatomic) UITextView *detailText;
@property (nonatomic) UILabel *titleLabel;
@property (nonatomic) UIButton *viewButton;
@property (nonatomic) UITableView *table;
@property (nonatomic) CGFloat kTableheaderHeight;
@property (nonatomic) NSLayoutConstraint *detailTextHeightConstraint;

@end

@implementation KabbalahDetailViewController

- (instancetype)init {
    if ((self = [super init])) {
        self.navigationController.navigationBar.tintColor = [UIColor whiteColor];
    }
    return self;
}

- (void)setDetailItem:(id)selectedItem {
    if (_selected != selectedItem) {
        _selected = selectedItem;
        [self loadTableView];
        [self loadConstraints];
    }
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.kTableheaderHeight = 250.0;
    self.view.backgroundColor = [UIColor whiteColor];
    [self.navigationItem setTitle:[NSString stringWithFormat:@"%@", _selected.title]];
    UIBarButtonItem *backButton = [[UIBarButtonItem alloc]
                                   initWithTitle:@" "
                                   style:UIBarButtonItemStylePlain
                                   target:nil
                                   action:nil];
    self.navigationItem.backBarButtonItem=backButton;
    // Do any additional setup after loading the view.
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Setup

#pragma mark - Tableview
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
    _table.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.view addSubview:_table];
}

- (void)loadConstraints {
    NSDictionary *views = NSDictionaryOfVariableBindings(_table);
    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|[_table]|" options:kNilOptions metrics:nil views:views]];
    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|[_table]|" options:kNilOptions metrics:nil views:views]];
}

#pragma mark - UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView
 numberOfRowsInSection:(NSInteger)section
{
    return 3;
}

- (UITableViewCell *)tableView:(UITableView *)tableView
         cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier forIndexPath:indexPath];
    cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:cellIdentifier];
    
    [self configureCell:cell forRowAtIndexPath:indexPath];
    
    return cell;
}

- (void)configureCell:(UITableViewCell *)cell
    forRowAtIndexPath:(NSIndexPath *)indexPath
{
    cell.textLabel.numberOfLines = 0;
    cell.backgroundColor = [UIColor kabStaticColor];
    switch (indexPath.row) {
        case 0: {
            UIView *contentView = [[UIView alloc] init];
            contentView.translatesAutoresizingMaskIntoConstraints = NO;
            [cell.contentView addSubview:contentView];
            
            UIImageView *bookImage = [[UIImageView alloc] init];
            bookImage.translatesAutoresizingMaskIntoConstraints = NO;
            [bookImage setContentMode:UIViewContentModeScaleAspectFill];
            [bookImage setImageWithURL:_selected.detailBackgroundURL placeholderImage:[UIImage imageNamed:@"bg_profile_empty"]];
            [contentView addSubview:bookImage];
            
            NSDictionary *views = NSDictionaryOfVariableBindings(contentView, bookImage);
            [cell.contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|[contentView]|" options:kNilOptions metrics:nil views:views]];
            [cell.contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|[contentView]|" options:kNilOptions metrics:nil views:views]];
            
            [contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|[bookImage]|" options:kNilOptions metrics:nil views:views]];
            [contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-0-[bookImage(==200)]-0-|" options:kNilOptions metrics:nil views:views]];
            [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
            break;
        }
        case 1: {
            //            cell.textLabel.font = [UIFont preferredFontForTextStyle:UIFontTextStyleBody];
            cell.textLabel.font = [UIFont kabInterfaceFontOfSize:16];
            cell.textLabel.textColor = [UIColor kabLightTextColor];
            cell.textLabel.text = _selected.detailDescription;
            [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
            break;
        }
        case 2: {
            cell.textLabel.font = IS_OS_9_OR_LATER ? [UIFont preferredFontForTextStyle:UIFontTextStyleTitle3] : [UIFont preferredFontForTextStyle:UIFontTextStyleSubheadline];
            cell.backgroundColor = [UIColor kabBlueColor];
            cell.textLabel.textColor = [UIColor whiteColor];
            [cell.textLabel setText:@"View".uppercaseString];
            [cell.textLabel setTextAlignment:NSTextAlignmentCenter];
            break;
        }
        default:
            break;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    return (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) ? 120 : UITableViewAutomaticDimension;
}

- (CGFloat)tableView:(UITableView *)tableView estimatedHeightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) ? 120 : 100;
}

#pragma mark - UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    switch (indexPath.row) {
        case 2: {
            KabbalahTVDetailViewController *detail = [[KabbalahTVDetailViewController alloc] init];
            detail.detailSelected = self.selected;
            [self.navigationController pushViewController:detail animated:YES];
            self.navigationItem.backBarButtonItem.title = @" ";
            break;
        }
        default:
            break;
    }
}

@end
