//
//  PLSkinCutViewController.m
//  GraduationProject
//
//  Created by qianfeng on 16/4/13.
//  Copyright (c) 2016年 qianfeng. All rights reserved.
//

#import "PLSkinCutViewController.h"
#import "PLBackgroundImageName.h"

#define PL_SCREEN_SIZE_HEIGHT ([UIScreen mainScreen].bounds.size.height - 114) / 4

@interface PLSkinCutViewController () {
    UIButton *_seaButton;
    UIButton *_lamnButton;
    UIButton *_leafButton;
    UIButton *_snowButton;
}

@end

@implementation PLSkinCutViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    //创建视图按钮
    [self createViewButton];
    
}


#pragma mark -----viewComtroller-----

- (void)createViewButton{
    //sea皮肤(默认)
    _seaButton = [self plCreateButtonWithFrame:CGRectMake(50, PL_SCREEN_SIZE_HEIGHT * 0 + 50, PL_SCREEN_SIZE_HEIGHT * 3 / 5, PL_SCREEN_SIZE_HEIGHT) andImageName:@"sea.jpg" andSEL:@selector(skinCutButtonAction:) andCornerRadius:0];
    [self.view addSubview:_seaButton];
    //sea文字
    UILabel *seaLabel = [self plCreateLabelWithText:@"海景" andFontSize:20 andTextColor:[UIColor blackColor] andFrame:CGRectMake(0, 0, 60, 20)];
    seaLabel.center = CGPointMake(_seaButton.center.x, PL_SCREEN_SIZE_HEIGHT * 1 + 70);
    [self.view addSubview:seaLabel];
    
    
    //lamn皮肤
    _lamnButton = [self plCreateButtonWithFrame:CGRectMake([UIScreen mainScreen].bounds.size.width - 50 - PL_SCREEN_SIZE_HEIGHT * 3 / 5, PL_SCREEN_SIZE_HEIGHT * 0 + 50, PL_SCREEN_SIZE_HEIGHT * 3 / 5, PL_SCREEN_SIZE_HEIGHT) andImageName:@"lamn.jpg" andSEL:@selector(skinCutButtonAction:) andCornerRadius:0];
    [self.view addSubview:_lamnButton];
    //lamn文字
    UILabel *lamnLabel = [self plCreateLabelWithText:@"草地" andFontSize:20 andTextColor:[UIColor blackColor] andFrame:CGRectMake(0, 0, 60, 20)];
    lamnLabel.center = CGPointMake(_lamnButton.center.x, PL_SCREEN_SIZE_HEIGHT * 1 + 70);
    [self.view addSubview:lamnLabel];
    
    
    //leaf皮肤
    _leafButton = [self plCreateButtonWithFrame:CGRectMake([UIScreen mainScreen].bounds.size.width - 50 - PL_SCREEN_SIZE_HEIGHT * 3 / 5, PL_SCREEN_SIZE_HEIGHT * 1 + 120, PL_SCREEN_SIZE_HEIGHT * 3 / 5, PL_SCREEN_SIZE_HEIGHT) andImageName:@"leaf.jpg" andSEL:@selector(skinCutButtonAction:) andCornerRadius:0];
    [self.view addSubview:_leafButton];
    //lamn文字
    UILabel *leafLabel = [self plCreateLabelWithText:@"树叶" andFontSize:20 andTextColor:[UIColor blackColor] andFrame:CGRectMake(0, 0, 60, 20)];
    leafLabel.center = CGPointMake(_leafButton.center.x, PL_SCREEN_SIZE_HEIGHT * 2 + 140);
    [self.view addSubview:leafLabel];
    
    
    //snow皮肤
    _snowButton = [self plCreateButtonWithFrame:CGRectMake(50, PL_SCREEN_SIZE_HEIGHT * 1 + 120, PL_SCREEN_SIZE_HEIGHT * 3 / 5, PL_SCREEN_SIZE_HEIGHT) andImageName:@"snow.jpg" andSEL:@selector(skinCutButtonAction:) andCornerRadius:0];
    [self.view addSubview:_snowButton];
    //snow文字
    UILabel *snowLabel = [self plCreateLabelWithText:@"雪景" andFontSize:20 andTextColor:[UIColor blackColor] andFrame:CGRectMake(0, 0, 60, 20)];
    snowLabel.center = CGPointMake(_snowButton.center.x, PL_SCREEN_SIZE_HEIGHT * 2 + 140);
    [self.view addSubview:snowLabel];
    
}

#pragma mark ----skinCutButton-----
- (void)skinCutButtonAction:(UIButton *)btn {
    NSString *tempName = nil;
    
    if (btn == _seaButton) {
        tempName = @"sea.jpg";
    } else if (btn == _leafButton) {
        tempName = @"leaf.jpg";
    } else if (btn == _lamnButton) {
        tempName = @"lamn.jpg";
    } else if (btn == _snowButton) {
        tempName = @"snow.jpg";
    }
    //点击按钮后弹出alert
    [self skinCutAlertWithImageName:tempName];
}


#pragma mark -----skinAlert-----
- (void)skinCutAlertWithImageName:(NSString *)name {
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"皮肤切换" message:@"点击'OK'切换皮肤" preferredStyle:UIAlertControllerStyleActionSheet];
    
    //添加取消按钮
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction *action) {
        //取消不做任何操作
    }];
    
    //添加确定按钮
    UIAlertAction *enterAction = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
        //点击确定按钮后换掉所有的皮肤
        //1.先将选择的皮肤保存在本地
        [self findAndChangeBackgroundImageWithName:name];
        
        //2.切换所有界面的皮肤
        NSArray *viewControllersArray = self.navigationController.viewControllers;
        
        //更换导航栏中所有视图的背景
        for (PLBaseViewController *baseViewController in viewControllersArray) {
            [baseViewController plSetBackgroundImage];
        }
    }];
    
    [alert addAction:cancelAction];
    [alert addAction:enterAction];
    
    [self presentViewController:alert animated:YES completion:nil];
}

#pragma mark ----数据库操作-----
- (void)findAndChangeBackgroundImageWithName:(NSString *)name {
    PLBackgroundImageName *plBackgroundImage = [PLBackgroundImageName MR_findFirst];
    plBackgroundImage.backgroundImageName = name;
    [[NSManagedObjectContext MR_defaultContext] MR_saveToPersistentStoreAndWait];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



@end
