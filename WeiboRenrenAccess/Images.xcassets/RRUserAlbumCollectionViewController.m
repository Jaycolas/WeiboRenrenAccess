//
//  RRUserAlbumCollectionViewController.m
//  WeiboRenrenAccess
//
//  Created by Nan Shen on 15/12/2.
//  Copyright (c) 2015年 Nan Shen. All rights reserved.
//

#import "RRUserAlbumCollectionViewController.h"
#import "RRAlbumPhotosCollectionViewController.h"
#import "RRAlbumUICVC.h"

@interface RRUserAlbumCollectionViewController () <UICollectionViewDelegateFlowLayout>

@property (strong, nonatomic) NSArray * albumArray;
@property (strong, nonatomic) UICollectionViewFlowLayout * rrAlbumFlowLayout;

@end

@implementation RRUserAlbumCollectionViewController

static NSString * const reuseIdentifier = @"RRAlbumCell";




- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Uncomment the following line to preserve selection between presentations
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Register cell classes
    [self.collectionView registerClass:[RRAlbumUICVC class] forCellWithReuseIdentifier:reuseIdentifier];
    
    NSLog(@"TEST");
    
    // Do any additional setup after loading the view.
}


//Sort the Album by the created time, will called it every time the view is segued
- (void)rrAlbumDataInit
{
    if ([self.selectedUser.albums count]>0) {
        
        NSSortDescriptor * createTimeSort =[[NSSortDescriptor alloc]initWithKey:@"createTime" ascending:NO];
        
        NSArray * sortDescriptors = [[NSArray alloc]initWithObjects:createTimeSort, nil];
        
        self.albumArray = [self.selectedUser.albums sortedArrayUsingDescriptors:sortDescriptors];
        
        
    } else {
        NSLog(@"No album in current selected user: %@", self.selectedUser.name);
    }

}


//Will call rrAlbumDataInit when the collection view appears
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self rrAlbumDataInit];
    
}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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

    //Currently only 1 senction is needed
    return 1;
}


- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {

    //Return how many album is for current user
    NSInteger albumCount = [self.selectedUser.albums count];
    NSLog(@"Albums count = %d", albumCount);
    return albumCount;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    RRAlbumUICVC *cell = [collectionView dequeueReusableCellWithReuseIdentifier:reuseIdentifier forIndexPath:indexPath];
    
    //Node 0 indicates sections, node 1 indicates
    NSUInteger albumIndex = [indexPath indexAtPosition:1];
    Album * album = [self.albumArray objectAtIndex:albumIndex];
    
    // Configure the cell
    
    //Album picture
    UIImage * albumCover;
    NSData * albumCoverData = [NSData dataWithContentsOfURL:[NSURL URLWithString:album.cover]];
    albumCover = [UIImage imageWithData:albumCoverData];
    [cell.albumCoverImageView setImage:albumCover];
    
    //Album name
    [cell.albumNameLabel setText:album.name];

    
    return cell;
}


#pragma mark <UICollectionViewDelegateFlowLayout>

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    CGSize itemSize;
    
    //Now we split the width into 4
    itemSize.width = SCREEN_WIDTH/2;
    itemSize.height = SCREEN_HEIGHT/3;
    
    return itemSize;
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section
{
    return 10;
}


- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section
{
    return 10;
}


#pragma mark <UICollectionViewDelegate>



- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    //Node 0 indicates sections, node 1 indicates
    NSUInteger albumIndex = [indexPath indexAtPosition:1];
    Album * album = [self.albumArray objectAtIndex:albumIndex];
    self.selectedAlbum = album;
    
    [self performSegueWithIdentifier:@"rrAlbumToPhoto" sender:self.view];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:@"rrAlbumToPhoto"]) {
        RRAlbumPhotosCollectionViewController * dstCVC = segue.destinationViewController;
        dstCVC.selectedUser = self.selectedUser;
        dstCVC.selectedAlbum = self.selectedAlbum;
        dstCVC.managedObjectContext = self.managedObjectContext;
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

@end
