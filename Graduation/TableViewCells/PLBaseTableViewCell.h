//
//  PLBaseTableViewCell.h
//  GraduationProject
//
//  Created by qianfeng on 16/4/10.
//  Copyright (c) 2016年 qianfeng. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CoreData+MagicalRecord.h"

@interface PLBaseTableViewCell : UITableViewCell

/**
 创建一个View
 */
- (UIView *)plCreatViewWithFrame:(CGRect)frame andAplha:(CGFloat)alpha;

/**
 创建一个UILabel
 */
- (UILabel *)plCreateLabelWithText:(NSString *)text andFontSize:(CGFloat)fontSize andTextColor:(UIColor *)textColor andFrame:(CGRect)frame;

/**
 创建一个Button
 */
- (UIButton *)plCreateButtonWithFrame:(CGRect)frame andImageName:(NSString *)imageName andSEL:(SEL)sel;
@end
