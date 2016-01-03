//
//  User+Create.m
//  WeiboRenrenAccess
//
//  Created by Nan Shen on 15/11/5.
//  Copyright (c) 2015年 Nan Shen. All rights reserved.
//

#import "User+Create.h"
#import "RennSDK/RennSDK.h"

@implementation User (Create)

+ (User *)userWithId:(NSString *) identify
          friendName:(NSString *) name
              avatar:(NSString *) avatarUrl
    inManagedObjectContext:(NSManagedObjectContext *)context
{
    User * friend = nil;
    
    if ((identify > 0)&& ([name length]) && ([avatarUrl length]) ){
        NSFetchRequest * request = [NSFetchRequest fetchRequestWithEntityName:@"User"];
        request.predicate = [NSPredicate predicateWithFormat:@"name = %@", name];
        
        NSError * error = nil;
        NSArray * matches = [context executeFetchRequest:request error:&error];
        
        if (!matches || [matches count] > 1) {
            //Handle error
        } else if (![matches count]){
            /*No result found out, need to insert a new element to the database*/
            friend = [NSEntityDescription insertNewObjectForEntityForName:@"User" inManagedObjectContext:context];
            friend.identify = identify;
            friend.name = name;
            friend.avatar = avatarUrl;
            /*First we set the album to nil, we only set the album when we start to load one specific user's data*/
            friend.albums = nil;
            
        }
        else {
            /*found the right match, return the one already in the database*/
            friend = [matches firstObject];
        }
    }
    
    
    
    return friend;

}

/*

+ (Photographer *)photographerWithName:(NSString *)name
                inManagedObjectContext:(NSManagedObjectContext *)context
{
    Photographer *photographer = nil;
    
    if ([name length]) {
        NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:@"Photographer"];
        request.predicate = [NSPredicate predicateWithFormat:@"name = %@", name];
        
        NSError *error;
        NSArray *matches = [context executeFetchRequest:request error:&error];
        
        if (!matches || ([matches count] > 1)) {
            // handle error
        } else if (![matches count]) {
            photographer = [NSEntityDescription insertNewObjectForEntityForName:@"Photographer"
                                                         inManagedObjectContext:context];
            photographer.name = name;
        } else {
            photographer = [matches lastObject];
        }
    }
    
    return photographer;
}*/

@end
