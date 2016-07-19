//
//  PLStoreViewController.m
//  Graduation
//
//  Created by qianfeng on 16/4/28.
//  Copyright (c) 2016年 qianfeng. All rights reserved.
//

#import "PLStoreViewController.h"
#import "MusicCell.h"
#import "PLSearchViewController.h"

@interface PLStoreViewController () <UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout, UITextFieldDelegate> {
    UICollectionView *_collectionView;
    UITextField *_textField;
}

//分类数组
@property (nonatomic, strong) NSArray *musicClassifyArray;

@end

@implementation PLStoreViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self searchTextField:1];
    
    [self createUI];
}

#pragma mark --创建UI
- (void)createUI {
    //创建网格布局对象
    UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc] init];
    
    //创建网格对象
    _collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 60, PL_SCREEN_SIZE.width, PL_SCREEN_SIZE.height - 200) collectionViewLayout:flowLayout];
    
    //设置代理
    _collectionView.delegate = self;
    _collectionView.dataSource = self;
    
    //设置背景颜色
    _collectionView.backgroundColor = [UIColor clearColor];
    
    [self.view addSubview:_collectionView];
    
    //注册cell
    [_collectionView registerClass:[MusicCell class] forCellWithReuseIdentifier:@"musicCell"];
}

#pragma mark ---- 创建搜索栏 ----
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
    
    //右视图
    textField.rightView = [self plCreatViewWithFrame:CGRectMake(textField.bounds.size.width - 100, 10, 50 , 50) andAplha:1];
    UIButton *searchButton = [self plCreateButtonWithFrame:CGRectMake(5, 5, 40, 40) andImageName:@"set_search" andSEL:@selector(searchButtonAction) andCornerRadius:10];
    [textField.rightView addSubview:searchButton];
    textField.rightViewMode = UITextFieldViewModeWhileEditing;
    
    [self.view addSubview:textField];
}

- (void)searchButtonAction {
    //跳转到搜索界面
    PLSearchViewController *searchVC = [[PLSearchViewController alloc] init];
    searchVC.navigationItem.title = @"搜索";
    searchVC.plName = _textField.text;
    [self.navigationController pushViewController:searchVC animated:YES];
    
    //让键盘隐藏--》让文本框放弃第一响应者
    [_textField resignFirstResponder];
}

#pragma mark --实现代理方法
//确定item的个数
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.musicClassifyArray.count;
}

//创建cell
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    MusicCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"musicCell" forIndexPath:indexPath];
    
    cell.imageView.image = [UIImage imageNamed:[NSString stringWithFormat:@"%@.jpg",[self.musicClassifyArray objectAtIndex:indexPath.item]]];
    cell.titleLabel.text = [self.musicClassifyArray objectAtIndex:indexPath.item];
    
    return cell;
}

//设置item的大小
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    return CGSizeMake((PL_SCREEN_SIZE.width - 100) / 2, (PL_SCREEN_SIZE.width - 100) / 2);
}

//设置距离边界的距离
- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section {
    return UIEdgeInsetsMake(15, 30, 30, 30);
}

//实现collectionView切换的小动画
- (void)collectionView:(UICollectionView *)collectionView willDisplayCell:(UICollectionViewCell *)cell forItemAtIndexPath:(NSIndexPath *)indexPath {
    //给cell实现一个3D动画
    //设置x和y的初始值为0.1，z的初始值为1
    cell.layer.transform = CATransform3DMakeScale(0.1, 0.1, 1);
    
    [UIView animateWithDuration:1 animations:^{
        //设置x和y的最终值为1
        cell.layer.transform = CATransform3DMakeScale(1, 1, 1);
    }];
}

//选中方法
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    
    //即将跳转的界面
    PLSearchViewController *searchVC = [[PLSearchViewController alloc] init];
    //设置页面的标题
    searchVC.navigationItem.title = [self.musicClassifyArray objectAtIndex:indexPath.item];
    searchVC.plName = [self.musicClassifyArray objectAtIndex:indexPath.item];
    //推出界面
    [self.navigationController pushViewController:searchVC animated:YES];
}

#pragma mark ----懒加载----
- (NSArray *)musicClassifyArray {
    return  @[@"古风", @"爱情", @"影视原声", @"动漫插曲", @"纯音乐", @"ktv-伴奏", @"流行", @"经典"];
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

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
 #pragma mark - Navigation
 
 // In a storyboard-based application, you will often want to do a little preparation before navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
 // Get the new view controller using [segue destinationViewController].
 // Pass the selected object to the new view controller.
 }
 */

@end
