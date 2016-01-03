//
//  Photo.h
//  WeiboRenrenAccess
//
//  Created by Nan Shen on 15/12/10.
//  Copyright (c) 2015年 Nan Shen. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Album;

@interface Photo : NSManagedObject

@property (nonatomic, retain) NSNumber * albumId;
@property (nonatomic, retain) NSNumber * commentCount;
@property (nonatomic, retain) NSString * createTime;
@property (nonatomic, retain) NSString * identify;
@property (nonatomic, retain) NSString * imageUrl;
@property (nonatomic, retain) NSNumber * ownerId;
@property (nonatomic, retain) NSString * photoDescription;
@property (nonatomic, retain) NSNumber * viewCount;
@property (nonatomic, retain) Album *whichAlbum;

@end
