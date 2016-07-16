//
//  FQHMusicTool.m
//  QQMusic_FQH
//
//  Created by Mac on 16/7/2.
//  Copyright © 2016年 FQH. All rights reserved.
//

#import "FQHMusicTool.h"
#import "FQHMusic.h"
#import "MJExtension.h"//转换模型

@implementation FQHMusicTool

static NSArray *_musics ;
static FQHMusic *_playingMusic;
//第一次的时候加载
+(void)initialize
{
    if (_musics == nil) {
        //用数组将所有的音乐存起来
        _musics = [FQHMusic objectArrayWithFilename:@"Musics.plist"];
    }
    if (_playingMusic == nil) {
        //默认播放数组中的第几首音乐
        _playingMusic = _musics[0];
    }
}
//所有的音乐
+(NSArray *)musics
{
    return _musics;
}
//当前正在播放的音乐
+(FQHMusic *)playingMusic
{
    return _playingMusic;
}
//设置默认的音乐
+(void)setuoPlayingMusic:(FQHMusic *)playingMusic
{
    _playingMusic = playingMusic;
}

//获取上一首音乐
+(FQHMusic *)previousMusic
{
    //1.获取当前的音乐下标
    NSInteger currentIndex = [_musics indexOfObject:_playingMusic];
    
    //2.获取上一首的音乐下标
    NSInteger previousIndex = --currentIndex;
    //
    FQHMusic *previousMusic = nil;
    //第一首的上一首是最后一首
    if (previousIndex < 0) {
        previousIndex = _musics.count -1 ;
    }
    previousMusic = _musics[previousIndex];
    
    return previousMusic;
}

//获取下一首音乐
+(FQHMusic *)NextMusic
{
    //1.获取当前的音乐下标
    NSInteger currentIndex = [_musics indexOfObject:_playingMusic];
    
    //2.获取下一首的音乐下标
    NSInteger NextIndex = ++currentIndex;
    //
    FQHMusic *NextMusic = nil;
    //第一首的上一首是最后一首
    if (NextIndex >= _musics.count) {
        NextIndex = 0 ;
    }
    NextMusic = _musics[NextIndex];
    
    return NextMusic;

}












@end
