//
//  FQHAudioTool.h
//  音频播放
//
//  Created by Mac on 16/7/2.
//  Copyright © 2016年 FQH. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AVFoundation/AVFoundation.h>

@interface FQHAudioTool : NSObject
//播放音乐 fileName：音乐文件
+(AVAudioPlayer *)playMusicWithFileName:(NSString *)fileName;

//播放音乐 fileName：音乐文件
+(void)pauseMusicWithFileName:(NSString *)fileName;

//播放音乐 fileName：音乐文件
+(void)stopMusicWithFileName:(NSString *)fileName;

//音效播放 soundName:音效文件
+(void)playSoundWithSoundName:(NSString *)soundName ;
@end
