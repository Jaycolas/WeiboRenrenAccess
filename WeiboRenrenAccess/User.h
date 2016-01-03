//
//  User.h
//  WeiboRenrenAccess
//
//  Created by Nan Shen on 15/12/10.
//  Copyright (c) 2015年 Nan Shen. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Album;

@interface User : NSManagedObject

@property (nonatomic, retain) NSString * avatar;
@property (nonatomic, retain) NSString * identify;
@property (nonatomic, retain) NSString * name;
@property (nonatomic, retain) NSSet *albums;
@end

@interface User (CoreDataGeneratedAccessors)

- (void)addAlbumsObject:(Album *)value;
- (void)removeAlbumsObject:(Album *)value;
- (void)addAlbums:(NSSet *)values;
- (void)removeAlbums:(NSSet *)values;

@end
