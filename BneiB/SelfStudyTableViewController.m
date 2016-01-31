//
//  SelfStudyTableViewController.m
//  BneiB
//
//  Created by MexRockstar.
//  Copyright (c) 2012 Bnei Baruch USA. All rights reserved.
//

#import "SelfStudyTableViewController.h"
#import "Twitter/Twitter.h"
#import "Reachability.h"
#import "StudyShareViewController.h"
#import "KabCustomCell.h"

@interface SelfStudyTableViewController ()

@end


@implementation SelfStudyTableViewController
@synthesize imageString = _imageString;
@synthesize urlString = _urlString;
/*@synthesize navBar;


- (IBAction)done:(id)sender {
    [self dismissModalViewControllerAnimated:YES];
}

- (IBAction)viewSettings;{
    
    SettingsViewController *itemDetail = [self.storyboard instantiateViewControllerWithIdentifier:@"SettingsView"];
    [self.navigationController pushViewController:itemDetail animated:YES];
    
}*/

- (instancetype)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [[LocalyticsSession shared] tagEvent:@"Self Study Main"];
    [super viewDidLoad];
    
    UIColor* bgColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"bg_tweet_place_holder~iphone.png"]];
    [self.view setBackgroundColor:bgColor];
    
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


    
    SelfStudy = [[NSMutableArray alloc] initWithObjects:
                 @"Lesson 1", 
                 @"Lesson 2", 
                 @"Lesson 3", 
                 @"Lesson 4", 
                 @"Lesson 5", 
                 @"Lesson 6", 
                 @"Lesson 7", 
                 @"Lesson 8", 
                 @"Lesson 9", 
                 @"Lesson 10", 
                 @"Lesson 11", 
                 @"Lesson 12", 
                 @"Lesson 13", 
                 @"Lesson 14", 
                 @"Lesson 15", 
                 @"Lesson 16",
                 
                 nil];
    
    SelfStudyDetail = [[NSMutableArray alloc] initWithObjects:
                       @"Kabbalah: A basic Overview",
                       @"Perception of Reality", 
                       @"Two Paths", 
                       @"The Force of Development and the Meaning of Suffering", 
                       @"Introduction to the Four Phases of Direct Light", 
                       @"The Screen", 
                       @"Equivalence of Form", 
                       @"There’s None Else Beside Him, Part 1", 
                       @"There’s None Else Beside Him, Part 2", 
                       @"Free Will, Part 1", 
                       @"Free Will, Part 2 'The Four Factors'",
                       @"The Difference Between Kabbalah and Religion", 
                       @"Defining the Goal", 
                       @"Revelation and Concealment", 
                       @"Inanimate Vegetative Animate Human",  
                       @"Correcting The World",
                       
                       nil];
    
    //[TestFlight passCheckpoint:@"Self Study Load"];

    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
 
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

- (void)viewDidUnload
{
    //[self setNavBar:nil];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    return [SelfStudy count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"SelfStudyCell";
    
    /*tableView.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"list-item.png"]];*/
    
    KabCustomCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[KabCustomCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier];
		cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        
    }
    
    // Configure the cell...
    cell.KabTitle.text = SelfStudy[indexPath.row];
    cell.KabSubTitle.text = SelfStudyDetail[indexPath.row];
    return cell;
}


#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *str= SelfStudy[indexPath.row];
    if ([str isEqual:@"Lesson 1"])
	{
		
        NSString *urlText = [NSString stringWithFormat:@"http://download-tv.kabbalah.info/eng/shows/kr/eng_tk_lesson_kabbalah-revealed-ep01_2010-06-09_tweb-distro-360.mp4"];
        NSURL *url = [NSURL URLWithString:urlText];
        
        MPMoviePlayerViewController *media = [[MPMoviePlayerViewController alloc] initWithContentURL:url];
        [self presentMoviePlayerViewControllerAnimated:media];
        
        
        [media.moviePlayer play];
        
        //[TestFlight passCheckpoint:@"Played Lesson 1 Self study"];
		
	}
	
	else if ([str isEqual:@"Lesson 2"])
	{
		
		/*NSBundle *bundle = [NSBundle mainBundle];
        NSString *moviePath = [bundle pathForResource:@"Lesson 2" ofType:@"mp4"];
        NSURL  *movieURL = [[NSURL fileURLWithPath:moviePath] retain];
        MPMoviePlayerController *theMovie = [[MPMoviePlayerController alloc] initWithContentURL:movieURL];
        theMovie.scalingMode = MPMovieScalingModeAspectFill;
        [theMovie play];
        MPMoviePlayerViewController *moviesPlayer = [[MPMoviePlayerViewController alloc] initWithContentURL:movieURL];
        [self presentMoviePlayerViewControllerAnimated:moviesPlayer];*/
        
        NSString *urlText = [NSString stringWithFormat:@"http://download-tv.kabbalah.info/eng/shows/kr/eng_tk_lesson_kabbalah-revealed-ep02_2010-06-09_tweb-distro-360.mp4"];
        NSURL *url = [NSURL URLWithString:urlText];
        
        MPMoviePlayerViewController *media = [[MPMoviePlayerViewController alloc] initWithContentURL:url];
        [self presentMoviePlayerViewControllerAnimated:media];
        
        
        [media.moviePlayer play];
        //[TestFlight passCheckpoint:@"Played Lesson 2 Self study"];

	}
    
    else if ([str isEqual:@"Lesson 3"])
	{
		
        NSString *urlText = [NSString stringWithFormat:@"http://download-tv.kabbalah.info/eng/shows/kr/eng_tk_lesson_kabbalah-revealed-ep03_2010-06-09_tweb-distro-360.mp4"];
        NSURL *url = [NSURL URLWithString:urlText];
        
        MPMoviePlayerViewController *media = [[MPMoviePlayerViewController alloc] initWithContentURL:url];
        [self presentMoviePlayerViewControllerAnimated:media];
        
        
        [media.moviePlayer play];
        //[TestFlight passCheckpoint:@"Played Lesson 3 Self study"];

		
	}
    
    else if ([str isEqual:@"Lesson 4"])
	{
		
        NSString *urlText = [NSString stringWithFormat:@"http://download-tv.kabbalah.info/eng/shows/kr/eng_tk_lesson_kabbalah-revealed-ep04_2010-06-09_tweb-distro-360.mp4"];
        NSURL *url = [NSURL URLWithString:urlText];
        
        MPMoviePlayerViewController *media = [[MPMoviePlayerViewController alloc] initWithContentURL:url];
        [self presentMoviePlayerViewControllerAnimated:media];
        
        
        [media.moviePlayer play];
        //[TestFlight passCheckpoint:@"Played Lesson 4 Self study"];

		
	}
    
    else if ([str isEqual:@"Lesson 5"])
	{
		
        NSString *urlText = [NSString stringWithFormat:@"http://download-tv.kabbalah.info/eng/shows/kr/eng_tk_lesson_kabbalah-revealed-ep05_2010-06-09_tweb-distro-360.mp4"];
        NSURL *url = [NSURL URLWithString:urlText];
        
        MPMoviePlayerViewController *media = [[MPMoviePlayerViewController alloc] initWithContentURL:url];
        [self presentMoviePlayerViewControllerAnimated:media];
        
        
        [media.moviePlayer play];
        //[TestFlight passCheckpoint:@"Played Lesson 5 Self study"];

		
	}
    
    else if ([str isEqual:@"Lesson 6"])
	{
		
        NSString *urlText = [NSString stringWithFormat:@"http://download-tv.kabbalah.info/eng/shows/kr/eng_tk_lesson_kabbalah-revealed-ep06_2010-06-09_tweb-distro-360.mp4"];
        NSURL *url = [NSURL URLWithString:urlText];
        
        MPMoviePlayerViewController *media = [[MPMoviePlayerViewController alloc] initWithContentURL:url];
        [self presentMoviePlayerViewControllerAnimated:media];
        
        
        [media.moviePlayer play];
        //[TestFlight passCheckpoint:@"Played Lesson 6 Self study"];

		
	}
    
    else if ([str isEqual:@"Lesson 7"])
	{
		
        NSString *urlText = [NSString stringWithFormat:@"http://download-tv.kabbalah.info/eng/shows/kr/eng_tk_lesson_kabbalah-revealed-ep07_2010-06-09_tweb-distro-360.mp4"];
        NSURL *url = [NSURL URLWithString:urlText];
        
        MPMoviePlayerViewController *media = [[MPMoviePlayerViewController alloc] initWithContentURL:url];
        [self presentMoviePlayerViewControllerAnimated:media];
        
        
        [media.moviePlayer play];
        //[TestFlight passCheckpoint:@"Played Lesson 7 Self study"];

		
	}
    
    else if ([str isEqual:@"Lesson 8"])
	{
		
        NSString *urlText = [NSString stringWithFormat:@"http://download-tv.kabbalah.info/eng/shows/kr/eng_tk_lesson_kabbalah-revealed-ep08_2010-06-09_tweb-distro-360.mp4"];
        NSURL *url = [NSURL URLWithString:urlText];
        
        MPMoviePlayerViewController *media = [[MPMoviePlayerViewController alloc] initWithContentURL:url];
        [self presentMoviePlayerViewControllerAnimated:media];
        
        
        [media.moviePlayer play];
        //[TestFlight passCheckpoint:@"Played Lesson 8 Self study"];

		
	}
    
    else if ([str isEqual:@"Lesson 9"])
	{
		
        NSString *urlText = [NSString stringWithFormat:@"http://download-tv.kabbalah.info/eng/shows/kr/eng_tk_lesson_kabbalah-revealed-ep09_2010-06-09_tweb-distro-360.mp4"];
        NSURL *url = [NSURL URLWithString:urlText];
        
        MPMoviePlayerViewController *media = [[MPMoviePlayerViewController alloc] initWithContentURL:url];
        [self presentMoviePlayerViewControllerAnimated:media];
        
        
        [media.moviePlayer play];
        //[TestFlight passCheckpoint:@"Played Lesson 9 Self study"];

		
	}
    
    else if ([str isEqual:@"Lesson 10"])
	{
		
        NSString *urlText = [NSString stringWithFormat:@"http://download-tv.kabbalah.info/eng/shows/kr/eng_tk_lesson_kabbalah-revealed-ep10_2010-06-09_tweb-distro-360.mp4"];
        NSURL *url = [NSURL URLWithString:urlText];
        
        MPMoviePlayerViewController *media = [[MPMoviePlayerViewController alloc] initWithContentURL:url];
        [self presentMoviePlayerViewControllerAnimated:media];
        
        
        [media.moviePlayer play];
        //[TestFlight passCheckpoint:@"Played Lesson 10 Self study"];

		
	}
    
    else if ([str isEqual:@"Lesson 11"])
	{
		
        NSString *urlText = [NSString stringWithFormat:@"http://download-tv.kabbalah.info/eng/shows/kr/eng_tk_lesson_kabbalah-revealed-ep11_2010-06-09_tweb-distro-360.mp4"];
        NSURL *url = [NSURL URLWithString:urlText];
        
        MPMoviePlayerViewController *media = [[MPMoviePlayerViewController alloc] initWithContentURL:url];
        [self presentMoviePlayerViewControllerAnimated:media];
        
        
        [media.moviePlayer play];
        //[TestFlight passCheckpoint:@"Played Lesson 11 Self study"];

	}
    
    else if ([str isEqual:@"Lesson 12"])
	{
		
        NSString *urlText = [NSString stringWithFormat:@"http://download-tv.kabbalah.info/eng/shows/kr/eng_tk_lesson_kabbalah-revealed-ep12_2010-06-09_tweb-distro-360.mp4"];
        NSURL *url = [NSURL URLWithString:urlText];
        
        MPMoviePlayerViewController *media = [[MPMoviePlayerViewController alloc] initWithContentURL:url];
        [self presentMoviePlayerViewControllerAnimated:media];
        
        
        [media.moviePlayer play];
        //[TestFlight passCheckpoint:@"Played Lesson 12 Self study"];

		
	}
    
    else if ([str isEqual:@"Lesson 13"])
	{
		
        NSString *urlText = [NSString stringWithFormat:@"http://download-tv.kabbalah.info/eng/shows/kr/eng_tk_lesson_kabbalah-revealed-ep13_2010-06-09_tweb-distro-360.mp4"];
        NSURL *url = [NSURL URLWithString:urlText];
        
        MPMoviePlayerViewController *media = [[MPMoviePlayerViewController alloc] initWithContentURL:url];
        [self presentMoviePlayerViewControllerAnimated:media];
        
        
        [media.moviePlayer play];
        //[TestFlight passCheckpoint:@"Played Lesson 13 Self study"];

		
	}
    
    else if ([str isEqual:@"Lesson 14"])
	{
		
        NSString *urlText = [NSString stringWithFormat:@"http://download-tv.kabbalah.info/eng/shows/kr/eng_tk_lesson_kabbalah-revealed-ep14_2010-06-09_tweb-distro-360.mp4"];
        NSURL *url = [NSURL URLWithString:urlText];
        
        MPMoviePlayerViewController *media = [[MPMoviePlayerViewController alloc] initWithContentURL:url];
        [self presentMoviePlayerViewControllerAnimated:media];
        
        
        [media.moviePlayer play];
        //[TestFlight passCheckpoint:@"Played Lesson 14 Self study"];

		
	}
    
    else if ([str isEqual:@"Lesson 15"])
	{
		
        NSString *urlText = [NSString stringWithFormat:@"http://download-tv.kabbalah.info/eng/shows/kr/eng_tk_lesson_kabbalah-revealed-ep15_2010-06-09_tweb-distro-360.mp4"];
        NSURL *url = [NSURL URLWithString:urlText];
        
        MPMoviePlayerViewController *media = [[MPMoviePlayerViewController alloc] initWithContentURL:url];
        [self presentMoviePlayerViewControllerAnimated:media];
        
        
        [media.moviePlayer play];
        //[TestFlight passCheckpoint:@"Played Lesson 15 Self study"];

		
	}
    
    else if ([str isEqual:@"Lesson 16"])
	{
		
        NSString *urlText = [NSString stringWithFormat:@"http://download-tv.kabbalah.info/eng/shows/kr/eng_tk_lesson_kabbalah-revealed-ep16_2010-06-09_tweb-distro-360.mp4"];
        NSURL *url = [NSURL URLWithString:urlText];
        
        MPMoviePlayerViewController *media = [[MPMoviePlayerViewController alloc] initWithContentURL:url];
        [self presentMoviePlayerViewControllerAnimated:media];
        
        
        [media.moviePlayer play];
        //[TestFlight passCheckpoint:@"Played Lesson 16 Self study"];

		
	}
	
	// Deselect
	//[self.tableView deselectRowAtIndexPath:indexPath animated:YES];
    

}




/*- (IBAction)tweetTapped:(id)sender {
    if ([TWTweetComposeViewController canSendTweet])
    {
        TWTweetComposeViewController *tweetSheet = 
        [[TWTweetComposeViewController alloc] init];
        [tweetSheet setInitialText:
         @"Archive Section: Self-Study"];
        
        self.imageString = @"studyBack.png";
        self.urlString = @"http://www.kabbalah.info/engkab/education-center/your-first-course-in-kabbalah";
        
        if (self.imageString)
        {
            [tweetSheet addImage:[UIImage imageNamed:self.imageString]];
        }
        
        if (self.urlString)
        {
            [tweetSheet addURL:[NSURL URLWithString:self.urlString]];
        }
        
	    [self presentModalViewController:tweetSheet animated:YES];
    }
    else
    {
        UIAlertView *alertView = [[UIAlertView alloc] 
                                  initWithTitle:@"Sorry"                                                             
                                  message:@"You can't send a tweet right now, make sure your device has an internet connection and you have at least one Twitter account setup"                                                          
                                  delegate:self                                              
                                  cancelButtonTitle:@"OK"                                                   
                                  otherButtonTitles:nil];
        [alertView show];
    }
}*/

- (IBAction)openActionSheet{
    
    if ([UIActivityViewController class]) {
        
        NSString *textToShare = [NSString stringWithFormat:@"16 Lessons that will change your life! via @KabbalahApp"];
        NSURL *url = [NSURL URLWithString:@"http://www.kabbalah.info/engkab/education-center/your-first-course-in-kabbalah"];
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
    else
    {
        
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
        [actionSheet showInView:self.tabBarController.tabBar];
    }
}

- (void)actionSheet: (UIActionSheet *) actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex{
    if (buttonIndex == 0) {
        
        NSString *message = [NSString stringWithFormat:@"16 Lessons that will change your life! via @KabbalahApp"];
        NSString *urlString = [NSString stringWithFormat:@"http://goo.gl/fWc6I"];
        
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
        
        [tweetSheet setInitialText:@"16 Lessons that will change your life! via @KabbalahApp"];
        //[tweetSheet addImage:[UIImage imageNamed:@"studyBack.png"]];
        [tweetSheet addURL:[NSURL URLWithString:@"http://goo.gl/fWc6I"]];
        
        
        tweetSheet.completionHandler = ^(TWTweetComposeViewControllerResult result){
            //[self dismissModalViewControllerAnimated:YES];
            [self dismissViewControllerAnimated:YES completion:nil];
        };
        
	    //[self presentModalViewController:tweetSheet animated:YES];
        [self presentViewController:tweetSheet animated:YES completion:nil];
        //[TestFlight passCheckpoint:@"Twitter Self Study"];
         */

    }
    
    if (buttonIndex == 1) {
        MFMailComposeViewController * composer = [[MFMailComposeViewController alloc]init];
        [composer setMailComposeDelegate:self];
        
        if ([MFMailComposeViewController canSendMail]) {
            [composer setToRecipients:@[@""]];
            [composer setSubject:@"Found this and thought of sharing it with you."];
            NSMutableString *body = [NSMutableString string];
            [composer setMessageBody:body isHTML:YES];
            [body appendString:@"<h2>Kabbalah Revealed</h2>"];
            [body appendString:@"<p>Check out these 16 lessons that will change your life.</p>"];
            [body appendString:@"<p>Here's the link for the lessons!</p>"];
            [body appendString:@"<a href =\"http://goo.gl/fWc6I\"> Link</a>\n"];
            [body appendString:@"<p>"];
            [body appendString:@"Follow us on <a href =\"http://www.twitter.com/KabbalahApp\">Twitter</a></br>"];
            [body appendString:@"Like us on <a href =\"https://www.facebook.com/KabbalahApp\">Facebook</a></br>"];
            [body appendString:@"Share us on <a href =\"https://plus.google.com/u/0/b/110517944996918866621/110517944996918866621\">Google +</a>"];
            [body appendString:@"</p>"];
            
            [body appendString:@"<p>Via <a href =\"http://itunes.apple.com/us/app/kabbalah-app/id550938690\">Kabbalah App</a></p>\n"];
            [composer setModalTransitionStyle:UIModalTransitionStyleCoverVertical];
            [self presentViewController:composer animated:YES completion:nil];
        }
        //[TestFlight passCheckpoint:@"Email Self Study"];

    }
    
    if (buttonIndex == 2) {
        
        NSString *message = [NSString stringWithFormat:@"Kabbalah Revealed. Check out these 16 lessons that will change your life. | Via Kabbalah App."];
        NSURL *url = [NSURL URLWithString:@"http://goo.gl/fWc6I"];
        
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
        
        StudyShareViewController *viewController = [self.storyboard instantiateViewControllerWithIdentifier:@"StudyShareView"];
        [self presentViewController:viewController animated:YES completion:nil];
        
        //[TestFlight passCheckpoint:@"Facebook Bookstore"];
        }
        */
    }
    
    if (buttonIndex == 3) {
        NSURL * currentURL = [NSURL URLWithString:@"http://goo.gl/fWc6I"];
        [[UIApplication sharedApplication] openURL:currentURL];
        
        //[TestFlight passCheckpoint:@"Open in Safari. Self study."];

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
