//
//  FQHLrcLine.h
//  QQMusic_FQH
//
//  Created by Mac on 16/7/4.
//  Copyright © 2016年 FQH. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface FQHLrcLine : NSObject

/** 歌词 */
@property(nonatomic,copy) NSString *text ;
/** 每句歌词播放的时间 */
@property(nonatomic,assign) NSTimeInterval time ;

-(instancetype)initWithLrcLineString:(NSString *)lrcLineString;
+(instancetype)LrcLineString:(NSString *)lrcLineString;


@end
