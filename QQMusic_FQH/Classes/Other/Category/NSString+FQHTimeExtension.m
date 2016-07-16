//
//  NSString+FQHTimeExtension.m
//  QQMusic_FQH
//
//  Created by Mac on 16/7/2.
//  Copyright © 2016年 FQH. All rights reserved.
//

#import "NSString+FQHTimeExtension.h"

@implementation NSString (FQHTimeExtension)
//将时间转换成字符串
+(NSString *)stringWithTime:(NSTimeInterval)time
{
    NSInteger min = time /60 ;
    NSInteger sec = (int)round(time)%60;
    return [NSString stringWithFormat:@"%02ld:%02ld",min,sec];
}
@end
