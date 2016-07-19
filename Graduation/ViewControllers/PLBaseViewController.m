//
//  PLBaseViewController.m
//  GraduationProject
//
//  Created by qianfeng on 16/4/10.
//  Copyright (c) 2016年 qianfeng. All rights reserved.
//

#import "PLBaseViewController.h"
#import "PLBackgroundImageName.h"

@interface PLBaseViewController ()

@end

@implementation PLBaseViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    //添加一个背景视图
    [self plSetBackgroundImageView];

}

#pragma mark ----- 视图即将出现 ------

//每次出现时,添加工具栏
- (void)viewWillAppear:(BOOL)animated {
    _toolBar = [PLHomeToolBar plHomeToolBar];
    [self.view addSubview:_toolBar];
}
//添加一个背景视图
- (void)plSetBackgroundImageView {
    CGRect frame = CGRectMake(0, 0, PL_SCREEN_SIZE.width, PL_SCREEN_SIZE.height);
    frame.size.height = frame.size.height - 64;
    self.backGroundImage = [[UIImageView alloc] initWithFrame:frame];
    [self.view addSubview:self.backGroundImage];
    
    //设置背景图
    [self plSetBackgroundImage];
}

//设置背景图片
- (void)plSetBackgroundImage {//查找数据库获得背景图
    _backGroundImageName = [PLBackgroundImageName MR_findFirst].backgroundImageName;
    self.backGroundImage.image = [UIImage imageNamed:_backGroundImageName];
}

//创建一个View
- (UIView *)plCreatViewWithFrame:(CGRect)frame andAplha:(CGFloat)alpha {
    UIView *view = [[UIView alloc] initWithFrame:frame];
    view.backgroundColor = [UIColor lightTextColor];
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
    label.textAlignment = NSTextAlignmentCenter;
    return label;
}

//创建一个Button
- (UIButton *)plCreateButtonWithFrame:(CGRect)frame andImageName:(NSString *)imageName andSEL:(SEL)sel andCornerRadius:(CGFloat)cornerRadius {
    UIButton *button = [[UIButton alloc] initWithFrame:frame];
    button.backgroundColor = [UIColor clearColor];
    [button setImage:[[UIImage imageNamed:imageName] imageWithRenderingMode:UIImageRenderingModeAutomatic] forState:UIControlStateNormal];
    [button addTarget:self action:sel forControlEvents:UIControlEventTouchUpInside];
    button.layer.cornerRadius = cornerRadius;
    button.clipsToBounds = YES;
    
    return button;
}

//创建一个分段选择器
- (UISegmentedControl *)plCreateSegmentControlWithFrame:(CGRect)frame andTitleArray:(NSArray *)array andEnabledIndex:(NSInteger)index andSEL:(SEL)sel {
    UISegmentedControl *segVC = [[UISegmentedControl alloc] initWithItems:array];
    segVC.frame = frame;
    segVC.selectedSegmentIndex = 0;
    segVC.tintColor = [UIColor darkGrayColor];
    [segVC addTarget:self action:sel forControlEvents:UIControlEventValueChanged];
    if (index != 0) {
       [segVC setEnabled:NO forSegmentAtIndex:index];
    }
    return segVC;
}

#pragma mark ----触摸------
- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    [self.view endEditing:NO];
}

#pragma mark ----导航栏的返回视图----
- (void)plCreateBackBarButtomItem {
    UIBarButtonItem *backItem = [[UIBarButtonItem alloc] init];
    backItem.title = @"返回";
    self.navigationItem.backBarButtonItem = backItem;
}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
