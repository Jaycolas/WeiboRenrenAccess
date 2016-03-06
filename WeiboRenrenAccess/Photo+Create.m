//
//  Photo+Create.m
//  WeiboRenrenAccess
//
//  Created by Nan Shen on 15/12/26.
//  Copyright (c) 2015年 Nan Shen. All rights reserved.
//

#import "Photo+Create.h"

@implementation Photo (Create)


/*
 
 @property (nonatomic, retain) NSNumber * albumId;
 @property (nonatomic, retain) NSNumber * commentCount;
 @property (nonatomic, retain) NSString * createTime;
 @property (nonatomic, retain) NSString * identify;
 @property (nonatomic, retain) NSString * imageUrl;
 @property (nonatomic, retain) NSNumber * ownerId;
 @property (nonatomic, retain) NSString * photoDescription;
 @property (nonatomic, retain) NSNumber * viewCount;
 @property (nonatomic, retain) Album *whichAlbum;
 
*/


+ (Photo *)photoWithId: (NSDecimalNumber *) albumId
     photoCommentCount: (NSDecimalNumber *) commentCount
       photoCreateTime: (NSString *) createTime
         photoIdentify: (NSDecimalNumber *) identify
     photoHeadImageUrl: (NSString *) imageHeadUrl
    photoLargeImageUrl: (NSString *) imageLargeUrl
     photoTinyImageUrl: (NSString *) imageTinyUrl
     photoMainImageUrl: (NSString *) imageMainUrl
          photoOwnerId: (NSDecimalNumber *) ownerId
      photoDescription: (NSString *) description
        photoViewCount: (NSDecimalNumber *) viewCount
       photoWhichAlbum: (Album *) whichAlbum
inManagedObjectContext: (NSManagedObjectContext *)context
{
    Photo * photo = nil;
    
    if ((albumId!=nil)) {
        
        NSFetchRequest * request = [[NSFetchRequest alloc]initWithEntityName:@"Photo"];
        request.predicate = [NSPredicate predicateWithFormat:@"identify = %@",identify];
        
        NSError * error = nil;
        NSArray * matches = [context executeFetchRequest:request error:&error];
        
        if (!matches || [matches count] > 1) {
            //Handle error
            
        } else if(![matches count]){
            photo = [NSEntityDescription insertNewObjectForEntityForName:@"Photo" inManagedObjectContext:context];
            
            photo.albumId = albumId;
            photo.commentCount = commentCount;
            photo.createTime = createTime;
            photo.identify = identify;
            photo.ownerId = ownerId;
            photo.photoDescription = description;
            photo.viewCount = viewCount;
            photo.whichAlbum = whichAlbum;
            photo.imageHeadUrl = imageHeadUrl;
            photo.imageLargeUrl = imageLargeUrl;
            photo.imageMainUrl = imageMainUrl;
            photo.imageTinyUrl = imageTinyUrl;
            
            
            
        }else{
            
            photo = [matches firstObject];
        }
        
        
    } else {
        //Handle error
    }
    
    return photo;
}


@end
