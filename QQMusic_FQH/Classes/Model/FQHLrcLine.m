//
//  FQHLrcLine.m
//  QQMusic_FQH
//
//  Created by Mac on 16/7/4.
//  Copyright © 2016年 FQH. All rights reserved.
//

#import "FQHLrcLine.h"

@implementation FQHLrcLine
-(instancetype)initWithLrcLineString:(NSString *)lrcLineString
{
    if (self = [super init]) {
        //[00:50.74]牵着你的手 一阵莫名感动
        NSArray *lrcArray = [lrcLineString componentsSeparatedByString:@"]"];//将在这个符号之前的和后面的分开
        self.text = lrcArray[1];
        self.time = [self timeWithString:[lrcArray[0] substringFromIndex:1]];//从[后面之后的字符串改为时间
        
        
    }
    return self;
    
}
+(instancetype)LrcLineString:(NSString *)lrcLineString
{
    return [[self alloc] initWithLrcLineString:lrcLineString];
}
-(NSTimeInterval)timeWithString:(NSString *)timeString
{
    //00:50.74
    NSUInteger min = [[timeString componentsSeparatedByString:@":"][0] integerValue];//从下标0开始，到：之前
    NSInteger sec = [[timeString substringWithRange:NSMakeRange(3, 2)] integerValue];//从下标3开始的后两位
    NSInteger hs = [[timeString componentsSeparatedByString:@"."][1] integerValue];//点的下标为0，从下标为1的开始到最后
    return min * 60 + sec + hs * 0.01;
    
    
}
@end
