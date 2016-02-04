//
//  Bnei_BaruchAppDelegate.m
//  Kabbalah
//
//  Created by MexRockstar.
//  Copyright (c) 2012 Bnei Baruch USA. All rights reserved.
//

#import "Bnei_BaruchAppDelegate.h"
#import "Appirater.h"
#import "LocalyticsUtilities.h"
#import "Localytics.h"

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
        
        [self _setupTabBarAppearance];
        
    }
    else
    {
        //[self customizeiPhoneTheme];
        [application setStatusBarHidden:NO];
        [application setStatusBarStyle:UIStatusBarStyleLightContent];
        UINavigationBar *navigationBar = [UINavigationBar appearance];
        [navigationBar setBackgroundImage:[UIImage imageNamed:@"navbar_bg"] forBarMetrics:UIBarMetricsDefault];
        [self _setupTabBarAppearance];
        
        
    }
    
    // call the Appirater class
    [Appirater setAppId:@"550938690"];
    [Appirater setDaysUntilPrompt:7];
    [Appirater setUsesUntilPrompt:5];
    [Appirater setSignificantEventsUntilPrompt:-1];
    [Appirater setTimeBeforeReminding:2];
    [Appirater setDebug:NO];
    [Appirater appLaunched:YES];
    
    
    /////////////Analytics/////////////
    //    [[LocalyticsSession shared] startSession:@"3899ffa1d6146a0cf30c70c-79a8c6ac-c8c3-11e2-0ede-004a77f8b47f"];
    [Localytics autoIntegrate:@"3899ffa1d6146a0cf30c70c-79a8c6ac-c8c3-11e2-0ede-004a77f8b47f" launchOptions:launchOptions];
    
    [_window makeKeyAndVisible];
    return YES;
}


#pragma mark Push notification handling
- (void)application:(UIApplication *)application
didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)newDeviceToken
{
    // Store the deviceToken in the current installation and save it to Parse.
}

- (void)application:(UIApplication *)application
didReceiveRemoteNotification:(NSDictionary *)userInfo {
    
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




#pragma mark Customization

- (void)_setupTabBarAppearance
{
    
    [[UITabBarItem appearance] setTitleTextAttributes:@{NSForegroundColorAttributeName:[UIColor colorWithRed:0.16f green:0.45f blue:0.73f alpha:1.0f]}
                                             forState:UIControlStateNormal];
    
    
    [[UITabBarItem appearance] setTitleTextAttributes:@{NSForegroundColorAttributeName:[UIColor colorWithRed:0.26f green:0.78f blue:0.91f alpha:1.0]}
                                             forState:UIControlStateSelected];
    
    [[UITabBar appearance] setTintColor:[UIColor whiteColor]];
}

- (void)_setupToolBarAppearance
{
    // Toolbar
    UIToolbar *toolbar = [UIToolbar appearance];
    [toolbar setBackgroundImage:[UIImage imageNamed:@"navigation-background"] forToolbarPosition:UIToolbarPositionTop barMetrics:UIBarMetricsDefault];
    [toolbar setBackgroundImage:[UIImage imageNamed:@"toolbar-background"] forToolbarPosition:UIToolbarPositionBottom barMetrics:UIBarMetricsDefault];
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
}


- (void)applicationWillEnterForeground:(UIApplication *)application
{
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
    [Appirater appEnteredForeground:YES];
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
