//
//  PLBaseViewController.h
//  GraduationProject
//
//  Created by qianfeng on 16/4/10.
//  Copyright (c) 2016年 qianfeng. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PLBaseViewController : UIViewController {
    PLHomeToolBar *_toolBar;
    NSString *_backGroundImageName;
}

//背景图片
@property (nonatomic, strong) UIImageView *backGroundImage;

//工具栏
@property (nonatomic, strong) PLHomeToolBar *toolBar;

/**
 设置背景图片
 */
- (void)plSetBackgroundImage;

/**
 设置背景视图
 */
- (void)plSetBackgroundImageView;

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
- (UIButton *)plCreateButtonWithFrame:(CGRect)frame andImageName:(NSString *)imageName andSEL:(SEL)sel andCornerRadius:(CGFloat)cornerRadius;

/**
 创建一个分段选择器
 */
- (UISegmentedControl *)plCreateSegmentControlWithFrame:(CGRect)frame andTitleArray:(NSArray *)array andEnabledIndex:(NSInteger)index andSEL:(SEL)sel;

/**
 导航栏的返回视图
 */
- (void)plCreateBackBarButtomItem;


@end
