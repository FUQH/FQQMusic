//
//  FQHLrcCell.m
//  QQMusic_FQH
//
//  Created by Mac on 16/7/4.
//  Copyright © 2016年 FQH. All rights reserved.
//

#import "FQHLrcCell.h"
#import "FQHLrcLabel.h"
#import "Masonry.h"

@implementation FQHLrcCell

+(instancetype)lrcCellWithTableView:(UITableView *)tableView
{
    static NSString *ID = @"cell";
    FQHLrcCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (cell == nil) {
        cell = [[FQHLrcCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:ID];
        
    }
    return cell;
}
-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        
        //初始化FQHLrcLabel
        FQHLrcLabel *lrcLabel = [[FQHLrcLabel alloc]init];
        [self.contentView addSubview:lrcLabel];
        self.lrcLbel = lrcLabel;
        
        //添加约束
        [lrcLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(self.contentView);
        }];
        
        //设置cell 被选中时的状态
        self.selectionStyle  = UITableViewCellSelectionStyleNone;
        self.backgroundColor = [UIColor clearColor];
        //设置cell字体颜色和字体大小
        self.lrcLbel.textColor = [UIColor whiteColor];
        self.lrcLbel.font = [UIFont systemFontOfSize:15];
        //让cell 的字体居中
        self.lrcLbel.textAlignment = NSTextAlignmentCenter;
    }
    return self;
}





- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
