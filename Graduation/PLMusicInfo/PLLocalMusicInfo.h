//
//  PLLocalMusicInfo.h
//  Graduation
//
//  Created by qianfeng on 16/4/27.
//  Copyright (c) 2016年 qianfeng. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface PLLocalMusicInfo : NSManagedObject

@property (nonatomic, retain) NSString * albumName;
@property (nonatomic, retain) NSNumber * isLike;
@property (nonatomic, retain) NSNumber * isnew;
@property (nonatomic, retain) NSNumber * musicDuration;
@property (nonatomic, retain) NSString * musicHash;
@property (nonatomic, retain) NSString * singerImage;
@property (nonatomic, retain) NSString * singerName;
@property (nonatomic, retain) NSString * songLyrics;
@property (nonatomic, retain) NSString * songName;
@property (nonatomic, retain) NSString * musicPath;

@end
