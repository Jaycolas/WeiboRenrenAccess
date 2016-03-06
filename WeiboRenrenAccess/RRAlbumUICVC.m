//
//  RRAlbumUICVC.m
//  WeiboRenrenAccess
//
//  Created by Nan Shen on 15/12/9.
//  Copyright (c) 2015年 Nan Shen. All rights reserved.
//

#import "RRAlbumUICVC.h"


@interface RRAlbumUICVC ()



@end


@implementation RRAlbumUICVC


#define IMAGE_PROPORTION (0.8)



- (UIImageView *)albumCoverImageView
{
    if (!_albumCoverImageView) {
        
        CGRect contentFrame = self.contentView.frame;
        
        CGRect albumCoverFrame = CGRectMake(contentFrame.origin.x, contentFrame.origin.y, contentFrame.size.width, contentFrame.size.height*(IMAGE_PROPORTION));
        
        _albumCoverImageView = [[UIImageView alloc]initWithFrame:albumCoverFrame];
        [_albumCoverImageView setImage:[UIImage imageNamed:@"imageAbsent"]];
        
        [self.contentView addSubview:_albumCoverImageView];
        
        
        _albumCoverImageView.contentMode = UIViewContentModeScaleAspectFit;
        
    }
    
    return _albumCoverImageView;
}


- (UILabel *)albumNameLabel
{
    if (!_albumNameLabel) {
        
        CGRect contentFrame = self.contentView.frame;
        
        CGRect labelFrame = CGRectMake(contentFrame.origin.x, contentFrame.size.height*IMAGE_PROPORTION+ contentFrame.origin.y, contentFrame.size.width, contentFrame.size.height*(1-IMAGE_PROPORTION));
        
        _albumNameLabel = [[UILabel alloc]initWithFrame:labelFrame];
        [_albumNameLabel setTextColor:[UIColor whiteColor]];
        
        [_albumNameLabel setText:@"N/A"];
        [_albumNameLabel setTextColor:[UIColor blackColor]];
        [self.contentView addSubview:_albumNameLabel];
    }
    
    return _albumNameLabel;
}

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    /*
    NSArray * arrayOfViews = [[NSBundle mainBundle] loadNibNamed:@"RRAlbumUICVCView" owner:self options:nil];
    
    //Nothing found out in the nib
    if ([arrayOfViews count]<1) {
        NSLog(@"Nothing found out int the nib");
        return nil;
    }
    
    if (![[arrayOfViews firstObject] isKindOfClass:[UICollectionViewCell class]]) {
        NSLog(@"Nib is not UICVC");
        return nil;
    }
    
    self = [arrayOfViews firstObject];*/
    /*
    CGRect imageFrame = CGRectMake(frame.origin.x, frame.origin.y, frame.size.width, frame.size.height * IMAGE_PROPORTION);
    [self.albumCoverImageView setFrame:imageFrame];
    [self.albumCoverImageView setImage:[UIImage imageNamed:@"imageAbsent"]];
    
    
    CGRect labelFrame = CGRectMake(frame.origin.x, frame.origin.y + frame.size.height*IMAGE_PROPORTION, frame.size.width, frame.size.height*(1-IMAGE_PROPORTION));
    [self.albumNameLabel setFrame:labelFrame];
    [self.albumNameLabel setText:@"N/A"];*/
                                   
    
    
    
    return self;
    
    
}





@end
