//
//  FQHLrcTool.m
//  QQMusic_FQH
//
//  Created by Mac on 16/7/4.
//  Copyright © 2016年 FQH. All rights reserved.
//

#import "FQHLrcTool.h"
#import "FQHLrcLine.h"

@implementation FQHLrcTool
+(NSArray *)lrcToolWithLrcName:(NSString *)lrcName
{
    //1.获取路径
    NSString *path = [[NSBundle mainBundle]pathForResource:lrcName ofType:nil];
    
    //2.获取歌词
    NSString *lrcString = [NSString stringWithContentsOfFile:path encoding:NSUTF8StringEncoding error:nil];
    //3.转化成歌词数组
    NSArray *lrcArray = [lrcString componentsSeparatedByString:@"\n"];
    NSMutableArray *tempArray = [NSMutableArray array];
    for(NSString *lrcLineString in lrcArray)
    {
        /** 
         [ti:简单爱]
         [ar:周杰伦]
         [al:范特西]
         */
        
        //4.过滤不需要的字符串
        if ([lrcLineString hasPrefix:@"[ti:"]||[lrcLineString hasPrefix:@"[ar:"]||[lrcLineString hasPrefix:@"[al:"]||![lrcLineString hasPrefix:@"["]) {
            continue;
        }
        //5.将歌词转化为模型
        FQHLrcLine *lrcLine = [FQHLrcLine LrcLineString:lrcLineString];
        [tempArray addObject:lrcLine];
    }
   
    return tempArray;
}

@end