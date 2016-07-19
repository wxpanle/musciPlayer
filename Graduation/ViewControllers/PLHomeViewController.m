//
//  PLHomeViewController.m
//  GraduationProject
//
//  Created by qianfeng on 16/4/10.
//  Copyright (c) 2016年 qianfeng. All rights reserved.
//

#import "PLHomeViewController.h"
#import "PLLocalViewController.h"
#import "PLSetinfoViewController.h"
#import "PLSearchViewController.h"
#import "PLStoreViewController.h"

#define PL_SCREEN_SIZE_HEIGHT ([UIScreen mainScreen].bounds.size.height - 204) / 9

@interface PLHomeViewController () <UITextFieldDelegate> {
//    NSMutableArray *_plHomeDataArray;
    UITextField *_textField;
}

@end

@implementation PLHomeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    //创建导航栏
    [self createNavigationItem:1];
    
    //创建搜索栏
    [self searchTextField:1];
    
    //创建列表
    [self createViewLocal:1];
    [self createViewLike:1];
    [self createViewMusicStore:1];
    [self createViewMusicApple:1];
    
    //创建清扫手势
    [self createSwipeGestureRecognizer];
}

#pragma mark -----NavigationItem-----
//创建导航栏
- (void)createNavigationItem:(CGFloat)alpha {
    //导航条 左边
    UIView *headView = [self plCreatViewWithFrame:CGRectMake(0, 0, 40, 40) andAplha:0];
    //设置圆角并剪切子类
    headView.layer.cornerRadius = 20;
    headView.clipsToBounds = YES;
    //添加头像
    UIImageView *headImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"home_head.jpg"]];
    headImageView.frame = CGRectMake(0, 0, 40, 40);
    [headView addSubview:headImageView];
    //添加圆圈
    headView.backgroundColor = [UIColor clearColor];
    UIImageView *headCircleView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"home_circle"]];
    headCircleView.frame = CGRectMake(0, 0, 40, 40);
    [headImageView addSubview:headCircleView];
    
    //定义item
    UIBarButtonItem *headItem = [[UIBarButtonItem alloc] initWithCustomView:headView];
    UIBarButtonItem *leftlineItem = [[UIBarButtonItem alloc] initWithImage:[[UIImage imageNamed:@"home_line_1"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] style:UIBarButtonItemStylePlain target:self action:nil];
    self.navigationItem.leftBarButtonItems = @[headItem, leftlineItem];
    
    //导航条 听
    UIView *titleView = [self plCreatViewWithFrame:CGRectMake(0, 0, 40, 40) andAplha:0];
    titleView.backgroundColor = [UIColor clearColor];
    titleView.layer.borderColor = [UIColor clearColor].CGColor;
    UIImageView *imageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"home_listen"]];
    imageView.frame = CGRectMake(0, 0, 40, 40);
    [titleView addSubview:imageView];
    self.navigationItem.titleView = titleView;
    
    //导航条 右边
    UIView *rightView = [self plCreatViewWithFrame:CGRectMake(0, 0, 50, 40) andAplha:0];
    rightView.layer.borderColor = [UIColor clearColor].CGColor;
    rightView.backgroundColor = [UIColor clearColor];
    UIButton *gotosliderButton = [self plCreateButtonWithFrame:CGRectMake(8, 0, 40, 40) andImageName:@"home_gotoslide" andSEL:@selector(homeGotoslideButtonAction:) andCornerRadius:10];
    UIImageView *lineImageView = [[UIImageView alloc] initWithImage:[[UIImage imageNamed:@"home_line_1"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal]];
    lineImageView.frame = CGRectMake(5, 10, 1, 23);
    [rightView addSubview:lineImageView];
    [rightView addSubview:gotosliderButton];
    
    UIBarButtonItem *rightItem = [[UIBarButtonItem alloc] initWithCustomView:rightView];
    self.navigationItem.rightBarButtonItem = rightItem;
}

#pragma mark -----viewControllers-----
// 创建搜索栏
- (void)searchTextField:(CGFloat)alpha {
    UITextField *textField = [[UITextField alloc] initWithFrame:CGRectMake(15, 10, PL_SCREEN_SIZE.width - 30, PL_SCREEN_SIZE_HEIGHT)];
    
    _textField = textField;
    textField.placeholder = @"请输入歌手名或者歌曲名字";
    textField.clearsOnBeginEditing = YES;
    textField.backgroundColor = [UIColor lightTextColor];
    textField.textAlignment = NSTextAlignmentCenter;
    textField.layer.cornerRadius = 5;
    textField.layer.borderColor = [UIColor whiteColor].CGColor;
    textField.layer.borderWidth = 0.3;
    textField.alpha = alpha;
    textField.clipsToBounds = YES;
    textField.delegate = self;
    
    //右视图
    textField.rightView = [self plCreatViewWithFrame:CGRectMake(textField.bounds.size.width - 100, 10, 50, 50) andAplha:1];
    UIButton *searchButton = [self plCreateButtonWithFrame:CGRectMake(5, 5, 40, 40) andImageName:@"set_search" andSEL:@selector(searchButtonAction) andCornerRadius:10];
    [textField.rightView addSubview:searchButton];
    textField.rightViewMode = UITextFieldViewModeWhileEditing;
    
    //左视图
    textField.leftView = [self plCreatViewWithFrame:CGRectMake(0, 10, 50 , 50) andAplha:1];
    UIButton *speackButton = [self plCreateButtonWithFrame:CGRectMake(5, 5, 40, 40) andImageName:@"home_language" andSEL:nil andCornerRadius:10];
    [textField.leftView addSubview:speackButton];
    textField.leftViewMode = UITextFieldViewModeUnlessEditing;
    
    [self.view addSubview:textField];
}

//创建第一栏
- (void)createViewLocal:(CGFloat)alpha {
    UIView *view = [self plCreatViewWithFrame:CGRectMake(15, PL_SCREEN_SIZE_HEIGHT + 20, PL_SCREEN_SIZE.width - 30, PL_SCREEN_SIZE_HEIGHT * 6 / 5) andAplha:alpha];
    view.tintColor = [UIColor clearColor];
    [self.view addSubview:view];
    
    UILabel *plhLocalLabel = [self plCreateLabelWithText:@"本地音乐" andFontSize:20 andTextColor:[UIColor blackColor] andFrame:CGRectMake(20, 10, 80, PL_SCREEN_SIZE_HEIGHT * 6 / 5 - 20)];
    [view addSubview:plhLocalLabel];
    
    //跳转按钮
    UIButton *buttonLocal = [self plCreateButtonWithFrame:CGRectMake(view.bounds.size.width - 60, 10, PL_SCREEN_SIZE_HEIGHT * 6 / 5 - 20, PL_SCREEN_SIZE_HEIGHT * 6 / 5 - 20) andImageName:@"home_local_music" andSEL:@selector(localMusicButtonAction:) andCornerRadius:10];
    [view addSubview:buttonLocal];
}

//创建第二栏
- (void)createViewLike:(CGFloat)alpha {
    UIView *view = [self plCreatViewWithFrame:CGRectMake(15, PL_SCREEN_SIZE_HEIGHT * 11 / 5 + 30, PL_SCREEN_SIZE.width - 30, PL_SCREEN_SIZE_HEIGHT * 8 / 5) andAplha:alpha];
    [self.view addSubview:view];
    
    //我喜欢
    UILabel *likeLabel = [self plCreateLabelWithText:@"我喜欢" andFontSize:13 andTextColor:[UIColor blackColor] andFrame:CGRectMake(15, PL_SCREEN_SIZE_HEIGHT + 5, (view.bounds.size.width - 30) / 4, PL_SCREEN_SIZE_HEIGHT * 2 / 5)];
    [view addSubview:likeLabel];
    
    UIButton *likeButton = [self plCreateButtonWithFrame:CGRectMake(15 + (view.bounds.size.width - 30) / 8 - 20, 5, 40, 40) andImageName:@"home_like" andSEL:@selector(likeMusicButtonAction:) andCornerRadius:10];
    [view addSubview:likeButton];
    
    //我的歌单

    UILabel *tableLabel = [self plCreateLabelWithText:@"我的歌单" andFontSize:13 andTextColor:[UIColor blackColor] andFrame:CGRectMake(15 + (view.bounds.size.width - 30) / 4 * 1, PL_SCREEN_SIZE_HEIGHT + 5, (view.bounds.size.width - 30) / 4 , PL_SCREEN_SIZE_HEIGHT * 2 / 5)];
    [view addSubview:tableLabel];
    
    UIButton *tableButton = [self plCreateButtonWithFrame:CGRectMake(15 + (view.bounds.size.width - 30) / 8 * 3 - 20, 5, 40, 40) andImageName:@"home_music_sheet" andSEL:nil andCornerRadius:10];
    [view addSubview:tableButton];
    
    //下载管理
    UILabel *downLabel = [self plCreateLabelWithText:@"下载管理" andFontSize:13 andTextColor:[UIColor blackColor] andFrame:CGRectMake(15 + (view.bounds.size.width - 30) / 4 * 2, PL_SCREEN_SIZE_HEIGHT + 5, (view.bounds.size.width - 30) / 4 , PL_SCREEN_SIZE_HEIGHT * 2 / 5)];
    [view addSubview:downLabel];
    
    UIButton *downButton = [self plCreateButtonWithFrame:CGRectMake(15 + (view.bounds.size.width - 30) / 8 * 5 - 20, 5, 40, 40) andImageName:@"home_recent_down" andSEL:nil andCornerRadius:10];
    [view addSubview:downButton];
    
    //最近播放
    UILabel *recentLabel = [self plCreateLabelWithText:@"最近播放" andFontSize:13 andTextColor:[UIColor blackColor] andFrame:CGRectMake(15 + (view.bounds.size.width - 30) / 4 * 3, PL_SCREEN_SIZE_HEIGHT + 5, (view.bounds.size.width - 30) / 4 , PL_SCREEN_SIZE_HEIGHT * 2 / 5)];
    [view addSubview:recentLabel];
    
    UIButton *recentButton = [self plCreateButtonWithFrame:CGRectMake(15 + (view.bounds.size.width - 30) / 8 * 7 - 20, 5, 40, 40) andImageName:@"home_recent" andSEL:nil andCornerRadius:10];
    [view addSubview:recentButton];
}

//创建第三栏
- (void)createViewMusicStore:(CGFloat)alpha {

    UIView *view = [self plCreatViewWithFrame:CGRectMake(15, PL_SCREEN_SIZE_HEIGHT * 19 / 5 + 40, PL_SCREEN_SIZE.width - 30, PL_SCREEN_SIZE_HEIGHT * 2) andAplha:alpha];
    [self.view addSubview:view];
    
    //乐库
    UILabel *storyLabel = [self plCreateLabelWithText:@"乐库" andFontSize:20 andTextColor:[UIColor blackColor] andFrame:CGRectMake(17, 20, 50, PL_SCREEN_SIZE_HEIGHT * 2 / 5)];
    [view addSubview:storyLabel];
    
    //下标
    UILabel *detailLabel = [self plCreateLabelWithText:@"歌手|歌单|分类|排行榜" andFontSize:15 andTextColor:[UIColor magentaColor] andFrame:CGRectMake(15, PL_SCREEN_SIZE_HEIGHT * 6 / 5, 170, PL_SCREEN_SIZE_HEIGHT * 2 / 5)];
    [view addSubview:detailLabel];
    
    UIButton *storyButton = [self plCreateButtonWithFrame:CGRectMake(view.bounds.size.width / 4 * 3, 15, PL_SCREEN_SIZE_HEIGHT * 2 - 30, PL_SCREEN_SIZE_HEIGHT * 2 - 30) andImageName:@"home_music" andSEL:@selector(storyButtonAction:) andCornerRadius:10];
    [view addSubview:storyButton];
}

//创建第四栏
- (void)createViewMusicApple:(CGFloat)alpha {
    UIView *view = [self plCreatViewWithFrame:CGRectMake(15, PL_SCREEN_SIZE_HEIGHT * 29 / 5 + 50, PL_SCREEN_SIZE.width - 30, PL_SCREEN_SIZE_HEIGHT * 2) andAplha:alpha];
    [self.view addSubview:view];
    
    //收音机
    UILabel *radioLabel = [self plCreateLabelWithText:@"收音机" andFontSize:13 andTextColor:[UIColor blackColor] andFrame:CGRectMake(15, PL_SCREEN_SIZE_HEIGHT + 20, (view.bounds.size.width - 30) / 4, PL_SCREEN_SIZE_HEIGHT * 2 / 5)];
    [view addSubview:radioLabel];
    

    UIButton *radioButton = [self plCreateButtonWithFrame:CGRectMake(0, 10, PL_SCREEN_SIZE_HEIGHT, PL_SCREEN_SIZE_HEIGHT) andImageName:@"home_radio" andSEL:nil andCornerRadius:10];
    radioButton.center = CGPointMake(radioLabel.center.x, radioButton.center.y);
    [view addSubview:radioButton];
    
    //铃声/彩铃
    UILabel *soundLabel = [self plCreateLabelWithText:@"铃声/彩铃" andFontSize:13 andTextColor:[UIColor blackColor] andFrame:CGRectMake(15 + (view.bounds.size.width - 30) / 4 * 1, PL_SCREEN_SIZE_HEIGHT + 20, (view.bounds.size.width - 30) / 4 , PL_SCREEN_SIZE_HEIGHT * 2 / 5)];
    [view addSubview:soundLabel];
    

    UIButton *soundButton = [self plCreateButtonWithFrame:CGRectMake(0, 10, PL_SCREEN_SIZE_HEIGHT, PL_SCREEN_SIZE_HEIGHT) andImageName:@"home_cd.jpg" andSEL:nil andCornerRadius:10];
    soundButton.center = CGPointMake(soundLabel.center.x, soundButton.center.y);
    [view addSubview:soundButton];
    
    //游戏
    UILabel *downLabel = [self plCreateLabelWithText:@"游戏" andFontSize:13 andTextColor:[UIColor blackColor] andFrame:CGRectMake(15 + (view.bounds.size.width - 30) / 4 * 2, PL_SCREEN_SIZE_HEIGHT + 20, (view.bounds.size.width - 30) / 4 , PL_SCREEN_SIZE_HEIGHT * 2 / 5)];
    [view addSubview:downLabel];
    

    UIButton *downButton = [self plCreateButtonWithFrame:CGRectMake(0, 10, PL_SCREEN_SIZE_HEIGHT, PL_SCREEN_SIZE_HEIGHT) andImageName:@"home_mv" andSEL:nil andCornerRadius:10];
    downButton.center = CGPointMake(downLabel.center.x, downButton.center.y);
    [view addSubview:downButton];
    
    //精品应用
    UILabel *recentLabel = [self plCreateLabelWithText:@"精品应用" andFontSize:13 andTextColor:[UIColor blackColor] andFrame:CGRectMake(15 + (view.bounds.size.width - 30) / 4 * 3, PL_SCREEN_SIZE_HEIGHT + 20, (view.bounds.size.width - 30) / 4 , PL_SCREEN_SIZE_HEIGHT * 2 /5)];
    [view addSubview:recentLabel];
    

    UIButton *recentButton = [self plCreateButtonWithFrame:CGRectMake(0, 10, PL_SCREEN_SIZE_HEIGHT, PL_SCREEN_SIZE_HEIGHT) andImageName:@"home_apply.jpg" andSEL:nil andCornerRadius:10];
    recentButton.center = CGPointMake(recentLabel.center.x, recentButton.center.y);
    [view addSubview:recentButton];

}

#pragma mark -----Button------
//跳转至本地播放列表
- (void)localMusicButtonAction:(UIButton *)btn {
    PLLocalViewController *localVC = [[PLLocalViewController alloc] init];
    [self plCreateBackBarButtomItem];
    localVC.navigationItem.title = @"本地音乐";
    [self.navigationController pushViewController:localVC animated:NO];
}

//跳转至我喜欢列表
- (void)likeMusicButtonAction:(UIButton *)btn {
    PLLocalViewController *localVC = [[PLLocalViewController alloc] init];
    [self plCreateBackBarButtomItem];
    localVC.navigationItem.title = @"我喜欢";
    [self.navigationController pushViewController:localVC animated:NO];
}

//跳转至乐库搜索
- (void)storyButtonAction:(UIButton *)btn {
    PLStoreViewController *storeVC = [[PLStoreViewController alloc] init];
    [self plCreateBackBarButtomItem];
    storeVC.navigationItem.title = @"乐库";
    [self.navigationController pushViewController:storeVC animated:NO];
}

//跳转到搜索页面
- (void)searchButtonAction {
    PLSearchViewController *localVC = [[PLSearchViewController alloc] init];
    [self plCreateBackBarButtomItem];
    localVC.navigationItem.title = @"搜索";
    localVC.plName = _textField.text;
    //清空textField内容
    _textField.text = @"";
    [self.navigationController pushViewController:localVC animated:NO];
    
    //让键盘隐藏--》让文本框放弃第一响应者
    [_textField resignFirstResponder];
}

//跳转到个人信息
- (void)homeHeadButtonAction:(UIButton *)btn {
    
}

//跳转到设置界面
- (void)homeGotoslideButtonAction:(UIButton *)btn {
    PLSetinfoViewController *setVC = [[PLSetinfoViewController alloc] init];
    [self plCreateBackBarButtomItem];
    setVC.navigationItem.title = @"设置";
    [self.navigationController pushViewController:setVC animated:NO];
}


#pragma mark ----- 清扫手势 -----
- (void)createSwipeGestureRecognizer {
    UISwipeGestureRecognizer *swipeGestureRecognizer = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(swipeGestureRecognizerAction:)];
    swipeGestureRecognizer.numberOfTouchesRequired = 1;
    //设置清扫方向
    swipeGestureRecognizer.direction = UISwipeGestureRecognizerDirectionLeft;
    
    [self.view addGestureRecognizer:swipeGestureRecognizer];
}

/**
 清扫手势的方法
 */
- (void)swipeGestureRecognizerAction:(UISwipeGestureRecognizer *)swipeGestureRecognizer{
    
    //推出设置界面
    [self homeGotoslideButtonAction:nil];
}

#pragma mark ----UITextDeledate-----
//是否开启输入模式
- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField {
    return YES;
}

//是否离开输入模式
- (BOOL)textFieldShouldEndEditing:(UITextField *)textField {
    return YES;
}

//是否进行回车
- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    
    [self searchButtonAction];
    return YES;
}

//是否执行清除动作
- (BOOL)textFieldShouldClear:(UITextField *)textField {
    return YES;
}
@end
