//
//  PLLyricsViewController.m
//  GraduationProject
//
//  Created by qianfeng on 16/4/13.
//  Copyright (c) 2016年 qianfeng. All rights reserved.
//

#import "PLLyricsViewController.h"
#import "PLLyricsCollectionViewCell.h"

@interface PLLyricsViewController () <UICollectionViewDelegateFlowLayout, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout> {
    UICollectionView *_collectionView;
    //歌手背景图
    UIImageView *_singerImageView;
    
    //歌词相关数组
    NSMutableArray *_lyricsDataArray;
    NSMutableArray *_lyricsWidthArray;
    NSMutableArray *_lyricsTimeArray;
    
    //标记是否喜欢
    UIButton *_isLikeItem;
    //当前正在播放的歌曲
    PLNetMusicInfo * _presentPlayMusic;
    
    //定时器
    NSTimer *_timer;
    //当前展示歌词的下标
    NSInteger _currentItem;
    //数据查找
    PLNetinterface *_netinterface;
    
}

@property (nonatomic, strong) NSMutableArray *lyricsDataArray;
@property (nonatomic, strong) NSMutableArray *lyricsWidthArray;
@property (nonatomic, strong) NSMutableArray *lyricsTimeArray;

@end

@implementation PLLyricsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    //添加歌手写真的背景图
    [self createSingerBackgroundImage];
    
    //添加导航栏
    self.toolBar = [PLHomeToolBar plHomeToolBar];
    
    //创建导航栏item
    [self createNavigationItem];
    
    //创建CollectionCollectionView
    [self createCollectionView];
    
    //添加定时器
    _timer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(plChangeLyricsLocationAndCollection) userInfo:nil repeats:YES];
    
    //先不让定时器工作
    [_timer setFireDate:[NSDate distantFuture]];
    
    //添加一个监控
    [_toolBar addObserver:self forKeyPath:@"isNeedPostNotification" options:NSKeyValueObservingOptionNew context:(void *)"isNeedPostNotification"];
    
    //添加长按手势
    [self addLongPressGestureRecognizer];
    
}

#pragma mark ------- 添加歌手背景图 -------
- (void)createSingerBackgroundImage {
    _singerImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, (PL_SCREEN_SIZE.height - PL_SCREEN_SIZE.width - 184) / 2.0, PL_SCREEN_SIZE.width, PL_SCREEN_SIZE.width)];
    _singerImageView.layer.cornerRadius = PL_SCREEN_SIZE.width / 2;
    _singerImageView.clipsToBounds = YES;
    _singerImageView.alpha = 0.8;
    _singerImageView.userInteractionEnabled = YES;
    [self.view addSubview:_singerImageView];
    
}

#pragma mark -----createCollectionView------
- (void)createCollectionView {
    //布局
     UICollectionViewFlowLayout *plLayout = [[UICollectionViewFlowLayout alloc] init];
    //设置item的大小
    plLayout.itemSize = CGSizeMake(PL_SCREEN_SIZE.width, 20);
    //指定空隙 整组内容的周边空隙
    plLayout.sectionInset = UIEdgeInsetsMake(10, 0, 10, 0);
    //设置最小行间距
    plLayout.minimumLineSpacing = 10;
    //设置最小横行间距
    plLayout.minimumInteritemSpacing = 0;
    
    //创建cellocs视图
//    _collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, (PL_SCREEN_SIZE.height - PL_SCREEN_SIZE.width - 184) / 2.0, PL_SCREEN_SIZE.width, PL_SCREEN_SIZE.width) collectionViewLayout:plLayout];
    _collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 20, PL_SCREEN_SIZE.width, PL_SCREEN_SIZE.width - 40) collectionViewLayout:plLayout];
    _collectionView.dataSource = self;
    _collectionView.delegate = self;
    _collectionView.backgroundColor = [UIColor clearColor];
//    _collectionView.userInteractionEnabled = NO;
    
    //隐藏滚动视图
    _collectionView.showsVerticalScrollIndicator = NO;
    _collectionView.showsHorizontalScrollIndicator = NO;
    
    [_collectionView registerClass:[PLLyricsCollectionViewCell class] forCellWithReuseIdentifier:@"lyricsCell"];
    
    [_singerImageView addSubview:_collectionView];

}

#pragma mark -----NavigationItem-----
/**
 创建导航栏相关视图
 */
- (void)createNavigationItem {
    
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 70, 44)];
    
    //下载按钮
    UIButton *downButton = [UIButton buttonWithType:UIButtonTypeCustom];
    downButton.frame = CGRectMake(10, 10, 30, 30);
    [downButton addTarget:self action:@selector(downloadPresentMusic) forControlEvents:UIControlEventTouchUpInside];
    UIImage *image = [UIImage imageNamed:@"play_down"];
    [downButton setImage:image forState:UIControlStateNormal];
    [view addSubview:downButton];
    
    //喜欢
    _isLikeItem = [UIButton buttonWithType:UIButtonTypeCustom];
    _isLikeItem.frame = CGRectMake(30, 2, 40, 40);
    [_isLikeItem addTarget:self action:@selector(plSetLikeOrCancelLike) forControlEvents:UIControlEventTouchUpInside];
    [_isLikeItem setImage:[UIImage imageNamed:@"play_unlike"] forState:UIControlStateNormal];
    [_isLikeItem setImage:[UIImage imageNamed:@"play_like"] forState:UIControlStateSelected];
    [view addSubview:_isLikeItem];
    
    if (_presentPlayMusic == nil) {
        
    } else if ([_presentPlayMusic.isLike isEqualToNumber:@1]) {
        _isLikeItem.selected = YES;
    } else {
        
    }
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:view];
}

#pragma mark ----下载正在播放的歌曲----
/**
 下载正在播放的歌曲
 */
- (void)downloadPresentMusic {
    
    NSInteger number = [self plSearchMusicNumber];
    
    //如果该文件不存在,则直接进行保存
    if (number == 0) {
        
        //保存该歌曲
        [self plDownLoadMusicAndSaveToLocalWithNumber:0];
        
    } else {
        //弹出警告框,告诉本地已经有该歌曲了,无须再次下载或者删除原来的,下载新的
        [self plSaveFailAlertWithNumber:number];
    }
}

/**
 返回一个歌曲的数字number
 */
- (NSInteger)plSearchMusicNumber {
    //查找当前歌曲
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"singerName = %@ and songName = %@", _presentPlayMusic.singerName, _presentPlayMusic.songName];
    
    //查询所有本地歌曲
    NSArray *array = [PLLocalMusicInfo MR_findAllWithPredicate:predicate];
    if (array.count >= 1) {
        if (array.count == 1) {
            return 1;
        } else {
            
            NSInteger i = 1;
            
            //遍历数组
            for (; i <= array.count; i++) {
                PLLocalMusicInfo *plMusic = [array objectAtIndex:i];
                NSString *tempStr = [NSString stringWithFormat:@"%@ - %@%ld", plMusic.singerName, plMusic.songName, i];
                if ([tempStr isEqualToString:plMusic.musicPath]) {
                    return i + 1;
                }
            }
            
            return i;
        }
    }
    
    return 0;
}

#pragma mark ----下载一首歌曲----
/**
 下载一首歌曲
 */
- (void)plDownLoadMusicAndSaveToLocalWithNumber:(NSInteger)number {
    
    //创建一个实体
    PLLocalMusicInfo *plMusic = [PLLocalMusicInfo MR_createEntity];
    plMusic.albumName = _presentPlayMusic.albumName;
    plMusic.isnew = _presentPlayMusic.isnew;
    plMusic.isLike = @NO;
    plMusic.musicDuration = _presentPlayMusic.musicDuration;
    plMusic.musicHash = _presentPlayMusic.musicHash;
    plMusic.singerName = _presentPlayMusic.singerName;
    plMusic.songName = _presentPlayMusic.songName;
    plMusic.singerImage = _presentPlayMusic.singerImage;
    plMusic.songLyrics = _presentPlayMusic.songLyrics;
    
    if (_presentPlayMusic.musicPath.length != 0) {
        //拷贝该文件
        NSString *beginPath = [PL_MUSIC_PATH stringByAppendingFormat:@"%@",_presentPlayMusic.musicPath];
        NSString *endPath = nil;
        
        if (number == 0) {
            endPath = [PL_MUSIC_PATH stringByAppendingFormat:@"/Music/%@ - %@",_presentPlayMusic.singerName, _presentPlayMusic.songName];
            
            if ([[NSFileManager defaultManager] copyItemAtPath:beginPath toPath:endPath error:nil]) {
                plMusic.musicPath = [NSString stringWithFormat:@"%@ - %@",_presentPlayMusic.singerName, _presentPlayMusic.songName];
            }
        } else {
            endPath = [PL_MUSIC_PATH stringByAppendingFormat:@"/Music/%@ - %@%ld",_presentPlayMusic.singerName, _presentPlayMusic.songName, number];
            
            if ([[NSFileManager defaultManager] copyItemAtPath:beginPath toPath:endPath error:nil]) {
                plMusic.musicPath = [NSString stringWithFormat:@"%@ - %@%ld",_presentPlayMusic.singerName, _presentPlayMusic.songName,number];
            }
        }
        
    }
    
    //保存本次操作
    [[NSManagedObjectContext MR_defaultContext] MR_saveToPersistentStoreAndWait];

}

/**
 假如已经保存过了,保存新的
 */
- (void)plSaveFailAlertWithNumber:(NSInteger)number {
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"保存失败" message:@"这首歌曲已经存在了,你要保留新的(OK)或者保留两份(ALL)" preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        //保留最新的
        
        //1.先删除本地的实体对象
        
        //查找当前歌曲
        NSPredicate *predicate = [NSPredicate predicateWithFormat:@"singerName = %@ and songName = %@", _presentPlayMusic.singerName, _presentPlayMusic.songName];
        
        //查询所有本地歌曲
        NSArray *array = [PLLocalMusicInfo MR_findAllWithPredicate:predicate];
        
        PLLocalMusicInfo *plMusic = [array objectAtIndex:number - 1];
        
        //先保存一份路径
        NSString *tempPath = plMusic.musicPath;
        
        //删除
        [plMusic MR_deleteEntity];
        [[NSManagedObjectContext MR_defaultContext] MR_saveToPersistentStoreAndWait];
        
        NSString *path = [PL_MUSIC_PATH stringByAppendingFormat:@"/Music/%@",tempPath];
        
        //删除本地文件
        [[NSFileManager defaultManager] removeItemAtPath:path error:nil];
        
        //再次保存新的文件
        [self plDownLoadMusicAndSaveToLocalWithNumber:number - 1];
    }];
    
    UIAlertAction *allAction = [UIAlertAction actionWithTitle:@"ALL" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        
        //保留两份
        [self plDownLoadMusicAndSaveToLocalWithNumber:number];
    }];
    
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        
        //查找该歌曲
        
    }];
    
    [alert addAction:okAction];
    [alert addAction:allAction];
    [alert addAction:cancelAction];
    
    [self presentViewController:alert animated:YES completion:nil];
}

#pragma mark -----viewWillAppear-----
- (void)viewWillAppear:(BOOL)animated {
    
    //在这个页面出现的时候 改变导航栏的样式
    self.toolBar = [PLHomeToolBar plHomeToolBar];
    
    [self.toolBar plChangeToolBarButton];
    [self.view addSubview:self.toolBar];
    
    //在视图要出现的时候,更改当前播放的歌曲
     _presentPlayMusic = [_toolBar.plLocalMusicInfoArray objectAtIndex:_toolBar.plCurrentIndex];
    
    //为请求赋值
    _netinterface = [PLNetinterface plGetSimpleOfNetinterfaceAddress];
    
    [self plChangeLyricsViewSomeAttribute];
}

#pragma mark -----viewWillDisApper-----
- (void)viewWillDisappear:(BOOL)animated {
    //在这个页面消失的时候 还原导航栏的样式
    [self.toolBar plRecoverToolBarButton];
}

#pragma mark -----datasourceAndDelegate-----
/**
 视图相关
 */
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    
    return self.lyricsDataArray.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {

    PLLyricsCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"lyricsCell" forIndexPath:indexPath];
    
    if (indexPath.item == _currentItem) {
        cell.textLabel.textColor = [UIColor yellowColor];
        cell.textLabel.font = [UIFont boldSystemFontOfSize:20];
    } else {
        cell.textLabel.textColor = [UIColor whiteColor];
        cell.textLabel.font = [UIFont systemFontOfSize:15];
    }
    
    cell.textLabel.text = [_lyricsDataArray objectAtIndex:indexPath.row];
    
    
    return cell;
}

//item大小
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    CGFloat width = [[self.lyricsWidthArray objectAtIndex:indexPath.item] floatValue];
    if (width <= PL_SCREEN_SIZE.width) {
        return CGSizeMake(PL_SCREEN_SIZE.width, 20);
    }
    return CGSizeMake(width, 20);
}

//选中时的改变
- (BOOL)collectionView:(UICollectionView *)collectionView shouldDeselectItemAtIndexPath:(NSIndexPath *)indexPath {
    //不允许选中
    return NO;
}

//改变起始位置和结束位置的整体大小
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout referenceSizeForFooterInSection:(NSInteger)section {
    return CGSizeMake(PL_SCREEN_SIZE.width, collectionView.bounds.size.height / 2.0);
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section {
    return CGSizeMake(PL_SCREEN_SIZE.width, collectionView.bounds.size.height / 2.0);
}

#pragma mark ------plArray------

//懒加载三个数组
- (NSMutableArray *)lyricsDataArray {
    if (_lyricsDataArray == nil) {
        _lyricsDataArray = [NSMutableArray array];
    }
    return _lyricsDataArray;
}

- (NSMutableArray *)lyricsWidthArray {
    if (_lyricsWidthArray == nil) {
        _lyricsWidthArray = [NSMutableArray array];
    }
    return _lyricsWidthArray;
}

- (NSMutableArray *)lyricsTimeArray {
    if (_lyricsTimeArray == nil) {
        _lyricsTimeArray = [NSMutableArray array];
    }
    return _lyricsTimeArray;
}

#pragma mark -----通知------
/**
 接收到通知之后需要更改的数据
 */
- (void)plChangeLyricsViewSomeAttribute {
    
    //先停止定时器
    [_timer setFireDate:[NSDate distantFuture]];

    //获取当前播放的歌曲
    _presentPlayMusic = [[PLHomeToolBar plHomeToolBar].plLocalMusicInfoArray objectAtIndex:[PLHomeToolBar plHomeToolBar].plCurrentIndex];
    
    
    //更改导航栏的歌曲名字
    self.navigationItem.title = [NSString stringWithFormat:@"%@ - %@", _presentPlayMusic.singerName, _presentPlayMusic.songName];
    
    //更换喜欢按钮的图片
    if ([_presentPlayMusic.isLike isEqualToNumber:@1]) {
        _isLikeItem.selected = YES;
    } else {
        _isLikeItem.selected = NO;
    }
    
    //弱引用
    __weak typeof(self) weakSelf = self;
    
    //刷新歌词 （如果存在）  不存在去请求
    if (!_presentPlayMusic.songLyrics) {
        
        //先去请求,请求成功后,更换歌词
        if (_netinterface == nil) {
            _netinterface = [PLNetinterface plGetSimpleOfNetinterfaceAddress];
        }
        
          //如果hash为空,先去请求hash;
        if (_presentPlayMusic.musicHash == nil) {
            if (_netinterface.musicQueryBlock == nil) {
                //返回执行的block
                [_netinterface setMusicQueryBlock:^(NSArray *array) {
                    
                    //作为标志,是否调用第一首歌词
                    BOOL flag = NO;
                    
                    //判断有没有歌词,应该请求哪一首
                    if (array.count == 0) {
                        
                    } else if (array.count == 1) {
                        [weakSelf plSavePresentHashIfRequestIsSuccess:array.firstObject];
                    } else if (array.count >= 2) {
                        NSInteger timeNumber = _toolBar.player.duration;
                        
                        for (NSDictionary *dict in array) {
                            NSNumber *tempTimeNumber = [dict objectForKey:@"duration"];
                            
                            NSInteger i = 0;
                            
                            for (; i < 20; i++) {
                                //如果有直接相等的,直接请求  否则,找寻差值在 -10 --- 10 以内的
                                if ([@(timeNumber + i) isEqualToNumber:tempTimeNumber]) {
                                    break;
                                } else if ([@(timeNumber - i) isEqualToNumber:tempTimeNumber]) {
                                    break;
                                }
                            }
                            
                            if (i != 20) {
                                flag = YES;
                                [self plSavePresentHashIfRequestIsSuccess:dict];
                                break;
                            }
                        }
                    }
                    
                    //如果为真,表示可以调用请求方法
                    if (flag) {
                        [weakSelf plSavePresentHashIfRequestIsSuccess:array.firstObject];
                    }
                    
                    //调用请求歌词方法
                    [self plRequestLyrics];

                }];
                
                //请求音乐资源
                [_netinterface plRequestMusicQueryWithName:[NSString stringWithFormat:@"%@ - %@",_presentPlayMusic.singerName, _presentPlayMusic.songName] andSize:10 andPage:1];
            }
            
        } else {  //hash不为空
            //直接请求
            [self plRequestLyrics];
        }
        
    } else {  //如果本地歌词存在
        [self plLoadAndChangePresentMusicInfoLyrice];
    }
    
    //刷新歌手写真,如果存在,加载,否则,去请求
    if (_presentPlayMusic.singerImage) {
        [_singerImageView sd_setImageWithURL:[NSURL URLWithString:_presentPlayMusic.singerImage]];
    } else {
        
        //确保可以获得单例
        if (_netinterface == nil) {
            _netinterface = [PLNetinterface plGetSimpleOfNetinterfaceAddress];
        }
        
        //确保歌手当前的block为空
        if (_netinterface.musicSingerBlock == nil) {
            //为block赋值
            [_netinterface setMusicSingerBlock:^(NSDictionary *dictionary) {
                //请求成功之后的回调
                
                //保存
                [weakSelf plSavePresentSingerImageIfRequestIsSuccess:dictionary];
                
                //更改当前的歌手写真
                [_singerImageView sd_setImageWithURL:[NSURL URLWithString:_presentPlayMusic.singerImage]];
            }];
            
            [_netinterface plRequestMusicQueryWithSingerName:_presentPlayMusic.singerName];
        }
    }
}

/**
 请求歌词的执行方法
 */
- (void)plRequestLyrics {
    if (_netinterface.musicLyricsBlock == nil) {
        //弱引用
        __weak typeof(self) weakSelf = self;
        
        //歌词请求成功之后的回调
        [_netinterface setMusicLyricsBlock:^(NSDictionary *dictionary) {
            //保存在本地
            [weakSelf plSavePresentLyricsIfRequestIsSuccess:dictionary];
            //刷新界面歌词显示
            [weakSelf plLoadAndChangePresentMusicInfoLyrice];
        }];
        
        //请求歌词
        [_netinterface plRequestMusicQueryWithMusicName:[NSString stringWithFormat:@"%@ - %@",_presentPlayMusic.singerName, _presentPlayMusic.songName] andHash:_presentPlayMusic.musicHash andTime:_presentPlayMusic.musicDuration];
    }
 }

/**
 定时器的选择器方法
 */
- (void)plChangeLyricsLocationAndCollection {

    NSInteger i = 0;
    
    for (; i < self.lyricsTimeArray.count; i++) {
        double time = [[self.lyricsTimeArray objectAtIndex:i] doubleValue];
        if (_toolBar.player.currentTime <= time) {
            break;
        }
    }
    
    _currentItem = i;
    
    if (_currentItem <= self.lyricsTimeArray.count) {
        
        
        NSIndexPath *indexPath = [NSIndexPath indexPathForItem:_currentItem inSection:0];
        
        [_collectionView scrollToItemAtIndexPath:indexPath atScrollPosition:UICollectionViewScrollPositionCenteredVertically animated:YES];
        
        [_collectionView reloadData];
    }
}

#pragma mark ----- 数据库操作 -------
/**
 设置取消或者喜欢一首歌曲
 */
- (void)plSetLikeOrCancelLike {
    //修改页面显示的图片
    //更换喜欢按钮的图片
    
    if (_isLikeItem.selected == NO) {
        _isLikeItem.selected = YES;
    } else {
        _isLikeItem.selected = NO;
    }
    
    //查找数据库得到该歌曲
    PLLocalMusicInfo *plMusic = [PLLocalMusicInfo MR_findAllWithPredicate:[NSPredicate predicateWithFormat:@"musicPath = %@", _presentPlayMusic.musicPath]].firstObject;
    
    if (plMusic == nil) {
        return;
    }
    
    //修改数据
    if ([plMusic.isLike isEqualToNumber:@0]) {
        plMusic.isLike = @1;
    } else {
        plMusic.isLike = @0;
    }
    
    //保存本次操作
    [[NSManagedObjectContext MR_defaultContext] MR_saveToPersistentStoreAndWait];
}

/**
 请求成功后保存当前歌曲的hash
 */
- (void)plSavePresentHashIfRequestIsSuccess:(NSDictionary *)dictionary {
    //查找数据库得到该歌曲
    PLLocalMusicInfo *plMusic = [PLLocalMusicInfo MR_findAllWithPredicate:[NSPredicate predicateWithFormat:@"songName = %@ and singerName = %@", _presentPlayMusic.songName, _presentPlayMusic.singerName]].firstObject;
    
    //修改数据
    _presentPlayMusic.musicHash = [dictionary objectForKey:@"hash"];
    _presentPlayMusic.musicDuration = [dictionary objectForKey:@"duration"];
    
    if (plMusic == nil) {
        return;
    }
    
    plMusic.musicHash = [dictionary objectForKey:@"hash"];
    plMusic.musicDuration = [dictionary objectForKey:@"duration"];
    
    //保存本次操作
    [[NSManagedObjectContext MR_defaultContext] MR_saveToPersistentStoreAndWait];
}

/**
 请求成功后保存当前歌词
 */
- (void)plSavePresentLyricsIfRequestIsSuccess:(NSDictionary *)dictionary {
    //查找数据库得到该歌曲
    PLLocalMusicInfo *plMusic = [PLLocalMusicInfo MR_findAllWithPredicate:[NSPredicate predicateWithFormat:@"songName = %@ and singerName = %@", _presentPlayMusic.songName, _presentPlayMusic.singerName]].firstObject;
    
    //修改当前播放歌曲的数据
    _presentPlayMusic.songLyrics = [dictionary objectForKey:@"content"];
    
    //如果本地没有找到,返回
    if (plMusic == nil) {
        return;
    }
    
    //修改数据
    plMusic.songLyrics = [dictionary objectForKey:@"content"];
    
    //保存本次操作
    [[NSManagedObjectContext MR_defaultContext] MR_saveToPersistentStoreAndWait];
}

/**
 请求成功后保存当前歌手的写真
 */
- (void)plSavePresentSingerImageIfRequestIsSuccess:(NSDictionary *)dictionary {
    
    //查找数据库得到该歌曲
    NSArray * plSingerMusic = [PLLocalMusicInfo MR_findAllWithPredicate:[NSPredicate predicateWithFormat:@"singerName = %@", _presentPlayMusic.singerName]];
    
    //修改当前播放歌曲的数据
    _presentPlayMusic.singerImage = [dictionary objectForKey:@"image"];
    
    if (plSingerMusic.count == 0) {
        
        return;
    }
    
    for (PLLocalMusicInfo *plMusic in plSingerMusic) {
        //修改数据
        plMusic.singerImage = [dictionary objectForKey:@"image"];
        
        //保存本次操作
        [[NSManagedObjectContext MR_defaultContext] MR_saveToPersistentStoreAndWait];
    }
}


#pragma mark -------加载当前歌曲的歌词------
/**
 更改或加载当前歌曲的歌词
 */
- (void)plLoadAndChangePresentMusicInfoLyrice {
    // 清空各个数组的内容,以便再次加入歌词
    [self.lyricsDataArray removeAllObjects];
    [self.lyricsTimeArray removeAllObjects];
    [self.lyricsWidthArray removeAllObjects];
    
    //先刷新一遍数据
    [_collectionView reloadData];
    
    //处理歌词数据
    NSArray *array = [[NSString stringWithFormat:@"%@\r\n%@",@"卿颜淡墨",_presentPlayMusic.songLyrics] componentsSeparatedByString:@"\r\n"];
    NSMutableArray *tempArray = [NSMutableArray arrayWithArray:array];
    [tempArray removeLastObject];
    for (NSString *temp in tempArray) {
        if ([temp isEqualToString:@"卿颜淡墨"]) {
            [self.lyricsDataArray addObject:temp];
            CGSize size = [@"卿颜淡墨" sizeWithAttributes:@{NSFontAttributeName : [UIFont systemFontOfSize:15]}];
            [self.lyricsWidthArray addObject:@(size.width)];
        } else {
        double time1 = [[temp substringWithRange:NSMakeRange(1, 2)] doubleValue];
        double time2 = [[temp substringWithRange:NSMakeRange(4, 5)] doubleValue];
        double time = time1 * 60 + time2;
        [self.lyricsTimeArray addObject:@(time)];
        NSString *dataStr = [temp substringFromIndex:10];
        [self.lyricsDataArray addObject:dataStr];
        CGSize size = [dataStr sizeWithAttributes:@{NSFontAttributeName : [UIFont systemFontOfSize:17]}];
        [self.lyricsWidthArray addObject:@(size.width)];
        }
    }
    
    //处理歌词完成后刷新数据
    [_collectionView reloadData];
    
    //开启定时器用于刷新歌词
    [_timer setFireDate:[NSDate distantPast]];
}

#pragma mark ----- 添加长按手势 ------
- (void)addLongPressGestureRecognizer {
    UILongPressGestureRecognizer *longPressGestureRecognizer = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(plLongPressAction:)];
    
    longPressGestureRecognizer.minimumPressDuration = 2;
    
    [_singerImageView addGestureRecognizer:longPressGestureRecognizer];
}

/**
 长按操作
 */
- (void)plLongPressAction:(UILongPressGestureRecognizer *)longPressGestureRecognizer {
    
    //如果没有歌词或者写真,可以长按重新加载
    if (_presentPlayMusic.songLyrics.length == 0) {
        [self plChangeLyricsViewSomeAttribute];
    }
}

#pragma mark ----监听的方法----
//监听
- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context {
    
    BOOL flag = [[change objectForKey:NSKeyValueChangeNewKey] boolValue];
    
    if (flag == YES) {
        //判断歌曲有没有变更
        [self plChangeLyricsViewSomeAttribute];
        _toolBar.isNeedPostNotification = NO;
    }
    
}

@end
