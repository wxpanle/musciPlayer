//
//  PLHomeToolBar.h
//  GraduationProject
//
//  Created by qianfeng on 16/4/10.
//  Copyright (c) 2016年 qianfeng. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AVFoundation/AVFoundation.h>

@interface PLHomeToolBar : UIToolbar <AVAudioPlayerDelegate>

//导航栏
@property (nonatomic, weak) UINavigationController *navc;

#pragma mark -----player------
//播放
@property (nonatomic, strong) AVAudioPlayer *player;
//现在的时间
@property (nonatomic, assign) NSTimeInterval currentTime;
//定时器
@property (nonatomic, strong) NSTimer *playTimer;
//正在播放的下标
@property (nonatomic, assign) NSInteger plCurrentIndex;
//本地音乐的数组
@property (nonatomic, strong) NSMutableArray *plLocalMusicInfoArray;
//定时
@property (nonatomic, assign) NSTimeInterval *watchTotalTime;
//YES: net  NO: local
@property (nonatomic, assign) BOOL localOrNetMusic;
//是否需要发送一个通知
@property (nonatomic, assign) BOOL isNeedPostNotification;

#pragma mark  ------button------
//背景
@property (nonatomic, strong) UIButton *singerButton;
//播放
@property (nonatomic, strong) UIButton *playButton;
//下一个
@property (nonatomic, strong) UIButton *nextButton;
//上一个
@property (nonatomic, strong) UIButton *previousButton;
//歌手名字
@property (nonatomic, strong) UILabel *singerName;
//歌曲名字
@property (nonatomic, strong) UILabel *songName;
//当前时间
@property (nonatomic, strong) UILabel *presentTime;
//歌曲总长
@property (nonatomic, strong) UILabel *totalTime;
//音乐进度
@property (nonatomic, strong) UISlider *slider;


#pragma mark ------playModel-------
//顺序播放
@property (nonatomic, strong) UIButton *toggleButton;
//单曲
@property (nonatomic, strong) UIButton *repeatButton;
//随机
@property (nonatomic, strong) UIButton *shuffleButton;



/**
 创建一个单例
 */
+ (instancetype)plHomeToolBar;

/**
 更换导航栏样式
 */
- (void)plChangeToolBarButton;

/**
 还原导航栏样式
 */
- (void)plRecoverToolBarButton;

/**
 初始化一个播放器 本地/网络
 */
- (void)setUpPlayer;

/**
 清除缓存
 */
- (void)plDeleteNetMusicToSaveSpace;
@end
