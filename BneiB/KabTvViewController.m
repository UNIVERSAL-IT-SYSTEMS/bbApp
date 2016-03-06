//
//  KabTvViewController.m
//  KabNew
//
//  Created by Rockstar. on 10/31/14.
//  Copyright (c) 2014 Gabe Morales. All rights reserved.
//

#import "KabTvViewController.h"
#import <MediaPlayer/MediaPlayer.h>
#import "GMDWebViewController.h"
#import <AVFoundation/AVFoundation.h>
#import <AVKit/AVKit.h>

@interface KabTvViewController () <UICollectionViewDelegateFlowLayout>
@property (nonatomic) UIButton *englishButton, *hebrewButton, *russianButton, *spanishButton, *scheduleButton;
@property (nonatomic) UIImageView *background;
@property (nonatomic, strong) MPMoviePlayerController *mp;
@property (nonatomic, strong) AVPlayerViewController *avP;
//@property (nonatomic) AVPlayer *player;
//@property (nonatomic) AVPlayerItem *playerItem;
@property (nonatomic) NSArray *menu;

@end

static void *AVPlayerPlaybackViewControllerStatusObservationContext = &AVPlayerPlaybackViewControllerStatusObservationContext;

@implementation KabTvViewController
@synthesize collection = _collection;

- (void)awakeFromNib {
    [super awakeFromNib];
    self.preferredContentSize = (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) ? CGSizeMake(320.0, 600.0) : CGSizeMake(CGRectGetWidth(self.collection.bounds), CGRectGetHeight(self.collection.bounds) /3);
}


- (instancetype)init {
    if ((self = [super init])) {
        self.navigationController.navigationBar.barStyle = UIBarStyleBlack;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.navigationItem setTitle:[NSString stringWithFormat:@"KabTV"]];
    UIBarButtonItem *backButton = [[UIBarButtonItem alloc]
                                   initWithTitle:@" "
                                   style:UIBarButtonItemStylePlain
                                   target:nil
                                   action:nil];
    self.navigationItem.backBarButtonItem=backButton;
    
    [self loadCollection];
    
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.tabBarController.tabBar setHidden:NO];
    _englishButton.alpha = 1.0f;
}


- (void)loadCollection {
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAction target:self action:@selector(share:)];
    self.navigationItem.rightBarButtonItem.tintColor = [UIColor whiteColor];
    self.menu = @[@"ENGLISH",@"עברית",@"PYCCKий",@"ESPAÑOL",@"ITALIANO",@"SCHEDULE"];
    
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
    layout.scrollDirection = (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) ? UICollectionViewScrollDirectionVertical : UICollectionViewScrollDirectionVertical;
    
    [self.collection setCollectionViewLayout:layout];
    
    _collection = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:layout];
    _collection.backgroundColor = [UIColor kabStaticColor];
    _collection.delegate = self;
    _collection.dataSource = self;
    _collection.translatesAutoresizingMaskIntoConstraints = NO;
    [_collection registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:@"Cell"];
    _collection.pagingEnabled = YES;
    _collection.scrollEnabled = NO;
    [_collection reloadData];
    
    [self.view addSubview:_collection];
    
    NSDictionary *viewDict = @{@"collection": _collection};
    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|[collection]|"
                                                                      options:kNilOptions metrics:nil
                                                                        views:viewDict]];
    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|[collection]-50-|"
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
    return [self.menu count];
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
    titleLabel.text = [self.menu[indexPath.row] uppercaseString];
    [cell.contentView addSubview:titleLabel];
    
    NSDictionary *views = NSDictionaryOfVariableBindings(titleLabel);
    [cell.contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-[titleLabel]-|" options:kNilOptions metrics:nil views:views]];
    [cell.contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:[titleLabel(==42)]" options:kNilOptions metrics:nil views:views]];
    [cell.contentView addConstraint:[NSLayoutConstraint constraintWithItem:titleLabel attribute:NSLayoutAttributeCenterY relatedBy:NSLayoutRelationEqual toItem:cell.contentView attribute:NSLayoutAttributeCenterY multiplier:1.0 constant:0.0]];
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    //    switch (indexPath.row) {
    //        case 0: [self loadVideoWithURL:[NSURL URLWithString:@"http://edge1.nl.kab.tv/rtplive/live1-eng-mobile.stream/playlist.m3u8"]]; break;
    //        case 1: [self loadVideoWithURL:[NSURL URLWithString:@"http://edge1.nl.kab.tv/rtplive/live1-heb-mobile.stream/playlist.m3u8"]]; break;
    //        case 2: [self loadVideoWithURL:[NSURL URLWithString:@"http://edge1.nl.kab.tv/rtplive/live1-rus-mobile.stream/playlist.m3u8"]]; break;
    //        case 3: [self loadVideoWithURL:[NSURL URLWithString:@"http://edge1.nl.kab.tv/rtplive/live1-spa-mobile.stream/playlist.m3u8"]]; break;
    //        case 5: [self loadWebView]; break;
    //        default: [self loadAlertWithTitle:@"Alert" andMessage:@"Language is still not supported"]; break;
    //    }
    
    switch (indexPath.row) {
        case 0: [self loadVideoPlayerplayURL:[NSURL URLWithString:[NSString stringWithFormat:@"http://edge1.nl.kab.tv/rtplive/live1-eng-mobile.stream/playlist.m3u8"]]]; break;
        case 1: [self loadVideoPlayerplayURL:[NSURL URLWithString:[NSString stringWithFormat:@"http://edge1.nl.kab.tv/rtplive/live1-heb-mobile.stream/playlist.m3u8"]]]; break;
        case 2: [self loadVideoPlayerplayURL:[NSURL URLWithString:[NSString stringWithFormat:@"http://edge1.nl.kab.tv/rtplive/live1-rus-mobile.stream/playlist.m3u8"]]]; break;
        case 3: [self loadVideoPlayerplayURL:[NSURL URLWithString:[NSString stringWithFormat:@"http://edge1.nl.kab.tv/rtplive/live1-spa-mobile.stream/playlist.m3u8"]]]; break;
        case 5: [self loadWebView]; break;
        default: [self loadAlertWithTitle:@"Alert" andMessage:@"Language still not supported"]; break;
    }
}

- (void)loadWebView {
    GMDWebViewController *viewController = [[GMDWebViewController alloc] init];
    [viewController loadURL:[NSURL URLWithString:@"http://kab.tv/tvlist_gen.php?lang=English"]];
    [viewController.navigationController.navigationBar setTintColor:[UIColor whiteColor]];
    [self.tabBarController.tabBar setHidden:YES];
    [self.navigationController pushViewController:viewController animated:YES];
}

- (void)loadAlertWithTitle:(NSString *)title andMessage:(NSString *)message {
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:title message:message preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *cancel = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleCancel handler:nil];
    [alert addAction:cancel];
    [self presentViewController:alert animated:YES completion:nil];
}
#pragma mark - Media

- (void)loadVideoPlayerplayURL:(NSURL *)url {
    MPMoviePlayerViewController *media = [[MPMoviePlayerViewController alloc] initWithContentURL:url];
    [media.moviePlayer setAllowsAirPlay:YES];
    [[media view] setFrame:[self.view bounds]];
    [media.moviePlayer prepareToPlay];
    [media.navigationController.navigationBar setTintColor:[UIColor whiteColor]];
    [self presentMoviePlayerViewControllerAnimated:media];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(moviePlayBackStateChange:)
                                                 name:MPMoviePlayerPlaybackStateDidChangeNotification
                                               object:[media moviePlayer]];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(moviePlayBackStateChange:) name:MPMoviePlayerPlaybackDidFinishNotification object:[media moviePlayer]];
}

//- (void)loadVideoWithURL:(NSURL *)url {
//    [[AVAudioSession sharedInstance] setCategory:AVAudioSessionCategoryPlayback error:nil];
//    self.avP= [[AVPlayerViewController alloc] init];
//    self.player = [[AVPlayer alloc] initWithURL:url];
//    self.avP.player = self.player;
//    [self presentViewController:self.avP animated:YES completion:nil];
//    [self.player play];
//}
//
//- (void)playerPlayBackStateChange:(NSNotification *)notification {
//    AVPlayer *player = notification.object;
//    switch (player.status) {
//        case AVPlayerStatusUnknown:
//            NSLog(@"Unknown");
//            break;
//        case AVPlayerStatusFailed: [self loadAlertWithTitle:@"Alert" andMessage:player.error.localizedDescription];
//            break;
//        default:
//            break;
//    }
//}


- (void)moviePlayBackStateChange:(NSNotification *)notification
{
    MPMoviePlayerController *player = notification.object;
    switch (player.playbackState) {
        case MPMoviePlaybackStatePlaying: NSLog(@"Normal Playing"); break;
        case MPMoviePlaybackStatePaused: NSLog(@"Paused playing"); break;
        case MPMoviePlaybackStateStopped: NSLog(@"Stopped"); break;
        case MPMoviePlaybackStateInterrupted: [self loadAlertWithTitle:@"Alert" andMessage:@"Feed is not available at this time, please try again later."]; break;
        default: break;
    }
    
    switch (player.loadState) {
        case MPMovieLoadStatePlayable: NSLog(@"Playable"); break;
        case MPMovieLoadStateStalled: NSLog(@"Stalled"); break;
        case MPMovieLoadStatePlaythroughOK: NSLog(@"Playtrhough ok "); break;
        case MPMovieLoadStateUnknown: NSLog(@"Unknown"); break;
        default: break;
    }
    
    
    NSDictionary *notificationUserInfo = [notification userInfo];
    NSNumber *resultValue = [notificationUserInfo objectForKey:MPMoviePlayerPlaybackDidFinishReasonUserInfoKey];
    MPMovieFinishReason reason = [resultValue intValue];
    NSError *mpError = [notificationUserInfo objectForKey:@"error"];
    switch (reason) {
        case MPMovieFinishReasonPlaybackEnded: NSLog(@"Ended"); break;
        case MPMovieFinishReasonPlaybackError: NSLog(@"Error: %@", mpError.localizedDescription); [self loadAlertWithTitle:@"Alert" andMessage:@"Lesson is not available at this time. Please try again."]; break;
        case MPMovieFinishReasonUserExited: NSLog(@"User exited"); break;
        default: break;
    }
    
    [[NSNotificationCenter defaultCenter] removeObserver:self
                                                    name:MPMoviePlayerPlaybackDidFinishNotification
                                                  object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:MPMoviePlayerPlaybackStateDidChangeNotification object:nil];
}

#pragma mark - Sharing
- (void)share:(id)sender {
    if ([UIActivityViewController class]) {
        NSString *title = @"KabTV.";
        NSURL *url = [NSURL URLWithString:@"http://www.kab.tv"];
        NSArray *items = @[title, url];
        
        UIActivityViewController *shareController = [[UIActivityViewController alloc] initWithActivityItems:items applicationActivities:nil];
        shareController.excludedActivityTypes = @[UIActivityTypeAddToReadingList, UIActivityTypeCopyToPasteboard];
        
        UIActivityViewControllerCompletionWithItemsHandler completion = ^(NSString *activityType, BOOL completed, NSArray *returnedItems, NSError *activityError) {
            if (completed) {
                [self loadAlertWithTitle:@"Done" andMessage:nil];
            } else if (activityError) {
                [self loadAlertWithTitle:@"Error!" andMessage:activityError.localizedDescription];
            }else {
                NSLog(@"user canceled");
            }
        };
        shareController.completionWithItemsHandler = completion;
        [self presentViewController:shareController animated:YES completion:nil];
    }
}

- (BOOL)shouldAutorotate
{
    return YES;
}

- (UIInterfaceOrientationMask)supportedInterfaceOrientations {
    return UIInterfaceOrientationMaskAll;
}

@end
