//
//  FQHMusicTool.h
//  QQMusic_FQH
//
//  Created by Mac on 16/7/2.
//  Copyright © 2016年 FQH. All rights reserved.
//

#import <Foundation/Foundation.h>
@class FQHMusic;
@interface FQHMusicTool : NSObject

//所有的音乐
+(NSArray *)musics;

//当前正在播放的音乐
+(FQHMusic *)playingMusic;

//设置默认的音乐
+(void)setuoPlayingMusic:(FQHMusic *)playingMusic ;

//获取上一首音乐
+(FQHMusic *)previousMusic;

//获取下一首音乐
+(FQHMusic *)NextMusic;
@end
