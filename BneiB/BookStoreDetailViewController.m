//
//  BookStoreDetailViewController.m
//  KabNew
//
//  Created by Gabriel Morales on 12/22/15.
//  Copyright © 2015 Gabe Morales. All rights reserved.
//

#import "BookStoreDetailViewController.h"
#import <AFNetworking/UIImageView+AFNetworking.h>
#import "BBEmptyDataSetSource.h"
#import "BBLoadingErrorEmptyDataSetSource.h"
#import "GMDWebViewController.h"

@interface BookStoreDetailViewController () <UITableViewDataSource, UITableViewDelegate, DZNEmptyDataSetDelegate>
@property (nonatomic) UITextView *synopsis;
@property (nonatomic) UILabel *titleLabel;
@property (nonatomic) UIImageView *bookImageView;
@property (nonatomic) UIButton *purchaseButton;
@property (nonatomic) UIButton *pdfButton;
@property (nonatomic) UITableView *table;
@property (nonatomic) CGFloat kTableheaderHeight;
@end

@implementation BookStoreDetailViewController

- (void)setDetailItem:(id)selectedItem {
    if (_selected != selectedItem) {
        _selected = selectedItem;
        //        [self loadUIViews];
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

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Setup
- (void)loadUIViews {
    
    _bookImageView = [[UIImageView alloc] init];
    _bookImageView.translatesAutoresizingMaskIntoConstraints = NO;
    _bookImageView.contentMode = UIViewContentModeScaleAspectFit;
    [_bookImageView setImageWithURL:[NSURL URLWithString:_selected.picLarge] placeholderImage:[UIImage imageNamed:@"bg_profile_empty"]];
    [self.view addSubview:_bookImageView];
    
    _titleLabel = [[UILabel alloc] init];
    _titleLabel.translatesAutoresizingMaskIntoConstraints = NO;
    _titleLabel.font = [UIFont boldKabInterfaceFontOfSize:15];
    _titleLabel.textColor = [UIColor kabBlueColor];
    _titleLabel.textAlignment = NSTextAlignmentLeft;
    _titleLabel.numberOfLines = 0;
    [_titleLabel setText:_selected.title];
    [self.view addSubview:_titleLabel];
    
    _synopsis = [[UITextView alloc] init];
    _synopsis.translatesAutoresizingMaskIntoConstraints = NO;
    [_synopsis setSelectable:NO];
    [_synopsis setEditable:NO];
    _synopsis.showsHorizontalScrollIndicator = NO;
    [_synopsis setBackgroundColor:[UIColor clearColor]];
    [_synopsis setTextColor:[UIColor kabLightTextColor]];
    [_synopsis setFont:[UIFont kabInterfaceFontOfSize:UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad ? 26.0 : 14.0]];
    [_synopsis setTextAlignment:NSTextAlignmentLeft];
    [_synopsis setAutocapitalizationType:UITextAutocapitalizationTypeSentences];
    [_synopsis setAutocorrectionType:UITextAutocorrectionTypeNo];
    _synopsis.scrollsToTop = YES;
    [_synopsis setText:_selected.synopsis];
    [self.view addSubview:_synopsis];
    
    _purchaseButton = [[UIButton alloc] init];
    _purchaseButton.translatesAutoresizingMaskIntoConstraints = NO;
    [_purchaseButton setTitle:@"Purchase" forState:UIControlStateNormal];
    [_purchaseButton.titleLabel setFont:[UIFont boldKabInterfaceFontOfSize:20]];
    [_purchaseButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [_purchaseButton setTitleColor:[UIColor kabLightTextColor] forState:UIControlStateSelected];
    [_purchaseButton setBackgroundColor:[UIColor kabBlueColor]];
    [_purchaseButton addTarget:self action:@selector(onPurchasePressed:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_purchaseButton];
    
    _pdfButton = [[UIButton alloc] init];
    _pdfButton.translatesAutoresizingMaskIntoConstraints = NO;
    [_pdfButton setTitle:@"Download" forState:UIControlStateNormal];
    [_pdfButton.titleLabel setFont:[UIFont boldKabInterfaceFontOfSize:20]];
    [_pdfButton setTitleColor:[UIColor kabBlueColor] forState:UIControlStateNormal];
    [_pdfButton setTitleColor:[UIColor kabLightTextColor] forState:UIControlStateSelected];
    [_pdfButton setBackgroundColor:[UIColor kabStaticColor]];
    [_pdfButton addTarget:self action:@selector(onDownloadPressed:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_pdfButton];
    
    [self setupContraints];
}

- (void)setupContraints {
    NSDictionary *views = NSDictionaryOfVariableBindings(_bookImageView, _titleLabel, _synopsis, _purchaseButton, _pdfButton);
    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-10-[_bookImageView(160)]-10-[_purchaseButton]-10-|" options:kNilOptions metrics:nil views:views]];
    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-10-[_bookImageView(240)]-10-[_titleLabel][_synopsis(400)]" options:kNilOptions metrics:nil views:views]];
    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-10-[_bookImageView]-10-[_pdfButton]-10-|" options:kNilOptions metrics:nil views:views]];
    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-30-[_purchaseButton(44)]-10-[_pdfButton(44)]" options:kNilOptions metrics:nil views:views]];
    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-10-[_titleLabel]|" options:kNilOptions metrics:nil views:views]];
    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-10-[_synopsis]|" options:kNilOptions metrics:nil views:views]];
}

#pragma mark - Actions
- (void)onPurchasePressed:(id)sender {
    
}

- (void)onDownloadPressed:(id)sender {
    
}

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

- (void)loadViews {
    
}

- (void)loadConstraints {
    NSDictionary *views = NSDictionaryOfVariableBindings(_table);
    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-0-[_table]-0-|" options:kNilOptions metrics:nil views:views]];
    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-0-[_table]-0-|" options:kNilOptions metrics:nil views:views]];
}

#pragma mark - UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView
 numberOfRowsInSection:(NSInteger)section
{
    return 5;
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
            [bookImage setContentMode:UIViewContentModeScaleAspectFit];
            [bookImage setImageWithURL:[NSURL URLWithString:_selected.picLarge] placeholderImage:[UIImage imageNamed:@"bg_profile_empty"]];
            [contentView addSubview:bookImage];
            
            NSDictionary *views = NSDictionaryOfVariableBindings(contentView, bookImage);
            [cell.contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-0-[contentView]-0-|" options:kNilOptions metrics:nil views:views]];
            [cell.contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-0-[contentView]-0-|" options:kNilOptions metrics:nil views:views]];
            
            [contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-0-[bookImage]-0-|" options:kNilOptions metrics:nil views:views]];
            [contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-0-[bookImage(==200)]-0-|" options:kNilOptions metrics:nil views:views]];
            [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
            break;
        }
        case 1: {
            //            cell.textLabel.font = [UIFont preferredFontForTextStyle:UIFontTextStyleTitle1];
            cell.textLabel.font = [UIFont boldKabInterfaceFontOfSize:22];
            cell.textLabel.textColor = [UIColor kabBlueColor];
            cell.textLabel.text = _selected.title;
            [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
            break;
        }
        case 2: {
            //            cell.textLabel.font = [UIFont preferredFontForTextStyle:UIFontTextStyleBody];
            cell.textLabel.font = [UIFont kabInterfaceFontOfSize:16];
            cell.textLabel.textColor = [UIColor kabLightTextColor];
            cell.textLabel.text = _selected.synopsis;
            [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
            break;
        }
        case 3: {
            cell.textLabel.font = IS_OS_9_OR_LATER ? [UIFont preferredFontForTextStyle:UIFontTextStyleTitle3] : [UIFont preferredFontForTextStyle:UIFontTextStyleSubheadline];
            cell.backgroundColor = [UIColor kabBlueColor];
            cell.textLabel.textColor = [UIColor whiteColor];
            [cell.textLabel setText:@"Purchase".uppercaseString];
            [cell.textLabel setTextAlignment:NSTextAlignmentCenter];
            break;
        }
        case 4: {
            cell.textLabel.font = IS_OS_9_OR_LATER ? [UIFont preferredFontForTextStyle:UIFontTextStyleTitle3] : [UIFont preferredFontForTextStyle:UIFontTextStyleSubheadline];
            cell.backgroundColor = [UIColor kabLightTextColor];
            cell.textLabel.textColor = [UIColor kabBlueColor];
            [cell.textLabel setText:@"Download".uppercaseString];
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

//- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
//    UIImageView *header = [[UIImageView alloc] init];
//    [header setImageWithURL:[NSURL URLWithString:_selected.picLarge] placeholderImage:[UIImage imageNamed:@"bg_profile_empty"]];
//    [header setContentMode:UIViewContentModeScaleAspectFit];
//    return header;
//}
//
//- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
//    return self.kTableheaderHeight;
//}

#pragma mark - UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    switch (indexPath.row) {
        case 3: {
            NSString *itunesURL = [self.selected.itunesURL stringByReplacingOccurrencesOfString:@"http:" withString:@""];
            NSString *storeURL = [NSString stringWithFormat:@"itms-books:%@", itunesURL];
            NSURL *url = [NSURL URLWithString:storeURL];
            [[UIApplication sharedApplication] openURL:url];
            break;
        }
        case 4: {
            NSString *downloadURL = [NSString stringWithFormat:@"%@", self.selected.pdfURL];
            NSURL *url = [NSURL URLWithString:downloadURL];
            GMDWebViewController *webView = [[GMDWebViewController alloc] init];
            dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0), ^(void) {
                //                [webView loadURL:url];
                webView.bookSelected = self.selected;
                //                webView.title = self.selected.title;
                dispatch_async(dispatch_get_main_queue(), ^(void) {
                    [self.navigationController pushViewController:webView animated:YES];
                });
            });
            break;
        }
            
        default:
            break;
    }
}


@end
