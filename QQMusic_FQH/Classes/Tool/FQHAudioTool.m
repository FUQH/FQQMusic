//
//  FQHAudioTool.m
//  音频播放
//
//  Created by Mac on 16/7/2.
//  Copyright © 2016年 FQH. All rights reserved.
//

#import "FQHAudioTool.h"

@implementation FQHAudioTool

static NSMutableDictionary *_soundIDs;
static NSMutableDictionary *_players;

#pragma mark - 初始化
+(void)initialize
{
    _soundIDs = [NSMutableDictionary dictionary];
    _players = [NSMutableDictionary dictionary];
}

#pragma mark - 音乐播放
+(AVAudioPlayer *)playMusicWithFileName:(NSString *)fileName
{
    //1.创建空的播放器
    AVAudioPlayer *player = nil;
    
    //2.从字典中取出播放器
    player = _players[fileName];
    
    //3.判断播放器是否为空
    if (player == nil) {
        //4.生成对应的音乐资源
        NSURL *fileurl = [[NSBundle mainBundle]URLForResource:fileName withExtension:nil];
        if(fileurl == nil)return nil;
        //5.创建对应的播放器
        player = [[AVAudioPlayer alloc]initWithContentsOfURL:fileurl error:nil];
        //6.保存到字典中
        [_players setObject:player forKey:fileName];
    }
    //7.准备播放
    [player prepareToPlay];
    
    //8.开始播放
    [player play];
    return player;
    
}
#pragma mark - 暂停音乐
+(void)pauseMusicWithFileName:(NSString *)fileName
{
    //1.从字典中取出播放
    AVAudioPlayer *player = _players[fileName];
    
    //2.暂停播放
    if (player) {
        [player pause];
    }
}
#pragma mark - 停止音乐
+(void)stopMusicWithFileName:(NSString *)fileName
{
    //1.从字典中取出播放
    AVAudioPlayer *player = _players[fileName];
    
    //2.停止音乐
    if (player) {
        [player stop];
        [_players removeObjectForKey:fileName];
        player = nil;
    }

}
#pragma mark - 音效播放
+(void)playSoundWithSoundName:(NSString *)soundName
{
    //1.创建soundID = 0
    SystemSoundID soundID = 0 ;
    
    //2.从字典中取出soundID
    soundID = [_soundIDs[soundName] unsignedIntValue];
    
    //3.判断soundID是否为0
    if (soundID == 0) {
        //3.1生成soundID
        CFURLRef url = (__bridge CFURLRef)[[NSBundle mainBundle]URLForResource:soundName withExtension:nil];
        if (url == nil)return;
        //
        AudioServicesCreateSystemSoundID(url, &soundID);
        
        //3.2将soudID 保存到字典中
        [_soundIDs setObject:@(soundID) forKey:soundName];
        
    }
    //4.播放音效
    AudioServicesPlaySystemSound(soundID);
    

}
@end
