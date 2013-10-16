//
//  AppDelegate.m
//  theGoodPush
//
//  Created by Justin Hyland on 8/26/13.
//  Copyright (c) 2013 Justin Hyland. All rights reserved.
//

#import "AppDelegate.h"


#import "Constants.h"


@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    
    if(CONSTANTS_IS_URBAN_AIRSHIP_IN_USE)
    {
        [self useUrbanAirship];
    }
    else
    {//using push notifications with out the Urban airship Libraries
        BOOL isOptedIn = [[NSUserDefaults standardUserDefaults]
                          boolForKey:@"isOptInForNotifications"];
        if(isOptedIn) {
            NSLog(@"registerForRemoteNotificationTypes Called");
            //Do this everytime the user launches the app incase it has changed.
            [[UIApplication sharedApplication] registerForRemoteNotificationTypes:
             (UIRemoteNotificationTypeBadge
              | UIRemoteNotificationTypeSound
              | UIRemoteNotificationTypeAlert)
             ];
        }
    
    }
    
    
    return YES;
}

-(void)useUrbanAirship
{
    // Populate AirshipConfig.plist with your app's info from https://go.urbanairship.com
    // or set runtime properties here.
    UAConfig *config = [UAConfig defaultConfig];
    [config setDevelopmentLogLevel:UALogLevelNone];
    // Call takeOff (which creates the UAirship singleton)
    [UAirship takeOff:config];
    
    [UAPush setDefaultPushEnabledValue:NO];
    // Request a custom set of notification types
    [UAPush shared].notificationTypes = (UIRemoteNotificationTypeBadge |
                                         UIRemoteNotificationTypeSound |
                                         UIRemoteNotificationTypeAlert);
    
    
    BOOL isOptedIn = [[NSUserDefaults standardUserDefaults]
                      boolForKey:@"isOptInForNotifications"];
    if(isOptedIn) {
        // This will trigger the proper registration or de-registration API call from inside the UA library.
        [[UAPush shared] setPushEnabled:YES];
    }
    else {
        [[UAPush shared] setPushEnabled:NO];
    }
    

}

- (void)applicationWillResignActive:(UIApplication *)application
{
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    application.applicationIconBadgeNumber = 0;
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

#pragma mark - NOTIFICATION SERVICE METHODS

- (void)application:(UIApplication *)application
        didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken
{
    //YAY! The device registered with apple!

    NSString *tokenStr = [[[deviceToken description]
                    stringByTrimmingCharactersInSet:[NSCharacterSet characterSetWithCharactersInString:@"<>"]]
                   stringByReplacingOccurrencesOfString:@" "
                   withString:@""];
    NSLog(@"didRegisterForRemoteNotificationsWithDeviceToken: %@", tokenStr);
    
    [[NSUserDefaults standardUserDefaults]
                         setObject:tokenStr
                            forKey:@"currentDeviceToken"];
}

- (void)application:(UIApplication *)application
        didFailToRegisterForRemoteNotificationsWithError:(NSError *)error
{
    //Opps, Probably messed up the provision, cert expired,
    NSLog(@"didFailToRegisterForRemoteNotificationsWithError: %@", error);
}

- (void)application:(UIApplication *)application
        didReceiveRemoteNotification:(NSDictionary *)userInfo
{
    //Here we recieve our push notificaiotn.
    NSLog(@"didReceiveRemoteNotification: %@", userInfo);
    if([application applicationState] == UIApplicationStateInactive)
    {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Settings"
                                                        message:@"You just selected a push notification. Good Job!"
                                                       delegate:nil
                                              cancelButtonTitle:@"OK"
                                              otherButtonTitles:nil];
        [alert show];
    }
    [[NSNotificationCenter defaultCenter]
                postNotificationName:CONSTANTS_NOTIFICATION_NAME_DID_RECEIVE_REMOTE_NOTIFICATION
                              object:userInfo];
}

@end
