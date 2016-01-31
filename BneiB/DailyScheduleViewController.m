//
//  DailyScheduleViewController.m
//  Kabbalah
//
//  Created by MexRockstar.
//  Copyright (c) 2012 Bnei Baruch USA. All rights reserved.
//
//

#import "DailyScheduleViewController.h"
#import "KabTVShareViewController.h"

@interface DailyScheduleViewController ()

@end

@implementation DailyScheduleViewController{
    
    UIBarButtonItem *_backBarButton;
    UIBarButtonItem *_actionButton;
    UIBarButtonItem *_reloadButton;
}
@synthesize activityIndicator;
@synthesize webView = _webView;

- (instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [[LocalyticsSession shared] tagEvent:@"Kab TV Schedule"];

    
    [super viewDidLoad];
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"icn_nav_bar_dark_compose_dm"] landscapeImagePhone:[UIImage imageNamed:@"icn_nav_bar_dark_compose_dm"] style:UIBarButtonItemStyleBordered target:self action:@selector(openActionSheet:)];
    
    //UIColor* bgColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"bg_tweet_place_holder~iphone.png"]];
    //[self.view setBackgroundColor:bgColor];
    
    UIColor *bgColor = [UIColor colorWithRed:240/255.0 green:240/255.0 blue:240/255.0 alpha:1.0];
    [self.view setBackgroundColor:bgColor];
    
    //_backBarButton = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"back_arrow"] landscapeImagePhone:[UIImage imageNamed:@"back_arrow"] style:UIBarButtonItemStylePlain target:_webView action:@selector(goBack)];
    
    _backBarButton = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"back_arrow"] landscapeImagePhone:[UIImage imageNamed:@"back_arrow"] style:UIBarButtonItemStylePlain target:_webView action:@selector(goBack)];
    _backBarButton.tintColor = [UIColor colorWithRed:51/255.0 green:51/255.0 blue:51/255.0 alpha:1.0];
    
    //_actionButton = [[UIBarButtonItem alloc]initWithImage:[UIImage imageNamed:@"icn_nav_bar_dark_actions"]landscapeImagePhone:[UIImage imageNamed:@"icn_nav_bar_dark_actions"] style:UIBarButtonItemStylePlain target:self action:@selector(openActionSheet:)];
    
    _actionButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAction target:self action:@selector(openActionSheet:)];
    _actionButton.tintColor = [UIColor colorWithRed:27/255.0 green:135/255.0 blue:195/255.0 alpha:1.0];
    
    _reloadButton = [[UIBarButtonItem alloc]initWithImage:[UIImage imageNamed:@"stop-button"] landscapeImagePhone:[UIImage imageNamed:@"stop-button"] style:UIBarButtonItemStylePlain target:_webView action:@selector(reload)];
    _reloadButton.tintColor = [UIColor colorWithRed:143/255.0 green:14/255.0 blue:23/255.0 alpha:1.0];
    
    UIBarButtonItem *flexibleSpace = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil];
    
    self.toolbarItems = @[_backBarButton,
                         flexibleSpace,
                         _reloadButton,
                         flexibleSpace,
                         _actionButton];
    
    for (UIBarButtonItem *button in self.toolbarItems){
        button.imageInsets = UIEdgeInsetsMake(0.0f, 0.0f, 0.0f, 0.0f);
        
    }
    
    
    UIActivityIndicatorView *indicator = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhite];
    indicator.hidesWhenStopped = YES;
    [indicator stopAnimating];
    self.activityIndicator = indicator;
    
    UIBarButtonItem *rightButton = [[UIBarButtonItem alloc] initWithCustomView:indicator];
    self.navigationItem.rightBarButtonItem = rightButton;
    
    timer = [NSTimer scheduledTimerWithTimeInterval: (0.5)
                                             target:self
                                           selector:@selector(loading)
                                           userInfo:Nil
                                            repeats:YES];
    
    internetReach = [Reachability reachabilityForInternetConnection];
    [internetReach startNotifier];
    NetworkStatus netStatus = [internetReach currentReachabilityStatus];
    
    switch (netStatus)
    {
        case ReachableViaWWAN:
        {
            break;
        }
        case ReachableViaWiFi:
        {
            break;
        }
        case NotReachable:
        {
            BlockAlertView *alert = [BlockAlertView alertWithTitle:@"Alert" message:@"No 3G/WiFi detected. Some functionality will be limited until a connection is made."];
            
            [alert setDestructiveButtonWithTitle:@"OK" block:nil];
            [alert show];
            break;
        }
            
    }
    
    /*NSString *fullURL = NSLocalizedString(@"SCHEDULE", nil);
    NSURL *url = [NSURL URLWithString:fullURL];
    NSURLRequest *requestObj = [NSURLRequest requestWithURL:url];
    [webView loadRequest:requestObj];*/
    
    /*[_webView loadRequest:[NSURLRequest requestWithURL:[NSURL fileURLWithPath:[[NSBundle mainBundle] pathForResource:NSLocalizedString(@"SCHEDULE_NEW", nil) ofType:@"html" inDirectory:NO]]]];*/
    
    NSString *fullURL = NSLocalizedString(@"SCHEDULE_NEW", nil);
    NSURL *url = [NSURL URLWithString:fullURL];
    NSURLRequest *requestObj = [NSURLRequest requestWithURL:url];
    [_webView loadRequest:requestObj];

    //http://kab.tv/tv/vod/ads/get_all_by_language?lang=English
	// Do any additional setup after loading the view.
}

- (void)viewWillAppear:(BOOL)animated {
	[super viewWillAppear:animated];
	[self.navigationController setToolbarHidden:NO animated:animated];
}


- (void)viewWillDisappear:(BOOL)animated {
	[super viewWillDisappear:animated];
	[self.navigationController setToolbarHidden:YES animated:animated];
}

#pragma mark - Private
-(void)loading {
    _backBarButton.enabled = [_webView canGoBack];
    _backBarButton.tintColor = [UIColor colorWithRed:27/255.0 green:135/255.0 blue:195/255.0 alpha:1.0];
    
	UIBarButtonItem *reloadButton = nil;
    if (!_webView.loading) {
        
        [activityIndicator stopAnimating];
        reloadButton = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"reload-button"] landscapeImagePhone:[UIImage imageNamed:@"reload-button"] style:UIBarButtonItemStylePlain target:_webView action:@selector(reload)];
        reloadButton.tintColor = [UIColor colorWithRed:27/255.0 green:135/255.0 blue:195/255.0 alpha:1.0];
        _actionButton.enabled = YES;
    }
    else {
        [activityIndicator startAnimating];
        reloadButton = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"stop-button"] landscapeImagePhone:[UIImage imageNamed:@"stop-button"] style:UIBarButtonItemStylePlain target:_webView action:@selector(stopLoading)];
        reloadButton.tintColor = [UIColor colorWithRed:143/255.0 green:14/255.0 blue:23/255.0 alpha:1.0];
        _actionButton.enabled = NO;
    }
    reloadButton.imageInsets = UIEdgeInsetsMake(0.0f, 0.0f, 0.0f, 0.0f);
	
	NSMutableArray *items = [self.toolbarItems mutableCopy];
	items[2] = reloadButton;
	self.toolbarItems = items;
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation {
	if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) {
		return YES;
	}
	
	return toInterfaceOrientation != UIInterfaceOrientationPortraitUpsideDown;
}



- (void) reachabilityChanged: (NSNotification* )note
{
	Reachability* curReach = [note object];
	NSParameterAssert([curReach isKindOfClass: [Reachability class]]);
	
    NetworkStatus netStatus = [curReach currentReachabilityStatus];
    switch (netStatus)
    {
        case ReachableViaWWAN:
        {
            break;
        }
        case ReachableViaWiFi:
        {
            break;
        }
        case NotReachable:
        {
            BlockAlertView *alert = [BlockAlertView alertWithTitle:@"Alert" message:@"No 3G/WiFi detected. Some functionality will be limited until a connection is made."];
            
            [alert setDestructiveButtonWithTitle:@"OK" block:nil];
            [alert show];
            break;
        }
    }
}

- (void)openActionSheet:(id)sender{
    
    if ([UIActivityViewController class]) {
        
        NSString *textToShare = @"Check Kab TV Daily Schedule! Via @KabbalahApp";
        NSURL *url = [NSURL URLWithString:@"http://www.kab.tv/eng"];
        NSArray *itemsToShare = @[textToShare, url];
        UIActivityViewController *activityVC = [[UIActivityViewController alloc] initWithActivityItems:itemsToShare applicationActivities:nil];
        activityVC.excludedActivityTypes = @[UIActivityTypePostToWeibo, UIActivityTypePrint, UIActivityTypeSaveToCameraRoll];
        
        UIActivityViewControllerCompletionHandler completionBlock = ^(NSString *activityType, BOOL completed) {
            if (completed) {
                MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
                hud.customView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"check.png"]];
                hud.mode = MBProgressHUDModeCustomView;
                hud.labelText = @"Done!";
                
                [hud show:YES];
                [hud hide:YES afterDelay:2];
            } else{
                
                MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
                hud.customView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"error-bubble.png"]];
                hud.mode = MBProgressHUDModeCustomView;
                hud.labelText = @"Oops! Something went wrong!";
                
                [hud show:YES];
                [hud hide:YES afterDelay:2];
            }
            
        };
        activityVC.completionHandler = completionBlock;
        
        [self presentViewController:activityVC animated:YES completion:nil];
        
    }
    else {
    UIActionSheet *actionSheet = [[UIActionSheet alloc]
                                  initWithTitle:@""
                                  delegate:self
                                  cancelButtonTitle:@"Cancel"
                                  destructiveButtonTitle:nil
                                  otherButtonTitles:
                                  NSLocalizedString(@"TWITTER", nil),
                                  NSLocalizedString(@"EMAIL", nil),
                                  NSLocalizedString(@"FACEBOOK",nil),
                                  NSLocalizedString(@"SAFARI",nil),
                                  
                                  nil];
    
    [actionSheet showFromTabBar:self.tabBarController.tabBar];
    }
}

- (void)actionSheet: (UIActionSheet *) actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex{
    if (buttonIndex == 0) {
        NSString *message = [NSString stringWithFormat:@"Kab.TV Schedule via @KabbalahApp"];
        NSString *urlString = [NSString stringWithFormat:@"http://goo.gl/ToS3J"];
        
        if ([SLComposeViewController isAvailableForServiceType:SLServiceTypeTwitter])
        {
            SLComposeViewController *tweetSheet = [SLComposeViewController
                                                   composeViewControllerForServiceType:SLServiceTypeTwitter];
            [tweetSheet setInitialText:message];
            
            [tweetSheet addURL:[NSURL URLWithString:urlString]];
            [self presentViewController:tweetSheet animated:YES completion:nil];
        }
        /*
        TWTweetComposeViewController *tweetSheet =
        [[TWTweetComposeViewController alloc] init];
        
        [tweetSheet setInitialText:@"Kab.TV Schedule via @KabbalahApp"];
        [tweetSheet addURL:[NSURL URLWithString:@"http://goo.gl/ToS3J"]];
        
        
        tweetSheet.completionHandler = ^(TWTweetComposeViewControllerResult result){
            [self dismissModalViewControllerAnimated:YES];
        };
        
	    [self presentModalViewController:tweetSheet animated:YES];
        
        //[TestFlight passCheckpoint:@"Twitter Sent Schedule"];*/
    }
    
    if (buttonIndex == 1) {
        MFMailComposeViewController * composer = [[MFMailComposeViewController alloc]init];
        [composer setMailComposeDelegate:self];
        
        if ([MFMailComposeViewController canSendMail]) {
            [composer setToRecipients:@[@""]];
            [composer setSubject:@"Today's lesson schedule."];
            NSMutableString *body = [NSMutableString string];
            [composer setMessageBody:body isHTML:YES];
            [body appendString:@"<h2>Kabbalah TV</h2>"];
            [body appendString:@"<h3>Bnei Baruch Kabbalah Education & Research Institute</h3>"];
            [body appendString:@"<p>Today's Lesson Schedule.</p>"];
            [body appendString:@"<a href =\"http://goo.gl/ToS3J\">Link</a>"];
            [body appendString:@"<p>"];
            [body appendString:@"Follow us on <a href =\"http://www.twitter.com/KabbalahApp\">Twitter</a></br>"];
            [body appendString:@"Like us on <a href =\"https://www.facebook.com/KabbalahApp\">Facebook</a></br>"];
            [body appendString:@"Share us on <a href =\"https://plus.google.com/u/0/b/110517944996918866621/110517944996918866621\">Google +</a>"];
            [body appendString:@"</p>"];
            [body appendString:@"<p>Via <a href =\"http://itunes.apple.com/us/app/kabbalah-app/id550938690\">Kabbalah App</a></p>\n"];
            [composer setModalTransitionStyle:UIModalTransitionStyleCoverVertical];
            //[self presentModalViewController:composer animated:YES];
            [self presentViewController:composer animated:YES completion:nil];
        }
        //[TestFlight passCheckpoint:@"Email Schedule"];
        
    }
    
    if (buttonIndex == 2) {
        
        /*[FBSession activeSession];
        NSString *message = [NSString stringWithFormat:@"Kabbalah TV - Check out today's lesson schedule! \n'%@' \nVia Kabbalah App",[NSURL URLWithString:@"http://goo.gl/ToS3J"]];
        
        [FBRequestConnection startForPostStatusUpdate:message
                                    completionHandler:^(FBRequestConnection *connection, id result, NSError *error) {
                                        
                                        [self showAlert:message result:result error:error];
                                        
                                    }];*/
        
        NSString *message = [NSString stringWithFormat:@"Kabbalah TV, Today's schedule. | Via Kabbalah App."];
        NSURL * url = [NSURL URLWithString:@"http://goo.gl/ToS3J"];
        if([SLComposeViewController isAvailableForServiceType:SLServiceTypeFacebook]) {
            
            SLComposeViewController *controller = [SLComposeViewController composeViewControllerForServiceType:SLServiceTypeFacebook];
            
            [controller setInitialText:message];
            [controller addURL:url];
            
            [self presentViewController:controller animated:YES completion:Nil];
            
        }
        
        /*
        BOOL displayedNativeDialog =
        [FBNativeDialogs
         presentShareDialogModallyFrom:self
         initialText:message
         image:nil
         url:url
         handler:^(FBNativeDialogResult result, NSError *error) {
             
             // Only show the error if it is not due to the dialog
             // not being supported, i.e. code = 7, otherwise ignore
             // because our fallback will show the share view controller.
             if (error && [error code] == 7) {
                 return;
             }
             
             NSString *alertText = @"";
             if (error) {
                 alertText = [NSString stringWithFormat:
                              @"error: domain = %@, code = %d",
                              error.domain, error.code];
             } else if (result == FBNativeDialogResultSucceeded) {
                 alertText = @"Posted successfully.";
             }
             if (![alertText isEqualToString:@""]) {
                 // Show the result in an alert
                 BlockAlertView *alert = [BlockAlertView alertWithTitle:@"Result" message:alertText];
                 
                 [alert setDestructiveButtonWithTitle:@"OK" block:nil];
                 [alert show];
             }
         }];
        
        // Fallback, show the view controller that will post using me/feed
        if (!displayedNativeDialog) {
        
        KabTVShareViewController *viewController = [self.storyboard instantiateViewControllerWithIdentifier:@"KabTVShareView"];
        [self presentViewController:viewController animated:YES completion:nil];
        
        //[TestFlight passCheckpoint:@"Facebook Schedule"];
        }*/
        
    }
    
    if (buttonIndex == 3) {
        NSURL *currenturl = [NSURL URLWithString:@"http://goo.gl/ToS3J"];
        [[UIApplication sharedApplication] openURL:currenturl];
        
        //[TestFlight passCheckpoint:@"Open in Safari. New Home"];
    }
    
}

- (void)mailComposeController:(MFMailComposeViewController *)controller didFinishWithResult:(MFMailComposeResult)result error:(NSError *)error{
    
    //[controller dismissModalViewControllerAnimated:YES];
    [controller dismissViewControllerAnimated:YES completion:nil];
    
    if (result == MFMailComposeResultSent) {
        //HUD
        MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        hud.customView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"check.png"]];
        hud.mode = MBProgressHUDModeCustomView;
        hud.labelText = @"Sent!";
        
        [hud show:YES];
        [hud hide:YES afterDelay:2];
        
        
	}
    
    else if (result == MFMailComposeResultFailed) {
        BlockAlertView *alert = [BlockAlertView alertWithTitle:@"Alert" message:@"Unable to send email"];
        
        [alert setDestructiveButtonWithTitle:@"OK" block:nil];
        [alert show];
    }
    
}

- (void)showAlert:(NSString *)message
           result:(id)result
            error:(NSError *)error {
    
    NSString *alertMsg;
    NSString *alertTitle;
    if (error) {
        alertMsg = [NSString stringWithFormat:@"There seems to be a problem. Please check the settings to make sure you are logged in."];
        alertTitle = @"Error";
    } else {
        alertMsg = [NSString stringWithFormat:@"Successfully posted '%@'.",
                    message];
        alertTitle = @"Success";
    }
    
    BlockAlertView *alert = [BlockAlertView alertWithTitle:alertTitle message:alertMsg];
    
    [alert setDestructiveButtonWithTitle:@"OK" block:nil];
    [alert show];
}


@end
