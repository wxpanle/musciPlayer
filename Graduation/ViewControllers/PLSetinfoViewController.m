//
//  PLSetinfoViewController.m
//  GraduationProject
//
//  Created by qianfeng on 16/4/10.
//  Copyright (c) 2016年 qianfeng. All rights reserved.
//

#import "PLSetinfoViewController.h"
#import "PLSkinCutViewController.h"

@interface PLSetinfoViewController ()

@end

@implementation PLSetinfoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    //设置导航栏Item
    //创建导航栏
    [self createNavigationItemSetInfo:1];
    
    //创建视图
    [self createViewSetInfo:1];
    
}

#pragma mark -----navigationItem-----
//设置导航栏属性
- (void)createNavigationItemSetInfo:(CGFloat)alpha {
    //导航条 右边
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
    self.navigationItem.rightBarButtonItems = @[headItem, leftlineItem];
    
    //导航条 听
    UIView *titleView = [self plCreatViewWithFrame:CGRectMake(0, 0, 40, 40) andAplha:0];
    titleView.backgroundColor = [UIColor clearColor];
    titleView.layer.borderColor = [UIColor clearColor].CGColor;
    UIImageView *imageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"home_listen"]];
    imageView.frame = CGRectMake(0, 0, 40, 40);
    [titleView addSubview:imageView];
    self.navigationItem.titleView = titleView;
    
}

#pragma mark ------view------
//创建视图
- (void)createViewSetInfo:(CGFloat)alpha {
    //皮肤更换按钮
    UIButton *skinButton = [self plCreateButtonWithFrame:CGRectMake((PL_SCREEN_SIZE.width - 160) / 3 + 20, (PL_SCREEN_SIZE.height - 164) / 4 - 60, 48, 48) andImageName:@"set_background" andSEL:@selector(skipButtonAction:) andCornerRadius:25];
    skinButton.layer.borderWidth = 2;
    skinButton.layer.borderColor = [UIColor whiteColor].CGColor;
    [self.view addSubview:skinButton];
    
    //皮肤更换文字
    UILabel *skinLabel = [self plCreateLabelWithText:@"皮肤管理" andFontSize:17 andTextColor:[UIColor blackColor] andFrame:CGRectMake(0, (PL_SCREEN_SIZE.height - 164) / 4, 80, 40)];
    skinLabel.center = CGPointMake(skinButton.center.x, skinLabel.center.y);
    [self.view addSubview:skinLabel];
    
    
    //定时按钮
    UIButton *watchButton = [self plCreateButtonWithFrame:CGRectMake((PL_SCREEN_SIZE.width - 160) / 3 * 2 + 90, (PL_SCREEN_SIZE.height - 164) / 4 - 60, 48, 48) andImageName:@"set_time" andSEL:@selector(watchButtonAction:) andCornerRadius:25];
    watchButton.layer.borderWidth = 2;
    watchButton.layer.borderColor = [UIColor whiteColor].CGColor;
    [self.view addSubview:watchButton];
    //定时按钮文字
    UILabel *watchLabel = [self plCreateLabelWithText:@"定时管理" andFontSize:17 andTextColor:[UIColor blackColor] andFrame:CGRectMake(0, (PL_SCREEN_SIZE.height - 164) / 4, 80, 40)];
    watchLabel.center = CGPointMake(watchButton.center.x, watchLabel.center.y);
    [self.view addSubview:watchLabel];
    
    //搜索按钮
    UIButton *searchButton = [self plCreateButtonWithFrame:CGRectMake((PL_SCREEN_SIZE.width - 160) / 3 + 20, (PL_SCREEN_SIZE.height - 164) / 4 * 2 - 60, 48, 48 ) andImageName:@"set_search" andSEL:@selector(searchLocalButtonAction:) andCornerRadius:25];
    searchButton.layer.borderWidth = 2;
    searchButton.layer.borderColor = [UIColor whiteColor].CGColor;
    [self.view addSubview:searchButton];
    //搜索按钮文字
    UILabel *searchLabel = [self plCreateLabelWithText:@"清理缓存" andFontSize:17 andTextColor:[UIColor blackColor] andFrame:CGRectMake(0, (PL_SCREEN_SIZE.height - 164) / 4 * 2, 120, 40)];
    searchLabel.center = CGPointMake(searchButton.center.x, searchLabel.center.y);
    [self.view addSubview:searchLabel];
    
    //设置按钮
    UIButton *setButton = [self plCreateButtonWithFrame:CGRectMake((PL_SCREEN_SIZE.width - 160) / 3 * 2 + 90, (PL_SCREEN_SIZE.height - 164) / 4 * 2 - 60, 48, 48 ) andImageName:@"set_set" andSEL:@selector(setButtonAction:) andCornerRadius:25];
    setButton.layer.borderWidth = 2;
    setButton.layer.borderColor = [UIColor whiteColor].CGColor;
    [self.view addSubview:setButton];
    //设置按钮文字
    UILabel *setLabel = [self plCreateLabelWithText:@"设置" andFontSize:17 andTextColor:[UIColor blackColor] andFrame:CGRectMake(0, (PL_SCREEN_SIZE.height - 164) / 4 * 2, 80, 40)];
    setLabel.center = CGPointMake(setButton.center.x, setLabel.center.y);
    [self.view addSubview:setLabel];
    
    //网络按钮
    UIButton *netButton = [self plCreateButtonWithFrame:CGRectMake((PL_SCREEN_SIZE.width - 160) / 3 + 20, (PL_SCREEN_SIZE.height - 164) / 4 * 3 - 60, 48, 48 ) andImageName:@"set_data_wi-fi" andSEL:@selector(netButtonAction:) andCornerRadius:25];
    [netButton setImage:[UIImage imageNamed:@"set_data_signal"] forState:UIControlStateSelected];
    netButton.layer.borderWidth = 2;
    netButton.layer.borderColor = [UIColor whiteColor].CGColor;
    [self.view addSubview:netButton];
    //网络按钮文字
    UILabel *netLabel = [self plCreateLabelWithText:@"网络状态" andFontSize:17 andTextColor:[UIColor blackColor] andFrame:CGRectMake(0, (PL_SCREEN_SIZE.height - 164) / 4 * 3, 80, 40)];
    netLabel.center = CGPointMake(netButton.center.x, netLabel.center.y);
    [self.view addSubview:netLabel];
    
    //结束按钮
    UIButton *overButton = [self plCreateButtonWithFrame:CGRectMake((PL_SCREEN_SIZE.width - 160) / 3 * 2 + 90, (PL_SCREEN_SIZE.height - 164) / 4 * 3 - 60, 48, 48 ) andImageName:@"set_shut_down" andSEL:@selector(overButtonAction:) andCornerRadius:25];
    overButton.layer.borderWidth = 2;
    overButton.layer.borderColor = [UIColor whiteColor].CGColor;
    [self.view addSubview:overButton];
    //结束按钮文字
    UILabel *overLabel = [self plCreateLabelWithText:@"结束程序" andFontSize:17 andTextColor:[UIColor blackColor] andFrame:CGRectMake((PL_SCREEN_SIZE.width - 160) / 3 * 3, (PL_SCREEN_SIZE.height - 164) / 4 * 3, 80, 40)];
    overLabel.center = CGPointMake(overButton.center.x, overLabel.center.y);
    [self.view addSubview:overLabel];
}

#pragma mark -----Button------
//皮肤管理
- (void)skipButtonAction:(UIButton *)btn {
    //跳转到皮肤切换界面
    PLSkinCutViewController *skinVC = [[PLSkinCutViewController alloc] init];
    self.navigationItem.title = @"返回";
    skinVC.navigationItem.title = @"皮肤切换";
    [self.navigationController pushViewController:skinVC animated:YES];
}

//定时管理
- (void)watchButtonAction:(UIButton *)btn {
    
}

//检索本地歌曲
- (void)searchLocalButtonAction:(UIButton *)btn {
    
    //清理缓存
    NSString *path = [self plGetCacheFilePath];
    
    [self plCalculateCachesSizeWithPath:path];
}

//设置
- (void)setButtonAction:(UIButton *)btn {
    
}

//网络管理
- (void)netButtonAction:(UIButton *)btn {
    
}

//电源管理
- (void)overButtonAction:(UIButton *)btn {
    
}

#pragma mark ----清理缓存相关----
/**
 获得缓存的路径
 */
- (NSString *)plGetCacheFilePath {
    
    NSLog(@"%@", NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES).lastObject);
    //获取沙盒缓存文件路径
    return NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES).lastObject;
}

/**
 计算缓存文件的大小
 */
- (CGFloat)plCalculateCachesSizeWithPath:(NSString *)path {
    //计算缓存文件夹下所有文件的大小
    
    //获取文件夹管理对象
    NSFileManager *manager = [NSFileManager defaultManager];
    
    //定义一个变量用来承接所有文件的大小
    CGFloat returnFileSize = 0.0;
    
    //判断该目录是否存在,只有存在才可以进行操作
    if ([manager fileExistsAtPath:path]) {
        
        //获取该目录下所有的文件
        NSArray *fileArray = [manager subpathsAtPath:path];
        
        //遍历该目录下所有的文件
        for (NSString *fileName in fileArray) {
            
            //获取每个子文件的路径
            NSString *filePath = [path stringByAppendingPathComponent:fileName];
            
            //每个文件的大小
            unsigned long long fileSize = [manager attributesOfItemAtPath:filePath error:nil].fileSize;
            
            //将字节转化为M
            returnFileSize += fileSize / 1024.0 / 1024.0;
            
            //删除文件夹
            [self plPresentAnAlertWithSize:returnFileSize];
            
            return returnFileSize;
        }
    }
     
    return returnFileSize;
}

/**
提示框
 */
- (void)plPresentAnAlertWithSize:(CGFloat)size {

    //提示框
    UIAlertController *cachesAlert = [UIAlertController alertControllerWithTitle:@"清理缓存" message:[NSString stringWithFormat:@"当前有%.2fM缓存,全部清理(ALL),保留歌手写真(OK),取消(NO)",size] preferredStyle:UIAlertControllerStyleAlert];
    
    //添加相关按钮

    //取消
    UIAlertAction *noAction = [UIAlertAction actionWithTitle:@"NO" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        
    }];
    
    //ALL
    UIAlertAction *allAction = [UIAlertAction actionWithTitle:@"ALL" style:UIAlertActionStyleDestructive handler:^(UIAlertAction * _Nonnull action) {
        
        [self plClearCachesWithFilePath:[self plGetCacheFilePath] andRemoveType:YES];
    }];
    
    //OK
    UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        
        [self plClearCachesWithFilePath:[self plGetCacheFilePath] andRemoveType:NO];
        
    }];
    
    //添加相关按钮
    [cachesAlert addAction:allAction];
    [cachesAlert addAction:okAction];
    [cachesAlert addAction:noAction];
    
    [self presentViewController:cachesAlert animated:YES completion:nil];
}

/**
 清理缓存
 */
- (void)plClearCachesWithFilePath:(NSString *)path andRemoveType:(BOOL)type {
    
    //获取文件夹对象
    NSFileManager *manager = [NSFileManager defaultManager];
    
    //判断目录是否存在
    if ([manager fileExistsAtPath:path]) {
        
        //查找子目录
        NSArray *fileArray = [manager subpathsAtPath:path];
        
        //遍历数组
        for (NSString *fileName in fileArray) {
            
            if ([fileName hasPrefix:@"default"]) {
                
                //判断删除类型
                if (type == NO) {
                    //跳过本次循环
//                    NSLog(@"不删除");
                    continue;
                }
            }
            
            //删除其余文件
            NSString *filePath = [path stringByAppendingPathComponent:fileName];
            
            [manager removeItemAtPath:filePath error:nil];
        }
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
}
@end
