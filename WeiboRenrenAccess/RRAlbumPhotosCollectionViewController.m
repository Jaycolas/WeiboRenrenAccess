//
//  RRAlbumPhotosCollectionViewController.m
//  WeiboRenrenAccess
//
//  Created by Nan Shen on 15/12/26.
//  Copyright (c) 2015年 Nan Shen. All rights reserved.
//

#import "RRAlbumPhotosCollectionViewController.h"
#import "RennSDK/RennSDK.h"
#import "Photo+Create.h"
#import "RRPhotoUICVC.h"
#import "PhotoUIVC.h"


@interface RRAlbumPhotosCollectionViewController () <UICollectionViewDelegateFlowLayout>

@property (nonatomic, strong) NSArray * photoArray;
@property (strong, nonatomic) IBOutlet UIActivityIndicatorView *photoLoadingUAI;

@end

@implementation RRAlbumPhotosCollectionViewController

static NSString * const reuseIdentifier = @"RRPhotoCell";

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Uncomment the following line to preserve selection between presentations
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Register cell classes
    [self.collectionView registerClass:[RRPhotoUICVC class] forCellWithReuseIdentifier:reuseIdentifier];
    
    // Do any additional setup after loading the view.
    self.photoLoadingUAI.hidesWhenStopped = YES;
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (void)viewWillAppear:(BOOL)animated
{
    
    [super viewWillAppear:animated];

    ListPhotoParam * param = [[ListPhotoParam alloc] init];
    param.ownerId = self.selectedUser.identify;
    param.albumId = self.selectedAlbum.identify;
    /*To use the maximum pagesize allowed*/
    param.pageSize = 100;
    
    //Do not need it since data init has to happen after getting the response
    //[self rrPhotoDataInit];
    
    NSLog(@"Chosen user is %@, Chosen album is %@", self.selectedUser.name, self.selectedAlbum.name);
    
    [RennClient sendAsynRequest:param delegate:self];
    
    //Start UIActivityIndicator
    [self.photoLoadingUAI startAnimating];
}

//Sort the Album by the created time, will called it every time the view is segued
- (void)rrPhotoDataInit
{
    if ([self.selectedAlbum.photos count]>0) {
        
        NSSortDescriptor * createTimeSort =[[NSSortDescriptor alloc]initWithKey:@"createTime" ascending:NO];
        
        NSArray * sortDescriptors = [[NSArray alloc]initWithObjects:createTimeSort, nil];
        
        //For debug
        NSInteger photoCount = [self.selectedAlbum.photos count];
        NSLog(@"Photo cound in CoreData is %d", photoCount);
        
        self.photoArray = [self.selectedAlbum.photos sortedArrayUsingDescriptors:sortDescriptors];
        
        
    } else {
        NSLog(@"No photo in current selected Album: %@", self.selectedAlbum.name);
    }
    
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

#pragma mark <UICollectionViewDataSource>

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
// Only one section is needed
    return 1;
}


- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    
    NSInteger photoCount = [self.selectedAlbum.photoCount integerValue];
    NSLog(@"Now setting the phont count %d in current section", photoCount);
    return photoCount;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    RRPhotoUICVC *cell = [collectionView dequeueReusableCellWithReuseIdentifier:reuseIdentifier forIndexPath:indexPath];
    
    // Configure the cell
    
    //Node 0 indicates sections, node 1 indicates index inside certain section
    NSInteger index = [indexPath indexAtPosition:1];
    
    Photo * photo = [self.photoArray objectAtIndex:index];
    
    NSOperationQueue * imageLoadingQ = [[NSOperationQueue alloc]init];
    
    NSBlockOperation * imageLoadingBlock = [NSBlockOperation blockOperationWithBlock:^{
        UIImage * photoImage;
        NSData * imageData = [NSData dataWithContentsOfURL:[NSURL URLWithString:photo.imageMainUrl]];
        photoImage = [UIImage imageWithData:imageData];
        
        NSOperationQueue * mainQ = [NSOperationQueue mainQueue];
        [mainQ addOperation:[NSBlockOperation blockOperationWithBlock:^{
                    [cell.photoImageView setImage:photoImage];
        }]];

    }];
    
    [imageLoadingQ addOperation:imageLoadingBlock];

    
    return cell;
}

#pragma mark <UICollectionViewDelegate>


- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    //Node 0 indicates sections, node 1 indicates index inside certain section
    NSInteger index = [indexPath indexAtPosition:1];
    Photo * photo = [self.photoArray objectAtIndex:index];
    self.selectedPhoto = photo;
    [self performSegueWithIdentifier:@"selectPhoto" sender:self];
}

- (void) prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:@"selectPhoto"]) {
        PhotoUIVC * dst = segue.destinationViewController;
        dst.selectedPhoto = self.selectedPhoto;
    }
}


/*
// Uncomment this method to specify if the specified item should be highlighted during tracking
- (BOOL)collectionView:(UICollectionView *)collectionView shouldHighlightItemAtIndexPath:(NSIndexPath *)indexPath {
	return YES;
}
*/

/*
// Uncomment this method to specify if the specified item should be selected
- (BOOL)collectionView:(UICollectionView *)collectionView shouldSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    return YES;
}
*/

/*
// Uncomment these methods to specify if an action menu should be displayed for the specified item, and react to actions performed on the item
- (BOOL)collectionView:(UICollectionView *)collectionView shouldShowMenuForItemAtIndexPath:(NSIndexPath *)indexPath {
	return NO;
}

- (BOOL)collectionView:(UICollectionView *)collectionView canPerformAction:(SEL)action forItemAtIndexPath:(NSIndexPath *)indexPath withSender:(id)sender {
	return NO;
}

- (void)collectionView:(UICollectionView *)collectionView performAction:(SEL)action forItemAtIndexPath:(NSIndexPath *)indexPath withSender:(id)sender {
	
}
*/

#pragma mark <UICollectionViewDelegateFlowLayout>

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    CGSize itemSize;
    
    //Now we split the width into 4
    itemSize.width = SCREEN_WIDTH/2 - 5;
    itemSize.height = SCREEN_HEIGHT/3;
    
    return itemSize;
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section
{
    return 2;
}


- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section
{
    return 2;
}

#pragma Renren delegate

/*
@property (nonatomic, retain) NSNumber * albumId;
@property (nonatomic, retain) NSNumber * commentCount;
@property (nonatomic, retain) NSString * createTime;
@property (nonatomic, retain) NSString * identify;
@property (nonatomic, retain) NSString * imageUrl;
@property (nonatomic, retain) NSNumber * ownerId;
@property (nonatomic, retain) NSString * photoDescription;
@property (nonatomic, retain) NSNumber * viewCount;
@property (nonatomic, retain) Album *whichAlbum;*/

- (void)rennService:(RennService *)service requestSuccessWithResponse:(id)response
{
    
    NSLog(@"Current service type is %@", service.type);
    
    //Stop UI Activity Indicator
    [self.photoLoadingUAI stopAnimating];
    
    //Perform segue when got the album infos
    if ([service.type isEqualToString:@"ListPhoto"]) {
        
        NSArray * photoList = (NSArray *)response;
        
        for (NSDictionary * photo in photoList) {
            
            NSDecimalNumber * albumId = [photo valueForKey:@"albumId"];
            NSString * createTime  = [photo valueForKey:@"createTime"];

            NSDecimalNumber * identify = [photo valueForKey:@"id"];
            
            //Cover has LARGE, MAIN, HEAD, TINY four
            //Index 2 means HEAD type
            NSArray * imageSets = [photo valueForKey:@"images"];

            NSDictionary * largeImage = [imageSets objectAtIndex:0];
            NSString * imageLargeUrl = [largeImage valueForKey:@"url"];
            
            NSDictionary * mainImage = [imageSets objectAtIndex:1];
            NSString * imageMainUrl = [mainImage valueForKey:@"url"];
            
            NSDictionary * headImage = [imageSets objectAtIndex:2];
            NSString * imageHeadUrl = [headImage valueForKey:@"url"];
            
            NSDictionary * tinyImage = [imageSets objectAtIndex:3];
            NSString * imageTinyUrl = [tinyImage valueForKey:@"url"];
            
            NSDecimalNumber * ownerId  = [photo valueForKey:@"ownerId"];
            NSString * photoDescription = [photo valueForKey:@"description"];
            NSDecimalNumber * viewCount = [photo valueForKey:@"viewCount"];
            
            Album * whichAlbum = self.selectedAlbum;

            //Add album into database
            Photo * addedPhoto = [Photo photoWithId:albumId photoCommentCount:viewCount photoCreateTime:createTime photoIdentify:identify photoHeadImageUrl:imageHeadUrl photoLargeImageUrl:imageLargeUrl photoTinyImageUrl:imageTinyUrl photoMainImageUrl:imageMainUrl photoOwnerId:ownerId photoDescription:photoDescription photoViewCount:viewCount photoWhichAlbum:whichAlbum inManagedObjectContext:self.managedObjectContext];
            
            if (addedPhoto!=nil) {
                //Hook up the user and its album
                [self.selectedAlbum addPhotosObject:addedPhoto];
            }
            else{
                //TODO Handle errors here
                NSLog(@"Photo failed to be inserted");
            }
            
            
        }
        
        //Call the photo array initialization right after
        [self rrPhotoDataInit];
        [self.collectionView reloadData];
    }
    
}
@end

