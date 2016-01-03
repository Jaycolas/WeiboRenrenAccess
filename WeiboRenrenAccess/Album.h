//
//  Album.h
//  WeiboRenrenAccess
//
//  Created by Nan Shen on 15/12/10.
//  Copyright (c) 2015年 Nan Shen. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Photo, User;

@interface Album : NSManagedObject

@property (nonatomic, retain) NSString * accessControl;
@property (nonatomic, retain) NSString * albumDescription;
@property (nonatomic, retain) NSString * cover;
@property (nonatomic, retain) NSString * createTime;
@property (nonatomic, retain) NSString * identify;
@property (nonatomic, retain) NSString * lastModifyTime;
@property (nonatomic, retain) NSString * location;
@property (nonatomic, retain) NSString * name;
@property (nonatomic, retain) NSNumber * photoCount;
@property (nonatomic, retain) NSString * type;
@property (nonatomic, retain) NSSet *photos;
@property (nonatomic, retain) User *whoTook;
@end

@interface Album (CoreDataGeneratedAccessors)

- (void)addPhotosObject:(Photo *)value;
- (void)removePhotosObject:(Photo *)value;
- (void)addPhotos:(NSSet *)values;
- (void)removePhotos:(NSSet *)values;

@end
