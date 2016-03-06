//
//  AppDelegate.h
//  WeiboRenrenAccess
//
//  Created by Nan Shen on 15/8/30.
//  Copyright (c) 2015年 Nan Shen. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WeiboSDK.h"

@interface AppDelegate : UIResponder <UIApplicationDelegate, WeiboSDKDelegate>

//@property (strong, nonatomic) UINavigationController * RRNavigationController;
//@property (strong, nonatomic) UINavigationController * WBNavigationController;

@property (strong, nonatomic) UIWindow *window;

@property (strong, nonatomic) NSString *wbtoken;
@property (strong, nonatomic) NSString *wbCurrentUserID;
@property (strong, nonatomic) NSString *wbRefreshToken;

@end

