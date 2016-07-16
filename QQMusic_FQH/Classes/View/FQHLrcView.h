//
//  FQHLrcView.h
//  QQMusic_FQH
//
//  Created by Mac on 16/7/4.
//  Copyright © 2016年 FQH. All rights reserved.
//

#import <UIKit/UIKit.h>
@class FQHLrcLabel;
@interface FQHLrcView : UIScrollView
/** 歌词名*/
@property(nonatomic,copy) NSString *lrcName ;

/** 当前播放器播放的时间 */
@property(nonatomic,assign) NSTimeInterval currentTime ;
/** 主界面歌词的Label  */
@property(nonatomic,strong) FQHLrcLabel *lrcLabel;

/** 当前播放器总时间 */
@property(nonatomic,assign) NSTimeInterval duration ;

@end
