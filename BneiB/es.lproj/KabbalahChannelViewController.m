//
//  DailyViewController.m
//  Kabbalah
//
//  Created by MexRockstar.
//  Copyright (c) 2012 Bnei Baruch USA. All rights reserved.
//

#import "KabbalahChannelViewController.h"
#import "KabbalahAskViewController.h"
#import "KabbalahIdeasViewController.h"
#import "KabbalahKabKafeViewController.h"
#import "KabbalahInsightsViewController.h"
#import "KabbalahLifestyleViewController.h"
#import "KabbalahModernViewController.h"
#import "KabbalahPaperClipsViewController.h"
#import "KabbalahPathsViewController.h"
#import "KabbalahProfilesViewController.h"
#import "KabbalahEnvironmentViewController.h"
#import "KabbalahPointViewController.h"
#import "KabbalahUnityViewController.h"
#import "KabbalahZoharViewController.h"

#import "Settings.h"

#import "Twitter/Twitter.h"
#import "MBProgressHUD.h"
#import "KabbalahChannelDetailViewController.h"
#import "Reachability.h"
#import <FacebookSDK/FacebookSDK.h>
#import "BlockAlertView.h"
#import "BlockBackground.h"
#import "BlockUI.h"

#import "KabCustomCell.h"



@class MBProgressHUD;

@interface KabbalahChannelViewController ()


@end

@implementation KabbalahChannelViewController

//@synthesize request = _request;


/////////VIEW SETTINGS/////////

//-(NSUInteger)supportedInterfaceOrientationsForWindow: (UIWindow *)window{
//    return UIInterfaceOrientationMaskPortrait;
//}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

-(NSUInteger)supportedInterfaceOrientations{
    return UIInterfaceOrientationMaskPortrait;
}

-(BOOL)shouldAutorotate{
    return NO;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}


- (IBAction)viewSettings;{
    
    Settings *itemDetail = [self.storyboard instantiateViewControllerWithIdentifier:@"SettingsView"];
    [self.navigationController pushViewController:itemDetail animated:YES];
    
}
///////////////////////////////

@synthesize cellImage;

- (id)initWithStyle:(UITableViewStyle)style
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
    
    
    
    NSError *error;
    [[GANTracker sharedTracker] trackPageview:@"Kabbalah Channel Main"
                                    withError:&error];
                                         
    //[[FBLoginView alloc] initWithPermissions:[NSArray arrayWithObject:@"status_update"]];
     
    [TestFlight passCheckpoint:@"Kabbalah Channel View"];
    
    internetReach = [[Reachability reachabilityForInternetConnection] retain];
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
            
            BlockAlertView *alert = [BlockAlertView alertWithTitle:@"Alert" message:@"No 3G/WiFi detected. Some sections require internet connection."];
            
            [alert setDestructiveButtonWithTitle:@"OK" block:nil];
            [alert show];
            break;
        }
            
    }
    
    ///////HUD//////
    HUD = [[MBProgressHUD alloc] initWithView:self.navigationController.view];
	[self.navigationController.view addSubview:HUD];
	
	HUD.delegate = self;
	HUD.labelText = @"Loading";
	
	[HUD showWhileExecuting:@selector(myTask) onTarget:self withObject:nil animated:YES];
    ////////////////
    
    UIColor* bgColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"ipad-BG-pattern.png"]];
    [self.view setBackgroundColor:bgColor];
    
    /////Custom Nav Bar////////
    /*UINavigationBar *navBar = [self.navigationController navigationBar];
    UIImage *backgroundImage = [UIImage imageNamed:@"menubar.png"];
    [navBar setBackgroundImage:backgroundImage forBarMetrics:UIBarMetricsDefault];
    [navBar setTintColor:[UIColor colorWithRed:31/255.0 green:62/255.0 blue:96/255.0 alpha:1.00]];*/
    //////////////////////////

    
    //////CELL INFO STARTS//////////
    kabChannel = [[NSMutableArray alloc] initWithObjects:
                  @"20 Ideas",
                  @"Animarte", 
                  @"Contundente",
                  @"Paella",
                  @"Punto en el Corazon",
                  @"Relatos",
                  @"Senderos",
                  @"Sesiones de Unidad",
                  nil];
    
    kabChannelDetail = [[NSMutableArray alloc] initWithObjects:
                        @"The real news of the day from a Kabbalistic perspective.",
                        
                        @"Find answers to all your questions from Dr. Laitman.",
                        
                        @"In depth talks on a given topic, exploring the Kabbalistic perspective on various subjects.",
                        
                        @"Unwind at the Kab Kafé where advancing hearts connect with live music in an intimate setting.",
                        
                        @"Find the deeper meaning of things from Dr. Michael Laitman as he explains the spiritual root of things from everyday life.",
                        
                        @"Kabbalistic insights on social issues and personal lifestyles; a guide to expanding perspectives and understanding of familiar issues.",
                        
                        @"Global society is in crisis because it has yet to discover the laws governing global life. Now is the time to learn them to bring about purposeful, results oriented action.",
                        
                        @"Profound concepts presented fun and fast.",
                        
                        
                        
                         nil];
    
    [self setCellImage:[NSArray arrayWithObjects:
                        @"Inner.png",
                        @"Ask.png",
                        @"Ideas.png",
                        @"Kafe.png",
                        @"Insights.png",
                        @"Lifestyles.png",
                        @"Modern.png",
                        @"Clips.png",
                        
                        
                        
                        
                        nil]];
  ////////////////////////////////////////////////
    //cellImage = [[NSArray alloc] initWithObjects:@"Inner.png",@"Ask.png",@"Environment.png",@"Modern.png",@"studyBack.png", nil];
    
}




- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{

    // Return the number of rows in the section.
    return [kabChannel count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"KabChanCell";
    //tableView.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"list-item.png"]];
    


    KabCustomCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    //////CELL CUSTOM BG///////////
    /*UIImageView *imageView = [[UIImageView alloc] initWithFrame:cell.frame];
    UIImage *image = [UIImage imageNamed:@"list-item.png"];
    imageView.image = image;
    cell.backgroundView = imageView;
    [[cell textLabel] setBackgroundColor:[UIColor clearColor]];
    [[cell detailTextLabel] setBackgroundColor:[UIColor clearColor]];*/
    
    // Configure the cell...
    cell.KabTitle.text = [[kabChannel objectAtIndex:indexPath.row]retain];
    cell.KabSubTitle.text = [[kabChannelDetail objectAtIndex:indexPath.row]retain];
    
    NSString *cellImage = [[self cellImage] objectAtIndex:[indexPath row]];
    UIImage *cellIcon = [UIImage imageNamed:cellImage];
    [[cell KabImageView] setImage:cellIcon];
    
    return cell;
    
}

/*- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    // Regular
    return 77;
    
} */

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *str= [kabChannel objectAtIndex:indexPath.row];
    if ([str isEqual:@"The Inner Stream"])
	{
        
        KabbalahChannelDetailViewController *itemDetail = [self.storyboard instantiateViewControllerWithIdentifier:@"InnerDetail"];
        [self.navigationController pushViewController:itemDetail animated:YES];
        
        [TestFlight passCheckpoint:@"Pressed Kabbalah Channel"];

        
    }
    
    else if ([str isEqual:@"Ask The Kabbalist"])
	{
        
         KabbalahAskViewController *itemDetail = [self.storyboard instantiateViewControllerWithIdentifier:@"AskDetail"];
        [self.navigationController pushViewController:itemDetail animated:YES];
        
        [TestFlight passCheckpoint:@"Pressed Ask The Kabbalist"];
		
	}
    else if ([str isEqual:@"20 Ideas"])
	{
        
        KabbalahIdeasViewController *itemDetail = [self.storyboard 
            instantiateViewControllerWithIdentifier:@"20Ideas"];
        [self.navigationController pushViewController:itemDetail animated:YES];
        
        [TestFlight passCheckpoint:@"Pressed 20 Ideas"];
		
	}
    else if ([str isEqual:@"Kab Kafé"])
	{
        
        KabbalahKabKafeViewController *itemDetail = [self.storyboard instantiateViewControllerWithIdentifier:@"KabKafeDetail"];
        [self.navigationController pushViewController:itemDetail animated:YES];
        
        [TestFlight passCheckpoint:@"Pressed Kab Kafe"];
		
	}
    else if ([str isEqual:@"Kabbalah Insights"])
	{
        KabbalahInsightsViewController *itemDetail = [self.storyboard instantiateViewControllerWithIdentifier:@"InsightsDetail"];
        [self.navigationController pushViewController:itemDetail animated:YES];
        
        [TestFlight passCheckpoint:@"Pressed Kabbalah Insights"];
		
	}
    else if ([str isEqual:@"Lifestyle"])
	{
        
        KabbalahLifestyleViewController *itemDetail = [self.storyboard instantiateViewControllerWithIdentifier:@"LifestyleDetail"];
        [self.navigationController pushViewController:itemDetail animated:YES];
        
        [TestFlight passCheckpoint:@"Pressed Lifestyle"];
		
	}
    else if ([str isEqual:@"Modern Laws of Global Life"])
	{
    
        KabbalahModernViewController *itemDetail = [self.storyboard instantiateViewControllerWithIdentifier:@"ModernDetail"];
        [self.navigationController pushViewController:itemDetail animated:YES];
        
        [TestFlight passCheckpoint:@"Pressed Modern Laws"];
		
	}
    else if ([str isEqual:@"Paper Clips"])
	{

        KabbalahPaperClipsViewController *itemDetail = [self.storyboard instantiateViewControllerWithIdentifier:@"ClipsDetail"];
        [self.navigationController pushViewController:itemDetail animated:YES];
        
        [TestFlight passCheckpoint:@"Pressed Paper Clips"];
		
	}
    else if ([str isEqual:@"Paths"])
	{

        KabbalahPathsViewController *itemDetail = [self.storyboard instantiateViewControllerWithIdentifier:@"PathsDetail"];
        [self.navigationController pushViewController:itemDetail animated:YES];
        
        [TestFlight passCheckpoint:@"Pressed Paths"];
		
	}
    else if ([str isEqual:@"Profiles"])
	{
        
        KabbalahProfilesViewController *itemDetail = [self.storyboard instantiateViewControllerWithIdentifier:@"ProfilesDetail"];
        [self.navigationController pushViewController:itemDetail animated:YES];
        [TestFlight passCheckpoint:@"Pressed Profiles"];
		//NSLog(@"Pressed Profiles");
	}
    else if ([str isEqual:@"Environment Unplugged"])
	{
        
        KabbalahEnvironmentViewController *itemDetail = [self.storyboard instantiateViewControllerWithIdentifier:@"EnvironmentDetail"];
        [self.navigationController pushViewController:itemDetail animated:YES];
        
        [TestFlight passCheckpoint:@"Pressed Environment"];
		
	}
    else if ([str isEqual:@"The Point"])
	{
        
        KabbalahPointViewController *itemDetail = [self.storyboard instantiateViewControllerWithIdentifier:@"PointDetail"];
        [self.navigationController pushViewController:itemDetail animated:YES];
        
        [TestFlight passCheckpoint:@"Pressed The Point"];
		
	}
    else if ([str isEqual:@"Unity Sessions"])
	{

        
        KabbalahUnityViewController *itemDetail = [self.storyboard instantiateViewControllerWithIdentifier:@"UnityDetail"];
        [self.navigationController pushViewController:itemDetail animated:YES];
        
        [TestFlight passCheckpoint:@"Pressed Unity"];
		
	}
    else if ([str isEqual:@"Unlocking The Zohar"])
	{

        KabbalahZoharViewController *itemDetail = [self.storyboard instantiateViewControllerWithIdentifier:@"ZoharDetail"];
        [self.navigationController pushViewController:itemDetail animated:YES];
        
        [TestFlight passCheckpoint:@"Pressed Unlocking"];
		
	}
}

- (NSDictionary*)parseURLParams:(NSString *)query {
    NSArray *pairs = [query componentsSeparatedByString:@"&"];
    NSMutableDictionary *params = [[NSMutableDictionary alloc] init];
    for (NSString *pair in pairs) {
        NSArray *kv = [pair componentsSeparatedByString:@"="];
        NSString *val =
        [[kv objectAtIndex:1]
         stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
        
        [params setObject:val forKey:[kv objectAtIndex:0]];
    }
    return params;
}

// Handle the publish feed call back
- (void)dialogCompleteWithUrl:(NSURL *)url {
    NSDictionary *params = [self parseURLParams:[url query]];
    NSString *msg = [NSString stringWithFormat:
                     @"Posted story, id: %@",
                     [params valueForKey:@"post_id"]];
    NSLog(@"%@", msg);
    // Show the result in an alert
    BlockAlertView *alert = [BlockAlertView alertWithTitle:@"Result" message:msg];
    
    [alert setDestructiveButtonWithTitle:@"OK" block:nil];
    [alert show];
}

/*- (IBAction)openActionSheet{
    NSArray *activityItems = @[@"Hello",[UIImage imageNamed:@"iTunesArtwork.png"], [NSURL URLWithString:@"http://goo.gl/YHsFu"]];
    UIActivityViewController *activityViewController = [[UIActivityViewController alloc] initWithActivityItems:activityItems applicationActivities:nil];
    activityViewController.excludedActivityTypes = @[UIActivityTypePostToWeibo, UIActivityTypeAssignToContact, UIActivityTypePrint, UIActivityTypeSaveToCameraRoll, UIActivityTypeMessage, UIActivityTypeCopyToPasteboard];
    [self presentViewController:activityViewController animated:YES completion:NULL];
    [activityViewController release];
    
    
}*/


//////SHARE MENU//////

- (IBAction)openActionSheet{
    UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:@"" delegate:self cancelButtonTitle:@"Cancel" destructiveButtonTitle:nil otherButtonTitles:@"Tweet This", @"Email This", @"Post to Facebook", @"Open in Safari", nil];
    [actionSheet showInView:self.tabBarController.tabBar];
    [actionSheet release];
    
    
}

- (void)actionSheet: (UIActionSheet *) actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex{
    if (buttonIndex == 0) {
        TWTweetComposeViewController *tweetSheet = 
        [[TWTweetComposeViewController alloc] init];
        
        [tweetSheet setInitialText:@"Check out the Kabbalah Channel @KabbalahApp"];
        [tweetSheet addURL:[NSURL URLWithString:@"http://goo.gl/YHsFu"]];
        
        
        tweetSheet.completionHandler = ^(TWTweetComposeViewControllerResult result){
            [self dismissModalViewControllerAnimated:YES];
        };
        
	    [self presentModalViewController:tweetSheet animated:YES];
    }
    
    if (buttonIndex == 1) {
        MFMailComposeViewController * composer = [[MFMailComposeViewController alloc]init];
        [composer setMailComposeDelegate:self];
        
        if ([MFMailComposeViewController canSendMail]) {
            [composer setToRecipients:[NSArray arrayWithObjects:@"", nil]];
            [composer setSubject:@"Found this and thought of sharing it with you."];
            NSMutableString *body = [NSMutableString string];
            [composer setMessageBody:body isHTML:YES];
            [body appendString:@"<h2>Kabbalah Channel</h2>"];
            [body appendString:@"<p><strong>Watch Life Make Sense</strong></p>"];
            [body appendString:@"<p>All of the programming you’ll see on the Kabbalah Channel is about the natural meaning and purpose of life and how you can fulfill it. Our live and recorded shows, clips, lessons and music are based on authentic <a href =\"http://www.kabbalah.info\">Kabbalah</a> texts and present the wisdom in a modern, relevant and accessible way.</p>"];
            [body appendString:@"<p>Our goal is to make this profound system for transforming human nature, a system embodied in The <a href =\"http://www.kabbalah.info/engkab/mystzohar.htm\">Zohar</a>, available to everyone at this critical turning point in history when humanity needs to undergo a positive adjustment to our increasingly globalized and interdependent existence.</p>"];
            [body appendString:@"<p>The Kabbalah Channel is the English language division of the Bnei Baruch Kabbalah and Research Institute’s Channel 66, based in Israel. Bnei Baruch is a non-profit educational organization.</p>"];
            [body appendString:@"Check it out<a href =\"http://tv.kabbalah.info\"> Here</a>\n"];
            [body appendString:@"<p>"];
            [body appendString:@"Follow us on <a href =\"http://www.twitter.com/KabbalahApp\">Twitter</a></br>"];
            [body appendString:@"Like us on <a href =\"https://www.facebook.com/KabbalahApp\">Facebook</a></br>"];
            [body appendString:@"Share us on <a href =\"https://plus.google.com/u/0/b/110517944996918866621/110517944996918866621\">Google +</a>"];
            [body appendString:@"</p>"];
            
            [body appendString:@"<p>Via <a href =\"http://itunes.apple.com/us/app/kabbalah-app/id550938690\">Kabbalah App</a></p>\n"];
            [composer setModalTransitionStyle:UIModalTransitionStyleCoverVertical];
            [self presentModalViewController:composer animated:YES];
            [composer release];
        }
        
    }
    
    if (buttonIndex == 2) {
        
        NSString *message = [NSString stringWithFormat:@"Watch Life Make Sense. | Via Kabbalah App."];
        NSURL *url = [NSURL URLWithString:@"http://tv.kabbalah.info"];
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
            ShareViewController *viewController = [self.storyboard instantiateViewControllerWithIdentifier:@"ShareView"];
            [self presentViewController:viewController animated:YES completion:nil];
            
        }


        
    }
    
    if (buttonIndex == 3){
        NSURL *currenturl = [NSURL URLWithString:@"http://goo.gl/YHsFu"];
        [[UIApplication sharedApplication] openURL:currenturl];
        
    }
    
}


- (void)mailComposeController:(MFMailComposeViewController *)controller didFinishWithResult:(MFMailComposeResult)result error:(NSError *)error{
    
    [self dismissModalViewControllerAnimated:YES];
    
    if (result == MFMailComposeResultFailed) {
        BlockAlertView *alert = [BlockAlertView alertWithTitle:@"Alert" message:@"Unable to send email"];
        
        [alert setDestructiveButtonWithTitle:@"OK" block:nil];
        [alert show];
    }
    
}

// UIAlertView helper for post buttons
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
////////////////////////////////////////////////////


//////HUD PROCESS/////////////////
- (void)myTask {
	// Do something usefull in here instead of sleeping ...
[super viewDidLoad];    
    sleep(1);
}
/////////////////////////////////


- (void)dealloc {
    [kabChannel release];
    [kabChannelDetail release];
    [moviePlayer release];
    [cellImage release];
    [[GANTracker sharedTracker] stopTracker];
    [KabCustomCell release];
    [BlockAlertView release];
    [super dealloc];

    //[facebook release];
    
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
            BlockAlertView *alert = [BlockAlertView alertWithTitle:@"Alert" message:@"No 3G/WiFi detected. Some sections require internet connection."];
            
            [alert setDestructiveButtonWithTitle:@"OK" block:nil];
            [alert show];
            break;
        }
    }
}

- (void)viewDidUnload
{
    [KabCustomCell: nil];
    [self viewSettings:nil];
    [self setCellImage:nil];
    [kabChannel: nil];
    [BlockAlertView: nil];
    [super viewDidUnload];

    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}


@end
