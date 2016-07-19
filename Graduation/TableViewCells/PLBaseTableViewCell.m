//
//  PLBaseTableViewCell.m
//  GraduationProject
//
//  Created by qianfeng on 16/4/10.
//  Copyright (c) 2016年 qianfeng. All rights reserved.
//

#import "PLBaseTableViewCell.h"

@implementation PLBaseTableViewCell



//创建一个View
- (UIView *)plCreatViewWithFrame:(CGRect)frame andAplha:(CGFloat)alpha {
    UIView *view = [[UIView alloc] initWithFrame:frame];
    view.backgroundColor = [UIColor clearColor];
    view.layer.cornerRadius = 5;
    view.layer.borderColor = [UIColor whiteColor].CGColor;
    view.layer.borderWidth = 1;
    view.alpha = alpha;
    view.clipsToBounds = YES;
    return view;
}

//创建一个UILabel
- (UILabel *)plCreateLabelWithText:(NSString *)text andFontSize:(CGFloat)fontSize andTextColor:(UIColor *)textColor andFrame:(CGRect)frame {
    UILabel *label = [[UILabel alloc] initWithFrame:frame];
    label.text = text;
    label.textColor = textColor;
    label.font = [UIFont systemFontOfSize:fontSize];
    label.textAlignment = NSTextAlignmentLeft;
    return label;
}

//创建一个Button
- (UIButton *)plCreateButtonWithFrame:(CGRect)frame andImageName:(NSString *)imageName andSEL:(SEL)sel {
    UIButton *button = [[UIButton alloc] initWithFrame:frame];
    [button setImage:[[UIImage imageNamed:imageName] imageWithRenderingMode:UIImageRenderingModeAutomatic] forState:UIControlStateNormal];
    [button addTarget:self action:sel forControlEvents:UIControlEventTouchUpInside];
    return button;
}

@end
