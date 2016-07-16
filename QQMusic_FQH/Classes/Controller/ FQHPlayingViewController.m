//
//  FQHPlayingViewController.m
//  QQMusic_FQH
//
//  Created by Mac on 16/7/2.
//  Copyright © 2016年 FQH. All rights reserved.
//

#import "FQHPlayingViewController.h"
#import "Masonry.h"//高斯模糊(毛玻璃效果)
#import "FQHMusic.h"
#import "FQHMusicTool.h"
#import "FQHAudioTool.h"
#import "NSString+FQHTimeExtension.h"
#import "CALayer+PauseAimate.h"
#import "FQHLrcView.h"
#import "FQHLrcView.h"
#import "FQHLrcLabel.h"
#import <MediaPlayer/MediaPlayer.h>

#define FQHbgColor(r,g,b,a) [UIColor colorWithRed:r/255.0 green:g/255.0 blue:b/255.0 alpha:a]

@interface FQHPlayingViewController ()<UITableViewDelegate>
/** 歌手背景图片*/
@property (weak, nonatomic) IBOutlet UIImageView *albumView;
/** 进度条*/
@property (weak, nonatomic) IBOutlet UISlider *progressSlider;
/** 歌手图片*/
@property (weak, nonatomic) IBOutlet UIImageView *iconView;
/** 歌曲名*/
@property (weak, nonatomic) IBOutlet UILabel *songLabel;
/** 歌手名*/
@property (weak, nonatomic) IBOutlet UILabel *singerLabel;
/** 当前的播放时间 */
@property (weak, nonatomic) IBOutlet UILabel *currentTimeLabel;
/** 歌曲的总时长*/
@property (weak, nonatomic) IBOutlet UILabel *totalTimeLabel;
/** 歌词的总时间*/
@property (weak, nonatomic) IBOutlet FQHLrcView *lrcView;

/** 显示歌词的label （一句的那个）*/
@property (weak, nonatomic) IBOutlet FQHLrcLabel *lrcLabel;

/** 进度条时间 －－定时器 */
@property(nonatomic,strong) NSTimer *progressTimer;

/** 歌词的定时器 */
@property(nonatomic,strong) CADisplayLink *lrcTimer ;

/** 播放和暂停*/
@property (weak, nonatomic) IBOutlet UIButton *playOrpauseBtn;

/** 播放器 */
@property(nonatomic,strong) AVAudioPlayer *currentPlayer;

#pragma mark - 进度条的事件处理
- (IBAction)start;
- (IBAction)end;
- (IBAction)progressValueChange;
- (IBAction)sliderClick:(UITapGestureRecognizer *)sender;
#pragma mark - 播放按钮处理
- (IBAction)playOrpause;
- (IBAction)Next;
- (IBAction)previous;

@end

@implementation FQHPlayingViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    //1.添加毛玻璃效果
    [self setupBlur];
    
    //2.改变滑块的图片（给滑块上能滑动的小圆点添加图片）
    [self.progressSlider setThumbImage:[UIImage imageNamed:@"player_slider_playback_thumb"] forState:UIControlStateNormal];
    //3.将lrcView 中的lecLabel设置为主控制器的lrcLabel
    self.lrcView.lrcLabel = self.lrcLabel;
    
    //4.开始播放音乐
    [self startPlayingMusic];
    
    //5.设置歌词ScrollView 的contentsize
    self.lrcView.contentSize = CGSizeMake(self.lrcView.bounds.size.width * 2, 0);
    
    //6.接受通知
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(addIconViewAnimate) name:@"FQHIconViewNOtification" object:nil];
    
    
    // Do any additional setup after loading the view.
}
#pragma mark - 开始播放音乐
-(void)startPlayingMusic
{
    //0.清除之前的歌词
    self.lrcLabel.text = nil;
    
    //1.获取当前正在播放的音乐
    FQHMusic *playingMusic = [FQHMusicTool playingMusic];
    
    //2.设置界面信息
    self.albumView.image = [UIImage imageNamed:playingMusic.icon];
    self.iconView.image = [UIImage imageNamed:playingMusic.icon];
    self.songLabel.text = playingMusic.name;
    self.singerLabel.text = playingMusic.singer;
    
    //3.播放音乐
    AVAudioPlayer *currentPlayer = [FQHAudioTool playMusicWithFileName:playingMusic.filename];
    self.currentTimeLabel.text = [NSString stringWithTime:currentPlayer.currentTime];//获取当前播放的时间
    self.totalTimeLabel.text = [NSString stringWithTime:currentPlayer.duration];//获取总时长
    self.currentPlayer = currentPlayer;
    
    //3.1设置播放按钮
    self.playOrpauseBtn.selected = self.currentPlayer.isPlaying;
    //3.2设置歌词
    self.lrcView.lrcName = playingMusic.lrcname;
    //3.3设置进度条的总时长
    self.lrcView.duration = currentPlayer.duration;
    
    //4.开启定时器
    [self removeProgressTimer];
    [self addProgressTimer];
    
    [self removeLrcTimer];
    [self addLrcTimer];
    
    //5.添加iconView 的动画
    [self addIconViewAnimate];
    
    //6.添加锁屏信息
//    [self setupLockScreenInfo];
    
    
}
#pragma mark - 添加iconView 的动画
-(void)addIconViewAnimate
{
    //添加基础动画
    CABasicAnimation *rotateAnimate = [CABasicAnimation animationWithKeyPath:@"transform.rotation.z"];
    //设置起始位置的角度
    rotateAnimate.fromValue = @(0);//起点
    rotateAnimate.toValue = @(M_PI * 2);//终点
    //设置转多少圈
    rotateAnimate.repeatCount = NSIntegerMax;//无限圈
    //设置转动的时间
    rotateAnimate.duration = 35;
    //将动画加入到iconView 中
    [self.iconView.layer addAnimation:rotateAnimate forKey:nil];
    NSLog(@"%s",__func__);
    
    //更新动画是否进入后台
    [[NSUserDefaults standardUserDefaults]setBool:NO forKey:@"iconViewAnimate"];
    [[NSUserDefaults standardUserDefaults]synchronize];
    

    
}
#pragma mark - 对歌词定时器的处理
-(void)addLrcTimer
{
    self.lrcTimer = [CADisplayLink displayLinkWithTarget:self selector:@selector(updateLrcInfo)];
    [self.lrcTimer addToRunLoop:[NSRunLoop mainRunLoop] forMode:NSRunLoopCommonModes];
    
}
-(void)removeLrcTimer
{
    //停止定时器
    [self.lrcTimer invalidate];
    //
    self.lrcTimer = nil;
}
#pragma mark - 更新歌词进度
-(void)updateLrcInfo
{
    //
    self.lrcView.currentTime = self.currentPlayer.currentTime;
}
#pragma mark - 对进度条时间的处理
//让时间实时更新
-(void)addProgressTimer
{
    //让进度条刚开始的时候默认在原处
    [self updateProgressInfo];
    self.progressTimer = [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(updateProgressInfo) userInfo:nil repeats:YES];
    [[NSRunLoop mainRunLoop] addTimer:self.progressTimer forMode:NSRunLoopCommonModes];
}
//删除进度条的值（重新加载新歌曲的进度）
-(void)removeProgressTimer
{
    [self.progressTimer invalidate];
    self.progressTimer = nil;
}
#pragma mark - 更新进度条
-(void)updateProgressInfo
{
    //1.更新播放时间
    self.currentTimeLabel.text = [NSString stringWithTime:self.currentPlayer.currentTime];
    //2.更新滑动条
    self.progressSlider.value = self.currentPlayer.currentTime/self.currentPlayer.duration;
}
#pragma mark - 添加毛玻璃效果
-(void)setupBlur
{
    //1.初始化toolBal
    UIToolbar *toolBar = [[UIToolbar alloc]init];
    [self.albumView addSubview:toolBar];
    //将高斯模糊改成黑色（默认是白色）
    toolBar.barStyle = UIBarStyleBlack;
    
    //2.添加约束
    toolBar.translatesAutoresizingMaskIntoConstraints = NO;
    //给背景图片添加毛玻璃效果
    [toolBar mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.albumView);
    }];
     
}
#pragma mark - 给歌手图片添加圆角效果
/** 
 * -(void)viewWillAppear:(BOOL)animated 第一出现
 * -(void)viewWillDisappear:(BOOL)animated 第二出现
 * -(void)viewWillLayoutSubviews 第三出现
 */
//布局子控件
-(void)viewWillLayoutSubviews
{
    [super viewWillLayoutSubviews];
    //给歌手图片添加圆角
    self.iconView.layer.cornerRadius = self.iconView.bounds.size.width*0.5;
    self.iconView.layer.masksToBounds = YES;
    //给歌手图片添加边框
    self.iconView.layer.borderColor = FQHbgColor(36, 36, 36, 1.0).CGColor;
    self.iconView.layer.borderWidth = 8.0;
    
}
#pragma mark - 进度条的事件处理
- (IBAction)start//touchDown(Action)
{
    //移除定时器
    [self removeProgressTimer];
}

- (IBAction)end//touchinside(Action)
{
    //1.更新播放的时间
    self.currentPlayer.currentTime = self.progressSlider.value * self.currentPlayer.duration;
    
    //2.添加定时器
    [self addProgressTimer];
    
}

- (IBAction)progressValueChange//ValueChange(Action)
{
    //更新当前的时间Label
    self.currentTimeLabel.text = [NSString stringWithTime:self.progressSlider.value*self.currentPlayer.duration];
}
//给滑块添加点击手势
- (IBAction)sliderClick:(UITapGestureRecognizer *)sender
{
    //1.获取点击到的点
    CGPoint point = [sender locationInView:sender.view];
    
    //2.获取点击的比列
    CGFloat ratio = point.x /self.progressSlider.bounds.size.width;
    
    //3.更新播放的时间
    self.currentPlayer.currentTime = self.currentPlayer.duration*ratio;
    
    //4.更新时间和滑块的位置
    [self updateProgressInfo];
}
#pragma mark - 播放点击处理
//暂停和播放
- (IBAction)playOrpause
{
    //
    self.playOrpauseBtn.selected = !self.playOrpauseBtn.selected;
    if (self.currentPlayer.playing) {
        //1.暂停播放器
        [self.currentPlayer pause];
        //2.移除定时器
        [self removeProgressTimer];
        //3.暂停旋转动画
        [self.iconView.layer pauseAnimate];
    }
    else
    {
        //1.开始播放
        [self.currentPlayer play];
        
        //2.添加定时器
        [self addProgressTimer];
        
        //3.恢复旋转动画
        [self.iconView.layer resumeAnimate];
        
    }
}
//播放下一首
- (IBAction)Next
{
    //1.获取当前播放的歌曲
    FQHMusic *currentMusic = [FQHMusicTool playingMusic];
    //2.停止当前播放的歌曲
    [FQHAudioTool stopMusicWithFileName:currentMusic.filename];
    //3.获取下一首歌
    FQHMusic *nextMusic = [FQHMusicTool NextMusic];
    //4.设置下一首歌为默认播放歌曲
    [FQHMusicTool setuoPlayingMusic:nextMusic];
    //5.播放音乐并更新界面信息
    [self startPlayingMusic];
}
//播放上一首
- (IBAction)previous
{
    //1.获取当前播放的歌曲
    FQHMusic *currentMusic = [FQHMusicTool playingMusic];
    //2.停止当前播放的歌曲
    [FQHAudioTool stopMusicWithFileName:currentMusic.filename];
    //3.获取上一首歌
    FQHMusic *previousMusic = [FQHMusicTool previousMusic];
    //4.设置上一首歌为默认播放歌曲
    [FQHMusicTool setuoPlayingMusic:previousMusic];
    //5.播放音乐并更新界面信息
    [self startPlayingMusic];

}
-(void)playMusicwithMusic:(FQHMusic *)music
{
    //1.获取当前播放的歌曲
    FQHMusic *currentMusic = [FQHMusicTool playingMusic];
    //2.停止当前播放的歌曲
    [FQHAudioTool stopMusicWithFileName:currentMusic.filename];
//    //3.获取上一首歌
//    FQHMusic *previousMusic = [FQHMusicTool previousMusic];
    //4.设置上一首歌为默认播放歌曲
    [FQHMusicTool setuoPlayingMusic:music];
    //5.播放音乐并更新界面信息
    [self startPlayingMusic];
}
#pragma mark - UIScrollViewDelegate(拉线的)
-(void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    //1.获取滑动的偏移量
    CGPoint point = scrollView.contentOffset;
    //2.获取滑动的比例
    CGFloat alpha = 1 - point.x /scrollView.bounds.size.width;
    //3.设置alpha
    self.iconView.alpha = alpha;
    self.lrcLabel.alpha = alpha;
}
/*
#pragma mark - 设置锁屏信息
-(void)setupLockScreenInfo
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
    MPMediaItemArtwork *artwork = [[MPMediaItemArtwork alloc]initWithImage:[UIImage imageNamed:playingMusic.icon]];
    [playingInfoDict setObject:artwork forKey:MPMediaItemPropertyArtwork];
    //2.4设置歌曲的总时长
    [playingInfoDict setObject:@(self.currentPlayer.duration) forKey:MPMediaItemPropertyPlaybackDuration];
    
    //将锁屏信息加入到锁屏中心
    playingInfoCenter.nowPlayingInfo = playingInfoDict;
    
    //3.开启远程交互
    [[UIApplication sharedApplication]beginReceivingRemoteControlEvents];
    
}*/
#pragma mark - 给锁屏信息添加点击功能(需要真机测试)
-(void)remoteControlReceivedWithEvent:(UIEvent *)event
{
    /** 
     UIEventSubtypeRemoteControlPlay                 = 100,
     UIEventSubtypeRemoteControlPause                = 101,
     UIEventSubtypeRemoteControlStop                 = 102,
     UIEventSubtypeRemoteControlTogglePlayPause      = 103,
     UIEventSubtypeRemoteControlNextTrack            = 104,
     UIEventSubtypeRemoteControlPreviousTrack        = 105,
     UIEventSubtypeRemoteControlBeginSeekingBackward = 106,
     UIEventSubtypeRemoteControlEndSeekingBackward   = 107,
     UIEventSubtypeRemoteControlBeginSeekingForward  = 108,
     UIEventSubtypeRemoteControlEndSeekingForward    = 109,
     */
    switch (event.subtype) {
        case UIEventSubtypeRemoteControlPlay:
            case UIEventSubtypeRemoteControlPause:
            [self playOrpause];
            break;
        case UIEventSubtypeRemoteControlNextTrack:
            [self Next];
            break;
        case UIEventSubtypeRemoteControlPreviousTrack:
            [self previous];
            break;
        default:
            break;
    }
}

#pragma mark - 改变状态栏的文字颜色
-(UIStatusBarStyle)preferredStatusBarStyle
{
    return UIStatusBarStyleLightContent;
}
#pragma mark - 移除通知
-(void)dealloc
{
    [[NSNotificationCenter defaultCenter]removeObserver:@"FQHIconViewNOtification"];
}
@end
