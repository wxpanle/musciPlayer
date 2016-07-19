//
//  AppDelegate.m
//  GraduationProject
//
//  Created by qianfeng on 16/4/10.
//  Copyright (c) 2016年 qianfeng. All rights reserved.
//

#import "AppDelegate.h"
#import "PLHomeViewController.h"
#import "PLLocalMusicInfo.h"
#import "PLBackgroundImageName.h"

@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    
    //实例化window
    [self initWithWindow];
    
    //创建文件夹,如果存在
    [self createManagerOfMusic];
    
    
    PLHomeViewController *plHomeVC = [[PLHomeViewController alloc] init];
    UINavigationController *plnaVC = [[UINavigationController alloc] initWithRootViewController:plHomeVC];
    plnaVC.navigationBar.translucent = NO;
    [plnaVC.navigationBar setBackgroundImage:[UIImage imageNamed:@"home_header"] forBarMetrics:UIBarMetricsDefault];
    plnaVC.navigationBar.backgroundColor = [UIColor clearColor];
    [self createToolBar:1];
    self.window.rootViewController = plnaVC;
    self.toolBar.navc = plnaVC;
    
    [self flashAnimation];
    
    return YES;
}

/**
 实例化window
 */
- (void)initWithWindow {
    self.window = [[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
    self.window.backgroundColor = [UIColor whiteColor];
    [self.window makeKeyAndVisible];
}

/**
 创建文件夹music
 */
- (void)createManagerOfMusic {
    NSFileManager *manager = [NSFileManager defaultManager];
    
    NSString *downPath = [PL_MUSIC_PATH stringByAppendingString:@"/Music"];
    NSString *tempPath = [PL_MUSIC_PATH stringByAppendingString:@"/Temp"];

    BOOL downFlag = [manager fileExistsAtPath:downPath isDirectory:nil];
    BOOL tempFlag = [manager fileExistsAtPath:tempPath isDirectory:nil];
    
    if (!downFlag) {
        //如果不存在,创建文件
        [manager createDirectoryAtPath:downPath withIntermediateDirectories:YES attributes:nil error:nil];
    }
    
    if (!tempFlag) {
        //如果不存在,创建文件
        [manager createDirectoryAtPath:tempPath withIntermediateDirectories:YES attributes:nil error:nil];
    }
}

/**
 创建导航栏
 */
- (void)createToolBar:(CGFloat)alpha {
    _toolBar = [PLHomeToolBar plHomeToolBar];
    _toolBar.plCurrentIndex = 0;
    //1.数据库准备
    [MagicalRecord setupCoreDataStackWithStoreNamed:@"/plMusicData.db"];
    
    //查找数据库
    if ([PLLocalMusicInfo MR_findAll].count == 0) {
        [self plAddLocalMusicLocal];
    }
    
    if ([PLBackgroundImageName MR_findAll].count == 0) {
        [self plAddBackgroundImage];
    }
    
    [_toolBar.plLocalMusicInfoArray addObjectsFromArray:[PLLocalMusicInfo MR_findAll]];
}

//添加本地皮肤数据库
- (void)plAddBackgroundImage {
    
    //添加皮肤
    PLBackgroundImageName *backgroundImageName = [PLBackgroundImageName MR_createEntity];
    backgroundImageName.backgroundImageName = @"sea.jpg";
    [[NSManagedObjectContext MR_defaultContext] MR_saveToPersistentStoreAndWait];
}

//添加本地音乐数据库
- (void)plAddLocalMusicLocal {
    
    //添加本地歌曲
    NSArray *plLocalMusicArray = @[@{@"singer" : @"关悦", @"song" : @"情难枕"}, @{@"singer" : @"孙露", @"song" : @"离别的秋天"}, @{@"singer" : @"尚芸菲", @"song" : @"忘了"}, @{@"singer" : @"金莎", @"song" : @"诺"}, @{@"singer" : @"杜雯媞", @"song" : @"雕琢"}];
    
    for (NSDictionary *tempDic in plLocalMusicArray) {
        PLLocalMusicInfo *data = [PLLocalMusicInfo MR_createEntity];
        data.singerName = [tempDic objectForKey:@"singer"];
        data.songName = [tempDic objectForKey:@"song"];
        data.songLyrics = nil;
        data.singerImage = nil;
        data.isLike = @0;
        data.albumName = @"未知专辑";
        
        //保存
        [[NSManagedObjectContext MR_defaultContext] MR_saveToPersistentStoreAndWait];
    }
}

/**
 *  闪屏动画
 */
- (void)flashAnimation {
    // 1. 实例化一个imageView
    UIImageView *iv = [[UIImageView alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    iv.image = [UIImage imageNamed:@"launched.jpg"];
    // 2. 把imageView添加到window上
    [self.window addSubview:iv];
    
    //
    [UIView animateWithDuration:0.8 delay:1 options:UIViewAnimationOptionLayoutSubviews animations:^{
        // 动画效果
        iv.alpha = 0;
        iv.transform = CGAffineTransformMakeScale(1.5, 1.5);
    } completion:^(BOOL finished) {
        // 动画完成后，移除imageView
        [iv removeFromSuperview];
    }];
}

- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

@end
