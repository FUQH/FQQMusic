//
//  AppDelegate.m
//  QQMusic_FQH
//
//  Created by Mac on 16/7/2.
//  Copyright © 2016年 FQH. All rights reserved.
//

#import "AppDelegate.h"
#import <AVFoundation/AVFoundation.h>

@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    
    //1.获取音频会话
    AVAudioSession *session = [AVAudioSession sharedInstance];
    
    //2.设置为后台类型
    [session setCategory:AVAudioSessionCategoryPlayback error:nil];
    
    //3.激活会话
    [session setActive:YES error:nil];
    
    
    
    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}
/** 
 * 第一次运行调用(BecomeActive) -> 后台(EnterBackground) ->前台(EnterForeground) -> BecomeActive
 */
//后台
- (void)applicationDidEnterBackground:(UIApplication *)application {
    NSLog(@"%s",__func__);
    //定义一个bool值来监听是否调用动画
    [[NSUserDefaults standardUserDefaults]setBool:YES forKey:@"iconViewAnimate"];
    [[NSUserDefaults standardUserDefaults]synchronize];

}
//前台
- (void)applicationWillEnterForeground:(UIApplication *)application {
    NSLog(@"%s",__func__);

}
//第一次运行进入
- (void)applicationDidBecomeActive:(UIApplication *)application
{
    NSLog(@"%s",__func__);
    if (![[NSUserDefaults standardUserDefaults] boolForKey:@"iconViewAnimate"]) {
        return;
    }
    
    //
    [[NSNotificationCenter defaultCenter] postNotificationName:@"FQHIconViewNOtification" object:nil];
    
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

@end
