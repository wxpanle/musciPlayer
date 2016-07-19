//
//  PLHomeToolBar.m
//  GraduationProject
//
//  Created by qianfeng on 16/4/10.
//  Copyright (c) 2016年 qianfeng. All rights reserved.
//

#import "PLHomeToolBar.h"
#import "PLLyricsViewController.h"

#define PL_SCREEN_SIZE [UIScreen mainScreen].bounds.size

@implementation PLHomeToolBar 

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {

    }
    return self;
}

+ (instancetype)plHomeToolBar {
    static PLHomeToolBar *toolBar = nil;
    if (toolBar == nil) {
        toolBar = [[PLHomeToolBar alloc] initWithFrame:CGRectMake(0, PL_SCREEN_SIZE.height - 144, PL_SCREEN_SIZE.width, 80)];
        [toolBar addCustomView];
    }
    return toolBar;
}

- (void)addCustomView {
    
    self.barStyle = UIBarStyleDefault;
    
    //背景
    _singerButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [_singerButton setImage:[UIImage imageNamed:@"home_singleButton.jpg"] forState:UIControlStateNormal];
    [_singerButton addTarget:self action:@selector(singerButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    _singerButton.frame = CGRectMake(20, 10, 60, 60);
    _singerButton.layer.cornerRadius = 5;
    _singerButton.clipsToBounds = YES;
    [self addSubview:_singerButton];
    
    //播放
    _playButton = [[UIButton alloc] initWithFrame:CGRectMake(PL_SCREEN_SIZE.width / 3 * 2 - 15, 30, 78, 42)];
    [_playButton setImage:[UIImage imageNamed:@"home_play"] forState:UIControlStateNormal];
    [_playButton setImage:[UIImage imageNamed:@"home_pause"] forState:UIControlStateSelected];
    [_playButton addTarget:self action:@selector(playButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:_playButton];
    
    //下一个
    _nextButton = [[UIButton alloc] initWithFrame:CGRectMake(PL_SCREEN_SIZE.width / 3 * 2 + 40, 27, 48, 48)];
    [_nextButton setImage:[UIImage imageNamed:@"home_next"] forState:UIControlStateNormal];
    [_nextButton addTarget:self action:@selector(nextButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:_nextButton];
    
    //上一个
    _previousButton = [[UIButton alloc] initWithFrame:CGRectMake(PL_SCREEN_SIZE.width / 2 - 85, 55, 30, 30)];
    [_previousButton setImage:[[UIImage imageNamed:@"play_pre"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] forState:UIControlStateNormal];
    [_previousButton addTarget:self action:@selector(preViousButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    _previousButton.hidden = YES;
    [self addSubview:_previousButton];
    
    //歌手名字
    _singerName = [[UILabel alloc] initWithFrame:CGRectMake(95, 35, 150, 20)];
    _singerName.text = @"卿颜淡墨";
    _singerName.font = [UIFont systemFontOfSize:15];
    _singerName.textColor = [UIColor blackColor];
    _singerName.textAlignment = NSTextAlignmentLeft;
    [self addSubview:_singerName];
    
    //歌曲名字
    _songName = [[UILabel alloc] initWithFrame:CGRectMake(95, 60, 150, 15)];
    _songName.text = @"卿颜淡墨";
    _songName.font = [UIFont systemFontOfSize:13];
    _songName.textColor = [UIColor grayColor];
    _songName.textAlignment = NSTextAlignmentLeft;
    [self addSubview:_songName];
    
    //当前时间
    _presentTime = [[UILabel alloc] initWithFrame:CGRectMake(5, 10, 40, 30)];
    _presentTime.text = @"0:00";
    _presentTime.font = [UIFont boldSystemFontOfSize:15];
    _presentTime.textColor = [UIColor blueColor];
    _presentTime.textAlignment = NSTextAlignmentLeft;
    _presentTime.hidden = YES;
    [self addSubview:_presentTime];
    
    //总时长
    _totalTime = [[UILabel alloc] initWithFrame:CGRectMake(PL_SCREEN_SIZE.width - 45, 10, 40, 30)];
    _totalTime.text = @"0:00";
    _totalTime.font = [UIFont boldSystemFontOfSize:15];
    _totalTime.textColor = [UIColor blueColor];
    _totalTime.textAlignment = NSTextAlignmentRight;
    _totalTime.hidden = YES;
    [self addSubview:_totalTime];
    
    //音乐进度
    _slider = [[UISlider alloc] initWithFrame:CGRectMake(120, 15, PL_SCREEN_SIZE.width - 140, 2)];
    _slider.continuous = NO;
    _slider.value = 0;
    _slider.tintColor = [UIColor whiteColor];
    [_slider addTarget:self action:@selector(sliderPlayCurrentTimeSet) forControlEvents:UIControlEventValueChanged];
    [self addSubview:_slider];

    
    //循环模式
    _toggleButton = [UIButton buttonWithType:UIButtonTypeCustom];
    _toggleButton.frame = CGRectMake(10, 60, 30, 30);
    [_toggleButton setImage:[[UIImage imageNamed:@"play_repeatall"] imageWithRenderingMode:UIImageRenderingModeAutomatic] forState:UIControlStateNormal];
    [_toggleButton addTarget:self action:@selector(plModelToggle:) forControlEvents:UIControlEventTouchUpInside];
    _toggleButton.hidden = YES;
    _toggleButton.selected = YES;
    _toggleButton.backgroundColor = [UIColor redColor];
    _toggleButton.layer.cornerRadius = 15;
    _toggleButton.clipsToBounds = YES;
    [self addSubview:_toggleButton];
    
    //单曲模式
    _repeatButton = [[UIButton alloc] initWithFrame:CGRectMake(10, 60, 30, 30)];
    [_repeatButton setImage:[UIImage imageNamed:@"play_repeatone"] forState:UIControlStateNormal];
    [_repeatButton addTarget:self action:@selector(plModelToggle:) forControlEvents:UIControlEventTouchUpInside];
    _repeatButton.hidden = YES;
    _repeatButton.backgroundColor = [UIColor redColor];
    _repeatButton.layer.cornerRadius = 15;
    _repeatButton.clipsToBounds = YES;
    [self addSubview:_repeatButton];
    
    //随机模式
    _shuffleButton = [[UIButton alloc] initWithFrame:CGRectMake(10, 60, 30, 30)];
    [_shuffleButton setImage:[UIImage imageNamed:@"play_shuffle"] forState:UIControlStateNormal];
    [_shuffleButton addTarget:self action:@selector(plModelToggle:) forControlEvents:UIControlEventTouchUpInside];
    _shuffleButton.backgroundColor = [UIColor redColor];
    _shuffleButton.layer.cornerRadius = 15;
    _shuffleButton.clipsToBounds = YES;
    _shuffleButton.hidden = YES;
    _shuffleButton.transform = CGAffineTransformMakeRotation(3.14 / 2);
    [self addSubview:_shuffleButton];
    
    
    //设置计时器
    self.playTimer = [NSTimer scheduledTimerWithTimeInterval:0.5 target:self selector:@selector(upDataOfSliderValue) userInfo:nil repeats:YES];
    
}

#pragma mark -----changeTool------
//更改导航栏的样式
- (void)plChangeToolBarButton {
    self.songName.hidden = YES;
    self.singerButton.hidden = YES;
    self.singerName.hidden = YES;
    self.previousButton.hidden = NO;
    self.presentTime.hidden = NO;
    self.totalTime.hidden = NO;
    self.toggleButton.hidden = NO;
    self.frame = CGRectMake(0, PL_SCREEN_SIZE.height - 184, PL_SCREEN_SIZE.width, 120);
    
    //更换播放按钮的位置和图片
    _playButton.frame = CGRectMake(PL_SCREEN_SIZE.width / 2 - 25, 50, 40, 40);
    [_playButton setImage:[[UIImage imageNamed:@"play_play"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] forState:UIControlStateNormal];
    [_playButton setImage:[[UIImage imageNamed:@"play_pause"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] forState:UIControlStateSelected];
    
    //更换下一曲的位置和图片
    _nextButton.frame = CGRectMake(PL_SCREEN_SIZE.width / 2 + 50, 55, 30, 30);
    [_nextButton setImage:[UIImage imageNamed:@"play_next"] forState:UIControlStateNormal];
    
    //更换slider位置
    _slider.frame = CGRectMake(55, 25, PL_SCREEN_SIZE.width - 110, 2);
}

//还原导航栏样式
- (void)plRecoverToolBarButton {
    self.songName.hidden = NO;
    self.singerButton.hidden = NO;
    self.singerName.hidden = NO;
    self.previousButton.hidden = YES;
    self.presentTime.hidden = YES;
    self.totalTime.hidden = YES;
    self.repeatButton.hidden = YES;
    self.shuffleButton.hidden = YES;
    self.toggleButton.hidden = YES;
    self.frame = CGRectMake(0, PL_SCREEN_SIZE.height - 144, PL_SCREEN_SIZE.width, 80);
    
    //更换播放按钮的位置和图片
    _playButton.frame = CGRectMake(PL_SCREEN_SIZE.width / 3 * 2 - 15, 30, 78, 42);
    [_playButton setImage:[UIImage imageNamed:@"home_play"] forState:UIControlStateNormal];
    [_playButton setImage:[UIImage imageNamed:@"home_pause"] forState:UIControlStateSelected];
    
    //更换下一曲的位置和图片
    _nextButton.frame = CGRectMake(PL_SCREEN_SIZE.width / 3 * 2 + 40, 27, 48, 48);
    [_nextButton setImage:[UIImage imageNamed:@"home_next"] forState:UIControlStateNormal];

    //更换slider位置
    _slider.frame = CGRectMake(120, 15, PL_SCREEN_SIZE.width - 140, 2);
}

#pragma mark -----Button-----
//跳转到歌手界面
- (void)singerButtonAction:(UIButton *)btn {
    PLLyricsViewController *plLyrics = [[PLLyricsViewController alloc] init];
    PLLocalMusicInfo *presentPlaySong = [self.plLocalMusicInfoArray objectAtIndex:self.plCurrentIndex];
    
    plLyrics.navigationItem.title = [NSString stringWithFormat:@"%@-%@",presentPlaySong.singerName, presentPlaySong.songName];
    [self.navc pushViewController:plLyrics animated:YES];
}

#pragma mark ------play-------
/**
 播放
 */
- (void)playButtonAction:(UIButton *)btn {
    if (self.playButton.selected == NO) {
        self.playButton.selected = YES;
        
        if (self.player) {
            
            //播放
            [self.player play];
            
            //开启定时器
            [self.playTimer setFireDate:[NSDate distantPast]];
            
        } else {
            //初始化一个播放器
            [self setUpPlayer];
            
            //开启定时器
            [self.playTimer setFireDate:[NSDate distantPast]];
        }
        
    } else {
        //切换按键
        self.playButton.selected = NO;
        
        //停止播放
        [self.player stop];
        
        //使定时器无效
        [self.playTimer setFireDate:[NSDate distantFuture]];
        
        //保留现在的时间
        self.currentTime = self.player.currentTime;
    }

}

/**
 上一曲
 */
- (void)preViousButtonAction:(UIButton *)btn {
    //暂停并清空播放器
    [self.player pause];
    self.player = nil;
    
    //删除本地文件
    [self plDeleteNetMusicToSaveSpace];
    
    //上一曲
    if (self.toggleButton.selected == YES) {
        self.plCurrentIndex--;
        if (self.plCurrentIndex == 0) {
            self.plCurrentIndex = self.plLocalMusicInfoArray.count - 1;
        }
    } else if (self.repeatButton.selected == YES){
        self.plCurrentIndex = self.plCurrentIndex;
    } else if (self.shuffleButton.selected == YES) {
        while (1) {
            if (self.plLocalMusicInfoArray.count == 1) {
                self.plCurrentIndex = 0;
                break;
            }
            
            NSInteger tempIndex = arc4random() % self.plLocalMusicInfoArray.count;
            
            if (tempIndex != self.plCurrentIndex && self.plLocalMusicInfoArray.count != 0) {
                self.plCurrentIndex = tempIndex;
                break;
            }
        }
    }
    
    self.currentTime = 0;
    [self setUpPlayer];
}

/**
 下一曲
 */
- (void)nextButtonAction:(UIButton *)btn {
    
    //暂停并清空播放器
    [self.player pause];
    self.player = nil;
    
    //删除本地文件
    [self plDeleteNetMusicToSaveSpace];
    
    //下一曲
    if (self.toggleButton.selected == YES) {
        self.plCurrentIndex++;
        if (self.plCurrentIndex == self.plLocalMusicInfoArray.count) {
            self.plCurrentIndex = 0;
        }
    } else if (self.repeatButton.selected == YES){
        self.plCurrentIndex = self.plCurrentIndex;
    } else if (self.shuffleButton.selected == YES) {
        while (1) {
            NSInteger tempIndex = arc4random() % self.plLocalMusicInfoArray.count;
            if (tempIndex != self.plCurrentIndex) {
                self.plCurrentIndex = tempIndex;
                break;
            }
        }
    }
    
    self.currentTime = 0;
    [self setUpPlayer];
}


#pragma mark ------setPlayer-----
/**
 实例化播放器
 */
- (void)setUpPlayer {

    PLNetMusicInfo *presentPlaySong = [self.plLocalMusicInfoArray objectAtIndex:self.plCurrentIndex];
    
    //更换歌手名字和歌曲名字
    [self plChangeToolBarSingerName];
    
    //如果为本地过来的歌曲
    if (self.localOrNetMusic == NO) {
        
        //判断本地是否有缓存
        if (presentPlaySong.musicPath == nil) {
            //1.获取本地文件的路径
            NSString *path = [[NSBundle mainBundle] pathForResource:[NSString stringWithFormat:@"%@ - %@", presentPlaySong.singerName, presentPlaySong.songName] ofType:@"mp3"];
            
            //调用相同的部分
            [self plSetUpAMusicAudioPlayerWithMusicPath:path];
            
        } else {
            NSString *path = [PL_MUSIC_PATH stringByAppendingFormat:@"/Music/%@",presentPlaySong.musicPath];
            [self plSetUpAMusicAudioPlayerWithMusicPath:path];
        }
    } else {
        
        if (presentPlaySong.musicPath != nil) {
            
            //查找该歌曲
            NSString *path = [PL_MUSIC_PATH stringByAppendingFormat:@"/Temp/%@ - %@",presentPlaySong.singerName,presentPlaySong.songName];
            //直接创建播放器
            [self plSetUpAMusicAudioPlayerWithMusicPath:path];
            
        } else {
            //去请求播放资源
            if ([PLNetinterface plGetSimpleOfNetinterfaceAddress].musicPlayBlock == nil) {
                [[PLNetinterface plGetSimpleOfNetinterfaceAddress] setMusicPlayBlock:^(NSDictionary *dictionary) {
                    
                    //1.开辟一个组
                    dispatch_group_t musicGroup = dispatch_group_create();
                    
                    //2.开辟一个队列
                    dispatch_queue_t musicQueue = dispatch_queue_create(0, 0);
                    
                    dispatch_group_async(musicGroup, musicQueue, ^{
                        //1.请求该歌曲的数据
                        NSData *data = [NSData dataWithContentsOfURL:[NSURL URLWithString:[dictionary objectForKey:@"url"]]];
                        
                        //2.把歌曲写入指定的目录下
                        [data writeToFile:[PL_MUSIC_PATH stringByAppendingFormat:@"/Temp/%@ - %@",presentPlaySong.singerName,presentPlaySong.songName] atomically:NO];
                        
//                        NSLog(@"%@",[PL_MUSIC_PATH stringByAppendingFormat:@"/Temp/%@ - %@",presentPlaySong.singerName,presentPlaySong.songName]);
                        
                        //3.为当前歌曲赋路径,表示已经下载过了
                        presentPlaySong.musicPath = [NSString stringWithFormat:@"/Temp/%@ - %@",presentPlaySong.singerName,presentPlaySong.songName];
                        
                        dispatch_async(dispatch_get_main_queue(), ^{
                            [self plSetUpAMusicAudioPlayerWithMusicPath:[PL_MUSIC_PATH stringByAppendingFormat:@"%@",presentPlaySong.musicPath]];
                        });
                        
                        });
                    
//                    dispatch_group_notify(musicGroup, musicQueue, ^{
//                        [self plSetUpAMusicAudioPlayerWithMusicPath:[PL_MUSIC_PATH stringByAppendingFormat:@"/Temp/%@",presentPlaySong.musicPath]];
//                    });
                    
                }];
                
                //请求资源
                [[PLNetinterface plGetSimpleOfNetinterfaceAddress] plRequestMusicPlayInfoWithHash:presentPlaySong.musicHash];
            }
        }
    }
}

/**
 音乐播放相同的部分
 */
- (void)plSetUpAMusicAudioPlayerWithMusicPath:(NSString *)path {
    //设置播放按钮的状态
    self.playButton.selected = YES;
    
    //将路径转化为url
    NSURL *pathUrl = [NSURL fileURLWithPath:path];
    
    //实例化一个音乐播放器
    //表示本地音频文件的路径
    self.player = [[AVAudioPlayer alloc] initWithContentsOfURL:pathUrl error:nil];
    
    //初始化一个播放器时,设置当前时间,如果属性当前时间有值,意味着是暂停了播放后继续,否则设定为播放新的歌曲或者自动播放下一首   滑动器使用
    if (self.currentTime) {
        self.player.currentTime = self.currentTime;
    }
    
    //预播放
    [self.player prepareToPlay];
    
    //播放
    [self.player play];
    
    self.player.delegate = self;
    
    //更改主线程属性的值
    self.isNeedPostNotification = YES;
}

#pragma mark ------sliderPlayTime------
- (void)sliderPlayCurrentTimeSet {
    
    //如果已经初始化了一个播放器,则设置播放时间等于当前滑动值和总时间的乘积,否则不让滑动
    if (self.player) {
        self.currentTime = self.slider.value * self.player.duration;
        [self setUpPlayer];
    } else {
        self.slider.value = 0;
    }
}

#pragma mark -----timer------
- (void)upDataOfSliderValue {
    
    //设置时间格式
    self.totalTime.text = [NSString stringWithFormat:@"%.0f:%.2ld", self.player.duration / 60, (NSInteger)self.player.duration % 60];
    
    //不断更新slider的值  现在的时间/总时间
    self.slider.value = self.player.currentTime / self.player.duration;
    
    //更新当前时间Label的值
    NSString *presentTime = [NSString stringWithFormat:@"%.0f:%.2ld", self.player.currentTime / 60, (NSInteger)self.player.currentTime % 60];
    
    self.presentTime.text = presentTime;
}

#pragma mark -----懒加载-----
- (NSMutableArray *)plLocalMusicInfoArray {
    if (_plLocalMusicInfoArray == nil) {
        _plLocalMusicInfoArray = [NSMutableArray array];
    }
    return _plLocalMusicInfoArray;
}

#pragma mark ------playModel------
/**
 更换模式
 */
- (void)plModelToggle:(UIButton *)btn {
    if (btn == _toggleButton) {
        _toggleButton.hidden = YES;
        _toggleButton.selected = NO;
        _repeatButton.hidden = NO;
        _repeatButton.selected = YES;
    } else if (btn == _repeatButton) {
        _repeatButton.hidden = YES;
        _repeatButton.selected = NO;
        _shuffleButton.hidden = NO;
        _shuffleButton.selected = YES;
    } else if (btn == _shuffleButton) {
        _shuffleButton.hidden = YES;
        _shuffleButton.selected = NO;
        _toggleButton.hidden = NO;
        _toggleButton.selected = YES;
    }
}

#pragma mark -----playName-----
/**
 更改工具栏的歌手和歌曲名字
 */
- (void)plChangeToolBarSingerName {
    PLNetMusicInfo *presentPlaySong = [self.plLocalMusicInfoArray objectAtIndex:self.plCurrentIndex];
    
    _singerName.text = presentPlaySong.singerName;
    _songName.text = presentPlaySong.songName;
}

#pragma mark -----playDelegate-----
- (void)audioPlayerDidFinishPlaying:(AVAudioPlayer *)player successfully:(BOOL)flag {
    [self nextButtonAction:_nextButton];
}


#pragma mark ---清除一个音乐文件----
/**
 清除一个音乐文件
 */
- (void)plDeleteNetMusicToSaveSpace {
    if (!self.localOrNetMusic) {
        //本地音乐不能删除
        return;
    }
    
    //删除该文件
    PLNetMusicInfo *plMusic = [self.plLocalMusicInfoArray objectAtIndex:self.plCurrentIndex];
    
    NSString *path = [PL_MUSIC_PATH stringByAppendingFormat:@"%@",plMusic.musicPath];
    
    if ([[NSFileManager defaultManager] fileExistsAtPath:path]) {
        //删除
        [[NSFileManager defaultManager] removeItemAtPath:path error:nil];
        
        plMusic.musicPath = nil;
    }
}
@end
