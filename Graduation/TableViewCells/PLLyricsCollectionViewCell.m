//
//  PLLyricsCollectionViewCell.m
//  GraduationProject
//
//  Created by qianfeng on 16/4/14.
//  Copyright (c) 2016年 qianfeng. All rights reserved.
//

#import "PLLyricsCollectionViewCell.h"

@implementation PLLyricsCollectionViewCell

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        CGRect labelFrame = self.bounds;
        _textLabel = [[UILabel alloc] initWithFrame:labelFrame];
        _textLabel.textColor = [UIColor whiteColor];
        _textLabel.textAlignment = NSTextAlignmentCenter;
        [self.contentView addSubview:_textLabel];
    }
    return self;
}

@end
