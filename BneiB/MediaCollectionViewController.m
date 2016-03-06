//
//  MediaCollectionViewController.m
//  KabNew
//
//  Created by Gabriel Morales on 12/20/15.
//  Copyright © 2015 Gabe Morales. All rights reserved.
//

#import "MediaCollectionViewController.h"
#import "ArchiveViewController.h"
#import "BookStoreViewController.h"
#import "GMDWebViewController.h"
#import "BBInforBaseViewController.h"

@interface MediaCollectionViewController ()<UICollectionViewDelegateFlowLayout>
@property (nonatomic) NSArray *menuItems;
@end

@implementation MediaCollectionViewController

- (instancetype)init {
    if ((self = [super init])) {
        self.navigationController.navigationBar.barStyle = UIBarStyleBlack;
    }
    return self;
}

- (void)awakeFromNib {
    [super awakeFromNib];
    self.preferredContentSize = (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) ? CGSizeMake(320.0, 600.0) : CGSizeMake(CGRectGetWidth(self.collection.bounds), CGRectGetHeight(self.collection.bounds) /3);
}

- (void)viewDidLoad {
    [super viewDidLoad];
    UIBarButtonItem *backButton = [[UIBarButtonItem alloc]
                                   initWithTitle:@" "
                                   style:UIBarButtonItemStylePlain
                                   target:nil
                                   action:nil];
    self.navigationItem.backBarButtonItem=backButton;
    [self.navigationItem setTitle:[NSString stringWithFormat:@"Media"]];
    
    self.menuItems = @[@"Media Archive", @"Library", @"Book Store", @"Courses", @"Events", @"Self-Study"];
    [self loadCollection];
    
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.tabBarController.tabBar setHidden:NO];
}

- (void)loadCollection {
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
    layout.scrollDirection = (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) ? UICollectionViewScrollDirectionVertical : UICollectionViewScrollDirectionVertical;
    [self.collection setCollectionViewLayout:layout];
    
    _collection = [[UICollectionView alloc] initWithFrame:CGRectMake(0.0f, 0.0f, self.view.bounds.size.width, self.view.bounds.size.height - 60) collectionViewLayout:layout];
    _collection.backgroundColor = [UIColor kabStaticColor];
    _collection.delegate = self;
    _collection.dataSource = self;
    _collection.translatesAutoresizingMaskIntoConstraints = NO;
    [_collection registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:@"Cell"];
    _collection.pagingEnabled = YES;
    _collection.scrollEnabled = NO;
    [_collection reloadData];
    [self.view addSubview:_collection];
    
    NSDictionary *viewDict = NSDictionaryOfVariableBindings(_collection);
    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|[_collection]|"
                                                                      options:kNilOptions metrics:nil
                                                                        views:viewDict]];
    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|[_collection]-50-|"
                                                                      options:kNilOptions metrics:nil
                                                                        views:viewDict]];
}


#pragma mark - UiCollectionView
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    CGFloat witdh = CGRectGetWidth(self.collection.bounds) / 2 - 2;
    CGFloat height = CGRectGetHeight(self.collection.bounds) / 3 - 22.333333;
    CGSize itemSize = CGSizeMake(witdh, height);
    CGSize deviceSize = (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) ? itemSize : CGSizeMake(CGRectGetWidth(self.collection.bounds)/2 -2, CGRectGetHeight(self.collection.bounds)/3);
    
    return deviceSize;
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section {
    return 1.0;
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section {
    return 1.0;
}

- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section {
    
    return (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) ? UIEdgeInsetsMake(1, 1, 1, 1) : UIEdgeInsetsMake(1, 1, 1, 1);
}

- (void)viewWillTransitionToSize:(CGSize)size withTransitionCoordinator:(id<UIViewControllerTransitionCoordinator>)coordinator {
    [super viewWillTransitionToSize:size withTransitionCoordinator:coordinator];
    [self updateCollectionViewLayoutWithSize:size];
}

- (void)updateCollectionViewLayoutWithSize:(CGSize)size {
    CGFloat witdh = CGRectGetWidth([UIScreen mainScreen].bounds) / 2 - 3;
    CGFloat height = CGRectGetHeight([UIScreen mainScreen].bounds) / 3 - 22.333333;
    UICollectionViewFlowLayout *layout = (UICollectionViewFlowLayout *)self.collection.collectionViewLayout;
    layout.itemSize = (size.width < size.height) ? CGSizeMake(witdh, height) : CGSizeMake(witdh, height);
    [layout invalidateLayout];
}

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return [self.menuItems count];
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"Cell" forIndexPath:indexPath];
    cell.backgroundColor = [UIColor colorWithWhite:0.0 alpha:0.1];
    cell.layer.cornerRadius = 3;
    
    UILabel *titleLabel = (UILabel *)[[UILabel alloc] init];
    titleLabel.translatesAutoresizingMaskIntoConstraints = NO;
    //    titleLabel.frame = CGRectMake(0.0f, cell.frame.size.height / 2 - 20, CGRectGetWidth(cell.frame), 42.0f);
    titleLabel.textColor = [UIColor kabBlueColor];
    titleLabel.shadowColor = [UIColor whiteColor];
    titleLabel.shadowOffset = CGSizeMake(0.0f, 1.0f);
    titleLabel.textAlignment = NSTextAlignmentCenter;
    titleLabel.font = [UIFont boldSystemFontOfSize:20.0f];
    titleLabel.text = [self.menuItems[indexPath.row] uppercaseString];
    [cell.contentView addSubview:titleLabel];
    
    NSDictionary *views = NSDictionaryOfVariableBindings(titleLabel);
    [cell.contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-0-[titleLabel]-0-|" options:kNilOptions metrics:nil views:views]];
    [cell.contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:[titleLabel(==42)]" options:kNilOptions metrics:nil views:views]];
    [cell.contentView addConstraint:[NSLayoutConstraint constraintWithItem:titleLabel attribute:NSLayoutAttributeCenterY relatedBy:NSLayoutRelationEqual toItem:cell.contentView attribute:NSLayoutAttributeCenterY multiplier:1.0 constant:0.0]];
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    switch (indexPath.row) {
        case 0: {
            ArchiveViewController *vc = [[ArchiveViewController alloc] init];
            [vc setHidesBottomBarWhenPushed:YES];
            [self.navigationController pushViewController:vc animated:YES];
            break;
        }
        case 1: {
            BookStoreViewController *vc = [[BookStoreViewController alloc] init];
            [vc setHidesBottomBarWhenPushed:YES];
            [self.navigationController pushViewController:vc animated:YES];
            break;
        }
        case 2: {
            [self loadWebViewWithString:@"https://www.kabbalahbooks.info/default.asp"];
            break;
        }
        case 3: {
            [self loadWebViewWithString:@"http://edu.kabbalah.info/course-catalog"];
            break;
        }
        case 4: {
            [self loadWebViewWithString:@"http://m.kab.tv/ios/events.html"];
            break;
        }
        case 5: {
            
            break;
        }
            
        default:
            break;
    }
    [_collection deselectItemAtIndexPath:[_collection indexPathsForSelectedItems].lastObject animated:YES];
}

- (void)loadWebViewWithString:(NSString *)urlString {
    GMDWebViewController *webView = [[GMDWebViewController alloc] init];
    [webView loadURL:[NSURL URLWithString:urlString]];
    [webView setHidesBottomBarWhenPushed:YES];
    [self.navigationController pushViewController:webView animated:YES];
}

- (void)loadAlertWithTitle:(NSString *)title andMessage:(NSString *)message {
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:title message:message preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *cancel = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleCancel handler:nil];
    [alert addAction:cancel];
    [self presentViewController:alert animated:YES completion:nil];
}

@end
