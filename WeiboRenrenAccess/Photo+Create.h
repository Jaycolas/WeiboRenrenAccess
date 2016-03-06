//
//  Photo+Create.h
//  WeiboRenrenAccess
//
//  Created by Nan Shen on 15/12/26.
//  Copyright (c) 2015年 Nan Shen. All rights reserved.
//

#import "Photo.h"

@interface Photo (Create)

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
inManagedObjectContext: (NSManagedObjectContext *)context;

@end
