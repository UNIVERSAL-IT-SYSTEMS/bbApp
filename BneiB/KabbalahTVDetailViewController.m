//
//  KabbalahTVDetailViewController.m
//  KabNew
//
//  Created by Gabriel Morales on 12/6/15.
//  Copyright © 2015 Gabe Morales. All rights reserved.
//

#import "KabbalahTVDetailViewController.h"
#import <AFNetworking/UIImageView+AFNetworking.h>
#import <MediaPlayer/MediaPlayer.h>
#import <AVFoundation/AVFoundation.h>
#import <AVKit/AVKit.h>
#import "UIScrollView+EmptyDataSet.h"


@interface KabbalahTVDetailViewController () <UITableViewDataSource, UITableViewDelegate, UIScrollViewDelegate, DZNEmptyDataSetSource, DZNEmptyDataSetDelegate>
@property (nonatomic) UITableView *table;
@property (nonatomic) CGFloat kTableheaderHeight;
@property (nonatomic) UIView *headerView;
@property (nonatomic, strong) MPMoviePlayerController *mp;
@property (nonatomic, strong) AVPlayerViewController *avP;
@property (nonatomic) AVPlayer *player;
@property (nonatomic) AVPlayerItem *playerItem;
@end

@implementation KabbalahTVDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    self.kTableheaderHeight = 250.0;
    [self.navigationItem setTitle:[NSString stringWithFormat:@"Videos"]];
    [self setupTableView];
    // Do any additional setup after loading the view.
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    if (![self.table respondsToSelector:@selector(tableView:heightForRowAtIndexPath:)])
    {
        self.table.rowHeight = 200;
        self.table.estimatedRowHeight = 300.0f;
    }
    [self.table reloadData];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



#pragma mark - UITableViewDataSource
- (void)setupTableView{
    self.table = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
    [self.table setTranslatesAutoresizingMaskIntoConstraints:NO];
    [self.table registerClass:[UITableViewCell class] forCellReuseIdentifier:@"Cell"];
    self.table.delegate = self;
    self.table.dataSource = self;
    self.table.emptyDataSetDelegate = self;
    self.table.emptyDataSetSource = self;
    self.table.tableFooterView = [UIView new];
    self.table.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
    self.table.separatorColor = [UIColor grayColor];
    self.table.backgroundColor = self.view.backgroundColor;
    [self.view addSubview:self.table];
    
    NSDictionary *views = NSDictionaryOfVariableBindings(_table);
    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|[_table]|" options:kNilOptions metrics:nil views:views]];
    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|[_table]|" options:kNilOptions metrics:nil views:views]];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.detailSelected.videos.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell" forIndexPath:indexPath];
    cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"Cell"];
    
    [self configureCell:cell forRowAtIndexPath:indexPath];
    return cell;
}

- (void)configureCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {
    NSArray *vides = self.detailSelected.videos;
    NSSortDescriptor *sort = [[NSSortDescriptor alloc] initWithKey:@"title" ascending:YES];
    vides = [vides sortedArrayUsingDescriptors:@[sort]];
    NSDictionary *videoDict = vides[indexPath.row];
    cell.textLabel.text = videoDict[@"title"];
    cell.detailTextLabel.text = videoDict[@"description"];
    
    cell.textLabel.font = [UIFont boldKabInterfaceFontOfSize:18];
    cell.textLabel.textColor = [UIColor kabBlueColor];
    cell.detailTextLabel.font = [UIFont kabInterfaceFontOfSize:16];
    cell.detailTextLabel.textColor = [UIColor kabLightTextColor];
    cell.detailTextLabel.lineBreakMode = NSLineBreakByWordWrapping;
    cell.detailTextLabel.numberOfLines = 7;
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
}


- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    UIImageView *bgImage = [[UIImageView alloc] init];
    [bgImage setImageWithURL:self.detailSelected.detailBackgroundURL placeholderImage:[UIImage imageNamed:@"bg_profile_empty"]];
    return bgImage;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return self.kTableheaderHeight;
}

#pragma mark - UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    //    NSIndexPath *index = [_table indexPathForSelectedRow];
    NSDictionary *selected = self.detailSelected.videos[indexPath.row];
    NSString *url = selected[@"video_url"];
    NSLog(@"%@", url);
    [self loadVideoWithURL:[NSURL URLWithString:url]];
}

#pragma mark - DZNEmptyDataSetSource methods -

- (NSAttributedString *) titleForEmptyDataSet:(UIScrollView *)scrollView
{
    NSString *text = @"No Videos Available";
    NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:text attributes:nil];
    
    
    [attributedString addAttribute:NSFontAttributeName value:[UIFont fontWithName:@"Avenir-Heavy" size:25.0] range:[attributedString.string rangeOfString:text]];
    
    return attributedString;
}

- (NSAttributedString *) descriptionForEmptyDataSet:(UIScrollView *)scrollView
{
    NSString *text = @"Please try again later.";
    NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:text attributes:nil];
    
    
    [attributedString addAttribute:NSFontAttributeName value:[UIFont fontWithName:@"Avenir-Medium" size:22.0f] range:[attributedString.string rangeOfString:text]];
    
    return attributedString;
}

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


#pragma mark - ScrollViewDelegate
- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    //        [self updateHeaderView];
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

- (void)loadVideoWithURL:(NSURL *)url {
    [[AVAudioSession sharedInstance] setCategory:AVAudioSessionCategoryPlayback error:nil];
    self.avP= [[AVPlayerViewController alloc] init];
    self.player = [[AVPlayer alloc] initWithURL:url];
    self.avP.player = self.player;
    [self presentViewController:self.avP animated:YES completion:nil];
    [self.player play];
}


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
        case MPMovieFinishReasonPlaybackError: NSLog(@"Error:"); [self loadAlertWithTitle:@"Alert" andMessage:mpError.localizedDescription]; break;
        case MPMovieFinishReasonUserExited: NSLog(@"User exited"); break;
        default: break;
    }
    
    [[NSNotificationCenter defaultCenter] removeObserver:self
                                                    name:MPMoviePlayerPlaybackDidFinishNotification
                                                  object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:MPMoviePlayerPlaybackStateDidChangeNotification object:nil];
}

- (void)loadAlertWithTitle:(NSString *)title andMessage:(NSString *)message {
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:title message:message preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *cancel = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleCancel handler:nil];
    [alert addAction:cancel];
    [self presentViewController:alert animated:YES completion:nil];
}


@end
