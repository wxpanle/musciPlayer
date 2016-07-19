//
//  PLLocalMusicInfo.m
//  Graduation
//
//  Created by qianfeng on 16/4/27.
//  Copyright (c) 2016年 qianfeng. All rights reserved.
//

#import "PLLocalMusicInfo.h"


@implementation PLLocalMusicInfo

@dynamic albumName;
@dynamic isLike;
@dynamic isnew;
@dynamic musicDuration;
@dynamic musicHash;
@dynamic singerImage;
@dynamic singerName;
@dynamic songLyrics;
@dynamic songName;
@dynamic musicPath;

- (void)setValue:(id)value forUndefinedKey:(NSString *)key {
    if ([key isEqualToString:@"hash"]) {
        [self setValue:value forKey:@"musicHash"];
    }
}
@end
