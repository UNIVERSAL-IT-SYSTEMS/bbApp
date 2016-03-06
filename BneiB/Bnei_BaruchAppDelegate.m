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
#import "BlogViewController.h"
#import "BlogDetailViewController.h"
#import "KabbalahViewController.h"
#import "KabTvViewController.h"
#import "MediaCollectionViewController.h"
#import "LoginViewController.h"
#import <Fabric/Fabric.h>
#import <Crashlytics/Crashlytics.h>



@interface Bnei_BaruchAppDelegate() <UISplitViewControllerDelegate>

@end

//static const NSInteger kGANDispatchPeriodSec = 10;
@implementation Bnei_BaruchAppDelegate

+ (Bnei_BaruchAppDelegate *)sharedDelegate {
    return (Bnei_BaruchAppDelegate *)[[UIApplication sharedApplication] delegate];
}


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    
    _window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    _window.backgroundColor = [UIColor whiteColor];
    
    [Fabric with:@[[Crashlytics class]]];
    
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
    
    [self setStyle];
    
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) {
        UISplitViewController *splitViewController = [[UISplitViewController alloc] init];
        BlogViewController *rootViewController = [[BlogViewController alloc] init];
        BlogDetailViewController *detailViewController = [[BlogDetailViewController alloc] init];
        UINavigationController *root = [[UINavigationController alloc] initWithRootViewController:rootViewController];
        UINavigationController *detailNav = [[UINavigationController alloc] initWithRootViewController:detailViewController];
        splitViewController.viewControllers = @[root, detailNav];
        
        splitViewController.delegate = self;
        _window.rootViewController = splitViewController;
    } else {
        [self setTabBar];
        _window.rootViewController = _tabBarController;
        [self.tabBarController setSelectedIndex:2];
    }
    
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


#pragma mark - Appearance
- (void)setStyle {
    //Status Bar
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent animated:YES];
    
    //Navigation Bar
    UINavigationBar *navigationBar = [UINavigationBar appearance];
    [navigationBar setTranslucent:NO];
    
    [navigationBar setBarTintColor:[UIColor kabBlueColor]];
    [navigationBar setTintColor: [UIColor whiteColor]];
    [navigationBar setTitleVerticalPositionAdjustment:-1.0f forBarMetrics:UIBarMetricsDefault];
    
    NSShadow *shadow = [NSShadow new];
    [shadow setShadowColor:[UIColor colorWithWhite:0.0f alpha:0.2f]];
    [shadow setShadowOffset:CGSizeMake(0.0f, 1.0f)];
    
    [navigationBar setTitleTextAttributes:@{NSFontAttributeName: [UIFont boldKabInterfaceFontOfSize:20.0f],
                                            NSShadowAttributeName: shadow,
                                            NSForegroundColorAttributeName: [UIColor whiteColor]
                                            }];
    
    [[UIBarButtonItem appearanceWhenContainedIn:[UINavigationBar class], nil] setTintColor:[UIColor whiteColor]];
    
    //Toolbar
    UIToolbar *toolbar = [UIToolbar appearance];
    [toolbar setBarStyle:UIBarStyleBlack];
    [toolbar setBarTintColor:[UIColor kabBlueColor]];
    [toolbar setBackgroundColor:[UIColor kabBlueColor]];
    
    //TabBar
    UITabBar *tabBar = [UITabBar appearance];
    [tabBar setTintColor:[UIColor whiteColor]];
    [tabBar setBarTintColor:[UIColor blackColor]];
    
    UITabBarItem *tabBarItem = [UITabBarItem appearance];
    [tabBarItem setTitleTextAttributes:@{NSForegroundColorAttributeName: [UIColor whiteColor]}
                              forState:UIControlStateSelected];
    
    [tabBarItem setTitleTextAttributes:@{NSForegroundColorAttributeName: [UIColor lightGrayColor]}
                              forState:UIControlStateNormal];
    
    //    [tabBarItem setTitleTextAttributes:@{NSForegroundColorAttributeName: [UIColor whiteColor]} forState:UIControlStateSelected];
}

#pragma mark - TabBar
- (void)setTabBar {
    //Edge Insets
    UIEdgeInsets insets = UIEdgeInsetsMake(7.0f, 0.0f, -7.0f, 0.0f);
    
    //Set Tab bar
    _tabBarController = [[UITabBarController alloc] init];
    [_tabBarController.tabBar setTintColor:[UIColor whiteColor]];
    
    
    //Tab Bar Items
    KabbalahViewController *kabbalah = [[KabbalahViewController alloc] init];
    UINavigationController *kabNav = [[UINavigationController alloc] initWithRootViewController:kabbalah];
    [kabNav.navigationBar setTranslucent:NO];
    [kabbalah.tabBarItem setImage:[[UIImage imageNamed:@"140-gradhat"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal]];
    [kabbalah.tabBarItem setSelectedImage:[[UIImage imageNamed:@"140-gradhat"] imageWithRenderingMode:UIImageRenderingModeAutomatic]];
    [kabbalah.tabBarItem setImageInsets:insets];
    
    BlogViewController *blog = [[BlogViewController alloc] init];
    UINavigationController *blogNav = [[UINavigationController alloc] initWithRootViewController:blog];
    [blogNav.navigationBar setTranslucent:NO];
    [blog.tabBarItem setImage:[[UIImage imageNamed:@"29-heart"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal]];
    [blog.tabBarItem setSelectedImage:[[UIImage imageNamed:@"29-heart"] imageWithRenderingMode:UIImageRenderingModeAutomatic]];
    [blog.tabBarItem setImageInsets:insets];
    
    KabTvViewController *kabTv = [[KabTvViewController alloc] init];
    UINavigationController *kabTvNav = [[UINavigationController alloc] initWithRootViewController:kabTv];
    [kabTvNav.navigationBar setTranslucent:NO];
    [kabTv.tabBarItem setImage:[[UIImage imageNamed:@"107-widescreen"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal]];
    [kabTv.tabBarItem setSelectedImage:[[UIImage imageNamed:@"107-widescreen"] imageWithRenderingMode:UIImageRenderingModeAutomatic]];
    [kabTv.tabBarItem setImageInsets:insets];
    
    MediaCollectionViewController *media = [[MediaCollectionViewController alloc] init];
    UINavigationController *mediaNav = [[UINavigationController alloc] initWithRootViewController:media];
    [mediaNav.navigationBar setTranslucent:NO];
    [media.tabBarItem setImage:[[UIImage imageNamed:@"56-cloud"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal]];
    [media.tabBarItem setSelectedImage:[[UIImage imageNamed:@"56-cloud"] imageWithRenderingMode:UIImageRenderingModeAutomatic]];
    [media.tabBarItem setImageInsets:insets];
    
    LoginViewController *ecView = [[LoginViewController alloc] init];
    UINavigationController *ecNav = [[UINavigationController alloc] initWithRootViewController:ecView];
    [ecNav.navigationBar setTranslucent:NO];
    [ecView.tabBarItem setImage:[[UIImage imageNamed:@"123-id-card"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal]];
    [ecView.tabBarItem setSelectedImage:[[UIImage imageNamed:@"123-id-card"] imageWithRenderingMode:UIImageRenderingModeAutomatic]];
    [ecView.tabBarItem setImageInsets:insets];
    
    self.tabBarController.viewControllers = @[kabNav, blogNav, kabTvNav, mediaNav, ecNav];
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
