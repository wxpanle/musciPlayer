//
//  PLNetMusicInfo.m
//  Graduation
//
//  Created by qianfeng on 16/4/20.
//  Copyright (c) 2016年 qianfeng. All rights reserved.
//

#import "PLNetMusicInfo.h"

@implementation PLNetMusicInfo

- (void)setValue:(id)value forUndefinedKey:(NSString *)key {
    if ([key isEqualToString:@"hash"]) {
        [self setValue:value forKey:@"musicHash"];
    } else if ([key isEqualToString:@"album_name"]) {
        [self setValue:value forKey:@"albumName"];
    } else if ([key isEqualToString:@"singername"]) {
        [self setValue:value forKey:@"singerName"];
    } else if ([key isEqualToString:@"songname"]) {
        [self setValue:value forKey:@"songName"];
    } else if ([key isEqualToString:@"duration"]) {
        [self setValue:value forKey:@"musicDuration"];
    } else {
        
    }
}

- (NSString *)description {
    return [NSString stringWithFormat:@"%@ %@", self.singerName,  self.songName];
}

+ (PLNetMusicInfo *)plCreateAndBackNetMusicWithLocalMusic:(PLLocalMusicInfo *)localMusic {
    PLNetMusicInfo *netMusic = [[PLNetMusicInfo alloc] init];
    netMusic.singerName = localMusic.singerName;
    netMusic.songName = localMusic.songName;
    netMusic.singerImage = localMusic.singerImage;
    netMusic.songLyrics = localMusic.songLyrics;
    netMusic.albumName = localMusic.albumName;
    netMusic.isLike = localMusic.isLike;
    netMusic.musicDuration = localMusic.musicDuration;
    netMusic.musicHash = localMusic.musicHash;
    netMusic.isnew = localMusic.isnew;
    netMusic.musicPath = localMusic.musicPath;
    return netMusic;
}

@end
