//
//  PADAppDelegate.m
//  PaylevenApiDemo
//
//  Created by Steffen Römer on 10/8/12.
//  Copyright (c) 2012, 2013 Payleven Holding GmbH. All rights reserved.
//

#import "PADAppDelegate.h"
#import "PaylevenAppApi/PaylevenAppApi.h"

@implementation PADAppDelegate

- (BOOL)application:(UIApplication*)application didFinishLaunchingWithOptions:(NSDictionary*)launchOptions
{
    // in your app add here your credentials provided by payleven
    [[PaylevenAppApi sharedInstance] configure:@"1aaf391975fc4755a9676dec0cff195b" callbackUrlScheme:@"paylevenapidemo"];
    // Override point for customization after application launch.
    return YES;
}

- (void)applicationWillResignActive:(UIApplication*)application
{
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication*)application
{
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication*)application
{
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication*)application
{
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication*)application
{
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

- (BOOL)application:(UIApplication*)application openURL:(NSURL*)url sourceApplication:(NSString*)sourceApplication annotation:(id)annotation
{
    // Called when the application is opened with an url sheme
    [[PaylevenAppApi sharedInstance] handleOpenUrl:url bundleId:sourceApplication];
    return YES;
}

@end