//
//  ARTAppDelegate.m
//  ArtfulDeductions
//
//  Created by Kyle Rokita on 6/29/14.
//  Copyright (c) 2014 Artful Deductions LLC. All rights reserved.
//

#import <iAd/iAd.h>

#import "ARTAppDelegate.h"
#import "ARTGame.h"
//#import "ARTIAPHelper.h"
#import "ARTImageHelper.h"
#import "ARTGameSaves.h"
#import "ARTUserInfo.h"
#import "ARTAvatarHelper.h"
#import "MKStoreManager.h"
#import "ARTCardHelper.h"
#import "iRate.h"
#import "ARTConstants.h"
#import "MTReachabilityManager.h"


@interface ARTAppDelegate () <iRateDelegate, UIAlertViewDelegate>

@property (nonatomic, strong) UIAlertView *alertView;

@end

@implementation ARTAppDelegate


+ (void)initialize
{

    [iRate sharedInstance].onlyPromptIfLatestVersion = NO;
    
    //enable preview mode
    [iRate sharedInstance].applicationName = appTitle;
    
    [iRate sharedInstance].daysUntilPrompt = 0;

    
    //once daysuntil is met, it goes with lower of events or uses
    [iRate sharedInstance].eventsUntilPrompt = 1; // wait until 2 topics have been completed
    [iRate sharedInstance].usesUntilPrompt = 5;

    [iRate sharedInstance].previewMode = NO;
}

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    // [MTReachabilityManager sharedManager];

    
    // Override point for customization after application launch.
    //launch card helper before imagehelper
    [ARTCardHelper sharedInstance];

    [ARTImageHelper sharedInstance];
    [ARTGameSaves sharedInstance];
    [ARTUserInfo sharedInstance];
    [ARTAvatarHelper sharedInstance];
    [MKStoreManager sharedManager];
    
    
   /* if ([application respondsToSelector:@selector(isRegisteredForRemoteNotifications)])
    {
        // iOS 8 Notifications
        [application registerUserNotificationSettings:[UIUserNotificationSettings settingsForTypes:(UIUserNotificationTypeSound | UIUserNotificationTypeAlert | UIUserNotificationTypeBadge) categories:nil]];
        
        [application registerForRemoteNotifications];
    }
    else
    {
        // iOS < 8 Notifications
        [application registerForRemoteNotificationTypes:
         (UIRemoteNotificationTypeBadge | UIRemoteNotificationTypeAlert | UIRemoteNotificationTypeSound)];
    }*/

    
    return YES;
}


							
- (void)applicationWillResignActive:(UIApplication *)application
{
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
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

/*- (void)application:(UIApplication*)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData*)deviceToken
{
    NSLog(@"My token is: %@", deviceToken);
    
    [[NSUserDefaults standardUserDefaults] setObject:deviceToken forKey:@"DeviceToken"];
}

- (void)application:(UIApplication*)application didFailToRegisterForRemoteNotificationsWithError:(NSError*)error
{
    NSLog(@"Failed to get token, error: %@", error);
}*/

@end
