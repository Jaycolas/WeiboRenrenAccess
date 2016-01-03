//
//  RRAlbumPhotosCollectionViewController.h
//  WeiboRenrenAccess
//
//  Created by Nan Shen on 15/12/26.
//  Copyright (c) 2015年 Nan Shen. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "User.h"
#import "Album.h"

@interface RRAlbumPhotosCollectionViewController : UICollectionViewController

@property (strong, nonatomic) NSIndexPath * indexPath;
@property (strong, nonatomic) User * selectedUser;
@property (strong, nonatomic) Album * selectedAlbum;
@property (nonatomic, strong) NSManagedObjectContext *managedObjectContext;


@end
