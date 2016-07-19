//
//  PLNetinterface.m
//  biyesheji
//
//  Created by qianfeng on 16/4/8.
//  Copyright (c) 2016年 qianfeng. All rights reserved.
//

#import "PLNetinterface.h"

//API接口来自百度
#define PATH_MUSIC_QUERY @"http://apis.baidu.com/geekery/music/query"
#define PATH_MUSIC_PLAYINFO @"http://apis.baidu.com/geekery/music/playinfo"
#define PATH_MUSIC_PLAYSINGER @"http://apis.baidu.com/geekery/music/singer"
#define PATH_MUSIC_PLAYKRC @"http://apis.baidu.com/geekery/music/krc"

@interface PLNetinterface ()



@end

@implementation PLNetinterface


//获取单例
+ (instancetype)plGetSimpleOfNetinterfaceAddress {
    static PLNetinterface *plNetinterface = nil;
    if (plNetinterface == nil) {
        plNetinterface = [[PLNetinterface alloc] init];
    }
    return plNetinterface;
}


//获取音乐资源
- (void)plRequestMusicQueryWithName:(NSString *)musicName andSize:(NSInteger)musicSize andPage:(NSInteger)musicPage {

    if (self.totalPage == 0) {
        self.totalPage = 1;
    }
    
    if (musicPage > self.totalPage) {
        
        self.musicQueryBlock = nil;
        self.refreshPause();
        return;
    }
    
    //将歌曲名字转换为NSUTF8StringEncoding编码
    NSString *tempName = [musicName stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    
    NSString *urlStr = [NSString stringWithFormat:@"%@?s=%@&size=%ld&page=%ld", PATH_MUSIC_QUERY, tempName, musicSize, musicPage];
    
    NSURL *url = [NSURL URLWithString: urlStr];
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc]initWithURL: url cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval: 10];
    
    //设置请求的方式
    [request setHTTPMethod: @"GET"];
    //第一个参数为自己的API key
    [request addValue: @"05dccf1ca620690552557342e4c3b88e" forHTTPHeaderField: @"apikey"];
    
    [NSURLConnection sendAsynchronousRequest: request
                                       queue: [NSOperationQueue mainQueue]
                           completionHandler: ^(NSURLResponse *response, NSData *data, NSError *error){
                               
                               if (data == nil) {
                                   //
                                   return;
                               }
                               
                               __autoreleasing NSError *error1 = nil;
                               
                               //解析数据
                               NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:&error1];
                               
                               NSString *isSuccess = [dict objectForKey:@"msg"];
                               
                    
                               self.totalPage = [[[dict objectForKey:@"data"] objectForKey:@"total_page"] integerValue];
                               
                               if ([isSuccess isEqualToString:@"数据请求成功"]) {
                                   
                                   if (self.musicQueryBlock) {
                                       self.musicQueryBlock([[dict objectForKey:@"data"] objectForKey:@"data"]);
                                   }
                                   self.musicQueryBlock = nil;
                                   
                               } else {
                                   //停止下拉刷新
                                   self.refreshPause();
                                   self.musicQueryBlock = nil;
                               }
                           }];
}

//获取音乐播放的地址
- (void)plRequestMusicPlayInfoWithHash:(NSString *)musicHash {
    
    NSString *urlStr = [NSString stringWithFormat:@"%@?hash=%@", PATH_MUSIC_PLAYINFO, musicHash];
    
    NSURL *url = [NSURL URLWithString: urlStr];
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc]initWithURL: url cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval: 10];
    
    //设置请求的方式
    [request setHTTPMethod: @"GET"];
    //第一个参数为自己的API key
    [request addValue: @"05dccf1ca620690552557342e4c3b88e" forHTTPHeaderField: @"apikey"];
    [NSURLConnection sendAsynchronousRequest: request
                                       queue: [NSOperationQueue mainQueue]
                           completionHandler: ^(NSURLResponse *response, NSData *data, NSError *error){
                               
                               if (data == nil) {
                                   return;
                               }
                               
                               NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
                               
                               NSString *isSuccess = [dict objectForKey:@"msg"];
                               
                               if ([isSuccess isEqualToString:@"数据请求成功"]) {
                                   NSDictionary *dataDictory = [dict objectForKey:@"data"];
                                   
                                   if (self.musicPlayBlock) {
                                       self.musicPlayBlock(dataDictory);
                                   }
                                   
                                   self.musicPlayBlock = nil;
                               } else {
                                   self.musicPlayBlock = nil;
                               }
                           }];
}

//获取歌手的相关信息
- (void)plRequestMusicQueryWithSingerName:(NSString *)singerName {
    //将歌曲名字转换为NSUTF8StringEncoding编码
    NSString *tempName = [singerName stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    
    NSString *urlStr = [NSString stringWithFormat:@"%@?name=%@", PATH_MUSIC_PLAYSINGER, tempName];
    
    NSURL *url = [NSURL URLWithString: urlStr];
    
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc]initWithURL: url cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval: 10];
    
    //设置请求的方式
    [request setHTTPMethod: @"GET"];
    //第一个参数为自己的API key
    [request addValue: @"05dccf1ca620690552557342e4c3b88e" forHTTPHeaderField: @"apikey"];
    [NSURLConnection sendAsynchronousRequest: request
                                       queue: [NSOperationQueue mainQueue]
                           completionHandler: ^(NSURLResponse *response, NSData *data, NSError *error){
                               
                               if (data == nil) {
                                   return;
                               }
                               
                               NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
                               
                               NSString *isSuccess = [dict objectForKey:@"msg"];
                               
                               if ([isSuccess isEqualToString:@"数据请求成功"]) {
                                   NSDictionary *dataDictory = [dict objectForKey:@"data"];

                                   if (self.musicSingerBlock) {
                                       self.musicSingerBlock(dataDictory);
                                   }
                                   
                                   self.musicSingerBlock = nil;
                               } else {
                                   self.musicSingerBlock = nil;
                               }
                           }];
}

//获取歌词的相关信息
- (void)plRequestMusicQueryWithMusicName:(NSString *)musicName andHash:(NSString *)musicHash andTime:(NSNumber *)musicTime {
    //将歌曲名字转换为NSUTF8StringEncoding编码
    NSString *tempName = [musicName stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    
    NSString *urlStr = [NSString stringWithFormat:@"%@?name=%@&hash=%@&time=%@", PATH_MUSIC_PLAYKRC, tempName, musicHash, musicTime];
    
    NSURL *url = [NSURL URLWithString: urlStr];
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc]initWithURL: url cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval: 10];
    
    //设置请求的方式
    [request setHTTPMethod: @"GET"];
    //第一个参数为自己的API key
    [request addValue: @"05dccf1ca620690552557342e4c3b88e" forHTTPHeaderField: @"apikey"];
    [NSURLConnection sendAsynchronousRequest: request
                                       queue: [NSOperationQueue mainQueue]
                           completionHandler: ^(NSURLResponse *response, NSData *data, NSError *error){
                               
                               if (data == nil) {
                                   return;
                               }
                               
                               NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
                               
                               NSString *isSuccess = [dict objectForKey:@"msg"];
                               
                               if ([isSuccess isEqualToString:@"数据请求成功"]) {
                                   NSDictionary *dataDictory = [dict objectForKey:@"data"];
                                   
                                   //调用回调的block
                                   if (self.musicLyricsBlock) {
                                       self.musicLyricsBlock(dataDictory);
                                   }
                                   
                                   self.musicLyricsBlock = nil;
                               } else {
                                   self.musicLyricsBlock = nil;

                               }
                           }];
}


//请求失败提示
- (void)plRequestMusicIsFail {
    
}

@end
