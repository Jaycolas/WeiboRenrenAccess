//
//  Album+Create.h
//  WeiboRenrenAccess
//
//  Created by Nan Shen on 15/12/3.
//  Copyright (c) 2015年 Nan Shen. All rights reserved.
//

#import "Album.h"

@interface Album (Create)

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
inManagedObjectContext: (NSManagedObjectContext *)context;

@end
