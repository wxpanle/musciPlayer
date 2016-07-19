//
//  PLLocalViewController.m
//  GraduationProject
//
//  Created by qianfeng on 16/4/10.
//  Copyright (c) 2016年 qianfeng. All rights reserved.
//

#import "PLLocalViewController.h"
#import "PLLocalSingleTableViewCell.h"
#import "PLLyricsViewController.h"
#import "MJRefresh.h"

@interface PLLocalViewController () <UITableViewDataSource, UITableViewDelegate> {
    UITableView *_tableView;
    UITextField *_textField;
    UISegmentedControl *_segVC;
    NSMutableArray *_localMusicArray;
}

//数据源数组
@property (nonatomic, strong) NSMutableArray *localMusicArray;

@end

@implementation PLLocalViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    //创建tableView
    [self createTableView];
    
    //创建分段选择器
    [self createSegmentedControl];
    
    //查找数据库为数组添加资源
    [self segCAction];
}

#pragma mark -----UISegmentedControl-----
//创建分段选择器
- (void)createSegmentedControl {
    UIView *view = nil;
    
    view = [self plCreatViewWithFrame:CGRectMake(15, 10, PL_SCREEN_SIZE.width - 30, 30) andAplha:1];
    
    _segVC = [self plCreateSegmentControlWithFrame:CGRectMake(1, 1, PL_SCREEN_SIZE.width - 32, 28) andTitleArray:@[@"单曲", @"歌手", @"专辑", @"文件夹"] andEnabledIndex:3 andSEL:@selector(segCAction)];
    
    [view addSubview:_segVC];
    [self.view addSubview:view];
}


/**
 分段选择器方法
 */
- (void)segCAction {
    
    //移除数组中的所有资源
    [self.localMusicArray removeAllObjects];
    
    //为数组加入资源
    if ([self.navigationItem.title isEqualToString:@"本地音乐"]) {
        //查找数据库为数组添加资源
        
        //歌手搜索
        if (_segVC.selectedSegmentIndex == 1) {
            [self plFindDataAndSortByCondition:@"singerName" andIsLike:NO];
            [_tableView reloadData];
        } else if (_segVC.selectedSegmentIndex == 0) { //歌曲搜索
            [self plFindDataAndSortByCondition:@"songName" andIsLike:NO];
            [_tableView reloadData];
        }
    } else if ([self.navigationItem.title isEqualToString:@"我喜欢"]) {
        //查找数据库为数组添加资源
        if (_segVC.selectedSegmentIndex == 1) {
            [self plFindDataAndSortByCondition:@"singerName" andIsLike:YES];
            [_tableView reloadData];
        } else if (_segVC.selectedSegmentIndex == 0) { //歌曲搜索
            [self plFindDataAndSortByCondition:@"songName" andIsLike:YES];
            [_tableView reloadData];
        }
    }

}

#pragma mark -----tableView-----
//创建tableView
- (void)createTableView {
    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(10, 50, PL_SCREEN_SIZE.width - 20, PL_SCREEN_SIZE.height - 224) style:UITableViewStylePlain];
    _tableView.dataSource = self;
    _tableView.delegate = self;
    _tableView.tableFooterView = [[UIView alloc] init];
    _tableView.backgroundColor = [UIColor clearColor];
    _tableView.editing = NO;
    _tableView.userInteractionEnabled = YES;
    _tableView.showsVerticalScrollIndicator = NO;
    _tableView.separatorColor = [UIColor clearColor];
    [self.view addSubview:_tableView];
    [_tableView registerClass:[PLLocalSingleTableViewCell class] forCellReuseIdentifier:@"single"];
}



#pragma mark -----datasource-----
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.localMusicArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    PLLocalSingleTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"single" forIndexPath:indexPath];
        
    PLLocalMusicInfo *plMusicInfo = [self.localMusicArray objectAtIndex:indexPath.row];
    if (_segVC.selectedSegmentIndex == 0) {
        cell.titleText.text = [NSString stringWithFormat:@"%@ - %@", plMusicInfo.songName, plMusicInfo.singerName];
    } else if (_segVC.selectedSegmentIndex == 1) {
        cell.titleText.text = [NSString stringWithFormat:@"%@ - %@", plMusicInfo.singerName, plMusicInfo.songName];
    }
    
    return cell;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if ([self.navigationItem.title isEqualToString:@"搜索"] || [self.navigationItem.title isEqualToString:@"乐库"]) {
        return;
    }
    //删除操作
    if (editingStyle ==  UITableViewCellEditingStyleDelete) {
        
        //查找当前歌曲的文件路径
        NSArray *dataArray = nil;
        
        //为数组加入资源
        if ([self.navigationItem.title isEqualToString:@"本地音乐"]) {
            //查找数据库为数组添加资源
            
            //歌手搜索
            if (_segVC.selectedSegmentIndex == 1) {
                dataArray = [self plFindDataByCondition:@"singerName" andIsLike:NO];
            } else if (_segVC.selectedSegmentIndex == 0) { //歌曲搜索
                dataArray = [self plFindDataByCondition:@"songName" andIsLike:NO];
            }
        } else if ([self.navigationItem.title isEqualToString:@"我喜欢"]) {
            //查找数据库为数组添加资源
            if (_segVC.selectedSegmentIndex == 1) {
                dataArray = [self plFindDataByCondition:@"singerName" andIsLike:YES];
            } else if (_segVC.selectedSegmentIndex == 0) { //歌曲搜索
                dataArray = [self plFindDataByCondition:@"songName" andIsLike:YES];
            }
        }
        
        
        //找到该歌曲
        PLLocalMusicInfo *plMusic = [dataArray objectAtIndex:indexPath.row];
        if (plMusic.musicPath == nil) {
            
            //退出编辑状态
            [_tableView endEditing:YES];
            
            //工程目录文件不允许删除
            return;
        } else {
            //删除该文件
            NSString *path = plMusic.musicPath;
            
            //删除实体
            [plMusic MR_deleteEntity];
            [[NSManagedObjectContext MR_defaultContext] MR_saveToPersistentStoreAndWait];
            
            //删除文件
            NSString *filePath = [PL_MUSIC_PATH stringByAppendingFormat:@"/Music/%@",path];
            NSLog(@"%@", filePath);
            
            //判断文件是否存在
            if ([[NSFileManager defaultManager] fileExistsAtPath:filePath]) {
                //删除
                [[NSFileManager defaultManager] removeItemAtPath:filePath error:nil];
            }
            
            //将该实体从数组中删除
            [self.localMusicArray removeObjectAtIndex:indexPath.row];
            
            //刷新tableView
            [_tableView reloadData];
        }
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    //点击之后 退出选中状态
    [_tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    if (self.toolBar.player) {
        [self.toolBar.player stop];   //暂停
    }
    //为播放音乐初始化
    
    if (self.toolBar.localOrNetMusic == YES) {
        
        //如果之前为网络数据,清除缓存
        [self.toolBar plDeleteNetMusicToSaveSpace];
    }
    
    //设置播放本地的音乐
    self.toolBar.localOrNetMusic = NO;
    
    //重新为数组赋值
    [self.toolBar.plLocalMusicInfoArray removeAllObjects];
    [self.toolBar.plLocalMusicInfoArray addObjectsFromArray:_localMusicArray];
    
    //设置当前点击的下标,即即将播放的下标
    self.toolBar.plCurrentIndex = indexPath.row;   //播放选中的歌曲
    //清空时间 -- 是否是暂停
    self.toolBar.currentTime = 0;
    
    //实例化播放器
    [self.toolBar setUpPlayer];
    
    //推出歌词界面
    PLLyricsViewController *lyricsVC = [[PLLyricsViewController alloc] init];
    lyricsVC.isLikeOrLoadButton = NO;
    [self.navigationController pushViewController:lyricsVC animated:NO];
}

- (NSString *)tableView:(UITableView *)tableView titleForDeleteConfirmationButtonForRowAtIndexPath:(NSIndexPath *)indexPath {
    return @"删除";
}

#pragma mark ------数据库操作----
/**
 数据库的查询
 */
- (void)plFindDataAndSortByCondition:(NSString *)condition andIsLike:(BOOL)like {
    
    NSArray *dataArray = [self plFindDataByCondition:condition andIsLike:like];
    
    for (PLLocalMusicInfo *localMusicInfo in dataArray) {
        PLNetMusicInfo *netMusicInfo = [PLNetMusicInfo plCreateAndBackNetMusicWithLocalMusic:localMusicInfo];
        
        //添加新的数据
        [self.localMusicArray addObject:netMusicInfo];
    }
}

/**
 查询
 */
- (NSArray *)plFindDataByCondition:(NSString *)condition andIsLike:(BOOL)like {
    NSArray *dataArray = nil;
    
    if (!like) {
        //1.查询所有按名字排序
        dataArray = [PLLocalMusicInfo MR_findAllSortedBy:condition ascending:YES];
    } else {
        NSPredicate *predicate = [NSPredicate predicateWithFormat:@"isLike = %ld", 1];
        //查询所有喜欢的歌曲
        dataArray = [PLLocalMusicInfo MR_findAllSortedBy:condition ascending:YES withPredicate:predicate];
    }
    
    return dataArray;
}

#pragma mark -----懒加载-----
- (NSMutableArray *)localMusicArray {
    if (_localMusicArray == nil) {
        _localMusicArray = [NSMutableArray array];
    }
    return _localMusicArray;
}

@end
