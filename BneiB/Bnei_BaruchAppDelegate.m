//
//  Bnei_BaruchAppDelegate.m
//  Kabbalah
//
//  Created by MexRockstar.
//  Copyright (c) 2012 Bnei Baruch USA. All rights reserved.
//

#import "Bnei_BaruchAppDelegate.h"
#import "KabbalahChannelViewController.h"
#import "BlogViewController.h"
#import "PullToRefreshView.h"
#import "Appirater.h"
#import <FacebookSDK/FacebookSDK.h>
#import <Crashlytics/Crashlytics.h>
#import <Parse/Parse.h>
#import "LocalyticsSession.h"
#import "LocalyticsUtilities.h"

@interface Bnei_BaruchAppDelegate()

@end

//static const NSInteger kGANDispatchPeriodSec = 10;
@implementation Bnei_BaruchAppDelegate
@synthesize window = _window;



//@synthesize session = _session;

//NSString *const FBSessionStateChangedNotification = @"FBSessionStateChangedNotification";

/*- (NSUInteger)application:(UIApplication*)application
supportedInterfaceOrientationsForWindow:(UIWindow*)window
{
    return UIInterfaceOrientationMaskAllButUpsideDown;
}
*/

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
//    [NewRelicAgent startWithApplicationToken:@"AA41f8e0391cbe018a90599c7e4c97f35156a3a0ac"];
    
    UIUserInterfaceIdiom idiom = [[UIDevice currentDevice] userInterfaceIdiom];
    if (idiom == UIUserInterfaceIdiomPad)
    {
        //[self customizeiPadTheme];
        [application setStatusBarHidden:NO];
        [application setStatusBarStyle:UIStatusBarStyleLightContent];
        UINavigationBar *navigationBar = [UINavigationBar appearance];
        [navigationBar setBackgroundImage:[UIImage imageNamed:@"navbar_bg"] forBarMetrics:UIBarMetricsDefault];
        //[[UINavigationBar appearance] setBackgroundImage:[UIImage imageNamed:@"navbar_bg"] forBarMetrics:UIBarMetricsDefault];
        
        [self iPadInit];
        [self _setupTabBarAppearance];
        [[LocalyticsSession shared] tagEvent:@"iPad"];
        
    }
    else
    {
        //[self customizeiPhoneTheme];
        [application setStatusBarHidden:NO];
        [application setStatusBarStyle:UIStatusBarStyleLightContent];
        UINavigationBar *navigationBar = [UINavigationBar appearance];
        [navigationBar setBackgroundImage:[UIImage imageNamed:@"navbar_bg"] forBarMetrics:UIBarMetricsDefault];
        [self _setupTabBarAppearance];
        [[LocalyticsSession shared] tagEvent:@"iPhone"];

        
    }
    //[self customizeInterface];
    
//    [application registerForRemoteNotificationTypes:
//     UIRemoteNotificationTypeBadge |
//     UIRemoteNotificationTypeAlert |
//     UIRemoteNotificationTypeSound];
    
//    NSDictionary* userInfo = [launchOptions valueForKey:@"UIApplicationLaunchOptionsRemoteNotificationKey"];
//    NSDictionary *apsInfo = [userInfo objectForKey:@"aps"];
//    NSInteger badge = [[apsInfo objectForKey:@"badge"] integerValue];
//    application.applicationIconBadgeNumber = badge;
    
    // call the Appirater class
    [Appirater appLaunched:YES];
    [FBSession openActiveSessionWithAllowLoginUI:NO];
    [FBProfilePictureView class];
    
    
    /////////////Analytics/////////////
    [TestFlight takeOff:@"bbf75db9-225e-400e-82fd-08055d9202c2"];
    [Parse setApplicationId:@"7wwVE7IWamdzBYdy7BlAnqo40WxpWX3BPATImzaP"
                  clientKey:@"ihKM2UMaStdUrKqJsdraOTiSXSOtrfkQlF6ELxlN"];
    [[Crashlytics sharedInstance] setDebugMode:YES];
    [Crashlytics startWithAPIKey:@"62ce332ae1de018bdee39900e29eab6ab5d39419"];
	[[LocalyticsSession shared] startSession:@"3899ffa1d6146a0cf30c70c-79a8c6ac-c8c3-11e2-0ede-004a77f8b47f"];
    
    [PFAnalytics trackAppOpenedWithLaunchOptions:launchOptions];
    NSDictionary *dimensions = @{
                                 // What type of news is this?
                                 @"category": @"politics",
                                 // Is it a weekday or the weekend?
                                 @"dayType": @"weekday",
                                 };
    // Send the dimensions to Parse along with the 'read' event
    
    [PFAnalytics trackEvent:@"read" dimensions:dimensions];
    
   // Optionally enable development mode
#ifdef BB_API_DEVELOPMENT_MODE
	[BBHTTPClient setDevelopmentModeEnabled:NO];
	[BBPushController setDevelopmentModeEnabled:NO];
#endif
    
    // Defer some stuff to make launching faster
	dispatch_async(dispatch_get_main_queue(), ^{
		
        
        
	});
        [_window makeKeyAndVisible];
        return YES;
}


#pragma mark Push notification handling
- (void)application:(UIApplication *)application
didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)newDeviceToken
{
    // Store the deviceToken in the current installation and save it to Parse.
    PFInstallation *currentInstallation = [PFInstallation currentInstallation];
    [currentInstallation setDeviceTokenFromData:newDeviceToken];
    [currentInstallation saveInBackground];
}

- (void)application:(UIApplication *)application
didReceiveRemoteNotification:(NSDictionary *)userInfo {
    [PFPush handlePush:userInfo];
    
    NSLog(@"remote notification: %@",[userInfo description]);
    NSDictionary *apsInfo = userInfo[@"aps"];
    
    NSString *alert = apsInfo[@"alert"];
    NSLog(@"Received Push Alert: %@", alert);
    
    NSString *badge = apsInfo[@"badge"];
    NSLog(@"Received Push Badge: %@", badge);
    application.applicationIconBadgeNumber = [apsInfo[@"badge"] integerValue];
}

- (void)application:(UIApplication *)application didFailToRegisterForRemoteNotificationsWithError:(NSError *)error
{
    NSLog(@"Failed to register: %@", error.localizedDescription);
}

- (void)application:(UIApplication *)application didReceiveLocalNotification:(UILocalNotification *)notification
{
    // just pass this on to the remote notification handling routine... they serve the same purpose
    [self application:application didReceiveRemoteNotification:notification.userInfo];
}



/*- (void) clearNotifications {
    [[UIApplication sharedApplication] setApplicationIconBadgeNumber: 0];
    [[UIApplication sharedApplication] cancelAllLocalNotifications];
}*/



#pragma mark Customization

- (void)_setupTabBarAppearance
{
    
    //[[UITabBar appearance] setBackgroundImage:[UIImage imageNamed:@"bg_title_bar"]];
    //[[UITabBar appearance] setSelectionIndicatorImage:[UIImage imageNamed:@""]];
    [[UITabBarItem appearance] setTitleTextAttributes:@{NSForegroundColorAttributeName:[UIColor colorWithRed:0.16f green:0.45f blue:0.73f alpha:1.0f]}
                                             forState:UIControlStateNormal];
    
    
    [[UITabBarItem appearance] setTitleTextAttributes:@{NSForegroundColorAttributeName:[UIColor colorWithRed:0.26f green:0.78f blue:0.91f alpha:1.0]}
                                             forState:UIControlStateSelected];
    
    [[UITabBar appearance] setTintColor:[UIColor whiteColor]];
    //[[UITabBar appearance] setBarTintColor:[UIColor yellowColor]];
}

- (void)_setupToolBarAppearance
{
    // Toolbar
	UIToolbar *toolbar = [UIToolbar appearance];
	[toolbar setBackgroundImage:[UIImage imageNamed:@"navigation-background"] forToolbarPosition:UIToolbarPositionTop barMetrics:UIBarMetricsDefault];
	[toolbar setBackgroundImage:[UIImage imageNamed:@"toolbar-background"] forToolbarPosition:UIToolbarPositionBottom barMetrics:UIBarMetricsDefault];
	
	// Toolbar mini
	[toolbar setBackgroundImage:[UIImage imageNamed:@"navigation-background-mini"] forToolbarPosition:UIToolbarPositionTop barMetrics:UIBarMetricsLandscapePhone];
	[toolbar setBackgroundImage:[UIImage imageNamed:@"toolbar-background-mini"] forToolbarPosition:UIToolbarPositionBottom barMetrics:UIBarMetricsLandscapePhone];
}

-(void)customizeiPhoneTheme
{
   /* [[UIApplication sharedApplication]
     setStatusBarStyle:UIStatusBarStyleBlackOpaque animated:YES];
    
    UIImage* tabBarBackground = [UIImage imageNamed:@"tabbar.png"];
    [[UITabBar appearance] setBackgroundImage:tabBarBackground];
    
    [[UITabBar appearance] setSelectionIndicatorImage:[UIImage imageNamed:@"tabbar-active.png"]];
    
    
    UINavigationBar *navigationBar = [UINavigationBar appearance];
    [navigationBar setBackgroundImage:[UIImage imageNamed:@"bg_title_bar"] forBarMetrics:UIBarMetricsDefault];
    [navigationBar setTitleVerticalPositionAdjustment:-1.0f forBarMetrics:UIBarMetricsDefault];
    [navigationBar setTitleTextAttributes:[[NSDictionary alloc] initWithObjectsAndKeys:
                                           [UIFont boldSystemFontOfSize:20.0f], UITextAttributeFont,
                                           [UIColor whiteColor], UITextAttributeTextColor,
                                           [UIColor colorWithWhite:0.0f alpha:0.2f], UITextAttributeTextShadowColor,
                                           nil]];*/
    
        
        //UIImage *navBarImageShadow = [UIImage imageNamed:@"Navbar_Shadow"];
        //[[UINavigationBar appearance] setShadowImage:navBarImageShadow];
    
    
    
    /*UINavigationBar *navBarImage = [UINavigationBar appearance];
    [navBarImage setBackgroundImage:[UIImage imageNamed:@"bg_title_bar.png"] forBarMetrics:UIBarMetricsDefault];
    [navBarImage setTitleVerticalPositionAdjustment:-1.0f forBarMetrics:UIBarMetricsDefault];
    [navBarImage setTitleTextAttributes:[[NSDictionary alloc] initWithObjectsAndKeys:
                                         [UIFont fontWithName:kMyriadSetBoldItalic size: 25.0f], UITextAttributeFont,
                                         [UIColor colorWithWhite:0.0f alpha:0.2f], UITextAttributeTextShadowColor,
                                         [NSValue valueWithUIOffset:UIOffsetMake(0.0f, 1.0f)],
                                         UITextAttributeTextShadowOffset,
                                         [UIColor whiteColor], UITextAttributeTextColor, nil]];*/
    
    /*NSDictionary *barButtonTitleTextAttributes = [[NSDictionary alloc] initWithObjectsAndKeys:
                                                  [UIFont boldSystemFontOfSize:16.0f], UITextAttributeFont,
                                                  [UIColor colorWithWhite:0.0f alpha:0.2f],
                                                  UITextAttributeTextShadowColor,
                                                  [NSValue valueWithUIOffset:UIOffsetMake(0.0f, 1.0f)],
                                                  UITextAttributeTextShadowOffset, nil];
    
    UIBarButtonItem *barButton = [UIBarButtonItem appearanceWhenContainedIn:[UINavigationBar class], nil];
    
    [barButton setTitleTextAttributes:barButtonTitleTextAttributes forState:UIControlStateNormal];
    [barButton setTitleTextAttributes:barButtonTitleTextAttributes forState:UIControlStateHighlighted];
    [barButton setBackgroundImage:[[UIImage imageNamed:@"menubar-button.png"] resizableImageWithCapInsets:UIEdgeInsetsMake(0, 4, 0, 4)] forState:UIControlStateNormal barMetrics:UIBarMetricsDefault];
    [barButton setBackgroundImage:[[UIImage imageNamed:@"menubar-button.png"] resizableImageWithCapInsets:UIEdgeInsetsMake(0, 4, 0, 4)] forState:UIControlStateHighlighted barMetrics:UIBarMetricsDefault];
    
    //Navigation back button
    [barButton setBackButtonTitlePositionAdjustment:UIOffsetMake(0.0f, 0.0f) forBarMetrics:UIBarMetricsDefault];
    [barButton setBackButtonBackgroundImage:[[UIImage imageNamed:@"back.png"] resizableImageWithCapInsets:UIEdgeInsetsMake(0, 14, 0, 4)] forState:UIControlStateNormal barMetrics:UIBarMetricsDefault];
    [barButton setBackButtonBackgroundImage:[[UIImage imageNamed:@"back.png"] resizableImageWithCapInsets:UIEdgeInsetsMake(0, 14, 0, 4)] forState:UIControlStateHighlighted barMetrics:UIBarMetricsDefault];*/
    
    
    /*
    UIImage *backButton = [[UIImage imageNamed:@"back.png"]
                           resizableImageWithCapInsets:UIEdgeInsetsMake(0, 14, 0, 4)];
    [[UIBarButtonItem appearance] setBackButtonBackgroundImage:backButton forState:UIControlStateNormal
                                                    barMetrics:UIBarMetricsDefault];
    
    UIImage *barButton = [[UIImage imageNamed:@"menubar-button.png"] resizableImageWithCapInsets:UIEdgeInsetsMake(0, 4, 0, 4)];
    
    [[UIBarButtonItem appearance] setBackgroundImage:barButton forState:UIControlStateNormal
                                          barMetrics:UIBarMetricsDefault];
    
    UIToolbar *toolBar = [UIToolbar appearance];
    [toolBar setBackgroundImage:[UIImage imageNamed:@"bg_tab_bar"] forToolbarPosition:UIToolbarPositionAny barMetrics:UIBarMetricsDefault];*/
    
    /*UIImage *toolBarImage = [UIImage imageNamed:@"bg_tab_bar.png"];
    [[UIToolbar appearance] setBackgroundImage:toolBarImage forToolbarPosition:UIToolbarPositionAny barMetrics:UIBarMetricsDefault];*/

}


-(void)customizeiPadTheme
{
    /*UIImage* tabBarBackground = [UIImage imageNamed:@"tabbar.png"];
    [[UITabBar appearance] setBackgroundImage:tabBarBackground];
    
    [[UITabBar appearance] setSelectionIndicatorImage:[UIImage imageNamed:@"tabbar-active.png"]];
    
    UINavigationBar *navigationBar = [UINavigationBar appearance];
    [navigationBar setBackgroundImage:[UIImage imageNamed:@"bg_title_bar"] forBarMetrics:UIBarMetricsDefault];
    [navigationBar setTitleVerticalPositionAdjustment:-1.0f forBarMetrics:UIBarMetricsDefault];
    [navigationBar setTitleTextAttributes:[[NSDictionary alloc] initWithObjectsAndKeys:
                                           [UIFont boldSystemFontOfSize:20.0f], UITextAttributeFont,
                                           [UIColor whiteColor], UITextAttributeTextColor,
                                           [UIColor colorWithWhite:0.0f alpha:0.2f], UITextAttributeTextShadowColor,
                                           nil]];
    
    UIImage *toolBarImage = [UIImage imageNamed:@"bg_tab_bar.png"];
    [[UIToolbar appearance] setBackgroundImage:toolBarImage forToolbarPosition:UIToolbarPositionAny barMetrics:UIBarMetricsDefault];
    
    UIImage *backButton = [[UIImage imageNamed:@"back.png"] resizableImageWithCapInsets:UIEdgeInsetsMake(0, 14, 0, 4)];
    [[UIBarButtonItem appearance] setBackButtonBackgroundImage:backButton forState:UIControlStateNormal
                                                    barMetrics:UIBarMetricsDefault];
    
    [[UINavigationBar appearance] setTitleTextAttributes:
     [NSDictionary dictionaryWithObjectsAndKeys:
      [UIColor colorWithRed:255.0/255.0 green:255.0/255.0 blue:255.0/255.0 alpha:1.0],
      UITextAttributeTextColor,
      [UIColor colorWithRed:0.0 green:0.0 blue:0.0 alpha:0.8],
      UITextAttributeTextShadowColor,
      [NSValue valueWithUIOffset:UIOffsetMake(0, -1)],
      UITextAttributeTextShadowOffset,
      nil]];
    
    
    UIImage *barItemImage = [[UIImage imageNamed:@"ipad-menubar-button.png"] resizableImageWithCapInsets:UIEdgeInsetsMake(0, 5, 0, 5)];
    [[UIBarButtonItem appearance] setBackgroundImage:barItemImage forState:UIControlStateNormal barMetrics:UIBarMetricsDefault];
   */ 
}


-(void)iPadInit
{
    
}

#pragma mark - Facebook methods
- (BOOL)application:(UIApplication *)application
            openURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication annotation:(id)annotation
{
    return [FBSession.activeSession handleOpenURL:url];
}

/*- (void) closeSession {
 [self.session closeAndClearTokenInformation];
 }*/

- (void)updateFacebookToken:(NSString *)accessToken expiresAt:(NSDate *)expiresAt
{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setObject:accessToken forKey:@"FBAccessTokenKey"];
    [defaults setObject:expiresAt forKey:@"FBExpirationDateKey"];
    [defaults synchronize];
}

- (void)fbSessionInvalidated
{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults removeObjectForKey:@"FBAccessTokenKey"];
    [defaults removeObjectForKey:@"FBExpirationDateKey"];
    [defaults synchronize];
}

- (void)fbDidExtendToken:(NSString*)accessToken
               expiresAt:(NSDate*)expiresAt
{
    [self updateFacebookToken:accessToken expiresAt:expiresAt];
}

- (void)fbDidNotLogin:(BOOL)cancelled
{
    NSLog(@"User did not log in to Facebook");
}


- (void)fbDidLogout
{
    NSLog(@"User did log out from Facebook");
}

/*- (FBSession *)createNewSession
{
    NSArray *permissions = [[NSArray alloc] initWithObjects:
                            @"user_likes",
                            @"read_stream",
                            nil];
    self.session = [[FBSession alloc] initWithPermissions:permissions];
    return self.session;
}

- (void)sessionStateChanged:(FBSession *)session
                      state:(FBSessionState) state
                      error:(NSError *)error
{
    switch (state) {
        case FBSessionStateOpen:
            if (!error) {
                // We have a valid session
                NSLog(@"User session found");
            }
            break;
        case FBSessionStateClosed:
        case FBSessionStateClosedLoginFailed:
            [session closeAndClearTokenInformation];
            self.session = nil;
            [self createNewSession];
            break;
        default:
            break;
    }
    
    [[NSNotificationCenter defaultCenter]
     postNotificationName:FBSessionStateChangedNotification
     object:session];
    
    if (error) {
        UIAlertView *alertView = [[UIAlertView alloc]
                                  initWithTitle:@"Error"
                                  message:error.localizedDescription
                                  delegate:nil
                                  cancelButtonTitle:@"OK"
                                  otherButtonTitles:nil];
        [alertView show];
    }
}

- (void) openSessionCheckCache:(BOOL)check {
    // Create a new session object
    if (!self.session.isOpen) {
        [self createNewSession];
    }
    // Open the session in two scenarios:
    // - When we are not loading from the cache, e.g. when a login
    //   button is clicked.
    // - When we are checking cache and have an available token,
    //   e.g. when we need to show a logged vs. logged out display.
    if (!check ||
        (self.session.state == FBSessionStateCreatedTokenLoaded)) {
        [self.session openWithCompletionHandler:
         ^(FBSession *session, FBSessionState state, NSError *error) {
             [self sessionStateChanged:session state:state error:error];
         }];
    }
}*/

							
- (void)applicationWillResignActive:(UIApplication *)application
{
    [[LocalyticsSession shared] close];
    [[LocalyticsSession shared] upload];
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    [[NSNotificationCenter defaultCenter] postNotificationName:@"didEnterBackground" object:self];
    
    UIApplication*    app = [UIApplication sharedApplication];
    
    // Request permission to run in the background. Provide an
    // expiration handler in case the task runs long.
    NSAssert(bgTask == UIBackgroundTaskInvalid, nil);
    
    bgTask = [app beginBackgroundTaskWithExpirationHandler:^{
        // Synchronize the cleanup call on the main thread in case
        // the task actually finishes at around the same time.
        dispatch_async(dispatch_get_main_queue(), ^{
            
            if (bgTask != UIBackgroundTaskInvalid)
            {
                [app endBackgroundTask:bgTask];
                bgTask = UIBackgroundTaskInvalid;
            }
        });
    }];
    
    // Start the long-running task and return immediately.
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        
        NSLog(@"App status: applicationDidEnterBackground");
        // Synchronize the cleanup call on the main thread in case
        // the expiration handler is fired at the same time.
        dispatch_async(dispatch_get_main_queue(), ^{
            if (bgTask != UIBackgroundTaskInvalid)
            {
                [app endBackgroundTask:bgTask];
                bgTask = UIBackgroundTaskInvalid;
            }
        });
    });
    NSLog(@"backgroundTimeRemaining: %f", [[UIApplication sharedApplication] backgroundTimeRemaining]);
    
    [[LocalyticsSession sharedLocalyticsSession] close];
    [[LocalyticsSession sharedLocalyticsSession] upload];
}


- (void)applicationWillEnterForeground:(UIApplication *)application
{
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
    
    [Appirater appEnteredForeground:YES];
    [[LocalyticsSession sharedLocalyticsSession] resume];
    [[LocalyticsSession sharedLocalyticsSession] upload];

}


- (void)applicationDidBecomeActive:(UIApplication *)application
{
    [FBSession.activeSession handleDidBecomeActive];
    [[LocalyticsSession sharedLocalyticsSession] close];
    [[LocalyticsSession sharedLocalyticsSession] upload];
    //[self clearNotifications];
    PFInstallation *currentInstallation = [PFInstallation currentInstallation];
    if (currentInstallation.badge != 0) {
        currentInstallation.badge = 0;
        [currentInstallation saveEventually];
    }
    
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    [FBSession.activeSession close];
    
    
    [[LocalyticsSession sharedLocalyticsSession] close];
    [[LocalyticsSession sharedLocalyticsSession] upload];
    
}


#pragma mark - UIAlertViewDelegate methods
- (void)alertView:(UIAlertView *)alertView didDismissWithButtonIndex:(NSInteger)buttonIndex {
    // Quit the app
    exit(1);
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation {
	if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) {
		return YES;
	}
	
	return toInterfaceOrientation != UIInterfaceOrientationPortraitUpsideDown;
}

-(NSUInteger)supportedInterfaceOrientations{
    return UIInterfaceOrientationMaskAll;
}

-(BOOL)shouldAutorotate{
    return YES;
}

@end
