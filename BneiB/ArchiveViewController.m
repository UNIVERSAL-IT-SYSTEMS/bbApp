//
//  KabTVViewController.m
//  Kabbalah
//
//  Created by MexRockstar.
//  Copyright (c) 2012 Bnei Baruch USA. All rights reserved.
//

#import "ArchiveViewController.h"
#import "SelfStudyTableViewController.h"
#import "BooksController.h"
#import "LibraryViewController.h"
#import "LibraryBookList.h"
#import "MediaTableViewController.h"
#import "Twitter/Twitter.h"
#import "Reachability.h"
#import "ArchiveShareViewController.h"
#import "LibraryList.h"

@interface ArchiveViewController ()

@end

@implementation ArchiveViewController
@synthesize detailBG = _detailBG;
@synthesize mediButton, libraryButton, booksButton, selfButton;
@synthesize moviePlayer;



- (void)SelfStudy:(id)sender {
    
    SelfStudyTableViewController *itemDetail = [self.storyboard instantiateViewControllerWithIdentifier:@"selfStudyVideos"];
    [self.navigationController pushViewController:itemDetail animated:YES];
    
    //[TestFlight passCheckpoint:@"Pressed Self Study"];

    

}

- (void)Media:(id)sender{
    
    MediaTableViewController *itemDetail = [self.storyboard instantiateViewControllerWithIdentifier:@"Media"];
    [self.navigationController pushViewController:itemDetail animated:YES];
    //[TestFlight passCheckpoint:@"Pressed Media"];

}
- (void)Library:(id)sender{
    
    LibraryList *itemDetail = [self.storyboard instantiateViewControllerWithIdentifier:@"LibraryList"];
    [self.navigationController pushViewController:itemDetail animated:YES];
    //[TestFlight passCheckpoint:@"Pressed Library"];

    
}

- (void)Books:(id)sender{
    
    BooksController *itemDetail = [self.storyboard instantiateViewControllerWithIdentifier:@"Books"];
    [self.navigationController pushViewController:itemDetail animated:YES];
    //[TestFlight passCheckpoint:@"Pressed Bookstore"];

    
}



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
    [[LocalyticsSession shared] tagEvent:@"Archive Main"];
    [super viewDidLoad];
    
    //self.title = NSLocalizedString(@"ARCHIVE", nil);
    
    //UIColor* bgColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"bg_tweet_place_holder~iphone.png"]];
    //[self.view setBackgroundColor:bgColor];
    
    UIColor *bgColor = [UIColor whiteColor];
    [self.view setBackgroundColor:bgColor];
    
    //UIImage *bg = [UIImage imageNamed:@"bg_profile_empty~iphone.png"];
    //_detailBG = [[[UIImageView alloc]initWithImage:bg]autorelease];
    //_detailBG.frame = CGRectMake(0, 28, 320.0, 260.0);
    //[self.view addSubview:_detailBG];
    
    //UIColor* bgImageColor = [UIColor colorWithPatternImage:bg];
    //CALayer * lt= [self.detailBG layer];
    //[lt setMasksToBounds:YES];
    //[lt setCornerRadius:10.0];
    //[self.detailBG setBackgroundColor:bgImageColor];
    
    UIImage *engbtn = [UIImage imageNamed:@"btn_standard_blue_border_default~iphone.png"];
    UIImage *stretchBtnEng = [engbtn stretchableImageWithLeftCapWidth:5.0 topCapHeight:0.0];
    UIImageView *btnImageViewEng = [[UIImageView alloc]initWithImage:stretchBtnEng];
    btnImageViewEng.frame = CGRectMake(120, 45, 162.0, stretchBtnEng.size.height);
    [mediButton setBackgroundImage:stretchBtnEng forState:UIControlStateNormal];
    
    UIImage *btnPressedEng = [UIImage imageNamed:@"btn_timeline_cta_rect_default.png"];
    UIImage *stretchBtnPressedEng = [btnPressedEng stretchableImageWithLeftCapWidth:5.0 topCapHeight:0.0];
    UIImageView *btnPressedImageViewEng = [[UIImageView alloc]initWithImage:stretchBtnPressedEng];
    btnPressedImageViewEng.frame = CGRectMake(120, 45, 162.0, stretchBtnPressedEng.size.height);
    [mediButton setBackgroundImage:stretchBtnPressedEng forState:UIControlStateHighlighted];
    
    mediButton = [[UIButton alloc] initWithFrame:CGRectMake(25.0f, 62.0f, 270.0f, 42.0f)];
    [mediButton setTitle:NSLocalizedString(@"MEDIA", nil) forState:UIControlStateNormal];
    [mediButton setTitleColor:[UIColor colorWithRed:27/255.0 green:135/255.0 blue:195/255.0 alpha:1.0] forState:UIControlStateNormal];
    [mediButton setTitle:NSLocalizedString(@"MEDIA", nil) forState:UIControlStateSelected];
    [mediButton setTitleColor:[UIColor whiteColor] forState:UIControlStateHighlighted];
    [mediButton setBackgroundImage:stretchBtnEng forState:UIControlStateNormal];
    [mediButton setBackgroundImage:stretchBtnPressedEng forState:UIControlStateHighlighted];
    [mediButton addTarget:self action:@selector(Media:) forControlEvents:UIControlEventTouchUpInside];
    mediButton.titleLabel.font = [UIFont boldSystemFontOfSize:17.0f];
    [self.view addSubview:mediButton];
    
    UIImage *btnheb = [UIImage imageNamed:@"btn_standard_blue_border_default~iphone.png"];
    UIImage *stretchBtnHeb = [btnheb stretchableImageWithLeftCapWidth:5.0 topCapHeight:0.0];
    UIImageView *btnImageViewHeb = [[UIImageView alloc]initWithImage:stretchBtnHeb];
    btnImageViewHeb.frame = CGRectMake(120, 95, 162.0, stretchBtnHeb.size.height);
    [libraryButton setBackgroundImage:stretchBtnHeb forState:UIControlStateNormal];
    
    UIImage *btnPressedHeb = [UIImage imageNamed:@"btn_timeline_cta_rect_default.png"];
    UIImage *stretchBtnPressedHeb = [btnPressedHeb stretchableImageWithLeftCapWidth:5.0 topCapHeight:0.0];
    UIImageView *btnPressedImageViewHeb = [[UIImageView alloc]initWithImage:stretchBtnPressedHeb];
    btnPressedImageViewHeb.frame = CGRectMake(120, 95, 162.0, stretchBtnPressedHeb.size.height);
    [libraryButton setBackgroundImage:stretchBtnPressedHeb forState:UIControlStateHighlighted];
    
    libraryButton = [[UIButton alloc] initWithFrame:CGRectMake(25.0f, 112.0f, 270.0f, 42.0f)];
    [libraryButton setTitle:NSLocalizedString(@"LIBRARY", nil) forState:UIControlStateNormal];
    [libraryButton setTitleColor:[UIColor colorWithRed:27/255.0 green:135/255.0 blue:195/255.0 alpha:1.0] forState:UIControlStateNormal];
    [libraryButton setTitle:NSLocalizedString(@"LIBRARY", nil) forState:UIControlStateSelected];
    [libraryButton setTitleColor:[UIColor whiteColor] forState:UIControlStateHighlighted];
    [libraryButton setBackgroundImage:stretchBtnHeb forState:UIControlStateNormal];
    [libraryButton setBackgroundImage:stretchBtnPressedHeb forState:UIControlStateHighlighted];
    [libraryButton addTarget:self action:@selector(Library:) forControlEvents:UIControlEventTouchUpInside];
    libraryButton.titleLabel.font = [UIFont boldSystemFontOfSize:17.0f];
    [self.view addSubview:libraryButton];
    
    UIImage *btnrus = [UIImage imageNamed:@"btn_standard_blue_border_default~iphone.png"];
    UIImage *stretchBtnRus = [btnrus stretchableImageWithLeftCapWidth:5.0 topCapHeight:0.0];
    UIImageView *btnImageViewRus = [[UIImageView alloc]initWithImage:stretchBtnRus];
    btnImageViewRus.frame = CGRectMake(120, 145, 162.0, stretchBtnRus.size.height);
    [booksButton setBackgroundImage:stretchBtnRus forState:UIControlStateNormal];
    
    UIImage *btnPressedRus = [UIImage imageNamed:@"btn_timeline_cta_rect_default.png"];
    UIImage *stretchBtnPressedRus = [btnPressedRus stretchableImageWithLeftCapWidth:5.0 topCapHeight:0.0];
    UIImageView *btnPressedImageViewRus = [[UIImageView alloc]initWithImage:stretchBtnPressedRus];
    btnPressedImageViewRus.frame = CGRectMake(120, 145, 162.0, stretchBtnPressedRus.size.height);
    [booksButton setBackgroundImage:stretchBtnPressedRus forState:UIControlStateHighlighted];
    
    booksButton = [[UIButton alloc] initWithFrame:CGRectMake(25.0f, 162.0f, 270.0f, 42.0f)];
    [booksButton setTitle:NSLocalizedString(@"BOOKS",nil) forState:UIControlStateNormal];
    [booksButton setTitleColor:[UIColor colorWithRed:27/255.0 green:135/255.0 blue:195/255.0 alpha:1.0] forState:UIControlStateNormal];
    [booksButton setTitle:NSLocalizedString(@"BOOKS",nil) forState:UIControlStateSelected];
    [booksButton setTitleColor:[UIColor whiteColor] forState:UIControlStateHighlighted];
    [booksButton setBackgroundImage:stretchBtnRus forState:UIControlStateNormal];
    [booksButton setBackgroundImage:stretchBtnPressedRus forState:UIControlStateHighlighted];
    [booksButton addTarget:self action:@selector(Books:) forControlEvents:UIControlEventTouchUpInside];
    booksButton.titleLabel.font = [UIFont boldSystemFontOfSize:17.0f];
    [self.view addSubview:booksButton];
    
    UIImage *btnsched = [UIImage imageNamed:@"btn_standard_blue_border_default~iphone.png"];
    UIImage *stretchBtnSched = [btnsched stretchableImageWithLeftCapWidth:5.0 topCapHeight:0.0];
    UIImageView *btnImageViewSched = [[UIImageView alloc]initWithImage:stretchBtnSched];
    btnImageViewSched.frame = CGRectMake(120, 195, 162.0, stretchBtnSched.size.height);
    [selfButton setBackgroundImage:stretchBtnSched forState:UIControlStateNormal];
    
    UIImage *btnPressedSched = [UIImage imageNamed:@"btn_timeline_cta_rect_default.png"];
    UIImage *stretchBtnPressedSched = [btnPressedSched stretchableImageWithLeftCapWidth:5.0 topCapHeight:0.0];
    UIImageView *btnPressedImageViewSched = [[UIImageView alloc]initWithImage:stretchBtnPressedSched];
    btnPressedImageViewSched.frame = CGRectMake(120, 195, 162.0, stretchBtnPressedSched.size.height);
    [selfButton setBackgroundImage:stretchBtnPressedSched forState:UIControlStateHighlighted];
    
    selfButton = [[UIButton alloc] initWithFrame:CGRectMake(25.0f, 212.0f, 270.0f, 42.0f)];
    [selfButton setTitle:NSLocalizedString(@"SELF-STUDY", nil) forState:UIControlStateNormal];
    [selfButton setTitleColor:[UIColor colorWithRed:27/255.0 green:135/255.0 blue:195/255.0 alpha:1.0] forState:UIControlStateNormal];
    [selfButton setTitle:NSLocalizedString(@"SELF-STUDY", nil) forState:UIControlStateSelected];
    [selfButton setTitleColor:[UIColor whiteColor] forState:UIControlStateHighlighted];
    [selfButton setBackgroundImage:stretchBtnSched forState:UIControlStateNormal];
    [selfButton setBackgroundImage:stretchBtnPressedSched forState:UIControlStateHighlighted];
    [selfButton addTarget:self action:@selector(SelfStudy:) forControlEvents:UIControlEventTouchUpInside];
    selfButton.titleLabel.font = [UIFont boldSystemFontOfSize:17.0f];
    [self.view addSubview:selfButton];
    
    /*UINavigationBar *navBar = [self.navigationController navigationBar];
    UIImage *backgroundImage = [UIImage imageNamed:@"navbar.png"];
    [navBar setBackgroundImage:backgroundImage forBarMetrics:UIBarMetricsDefault];
    [navBar setTintColor:[UIColor colorWithRed:31/255.0 green:62/255.0 blue:96/255.0 alpha:1.00]];*/
    
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
    
    
}
- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}


- (IBAction)openActionSheet{
    UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:@"" delegate:self cancelButtonTitle:@"Cancel" destructiveButtonTitle:nil otherButtonTitles:@"Tweet This", @"Email This", @"Post to Facebook", @"Open in Safari", nil];
    [actionSheet showInView:self.tabBarController.tabBar];
}

- (void)actionSheet: (UIActionSheet *) actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex{
    if (buttonIndex == 0) {
        /*TWTweetComposeViewController *tweetSheet =
        [[TWTweetComposeViewController alloc] init];
        
        [tweetSheet setInitialText:@"Check out the Kabbalah Media Archive section! @KabbalahApp"];
        [tweetSheet addURL:[NSURL URLWithString:@"http://goo.gl/kgnNU"]];
        
        
        tweetSheet.completionHandler = ^(TWTweetComposeViewControllerResult result){
            [self dismissModalViewControllerAnimated:YES];
        };
        
	    [self presentModalViewController:tweetSheet animated:YES];
        [TestFlight passCheckpoint:@"Twitter Archive"];*/
        if ([SLComposeViewController isAvailableForServiceType:SLServiceTypeTwitter])
        {
            SLComposeViewController *tweetSheet = [SLComposeViewController
                                                   composeViewControllerForServiceType:SLServiceTypeTwitter];
            [tweetSheet setInitialText:@"Check out the Kabbalah Media Archive section! @KabbalahApp"];
            [tweetSheet addURL:[NSURL URLWithString:@"http://goo.gl/kgnNU"]];
            [self presentViewController:tweetSheet animated:YES completion:nil];
        }

    }
    
    if (buttonIndex == 1) {
        MFMailComposeViewController * composer = [[MFMailComposeViewController alloc]init];
        [composer setMailComposeDelegate:self];
        
        if ([MFMailComposeViewController canSendMail]) {
            [composer setToRecipients:@[@""]];
            [composer setSubject:@"Found this and thought of sharing it with you."];
            NSMutableString *body = [NSMutableString string];
            [composer setMessageBody:body isHTML:YES];
            [body appendString:@"<h2>Kabbalah Media Archive</h2>"];
            [body appendString:@"<p>Free Kabbalah Lessons, Sources, Video and Audio Downloads</p>"];
            [body appendString:@"<a href =\"http://goo.gl/kgnNU\"> Link</a>\n"];
            [body appendString:@"<p>"];
            [body appendString:@"Follow us on <a href =\"http://www.twitter.com/KabbalahApp\">Twitter</a></br>"];
            [body appendString:@"Like us on <a href =\"https://www.facebook.com/KabbalahApp\">Facebook</a></br>"];
            [body appendString:@"Share us on <a href =\"https://plus.google.com/u/0/b/110517944996918866621/110517944996918866621\">Google +</a>"];
            [body appendString:@"</p>"];
            
            [body appendString:@"<p>Via <a href =\"http://itunes.apple.com/us/app/kabbalah-app/id550938690\">Kabbalah App</a></p>\n"];
            [composer setModalTransitionStyle:UIModalTransitionStyleCoverVertical];
            [self presentViewController:composer animated:YES completion:nil];
        }
        //[TestFlight passCheckpoint:@"Email. Archive. "];
 
    }
    
    if (buttonIndex == 2) {
        
        NSString *message = [NSString stringWithFormat:@"Kabbalah Media Archive, Free Kabbalah Lessons, Sources, Video and Audio Downloads. | Via Kabbalah App."];
        NSURL *url = [NSURL URLWithString:@"http://goo.gl/kgnNU"];
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
        
        ArchiveShareViewController *viewController = [self.storyboard instantiateViewControllerWithIdentifier:@"ArchiveShareView"];
        [self presentViewController:viewController animated:YES completion:nil];
        
        [TestFlight passCheckpoint:@"Facebook. Archive"];
        }*/
        
    }
    
    if (buttonIndex == 3){
        NSURL *currenturl = [NSURL URLWithString:@"http://goo.gl/kgnNU"];
        [[UIApplication sharedApplication] openURL:currenturl];
        
        //[TestFlight passCheckpoint:@"Open in Safari. Archive. "];

        
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
