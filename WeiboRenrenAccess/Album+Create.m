//
//  Album+Create.m
//  WeiboRenrenAccess
//
//  Created by Nan Shen on 15/12/3.
//  Copyright (c) 2015年 Nan Shen. All rights reserved.
//

#import "Album+Create.h"

@implementation Album (Create)

+ (Album *)albumWithId: (NSString *) identify
             albumType: (NSString *) type
            albumCover: (NSString *) cover
             albumName: (NSString *) name
      albumDescription: (NSString *) albumDescription
        albumCreatTime: (NSString *) createTime
   albumLastModifyTime: (NSString *) lastModifyTime
         albumLocation: (NSString *) location
       albumPhotoCount: (NSNumber *) photoCount
    albumAccessControl: (NSString *) accessControl
           albumPhotos: (NSSet *) photos
inManagedObjectContext: (NSManagedObjectContext *)context
{
    
    Album * friendAlbum = nil;
    
    if (([identify intValue]>0) && ([name length] > 0)) {
        
        NSFetchRequest * request = [[NSFetchRequest alloc]initWithEntityName:@"Album"];
        request.predicate = [NSPredicate predicateWithFormat:@"name = %@",name];
        
        NSError * error = nil;
        NSArray * matches = [context executeFetchRequest:request error:&error];
    
        if (!matches || [matches count] > 1) {
            //Handle error
            
        } else if(![matches count]){
            friendAlbum = [NSEntityDescription insertNewObjectForEntityForName:@"Album" inManagedObjectContext:context];
            
            friendAlbum.identify = identify;
            friendAlbum.type = type;
            friendAlbum.cover = cover;
            friendAlbum.name = name;
            friendAlbum.albumDescription = albumDescription;
            friendAlbum.createTime = createTime;
            friendAlbum.lastModifyTime = lastModifyTime;
            friendAlbum.location = location;
            friendAlbum.photoCount = photoCount;
            friendAlbum.accessControl = accessControl;
            //photos need to be set when album is expanded
            friendAlbum.photos = nil;
            
        }else{
            
            friendAlbum = [matches firstObject];
        }
        
        
    } else {
        //Handle error
    }
    
    return friendAlbum;
}




/*
@property (nonatomic, retain) NSNumber * id;
@property (nonatomic, retain) NSNumber * type;
@property (nonatomic, retain) NSString * cover;
@property (nonatomic, retain) NSString * name;
@property (nonatomic, retain) NSString * albumDescription;
@property (nonatomic, retain) NSString * createTime;
@property (nonatomic, retain) NSString * lastModifyTime;
@property (nonatomic, retain) NSString * location;
@property (nonatomic, retain) NSNumber * photoCount;
@property (nonatomic, retain) NSNumber * accessControl;
@property (nonatomic, retain) NSSet *photos;


 
+ (User *)userWithId:(NSNumber *) identify
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
            //No result found out, need to insert a new element to the database
            friend = [NSEntityDescription insertNewObjectForEntityForName:@"User" inManagedObjectContext:context];
            friend.id = identify;
            friend.name = name;
            friend.avatar = avatarUrl;
            //First we set the album to nil, we only set the album when we start to load one specific user's data
            friend.albums = nil;
            
        }
        else {
            //found the right match, return the one already in the database
            friend = [matches firstObject];
        }
    }
    
    
    
    return friend;
    
}*/

@end
