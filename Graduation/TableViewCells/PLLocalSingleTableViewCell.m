//
//  PLLocalSingleTableViewCell.m
//  GraduationProject
//
//  Created by qianfeng on 16/4/10.
//  Copyright (c) 2016年 qianfeng. All rights reserved.
//

#import "PLLocalSingleTableViewCell.h"


@implementation PLLocalSingleTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self addCustomView];
    }
    return self;
}

- (void)addCustomView {
    self.backgroundColor = [UIColor clearColor];
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    self.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    
    //左视图
    _preView = [self plCreatViewWithFrame:CGRectMake(20, 8, 28, 28) andAplha:1];
    UIButton *button = [self plCreateButtonWithFrame:CGRectMake(1, 1, 27, 27) andImageName:@"table_add" andSEL:@selector(tableAddAction)];
    [_preView addSubview:button];
    [self.contentView addSubview:_preView];
    
    //label
    _titleText = [self plCreateLabelWithText:@"" andFontSize:15 andTextColor:[UIColor blackColor] andFrame:CGRectMake(54, 5, self.bounds.size.width - 30, 34)];
    [self.contentView addSubview:_titleText];
}


- (void)tableAddAction {
    NSLog(@"s");
}

- (void)tableSpreadButton {
    NSLog(@"d");
}
@end
