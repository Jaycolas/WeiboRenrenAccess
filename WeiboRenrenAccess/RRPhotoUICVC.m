//
//  RRPhotoUICVC.m
//  WeiboRenrenAccess
//
//  Created by Nan Shen on 16/1/13.
//  Copyright (c) 2016年 Nan Shen. All rights reserved.
//

#import "RRPhotoUICVC.h"

@implementation RRPhotoUICVC

- (UIImageView *) photoImageView
{
    if (!_photoImageView) {
        _photoImageView = [[UIImageView alloc]initWithFrame:self.contentView.frame];
        [_photoImageView setImage:[UIImage imageNamed:@"imageAbsent"]];
        
        [self.contentView addSubview:_photoImageView];
        _photoImageView.contentMode = UIViewContentModeScaleAspectFit;
    }
    
    return _photoImageView;
}


@end
