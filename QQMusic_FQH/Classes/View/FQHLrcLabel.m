//
//  FQHLrcLabel.m
//  QQMusic_FQH
//
//  Created by Mac on 16/7/5.
//  Copyright © 2016年 FQH. All rights reserved.
//

#import "FQHLrcLabel.h"

@implementation FQHLrcLabel
//
-(void)setProgress:(CGFloat)progress
{
    _progress = progress;
    //让代码能够调用－(void)drawRect:(CGRect)rect方法
    [self setNeedsDisplay];
}


//
-(void)drawRect:(CGRect)rect
{
    [super drawRect:rect];
    
    CGRect fillRect = CGRectMake(0, 0, self.bounds.size.width * self.progress, self.bounds.size.height);
    [[UIColor cyanColor]set];
    //填充所有
//    UIRectFill(fillRect);
    //
    UIRectFillUsingBlendMode(fillRect, kCGBlendModeSourceIn);
}


@end
