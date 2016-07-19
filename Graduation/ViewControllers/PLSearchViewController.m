//
//  PLSearchViewController.m
//  Graduation
//
//  Created by qianfeng on 16/4/26.
//  Copyright (c) 2016年 qianfeng. All rights reserved.
//

#import "PLSearchViewController.h"
#import "PLLocalSingleTableViewCell.h"
#import "PLLyricsViewController.h"
#import "MJRefresh.h"
#import "PLClassifyCell.h"

//typedef NS_ENUM(NSUInteger, refreshStatus) {
//    refreshStatusRefresh    = 0,    // 下拉刷新状态
//    refreshStatusLoadMore           // 上拉加载状态
//};

@interface PLSearchViewController () <UITableViewDataSource, UITableViewDelegate, UITextFieldDelegate> {
    UITableView *_tableView;
    UITextField *_textField;
    UISegmentedControl *_segVC;
    NSMutableArray *_localMusicArray;
}

//数据源数组
@property (nonatomic, strong) NSMutableArray *localMusicArray;

//乐库分段的标志
@property (nonatomic, assign) BOOL musicStoreClassFlag;

//请求的页数
@property (nonatomic, assign) NSInteger page;

//请求的状态
//@property (nonatomic, assign) refreshStatus status;

@end

@implementation PLSearchViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    //创建分段选择器
    [self createSegmentedControl];
    
    //创建tableView
    [self createTableView];
    
    
    //添加上拉加载更多的数据
    [self addUpRefreshMoreData];
    
    //添加上拉加载时失败的blcok
    [[PLNetinterface plGetSimpleOfNetinterfaceAddress] setRefreshPause:^{
        self.page--;
        [_tableView.footer endRefreshing];
    }];
    
    //加载一次数据
    [self initTableViewData];
    
    //添加长按手势
    [self addLongPressGestureRecognizer];
}


#pragma mark -----UISegmentedControl-----
//创建分段选择器
- (void)createSegmentedControl {
    
    //创建搜索栏视图
    UIView *view = [self plCreatViewWithFrame:CGRectMake(15, 65, PL_SCREEN_SIZE.width - 30, 30) andAplha:1];
    
    //创建搜索栏
    [self searchTextField:1];
    
    //创建分段选择器
    _segVC = [self plCreateSegmentControlWithFrame:CGRectMake(1, 1, PL_SCREEN_SIZE.width - 32, 28) andTitleArray:@[@"歌手", @"单曲"] andEnabledIndex:0 andSEL:@selector(segCAction)];

    [view addSubview:_segVC];
    [self.view addSubview:view];
}

#pragma mark ----分段选择器方法----
/**
 分段选择器方法
 */
- (void)segCAction {
    
    //重新排列数组中的数据,以一定的方式
    [_tableView reloadData];
}

#pragma mark -----tableView-----
//创建tableView
- (void)createTableView {
    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(10, 100, PL_SCREEN_SIZE.width - 20, PL_SCREEN_SIZE.height - 230) style:UITableViewStylePlain];
    _tableView.dataSource = self;
    _tableView.delegate = self;
    _tableView.tableFooterView = [[UIView alloc] init];
    _tableView.backgroundColor = [UIColor clearColor];
    _tableView.editing = NO;
    _tableView.userInteractionEnabled = YES;
    _tableView.showsVerticalScrollIndicator = NO;
    _tableView.separatorColor = [UIColor clearColor];
    [self.view addSubview:_tableView];
    [_tableView registerClass:[PLLocalSingleTableViewCell class] forCellReuseIdentifier:@"singleCell"];
    
}

#pragma mark -----datasource-----

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.localMusicArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    PLLocalSingleTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"singleCell" forIndexPath:indexPath];
    
    if (!cell) {
        cell = [[PLLocalSingleTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"singleCell"];
    }
    
    PLNetMusicInfo *plMusic = [self.localMusicArray objectAtIndex:indexPath.row];
    
    if (_segVC.selectedSegmentIndex == 0) {
        cell.titleText.text = [NSString stringWithFormat:@"%@ - %@", plMusic.singerName, plMusic.songName];
    } else if (_segVC.selectedSegmentIndex == 1){
        cell.titleText.text = [NSString stringWithFormat:@"%@ - %@", plMusic.songName, plMusic.singerName];
    }
    
    return cell;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {

    //下载操作
    if (editingStyle ==  UITableViewCellEditingStyleDelete) {
        ;
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    //点击之后 退出选中状态
    [_tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    //请求下载并播放音乐代码
    
    //如果当前正在播放音乐,暂停
    if (_toolBar.player) {
        [_toolBar.player pause];
        _toolBar.player = nil;
    }
    
    //重新为数组赋值
    [self.toolBar.plLocalMusicInfoArray removeAllObjects];
    [self.toolBar.plLocalMusicInfoArray addObjectsFromArray:_localMusicArray];
    
    //清除上一首歌的缓存
    if (self.toolBar.localOrNetMusic) {
        [self.toolBar plDeleteNetMusicToSaveSpace];
    }
    
    self.toolBar.plCurrentIndex = indexPath.row;   //播放选中的歌曲
    self.toolBar.localOrNetMusic = YES;
    self.toolBar.currentTime = 0;
    
    [self.toolBar setUpPlayer];
    
    PLLyricsViewController *lyricsVC = [[PLLyricsViewController alloc] init];
    lyricsVC.isLikeOrLoadButton = YES;
    [self.navigationController pushViewController:lyricsVC animated:YES];

}
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    
    return YES;
    
}


#pragma mark -----懒加载-----
- (NSMutableArray *)localMusicArray {
    if (_localMusicArray == nil) {
        _localMusicArray = [NSMutableArray array];
    }
    return _localMusicArray;
}


#pragma mark ----搜索栏-----
/**
 创建搜索栏
 */
- (void)searchTextField:(CGFloat)alpha {
    UITextField *textField = [[UITextField alloc] initWithFrame:CGRectMake(15, 5, PL_SCREEN_SIZE.width - 30, 50)];
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
    textField.rightView = [self plCreatViewWithFrame:CGRectMake(textField.bounds.size.width - 100, 10, 50 , 50) andAplha:1];
    UIButton *searchButton = [self plCreateButtonWithFrame:CGRectMake(5, 5, 40, 40) andImageName:@"set_search" andSEL:@selector(searchButtonAction) andCornerRadius:10];
    [textField.rightView addSubview:searchButton];
    textField.rightViewMode = UITextFieldViewModeWhileEditing;
    
    [self.view addSubview:textField];
}

/**
 更新数据
 */
- (void)searchButtonAction {
    
    //判定为重新加载歌曲数据
    [self.localMusicArray removeAllObjects];
    
    //重置页数
    _page = 1;
    
    self.plName = _textField.text;
    
    [_textField resignFirstResponder];
    
    if (self.plName.length != 0) {
        [self plSearchDataWithSingerNameOrSongNameOrClassName:self.plName];
    }
}

/**
 搜索资源
 */
- (void)plSearchDataWithSingerNameOrSongNameOrClassName:(NSString *)plName {
    
    //获取请求的单例
    PLNetinterface *netinterface = [PLNetinterface plGetSimpleOfNetinterfaceAddress];
    
    //判断搜索block是否被占用
    if (netinterface.musicQueryBlock == nil) {
        
        [netinterface setMusicQueryBlock:^(NSArray *dataArray) {
            
            for (NSDictionary *dict in dataArray) {
                
                PLNetMusicInfo *plMusic = [[PLNetMusicInfo alloc] init];
                
                [plMusic setValuesForKeysWithDictionary:dict];
                
                [self.localMusicArray addObject:plMusic];
            }
            
            
            //停止刷新
            [_tableView.footer endRefreshing];
            
            //刷新数据
            [_tableView reloadData];
            
        }];
        
        //请求音乐资源
        if (plName.length != 0 ) {
            [netinterface plRequestMusicQueryWithName:plName andSize:10 andPage:self.page];
        }
    }
}

#pragma mark ----上拉加载----
/**
 上拉加载的创建
 */
- (void)addUpRefreshMoreData {
    MJRefreshAutoNormalFooter *refreshFooter = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
        
        self.page++;
        
        if (self.plName.length != 0) {
            [self plSearchDataWithSingerNameOrSongNameOrClassName:self.plName];
        }
        
    }];
    
    _tableView.footer = refreshFooter;
}


#pragma mark ----加载数据----
- (void)initTableViewData {
    self.page = 1;
    if (self.plName.length != 0) {
        [self plSearchDataWithSingerNameOrSongNameOrClassName:self.plName];
    }
}


#pragma mark ----UITextDeledate-----
//是否开启输入模式
- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField {
    return YES;
}

//是否离开输入模式
- (BOOL)textFieldShouldEndEditing:(UITextField *)textField {
    
    [_textField resignFirstResponder];
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

#pragma mark ----长按手势----
- (void)addLongPressGestureRecognizer {
    UILongPressGestureRecognizer *longPressGestureRecognizer = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(plLongPressAction:)];
    
    longPressGestureRecognizer.minimumPressDuration = 2;
    
    [_tableView addGestureRecognizer:longPressGestureRecognizer];
}

- (void)plLongPressAction:(UILongPressGestureRecognizer *)longPressGestureRecognizer {
    if (self.localMusicArray.count == 0) {
        if (self.plName.length != 0) {
            [self plSearchDataWithSingerNameOrSongNameOrClassName:self.plName];
        }
    } else {
        return;
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
