//
//  NSString+FQHTimeExtension.h
//  QQMusic_FQH
//
//  Created by Mac on 16/7/2.
//  Copyright © 2016年 FQH. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSString (FQHTimeExtension)
//将时间转换成字符串
+(NSString *)stringWithTime:(NSTimeInterval)time;
@end
