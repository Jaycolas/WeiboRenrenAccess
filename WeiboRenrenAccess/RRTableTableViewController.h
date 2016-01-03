//
//  RRTableTableViewController.h
//  WeiboRenrenAccess
//
//  Created by Nan Shen on 15/10/11.
//  Copyright (c) 2015年 Nan Shen. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CoreDataTableViewController.h"
#import "RRUserAlbumCollectionViewController.h"
#import "User.h"
#import "Album+Create.h"

@interface RRTableTableViewController : CoreDataTableViewController

@property (strong, nonatomic) NSString * usrId;
@property (strong, nonatomic) NSArray * friendList;

@property (nonatomic, strong) NSManagedObjectContext *managedObjectContext;
@property (nonatomic, strong) User * selectedUser;

@end
