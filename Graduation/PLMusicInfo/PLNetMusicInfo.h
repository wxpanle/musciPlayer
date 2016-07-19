//
//  PLNetMusicInfo.h
//  Graduation
//
//  Created by qianfeng on 16/4/20.
//  Copyright (c) 2016年 qianfeng. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "PLLocalMusicInfo.h"

@interface PLNetMusicInfo : NSObject

@property (nonatomic, copy) NSString *albumName;
@property (nonatomic, assign) NSNumber *isLike;
@property (nonatomic, copy) NSString *singerImage;
@property (nonatomic, copy) NSString *singerName;
@property (nonatomic, copy) NSString *songLyrics;
@property (nonatomic, copy) NSString *songName;
@property (nonatomic, copy) NSString *musicHash;
@property (nonatomic, assign) NSNumber *musicDuration;
@property (nonatomic, assign) NSNumber *isnew;
@property (nonatomic, copy) NSString *musicPath;

+ (PLNetMusicInfo *)plCreateAndBackNetMusicWithLocalMusic:(PLLocalMusicInfo *)localMusic;

// {
//    "album_name" = "\U5fae\U7b11pasta \U7535\U89c6\U5267\U539f\U58f0\U5e26";
//    bitrate = 128;
//    duration = 285;
//    extname = mp3;
//    filename = "\U738b\U5fc3\U51cc - \U9ec4\U660f\U6653\U3010\U300a\U5fae\U7b11pasta\U300b \U7535\U89c6\U5267\U539f\U58f0\U5e26\U3011";
//    filesize = 4573274;
//    hash = 1757e8c176242fb079ed9a3e7795bed2;
//    isnew = 0;
//    m4afilesize = 1193667;
//    othername = "";
//    singername = "\U738b\U5fc3\U51cc";
//    songname = "\U9ec4\U660f\U6653";
//}
@end
