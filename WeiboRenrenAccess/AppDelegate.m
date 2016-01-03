//
//  AppDelegate.m
//  WeiboRenrenAccess
//
//  Created by Nan Shen on 15/8/30.
//  Copyright (c) 2015年 Nan Shen. All rights reserved.
//

#import "AppDelegate.h"
#import "RRViewController.h"
#import "WBViewController.h"
#import "RennSDK/RennSDK.h"
#import "RRDBAvalability.h"

@interface AppDelegate ()

@property (strong, nonatomic) UIManagedDocument * rrDocument;
@property (strong, nonatomic) NSURL * rrUrl;

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    
    if ([[NSFileManager defaultManager] fileExistsAtPath:[self.rrUrl path]]) {
        [self.rrDocument openWithCompletionHandler:^(BOOL success) {
            if (success) {
                [self documentIsReady];
            } else {
                NSLog(@"Unable to open URL %@", self.rrUrl);
            }
        }];
    }
    else{
        
        [self.rrDocument saveToURL:self.rrUrl forSaveOperation:UIDocumentSaveForCreating completionHandler:^(BOOL success) {
            if (success) {
                [self documentIsReady];
            } else {
                NSLog(@"Unable to open URL %@", self.rrUrl);
            }
        }];
    }
    
    return YES;
}


- (void) documentIsReady
{
    if (self.rrDocument.documentState == UIDocumentStateNormal) {
        
        NSDictionary *userInfo = self.rrDocument.managedObjectContext ? @{ RRDBAvailabilityContext : self.rrDocument.managedObjectContext  } : nil;
        [[NSNotificationCenter defaultCenter] postNotificationName:RRDBAvailabilityNotification
                                                            object:self
                                                          userInfo:userInfo];
    }
    else
    {
        NSLog(@"Docment state is %d, can not send out database notification", self.rrDocument.documentState);
    }
    
}

- (NSURL *)rrUrl
{
    if (!_rrUrl) {
        NSFileManager * fileManager = [NSFileManager defaultManager];
        NSURL *documentDirectory = [[fileManager URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask] firstObject];
        
        NSString * documentName = @"MyDocument";
        _rrUrl = [documentDirectory URLByAppendingPathComponent:documentName];
    }
    
    return _rrUrl;
}

- (UIManagedDocument *)rrDocument
{
    if (!_rrDocument) {
        //Initialize UIManagedDocument here
         _rrDocument = [[UIManagedDocument alloc]initWithFileURL:self.rrUrl];

    }
    
    return _rrDocument;
}

- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}


#pragma RenRen login delegate




@end
