//
//  PLClassifyCell.m
//  Graduation
//
//  Created by qianfeng on 16/4/26.
//  Copyright (c) 2016年 qianfeng. All rights reserved.
//

#import "PLClassifyCell.h"

#define PL_SCREEN_SIZE [UIScreen mainScreen].bounds.size

@implementation PLClassifyCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self addCustomView];
    }
    return self;
}

- (void)addCustomView {
    self.backgroundColor = [UIColor lightTextColor];
    self.selectionStyle =  UITableViewCellSelectionStyleNone;
    
    //图片
    _photoImage = [[UIImageView alloc] initWithFrame:CGRectMake(15, 5, (PL_SCREEN_SIZE.height - 224) / 6 - 10, (PL_SCREEN_SIZE.height - 224) / 6 - 10)];
    [self.contentView addSubview:_photoImage];
    
    //歌手名字
    _className = [[UILabel alloc] initWithFrame:CGRectMake((PL_SCREEN_SIZE.height - 224) / 6 + 20, 0, PL_SCREEN_SIZE.width * 2 / 3 - 20, 25)];
    _className.textAlignment = NSTextAlignmentLeft;
    _className.textColor = [UIColor blackColor];
    _className.font = [UIFont systemFontOfSize:20];
    _className.center = CGPointMake(_className.center.x, _photoImage.center.y);
    [self.contentView addSubview:_className];
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
