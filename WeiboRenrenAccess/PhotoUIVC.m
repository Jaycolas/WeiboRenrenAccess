//
//  PhotoUIVC.m
//  WeiboRenrenAccess
//
//  Created by Nan Shen on 16/1/18.
//  Copyright (c) 2016年 Nan Shen. All rights reserved.
//

#import "PhotoUIVC.h"

@interface PhotoUIVC ()
@property (strong, nonatomic) IBOutlet UIImageView *photoUIIV;
@property (strong, nonatomic) IBOutlet UIActivityIndicatorView *photoLoadingUIAI;

@end

@implementation PhotoUIVC

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    if (self.selectedPhoto!=nil) {
        
        [self.photoLoadingUIAI startAnimating];
        
        NSOperationQueue * imageLoadingQ = [[NSOperationQueue alloc]init];
        
        NSBlockOperation * imageLoadingBlock = [NSBlockOperation blockOperationWithBlock:^{
            NSString * imageUrl = self.selectedPhoto.imageLargeUrl;
            
            NSData * imageData = [NSData dataWithContentsOfURL:[NSURL URLWithString:imageUrl]];
            UIImage * image = [UIImage imageWithData:imageData];
            
            NSOperationQueue * mainQ = [NSOperationQueue mainQueue];
            [mainQ addOperation:[NSBlockOperation blockOperationWithBlock:^{
                        [self.photoUIIV setImage:image];
            }]];
        }
        ];
        
        [imageLoadingQ addOperation:imageLoadingBlock];

        [self.photoLoadingUIAI stopAnimating];
        
    }
    else
    {
        NSLog(@"This photo has not been loaded in this database!");
    }
}


- (UIImage *)loadImageInBG: (NSString *) imageUrl
{
    NSData * imageData = [NSData dataWithContentsOfURL:[NSURL URLWithString:imageUrl]];
    UIImage * image = [UIImage imageWithData:imageData];
    return image;
}


@end
