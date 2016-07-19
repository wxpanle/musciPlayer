//
//  PLNetinterface.h
//  biyesheji
//
//  Created by qianfeng on 16/4/8.
//  Copyright (c) 2016年 qianfeng. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface PLNetinterface : NSObject

//4个block负责请求事件
@property (nonatomic, copy) void (^musicQueryBlock)(NSArray *);
@property (nonatomic, copy) void (^musicPlayBlock)(NSDictionary *);
@property (nonatomic, copy) void (^musicSingerBlock)(NSDictionary *);
@property (nonatomic, copy) void (^musicLyricsBlock)(NSDictionary *);
@property (nonatomic, copy) void (^refreshPause)();

//总页数
@property (nonatomic, assign) NSInteger totalPage;

/**
 获取一个PLNetinterface的单例
 */
+ (instancetype)plGetSimpleOfNetinterfaceAddress;

/**
 获取音乐资源
 */
- (void)plRequestMusicQueryWithName:(NSString *)musicName andSize:(NSInteger)musicSize andPage:(NSInteger)musicPage;

/**
 获取音乐播放的地址
 */
- (void)plRequestMusicPlayInfoWithHash:(NSString *)musicHash;

/**
 获取歌手的相关信息
 */
- (void)plRequestMusicQueryWithSingerName:(NSString *)singerName;

/**
 获取歌词的相关信息
 */
- (void)plRequestMusicQueryWithMusicName:(NSString *)musicName andHash:(NSString *)musicHash andTime:(NSNumber *)musicTime;





@end
