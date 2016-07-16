//
//  FQHMusic.h
//  QQMusic_FQH
//
//  Created by Mac on 16/7/2.
//  Copyright © 2016年 FQH. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface FQHMusic : NSObject
/** 歌名 */
@property(nonatomic,copy) NSString *name ;
/** 歌曲*/
@property(nonatomic,copy) NSString *filename ;
/** 歌词*/
@property(nonatomic,copy) NSString *lrcname ;
/** 歌手名*/
@property(nonatomic,copy) NSString *singer ;
/** 歌手图片*/
@property(nonatomic,copy) NSString *singerIcon ;
/** */
@property(nonatomic,copy) NSString *icon ;


@end
