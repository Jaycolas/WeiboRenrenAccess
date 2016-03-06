//
//  Photo.h
//  WeiboRenrenAccess
//
//  Created by Nan Shen on 16/1/19.
//  Copyright (c) 2016年 Nan Shen. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Album;

@interface Photo : NSManagedObject

@property (nonatomic, retain) NSDecimalNumber * albumId;
@property (nonatomic, retain) NSDecimalNumber * commentCount;
@property (nonatomic, retain) NSString * createTime;
@property (nonatomic, retain) NSDecimalNumber * identify;
@property (nonatomic, retain) NSString * imageHeadUrl;
@property (nonatomic, retain) NSDecimalNumber * ownerId;
@property (nonatomic, retain) NSString * photoDescription;
@property (nonatomic, retain) NSDecimalNumber * viewCount;
@property (nonatomic, retain) NSString * imageLargeUrl;
@property (nonatomic, retain) NSString * imageMainUrl;
@property (nonatomic, retain) NSString * imageTinyUrl;
@property (nonatomic, retain) Album *whichAlbum;

@end
