//
//  User+Create.h
//  WeiboRenrenAccess
//
//  Created by Nan Shen on 15/11/5.
//  Copyright (c) 2015年 Nan Shen. All rights reserved.
//

#import "User.h"

@interface User (Create)

+ (User *)userWithId:(NSString *) identify
          friendName:(NSString *) name
              avatar:(NSString *) avatarUrl
inManagedObjectContext:(NSManagedObjectContext *)context;

@end
