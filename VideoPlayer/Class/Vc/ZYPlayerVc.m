//
//  ZYPlayerVc.m
//  AVPlayDemo
//
//  Created by 王志盼 on 16/6/30.
//  Copyright © 2016年 王志盼. All rights reserved.
//

#import "ZYPlayerVc.h"
#import "ZYPlayerView.h"
#import <AVFoundation/AVFoundation.h>
#import "ZYTransport.h"

@interface ZYPlayerVc () <ZYTransportDelegate>
@property (strong, nonatomic) ZYPlayerView *playerView;

@property (nonatomic, strong) AVPlayer *player;

@property (nonatomic, strong) AVPlayerItem *playerItem;

@property (nonatomic, weak) id<ZYTransport>transport;

@property (nonatomic, assign) CGFloat scale;

/**
 *  是否获取了视频长度
 */
@property (nonatomic, assign) BOOL isFetchTotalDuration;
@end

@implementation ZYPlayerVc

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    self.isFetchTotalDuration = NO;
    
    NSURL *url = [NSURL URLWithString:@"http://v.jxvdy.com/sendfile/w5bgP3A8JgiQQo5l0hvoNGE2H16WbN09X-ONHPq3P3C1BISgf7C-qVs6_c8oaw3zKScO78I--b0BGFBRxlpw13sf2e54QA"];
    self.playerItem = [[AVPlayerItem alloc] initWithURL:url];
    
    //监听status属性
    [self.playerItem addObserver:self forKeyPath:@"status" options:NSKeyValueObservingOptionNew context:nil];
    
    [self.playerItem addObserver:self forKeyPath:@"loadedTimeRanges" options:NSKeyValueObservingOptionNew context:nil];
    
    self.player = [[AVPlayer alloc] initWithPlayerItem:self.playerItem];
    
    self.playerView.player = self.player;
    self.playerView.frame = CGRectMake(0, 30, kScreenW, kScreenW * kScreenW / kScreenH);
    self.scale = kScreenW / self.playerView.height;
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(moviePlayDidEnd:) name:AVPlayerItemDidPlayToEndTimeNotification object:nil];
    
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [[UIApplication sharedApplication] setStatusBarHidden:YES];
}

- (ZYPlayerView *)playerView
{
    if (_playerView == nil)
    {
        _playerView = [[ZYPlayerView alloc] init];
        _playerView.backgroundColor = [UIColor blackColor];
        self.transport = _playerView.transport;
        self.transport.isBuffering = YES;
        self.transport.delegate = self;
        [self.view addSubview:_playerView];
    }
    return _playerView;
}

- (void)moviePlayDidEnd:(NSNotification *)note
{
    self.isFetchTotalDuration = NO;
}

//kvo
- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSString *,id> *)change context:(void *)context
{
    AVPlayerItem *item = (AVPlayerItem *)object;
    
    if ([keyPath isEqualToString:@"status"])
    {
        NSLog(@"%d", (int)[item status]);
        if ([item status] == AVPlayerStatusReadyToPlay)
        {
            
            if (!self.isFetchTotalDuration)
            {
                //获取视频总长度
                NSTimeInterval totalDuration = CMTimeGetSeconds(item.duration);
                self.transport.durationTime = totalDuration;
                self.isFetchTotalDuration = YES;
            }
            
        }
    }
    else if ([keyPath isEqualToString:@"loadedTimeRanges"])    //缓冲
    {
        self.transport.isBuffering = NO;
    }
    else
    {
        [super observeValueForKeyPath:keyPath ofObject:object change:change context:context];
    }
    
}

#pragma mark ----ZYTransportDelegate

- (void)play
{
    [self.playerView.player play];
}

- (void)pause
{
    [self.playerView.player pause];
}

- (void)stop
{
    self.isFetchTotalDuration = NO;
    [self.player setRate:0];
}

/**
 *  跳转到某个时间点播放
 *
 */
- (void)jumpedToTime:(NSTimeInterval)time
{
    
}

/**
 *  视频横竖屏
 *
 *  @param flag YES为是
 */
- (void)fullScreenOrNormalSizeWithFlag:(BOOL)flag
{
    
    if (flag)
    {
        CGFloat moveY = self.view.center.y - self.playerView.center.y;
        CGAffineTransform tmpTransform = CGAffineTransformScale(CGAffineTransformMakeTranslation(0, moveY), self.scale, self.scale);
        CGAffineTransform transform = CGAffineTransformRotate(tmpTransform, - M_PI_2);
        
        [UIView animateWithDuration:0.25 animations:^{
            self.playerView.transform = transform;
        }];
    }
    else
    {
        [UIView animateWithDuration:0.25 animations:^{
            self.playerView.transform = CGAffineTransformIdentity;
        }];
    }
}


- (void)dealloc
{
    [self.playerItem removeObserver:self forKeyPath:@"status"];
    [self.playerItem removeObserver:self forKeyPath:@"loadedTimeRanges"];
    
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

@end
