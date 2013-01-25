//
//  AppDelegate.m
//  KnessetTrivia
//
//  Created by Stav Ashuri on 4/1/12.
//   
//

#import "AppDelegate.h"
#import <FacebookSDK/FacebookSDK.h>

#import "AboutViewController.h"
#import "ImageTriviaViewController.h"
#import "RightWrongTriviaViewController.h"
#import "DataManager.h"
#import "ScoreManager.h"
#import "GeneralTriviaViewController.h"
#import "GoogleAnalyticsManager.h"
#import "GoogleAnalyticsLogger.h"
#import "SoundEngine.h"

@implementation AppDelegate

@synthesize window = _window;
@synthesize tabBarController = _tabBarController;
@synthesize gameTimer = _gameTimer;

- (void)dealloc
{
    self.gameTimer = nil;
    [_window release];
    [_tabBarController release];
    [super dealloc];
}

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleBlackOpaque];
    [[GoogleAnalyticsManager sharedGoogleAnalyticsManager] setAnalyticsTrackingNumber:kKnessetTriviaGoogleAnalyticsTrackingNumber];
    
    self.window = [[[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]] autorelease];
    // Override point for customization after application launch.
    UIViewController *viewController1 = [[[GeneralTriviaViewController alloc] init] autorelease];
    UIViewController *viewController2 = [[[AboutViewController alloc] initWithNibName:@"AboutViewController" bundle:nil] autorelease];
    self.tabBarController = [[[UITabBarController alloc] init] autorelease];
    self.tabBarController.viewControllers = [NSArray arrayWithObjects:viewController1, viewController2, nil];
    self.window.rootViewController = self.tabBarController;
    
    [[DataManager sharedManager] initializeMembers];
    [[DataManager sharedManager] initializeParties];
    [ScoreManager sharedManager];
    [SoundEngine sharedSoundEngine];
    [self.window makeKeyAndVisible];
    
    [self initGameTimer];
    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application
{    
    [self logSecondsElapsed];
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    [self initGameTimer];
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    [FBSession.activeSession handleDidBecomeActive];
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    [FBSession.activeSession close];
    [self logSecondsElapsed];
    [self cleanTempDirectory];
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

/*
// Optional UITabBarControllerDelegate method.
- (void)tabBarController:(UITabBarController *)tabBarController didSelectViewController:(UIViewController *)viewController
{
}
*/

/*
// Optional UITabBarControllerDelegate method.
- (void)tabBarController:(UITabBarController *)tabBarController didEndCustomizingViewControllers:(NSArray *)viewControllers changed:(BOOL)changed
{
}
*/

#pragma mark - Cache dump

- (void) cleanTempDirectory {
    NSArray *filesToDelete = [[NSFileManager defaultManager] contentsOfDirectoryAtPath:NSTemporaryDirectory() error:nil];
    for (NSString *filePath in filesToDelete) {
        [[NSFileManager defaultManager] removeItemAtPath:[NSString stringWithFormat:@"%@/%@",NSTemporaryDirectory(),filePath] error:nil];
    }
}

#pragma mark - Game Timer
- (void)initGameTimer {
    secondsElapsed = 0;
    self.gameTimer = [NSTimer timerWithTimeInterval:1.0 target:self selector:@selector(incrementSecondsElapsed) userInfo:nil repeats:YES];
    [[NSRunLoop currentRunLoop] addTimer:self.gameTimer forMode:NSDefaultRunLoopMode];
    [self.gameTimer fire];

}
- (void) incrementSecondsElapsed {
    secondsElapsed++;
}

- (void) logSecondsElapsed {
    if (secondsElapsed > 0) {
        [[GoogleAnalyticsLogger sharedLogger] logSecondsSpentInApplication:secondsElapsed];
        secondsElapsed = 0;
    }
    [self.gameTimer invalidate];
}

#pragma mark - URL scheme handling

/*
 * If we have a valid session at the time of openURL call, we handle
 * Facebook transitions by passing the url argument to handleOpenURL
 */
- (BOOL)application:(UIApplication *)application
            openURL:(NSURL *)url
  sourceApplication:(NSString *)sourceApplication
         annotation:(id)annotation {
    // attempt to extract a token from the url
    return [FBSession.activeSession handleOpenURL:url];
}

@end
