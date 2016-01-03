//
//  RRTableTableViewController.m
//  WeiboRenrenAccess
//
//  Created by Nan Shen on 15/10/11.
//  Copyright (c) 2015年 Nan Shen. All rights reserved.
//

#import "RRTableTableViewController.h"
#import "RennSDK/RennSDK.h"
#import "User+Create.h"

@interface RRTableTableViewController ()

@property (strong,nonatomic) NSIndexPath * curIndexPath;


@end

@implementation RRTableTableViewController

/*
- (void)awakeFromNib
{
    [[NSNotificationCenter defaultCenter] addObserverForName:PhotoDatabaseAvailabilityNotification
                                                      object:nil
                                                       queue:nil
                                                  usingBlock:^(NSNotification *note) {
                                                      self.managedObjectContext = note.userInfo[PhotoDatabaseAvailabilityContext];
                                                  }];
}
*/

- (void)setManagedObjectContext:(NSManagedObjectContext *)managedObjectContext
{
    _managedObjectContext = managedObjectContext;
    
    NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:@"User"];
    request.predicate = nil;
    request.sortDescriptors = @[[NSSortDescriptor sortDescriptorWithKey:@"name"
                                                              ascending:YES
                                                               selector:@selector(localizedStandardCompare:)]];
    
    
    
    self.fetchedResultsController = [[NSFetchedResultsController alloc] initWithFetchRequest:request
                                                                        managedObjectContext:managedObjectContext
                                                                          sectionNameKeyPath:nil
                                                                                   cacheName:nil];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [self.tableView dequeueReusableCellWithIdentifier:@"User Cell"];
    
    User * user = [self.fetchedResultsController objectAtIndexPath:indexPath];
    
    
    cell.textLabel.text = user.name;
    cell.detailTextLabel.text = user.identify;
    
    UIImage * tinyAvatar;
    NSData * tinyAvatarData = [NSData dataWithContentsOfURL:[NSURL URLWithString:user.avatar]];
    tinyAvatar = [UIImage imageWithData:tinyAvatarData];
    
    [cell.imageView setImage:tinyAvatar];
    
    return cell;
}

- (void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    self.curIndexPath = indexPath;
    self.selectedUser = [self.fetchedResultsController objectAtIndexPath:indexPath];
    
    ListAlbumParam * param = [[ListAlbumParam alloc] init];
    param.ownerId = self.selectedUser.identify;
    
    NSLog(@"Chosen user is %@", param.ownerId);
    
    [RennClient sendAsynRequest:param delegate:self];
    
    
    

}

- (BOOL) shouldPerformSegueWithIdentifier:(NSString *)identifier sender:(id)sender
{
    if ([identifier isEqualToString:@"rrUserToAlbum"]) {
        return NO;
    }
    
    return YES;
}


- (void) prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:@"rrUserToAlbum"]) {
        
        //Pass the current chosen table index to the album collection view controller
        RRUserAlbumCollectionViewController * dst = segue.destinationViewController;
        dst.indexPath = self.curIndexPath;
        dst.selectedUser = self.selectedUser;
        dst.managedObjectContext = self.managedObjectContext;
        
    }
}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source




/*JSON struct for each user*/
/*

 vatar =     (
 {
 size = TINY;
 url = "http://hdn.xnimg.cn/photos/hdn411/20090718/2125/tiny_f3R3_4610g204234.jpg";
 },
 {
 size = HEAD;
 url = "http://hdn.xnimg.cn/photos/hdn411/20090718/2125/head_JEM9_4560d204234.jpg";
 },
 {
 size = MAIN;
 url = "http://hdn.xnimg.cn/photos/hdn411/20090718/2125/main_kUEQ_4560d204234.jpg";
 },
 {
 size = LARGE;
 url = "http://hdn.xnimg.cn/photos/hdn411/20090718/2125/large_QSDX_4586e204234.jpg";
 }
 );
 basicInformation =     {
 birthday = "1984-7-23";
 homeTown =         {
 city = "\U6210\U90fd\U5e02";
 province = "\U56db\U5ddd";
 };
 sex = MALE;
 };
 education =     (
 {
 department = "\U6570\U5b66\U79d1\U5b66\U5b66\U9662";
 educationBackground = COLLEGE;
 name = "\U5317\U4eac\U5e08\U8303\U5927\U5b66";
 year = 2003;
 },
 {
 department = "<null>";
 educationBackground = HIGHSCHOOL;
 name = "\U56db\U5ddd\U7701\U6210\U90fd\U5e02\U897f\U5317\U4e2d\U5b66";
 year = 2000;
 },
 {
 department = "<null>";
 educationBackground = JUNIOR;
 name = "\U56db\U5ddd\U7701\U6210\U90fd\U5e02\U897f\U5317\U4e2d\U5b66";
 year = 1997;
 },
 {
 department = "<null>";
 educationBackground = PRIMARY;
 name = "\U6210\U90fd\U5e02\U5149\U534e\U5c0f\U5b66";
 year = 1991;
 }
 );
 emotionalState = "<null>";
 id = 42713504;
 like =     (
 {
 catagory = INTEREST;
 name = "\U5403\U706b\U9505, \U5403\U7c73\U7ebf, \U5403\U4e32\U4e32\U513f, \U5403\U70e7\U70e4, \U5403\U5154\U513f\U8111\U58f3, \U5403\U521a\U51fa\U9505\U7684\U5364\U732a\U8e44\U5b50, \U5403\U8fd8\U6ca1\U957f\U9971\U6ee1\U7684\U5ae9\U7389\U7c73";
 },
 {
 catagory = MUSIC;
 name = "heal the world, my love, seasons in the sun, \U5b89\U9759";
 },
 {
 catagory = BOOK;
 name = "\U9ed1\U6697\U7cbe\U7075\U4e09\U6b65\U66f2, \U9f99\U65cf, \U4e5d\U5dde\U7cfb\U5217, \U91d1\U5eb8\U5168\U96c6, \U8bdb\U4ed9\U7cfb\U5217, \U5218\U6148\U6b23\U7684\U79d1\U5e7b, \U674e\U5927\U773c\U7684\U5c0f\U8bf4, \U66f9\U6587\U8f69\U7684\U5c0f\U8bf4";
 },
 {
 catagory = MOVIE;
 name = "\U8096\U7533\U514b\U7684\U6551\U8d4e";
 },
 {
 catagory = GAME;
 name = "\U661f\U9645\U4e89\U9738, \U9b54\U517d\U4e89\U9738, \U82f1\U96c4\U65e0\U654cIII, \U82f1\U96c4\U4f20\U8bf4\U7cfb\U5217, \U541e\U98df\U5929\U5730II, \U5927\U822a\U6d774";
 },
 {
 catagory = CARTOON;
 name = "\U4ea4\U54cd\U60c5\U4eba\U68a6, \U68cb\U9b42";
 },
 {
 catagory = SPORT;
 name = "\U6392\U7403, dota";
 }
 );
 name = "\U738b\U594b\U9645";
 star = 1;
 work = "<null>";
 
*/




/*
+ (User *)userWithId:(NSNumber *) identify
          friendName:(NSString *) name
              avatar:(NSString *) avatarUrl*/

- (void)rennService:(RennService *)service requestSuccessWithResponse:(id)response
{

    
    //NSArray * friendListJson = [NSJSONSerialization JSONObjectWithData:response options:NSJSONReadingAllowFragments error:&error];
    
    NSLog(@"Current service type is %@", service.type);
    
    //Perform segue when got the album infos
    if ([service.type isEqualToString:@"ListAlbum"]) {
        
        NSArray * albumList = (NSArray *)response;
        for (NSDictionary * album in albumList) {
            
            NSDecimalNumber * identify = [album valueForKey:@"id"];
            NSString * identifyStr = [identify stringValue];
            NSString * type  = [album valueForKey:@"type"];
            //Cover has LARGE, MAIN, HEAD, TINY four
            NSArray * coverSet = [album valueForKey:@"cover"];
            //Index 2 means HEAD type
            NSDictionary * headCover = [coverSet objectAtIndex:1];
            NSString * cover = [headCover valueForKey:@"url"];
            NSString * name  = [album valueForKey:@"name"];
            NSString * albumDescription = [album valueForKey:@"albumDescription"];
            NSString * createTime = [album valueForKey:@"createTime"];
            NSString * lastModifyTime = [album valueForKey:@"lastModifyTime"];
            NSString * location = [album valueForKey:@"location"];
            NSNumber * photoCount = [album valueForKey:@"photoCount"];
            NSString * accessControl = [album valueForKey:@"accessControl"];
            
            //Add album into database
            Album * addedAlbum = [Album albumWithId:identifyStr albumType:type albumCover:cover albumName:name albumDescription:albumDescription albumCreatTime:createTime albumLastModifyTime:lastModifyTime albumLocation:location albumPhotoCount:photoCount albumAccessControl:accessControl albumPhotos:nil inManagedObjectContext:self.managedObjectContext];
            
            
            if (addedAlbum!=nil) {
                
                //Hook up the user and its album
                [self.selectedUser addAlbumsObject:addedAlbum];
                addedAlbum.whoTook = self.selectedUser;
            }
            else{
                //TODO Handle errors here
            }
            
            
        }
    }
    
    [self performSegueWithIdentifier:@"rrUserToAlbum" sender:self.view];
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
@property (nonatomic, retain) NSSet *photos;*/

- (void)rennService:(RennService *)service requestFailWithError:(NSError*)error
{
    NSLog(@"requestFailWithError:%@", [error description]);
    NSString *domain = [error domain];
    NSString *code = [[error userInfo] objectForKey:@"code"];
    NSLog(@"requestFailWithError:Error Domain = %@, Error Code = %@", domain, code);
    //AppLog(@"请求失败: %@", domain);
}


/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
