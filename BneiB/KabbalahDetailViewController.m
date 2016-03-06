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

@interface KabbalahDetailViewController () <UITextViewDelegate>
@property (nonatomic) UIScrollView *scrollView;
@property (nonatomic) UIImageView *mainTitle;
@property (nonatomic) UIImageView *textBackground;
@property (nonatomic) UITextView *detailText;
@property (nonatomic) UIButton *viewButton;
@property (nonatomic) NSLayoutConstraint *detailTextHeightConstraint;

@end

@implementation KabbalahDetailViewController

- (UIScrollView *)scrollView {
    if (!_scrollView) {
        _scrollView = [[UIScrollView alloc] init];
        _scrollView.translatesAutoresizingMaskIntoConstraints = NO;
        _scrollView.showsHorizontalScrollIndicator = NO;
        _scrollView.showsVerticalScrollIndicator = NO;
        _scrollView.alwaysBounceVertical = YES;
    }
    return _scrollView;
}

- (instancetype)init {
    if ((self = [super init])) {
        self.navigationController.navigationBar.tintColor = [UIColor whiteColor];
    }
    return self;
}

- (void)setDetailItem:(id)selectedItem {
    if (_selected != selectedItem) {
        _selected = selectedItem;
        [self loadUIViews];
    }
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    self.navigationController.navigationBar.tintColor = [UIColor whiteColor];
    [self.navigationController.navigationBar setTranslucent:NO];
    [self.view addSubview:self.scrollView];
    [self loadUIViews];
    UIBarButtonItem *backButton = [[UIBarButtonItem alloc]
                                   initWithTitle:@" "
                                   style:UIBarButtonItemStylePlain
                                   target:nil
                                   action:nil];
    self.navigationItem.backBarButtonItem=backButton;
    
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



- (void)loadUIViews {
    //Main View
    self.title = self.selected.title;
    self.navigationItem.backBarButtonItem.title = @" ";
    
    
    [_scrollView setBackgroundColor:[UIColor kabStaticColor]];
    
    _mainTitle = [[UIImageView alloc] init];
    _mainTitle.translatesAutoresizingMaskIntoConstraints = NO;
    _mainTitle.contentMode = UIViewContentModeScaleAspectFill;
    [_mainTitle setImageWithURL:self.selected.backgroundURL placeholderImage:[UIImage imageNamed:@"bg_profile_empty"]];
    [self.scrollView addSubview:_mainTitle];
    
    _detailText = [[UITextView alloc] init];
    _detailText.translatesAutoresizingMaskIntoConstraints = NO;
    _detailText.backgroundColor = [UIColor clearColor];
    _detailText.textColor = [UIColor kabBlueColor];
    _detailText.font = [UIFont kabInterfaceFontOfSize:UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad ? 26.0 : 16.0];
    _detailText.textAlignment = NSTextAlignmentLeft;
    _detailText.autocapitalizationType = UITextAutocapitalizationTypeSentences;
    _detailText.autocorrectionType = UITextAutocorrectionTypeNo;
    _detailText.editable = NO;
    _detailText.scrollsToTop = YES;
    [_detailText setScrollEnabled:NO];
    [self.scrollView addSubview:_detailText];
    
    _viewButton = [[UIButton alloc] init];
    _viewButton.translatesAutoresizingMaskIntoConstraints = NO;
    [_viewButton setTitle:@"View More" forState:UIControlStateNormal];
    [_viewButton.titleLabel setFont:[UIFont boldKabInterfaceFontOfSize:20]];
    [_viewButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [_viewButton setTitleColor:[UIColor kabLightTextColor] forState:UIControlStateSelected];
    [_viewButton setBackgroundColor:[UIColor kabBlueColor]];
    [_viewButton addTarget:self action:@selector(pressedView:) forControlEvents:UIControlEventTouchUpInside];
    [self.scrollView addSubview:_viewButton];
    
    [_detailText setText:self.selected.detailDescription];
    CGRect rect = _detailText.frame;
    rect.size.height = _detailText.contentSize.height;
    self.detailTextHeightConstraint.constant = rect.size.height;
    
    NSDictionary *views = NSDictionaryOfVariableBindings(_mainTitle, _scrollView, _detailText);
    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-0-[_scrollView]-0-|" options:kNilOptions metrics:nil views:views]];
    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-0-[_scrollView]-0-|" options:kNilOptions metrics:nil views:views]];
    [self.scrollView addConstraint:[NSLayoutConstraint constraintWithItem:_mainTitle
                                                                attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual
                                                                   toItem:self.scrollView attribute:NSLayoutAttributeWidth
                                                               multiplier:1.0 constant:0.0]];
    [self.scrollView addConstraint:[NSLayoutConstraint constraintWithItem:_mainTitle
                                                                attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual
                                                                   toItem:self.scrollView attribute:NSLayoutAttributeWidth
                                                               multiplier:3.0/4.0 constant:0]];
    [self.scrollView addConstraint:[NSLayoutConstraint constraintWithItem:_detailText
                                                                attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual
                                                                   toItem:self.scrollView attribute:NSLayoutAttributeWidth
                                                               multiplier:1.0 constant:0.0]];
    [self.scrollView addConstraint:[NSLayoutConstraint constraintWithItem:_detailText
                                                                attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual
                                                                   toItem:_mainTitle attribute:NSLayoutAttributeBottom
                                                               multiplier:1.0 constant:0]];
    
    [self.scrollView addConstraint:[NSLayoutConstraint constraintWithItem:_viewButton attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:_detailText attribute:NSLayoutAttributeBottom multiplier:1.0 constant:10.0]];
    [self.scrollView addConstraint:[NSLayoutConstraint constraintWithItem:_viewButton attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:self.scrollView attribute:NSLayoutAttributeWidth multiplier:1.0 constant:0.0]];
    [self.scrollView addConstraint:[NSLayoutConstraint constraintWithItem:_viewButton attribute:NSLayoutAttributeCenterX relatedBy:NSLayoutRelationEqual toItem:self.scrollView attribute:NSLayoutAttributeCenterX multiplier:1.0 constant:0.0]];
    [self.scrollView addConstraint:[NSLayoutConstraint constraintWithItem:_viewButton attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:self.scrollView attribute:NSLayoutAttributeHeight multiplier:0.0 constant:44]];
    
    CGFloat height = CGRectGetHeight(self.view.bounds) + _viewButton.bounds.size.height + _detailTextHeightConstraint.constant + 350;
    NSLog(@"Height: %f", height);
    [_scrollView setContentSize:CGSizeMake(CGRectGetWidth(self.view.bounds), height)];
}

- (void)pressedView:(id)sender {
    KabbalahTVDetailViewController *detail = [[KabbalahTVDetailViewController alloc] init];
    detail.detailSelected = self.selected;
    [self.navigationController pushViewController:detail animated:YES];
    self.navigationItem.backBarButtonItem.title = @" ";
}

- (void)openActionSheet:(id)sender {
    
}

@end
