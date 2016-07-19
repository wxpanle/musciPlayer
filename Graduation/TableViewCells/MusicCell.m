//
//  MusicCell.m
//  LoveLife
//
//  Created by qianfeng on 16/4/28.
//  Copyright (c) 2016年 qianfeng. All rights reserved.
//

#import "MusicCell.h"

@implementation MusicCell


- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        
        self.imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, self.bounds.size.width, self.bounds.size.height)];
        [self.contentView addSubview:self.imageView];
        

        self.titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, self.imageView.bounds.size.width, 20)];
        self.titleLabel.textAlignment = NSTextAlignmentCenter;
        self.titleLabel.textColor = [UIColor whiteColor];
        self.titleLabel.font = [UIFont systemFontOfSize:17];
        self.titleLabel.center = self.imageView.center;
        [self.contentView addSubview:self.titleLabel];
    }
    return self;
}
@end
