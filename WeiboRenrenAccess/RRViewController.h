//
//  RRViewController.h
//  WeiboRenrenAccess
//
//  Created by Nan Shen on 15/10/11.
//  Copyright (c) 2015年 Nan Shen. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface RRViewController : UIViewController

@property (strong, nonatomic) UINavigationController * RRNavigationController;
@property (strong, nonatomic) NSString * usrId;
@property (strong, nonatomic) NSArray * friendList;
@property (nonatomic, strong) NSManagedObjectContext *managedObjectContext;

@end
