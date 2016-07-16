//
//  FQHLrcCell.h
//  QQMusic_FQH
//
//  Created by Mac on 16/7/4.
//  Copyright © 2016年 FQH. All rights reserved.
//

#import <UIKit/UIKit.h>
@class FQHLrcLabel;
@interface FQHLrcCell : UITableViewCell
+(instancetype)lrcCellWithTableView:(UITableView *)tableView;
/** 歌词的label */
@property(nonatomic,weak) FQHLrcLabel *lrcLbel;

@end
