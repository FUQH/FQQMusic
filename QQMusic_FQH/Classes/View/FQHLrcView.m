//
//  FQHLrcView.m
//  QQMusic_FQH
//
//  Created by Mac on 16/7/4.
//  Copyright © 2016年 FQH. All rights reserved.
//

#import "FQHLrcView.h"
#import "Masonry.h"
#import "FQHLrcCell.h"
#import "FQHLrcLine.h"
#import "FQHLrcTool.h"
#import "FQHLrcLabel.h"
#import "FQHMusic.h"
#import "FQHMusicTool.h"
#import <MediaPlayer/MediaPlayer.h>

@interface FQHLrcView()<UITableViewDataSource>
/** tableView */
@property(nonatomic,weak)UITableView *tableView ;
/** 歌词数组 */
@property(nonatomic,strong) NSArray *lrcList;

/** 记录当前刷新的某行 */
@property(nonatomic,assign) NSInteger currentIndex ;

@end

@implementation FQHLrcView
-(instancetype)initWithCoder:(NSCoder *)aDecoder
{
    if (self = [super initWithCoder:aDecoder]) {
        //初始化TableView
        [self setupTablrView];
    }
    return self;
}
-(instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        //初始化TableView
        [self setupTablrView];
    }
    return self;
}
#pragma mark - 初始化TableView 
-(void)setupTablrView
{
    //1.初始化
    UITableView *tableView = [[UITableView alloc]init];
    [self addSubview:tableView];
    self.tableView = tableView ;
    tableView.dataSource = self;
}
#pragma mark - 添加布局
-(void)layoutSubviews
{
    [super layoutSubviews];
    //1.添加约束
    self.tableView.translatesAutoresizingMaskIntoConstraints = NO;
    //
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.mas_top);//顶部
        make.bottom.equalTo(self.mas_bottom);//底部
        make.height.equalTo(self.mas_height);//高
        make.right.equalTo(self.mas_right);//右
        make.left.equalTo(self.mas_left).offset(self.bounds.size.width);//左
        make.width.equalTo(self.mas_width);//宽
    }];
    
    //2.改变tableView 的属性
    self.tableView.backgroundColor = [UIColor clearColor];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;//cell之间没有分割线
    self.tableView.rowHeight = 40;//默认44
    self.tableView.contentInset = UIEdgeInsetsMake(self.tableView.bounds.size.height*0.5, 0,self.tableView.bounds.size.height*0.5, 0);//让cell的首行和最后一行能够移动到中间(好像是歌词的活动范围)
    /** */
    
    
}
#pragma mark - UITableView Delegate 数据源
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.lrcList.count;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    FQHLrcCell *cell = [FQHLrcCell lrcCellWithTableView:self.tableView];
    if (self.currentIndex == indexPath.row) {
        cell.lrcLbel.font = [UIFont systemFontOfSize:20];
    }
    else
    {
        cell.lrcLbel.font = [UIFont systemFontOfSize:14];
        cell.lrcLbel.progress = 0;
    }
    //1.取出数据模型
    FQHLrcLine *lrcLine = self.lrcList[indexPath.row];
    //2.设置数据
    cell.lrcLbel.text = lrcLine.text;
    
    return cell;
}

#pragma mark - 重写lrcName
-(void)setLrcName:(NSString *)lrcName
{
    //-1让tableView 滚到中间(让刚开始的时候第一句在中间显示)
    [self.tableView setContentOffset:CGPointMake(0, -self.tableView.bounds.size.height * 0.5) animated:NO];
    
    //0.将currentIndex设置为0
    self.currentIndex = 0;

    //1.记录歌词名
    _lrcName = [lrcName copy];
    
    //2.解析歌词
    self.lrcList = [FQHLrcTool lrcToolWithLrcName:lrcName];
    //2.1设置第一句歌词
    FQHLrcLine *firstLrcLine = self.lrcList[0];
    self.lrcLabel.text = firstLrcLine.text;
    
    
    //3.刷新表格
    [self.tableView reloadData];
    
    //让刚开始的时候第一句在中间显示
//    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
//        NSIndexPath *indexPath = [NSIndexPath indexPathForRow:0 inSection:0];
//        [self.tableView scrollToRowAtIndexPath:indexPath atScrollPosition:UITableViewScrollPositionTop animated:NO];
//    });
}
#pragma mark - 重写currentTimer set 方法
-(void)setCurrentTime:(NSTimeInterval)currentTime
{
    
    //1.记录当前的播放时间
    _currentTime = currentTime;
    
    //2.判断显示那句歌词
    NSInteger count = self.lrcList.count;
    for (NSInteger i = 0; i < count; i++) {
        //2.1取出当前的歌词
        FQHLrcLine *currentlrcLine = self.lrcList[i];
        
        //2.2取出下一句歌词
        NSInteger nextIndex = i + 1;
        FQHLrcLine *nextlrcLine = nil;
        if (nextIndex < count) {
            nextlrcLine = self.lrcList[nextIndex];
        }
        //2.3用当前播放器的时间，跟当前这句歌词的时间和下一句歌词的时间进行对比，如果大于等于当前的歌词的时间，并且小于小于下一歌词的时间，就显示当前歌词
        if (self.currentIndex != i && currentTime >= currentlrcLine.time&&currentTime < nextlrcLine.time) {
            //(1)将当前的这句歌词滚动到中间
            NSIndexPath *indexPath = [NSIndexPath indexPathForRow:i inSection:0];
            NSIndexPath *previousIndexPath = [NSIndexPath indexPathForRow:self.currentIndex inSection:0];
            
            //(2)记录当前的刷新的某行
            self.currentIndex = i ;
            
            //(3)刷新当前的这句歌词，并且刷新上一句歌词
            [self.tableView reloadRowsAtIndexPaths:@[indexPath,previousIndexPath] withRowAnimation:UITableViewRowAnimationNone];
            
            //(4)让当前的这句歌词滚动到中间
            [self.tableView scrollToRowAtIndexPath:indexPath atScrollPosition:UITableViewScrollPositionTop animated:YES];
            //5.设置主界面的歌词的文字
            self.lrcLabel.text = currentlrcLine.text;
            
            //6.生成锁屏图片
            [self genaratorLockImage];
        }
        if (self.currentIndex == i ) {//当前这句歌词
            
            //3.用当前播放器的时间减去当前歌词的时间除以（下一句歌词的时间 － 当前歌词的时间）
        
            CGFloat value = (currentTime - currentlrcLine.time)/(nextlrcLine.time - currentlrcLine.time);
            
            //4.设置当前歌词的播放进度
            NSIndexPath *indexPath = [NSIndexPath indexPathForRow:self.currentIndex inSection:0];
            FQHLrcCell *lrcCell = [self.tableView cellForRowAtIndexPath:indexPath];
            lrcCell.lrcLbel.progress = value;
            self.lrcLabel.progress = value;
        }
    }
}
#pragma mark - 生成锁屏信息
-(void)genaratorLockImage
{
    //1.获取当前音乐的图片
    FQHMusic *playingMusic = [FQHMusicTool playingMusic];
    UIImage *currentImage = [UIImage imageNamed:playingMusic.icon];
    
    //2.取出歌词
    //2.1取出当前的歌词
    FQHLrcLine *currentLrcLine = self.lrcList[self.currentIndex];
    //2.2取出上一句歌词
    NSInteger previousIndex = self.currentIndex - 1;
    FQHLrcLine *previousLrcLine = nil;
    if (previousIndex >= 0) {
        previousLrcLine = self.lrcList[previousIndex];
    }
    
    //2.3取出下一句歌词
    NSInteger nextIndex = self.currentIndex + 1;
    FQHLrcLine *nextlrcLine = nil;
    if (nextIndex < self.lrcList.count) {
        nextlrcLine = self.lrcList[nextIndex];
    }
    
    //3.生成水印图片
    //3.1获取上下文
    UIGraphicsBeginImageContext(currentImage.size);
    
    //3.2将图片画上去
    [currentImage drawInRect:CGRectMake(0, 0, currentImage.size.width, currentImage.size.height)];
    
    //3.3将文字画上去
    CGFloat titleH = 25 ;
    //让歌词居中
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc]init];
    paragraphStyle.alignment = NSTextAlignmentCenter;
    
    NSDictionary *attributes1 = @{NSFontAttributeName:[UIFont systemFontOfSize:14],NSForegroundColorAttributeName:[UIColor whiteColor],NSParagraphStyleAttributeName:paragraphStyle};
    //前一句歌词
    [previousLrcLine.text drawInRect:CGRectMake(0, currentImage.size.height - titleH*3, currentImage.size.width, titleH) withAttributes:attributes1];
    //后一句歌词
    [nextlrcLine.text drawInRect:CGRectMake(0, currentImage.size.height - titleH, currentImage.size.width, titleH) withAttributes:attributes1];
    //当前播放歌词
    NSDictionary *attributes2 = @{NSFontAttributeName:[UIFont systemFontOfSize:20],NSForegroundColorAttributeName:[UIColor cyanColor],NSParagraphStyleAttributeName:paragraphStyle};
    [currentLrcLine.text drawInRect:CGRectMake(0, currentImage.size.height - titleH*2, currentImage.size.width, titleH) withAttributes:attributes2];
    //3.4获取画好的图片
    UIImage *lockImage = UIGraphicsGetImageFromCurrentImageContext();
    
    //3.5关闭上下文
    UIGraphicsEndImageContext();
    
    //3.6设置锁屏界面的图片
    [self setupLockScreenInfoWithLockImage:lockImage];
    
}

#pragma mark - 设置锁屏信息
-(void)setupLockScreenInfoWithLockImage:(UIImage *)lockImage
{
    // MPMediaItemPropertyAlbumTitle
    // MPMediaItemPropertyAlbumTrackCount
    // MPMediaItemPropertyAlbumTrackNumber
    // MPMediaItemPropertyArtist
    // MPMediaItemPropertyArtwork
    // MPMediaItemPropertyComposer
    // MPMediaItemPropertyDiscCount
    // MPMediaItemPropertyDiscNumber
    // MPMediaItemPropertyGenre
    // MPMediaItemPropertyPersistentID
    // MPMediaItemPropertyPlaybackDuration
    // MPMediaItemPropertyTitle
    
    //0.获取当前播放的歌曲
    FQHMusic *playingMusic = [FQHMusicTool playingMusic];
    
    //1.获取锁屏中心
    MPNowPlayingInfoCenter *playingInfoCenter = [MPNowPlayingInfoCenter defaultCenter];
    
    //2.设置锁屏参数
    NSMutableDictionary *playingInfoDict = [NSMutableDictionary dictionary];
    //2.1设置歌曲名
    [playingInfoDict setObject:playingMusic.name forKey:MPMediaItemPropertyAlbumTitle];
    //2.2设置歌手名
    [playingInfoDict setObject:playingMusic.singer forKey:MPMediaItemPropertyArtist];
    //2.3设置封面的图片
    MPMediaItemArtwork *artwork = [[MPMediaItemArtwork alloc]initWithImage:lockImage];
    [playingInfoDict setObject:artwork forKey:MPMediaItemPropertyArtwork];
    //2.4设置歌曲的总时长
    [playingInfoDict setObject:@(self.duration) forKey:MPMediaItemPropertyPlaybackDuration];
    
    //2.5设置歌词当前的播放时间
    [playingInfoDict setObject:@(self.currentTime) forKey:MPNowPlayingInfoPropertyElapsedPlaybackTime];
    
    //将锁屏信息加入到锁屏中心
    playingInfoCenter.nowPlayingInfo = playingInfoDict;
    
    //3.开启远程交互
    [[UIApplication sharedApplication]beginReceivingRemoteControlEvents];
    
}










@end
