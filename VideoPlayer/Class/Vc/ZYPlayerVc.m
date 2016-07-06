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
@property (weak, nonatomic) IBOutlet ZYPlayerView *playerView;

@property (nonatomic, strong) AVPlayer *player;

@property (nonatomic, strong) AVPlayerItem *playerItem;

@property (nonatomic, weak) id<ZYTransport>transport;

@end

@implementation ZYPlayerVc

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    
    NSURL *url = [NSURL URLWithString:@"http://www.jxvdy.com/file/upload/201405/05/18-24-58-42-627.mp4"];
    self.playerItem = [[AVPlayerItem alloc] initWithURL:url];
    
    //监听status属性
    [self.playerItem addObserver:self forKeyPath:@"status" options:NSKeyValueObservingOptionNew context:nil];
    
    [self.playerItem addObserver:self forKeyPath:@"loadedTimeRanges" options:NSKeyValueObservingOptionNew context:nil];
    
    self.player = [[AVPlayer alloc] initWithPlayerItem:self.playerItem];
    
    self.playerView.player = self.player;
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(moviePlayDidEnd:) name:AVPlayerItemDidPlayToEndTimeNotification object:nil];
    
}
- (IBAction)clickPlayBtn:(id)sender {
    [self.playerView.player play];
}

- (void)moviePlayDidEnd:(NSNotification *)note
{
    
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
            NSLog(@"1111111");
        }
    }
    else if ([keyPath isEqualToString:@"loadedTimeRanges"])
    {
        
    }
    else
    {
        [super observeValueForKeyPath:keyPath ofObject:object change:change context:context];
    }
    
}

#pragma mark ----ZYTransportDelegate

- (void)play
{
    
}

- (void)pause
{
    
}

- (void)stop
{
    
}

/**
 *  跳转到某个时间点播放
 *
 */
- (void)jumpedToTime:(NSTimeInterval)time
{
    
}



- (void)dealloc
{
    [self.playerItem removeObserver:self forKeyPath:@"status"];
    [self.playerItem removeObserver:self forKeyPath:@"loadedTimeRanges"];
    
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

@end
