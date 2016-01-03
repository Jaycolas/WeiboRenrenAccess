//
//  RRViewController.m
//  WeiboRenrenAccess
//
//  Created by Nan Shen on 15/10/11.
//  Copyright (c) 2015年 Nan Shen. All rights reserved.
//

#import "RRViewController.h"
#import "RennSDK/RennSDK.h"
#import "RRTableTableViewController.h"
#import "User+Create.h"
#import "RRDBAvalability.h"


@interface RRViewController () <RennLoginDelegate>

@property (strong, nonatomic) UITableView * renrenTableView;
@property (strong, nonatomic) RRTableTableViewController * RRTableViewController;

@property (weak, nonatomic) IBOutlet UIButton *rrLogInOutBtn;
@property (nonatomic) BOOL isFriendlistGot;

@end

@implementation RRViewController

- (void)awakeFromNib
{
    [[NSNotificationCenter defaultCenter]addObserverForName:RRDBAvailabilityNotification object:nil queue:nil usingBlock:^(NSNotification *note) {
        self.managedObjectContext = note.userInfo[RRDBAvailabilityContext];
    }];
}


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.

    // Do any additional setup after loading the view.
    //    [RennClient initWithAppId:@"168802"
    //                       apiKey:@"e884884ac90c4182a426444db12915bf"
    //                    secretKey:@"094de55dc157411e8a5435c6a7c134c5"];
    //开通了高级api权限
    
    //self.RRNavigationController = [[UINavigationController alloc]initWithRootViewController:self];
    
    [RennClient initWithAppId:@"228525"
                       apiKey:@"1dd8cba4215d4d4ab96a49d3058c1d7f"
                    secretKey:@"48cea4b12f7442c5bff322312ab2c99e"];
    
    
    //不设置则默认使用bearer token
    //[RennClient setTokenType:@"mac"];
    
    //不设置则获取默认权限
    [RennClient setScope:@"read_user_feed read_user_blog read_user_photo read_user_status read_user_album read_user_comment read_user_share publish_blog publish_share send_notification photo_upload status_update create_album publish_comment publish_feed operate_like"];
    
    if ([RennClient isLogin]) {
        //[self.navigationBar.topItem.rightBarButtonItem setTitle:@"注销"];
        NSLog(@"Renren client has already logged in");
        [self.rrLogInOutBtn setTitle:@"LogOut" forState:UIControlStateNormal];
    }
    else {
        NSLog(@"Renren client has not logged in");
        [self.rrLogInOutBtn setTitle:@"LogIn" forState:UIControlStateNormal];
        //[self.navigationBar.topItem.rightBarButtonItem setTitle:@"登录"];
    }
    
    self.isFriendlistGot = NO;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (IBAction)renrenLogin:(id)sender {
    if ([RennClient isLogin]) {
        [RennClient logoutWithDelegate:(id<RennLoginDelegate>)[[UIApplication sharedApplication]delegate]];
    } else {
        [RennClient loginWithDelegate:self];
    }
    
}

- (RRTableTableViewController *)RRTableViewController
{
    if (!_RRTableViewController) {
        _RRTableViewController = [[RRTableTableViewController alloc]init];
    }
    
    return _RRTableViewController;
}


- (void)rennLoginSuccess
{
    NSLog(@"Log in success");
    [self.rrLogInOutBtn setTitle:@"LogOut" forState:UIControlStateNormal];
    
    [self.RRNavigationController pushViewController:self.RRTableViewController animated:YES];
    
    self.usrId= [RennClient uid];
    
    if ([RennClient isLogin]) {
        
        NSLog(@"Getting user's friend list now");
        ListFriendParam *param = [[ListFriendParam alloc] init];
        param.userId = [RennClient uid];
        [RennClient sendAsynRequest:param delegate:self];
        
        
        
    } else {
        NSLog(@"It's not logged in");
    }
}

- (void)rennLogoutSuccess
{
    NSLog(@"Log out success");
    //[self.rrLogInOutBtn setTitle:@"LogOut" forState:UIControlStateNormal];
}

- (void)rennService:(RennService *)service requestSuccessWithResponse:(id)response
{
    //NSLog(@"requestSuccessWithResponse:%@", [[SBJSON new] stringWithObject:response error:nil]);
    //AppLog(@"请求成功:%@", service.type);
    //NSError * error = nil;
    
    //NSData * jsonData = [NSData alloc]initwi
    
    //NSArray * friendListJson = [NSJSONSerialization JSONObjectWithData:response options:NSJSONReadingAllowFragments error:&error];
    
    static NSInteger friendIndex = 0;
    NSString * usrId = nil;
    
    NSLog(@"Current service type is %@", service.type);
    
    if ([service.type isEqualToString:@"ListFriend"]) {
        
        self.friendList = (NSArray *)response;
        NSInteger friendCount = [self.friendList count];
        
        NSLog(@"Friend count is %d", friendCount);
        NSLog(@"Friend list are: %@", self.friendList);
        
        NSInteger friendsNumber = [self.friendList count];
        
        if (friendsNumber) {
            self.isFriendlistGot = YES;
        }
        else
        {
            NSLog(@"Friend list is empty");
            assert(0);
        }

        if (friendIndex!=0) {
            NSLog(@"Friend index needs to be 0 when firstly we get the friend list");
            assert(0);
        }
        
        NSRange range = {friendIndex*50, 50};
        NSArray * usrIdsSub = [self.friendList subarrayWithRange:range];
        BatchUserParam *param = [[BatchUserParam alloc] init];
        param.userIds = usrIdsSub;
        [RennClient sendAsynRequest:param delegate:self];
        
    }
    else if ([service.type isEqualToString:@"GetUser"])
    {
        
        NSDictionary * friendsInfo = (NSDictionary *)response;
        
        NSString * name = [friendsInfo valueForKey:@"name"];
        NSLog(@"Got friend info for %@", name);
        NSString * idx_string = [friendsInfo valueForKey:@"id"];
        NSArray * avatar = [friendsInfo valueForKey:@"avatar"];
        
        /*The first object is the tiny portrait*/
        NSDictionary * tinyAvatar = [avatar firstObject];
        NSString * imageUrl = [tinyAvatar valueForKey:@"url"];
    
        
        [User userWithId:idx_string friendName:name avatar:imageUrl inManagedObjectContext:self.managedObjectContext];
        
        /*After loading the database, send the get friends request again*/
        friendIndex++;
        usrId = [self.friendList objectAtIndex:friendIndex];
        
        if (usrId!=nil) {
            NSLog(@"Getting user's friend info for %@", usrId);
            GetUserParam *param = [[GetUserParam alloc] init];
            param.userId = usrId;
            [RennClient sendAsynRequest:param delegate:self];
        }
        else
        {
            /*UsrId == nil, which means it reaches the end of the friend list*/
            /*Push the segue to RRTableViewController*/
            [self performSegueWithIdentifier:@"RRTblViewSegue" sender:self];
        }
    }
    else if ([service.type isEqualToString:@"BatchUser"])
    {
        NSLog(@"Having batchUser command");
        NSArray * friendInfoList = (NSArray *)response;
        NSLog(@"Got %d friends' info", [friendInfoList count]);
        
        for (NSDictionary * friendInfo in friendInfoList) {
            
            NSString * name = [friendInfo valueForKey:@"name"];
            NSLog(@"Got friend info for %@", name);

            //NSInteger idx = (NSInteger)[friendInfo valueForKey:@"id"];
            NSDecimalNumber * idxDecimal = [friendInfo valueForKey:@"id"];
            
            NSString * idx_string = [idxDecimal stringValue];
            
            //NSLog(@"friend's id is %d", idx);
            NSLog(@"friend's id string is %@", idx_string);
            
            NSArray * avatar = [friendInfo valueForKey:@"avatar"];
            
            /*The first object is the tiny portrait*/
            NSDictionary * tinyAvatar = [avatar firstObject];
            NSString * imageUrl = [tinyAvatar valueForKey:@"url"];
            
            //NSNumber * idx_nsn = [NSNumber numberWithInteger:idx ];
            
            [User userWithId:idx_string friendName:name avatar:imageUrl inManagedObjectContext:self.managedObjectContext];
        }
        
        friendIndex++;
        

        NSInteger length;
        NSInteger friendCount = [self.friendList count];
        
        if (friendIndex*50 > friendCount) {
            NSLog(@"Has handled all the friends, need to return");
            return;
        }
        
        if ((friendIndex+1)*50 >= friendCount) {
            length = friendCount - friendIndex*50;
        } else {
            length = 50;
        }
        
        NSRange range = {friendIndex*50, length};

        NSArray * usrIdsSub = [self.friendList subarrayWithRange:range];
        BatchUserParam *param = [[BatchUserParam alloc] init];
        param.userIds = usrIdsSub;
        [RennClient sendAsynRequest:param delegate:self];
        
        
        
        
    }
}


- (void)rennService:(RennService *)service requestFailWithError:(NSError*)error
{
    NSLog(@"requestFailWithError:%@", [error description]);
    NSString *domain = [error domain];
    NSString *code = [[error userInfo] objectForKey:@"code"];
    NSLog(@"requestFailWithError:Error Domain = %@, Error Code = %@", domain, code);
    //AppLog(@"请求失败: %@", domain);
}




#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:@"RRTblViewSegue"]) {
        if ([segue.destinationViewController isKindOfClass:[RRTableTableViewController class]]) {
            RRTableTableViewController * rtvc = (RRTableTableViewController *)segue.destinationViewController;
            rtvc.friendList = self.friendList;
            rtvc.managedObjectContext = self.managedObjectContext;
        }
    }
}

- (BOOL)shouldPerformSegueWithIdentifier:(NSString *)identifier
                                  sender:(id)sender
{
    /*
    if ([identifier isEqualToString:@"RRTblViewSegue"]) {
        if (self.isFriendlistGot) {
            
            //Only perform the segue if friend list is got
            return YES;
        }
        else
        {
            return NO;
        }
    }
    */
    return YES;
}


@end
