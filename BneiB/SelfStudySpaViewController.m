//
//  SelfStudySpaViewController.m
//  Kabbalah
//
//  Created by Rockstar. on 2/3/13.
//  Copyright (c) 2013 Bnei Baruch USA. All rights reserved.
//

#import "SelfStudySpaViewController.h"
#import "Twitter/Twitter.h"
#import "Reachability.h"
#import "StudyShareViewController.h"
#import "KabCustomCell.h"

@interface SelfStudySpaViewController ()

@end

@implementation SelfStudySpaViewController

@synthesize imageString = _imageString;
@synthesize urlString = _urlString;

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
    [super viewDidLoad];
    
    UIColor* bgColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"ipad-BG-pattern.png"]];
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
                 @"Lección 1",
                 @"Lección 2",
                 @"Lección 3",
                 @"Lección 4",
                 @"Lección 5",
                 @"Lección 6",
                 @"Lección 7",
                 @"Lección 8",
                 @"Lección 9",
                 @"Lección 10",
                 @"Lección 11",
                 @"Lección 12",
                 @"Lección 13",
                 @"Lección 14",
                 @"Lección 15",
                 @"Lección 16",
                 
                 nil];
    
    SelfStudyDetail = [[NSMutableArray alloc] initWithObjects:
                       @"Cabalá: Un resumén rápido",
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
    
    [TestFlight passCheckpoint:@"Self Study Load"];

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
    if ([str isEqual:@"Lección 1"])
	{
		
        NSString *urlText = [NSString stringWithFormat:@"http://files.kab.co.il/video/spa_t_tk_2006-08_virtles_kabbalah-revealed-1.wmv"];
        NSURL *url = [NSURL URLWithString:urlText];
        
        MPMoviePlayerViewController *media = [[MPMoviePlayerViewController alloc] initWithContentURL:url];
        [self presentMoviePlayerViewControllerAnimated:media];
        
        
        [media.moviePlayer play];
        
        [TestFlight passCheckpoint:str];
		
	}
	
	else if ([str isEqual:@"Lección 2"])
	{
		
		/*NSBundle *bundle = [NSBundle mainBundle];
         NSString *moviePath = [bundle pathForResource:@"Lesson 2" ofType:@"mp4"];
         NSURL  *movieURL = [[NSURL fileURLWithPath:moviePath] retain];
         MPMoviePlayerController *theMovie = [[MPMoviePlayerController alloc] initWithContentURL:movieURL];
         theMovie.scalingMode = MPMovieScalingModeAspectFill;
         [theMovie play];
         MPMoviePlayerViewController *moviesPlayer = [[MPMoviePlayerViewController alloc] initWithContentURL:movieURL];
         [self presentMoviePlayerViewControllerAnimated:moviesPlayer];*/
        
        NSString *urlText = [NSString stringWithFormat:@"http://files.kab.co.il/video/spa_t_tk_2006-08_virtles_kabbalah-revealed-2.wmv"];
        NSURL *url = [NSURL URLWithString:urlText];
        
        MPMoviePlayerViewController *media = [[MPMoviePlayerViewController alloc] initWithContentURL:url];
        [self presentMoviePlayerViewControllerAnimated:media];
        
        
        [media.moviePlayer play];
        [TestFlight passCheckpoint:str];
        
	}
    
    else if ([str isEqual:@"Lección 3"])
	{
		
        NSString *urlText = [NSString stringWithFormat:@"http://files.kab.co.il/video/spa_t_tk_2006-08_virtles_kabbalah-revealed-3.wmv"];
        NSURL *url = [NSURL URLWithString:urlText];
        
        MPMoviePlayerViewController *media = [[MPMoviePlayerViewController alloc] initWithContentURL:url];
        [self presentMoviePlayerViewControllerAnimated:media];
        
        
        [media.moviePlayer play];
        [TestFlight passCheckpoint:str];
        
		
	}
    
    else if ([str isEqual:@"Lección 4"])
	{
		
        NSString *urlText = [NSString stringWithFormat:@"http://download-tv.kabbalah.info/eng/shows/kr/eng_tk_lesson_kabbalah-revealed-ep04_2010-06-09_tweb-distro-360.mp4"];
        NSURL *url = [NSURL URLWithString:urlText];
        
        MPMoviePlayerViewController *media = [[MPMoviePlayerViewController alloc] initWithContentURL:url];
        [self presentMoviePlayerViewControllerAnimated:media];
        
        
        [media.moviePlayer play];
        [TestFlight passCheckpoint:str];
        
		
	}
    
    else if ([str isEqual:@"Lección 5"])
	{
		
        NSString *urlText = [NSString stringWithFormat:@"http://download-tv.kabbalah.info/eng/shows/kr/eng_tk_lesson_kabbalah-revealed-ep05_2010-06-09_tweb-distro-360.mp4"];
        NSURL *url = [NSURL URLWithString:urlText];
        
        MPMoviePlayerViewController *media = [[MPMoviePlayerViewController alloc] initWithContentURL:url];
        [self presentMoviePlayerViewControllerAnimated:media];
        
        
        [media.moviePlayer play];
        [TestFlight passCheckpoint:str];
        
		
	}
    
    else if ([str isEqual:@"Lección 6"])
	{
		
        NSString *urlText = [NSString stringWithFormat:@"http://download-tv.kabbalah.info/eng/shows/kr/eng_tk_lesson_kabbalah-revealed-ep06_2010-06-09_tweb-distro-360.mp4"];
        NSURL *url = [NSURL URLWithString:urlText];
        
        MPMoviePlayerViewController *media = [[MPMoviePlayerViewController alloc] initWithContentURL:url];
        [self presentMoviePlayerViewControllerAnimated:media];
        
        
        [media.moviePlayer play];
        [TestFlight passCheckpoint:str];
        
		
	}
    
    else if ([str isEqual:@"Lección 7"])
	{
		
        NSString *urlText = [NSString stringWithFormat:@"http://download-tv.kabbalah.info/eng/shows/kr/eng_tk_lesson_kabbalah-revealed-ep07_2010-06-09_tweb-distro-360.mp4"];
        NSURL *url = [NSURL URLWithString:urlText];
        
        MPMoviePlayerViewController *media = [[MPMoviePlayerViewController alloc] initWithContentURL:url];
        [self presentMoviePlayerViewControllerAnimated:media];
        
        
        [media.moviePlayer play];
        [TestFlight passCheckpoint:str];
        
		
	}
    
    else if ([str isEqual:@"Lección 8"])
	{
		
        NSString *urlText = [NSString stringWithFormat:@"http://download-tv.kabbalah.info/eng/shows/kr/eng_tk_lesson_kabbalah-revealed-ep08_2010-06-09_tweb-distro-360.mp4"];
        NSURL *url = [NSURL URLWithString:urlText];
        
        MPMoviePlayerViewController *media = [[MPMoviePlayerViewController alloc] initWithContentURL:url];
        [self presentMoviePlayerViewControllerAnimated:media];
        
        
        [media.moviePlayer play];
        [TestFlight passCheckpoint:str];
        
		
	}
    
    else if ([str isEqual:@"Lección 9"])
	{
		
        NSString *urlText = [NSString stringWithFormat:@"http://download-tv.kabbalah.info/eng/shows/kr/eng_tk_lesson_kabbalah-revealed-ep09_2010-06-09_tweb-distro-360.mp4"];
        NSURL *url = [NSURL URLWithString:urlText];
        
        MPMoviePlayerViewController *media = [[MPMoviePlayerViewController alloc] initWithContentURL:url];
        [self presentMoviePlayerViewControllerAnimated:media];
        
        
        [media.moviePlayer play];
        [TestFlight passCheckpoint:str];
        
		
	}
    
    else if ([str isEqual:@"Lección 10"])
	{
		
        NSString *urlText = [NSString stringWithFormat:@"http://download-tv.kabbalah.info/eng/shows/kr/eng_tk_lesson_kabbalah-revealed-ep10_2010-06-09_tweb-distro-360.mp4"];
        NSURL *url = [NSURL URLWithString:urlText];
        
        MPMoviePlayerViewController *media = [[MPMoviePlayerViewController alloc] initWithContentURL:url];
        [self presentMoviePlayerViewControllerAnimated:media];
        
        
        [media.moviePlayer play];
        [TestFlight passCheckpoint:str];
        
		
	}
    
    else if ([str isEqual:@"Lección 11"])
	{
		
        NSString *urlText = [NSString stringWithFormat:@"http://download-tv.kabbalah.info/eng/shows/kr/eng_tk_lesson_kabbalah-revealed-ep11_2010-06-09_tweb-distro-360.mp4"];
        NSURL *url = [NSURL URLWithString:urlText];
        
        MPMoviePlayerViewController *media = [[MPMoviePlayerViewController alloc] initWithContentURL:url];
        [self presentMoviePlayerViewControllerAnimated:media];
        
        
        [media.moviePlayer play];
        [TestFlight passCheckpoint:str];
        
	}
    
    else if ([str isEqual:@"Lección 12"])
	{
		
        NSString *urlText = [NSString stringWithFormat:@"http://download-tv.kabbalah.info/eng/shows/kr/eng_tk_lesson_kabbalah-revealed-ep12_2010-06-09_tweb-distro-360.mp4"];
        NSURL *url = [NSURL URLWithString:urlText];
        
        MPMoviePlayerViewController *media = [[MPMoviePlayerViewController alloc] initWithContentURL:url];
        [self presentMoviePlayerViewControllerAnimated:media];
        
        
        [media.moviePlayer play];
        [TestFlight passCheckpoint:str];
        
		
	}
    
    else if ([str isEqual:@"Lección 13"])
	{
		
        NSString *urlText = [NSString stringWithFormat:@"http://download-tv.kabbalah.info/eng/shows/kr/eng_tk_lesson_kabbalah-revealed-ep13_2010-06-09_tweb-distro-360.mp4"];
        NSURL *url = [NSURL URLWithString:urlText];
        
        MPMoviePlayerViewController *media = [[MPMoviePlayerViewController alloc] initWithContentURL:url];
        [self presentMoviePlayerViewControllerAnimated:media];
        
        
        [media.moviePlayer play];
        [TestFlight passCheckpoint:str];
        
		
	}
    
    else if ([str isEqual:@"Lección 14"])
	{
		
        NSString *urlText = [NSString stringWithFormat:@"http://download-tv.kabbalah.info/eng/shows/kr/eng_tk_lesson_kabbalah-revealed-ep14_2010-06-09_tweb-distro-360.mp4"];
        NSURL *url = [NSURL URLWithString:urlText];
        
        MPMoviePlayerViewController *media = [[MPMoviePlayerViewController alloc] initWithContentURL:url];
        [self presentMoviePlayerViewControllerAnimated:media];
        
        
        [media.moviePlayer play];
        [TestFlight passCheckpoint:str];
        
		
	}
    
    else if ([str isEqual:@"Lección 15"])
	{
		
        NSString *urlText = [NSString stringWithFormat:@"http://download-tv.kabbalah.info/eng/shows/kr/eng_tk_lesson_kabbalah-revealed-ep15_2010-06-09_tweb-distro-360.mp4"];
        NSURL *url = [NSURL URLWithString:urlText];
        
        MPMoviePlayerViewController *media = [[MPMoviePlayerViewController alloc] initWithContentURL:url];
        [self presentMoviePlayerViewControllerAnimated:media];
        
        
        [media.moviePlayer play];
        [TestFlight passCheckpoint:str];
        
		
	}
    
    else if ([str isEqual:@"Lección 16"])
	{
		
        NSString *urlText = [NSString stringWithFormat:@"http://download-tv.kabbalah.info/eng/shows/kr/eng_tk_lesson_kabbalah-revealed-ep16_2010-06-09_tweb-distro-360.mp4"];
        NSURL *url = [NSURL URLWithString:urlText];
        
        MPMoviePlayerViewController *media = [[MPMoviePlayerViewController alloc] initWithContentURL:url];
        [self presentMoviePlayerViewControllerAnimated:media];
        
        
        [media.moviePlayer play];
        [TestFlight passCheckpoint:str];
        
		
	}
	
	// Deselect
	//[self.tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    
}
- (IBAction)openActionSheet{
    UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:@"" delegate:self cancelButtonTitle:@"Cancel" destructiveButtonTitle:nil otherButtonTitles:@"Tweet This", @"Email This", @"Post to Facebook", @"Open in Safari", nil];
    [actionSheet showFromTabBar:self.tabBarController.tabBar];
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
            
            [tweetSheet setCompletionHandler:^(SLComposeViewControllerResult result) {
                
                switch (result) {
                    case SLComposeViewControllerResultCancelled:
                        NSLog(@"Post Canceled");
                        break;
                    case SLComposeViewControllerResultDone:
                        NSLog(@"Post Sucessful");
                        break;
                        
                    default:
                        break;
                }
            }];
            
            
            [self presentViewController:tweetSheet animated:YES completion:nil];
        }
        
        /*
        TWTweetComposeViewController *tweetSheet =
        [[TWTweetComposeViewController alloc] init];
        
        [tweetSheet setInitialText:@"16 Lessons that will change your life! via @KabbalahApp"];
        //[tweetSheet addImage:[UIImage imageNamed:@"studyBack.png"]];
        [tweetSheet addURL:[NSURL URLWithString:@"http://goo.gl/fWc6I"]];
        
        
        tweetSheet.completionHandler = ^(TWTweetComposeViewControllerResult result){
            [self dismissModalViewControllerAnimated:YES];
        };
        
	    [self presentModalViewController:tweetSheet animated:YES];*/
        [TestFlight passCheckpoint:@"Twitter Self Study"];
        
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
        [TestFlight passCheckpoint:@"Email Self Study"];
        
    }
    
    if (buttonIndex == 2) {
        
        NSString *message = [NSString stringWithFormat:@"Kabbalah Revealed. Check out these 16 lessons that will change your life. | Via Kabbalah App."];
        NSURL *url = [NSURL URLWithString:@"http://goo.gl/fWc6I"];
        if([SLComposeViewController isAvailableForServiceType:SLServiceTypeFacebook]) {
            
            SLComposeViewController *controller = [SLComposeViewController composeViewControllerForServiceType:SLServiceTypeFacebook];
            
            [controller setInitialText:message];
            [controller addURL:url];
            
            [controller setCompletionHandler:^(SLComposeViewControllerResult result) {
                
                switch (result) {
                    case SLComposeViewControllerResultCancelled:
                        NSLog(@"Post Canceled");
                        break;
                    case SLComposeViewControllerResultDone:
                        NSLog(@"Post Sucessful");
                        break;
                        
                    default:
                        break;
                }
            }];
            
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
            
            [TestFlight passCheckpoint:@"Facebook Bookstore"];
        }*/
        
    }
    
    if (buttonIndex == 3) {
        NSURL * currentURL = [NSURL URLWithString:@"http://goo.gl/fWc6I"];
        [[UIApplication sharedApplication] openURL:currentURL];
        
        [TestFlight passCheckpoint:@"Open in Safari. Self study."];
        
    }
    
}

- (void)mailComposeController:(MFMailComposeViewController *)controller didFinishWithResult:(MFMailComposeResult)result error:(NSError *)error{
    
    [self dismissViewControllerAnimated:YES completion:nil];
    
    if (result == MFMailComposeResultFailed) {
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
